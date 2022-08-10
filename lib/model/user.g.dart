// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    su_seq: json['su_seq'] as int,
    su_last_login: json['su_last_login'] as String,
    su_type: json['su_type'] as int,
    su_first_name: json['su_first_name'] as String,
    su_last_name: json['su_last_name'] as String,
    su_gender: json['su_gender'] as String,
    su_location: json['su_location'] as String,
    su_birth_date: json['su_birth_date'] as String,
    su_license_key: null,
    su_email: json['su_email'] as String,
    su_is_active: json['su_is_active'] as int,
    su_cr_dt: json['su_cr_dt'] != null
        ? DateTime.parse(json['su_cr_dt'] as String)
        : null,
    su_join_dt: json['su_join_dt'] != null
        ? DateTime.parse(json['su_join_dt'] as String)
        : null,
    su_nickname: json['su_nickname'] as String,
    su_phone_number: json['su_phone_number'] as String,
    su_sc_seq: json['su_sc_seq'] as int,
    sc_name: json['sc_name'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'su_seq': instance.su_seq,
  'su_last_login': instance.su_last_login,
  'su_type': instance.su_type,
  'su_first_name': instance.su_first_name,
  'su_last_name': instance.su_last_name,
  'su_gender': instance.su_gender,
  'su_location': instance.su_location,
  'su_license_key': instance.su_license_key,
  'su_birth_date': instance.su_birth_date,
  'su_email': instance.su_email,
  'su_is_active': instance.su_is_active,
  'su_cr_dt': instance.su_cr_dt?.toIso8601String(),
  'su_join_dt': instance.su_join_dt?.toIso8601String(),
  'su_nickname': instance.su_nickname,
  'su_phone_number': instance.su_phone_number,
  'su_sc_seq': instance.su_sc_seq,
  'sc_name': instance.sc_name,
};
