import 'dart:convert';

import 'package:flutter/material.dart';
import 'common_api.dart';
import 'package:provider/provider.dart';
import '../model/pairing_telliot.dart';
import '../model/user.dart';
import '../state/auth_state.dart';

class UserAPI extends CommonAPI {
  UserAPI({BuildContext context, bool listen}): super(context, listen: listen);

  Future<User> getMe({int su_seq}) async {
    final response = await get('/user/myinfo/$su_seq', headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return User.fromJson(result);
  }

  /// 로그인 한다.
  /// checking 부분이 true일 경우 헤더에 저장할 쿠키를 생성하고, 해당 유저 정보를 반환한다.
  /// 이외에는 성공 여부 코드를 반환하여 에러 처리를 하도록 한다.
  Future<dynamic> signIn(
      {String username, String password, bool checking = false}) async {
    final response = await post('/user/signin', body: {
      if (username != null) 'username': username,
      if (password != null) 'password': password,
    }, headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    print("login!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    print(result);
    if (!checking && (result['code'] == 200 || result['code'] == 100) || result['code'] == 201) {
      String rawCookie = response.headers['set-cookie'];

      if (rawCookie != null && rawCookie.contains('sessionid')) {
        await context
            ?.read<AuthState>()
            .setToken(rawCookie.substring(rawCookie.indexOf('sessionid')));
      }
      return User.fromJson(result);
    }

    return result;
  }

  /// 닉네임 중복확인.
  Future<void> checkExsistNickname({String nickname}) async {
    final response = await get('/user/dupcheck/$nickname', headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result['code'] == -21) throw new ErrorDescription(result['msg']);
  }

  Future<void> signup() async {}

  /// 텔리엇을 연결한다.
  Future<Map<String, dynamic>> connectTelliot({int historySeq}) async {
    final response = await post('/pairing/telliot/connect', body: {
      if (historySeq != null) "ph_seq": historySeq,
    }, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// IOTED-API-036 텔리엇을 연결을 끊기
  Future<Map<String, dynamic>> disconnectTelliot({int historySeq}) async {
    final response = await post('/pairing/telliot/disconnect', body: {
      if (historySeq != null) "ph_seq": historySeq,
    }, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }


  /// 텔리엇의 챗봇 모드를 바꾼다.(한국어 모드, 영어 모드)
  Future<Map<String, dynamic>> updateTelliotMode(
      {String mode, String telliotId}) async {
    final response = await post(
      '/user/mode/update',
      body: {
        if (mode != null) "mode": mode,
      },
      headers: {
        "TELLIOT-ID": telliotId,
      }, params: {},
    );
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  /// 텔리엇의 현재 모드를 가져온다.
  Future<Map<String, String>> getTelliotMode({String telliotId}) async {
    final response = await get(
      '/user/mode/read',
      headers: {
        "TELLIOT-ID": telliotId,
      }, params: {},
    );

    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result['code'] != 200) {
      throw new ErrorDescription('사용되지 않는 텔리엇 id 입니다.');
    }

    return {
      "mode": result['mode'],
      "kor_voice": result['kor_voice'],
      "eng_voice": result['eng_voice']
    };
  }

  /// 비밀번호를 바꾼다.
  Future<void> changePassword({String password, String newPassword}) async {
    final response = await post('/user/changepw', body: {
      if (password != null) "password": password,
      if (newPassword != null) "new_password": newPassword,
    }, params: {}, headers: {});

    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result['code'] != 200) {
      throw new ErrorDescription(result['msg']);
    }
  }

  /// 유저의 정보를 변경한다.
  Future<void> updateInfo(
      {int su_seq,
        String firstName,
        String lastName,
        String gender,
        String birth,
        String location,
        String email,
        String nickname,
        String phone}) async {
    final response = await post('/user/myinfo/update', body: {
      'su_seq': su_seq,
      if (firstName != null) 'su_first_name': firstName,
      if (lastName != null) 'su_last_name': lastName,
      if (gender != null) 'su_gender': gender,
      if (birth != null) 'su_birth_date': birth,
      if (location != null) 'su_location': location,
      if (email != null) 'su_email': email,
      if (nickname != null) 'su_nickname': nickname,
      if (phone != null) 'su_phone_number': phone,
    }, headers: {}, params: {});

    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result['code'] != 200) {
      throw new ErrorDescription(result['msg']);
    }
  }

  /// 텔리엇의 모드 별로 활성화할 목소리를 설정한다.
  Future<void> updateVoice({String koreanVoice, String englishVoice}) async {
    final response = await post('/user/voice/update', body: {
      if (koreanVoice != null) "su_kor_voice": koreanVoice,
      if (englishVoice != null) "su_eng_voice": englishVoice,
    }, headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result['code'] != 200)
      throw new Error();
  }

  /// 현재 텔리엇의 목소리 정보를 가져온다.
  Future<Map<String, String>> getTelliotVoice({int su_seq}) async {
    final response = await get('/user/voice/$su_seq',headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return {'kor_voice': result['kor_voice'], 'eng_voice': result['eng_voice']};
  }

  /// 로그아웃 한다.
  Future<void> signout() async {
    await post('/user/signout',headers: {}, params: {});
  }

  /// ble로 연결된 텔리엇을 유저에게 등록시킨다.
  /// 등록된 텔리엇은 메인 하단에서 조회 가능하다.
  /// ble로 받은 id와 id를 api로 요청해서 받은 name을 바디로 갖는다.
  Future<int> insertTelliotToUserPairingHistory(
      {String telliotId, String telliotName, String btMac}) async {
    final response = await post('/pairing/telliot/create', body: {
      'telliot_id': telliotId,
      'telliot_name': telliotName,
      'bt_mac': btMac
    }, headers: {}, params: {});

    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result['code'] != 200)
      throw new ErrorDescription('올바르지 않은 요청입니다.'+result['code']);

    return result['ph_seq'];
  }

  Future<List<PairingTelliot>> getUserPairingHistory({int su_seq}) async {
    final response = await get('/pairing/telliot/$su_seq',headers: {}, params: {});

    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result['code'] != 200) {
      throw new ErrorDescription('페어링 텔리엇을 불러오는데 실패했습니다.');
    }

    return (result['telliot_list'] as List ?? [])
        .map(
          (history) => PairingTelliot.fromJson(history),
    )
        .toList();
  }

  /// 텔리엇의 이름을 변경시킨다.
  Future<void> updateTelliotName({int historySequence, String name}) async {
    await post('/pairing/telliot/update', body: {
      'ph_seq': historySequence,
      'ph_telliot_name': name,
    }, headers: {}, params: {});
  }

  /// 텔리엇을 등록 부분에서 삭제시킨다.
  Future<void> delteTelliotHistory({int historySequence}) async {
    final response = await post('/pairing/telliot/delete', body: {
      'ph_seq': historySequence,
    },headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    if (result['code'] != 200) {
      throw new ErrorDescription('유효하지 않은 옵션입니다.');
    }
  }
}