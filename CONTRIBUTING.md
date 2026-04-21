# Contributing

Thanks for wanting to help. Here's everything you need to get up and running.

## Before you start

Open an issue before you open a PR. If an issue already covers what you want to do, link it. If not, file one first. You're welcome to open the PR at the same time if you're confident about the direction.

The only exception is trivial changes, like fixing a typo, a broken link, or a wording tweak. Those can go straight to a PR.

The reason we require an issue is that it's the durable record of the work. If a PR has to be reverted, we reopen the issue. If a contributor stops partway through, the issue is where we point so someone else can pick it up. Without an issue, the context vanishes the moment the PR closes.

## Development setup

You'll need Dart 3.11 or later. Check with `dart --version`.

```sh
git clone https://github.com/andeart/threads
cd threads
dart pub get
```

The generated JSON serialization files (`*.g.dart`) are checked in, but if you change any annotated model you'll need to regenerate them:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Running locally

These are the commands worth knowing before you open a PR:

```sh
# Format
dart format .

# Analyze (zero warnings, zero infos)
dart analyze --fatal-infos

# Test
dart test

# Publish dry-run (catches anything pub.dev would reject)
dart pub publish --dry-run
```

All four should pass cleanly. CI runs the same set.

## Testing approach

Tests live in `test/`. We use `package:http`'s `MockClient` to intercept HTTP calls, so no real network access is needed. Tokens and IDs in tests are just dummy strings like `'test-token'` or `'12345'`. No real credentials.

Mock responses should mirror what the Threads API actually returns today: field names, shapes, status codes, error bodies. A test that passes against a made-up payload gives a false sense of safety. When adding or updating a mock, cross-reference the relevant endpoint in the [Threads API docs](https://developers.facebook.com/docs/threads) and check the [Threads API changelog](https://developers.facebook.com/docs/threads/changelog) for recent changes that might affect the shape you're mocking.

When adding a new feature:
- Add a test that covers the happy path.
- Add a test for at least one error case (e.g. verify that a 4xx response from the API causes the SDK to throw the correct `ThreadsException` subclass).
- Keep test files parallel to the source files they cover (e.g. `test/publishing_test.dart` for `lib/src/publishing.dart`).

When fixing a bug:
- First write a test that reproduces the bug and fails against `main`.
- Then apply the fix, and confirm the same test now passes.
- Include both the failing test and the fix in the same PR.

Aim to cover every line of new code with tests. Anything uncovered tends to regress quietly, or get stripped out later by a "this doesn't look used" cleanup.

## Coverage

We hold total line coverage at 90% or higher. CI runs the suite with coverage and fails the build if the number drops below that, so a PR that removes a test without replacing it, or adds a branch with no test, will be caught before merge.

To run the same check locally:

```sh
# Run the suite and write coverage/lcov.info.
dart run coverage:test_with_coverage

# Check the total line coverage against the 90% floor.
dart run tool/check_coverage.dart --min-coverage 90
```

Generated files (`*.g.dart`) are excluded from the calculation since build_runner owns them. Everything under `lib/src/` counts.

The 90% bar is a floor, not a target. New changes are expected to keep coverage where it is, or raise it. If you're adding code that's genuinely hard to exercise from tests, flag it in the PR so we can talk about the right shape rather than quietly lowering the threshold.

## Code style

- Follow the existing conventions; the linter will catch most things.
- Public APIs get doc comments. Internal helpers don't currently need them.
- Avoid abbreviations in names. `accessToken` not `tok`, `httpClient` not `client` (when there's ambiguity).
- Enums expose a `value` string matching the literal string used in Threads API requests and responses, and a `fromValue` factory for parsing them back. Keep that pattern when adding enums.
- Models use `json_annotation` / `json_serializable`. Add `@JsonKey` for any field where the JSON key differs from the Dart name. Don't hand-write your own `toJson` / `fromJson` methods, let the generator produce them.

## Branch strategy

- Branch off `main`.
- Name branches descriptively: `add-gif-support`, `fix-rate-limit-retry`, etc.
- Open a PR against `main` when you're ready for review.
- Squash or tidy your commits before asking for review. One logical change per commit is ideal, but a small sequence of clean commits is fine too.
- All commits must be cryptographically signed (GPG or SSH). GitHub will show a "Verified" badge next to each signed commit. Unsigned commits will not be merged. If you haven't set this up before, GitHub's [signing commits docs](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits) cover both key generation and the git-side configuration.

## PR expectations

- The PR description should explain what changed and why, not just what the diff shows.
- Link to any relevant Threads API docs if you're adding support for a new endpoint.
- If you're changing public API surface, update the example and README to reflect it.
- CI must be green before merge.

If you're unsure whether something is in scope or have a question before starting, open an issue first. Easier to align on direction early than after a big diff.
