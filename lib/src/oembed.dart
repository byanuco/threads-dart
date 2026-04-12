import 'package:threads/src/models/oembed_response.dart';
import 'package:threads/src/threads_http_client.dart';

class OEmbed {
  OEmbed(this._client);

  final ThreadsHttpClient _client;

  Future<OEmbedResponse> get(String url, {int? maxWidth}) async {
    final queryParams = <String, String>{
      'url': url,
      'maxwidth': ?maxWidth?.toString(),
    };
    final response = await _client.get('/oembed', queryParams: queryParams);
    return OEmbedResponse.fromJson(response);
  }
}
