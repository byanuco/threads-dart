import 'package:threads_sdk/src/models/oembed_response.dart';
import 'package:threads_sdk/src/threads_http_client.dart';

/// Fetches oEmbed markup for rendering a Threads post inside another page.
class OEmbed {
  /// Creates an [OEmbed] bound to the given authenticated HTTP client.
  OEmbed(this._client);

  final ThreadsHttpClient _client;

  /// Returns the oEmbed response for a Threads post [url].
  ///
  /// [maxWidth] hints the maximum rendered width in pixels.
  Future<OEmbedResponse> get(String url, {int? maxWidth}) async {
    final queryParams = <String, String>{
      'url': url,
      'maxwidth': ?maxWidth?.toString(),
    };
    final response = await _client.get('/oembed', queryParams: queryParams);
    return OEmbedResponse.fromJson(response);
  }
}
