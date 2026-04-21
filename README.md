# threads

[![CI](https://github.com/andeart/threads-dart/actions/workflows/ci.yml/badge.svg)](https://github.com/andeart/threads-dart/actions/workflows/ci.yml)
[![pub.dev](https://img.shields.io/pub/v/threads.svg)](https://pub.dev/packages/threads)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A complete Dart SDK for the [Threads API](https://developers.facebook.com/docs/threads). Publish posts, manage replies, retrieve insights, and handle OAuth, all from a single package.

> **Important.** This is a community-maintained package and is not affiliated with or endorsed by Meta or the Threads team. "Threads" is a trademark of Meta Platforms, Inc., mentioned here only so you know which API this package talks to.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  threads: ^0.1.0
```

Then run `dart pub get`.

## Quick start

### Authentication

The Threads API uses OAuth 2.0. Create an `Auth` instance and redirect your user to the authorization URL:

```dart
import 'package:threads/threads.dart';

final auth = Auth(
  appId: 'YOUR_APP_ID',
  appSecret: 'YOUR_APP_SECRET',
  redirectUri: 'https://your-app.example.com/callback',
);

final url = auth.getAuthorizationUrl(
  scopes: [Scope.basic, Scope.publish, Scope.manageInsights],
);
// Redirect the user to `url`, then handle the callback.
```

After the user authorizes, exchange the code for tokens:

```dart
final shortLived = await auth.exchangeCode(codeFromCallback);
final longLived = await auth.exchangeForLongLived(shortLived.accessToken);
// Store longLived.accessToken. It's valid for 60 days.
```

### Publishing

Once you have an access token, create a `ThreadsClient` and publish:

```dart
final client = ThreadsClient(accessToken: longLived.accessToken);

// Step 1: create a container.
final containerId = await client.publishing.createContainer(
  userId: 'me',
  mediaType: MediaType.text,
  text: 'Hello from the Threads Dart SDK!',
);

// Step 2: publish it.
final postId = await client.publishing.publish(
  userId: 'me',
  creationId: containerId,
);
```

### Reading

Fetch a user's threads with optional pagination:

```dart
final threads = await client.user.getThreads(
  'me',
  fields: ['id', 'text', 'timestamp'],
  limit: 25,
);

for (final post in threads.data) {
  print('${post.timestamp}: ${post.text}');
}

// Get the next page.
if (threads.afterCursor != null) {
  final next = await client.user.getThreads('me', after: threads.afterCursor);
}
```

Fetch account-level and post-level insights:

```dart
final insights = await client.insights.getUserInsights(
  'me',
  metrics: [InsightMetric.views, InsightMetric.followersCount],
);
```

### Error handling

All errors thrown by this SDK are subclasses of `ThreadsException`, so you can catch them as broadly or narrowly as you need:

```dart
try {
  await client.media.get(someId);
} on NotFoundException catch (e) {
  print('Not found: ${e.message}');
} on RateLimitException catch (e) {
  print('Rate limited. Retry after a moment.');
} on PermissionException catch (e) {
  print('Missing scope: ${e.errorCode}');
} on ThreadsException catch (e) {
  print('Threads error [${e.errorCode}]: ${e.message}');
}
```

Every `ThreadsException` has three fields: `statusCode`, `errorCode`, and `message`.

## API groups

| Group | Access via | What it covers |
|-------|-----------|----------------|
| `Auth` | `client.auth` or standalone | OAuth flows, token exchange, token refresh |
| `Publishing` | `client.publishing` | Create containers, publish posts, repost, delete |
| `Media` | `client.media` | Fetch media objects, keyword search |
| `Replies` | `client.replies` | Read and manage reply threads |
| `User` | `client.user` | Profile, threads, replies, mentions, ghost posts |
| `Insights` | `client.insights` | Media and account-level metrics |
| `Locations` | `client.locations` | Tag posts with location data |
| `OEmbed` | `client.oembed` | Embed Threads posts in web pages |
| `Debug` | `client.debug` | Debug token info (useful in development) |

A runnable end-to-end example lives in [`example/threads_example.dart`](example/threads_example.dart).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup, code style, and PR expectations.

Test coverage is held at 90% or higher, enforced in CI. See the [Coverage section in CONTRIBUTING.md](CONTRIBUTING.md#coverage) for how to run the check locally.

## License

MIT. See [LICENSE](LICENSE).
