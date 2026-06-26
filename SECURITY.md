# Security Policy

RichText renders caller-provided HTML in SwiftUI using WebKit. Security-sensitive behavior can include generated HTML/CSS/JavaScript, `WKWebView` configuration, link handling, media click handling, and privacy metadata.

## Supported Versions

Security fixes are prioritized for the latest released major version.

| Version | Supported |
| --- | --- |
| 3.x | ✅ |
| 2.x | Case-by-case critical fixes |
| < 2.0 | ❌ |

## Reporting a Vulnerability

Please do not disclose security issues publicly before maintainers have had a chance to review them.

Preferred reporting path:

1. Use GitHub's private vulnerability reporting or Security Advisory flow for this repository when available.
2. If private reporting is not available, open a GitHub issue with a high-level summary only and request a private contact path. Do not include exploit details, proof-of-concept payloads, or sensitive app data in a public issue.

Helpful details to include privately:

- RichText version or commit SHA
- iOS/macOS version and Xcode/Swift version
- Minimal HTML/CSS/JavaScript input that reproduces the issue
- Expected behavior vs. observed behavior
- Impact assessment, such as unsafe navigation, script execution, data exposure, denial of service, or privacy manifest concerns

## Scope

In scope:

- Unsafe behavior caused by RichText-generated wrapper HTML, CSS, or JavaScript
- `WKWebView` navigation, link opening, or media click handling issues
- Regressions that expose app data or unexpectedly load remote content
- Privacy manifest or package-distribution security concerns

Out of scope:

- Vulnerabilities in app-specific HTML sources or sanitization pipelines outside RichText
- Issues that require a consuming app to intentionally execute untrusted code outside RichText's API
- General WebKit vulnerabilities that are not caused or amplified by RichText

## Maintainer Response

Maintainers will try to acknowledge valid reports promptly, investigate reproducible issues, and coordinate fixes and release notes when a security update is needed.
