// Lean compiler output
// Module: RIINA.Domains.MobileOS
// Imports: Init RIINA.Domains.MobileOS.AnimationSystem RIINA.Domains.MobileOS.AppDistribution RIINA.Domains.MobileOS.ApplicationLifecycle RIINA.Domains.MobileOS.BiometricSystem RIINA.Domains.MobileOS.CameraAudioSystem RIINA.Domains.MobileOS.CellularStack RIINA.Domains.MobileOS.ComputerVision RIINA.Domains.MobileOS.ConcurrencyFramework RIINA.Domains.MobileOS.DataPersistence RIINA.Domains.MobileOS.EncryptionSystem RIINA.Domains.MobileOS.FileSystem RIINA.Domains.MobileOS.GraphicsEngine RIINA.Domains.MobileOS.LocationServices RIINA.Domains.MobileOS.MemoryManagement RIINA.Domains.MobileOS.MultiDeviceContinuity RIINA.Domains.MobileOS.NetworkSecurity RIINA.Domains.MobileOS.NetworkingStack RIINA.Domains.MobileOS.NotificationSystem RIINA.Domains.MobileOS.OnDeviceML RIINA.Domains.MobileOS.PowerManagement RIINA.Domains.MobileOS.SystemApps RIINA.Domains.MobileOS.SystemArchitecture RIINA.Domains.MobileOS.TouchGestureSystem RIINA.Domains.MobileOS.TrackingPrevention RIINA.Domains.MobileOS.UIComponents RIINA.Domains.MobileOS.VoiceAssistant RIINA.Domains.MobileOS.WirelessProtocols
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
lean_object* initialize_Init(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_AnimationSystem(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_AppDistribution(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_ApplicationLifecycle(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_BiometricSystem(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_CameraAudioSystem(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_CellularStack(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_ComputerVision(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_ConcurrencyFramework(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_DataPersistence(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_EncryptionSystem(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_FileSystem(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_GraphicsEngine(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_LocationServices(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_MemoryManagement(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_MultiDeviceContinuity(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_NetworkSecurity(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_NetworkingStack(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_NotificationSystem(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_OnDeviceML(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_PowerManagement(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_SystemApps(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_SystemArchitecture(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_TouchGestureSystem(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_TrackingPrevention(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_UIComponents(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_VoiceAssistant(uint8_t builtin, lean_object*);
lean_object* initialize_RIINA_Domains_MobileOS_WirelessProtocols(uint8_t builtin, lean_object*);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_RIINA_Domains_MobileOS(uint8_t builtin, lean_object* w) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_AnimationSystem(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_AppDistribution(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_ApplicationLifecycle(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_BiometricSystem(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_CameraAudioSystem(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_CellularStack(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_ComputerVision(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_ConcurrencyFramework(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_DataPersistence(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_EncryptionSystem(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_FileSystem(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_GraphicsEngine(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_LocationServices(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_MemoryManagement(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_MultiDeviceContinuity(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_NetworkSecurity(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_NetworkingStack(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_NotificationSystem(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_OnDeviceML(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_PowerManagement(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_SystemApps(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_SystemArchitecture(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_TouchGestureSystem(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_TrackingPrevention(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_UIComponents(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_VoiceAssistant(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_RIINA_Domains_MobileOS_WirelessProtocols(builtin, lean_io_mk_world());
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
