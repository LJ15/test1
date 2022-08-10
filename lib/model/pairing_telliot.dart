import 'package:json_annotation/json_annotation.dart';

part 'pairing_telliot.g.dart';

@JsonSerializable()
class PairingTelliot {
  int ph_seq;
  String ph_telliot_id;
  String ph_cr_dt;
  int ph_is_active;
  String ph_telliot_name;
  String ph_bt_mac;

  PairingTelliot(
      { this.ph_seq,
        this.ph_telliot_id,
        this.ph_cr_dt,
        this.ph_is_active,
        this.ph_telliot_name,
        this.ph_bt_mac});

  factory PairingTelliot.fromJson(Map<String, dynamic> json) =>
      _$PairingTelliotFromJson(json);

  Map<String, dynamic> toJson() => _$PairingTelliotToJson(this);
}
