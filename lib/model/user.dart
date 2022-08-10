import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int su_seq;
  String su_last_login;
  int su_type;
  String su_first_name;
  String su_last_name;
  String su_gender;
  String su_location;
  String su_license_key;
  String su_birth_date;
  String su_email;
  int su_is_active;
  DateTime su_cr_dt;
  DateTime su_join_dt;
  String su_nickname;
  String su_phone_number;
  int su_sc_seq;
  String sc_name;
  User({
    this.su_seq,
    this.su_last_login,
    this.su_type,
    this.su_first_name,
    this.su_last_name,
    this.su_gender,
    this.su_location,
    this.su_license_key,
    this.su_birth_date,
    this.su_email,
    this.su_is_active,
    this.su_cr_dt,
    this.su_join_dt,
    this.su_nickname,
    this.su_phone_number,
    this.su_sc_seq,
    this.sc_name,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
