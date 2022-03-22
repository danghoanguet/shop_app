import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_execption.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate = null;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    if (token == '') {
      return false;
    }
    return true;

    //return token != '';
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return '';
  }

  String get userId {
    return _userId == null ? '' : _userId!;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _authenticate(
    String email,
    String password,
    String method,
  ) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$method?key=AIzaSyB6CWorMveXL6cN_aDCqNuJiNSJmx1uOt4');
    try {
      final respone = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      if (json.decode(respone.body)['error'] != null) {
        throw HttpExepciotn(json.decode(respone.body)['error']['message']);
      }
      _token = json.decode(respone.body)['idToken'];
      _userId = json.decode(respone.body)['localId'];
      _expiryDate = DateTime.now().add(
          Duration(seconds: int.parse(json.decode(respone.body)['expiresIn'])));
      _autoLogout();
      notifyListeners();

      // Store token on device local storage
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final extractedUserData = json.decode(prefs.getString('userData')!);
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;

    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate == null
        ? 0
        : _expiryDate!.difference(DateTime.now()).inSeconds;
    print(timeToExpiry);
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
