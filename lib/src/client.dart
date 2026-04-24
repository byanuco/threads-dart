import 'package:http/http.dart' as http;
import 'package:threads_sdk/src/auth.dart';
import 'package:threads_sdk/src/debug.dart';
import 'package:threads_sdk/src/exceptions/threads_exception.dart';
import 'package:threads_sdk/src/insights.dart';
import 'package:threads_sdk/src/locations.dart';
import 'package:threads_sdk/src/media.dart';
import 'package:threads_sdk/src/oembed.dart';
import 'package:threads_sdk/src/publishing.dart';
import 'package:threads_sdk/src/replies.dart';
import 'package:threads_sdk/src/threads_http_client.dart';
import 'package:threads_sdk/src/user.dart';

class ThreadsClient {
  ThreadsClient({
    required String accessToken,
    http.Client? httpClient,
    String? appId,
    String? appSecret,
    String? redirectUri,
  }) : _appId = appId,
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
  Debug? _debug;
  Insights? _insights;
  Locations? _locations;
  Media? _media;
  OEmbed? _oembed;
  Publishing? _publishing;
  Replies? _replies;
  User? _user;

  Auth get auth {
    if (_appId == null || _appSecret == null || _redirectUri == null) {
      throw ValidationException(
        statusCode: 0,
        errorCode: 'MissingCredentials',
        message:
            'App credentials (appId, appSecret, redirectUri) are '
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

  Debug get debug => _debug ??= Debug(_httpClient);

  Insights get insights => _insights ??= Insights(_httpClient);

  Locations get locations => _locations ??= Locations(_httpClient);

  Media get media => _media ??= Media(_httpClient);

  OEmbed get oembed => _oembed ??= OEmbed(_httpClient);

  Publishing get publishing => _publishing ??= Publishing(_httpClient);

  Replies get replies => _replies ??= Replies(_httpClient);

  User get user => _user ??= User(_httpClient);
}
