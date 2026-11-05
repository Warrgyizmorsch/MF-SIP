# App-wide purple theme migration

## Scope and approvals

The user approved a phased migration of app branding to Home's existing purple
palette. Phase 1 changes shared definitions only. Pause for approval after each
phase; list and review the exact files for each subsequent phase before editing.

No tests, builds, or installations are authorized. Verification is limited to
formatting, static analysis, and source review. Runtime appearance, responsive
rendering, interaction states, and contrast need device/browser review.

## Progress

| Phase | Scope | Status |
| --- | --- | --- |
| 1 | Shared palette, Material brand roles, button-text default, documentation | Complete; paused before Phase 2 |
| 2 | Shared fields, pickers, dialogs, loading indicators, reusable controls | Awaiting approval |
| 3 | Home, discovery, fund/NFO details, comparison, calculators, Freedom SIP | Awaiting approval |
| 4 | Investor, KYC, personalization, transaction, dashboard, support presentation | Awaiting approval |
| 5 | Final source audit, intentional exceptions, verification records | Awaiting approval |

## Phase 1 files

- `lib/core/utils/constant/colors.dart`: retain public names and map brand aliases
  and generic gradients to the existing Home palette.
- `lib/core/utils/theme/theme.dart`: align Material brand roles while retaining
  existing typography, layout, neutral surfaces, and error roles.
- `lib/core/utils/constant/text_style.dart`: change only the default color of
  `AppTextStyles.button()`. Explicit caller colors, fonts, sizes, and weights stay.
- `assets/home/README.md`: describe the shared palette and link this guide.
- `docs/APP_PURPLE_THEME_MIGRATION.md`: record scope, mappings, and verification.

## Shared palette and legacy names

| Existing name | Shared source | Value / purpose |
| --- | --- | --- |
| `primary`, `secondary`, `hometxtblue`, `textFormEnabled` | `homeHeaderStart` | `#5B3FDF`, primary brand |
| `blue`, `darkBlue`, `primary3` | `homeHeaderEnd` | `#0E176F`, dark brand |
| `indigo` | `homeSelectedNavigation` | `#3129A2`, selected accent |
| `skyblue`, `secondaryContainer` | `homeSelectedNavigationFill` | `#EEEDF9`, selected lavender fill |
| `skyblue1` | `homeKycStart` | `#F2F1FB`, light lavender fill |
| `textLight` | `homeOnboardingText` | `#E9EAF2`, light text on branded fills |
| `primaryContainer` | `blue` | Legacy dark statement-control fill |
| `onPrimary`, `onPrimaryContainer` | `white` | `#FFFFFF`, foreground on legacy dark fills |

Public identifiers remain unchanged for backward compatibility. These aliases
also affect existing callsites, including filter accents, onboarding/profile
fills, payment-card presentation, and statement selection. No feature callbacks,
requests, amounts, dates, or transaction state logic are changed in this phase.

## Generic gradients

Directions, stop positions, and the number of colors are retained:

| Gradient | Colors |
| --- | --- |
| `backgroundGradient` | `[primary, blue]` (already migrated) |
| `premiumDarkGradient` | `[homeInk, blue]` |
| `modernFintechGradient` | `[primary, blue]` |
| `deepOceanGradient` | `[indigo, blue, homeInk]` |
| `gradientBlue` | `[blue, indigo, primary]`, stops `[0, 0.55, 1]` |

The dedicated goal-planning gradients and bank-specific `icicibankGradient`
retain their existing definitions.

## Material theme roles

`Utheme.lightTheme` keeps its existing public interface and copies the base theme:

| Role | Value |
| --- | --- |
| `primaryColor` / `colorScheme.primary` | `primary` |
| `primaryColorLight` | `skyblue1` |
| `primaryColorDark` | `blue` |
| `colorScheme.onPrimary` | `white` |
| `colorScheme.primaryContainer` / `onPrimaryContainer` | `skyblue1` / `blue` |
| `colorScheme.secondary` / `onSecondary` | `indigo` / `white` |
| `colorScheme.secondaryContainer` / `onSecondaryContainer` | `skyblue` / `homeInk` |
| `colorScheme.surfaceTint` | `primary` |

The legacy `Ucolors.primaryContainer` has historically meant a dark filled
control, so it intentionally differs from the light Material container role.
Foreground/background pairs must be preserved when reviewing later callsites.
The app-wide Roboto theme and Home's Inter helper remain as configured.

## Intentional exclusions and remaining work

- Preserve financial return/risk colors, chart-series/category colors, and
  transaction/status indicators unless separately reviewed and approved.
- Preserve success, warning, error, and informational colors, including the
  existing `infoBanner` / `infoBannerBorder` definitions.
- Preserve provider, payment, bank, AMC, and social-brand artwork and colors.
- Preserve neutral surfaces, outlines, borders, and non-brand color-scheme roles.
- Retain commented code. Review active callsites instead of blanket replacement.
- Later phases cover hardcoded brand colors and local widget theme overrides.
- No package, route, binding, repository, API, session, KYC sequence, polling,
  financial calculation, transaction reference, or callback behavior changes.

## Phase 1 verification

- Formatting: `dart format` on the three modified Dart files completed with no
  further changes.
- Targeted static analysis: `flutter analyze --no-pub` on those three files found
  no errors or warnings. It returned exit code 1 for the existing informational
  `constant_identifier_names` finding on `Ucolors.Orange`; that public name is
  retained.
- Diff and source review: `git diff --check` passed. Reviewed palette mappings,
  foreground/background pairs, preserved semantic/provider colors, typography,
  and the scope of modified files.
- Tests, builds, installation, and rendered comparisons: not run.

No runtime or production-readiness claim is made by this styling phase.
