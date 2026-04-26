# Security

Thanks for taking the time to report a vulnerability. Here's how to do it and what to expect.

## Reporting a vulnerability

Please send security reports privately rather than as a public GitHub issue or post. Until a fix is released, public details mostly serve as a heads-up to anyone looking to target people who depend on this SDK, so keeping the report private gives those users a chance to upgrade before the issue is out in the open.

The primary channel is GitHub's [Private Vulnerability Reporting](https://github.com/byanuco/threads-dart/security/advisories/new). It puts the report directly in front of me, keeps the conversation private, and lets any eventual advisory tie back to the right CVE.

If that flow doesn't work for you, email `hello@byanu.co` instead. Either way, just pick one channel rather than sending the report through both, so the conversation doesn't end up split across two threads.

## Supported versions

The most recently published release of this package on pub.dev receives security fixes. Older releases may or may not get backports. I'll give it my reasonable best, but upgrading to the latest version is the most reliable path to a fix.

## Scope

A security issue here means something that compromises a user of this SDK in a way they couldn't reasonably mitigate themselves. Examples:

- Credential or token leakage by the SDK (e.g. logging an access token, sending it to the wrong host).
- Tampering with API requests or responses in a way the caller can't detect.
- Code execution triggered by parsing a Threads API response.
- A pinned dependency with a known exploitable vulnerability that reaches this SDK's surface.

Out of scope:

- Issues in the Threads API itself, please report those to Meta directly.
- Issues that require the attacker to already control the host machine or the developer's pub.dev credentials.
- Theoretical concerns without a concrete attack path against an SDK user.

## Response expectations

This is currently a solo-maintained package, so handling is best-effort. I'll aim to acknowledge any report within a few days, and to ship a fix or a clear explanation as quickly as the issue allows. There's no formal SLA, no bounty, and no compliance program behind the project, but every report will get a careful read and a real response from me.

## Credit

I'm happy to credit you by name, handle, or however you'd like to be referred to in the release notes and the GitHub Security Advisory for the fix. Just let me know in your report.
