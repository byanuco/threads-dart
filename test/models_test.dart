import 'package:test/test.dart';
import 'package:threads/src/enums/media_type.dart';
import 'package:threads/src/enums/token_type.dart';
import 'package:threads/src/models/insight.dart';
import 'package:threads/src/models/location.dart';
import 'package:threads/src/models/media_object.dart';
import 'package:threads/src/models/oembed_response.dart';
import 'package:threads/src/models/paginated_response.dart';
import 'package:threads/src/models/token.dart';
import 'package:threads/src/models/user_profile.dart';

void main() {
  group('Token', () {
    test('fromJson parses fields correctly', () {
      final json = {
        'access_token': 'abc123',
        'token_type': 'bearer',
        'expires_in': 3600,
      };
      final token = Token.fromJson(json);
      expect(token.accessToken, 'abc123');
      expect(token.tokenType, TokenType.bearer);
      expect(token.expiresIn, 3600);
    });

    test('fromJson computes expiresAt from now + expiresIn', () {
      final before = DateTime.now();
      final json = {
        'access_token': 'abc123',
        'token_type': 'bearer',
        'expires_in': 3600,
      };
      final token = Token.fromJson(json);
      final after = DateTime.now();
      expect(
        token.expiresAt.isAfter(before.add(const Duration(seconds: 3599))),
        isTrue,
      );
      expect(
        token.expiresAt.isBefore(after.add(const Duration(seconds: 3601))),
        isTrue,
      );
    });

    test('toJson does not include expiresAt', () {
      final json = {
        'access_token': 'abc123',
        'token_type': 'bearer',
        'expires_in': 3600,
      };
      final token = Token.fromJson(json);
      final output = token.toJson();
      expect(output.containsKey('expires_at'), isFalse);
    });

    test('toString does not include access token value', () {
      final json = {
        'access_token': 'super_secret_token',
        'token_type': 'bearer',
        'expires_in': 3600,
      };
      final token = Token.fromJson(json);
      expect(token.toString(), isNot(contains('super_secret_token')));
      expect(token.toString(), contains('bearer'));
    });
  });

  group('MediaObject', () {
    test('fromJson parses required id field', () {
      final json = {'id': 'media_123'};
      final obj = MediaObject.fromJson(json);
      expect(obj.id, 'media_123');
    });

    test('fromJson parses all nullable fields when present', () {
      final json = {
        'id': 'media_123',
        'media_type': 'IMAGE',
        'media_url': 'https://example.com/img.jpg',
        'permalink': 'https://threads.net/post/123',
        'username': 'alice',
        'text': 'Hello world',
        'timestamp': '2024-01-01T00:00:00Z',
        'shortcode': 'abc',
        'thumbnail_url': 'https://example.com/thumb.jpg',
        'children': ['child_1', 'child_2'],
        'is_quote_post': true,
        'has_replies': false,
        'is_reply': false,
        'is_reply_owned_by_me': true,
        'is_spoiler_media': false,
        'alt_text': 'An image',
        'link_attachment_url': 'https://example.com',
      };
      final obj = MediaObject.fromJson(json);
      expect(obj.mediaType, MediaType.image);
      expect(obj.mediaUrl, 'https://example.com/img.jpg');
      expect(obj.username, 'alice');
      expect(obj.text, 'Hello world');
      expect(obj.children, ['child_1', 'child_2']);
      expect(obj.isQuotePost, isTrue);
      expect(obj.altText, 'An image');
      expect(obj.linkAttachmentUrl, 'https://example.com');
    });

    test('fromJson handles null optional fields', () {
      final json = {'id': 'media_123'};
      final obj = MediaObject.fromJson(json);
      expect(obj.mediaType, isNull);
      expect(obj.mediaUrl, isNull);
      expect(obj.children, isNull);
    });

    test('toJson round-trips correctly', () {
      final json = {'id': 'media_123', 'media_type': 'TEXT', 'username': 'bob'};
      final obj = MediaObject.fromJson(json);
      final output = obj.toJson();
      expect(output['id'], 'media_123');
      expect(output['media_type'], 'TEXT');
      expect(output['username'], 'bob');
    });
  });

  group('UserProfile', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'user_123',
        'username': 'alice',
        'name': 'Alice Smith',
        'threads_profile_picture_url': 'https://example.com/pic.jpg',
        'threads_biography': 'Hello!',
        'is_verified': true,
      };
      final profile = UserProfile.fromJson(json);
      expect(profile.id, 'user_123');
      expect(profile.username, 'alice');
      expect(profile.name, 'Alice Smith');
      expect(profile.profilePictureUrl, 'https://example.com/pic.jpg');
      expect(profile.biography, 'Hello!');
      expect(profile.isVerified, isTrue);
    });

    test('fromJson handles null optional fields', () {
      final json = {
        'id': 'user_123',
        'username': 'alice',
        'threads_profile_picture_url': null,
        'threads_biography': null,
        'is_verified': null,
      };
      final profile = UserProfile.fromJson(json);
      expect(profile.name, isNull);
      expect(profile.profilePictureUrl, isNull);
      expect(profile.biography, isNull);
      expect(profile.isVerified, isNull);
    });

    test('toJson round-trips correctly', () {
      final json = {
        'id': 'user_123',
        'username': 'alice',
        'name': 'Alice',
        'threads_profile_picture_url': null,
        'threads_biography': null,
        'is_verified': false,
      };
      final profile = UserProfile.fromJson(json);
      final output = profile.toJson();
      expect(output['id'], 'user_123');
      expect(output['username'], 'alice');
    });
  });

  group('InsightValue', () {
    test('fromJson parses required fields', () {
      final json = {
        'name': 'views',
        'period': 'lifetime',
        'values': [
          {'value': 100, 'end_time': '2024-01-01'},
        ],
      };
      final insight = InsightValue.fromJson(json);
      expect(insight.name, 'views');
      expect(insight.period, 'lifetime');
      expect(insight.values, hasLength(1));
    });

    test('fromJson handles optional fields', () {
      final json = {
        'name': 'likes',
        'period': 'day',
        'values': <Map<String, dynamic>>[],
        'title': 'Likes',
        'description': 'Number of likes',
        'id': 'insight_123',
      };
      final insight = InsightValue.fromJson(json);
      expect(insight.title, 'Likes');
      expect(insight.description, 'Number of likes');
      expect(insight.id, 'insight_123');
    });

    test('fromJson handles null optional fields', () {
      final json = {
        'name': 'likes',
        'period': 'day',
        'values': <Map<String, dynamic>>[],
      };
      final insight = InsightValue.fromJson(json);
      expect(insight.title, isNull);
      expect(insight.description, isNull);
      expect(insight.id, isNull);
    });
  });

  group('Location', () {
    test('fromJson parses required and optional fields', () {
      final json = {
        'id': 'loc_123',
        'name': 'Central Park',
        'address': '59th St',
        'city': 'New York',
        'country': 'US',
        'latitude': 40.7829,
        'longitude': -73.9654,
        'postal_code': '10024',
      };
      final loc = Location.fromJson(json);
      expect(loc.id, 'loc_123');
      expect(loc.name, 'Central Park');
      expect(loc.latitude, 40.7829);
      expect(loc.longitude, -73.9654);
      expect(loc.postalCode, '10024');
    });

    test('fromJson handles null optional fields', () {
      final json = {'id': 'loc_123'};
      final loc = Location.fromJson(json);
      expect(loc.name, isNull);
      expect(loc.latitude, isNull);
      expect(loc.postalCode, isNull);
    });
  });

  group('OEmbedResponse', () {
    test('fromJson parses all fields', () {
      final json = {
        'html': '<blockquote>...</blockquote>',
        'provider_name': 'Threads',
        'provider_url': 'https://threads.net',
        'type': 'rich',
        'version': '1.0',
        'width': 550,
      };
      final resp = OEmbedResponse.fromJson(json);
      expect(resp.html, '<blockquote>...</blockquote>');
      expect(resp.providerName, 'Threads');
      expect(resp.providerUrl, 'https://threads.net');
      expect(resp.type, 'rich');
      expect(resp.version, '1.0');
      expect(resp.width, 550);
    });

    test('fromJson handles null optional fields', () {
      final json = {'html': '<p>test</p>'};
      final resp = OEmbedResponse.fromJson(json);
      expect(resp.providerName, isNull);
      expect(resp.width, isNull);
    });
  });

  group('PaginatedResponse', () {
    test('fromJson parses data and cursors', () {
      final json = {
        'data': [
          {'id': 'item_1'},
          {'id': 'item_2'},
        ],
        'paging': {
          'cursors': {'before': 'cursor_before', 'after': 'cursor_after'},
        },
      };
      final response = PaginatedResponse.fromJson(
        json,
        (item) => item as Map<String, dynamic>,
      );
      expect(response.data, hasLength(2));
      expect(response.beforeCursor, 'cursor_before');
      expect(response.afterCursor, 'cursor_after');
    });

    test('fromJson handles missing paging', () {
      final json = {
        'data': [
          {'id': 'item_1'},
        ],
      };
      final response = PaginatedResponse.fromJson(
        json,
        (item) => item as Map<String, dynamic>,
      );
      expect(response.data, hasLength(1));
      expect(response.beforeCursor, isNull);
      expect(response.afterCursor, isNull);
    });

    test('fromJson deserializes data items using provided function', () {
      final json = {
        'data': ['a', 'b', 'c'],
      };
      final response = PaginatedResponse.fromJson(
        json,
        (item) => item as String,
      );
      expect(response.data, ['a', 'b', 'c']);
    });

    test('handles empty data list', () {
      final json = {'data': <dynamic>[]};
      final response = PaginatedResponse.fromJson(
        json,
        (item) => item as String,
      );
      expect(response.data, isEmpty);
      expect(response.beforeCursor, isNull);
      expect(response.afterCursor, isNull);
    });
  });
}
