<!--
Thanks for opening a PR! Please fill out the sections below so reviewers have
the context they need. If anything doesn't apply (e.g. a docs-only change),
say so rather than deleting the section.
-->

## Summary

<!-- What does this PR change, and why? Not just what the diff shows. -->

## Related issue

<!-- Link the issue this PR addresses, e.g. "Closes #123".
     If this is a trivial change (typo, broken link, wording tweak), say so.
     See: "Before you start" in CONTRIBUTING.md -->

Closes #

## Pre-flight checklist

- [ ] An issue exists for this work and is linked above, or this is a trivial change per [Before you start](/CONTRIBUTING.md#before-you-start).
- [ ] New features have happy-path and error-case tests; bug fixes include a test that failed against `main` before the fix. See [Testing approach](/CONTRIBUTING.md#testing-approach).
- [ ] Mock responses mirror what the real [Threads API](https://developers.facebook.com/docs/threads) returns today (field names, shapes, status codes, error bodies), cross-referenced against the [Threads API changelog](https://developers.facebook.com/docs/threads/changelog). See [Testing approach](/CONTRIBUTING.md#testing-approach).
- [ ] Every commit is cryptographically signed and shows GitHub's "Verified" badge. See [Branch strategy](/CONTRIBUTING.md#branch-strategy).
- [ ] `dart format .`, `dart analyze --fatal-infos`, `dart test`, and `dart pub publish --dry-run` all pass locally. See [Running locally](/CONTRIBUTING.md#running-locally).
- [ ] If public API surface changed, the [example](/example/threads_sdk_example.dart) and [API groups](/README.md#api-groups) section of the README are updated to match. See [PR expectations](/CONTRIBUTING.md#pr-expectations).
