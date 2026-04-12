import 'package:http/http.dart' as http;
import 'package:threads/src/auth.dart';
import 'package:threads/src/exceptions/threads_exception.dart';
import 'package:threads/src/media.dart';
import 'package:threads/src/publishing.dart';
import 'package:threads/src/replies.dart';
import 'package:threads/src/threads_http_client.dart';

class ThreadsClient {
  ThreadsClient({
    required String accessToken,
    http.Client? httpClient,
    String? appId,
    String? appSecret,
    String? redirectUri,
  })  : _appId = appId,
        _appSecret = appSecret,
        _redirectUri = redirectUri,
        _rawHttpClient = httpClient,
        _httpClient = ThreadsHttpClient(
          accessToken: accessToken,
          httpClient: httpClient,
        );

  final String? _appId;
  final String? _appSecret;
  final String? _redirectUri;
  final http.Client? _rawHttpClient;
  final ThreadsHttpClient _httpClient;

  Auth? _auth;
  Media? _media;
  Publishing? _publishing;
  Replies? _replies;

  Auth get auth {
    if (_appId == null || _appSecret == null || _redirectUri == null) {
      throw ValidationException(
        statusCode: 0,
        errorCode: 'MissingCredentials',
        message: 'App credentials (appId, appSecret, redirectUri) are '
            'required for auth operations. Pass them to the '
            'ThreadsClient constructor or use Auth directly.',
      );
    }
    return _auth ??= Auth(
      appId: _appId,
      appSecret: _appSecret,
      redirectUri: _redirectUri,
      httpClient: _rawHttpClient,
    );
  }

  Media get media => _media ??= Media(_httpClient);

  Publishing get publishing => _publishing ??= Publishing(_httpClient);

  Replies get replies => _replies ??= Replies(_httpClient);
}
