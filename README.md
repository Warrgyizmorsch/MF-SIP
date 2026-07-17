# MF SIP

MF SIP is a private, cross-platform Flutter client for mutual-fund discovery, SIP planning, investor onboarding, KYC, portfolio management, and MF Utility (MFU) transaction workflows.

The package name is `my_sip`, and the current application version is `1.0.0+1`. The client is feature-rich but still under active development: several investment/payment paths contain UAT data or placeholder behavior and must not be treated as production-ready without the checks in [Production readiness](#production-readiness).

## Contents

- [Features](#features)
- [Architecture](#architecture)
- [Technology stack](#technology-stack)
- [Supported platforms](#supported-platforms)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Configuration](#configuration)
- [Common commands](#common-commands)
- [Testing and code quality](#testing-and-code-quality)
- [Project structure](#project-structure)
- [Integration documentation](#integration-documentation)
- [Production readiness](#production-readiness)

## Features

| Area | Current capabilities |
| --- | --- |
| Onboarding and authentication | Splash/onboarding flow, registration, phone/email OTP login, Google sign-in, Firebase device-token registration, and session persistence. |
| Mutual-fund research | Fund discovery and filters, fund-house browsing, fund details, NAV history, portfolio analysis, comparison, NFO listings, recently viewed funds, and watchlists. |
| Planning tools | SIP, lump-sum, SWP, and step-up calculators; goal-based planning; Freedom SIP and investment-approach user interfaces. |
| Investment preparation | Cart management, amount distribution, SIP scheduling screens, mandate checks, and payment/approval WebViews. Some checkout orchestration remains partial. |
| KYC | Existing-KYC checks and a Signzy-based onboarding chain covering identity/address steps, bank penny-drop verification, document upload, captcha, e-sign, verification status, and CAMS response handling. |
| MFU | CAN registration/status, CAN bank validation, UPI AutoPay mandate creation/status, normal transactions, systematic transactions, and generic MFU calls through the application backend. Some active flows still use UAT values. |
| Portfolio and goals | Transaction and portfolio dashboards, goal creation, fund allocation, goal details, and separate responsive web views. Some dashboard cards remain mock/static data. |
| Profile and servicing | Personal details, risk assessment, bank accounts, nominees, KYC/documents, capital-gain and account-statement requests, app lock, and support/legal WebViews. |
| Cross-platform UX | Mobile bottom navigation, web sidebar/header with path-based URLs, responsive breakpoints, network-loss overlay, cached images, video/YouTube content, push notifications, and optional biometric/device-credential app lock. |

## Architecture

The repository uses feature-oriented modules with a Clean Architecture-style separation. Most complete features contain `data`, `domain`, and `presentation` layers; smaller or prototype features may contain only presentation code.

```text
Widgets / pages
      |
GetX controllers and route bindings
      |
Domain use cases
      |
Repository contracts
      |
Repository implementations
      |
Remote data sources
      |
NetworkServicesApi (Dio)
      |
Application backend / MF data providers / Signzy / Firebase
```

The main runtime pieces are:

- `lib/main.dart` initializes Flutter bindings, path-based web URLs, Firebase, and the persistent `SessionManager` before starting the app.
- `lib/my_app.dart` builds `GetMaterialApp`, the responsive shell, the no-internet overlay, and the optional biometric/device-credential lock screen.
- `lib/config/routes/` defines named routes and route-to-binding mappings. Web routes open inside `NavigationMenuBar`; mobile uses the same page registry without the web wrapper.
- `lib/core/bindings/bindings.dart` registers global services and core authentication, discovery, and cart dependencies. Feature bindings register their own data sources, repositories, use cases, and controllers.
- `lib/core/network/network_api_service.dart` wraps Dio for JSON, form, multipart, byte-download, and direct S3 requests. Interceptors attach bearer tokens, log debug traffic, map HTTP failures, and attempt token refresh.
- `lib/services/session_manager.dart` owns authentication, user, risk, KYC, onboarding, recent-fund, notification, and app-lock state. Mobile uses `flutter_secure_storage`; web uses `SharedPreferences`/browser storage.
- API operations generally return `Either<Result<T>, ApiError>` and are transformed from data models into domain entities before reaching controllers.

GetX provides routing, reactive state, and dependency injection. Responsive behavior combines `flutter_screenutil` with `responsive_framework`; the configured breakpoints are mobile `0–450`, tablet `451–800`, desktop `801–1920`, and 4K above `1920`.

## Technology stack

| Concern | Libraries/services |
| --- | --- |
| UI | Flutter Material/Cupertino, `flutter_screenutil`, `responsive_framework`, `flutter_svg`, custom Roboto and Inter fonts |
| State, routing, DI | GetX |
| Networking | Dio, multipart uploads, application bearer tokens, S3 uploads |
| Domain/error flow | `dartz`, `equatable`, `Result<T>`, `ApiError` |
| Persistence | `flutter_secure_storage` on mobile; `shared_preferences` on web and for notification history |
| Firebase | Core, Authentication, and Cloud Messaging |
| Identity/device | Google sign-in, local authentication, device info, permissions, image picker, geolocation |
| Content | Cached network images, SVG, WebView/InAppWebView, YouTube and video players |
| Charts | `fl_chart`, Syncfusion gauges, percentage indicators |
| External data/services | Application backend, AdvisorKhoj, MFAPI.in, Signzy, Razorpay IFSC lookup, Firebase, and YouTube |

## Supported platforms

| Platform | Repository state |
| --- | --- |
| Android | Primary target. Firebase/Google Services and application ID `com.kirtihinger.mfsip` are configured. |
| iOS | Primary target with deployment target 13.0. Bundle identifiers are currently inconsistent between build configurations; align them before signing. |
| Web | Primary target. Uses path URL strategy, browser storage, responsive shell navigation, and Firebase web options. The hosting server must rewrite application routes to `index.html`. |
| macOS | Runner and Firebase options exist, but the bundle identifier still uses the template `com.example.mySip`. Treat it as not release-configured. |
| Windows | Runner and Firebase options exist; functional/release validation is still required. |
| Linux | A runner exists, but `DefaultFirebaseOptions` deliberately throws `UnsupportedError` for Linux. The app will not complete startup without adding Linux Firebase handling or bypassing Firebase initialization. |

## Prerequisites

- Flutter stable. Use Flutter `3.38.4` or newer with Dart `3.11` or newer to match the dependency resolution in the current workspace. Dart must remain below `4.0.0`.
- The platform toolchain required by the target: Android SDK for Android, Xcode and CocoaPods for Apple platforms, or a supported browser for web.
- Access to the configured application backend and third-party services. This repository contains the Flutter client, not the backend services.
- A Firebase project and platform registrations when replacing the committed default Firebase configuration.

Verify the local toolchain before fetching packages:

```bash
flutter doctor -v
flutter devices
```

## Setup

From the repository root:

```bash
flutter pub get
flutter run -d chrome
```

To run on a connected phone, emulator, simulator, or desktop target:

```bash
flutter devices
flutter run -d <device-id>
```

Examples:

```bash
flutter run -d chrome
flutter run -d windows
flutter run -d macos
```

For iOS/macOS development, use macOS with Xcode configured. Flutter normally manages CocoaPods; if pods need to be restored manually, run `flutter pub get` first and then:

```bash
cd ios
pod install
cd ..
```

If stale generated artifacts cause build failures:

```bash
flutter clean
flutter pub get
```

## Configuration

### API environments

API hosts are compile-time constants in `lib/core/utils/constant/appUrl.dart`. There is currently no `.env`, flavor, or `--dart-define` configuration layer.

| Constant | Purpose |
| --- | --- |
| `Appurl.baseUrl` | Primary MF SIP application backend. |
| `Appurl.baseUrl2` / `Appurl.advUrl` | AdvisorKhoj mutual-fund data APIs. |
| `Appurl.navUrl` | MFAPI.in NAV endpoint. |
| `Appurl.kycUrl` | Signzy production or preproduction host, selected by `Appurl.isProduction`. |

`Appurl.isProduction` is currently `true`, so Signzy requests target production. Change environment selection deliberately and never commit service passwords, bearer tokens, private signing material, MFU encryption keys, or personal test data.

Most data sources send absolute URLs. The fallback Dio base URL in `NetworkServicesApi` is a placeholder and must not be used as a real backend address. If environment support is added, update both ordinary requests and token-refresh behavior to use the same selected backend.

### Firebase

The default Firebase project is represented by:

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `firebase.json`

When moving to another Firebase project, regenerate configuration with FlutterFire and verify Authentication, Google sign-in, Cloud Messaging, application IDs, bundle IDs, signing certificates, and web origins for every target. Do not hand-copy credentials between environments.

### Platform identifiers and signing

- Android namespace/application ID: `com.kirtihinger.mfsip`.
- iOS profile uses `com.kirtihinger.mfsip`, while debug/release currently use `com.example.mySip`; these must be unified.
- macOS currently uses `com.example.mySip`.
- Android release builds currently use the debug signing configuration. Add a protected release keystore configuration before distribution.

### Assets and fonts

Assets are registered in `pubspec.yaml` from:

- `assets/images/`
- `assets/images/onboarding/`
- `assets/logo/`
- `assets/icon/`
- `assets/fonts/Roboto/static/`

Roboto and Inter font families are configured explicitly in `pubspec.yaml`. Add new asset directories there before referencing them in Dart code.

## Common commands

### Development

```bash
flutter pub get
flutter run -d <device-id>
flutter run -d chrome
flutter run --profile -d <device-id>
```

### Formatting and analysis

```bash
dart format lib test
flutter analyze
```

To check formatting without changing files:

```bash
dart format --output=none --set-exit-if-changed lib test
```

### Tests

```bash
flutter test
flutter test --coverage
```

See [Testing and code quality](#testing-and-code-quality) before relying on these as passing gates.

### Builds

```bash
# Android
flutter build apk --debug
flutter build appbundle --release

# Web
flutter build web --release

# Apple platforms (macOS host required)
flutter build ios --release
flutter build macos --release

# Windows (Windows host required)
flutter build windows --release
```

Do not distribute current Android or Apple release artifacts until signing, bundle identifiers, environment selection, and the production-readiness items below are resolved.

## Testing and code quality

The project uses `flutter_lints`, but `analysis_options.yaml` currently suppresses `unused_element`, `unused_field`, and `use_key_in_widget_constructors`. `flutter analyze` may report pre-existing issues and does not currently enforce unused-code cleanup.

The only file under `test/` is the original Flutter counter-template widget test. It does not describe the current application and should be replaced before `flutter test` is used as a release gate. There are no repository CI workflows for Flutter analysis, tests, or builds.

Recommended coverage priorities are:

1. Calculator and investment-allocation formulas.
2. Authentication/session persistence and token refresh.
3. KYC state transitions, document uploads, polling, and error handling.
4. CAN, mandate, normal-transaction, systematic-transaction, and callback flows.
5. Cart idempotency, amount constraints, retries, and checkout orchestration.
6. Web route restoration and mobile/web navigation behavior.

## Project structure

```text
MF-SIP/
├── lib/
│   ├── main.dart                 # Startup: Firebase, URL strategy, session
│   ├── my_app.dart               # Root app, responsiveness, app lock
│   ├── navigation_menu_bar.dart  # Mobile/web application shell
│   ├── config/routes/            # Route constants and GetPage registry
│   ├── core/
│   │   ├── bindings/             # Global GetX dependency registration
│   │   ├── network/              # Dio client and interceptors
│   │   └── utils/                # API types, constants, theme, helpers, calculators
│   ├── common/                    # Shared widgets and presentation helpers
│   ├── services/                  # Session, Firebase, connectivity, image services
│   └── features/
│       ├── authentication/        # Login, registration, OTP, Google sign-in
│       ├── cart/                  # Cart CRUD and investment allocation
│       ├── dashboard/             # Portfolio and transaction dashboards
│       ├── explore/               # Fund discovery and filters
│       ├── freedom_sip/           # Freedom SIP presentation flow
│       ├── fund_details/          # Fund data, charts, analysis, comparison
│       ├── goal/                  # Goal planning and fund allocation
│       ├── home/                  # Home experience and calculators
│       ├── kyc/                   # Signzy/CAMS KYC workflow
│       ├── mfu/                   # CAN, mandate, and transaction integration
│       ├── nfo/                   # New fund offers
│       ├── onboarding/            # Splash and onboarding pages
│       ├── personalization/       # Profile, risk, bank, nominee, statements
│       ├── sip_process/           # SIP selection and payment preparation
│       └── wishlist/              # Watchlist CRUD
├── assets/                        # Images, icons, logos, and fonts
├── docs/
│   ├── kyc/                       # Signzy/KYC source-derived references
│   └── mfu/                       # MFU source-derived references
├── test/                          # Flutter tests (currently template-only)
├── android/ ios/ web/             # Primary platform runners
├── macos/ windows/ linux/         # Additional scaffolded runners
├── pubspec.yaml                   # Package, dependencies, assets, fonts
└── firebase.json                  # FlutterFire project mapping
```

## Integration documentation

Detailed, source-derived documentation is available in the repository:

- [KYC documentation index](docs/kyc/README.md)
- [KYC implementation guide](docs/kyc/KYC_IMPLEMENTATION_GUIDE.md)
- [MFU documentation index](docs/mfu/README.md)
- [MFU implementation guide](docs/mfu/MFU_IMPLEMENTATION_GUIDE.md)
- [Complete generated MFU reference](docs/mfu/generated/MFU_COMPLETE_DOCUMENTATION.md)

The generated KYC and MFU references preserve the original API field names and examples. Use them alongside provider onboarding details; do not infer missing production credentials or endpoint behavior.

## Production readiness

This repository should currently be treated as a development/UAT client. Before handling production investor data or money:

- Replace hardcoded UAT identities, CANs, bank data, schemes, VPAs, amounts, and placeholder responses with authenticated user/session data.
- Complete the cart-to-MFU checkout path and add transaction-status/callback reconciliation and idempotency.
- Replace the placeholder SIP endpoint and all static dashboard, projection, return, tax, and fund values with validated data.
- Move environment selection out of source constants and separate development, UAT, and production configuration.
- Remove committed/commented service tokens and client-side provider passwords; rotate any exposed credentials.
- Redact authorization headers and PAN, Aadhaar, bank, CAN, mandate, and transaction payloads from logs.
- Review web token storage and add the required browser security controls.
- Remove any WebView TLS-certificate bypass and validate every redirect/callback origin.
- Configure release signing, bundle identifiers, minification/obfuscation as appropriate, Firebase restrictions, and platform permissions.
- Correct and test token refresh against the selected backend rather than the placeholder Dio base URL.
- Add unit, widget, integration, and end-to-end tests plus CI gates for analysis and release builds.
- Complete a financial-calculation, security, privacy, KYC/AML, and regulatory review before release.
