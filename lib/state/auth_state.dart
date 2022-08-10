import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/user_api.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  bool get isLogin => _token != null;
  String get token => _token;
  String get username => _username;
  String get password => _password;
  User get me => _user;
  bool get firstInit => _firstInit;
  bool get savePassword => _savePassword;
  bool get saveUsername => _saveUsername;

  String _token;
  String _username;
  String _password;
  bool _firstInit;
  bool _savePassword = false;
  bool _saveUsername = false;

  User _user;

  Future<void> checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final init = prefs.getBool('init');

    if (init == null) {
      _firstInit = false;
      notifyListeners();
    } else {
      _firstInit = true;
      notifyListeners();
    }
  }

  Future<void> setToken(String token) async {
    FlutterSecureStorage _storage = FlutterSecureStorage();

    await _storage.write(key: 'token', value: token);
    _token = token;
    notifyListeners();
  }

  Future<void> setPassword(BuildContext context, {String password}) async {
    if (password == null) return;

    await UserAPI(context: context)
        .changePassword(password: _password, newPassword: password);
    FlutterSecureStorage _storage = FlutterSecureStorage();

    await _storage.write(key: 'password', value: password);
    _password = password;
    notifyListeners();
  }

  Future<void> readAllFromStorage() async {
    final _storage = FlutterSecureStorage();
    _token = (await _storage.read(key: 'token'));
    _username = (await _storage.read(key: 'username'));
    _password = (await _storage.read(key: 'password'));
    notifyListeners();
    _savePassword =
        (await _storage.read(key: 'savePassword') ?? "false") == "true";
    _saveUsername =
        (await _storage.read(key: 'saveUsername') ?? "false") == "true";
    if (_token == null) {
      if (!_savePassword) {
        _password = null;
        await _storage.delete(key: 'password');
      }
      if (!_saveUsername) {
        _username = null;
        await _storage.delete(key: 'username');
      }
    }


    notifyListeners();
  }

  Future<void> autoLogin(BuildContext context) async {
    final _storage = FlutterSecureStorage();

    try {
      if (_token != null) {
        final user = await UserAPI(context: context).signIn(
          username: _username,
          password: _password,
        );
        if (user.su_join_dt != null) {
          final map = await _storage.read(key: 'deviceMap');
          if (map != null) {
            await _storage.delete(key: 'deviceMap');
          }
          _user = user;

          await setToken(_token);
        }
      }
    } catch (e) {
      print(e);
      setToken(null);
      signout(context);
    }
  }

  Future<User> setMe(BuildContext context) async {
    final me = await UserAPI(context: context).getMe(su_seq: _user.su_seq);

    _user.su_first_name = me.su_first_name;
    _user.su_last_name = me.su_last_name;
    _user.su_gender = me.su_gender;
    _user.su_birth_date = me.su_gender;
    _user.su_location = me.su_location;
    _user.su_email = me.su_email;
    _user.su_nickname = me.su_nickname;
    _user.su_phone_number = me.su_phone_number;
    _user.su_cr_dt = me.su_cr_dt;
    _user.su_join_dt = me.su_join_dt;
    _user.su_last_login = me.su_last_login;

    notifyListeners();

    return me;
  }

  void setSaveUserName({bool save}) {
    _saveUsername = save;
    notifyListeners();
  }

  void setSavePassword({bool save}) {
    _savePassword = save;
    notifyListeners();
  }

  Future<User> signin(
      BuildContext context, {
        String username,
        String password,
      }) async {
    final storage = FlutterSecureStorage();
    final _prefs = await SharedPreferences.getInstance();
    final user = await UserAPI(context: context)
        .signIn(username: username, password: password);
    if (user is User) {
      _user = user;
      await storage.write(key: 'username', value: username);
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'saveUsername', value: _saveUsername.toString());
      await storage.write(key: 'savePassword', value: _savePassword.toString());
      if (!_firstInit) {
        _prefs.setBool('init', true);
      }
      _password = password;
      _username = username;
      notifyListeners();
      return user;
    } else
      throw new Exception('[아이디 또는 비밀번호가 일치하지 않습니다.]');
  }

  Future<void> signout(BuildContext context) async {
    final _storage = FlutterSecureStorage();
    await UserAPI(context: context).signout();
    _storage.delete(key: 'token');
    setToken(null);
    //_user;
    _password = null;
    notifyListeners();
  }
}
