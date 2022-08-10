part of 'pairing_telliot.dart';

PairingTelliot _$PairingTelliotFromJson(Map<String, dynamic> json) {
  return PairingTelliot(
    ph_seq: json['ph_seq'] as int,
    ph_telliot_id: json['ph_telliot_id'] as String,
    ph_cr_dt: json['ph_cr_dt'] as String,
    ph_is_active: json['ph_is_active'] as int,
    ph_telliot_name: json['ph_telliot_name'] as String,
    ph_bt_mac: json['ph_bt_mac'] as String,
  );
}

Map<String, dynamic> _$PairingTelliotToJson(PairingTelliot instance) =>
    <String, dynamic>{
      'ph_seq': instance.ph_seq,
      'ph_telliot_id': instance.ph_telliot_id,
      'ph_cr_dt': instance.ph_cr_dt,
      'ph_is_active': instance.ph_is_active,
      'ph_telliot_name': instance.ph_telliot_name,
      'ph_bt_mac': instance.ph_bt_mac,
    };
