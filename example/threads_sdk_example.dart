// ignore_for_file: avoid_print

import 'dart:io';

import 'package:threads_sdk/threads_sdk.dart';

Future<void> main() async {
  // -------------------------------------------------------------------------
  // Authentication
  // -------------------------------------------------------------------------

  // Load credentials from .env file at the repo root.
  final env = <String, String>{};
  for (final line in File('.env').readAsLinesSync()) {
    final idx = line.indexOf('=');
    if (idx > 0) env[line.substring(0, idx)] = line.substring(idx + 1);
  }

  // Create an Auth instance directly when you only need OAuth flows.
  final auth = Auth(
    appId: env['THREADS_APP_ID']!,
    appSecret: env['THREADS_APP_SECRET']!,
    redirectUri: env['THREADS_REDIRECT_URI']!,
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

  // Open the authorization URL in the default browser.
  print('Opening browser for authorization...');
  await Process.run('open', [authUrl.toString()]);

  // After authorizing, paste the full redirect URL or just the code.
  stdout.write('Paste the redirect URL (or just the code): ');
  final input = stdin.readLineSync()!;
  final code = Uri.tryParse(input)?.queryParameters['code'] ?? input;

  // Exchange it for a short-lived token, then upgrade to a long-lived one.
  final shortLived = await auth.exchangeCode(code);
  final longLived = await auth.exchangeForLongLived(shortLived.accessToken);
  print('Long-lived token: $longLived');

  // -------------------------------------------------------------------------
  // ThreadsClient
  // -------------------------------------------------------------------------

  // ThreadsClient is the main entry point once you have an access token.
  // Pass appId/appSecret/redirectUri if you also want to call client.auth.
  final client = ThreadsClient(
    accessToken: longLived.accessToken,
    appId: auth.appId,
    appSecret: auth.appSecret,
    redirectUri: auth.redirectUri,
  );

  const userId = 'me'; // Use 'me' or a numeric user ID.

  // -------------------------------------------------------------------------
  // Publishing: create and publish a text post
  // -------------------------------------------------------------------------

  // Step 1: create a media container.
  final containerId = await client.publishing.createContainer(
    userId: userId,
    mediaType: MediaType.text,
    text: 'This post should delete itself shortly.',
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
    final value = insight.totalValue ?? insight.values.firstOrNull;
    print('${insight.name}: $value');
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
