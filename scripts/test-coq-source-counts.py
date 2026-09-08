#!/usr/bin/env python3
"""Negative controls for the documentation audit's proof-declaration scan."""

import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path

sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location('coq_counts', Path(__file__).with_name('coq-source-counts.py'))
scanner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(scanner)


class CoqSourceCounts(unittest.TestCase):
    def test_inline_declarations_and_nested_comments(self):
        source = '''(* comment *) Axiom p : False.
        Lemma q : False. Admitted.
        (* nested (* Axiom hidden : False. *) Abort. *)
        Definition message := "Axiom "" Admitted. """.
        Lemma r : False. Proof. admit. Abort.
        '''
        tokens = list(scanner.identifiers(source))
        for name in ['Axiom', 'Admitted', 'admit', 'Abort']:
            self.assertEqual(tokens.count(name), 1, name)

    def test_active_sources_and_missing_files(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            (root / '_CoqProject').write_text('-Q . RIINA\nactive.v\n', encoding='utf-8')
            (root / 'active.v').write_text('Lemma p : True. Admitted.', encoding='utf-8')
            (root / '_archive_deprecated').mkdir()
            (root / '_archive_deprecated/archive.v').write_text('Axiom hidden : False.', encoding='utf-8')
            self.assertEqual(scanner.count(root, {'Admitted', 'Axiom'}), 1)
            (root / 'unlisted.v').write_text('Axiom hidden : False.', encoding='utf-8')
            with self.assertRaisesRegex(ValueError, 'unlisted active'):
                scanner.count(root, {'Admitted', 'Axiom'})
            (root / 'unlisted.v').unlink()
            (root / 'active.v').unlink()
            with self.assertRaises(FileNotFoundError):
                scanner.count(root, {'Admitted'})
            (root / '_CoqProject').write_text('# empty\n', encoding='utf-8')
            with self.assertRaises(ValueError):
                scanner.count(root, {'Admitted'})


if __name__ == '__main__':
    unittest.main()
