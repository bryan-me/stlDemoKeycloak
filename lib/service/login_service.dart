// login_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oauth2_test/tokenmanager.dart';

class LoginService {
  final String tokenEndpoint;
  final String clientId;

  LoginService({
    required this.tokenEndpoint,
    required this.clientId,
  });

  Future<Map<String, dynamic>> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'password',
          'client_id': clientId,
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to obtain access token');
      }

      final tokenData = json.decode(response.body);
      final accessToken = tokenData['access_token'];
      final refreshToken = tokenData['refresh_token'];
      final decodedToken = JwtDecoder.decode(accessToken);
      final sessionState = decodedToken['session_state'];

      if (accessToken != null && accessToken.isNotEmpty) {
        TokenManager.setTokens(accessToken, refreshToken, sessionState);
        return {
          'accessToken': accessToken,
          'username': decodedToken['preferred_username'],
          'email': decodedToken['email'],
          'sessionState': sessionState,
        };
      } else {
        throw Exception('Access token is empty');
      }
    } catch (e) {
      TokenManager.clearTokens();
      throw Exception('Error during token exchange: $e');
    }
  }
}
