/// A Dart SDK for Meta's Threads API.
///
/// Publish posts, manage replies, read insights, search locations, and
/// handle OAuth, all with fully typed models and a sealed exception
/// hierarchy.
///
/// See the README at https://github.com/byanuco/threads-dart for a full
/// walkthrough and a runnable example.
library;

// Client
export 'src/client.dart';
export 'src/auth.dart';

// Sub-groups
export 'src/publishing.dart';
export 'src/media.dart';
export 'src/replies.dart';
export 'src/user.dart';
export 'src/insights.dart';
export 'src/locations.dart';
export 'src/oembed.dart';
export 'src/debug.dart';

// Models
export 'src/models/token.dart';
export 'src/models/media_object.dart';
export 'src/models/user_profile.dart';
export 'src/models/insight.dart';
export 'src/models/location.dart';
export 'src/models/oembed_response.dart';
export 'src/models/paginated_response.dart';

// Enums
export 'src/enums/media_type.dart';
export 'src/enums/token_type.dart';
export 'src/enums/reply_control.dart';
export 'src/enums/search_type.dart';
export 'src/enums/search_mode.dart';
export 'src/enums/insight_metric.dart';
export 'src/enums/container_status.dart';
export 'src/enums/scope.dart';

// Exceptions
export 'src/exceptions/threads_exception.dart';
