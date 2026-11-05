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
| 1 | Shared palette, Material brand roles, button-text default, documentation | Complete |
| 2 | Shared fields, pickers, dialogs, loading indicators, reusable controls | Complete |
| 3 | Home, discovery, fund/NFO details, comparison, calculators, Freedom SIP | Complete |
| 4 | Investor, KYC, personalization, transaction, dashboard, support presentation | Complete |
| 5 | Final source audit, intentional exceptions, verification records | Complete; rendered acceptance pending |

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
- Phases 2 through 5 cover reviewed brand overrides and local widget themes.
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

## Phase 2 shared controls

Following explicit user approval, the following files under
`lib/common/widget/` now reuse the shared palette:

| File | Change |
| --- | --- |
| `text_form/text_field_component.dart` | Clickable helper text uses `Ucolors.primary`; non-clickable helper text retains its neutral color. |
| `showbottomsheet/datepicker.dart` | The desktop date picker uses `primary` with `onPrimary`; date limits and mobile picker behavior are retained. |
| `showbottomsheet/showbottomsheet.dart` | The desktop selection checkmark uses `primary`. |
| `animated/dialog_button.dart` | The dialog action text uses `primary`. |
| `animated/popups.dart` | The loading spinner uses `primary` with a `skyblue` lavender track. |
| `animated/custom_toast.dart` | `CustomLoadingDialog` uses a `primary` spinner. |
| `images/image_picker.dart` | Camera uses `primary` and Gallery uses `indigo` in both responsive branches; icon backgrounds retain their existing opacity. |
| `responsive/web_restriction_screen.dart` | The badge uses `primary` at its existing opacity, with a light lavender `textLight` icon on the dark surface. |

Existing buttons, OTP borders, sliders, and most field focus colors already
inherit the shared palette; they required no edits. Imports were added where
needed, and the modified Dart files were formatted. Semantic informational blue
in `ULoaders.info` and `CustomSnackbar`, warning/error/success colors, neutral
surfaces, provider assets, and commented examples are retained.

Public interfaces, callbacks, picker ranges, validation, dialog dismissal,
navigation, breakpoints, typography, and layout values are unchanged. No
controllers, bindings, repositories, APIs, or financial logic were edited.

## Phase 2 verification

- `dart format` completed for all eight modified Dart files.
- `flutter analyze --no-pub` on those files found no errors or warnings. It
  returned exit code 1 for five informational findings in existing code:
  three missing-brace notices in `popups.dart` and two deprecated Radio
  `groupValue` / `onChanged` properties in `showbottomsheet.dart`. Source review
  against HEAD confirmed these constructs predate Phase 2.
- `git diff --check` passed. Reviewed the diff for approved color substitutions,
  retained callbacks/layout values, and intentional semantic-color exceptions.
- Tests, builds, installation, and rendered comparisons were not run.

Runtime appearance and contrast still need device/browser review. Phase 3 was
subsequently approved separately; its implementation is recorded below.

## Phase 3 feature presentation

Following explicit user approval, the following files under `lib/features/`
reuse the shared brand tokens for the reviewed blue overrides:

| File | Change |
| --- | --- |
| `home/presentation/pages/home.dart` | Desktop hero gradient and fixed metric icons, goal action accent, links/buttons, hover fills, collection press feedback, and welcome text. |
| `home/presentation/pages/notification_page.dart` | Notification header fill and text only; existing read/unread row colors remain. |
| `home/presentation/widgets/smartcard.dart` | Featured-fund border, shadow, icon badge, label, and chevron. |
| `home/presentation/widgets/product_tool/compare_fund.dart` | Search focus border and add-fund icon. |
| `home/presentation/widgets/product_tool/widget/sipslidertile.dart` | `SipSliderTile3` defaults to `Ucolors.primary`; explicit caller colors remain supported. |
| `explore/presentation/pages/explore.dart` | Desktop fund-card hover gradient uses lavender tokens. |
| `fund_details/presentation/pages/fund_deatails.dart` | Comparison borders, retry controls, detail icons, NAV summary styling, manager chip, default decorative dashed line, and allocation tab indicator. |
| `fund_details/presentation/widgets/stock_allocation_items.dart` | Uniform category badge fill, border, and text; allocation percentage colors remain. |
| `nfo/presentation/page/nfo_details_page.dart` | All three active screen variants use the shared primary accent; decorative glow, NAV chips, and exit-load icons use matching lavender fills. |
| `freedom_sip/presentation/pages/freedom_sip_screen.dart` | The existing vertical card gradient retains its direction and three stops, using `[blue, blue, primary]`. |
| `freedom_sip/presentation/pages/sip_tenure_screen.dart` | Tenure slider uses `primary`; values, limits, and callbacks remain. |

These are color substitutions and required imports, plus Dart formatting.
The existing Home mobile widgets, Explore filters/pagination, NFO list, and
other calculator screens already inherit the palette or retain intentional
non-brand colors, so no edits were needed there. No formulas, model parsing,
controller logic, bindings, repositories, endpoints, lifecycle rules, navigation
targets, purchase arguments, responsive breakpoints, or layout values changed.

### Intentional Phase 3 exceptions

- Preserve fund NAV chart lines, allocation chart palettes, sector/holding
  percentage bars, chart legends, risk indicators, and financial return colors.
- Preserve Home profit/loss colors and existing non-blue category accents.
- Preserve notification read/unread row fills, avatar fills, and their conditions.
- Preserve NFO closed/active/launched/upcoming status colors and conditions.
  The Upcoming NFO tag now explicitly keeps its original `#1E40AF` text because
  the screen's `primaryColor` identifier has become the purple brand alias.
- Preserve neutral/slate `Colors.blueGrey` text and all provider artwork.
- Preserve commented examples and existing public names, including the three
  NFO detail screen variants; no consolidation or unrelated cleanup was done.

## Phase 3 verification

- Ran `dart format` on all eleven modified Dart files.
- Recorded baseline and final `flutter analyze --no-pub` results for the same
  eleven files. Baseline: no errors, one warning, fourteen informational
  findings. Final: no errors, the same warning, and twelve informational findings.
- Compared diagnostic messages, paths, and multiplicities while ignoring shifted
  line/column positions: no new findings. The final command returns exit code 1
  for the existing unused local `nfoData` warning and remaining informational
  notices. Replacing the touched hover color with `withValues` and removing a
  redundant `const` during a color substitution eliminated two prior notices.
- `git diff --check` passed. Reviewed feature diffs for color-only intent and
  formatter changes, and reviewed remaining blue matches against the exceptions
  above. Existing Phase 2 edits were preserved.
- No tests, builds, installations, app launches, or rendered comparisons ran.

Runtime mobile/tablet/web appearance, hover/press states, and contrast remain
unverified. Phase 4 was subsequently approved separately; its implementation
is recorded below.

## Phase 4 investor and transaction presentation

Following explicit user approval, reviewed brand overrides now reuse the
shared purple/lavender palette in the following 31 Dart files. Paths in this
table are relative to `lib/`.

| File | Change |
| --- | --- |
| `core/app_config/presentation/update_required_screen.dart` | Update badge fill/border and changelog link accent. |
| `core/utils/helper/app_open_alert_coordinator.dart` | Personal-details and bank-link reminder icon colors only. |
| `features/personalization/presentation/pages/profile.dart` | App-lock switch active-thumb color only. |
| `features/personalization/presentation/pages/risk_profile.dart` | Back link accent. |
| `features/personalization/presentation/widgets/help_support.dart` | Helpdesk, contact-support, and About link icons. |
| `features/kyc/presentation/pages/kyc_screen.dart` | Existing `kWebPrimary` alias, active loading spinner, field hint fill, and option selection fill. |
| `features/questions/presentation/pages/question_page.dart` | Question-progress track fill. |
| `features/questions/presentation/pages/question1.dart` | Question-progress fills and selected-answer text. |
| `features/cart/presentation/pages/cart_page.dart` | Dialog action text, checkout summary fills, and step-up section fill. |
| `features/cart/presentation/pages/invest_now_page.dart` | Continue button and step-up section fill. |
| `features/sip_process/presentation/pages/select_funds_screen.dart` | Profile-side panel dark brand fill. |
| `features/sip_process/presentation/pages/monthly_sip_screen.dart` | Profile-side panel, summary panel, and light summary text. |
| `features/sip_process/presentation/pages/investing_approach_screen.dart` | Profile panels, option selection accents, and selected-card gradient. |
| `features/sip_process/presentation/pages/payment_screen.dart` | Brand shadows and payment-option icon accents. |
| `features/sip_process/presentation/pages/sip_payement_screen.dart` | Payment selection fill/border and submit button; light lavender foregrounds for calendar, selected labels, and total on dark surfaces. |
| `features/mfu/presentation/pages/purchase_page.dart` | Private brand aliases, selected dividend-option fills, and brand shadow. |
| `features/mfu/presentation/pages/redeem_page.dart` | Selected radio-row fill, goal-linked panel styling, and empty/bank icon fills. |
| `features/dashboard/presentation/pages/dashboard.dart` | Links, date accents, goal controls, placeholders, mobile header/summary gradient, sorting controls, statement icon, and goal-link dialog avatar. |
| `features/dashboard/presentation/pages/web_portfolio_screen.dart` | Header gradient/shadow, sorting controls, and empty-state icon fills. |
| `features/dashboard/presentation/pages/web_transactions_screen.dart` | Filter-count badge fill. |
| `features/dashboard/presentation/widgets/portfolio_summary.dart` | Heading gradient. |
| `features/support_tickets/presentation/pages/create_ticket_page.dart` | Attachment picker icons/fills, submit button, and attachment preview icon. |
| `features/support_tickets/presentation/pages/ticket_detail_page.dart` | Attachment picker, ticket identifier, reopen/reply/send actions. |
| `features/support_tickets/presentation/pages/tickets_list_page.dart` | Raise-ticket button, filter selection, and empty/error action styling. |
| `features/support_tickets/presentation/widgets/ticket_card.dart` | Ticket identifier accent. |
| `features/support_tickets/presentation/widgets/ticket_chat_bubble.dart` | Agent branding and user message fill. |
| `features/support_tickets/presentation/controllers/ticket_detail_controller.dart` | Reopen-confirmation button fill and required color import only. |
| `features/goal/presentation/pages/goaldetails.dart` | Edit/link controls, sliders, count badges, detail/calendar icons, and links. |
| `features/goal/presentation/pages/goalsuccess.dart` | Decorative page background. |
| `features/goal/presentation/widget/add_fund_bottom_sheet.dart` | Header icon, progress label, and informational count chip styling. |
| `features/wishlist/presentation/pages/watchlist_page.dart` | Fund-action icon background. |

Primary accents use `Ucolors.primary`, dark brand panels use `blue` / `homeInk`,
and light fills use `skyblue` / `skyblue1`. Foregrounds remain paired with their
surfaces. No new packages, assets, public names, routes, or API fields were added.

The private purchase shadow now derives from `Ucolors.primary` using
`withAlpha(0x1A)`, preserving the original alpha byte. Its three shadow lists
are no longer const because the shared-color alpha expression is evaluated
at runtime; offsets, blur radii, and other shadow parameters are retained.

### Intentional Phase 4 exceptions

- Preserve chart lines, sparklines, allocation segment/legend colors, goal
  category/progress palettes, financial gain/loss colors, and investment-type
  colors. The dashboard wallet icon and fill retain their original colors
  because its icon color also drives a sparkline.
- Preserve dashboard SIP/Lumpsum type chips, pending-allotment chips/dialogs,
  and portfolio lifecycle banners.
- Preserve profile verification badges, nominee role/status badges and detail
  category colors, document-category colors, and payment verification states.
- Preserve ticket Open summary, status badges, priority badges, and destructive
  close actions. The general selected-filter accent is a separate brand color.
- Preserve informational notices and dividend-help colors, monthly-SIP
  informational banner, goal on-track/status indicators, mandate waiting-state
  presentation, provider artwork, and the existing coming-soon illustration.
- Preserve estimated-return value styling in the investment preview, all
  neutral/slate text/surfaces, and commented examples (including the inactive
  KYC screen block).

No financial formulas, amounts, validations, date limits, requests, models,
controllers' business logic, bindings, repositories, navigation targets,
session handling, KYC/CAN/mandate sequences, polling, ticket callbacks, or
transaction submission behavior changed. The helper/controller edits above
only change UI colors and add the required import.

## Phase 4 verification

- Recorded baseline and final `flutter analyze --no-pub` results for the same
  31 Dart files: both report no errors, 27 existing warnings, and 53 existing
  informational findings. The command returns exit code 1 for those findings.
- Compared diagnostic messages, file paths, and multiplicities while ignoring
  shifted line/column positions: no added or removed findings.
- Ran `dart format` on the 31 modified Dart files. Retained the original
  formatting outside the color edits in the two goal files, fund-selection
  screen, app-open helper, and ticket-detail controller to avoid broad unrelated
  diffs. The other modified Dart files retain formatter output.
- `git diff --check` passed. Source/diff review covered the approved file scope,
  shared-color substitutions, foreground/background pairs, preserved semantic
  colors, and unchanged callbacks, formulas, and responsive layout values.
- Existing Phase 2 and Phase 3 edits were preserved.
- No tests, builds, installations, app launches, API calls, or rendered
  comparisons ran as part of Phase 4.

Rendered mobile/tablet/web appearance and contrast remain unverified. This
phase does not establish production readiness for any financial or KYC flow.
Phase 5 was subsequently approved separately; its final audit is recorded below.

## Phase 5 final source audit

Following explicit user approval, reviewed the shared palette, Material theme
roles, theme entry point, local theme overrides, remaining named blue/indigo/cyan
colors, legacy brand hex values, and other blue-toned literal candidates across
`lib/`. Matches in commented code were reviewed separately from active styling.

The audit found a small set of remaining brand overrides. Phase 5 changes these
five Dart files and this guide:

| File | Final correction |
| --- | --- |
| `lib/navigation_menu_bar.dart` | Sidebar selected text/icons use `primary`, selected fill uses `skyblue`, scrollbar thumb uses `blue`, and profile-tab selection uses `primary`. Callbacks and navigation indices remain unchanged. |
| `lib/features/personalization/presentation/widgets/kyc_details.dart` | Update-action foreground/border and update-dialog icon ring/button use shared tokens. Secure/compliant badges, the informational help strip, and visibility conditions retain their definitions. |
| `lib/features/personalization/presentation/widgets/additional_info.dart` | Section-heading icons use `primary`; add the required color import. |
| `lib/features/personalization/presentation/widgets/download_statement.dart` | Decorative header/preview fills, inactive duration icon, and disabled loading-button fill use shared tokens. The loading spinner uses dark `blue` on light lavender; loading conditions and download actions remain unchanged. |
| `lib/features/fund_details/presentation/pages/fund_deatails.dart` | The expansion-card local theme copies the inherited color scheme and sets the shared primary color. Existing local typography defaults and transparent divider configuration remain. |

### Consolidated exception record

Remaining blue matches are intentional in the reviewed contexts below. Public
legacy names such as `Ucolors.blue`, `gradientBlue`, and `kWebPrimary` remain for
compatibility; their names do not determine their current color values.

| Context | Reason retained / representative locations |
| --- | --- |
| Financial charts and data categories | Fund NAV and allocation charts, dashboard benchmark/sparkline series, SIP projection chart, goal value legends/category palettes, SIP/Lumpsum type chips, and investment-preview return styling. |
| Transaction and investment lifecycle | Pending-allotment chips, portfolio lifecycle banners, mandate waiting-state presentation, and existing goal on-track/status indicators. |
| Identity and verification | Profile/sidebar verification icons, KYC submission snackbar, Secure & Compliant indicators, nominee role/status/detail categories, document categories, and payment verification states. |
| Support semantics | Ticket Open summary, status/priority badges, and destructive close actions. General support action controls use purple. |
| Information and notification state | Shared info overlays/snackbars, NFO Upcoming status, notification read/unread row styling, monthly-SIP information, dividend help, KYC help strip, and statement information notices. |
| Neutral styling | Slate/blue-grey text, neutral surfaces, borders, disabled neutral text, and existing non-brand Material roles. |
| Existing artwork and dedicated design palettes | Provider/bank/AMC/social assets, coming-soon illustration, dedicated goal palette, Home video/support decorative colors, and retained unused Home navigation design definitions. |
| Inactive source examples | Commented examples and the inactive KYC screen block retain their original values. |

`Utheme.lightTheme` remains the theme supplied to the application. Shared
primary/container foreground pairs and existing fonts were reviewed. No route,
binding, repository, model, API, formula, polling, session, asset-registration,
or navigation-selection logic was changed by Phase 5.

## Final verification record

- Baseline and final app-wide `flutter analyze --no-pub lib` both report
  **0 errors, 40 existing warnings, and 153 informational findings** (193 total).
  The command returns exit code 1 for the existing findings.
- Compared diagnostic messages, paths, and multiplicities while ignoring
  shifted source positions: no added or removed findings after Phase 5.
- Ran `dart format` on the five Phase 5 Dart files. Retained existing formatting
  outside the color edits in `kyc_details.dart` and `download_statement.dart`
  to keep the final corrections focused; the other three retain formatter output.
- `git diff --check` passed. Git emitted normal LF-to-CRLF conversion notices.
- Reviewed the Phase 5 diffs, required imports, remaining color matches,
  theme wiring, unchanged callbacks/selection conditions, and preservation of
  the earlier phases' work.
- No Flutter/widget/unit/other tests, builds, installations, app launches,
  external API calls, or rendered comparisons were run.

All five source-work phases are complete. This record establishes static-source
verification only. Rendered mobile/tablet/web layouts, hover/press/focus/disabled
states, text scaling, contrast, browser history, system back behavior, and live
KYC/cart/goal/portfolio/MFU interactions remain unverified at runtime.

For future brand styling, use `Ucolors.primary` for primary actions, `blue` or
`homeInk` for dark brand surfaces, `skyblue` / `skyblue1` for lavender fills, and
the corresponding foreground tokens. Preserve explicit semantic/data/provider
colors according to their role and reuse the application color scheme in local
theme overrides.
