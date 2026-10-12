import * as vscode from 'vscode';
import * as path from 'path';
import { spawn, ChildProcess } from 'child_process';

let lspProcess: ChildProcess | null = null;

export function activate(context: vscode.ExtensionContext) {
    console.log('RIINA Language extension activated');

    // Start LSP client
    startLspClient(context);

    // Register format command
    context.subscriptions.push(
        vscode.commands.registerCommand('riina.format', () => {
            const editor = vscode.window.activeTextEditor;
            if (editor && editor.document.languageId === 'riina') {
                formatDocument(editor);
            }
        })
    );
}

/**
 * The riinac binary to execute. Only the USER (global) value or the default is
 * honoured: a workspace or folder value comes from the opened repository's
 * .vscode/settings.json, and honouring it would let any cloned repository pick
 * the binary this extension spawns. (The setting is also declared
 * machine-scoped and restricted in package.json; this is defense in depth.)
 */
function riinacPath(): string {
    const inspected = vscode.workspace.getConfiguration('riina').inspect<string>('riinacPath');
    return inspected?.globalValue ?? inspected?.defaultValue ?? 'riinac';
}

function startLspClient(context: vscode.ExtensionContext) {
    // Never start a language server for an untrusted workspace.
    if (!vscode.workspace.isTrusted) {
        context.subscriptions.push(
            vscode.workspace.onDidGrantWorkspaceTrust(() => startLspClient(context))
        );
        return;
    }
    const riinacPath_ = riinacPath();

    try {
        lspProcess = spawn(riinacPath_, ['lsp'], {
            stdio: ['pipe', 'pipe', 'pipe'],
        });

        if (lspProcess.stderr) {
            lspProcess.stderr.on('data', (data: Buffer) => {
                console.error(`riina-lsp stderr: ${data}`);
            });
        }

        lspProcess.on('error', (err: Error) => {
            vscode.window.showWarningMessage(`RIINA LSP failed to start: ${err.message}. Install riinac and set riina.riinacPath.`);
        });

        lspProcess.on('exit', (code: number | null) => {
            console.log(`riina-lsp exited with code ${code}`);
        });

        // Simple LSP client over stdio
        if (lspProcess.stdin && lspProcess.stdout) {
            initializeLsp(lspProcess);
        }
    } catch (e) {
        console.error('Failed to start RIINA LSP:', e);
    }
}

function initializeLsp(proc: ChildProcess) {
    if (!proc.stdin || !proc.stdout) return;

    const initRequest = {
        jsonrpc: '2.0',
        id: 1,
        method: 'initialize',
        params: {
            capabilities: {},
            rootUri: vscode.workspace.workspaceFolders?.[0]?.uri.toString() || null,
        },
    };

    sendMessage(proc, initRequest);

    // Read responses
    let buffer = '';
    proc.stdout.on('data', (data: Buffer) => {
        buffer += data.toString();
        // Parse Content-Length framed messages
        while (true) {
            const headerEnd = buffer.indexOf('\r\n\r\n');
            if (headerEnd === -1) break;

            const header = buffer.substring(0, headerEnd);
            const match = header.match(/Content-Length: (\d+)/);
            if (!match) break;

            const contentLength = parseInt(match[1], 10);
            const bodyStart = headerEnd + 4;
            if (buffer.length < bodyStart + contentLength) break;

            const body = buffer.substring(bodyStart, bodyStart + contentLength);
            buffer = buffer.substring(bodyStart + contentLength);

            try {
                const msg = JSON.parse(body);
                handleMessage(msg);
            } catch (e) {
                console.error('Failed to parse LSP message:', e);
            }
        }
    });

    // Send initialized notification
    setTimeout(() => {
        sendMessage(proc, { jsonrpc: '2.0', method: 'initialized', params: {} });
    }, 100);
}

function sendMessage(proc: ChildProcess, msg: object) {
    if (!proc.stdin) return;
    const body = JSON.stringify(msg);
    const header = `Content-Length: ${Buffer.byteLength(body)}\r\n\r\n`;
    proc.stdin.write(header + body);
}

const diagnosticCollection = vscode.languages.createDiagnosticCollection('riina');

function handleMessage(msg: any) {
    if (msg.method === 'textDocument/publishDiagnostics') {
        const uri = vscode.Uri.parse(msg.params.uri);
        const diagnostics: vscode.Diagnostic[] = msg.params.diagnostics.map((d: any) => {
            const range = new vscode.Range(
                d.range.start.line, d.range.start.character,
                d.range.end.line, d.range.end.character
            );
            const severity = d.severity === 1
                ? vscode.DiagnosticSeverity.Error
                : vscode.DiagnosticSeverity.Warning;
            const diag = new vscode.Diagnostic(range, d.message, severity);
            diag.source = 'riina';
            return diag;
        });
        diagnosticCollection.set(uri, diagnostics);
    }
}

function formatDocument(editor: vscode.TextEditor) {
    if (!vscode.workspace.isTrusted) {
        vscode.window.showWarningMessage('RIINA: formatting runs riinac and is disabled in untrusted workspaces.');
        return;
    }
    const document = editor.document;
    const text = document.getText();

    const proc = spawn(riinacPath(), ['fmt', document.uri.fsPath]);
    let output = '';
    let error = '';

    if (proc.stdout) {
        proc.stdout.on('data', (data: Buffer) => { output += data; });
    }
    if (proc.stderr) {
        proc.stderr.on('data', (data: Buffer) => { error += data; });
    }
    proc.on('close', (code: number | null) => {
        if (code === 0 && output) {
            const fullRange = new vscode.Range(
                document.positionAt(0),
                document.positionAt(text.length)
            );
            editor.edit(editBuilder => {
                editBuilder.replace(fullRange, output);
            });
        } else if (error) {
            vscode.window.showErrorMessage(`RIINA format error: ${error}`);
        }
    });
}

export function deactivate() {
    if (lspProcess) {
        lspProcess.kill();
        lspProcess = null;
    }
    diagnosticCollection.dispose();
}
