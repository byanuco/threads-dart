// ignore_for_file: avoid_print, unused_local_variable

import 'package:threads/threads.dart';

Future<void> main() async {
  // -------------------------------------------------------------------------
  // Authentication
  // -------------------------------------------------------------------------

  // Create an Auth instance directly when you only need OAuth flows.
  final auth = Auth(
    appId: 'YOUR_APP_ID',
    appSecret: 'YOUR_APP_SECRET',
    redirectUri: 'https://your-app.example.com/callback',
  );

  // Generate the URL to redirect the user to for authorization.
  final authUrl = auth.getAuthorizationUrl(
    scopes: [
      Scope.basic,
      Scope.publish,
      Scope.manageReplies,
      Scope.manageInsights,
    ],
    state: 'some-csrf-token',
  );
  print('Direct your user to: $authUrl');

  // After the user authorizes and you receive the callback code, exchange it
  // for a short-lived token, then upgrade to a long-lived one.
  //
  // final shortLived = await auth.exchangeCode('CODE_FROM_CALLBACK');
  // final longLived = await auth.exchangeForLongLived(shortLived.accessToken);
  // print('Long-lived token expires in: ${longLived.expiresIn} seconds');

  // -------------------------------------------------------------------------
  // ThreadsClient
  // -------------------------------------------------------------------------

  // ThreadsClient is the main entry point once you have an access token.
  // Pass appId/appSecret/redirectUri if you also want to call client.auth.
  final client = ThreadsClient(
    accessToken: 'LONG_LIVED_ACCESS_TOKEN',
    appId: 'YOUR_APP_ID',
    appSecret: 'YOUR_APP_SECRET',
    redirectUri: 'https://your-app.example.com/callback',
  );

  const userId = 'ME'; // Use 'me' or a numeric user ID.

  // -------------------------------------------------------------------------
  // Publishing: create and publish a text post
  // -------------------------------------------------------------------------

  // Step 1: create a media container.
  final containerId = await client.publishing.createContainer(
    userId: userId,
    mediaType: MediaType.text,
    text: 'Hello from the Threads Dart SDK!',
  );
  print('Container created: $containerId');

  // Step 2: publish it.
  final postId = await client.publishing.publish(
    userId: userId,
    creationId: containerId,
  );
  print('Post published: $postId');

  // -------------------------------------------------------------------------
  // Reading: fetch the user's threads
  // -------------------------------------------------------------------------

  final threads = await client.user.getThreads(
    userId,
    fields: ['id', 'text', 'timestamp', 'media_type'],
    limit: 10,
  );

  print('Fetched ${threads.data.length} threads');
  for (final post in threads.data) {
    print('  [${post.id}] ${post.text ?? "(no text)"}');
  }

  // Paginate with the cursor from the response.
  if (threads.afterCursor != null) {
    final nextPage = await client.user.getThreads(
      userId,
      after: threads.afterCursor,
      limit: 10,
    );
    print('Next page has ${nextPage.data.length} threads');
  }

  // -------------------------------------------------------------------------
  // Insights
  // -------------------------------------------------------------------------

  // Media-level insights for a specific post.
  final mediaInsights = await client.insights.getMediaInsights(
    postId,
    metrics: [InsightMetric.likes, InsightMetric.replies, InsightMetric.views],
  );

  for (final insight in mediaInsights) {
    print('${insight.name}: ${insight.values.firstOrNull}');
  }

  // User-level insights (account-wide metrics).
  final userInsights = await client.insights.getUserInsights(
    userId,
    metrics: [InsightMetric.followersCount, InsightMetric.views],
  );

  for (final insight in userInsights) {
    print('${insight.name}: ${insight.values.firstOrNull}');
  }

  // -------------------------------------------------------------------------
  // Error handling
  // -------------------------------------------------------------------------

  try {
    await client.media.get('nonexistent-id');
  } on NotFoundException catch (e) {
    print('Not found: ${e.message}');
  } on RateLimitException catch (e) {
    print('Rate limited (${e.statusCode}): ${e.message}');
  } on PermissionException catch (e) {
    print('Permission denied: ${e.message}');
  } on ThreadsException catch (e) {
    // Catches any other ThreadsException subclass.
    print('Threads error [${e.errorCode}]: ${e.message}');
  }
}
