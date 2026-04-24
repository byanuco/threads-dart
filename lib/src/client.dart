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

/// Entry point to the Threads API.
///
/// Groups the SDK's feature areas ([publishing], [media], [replies], [user],
/// [insights], [locations], [oembed], [debug]) behind a single authenticated
/// client. Pass app credentials (`appId`, `appSecret`, `redirectUri`) if you
/// also need [auth] for the OAuth flow.
class ThreadsClient {
  /// Creates a client authenticated with [accessToken].
  ///
  /// [httpClient] lets callers inject a custom `http.Client` (useful for
  /// tests or proxy setups). `appId`, `appSecret`, and `redirectUri` are only
  /// required if you intend to use [auth]; omit them for plain API calls.
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

  /// OAuth helpers for obtaining and refreshing access tokens.
  ///
  /// Throws [ValidationException] if app credentials were not supplied to the
  /// constructor.
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

  /// Token introspection endpoints used for debugging auth state.
  Debug get debug => _debug ??= Debug(_httpClient);

  /// Media and user insights (views, likes, follower demographics, etc.).
  Insights get insights => _insights ??= Insights(_httpClient);

  /// Location lookup and search used when tagging posts with a place.
  Locations get locations => _locations ??= Locations(_httpClient);

  /// Reads on individual media objects and keyword/tag search over posts.
  Media get media => _media ??= Media(_httpClient);

  /// Fetches oEmbed markup for rendering a Threads post inside another page.
  OEmbed get oembed => _oembed ??= OEmbed(_httpClient);

  /// Creates, publishes, reposts, and deletes Threads posts.
  Publishing get publishing => _publishing ??= Publishing(_httpClient);

  /// Reads and moderates replies on posts you own.
  Replies get replies => _replies ??= Replies(_httpClient);

  /// Profile, feed, replies, mentions, and publishing quota for a user.
  User get user => _user ??= User(_httpClient);
}
