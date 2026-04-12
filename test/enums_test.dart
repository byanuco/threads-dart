import 'package:test/test.dart';
import 'package:threads/src/enums/media_type.dart';
import 'package:threads/src/enums/token_type.dart';
import 'package:threads/src/enums/reply_control.dart';
import 'package:threads/src/enums/search_type.dart';
import 'package:threads/src/enums/search_mode.dart';
import 'package:threads/src/enums/insight_metric.dart';
import 'package:threads/src/enums/container_status.dart';
import 'package:threads/src/enums/scope.dart';

void main() {
  group('MediaType', () {
    test('fromValue returns correct enum for known values', () {
      expect(MediaType.fromValue('TEXT'), MediaType.text);
      expect(MediaType.fromValue('IMAGE'), MediaType.image);
      expect(MediaType.fromValue('VIDEO'), MediaType.video);
      expect(MediaType.fromValue('CAROUSEL'), MediaType.carousel);
    });

    test('value returns correct string', () {
      expect(MediaType.text.value, 'TEXT');
      expect(MediaType.image.value, 'IMAGE');
      expect(MediaType.video.value, 'VIDEO');
      expect(MediaType.carousel.value, 'CAROUSEL');
    });

    test('fromValue throws ArgumentError for unknown value', () {
      expect(() => MediaType.fromValue('UNKNOWN'), throwsArgumentError);
    });
  });

  group('TokenType', () {
    test('fromValue returns correct enum for known values', () {
      expect(TokenType.fromValue('bearer'), TokenType.bearer);
    });

    test('value returns correct string', () {
      expect(TokenType.bearer.value, 'bearer');
    });

    test('fromValue throws ArgumentError for unknown value', () {
      expect(() => TokenType.fromValue('UNKNOWN'), throwsArgumentError);
    });
  });

  group('ReplyControl', () {
    test('fromValue returns correct enum for known values', () {
      expect(ReplyControl.fromValue('everyone'), ReplyControl.everyone);
      expect(
        ReplyControl.fromValue('accounts_you_follow'),
        ReplyControl.accountsYouFollow,
      );
      expect(
        ReplyControl.fromValue('mentioned_only'),
        ReplyControl.mentionedOnly,
      );
      expect(
        ReplyControl.fromValue('parent_post_author_only'),
        ReplyControl.parentPostAuthorOnly,
      );
      expect(
        ReplyControl.fromValue('followers_only'),
        ReplyControl.followersOnly,
      );
    });

    test('value returns correct string', () {
      expect(ReplyControl.everyone.value, 'everyone');
      expect(ReplyControl.accountsYouFollow.value, 'accounts_you_follow');
      expect(ReplyControl.mentionedOnly.value, 'mentioned_only');
      expect(ReplyControl.parentPostAuthorOnly.value, 'parent_post_author_only');
      expect(ReplyControl.followersOnly.value, 'followers_only');
    });

    test('fromValue throws ArgumentError for unknown value', () {
      expect(() => ReplyControl.fromValue('UNKNOWN'), throwsArgumentError);
    });
  });

  group('SearchType', () {
    test('fromValue returns correct enum for known values', () {
      expect(SearchType.fromValue('TOP'), SearchType.top);
      expect(SearchType.fromValue('RECENT'), SearchType.recent);
    });

    test('value returns correct string', () {
      expect(SearchType.top.value, 'TOP');
      expect(SearchType.recent.value, 'RECENT');
    });

    test('fromValue throws ArgumentError for unknown value', () {
      expect(() => SearchType.fromValue('UNKNOWN'), throwsArgumentError);
    });
  });

  group('SearchMode', () {
    test('fromValue returns correct enum for known values', () {
      expect(SearchMode.fromValue('KEYWORD'), SearchMode.keyword);
      expect(SearchMode.fromValue('TAG'), SearchMode.tag);
    });

    test('value returns correct string', () {
      expect(SearchMode.keyword.value, 'KEYWORD');
      expect(SearchMode.tag.value, 'TAG');
    });

    test('fromValue throws ArgumentError for unknown value', () {
      expect(() => SearchMode.fromValue('UNKNOWN'), throwsArgumentError);
    });
  });

  group('InsightMetric', () {
    test('fromValue returns correct enum for known values', () {
      expect(InsightMetric.fromValue('views'), InsightMetric.views);
      expect(InsightMetric.fromValue('likes'), InsightMetric.likes);
      expect(InsightMetric.fromValue('replies'), InsightMetric.replies);
      expect(InsightMetric.fromValue('reposts'), InsightMetric.reposts);
      expect(InsightMetric.fromValue('quotes'), InsightMetric.quotes);
      expect(InsightMetric.fromValue('shares'), InsightMetric.shares);
      expect(InsightMetric.fromValue('clicks'), InsightMetric.clicks);
      expect(
        InsightMetric.fromValue('followers_count'),
        InsightMetric.followersCount,
      );
      expect(
        InsightMetric.fromValue('follower_demographics'),
        InsightMetric.followerDemographics,
      );
    });

    test('value returns correct string', () {
      expect(InsightMetric.views.value, 'views');
      expect(InsightMetric.likes.value, 'likes');
      expect(InsightMetric.replies.value, 'replies');
      expect(InsightMetric.reposts.value, 'reposts');
      expect(InsightMetric.quotes.value, 'quotes');
      expect(InsightMetric.shares.value, 'shares');
      expect(InsightMetric.clicks.value, 'clicks');
      expect(InsightMetric.followersCount.value, 'followers_count');
      expect(InsightMetric.followerDemographics.value, 'follower_demographics');
    });

    test('fromValue throws ArgumentError for unknown value', () {
      expect(() => InsightMetric.fromValue('UNKNOWN'), throwsArgumentError);
    });
  });

  group('ContainerStatus', () {
    test('fromValue returns correct enum for known values', () {
      expect(ContainerStatus.fromValue('IN_PROGRESS'), ContainerStatus.inProgress);
      expect(ContainerStatus.fromValue('FINISHED'), ContainerStatus.finished);
      expect(ContainerStatus.fromValue('ERROR'), ContainerStatus.error);
      expect(ContainerStatus.fromValue('EXPIRED'), ContainerStatus.expired);
    });

    test('value returns correct string', () {
      expect(ContainerStatus.inProgress.value, 'IN_PROGRESS');
      expect(ContainerStatus.finished.value, 'FINISHED');
      expect(ContainerStatus.error.value, 'ERROR');
      expect(ContainerStatus.expired.value, 'EXPIRED');
    });

    test('fromValue throws ArgumentError for unknown value', () {
      expect(() => ContainerStatus.fromValue('UNKNOWN'), throwsArgumentError);
    });
  });

  group('Scope', () {
    test('value returns correct string', () {
      expect(Scope.basic.value, 'threads_basic');
      expect(Scope.publish.value, 'threads_content_publish');
      expect(Scope.manageReplies.value, 'threads_manage_replies');
      expect(Scope.readReplies.value, 'threads_read_replies');
      expect(Scope.manageInsights.value, 'threads_manage_insights');
    });
  });
}
