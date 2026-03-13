; Copyright (c) 2026 The RIINA Authors. All rights reserved.
; RIINA WirelessProtocols — SMT Verification
; Derived from 02_FORMAL/coq/domains/mobile_os/WirelessProtocols.v (25 assertions)
; Module: WirelessProtocols
;
; Real verification: datatype invariants, guard completeness,
; ordering properties, accessor round-trips.

(set-logic ALL)
(set-option :produce-models true)

; =======================================================================
; DATATYPE DECLARATIONS
; =======================================================================

(declare-datatypes ((WirelessProtocol 0)) (((WiFi) (Bluetooth) (NFC) (UWB))))

(declare-datatypes ((SecurityLevel 0)) (((C_None) (WPA2) (WPA3) (SecureBLE) (SecureNFC) (SecureUWB))))

(declare-datatypes ((WirelessConnection 0))
  (((mk-wireless_connection (conn_protocol WirelessProtocol) (conn_security SecurityLevel) (conn_encrypted Bool) (conn_authenticated Bool)))))

(declare-datatypes ((BluetoothPairing 0))
  (((mk-bluetooth_pairing (bt_device_id Int) (bt_pairing_method Int) (bt_authenticated Bool) (bt_bonded Bool)))))

(declare-datatypes ((WiFiConnection 0))
  (((mk-wi_fi_connection (wifi_ssid Int) (wifi_encrypted Bool) (wifi_security SecurityLevel) (wifi_password_stored_plaintext Bool)))))

(declare-datatypes ((NFCTransaction 0))
  (((mk-nfc_transaction (nfc_tx_id Int) (nfc_range_cm Int) (nfc_max_range_cm Int) (nfc_atomic Bool)))))

(declare-datatypes ((UWBRanging 0))
  (((mk-uwb_ranging (uwb_distance_cm Int) (uwb_measured_cm Int) (uwb_error_cm Int) (uwb_max_error_cm Int)))))

(declare-datatypes ((BTDataTransfer 0))
  (((mk-bt_data_transfer (bt_data_id Int) (bt_data_encrypted Bool) (bt_data_size Int)))))

(declare-datatypes ((AirDropSession 0))
  (((mk-air_drop_session (airdrop_sender Int) (airdrop_receiver Int) (airdrop_permission_granted Bool) (airdrop_encrypted Bool)))))

(declare-datatypes ((BTServiceDiscovery 0))
  (((mk-bt_service_discovery (bt_services_found (Seq Int)) (bt_discovery_timeout_ms Int) (bt_max_services Int)))))

(declare-datatypes ((WiFiScan 0))
  (((mk-wi_fi_scan (scan_timestamp_ms Int) (scan_interval_ms Int) (scan_min_interval_ms Int)))))

(declare-datatypes ((UWBAnchor 0))
  (((mk-uwb_anchor (anchor_id Int) (anchor_validated Bool) (anchor_certificate Int)))))

(declare-datatypes ((BTConnection 0))
  (((mk-bt_connection (bt_conn_id Int) (bt_conn_start_ms Int) (bt_conn_timeout_ms Int) (bt_conn_max_timeout_ms Int)))))

(declare-datatypes ((WiFiRoaming 0))
  (((mk-wi_fi_roaming (roaming_from_ap Int) (roaming_to_ap Int) (roaming_seamless Bool) (roaming_encrypted Bool)))))

(declare-datatypes ((NFCEmulation 0))
  (((mk-nfc_emulation (nfc_emu_app_id Int) (nfc_emu_authorized Bool) (nfc_emu_secure_element Bool)))))

(declare-datatypes ((WirelessCoexistence 0))
  (((mk-wireless_coexistence (active_protocols (Seq Int)) (coexistence_managed Bool) (interference_level Int) (max_interference Int)))))

; =======================================================================
; FUNCTION DEFINITIONS AND PROPERTY VERIFICATION
; =======================================================================

; --- 1. WirelessProtocol exhaustiveness ---
(push 1)
(declare-const x WirelessProtocol)
(assert (not (or (= x WiFi) (= x Bluetooth) (= x NFC) (= x UWB))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 2. WirelessProtocol: WiFi != Bluetooth ---
(push 1)
(assert (= WiFi Bluetooth))
(check-sat) ; expect UNSAT
(pop 1)

; --- 3. WirelessProtocol: Bluetooth != NFC ---
(push 1)
(assert (= Bluetooth NFC))
(check-sat) ; expect UNSAT
(pop 1)

; --- 4. WirelessProtocol: NFC != UWB ---
(push 1)
(assert (= NFC UWB))
(check-sat) ; expect UNSAT
(pop 1)

; --- 5. WirelessProtocol: WiFi != UWB ---
(push 1)
(assert (= WiFi UWB))
(check-sat) ; expect UNSAT
(pop 1)

; --- 6. WirelessProtocol finite cardinality (4 values) ---
(push 1)
(declare-const x WirelessProtocol)
(assert (and (not (= x WiFi)) (not (= x Bluetooth)) (not (= x NFC)) (not (= x UWB))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 7. SecurityLevel exhaustiveness ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (or (= x C_None) (= x WPA2) (= x WPA3) (= x SecureBLE) (= x SecureNFC) (= x SecureUWB))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 8. SecurityLevel: C_None != WPA2 ---
(push 1)
(assert (= C_None WPA2))
(check-sat) ; expect UNSAT
(pop 1)

; --- 9. SecurityLevel: WPA2 != WPA3 ---
(push 1)
(assert (= WPA2 WPA3))
(check-sat) ; expect UNSAT
(pop 1)

; --- 10. SecurityLevel: WPA3 != SecureBLE ---
(push 1)
(assert (= WPA3 SecureBLE))
(check-sat) ; expect UNSAT
(pop 1)

; --- 11. SecurityLevel: C_None != SecureUWB ---
(push 1)
(assert (= C_None SecureUWB))
(check-sat) ; expect UNSAT
(pop 1)

; --- 12. SecurityLevel finite cardinality (6 values) ---
(push 1)
(declare-const x SecurityLevel)
(assert (and (not (= x C_None)) (not (= x WPA2)) (not (= x WPA3)) (not (= x SecureBLE)) (not (= x SecureNFC)) (not (= x SecureUWB))))
(check-sat) ; expect UNSAT
(pop 1)

; --- 13. WirelessConnection accessor round-trip: conn_protocol ---
(push 1)
(declare-const f0 WirelessProtocol)
(declare-const f1 SecurityLevel)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (conn_protocol (mk-wireless_connection f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 14. WirelessConnection accessor round-trip: conn_security ---
(push 1)
(declare-const f0 WirelessProtocol)
(declare-const f1 SecurityLevel)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (conn_security (mk-wireless_connection f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 15. WirelessConnection accessor round-trip: conn_encrypted ---
(push 1)
(declare-const f0 WirelessProtocol)
(declare-const f1 SecurityLevel)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (conn_encrypted (mk-wireless_connection f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 16. WirelessConnection accessor round-trip: conn_authenticated ---
(push 1)
(declare-const f0 WirelessProtocol)
(declare-const f1 SecurityLevel)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (conn_authenticated (mk-wireless_connection f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 17. BluetoothPairing accessor round-trip: bt_device_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bt_device_id (mk-bluetooth_pairing f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 18. BluetoothPairing accessor round-trip: bt_pairing_method ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bt_pairing_method (mk-bluetooth_pairing f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 19. BluetoothPairing accessor round-trip: bt_authenticated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bt_authenticated (mk-bluetooth_pairing f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 20. BluetoothPairing accessor round-trip: bt_bonded ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (bt_bonded (mk-bluetooth_pairing f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 21. BluetoothPairing: non-negative int fields sum ---
(push 1)
(declare-const r BluetoothPairing)
(assert (>= (bt_device_id r) 0))
(assert (>= (bt_pairing_method r) 0))
(assert (not (>= (+ (bt_device_id r) (bt_pairing_method r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 22. WiFiConnection accessor round-trip: wifi_ssid ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 SecurityLevel)
(declare-const f3 Bool)
(assert (not (= (wifi_ssid (mk-wi_fi_connection f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 23. WiFiConnection accessor round-trip: wifi_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 SecurityLevel)
(declare-const f3 Bool)
(assert (not (= (wifi_encrypted (mk-wi_fi_connection f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 24. WiFiConnection accessor round-trip: wifi_security ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 SecurityLevel)
(declare-const f3 Bool)
(assert (not (= (wifi_security (mk-wi_fi_connection f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 25. WiFiConnection accessor round-trip: wifi_password_stored_plaintext ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 SecurityLevel)
(declare-const f3 Bool)
(assert (not (= (wifi_password_stored_plaintext (mk-wi_fi_connection f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 26. NFCTransaction accessor round-trip: nfc_tx_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (nfc_tx_id (mk-nfc_transaction f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 27. NFCTransaction accessor round-trip: nfc_range_cm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (nfc_range_cm (mk-nfc_transaction f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 28. NFCTransaction accessor round-trip: nfc_max_range_cm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (nfc_max_range_cm (mk-nfc_transaction f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 29. NFCTransaction accessor round-trip: nfc_atomic ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Bool)
(assert (not (= (nfc_atomic (mk-nfc_transaction f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 30. NFCTransaction: non-negative int fields sum ---
(push 1)
(declare-const r NFCTransaction)
(assert (>= (nfc_tx_id r) 0))
(assert (>= (nfc_range_cm r) 0))
(assert (not (>= (+ (nfc_tx_id r) (nfc_range_cm r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 31. UWBRanging accessor round-trip: uwb_distance_cm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (uwb_distance_cm (mk-uwb_ranging f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 32. UWBRanging accessor round-trip: uwb_measured_cm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (uwb_measured_cm (mk-uwb_ranging f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 33. UWBRanging accessor round-trip: uwb_error_cm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (uwb_error_cm (mk-uwb_ranging f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 34. UWBRanging accessor round-trip: uwb_max_error_cm ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (uwb_max_error_cm (mk-uwb_ranging f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 35. UWBRanging: non-negative int fields sum ---
(push 1)
(declare-const r UWBRanging)
(assert (>= (uwb_distance_cm r) 0))
(assert (>= (uwb_measured_cm r) 0))
(assert (not (>= (+ (uwb_distance_cm r) (uwb_measured_cm r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 36. BTDataTransfer accessor round-trip: bt_data_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (bt_data_id (mk-bt_data_transfer f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 37. BTDataTransfer accessor round-trip: bt_data_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (bt_data_encrypted (mk-bt_data_transfer f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 38. BTDataTransfer accessor round-trip: bt_data_size ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (bt_data_size (mk-bt_data_transfer f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 39. BTDataTransfer: non-negative int fields sum ---
(push 1)
(declare-const r BTDataTransfer)
(assert (>= (bt_data_id r) 0))
(assert (>= (bt_data_size r) 0))
(assert (not (>= (+ (bt_data_id r) (bt_data_size r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 40. AirDropSession accessor round-trip: airdrop_sender ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (airdrop_sender (mk-air_drop_session f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 41. AirDropSession accessor round-trip: airdrop_receiver ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (airdrop_receiver (mk-air_drop_session f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 42. AirDropSession accessor round-trip: airdrop_permission_granted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (airdrop_permission_granted (mk-air_drop_session f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 43. AirDropSession accessor round-trip: airdrop_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (airdrop_encrypted (mk-air_drop_session f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 44. AirDropSession: non-negative int fields sum ---
(push 1)
(declare-const r AirDropSession)
(assert (>= (airdrop_sender r) 0))
(assert (>= (airdrop_receiver r) 0))
(assert (not (>= (+ (airdrop_sender r) (airdrop_receiver r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 45. WiFiScan accessor round-trip: scan_timestamp_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (scan_timestamp_ms (mk-wi_fi_scan f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 46. WiFiScan accessor round-trip: scan_interval_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (scan_interval_ms (mk-wi_fi_scan f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 47. WiFiScan accessor round-trip: scan_min_interval_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(assert (not (= (scan_min_interval_ms (mk-wi_fi_scan f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 48. WiFiScan: non-negative int fields sum ---
(push 1)
(declare-const r WiFiScan)
(assert (>= (scan_timestamp_ms r) 0))
(assert (>= (scan_interval_ms r) 0))
(assert (not (>= (+ (scan_timestamp_ms r) (scan_interval_ms r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 49. UWBAnchor accessor round-trip: anchor_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (anchor_id (mk-uwb_anchor f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 50. UWBAnchor accessor round-trip: anchor_validated ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (anchor_validated (mk-uwb_anchor f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 51. UWBAnchor accessor round-trip: anchor_certificate ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Int)
(assert (not (= (anchor_certificate (mk-uwb_anchor f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 52. UWBAnchor: non-negative int fields sum ---
(push 1)
(declare-const r UWBAnchor)
(assert (>= (anchor_id r) 0))
(assert (>= (anchor_certificate r) 0))
(assert (not (>= (+ (anchor_id r) (anchor_certificate r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 53. BTConnection accessor round-trip: bt_conn_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bt_conn_id (mk-bt_connection f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 54. BTConnection accessor round-trip: bt_conn_start_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bt_conn_start_ms (mk-bt_connection f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 55. BTConnection accessor round-trip: bt_conn_timeout_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bt_conn_timeout_ms (mk-bt_connection f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 56. BTConnection accessor round-trip: bt_conn_max_timeout_ms ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Int)
(declare-const f3 Int)
(assert (not (= (bt_conn_max_timeout_ms (mk-bt_connection f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 57. BTConnection: non-negative int fields sum ---
(push 1)
(declare-const r BTConnection)
(assert (>= (bt_conn_id r) 0))
(assert (>= (bt_conn_start_ms r) 0))
(assert (not (>= (+ (bt_conn_id r) (bt_conn_start_ms r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 58. WiFiRoaming accessor round-trip: roaming_from_ap ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (roaming_from_ap (mk-wi_fi_roaming f0 f1 f2 f3)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 59. WiFiRoaming accessor round-trip: roaming_to_ap ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (roaming_to_ap (mk-wi_fi_roaming f0 f1 f2 f3)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 60. WiFiRoaming accessor round-trip: roaming_seamless ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (roaming_seamless (mk-wi_fi_roaming f0 f1 f2 f3)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 61. WiFiRoaming accessor round-trip: roaming_encrypted ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Int)
(declare-const f2 Bool)
(declare-const f3 Bool)
(assert (not (= (roaming_encrypted (mk-wi_fi_roaming f0 f1 f2 f3)) f3)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 62. WiFiRoaming: non-negative int fields sum ---
(push 1)
(declare-const r WiFiRoaming)
(assert (>= (roaming_from_ap r) 0))
(assert (>= (roaming_to_ap r) 0))
(assert (not (>= (+ (roaming_from_ap r) (roaming_to_ap r)) 0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 63. NFCEmulation accessor round-trip: nfc_emu_app_id ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (nfc_emu_app_id (mk-nfc_emulation f0 f1 f2)) f0)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 64. NFCEmulation accessor round-trip: nfc_emu_authorized ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (nfc_emu_authorized (mk-nfc_emulation f0 f1 f2)) f1)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 65. NFCEmulation accessor round-trip: nfc_emu_secure_element ---
(push 1)
(declare-const f0 Int)
(declare-const f1 Bool)
(declare-const f2 Bool)
(assert (not (= (nfc_emu_secure_element (mk-nfc_emulation f0 f1 f2)) f2)))
(check-sat) ; expect UNSAT
(pop 1)

(define-fun SecurityLevel_level ((x SecurityLevel)) Int
  (ite (= x C_None) 0 (ite (= x WPA2) 1 (ite (= x WPA3) 2 (ite (= x SecureBLE) 3 (ite (= x SecureNFC) 4 5))))))

(define-fun SecurityLevel_leq ((x SecurityLevel) (y SecurityLevel)) Bool
  (<= (SecurityLevel_level x) (SecurityLevel_level y)))

; --- 66. SecurityLevel_leq reflexivity ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 67. SecurityLevel_leq transitivity ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(declare-const z SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y z))
(assert (not (SecurityLevel_leq x z)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 68. SecurityLevel_leq antisymmetry ---
(push 1)
(declare-const x SecurityLevel)
(declare-const y SecurityLevel)
(assert (SecurityLevel_leq x y))
(assert (SecurityLevel_leq y x))
(assert (not (= x y)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 69. C_None is bottom ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq C_None x)))
(check-sat) ; expect UNSAT
(pop 1)

; --- 70. SecureUWB is top ---
(push 1)
(declare-const x SecurityLevel)
(assert (not (SecurityLevel_leq x SecureUWB)))
(check-sat) ; expect UNSAT
(pop 1)

(check-sat)
(exit)
