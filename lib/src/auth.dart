import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:threads/src/enums/scope.dart';
import 'package:threads/src/exceptions/threads_exception.dart';
import 'package:threads/src/models/token.dart';

class Auth {
  Auth({
    required this.appId,
    required this.appSecret,
    required this.redirectUri,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final String appId;
  final String appSecret;
  final String redirectUri;
  final http.Client _httpClient;

  Uri getAuthorizationUrl({required List<Scope> scopes, String? state}) {
    final params = <String, String?>{
      'client_id': appId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      'scope': scopes.map((s) => s.value).join(','),
      'state': ?state,
    };
    return Uri.https('threads.net', '/oauth/authorize', params);
  }

  Future<Token> exchangeCode(String code) async {
    final uri = Uri.https('graph.threads.me', '/oauth/access_token');
    final response = await _httpClient.post(
      uri,
      body: {
        'client_id': appId,
        'client_secret': appSecret,
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUri,
        'code': code,
      },
    );
    return _parseTokenResponse(response);
  }

  Future<Token> exchangeForLongLived(String shortLivedToken) async {
    final uri = Uri.https('graph.threads.me', '/access_token', {
      'grant_type': 'th_exchange_token',
      'client_secret': appSecret,
      'access_token': shortLivedToken,
    });
    final response = await _httpClient.get(uri);
    return _parseTokenResponse(response);
  }

  Future<Token> refreshLongLivedToken(String longLivedToken) async {
    final uri = Uri.https('graph.threads.me', '/refresh_access_token', {
      'grant_type': 'th_refresh_token',
      'access_token': longLivedToken,
    });
    final response = await _httpClient.get(uri);
    return _parseTokenResponse(response);
  }

  Token _parseTokenResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Token.fromJson(body);
    }

    final error = body['error'] as Map<String, dynamic>? ?? {};
    final message = error['message'] as String? ?? 'Unknown error';
    final errorType = error['type'] as String? ?? 'UnknownError';
    final code = error['code'] as int? ?? 0;
    final errorCode = '$errorType/$code';

    throw AuthException(
      statusCode: response.statusCode,
      errorCode: errorCode,
      message: message,
    );
  }
}
