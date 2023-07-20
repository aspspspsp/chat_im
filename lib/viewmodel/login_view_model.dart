import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/login_data.dart';

class LoginViewModel extends ChangeNotifier {
  final dio = Dio();

  Future<LoginData> login(String account, String password) async {
    final url = "http://localhost:8080/user/user/login";
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final body = {
      'username': account,
      'password': password,
    };

    try {
      final response = await dio.post(
        url,
        options: Options(headers: headers),
        data: body,
      );

      if (response.statusCode == 200) {
        // 登錄成功，處理回應數據
        var data = response.data['data'];
        String token = data['jwtToken'];
        return LoginData(success: true, token: token, message: "Login Successful");
      } else {
        // 登錄失敗，處理錯誤
        return LoginData(success: false, message: "Login Failed");
      }
    } catch (e) {
      print('Error: $e');
      // 處理錯誤
      return LoginData(success: false, message: "An error occurred");
    }
  }

}