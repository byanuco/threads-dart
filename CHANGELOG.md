## 0.1.1

- Fix API base URL from `graph.threads.me` to `graph.threads.net`
- Fix Token model to handle short-lived token responses (no `token_type` or `expires_in`)
- Fix auth error parsing for flat error format used by token endpoints
- Add missing `MediaType` values: `AUDIO`, `REPOST_FACADE`, `TEXT_POST`, `CAROUSEL_ALBUM`
- Add missing `ContainerStatus.published`
- Fix `MediaObject.children` type to match API response shape
- Add missing `MediaObject` fields: `owner`, `mediaProductType`, `replyApprovalStatus`, `isVerified`, `profilePictureUrl`
- Add `totalValue` and `linkTotalValues` to `InsightValue` for user-level metrics
- Add `userId` field to `Token`
- Make example interactive with browser-based OAuth and stdin code input

## 0.1.0

- Initial release
- Full coverage of the Threads API: Publishing, Media Retrieval, Reply Management, User, Locations, Location Search, Insights, oEmbed, and Debug
- OAuth 2.0 authentication with token exchange and refresh
- Typed exception hierarchy with sealed classes
- Cursor-based pagination support
