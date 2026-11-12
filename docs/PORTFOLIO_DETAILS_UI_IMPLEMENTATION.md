# Portfolio details UI implementation

Reference: Figma file `Ud1D8521VyPLVwKdFR0VLG`, node `717:4543`, and the three
`Create a Vesyless UI (Copy)` images under `assets/figma_UI/`.

Current status: the three shared-styling migration phases are complete as of
12 November 2026. The final migration review appears at the end of this report;
earlier phase notes retain their intermediate implementation history.

## Approved scope

Implement the reference screen in phases and pause after each phase. Exclude
Exit Load & Redemption Forecast from the details page and any additional-details
sheet. Existing redemption request fields and transaction rules stay in their
current flows.

## Phase 1: header and holding card

Implemented on 11 November 2026.

- Add the reference navy/purple header, exact exported back icon, and overlapping
  white holding card. At 430 logical pixels, the header is 174 pixels high,
  navigation row 76 pixels high, and the card starts at 96 pixels, before the
  device's safe-area inset. Content grows for longer data and larger text.
- Reuse Plus Jakarta Sans through the existing typography helper and shared
  palette tokens where they match the reference.
- Display live fund name/logo, folio, linked goal, holding status, NAV/date,
  invested/current value, gain/return and units. Negative returns retain their
  minus sign. Relative logo URLs are resolved against the existing backend.
- Plan and option are displayed only when explicitly present in the supplied
  fund name. Missing values use a dash. AMC name is used as the available fund
  description: asset class/category are not exposed by the holding entity.
- Label the footer with the NAV's actual date rather than claiming that all
  holding data was updated today.
- Remove the excluded forecast section and exit-load badge/metric from this
  page's displayed layouts. The existing forecast builder is retained but is
  no longer mounted. Existing model fields and redemption payloads remain.
- Preserve the current desktop breakpoint, back navigation, status banners,
  transaction list, SIP schedule and existing action bar for this phase.

The new reusable presentation widgets are in
`lib/features/dashboard/presentation/widgets/portfolio_holding_header.dart`.
The back icon is registered under `assets/portfolio/figma/`.

## Phase 2: expandable detail panels

Implemented on 11 November 2026. The new `PortfolioDetailsPanels` presentation
widget is shared by mobile and desktop. Both panels start collapsed; tapping a
control opens it, tapping it again closes it, and choosing the other control
switches panels. Expansion resets when the selected holding changes.

- Match the Figma controls' 54-pixel baseline height, 10-pixel gap, 14-pixel
  corners and purple selected state. Expanded data rows use 16-pixel padding,
  18-pixel corners and a 67-pixel baseline height. Controls and content grow
  for wrapped text instead of clipping it.
- Investment Details reads invested amount, purchase NAV and first invested
  date directly from the holding. Missing purchase NAV or first date uses a
  dash; the latest investment date is not presented as the first date.
- SIP Schedule reuses the existing page visibility rule. Its data comes from
  next SIP date, frequency and installment count. Cancelled SIPs do not show
  a future debit date, and missing frequency is not defaulted to Monthly in
  the compact panel.
- The four original Figma SVGs are saved under `assets/portfolio/figma/` for
  selected/unselected investment and calendar states. All have 17 by 17 root
  dimensions and are rendered at that size without recoloring.
- The Investment Details panel includes the preview's intentional extension,
  a working View all details link. It opens a scrollable bottom sheet on
  mobile or dialog on desktop, reusing the original investment metrics and
  SIP schedule widgets. One-day returns, additional investment dates/NAV,
  and debit-day information remain accessible there.
- The existing redemption/cancellation audit sections and transaction/action
  handlers remain in place for their later phases. No new API calls are made
  by expanding a panel or opening the details overlay. The excluded exit-load
  forecast remains unmounted.

Figma expanded-state sources: controls `717:5417` / `717:6225`, investment
panel `717:5434`, and schedule panel `717:6242`.

## Phase 3: transaction cards and expansion

Implemented on 11 November 2026. `PortfolioTransactionsSection` replaces the
original transaction-list presentation in both mobile and desktop layouts.

- Match the reference ACTIVITY/Transaction Details heading, actual record-count
  badge, 104-pixel baseline cards, three columns, thin vertical dividers,
  18-pixel corners, 9-pixel card gaps and purple show-more/show-fewer control.
- Cards display transaction date/NAV, transaction type/units, and amount/status.
  API display dates, amounts and units take precedence over numeric formatting;
  parseable raw dates use the reference date format. NAV uses two decimal
  places, as in the reference and original transaction list.
- Keep all returned records in their original API order, without inferring
  transaction frequency from the holding's current SIP schedule. The count
  represents returned transaction rows, not completed SIP installments.
- Start expanded to match the supplied reference. Show fewer retains the first
  three returned records; Show more reveals all loaded records again. The
  control is hidden when there are three or fewer records. Expansion resets
  when a different holding is selected and makes no API requests.
- Preserve supplied status text and the existing entity success predicate.
  Explicit failure/cancellation text takes visual precedence over conflicting
  success fields. Missing status uses a neutral dash rather than inventing a
  Processed/Successful result. Debit amounts retain their red visual cue and
  direction remains available to assistive technology.
- Text and cards grow for longer values or larger text. Existing transaction
  visibility, action handlers, detail panels and forecast exclusion remain.

Figma sources: heading `717:4664`, card `717:4676`, and toggle `717:4939`.
This phase adds no static image assets or dependencies.

## Phase 4: separate actions and additional details

Implemented on 11 November 2026. The page now uses `PortfolioFundActions` in
the mobile footer and existing desktop actions card.

- Eligible active SIPs show separate Cancel SIP and Redeem buttons. Redeem
  always selects redemption, including for active SIPs. Cancel SIP opens the
  existing OTP dialog; cancellation does not redeem the holding. Other eligible
  holdings show Redeem, or Redeem Remaining for partial redemptions.
- Match footer node `717:6930`: 56-pixel baseline pill buttons, 18-pixel gap,
  red cancellation outline and navy/purple redemption gradient and shadow.
  Labels grow and actions stack on narrow layouts or with larger text.
- Export the exact visible cancellation SVG from node `717:6960` to
  `assets/portfolio/figma/cancel.svg`. Its native 11.6 by 11.6 dimensions are
  centered inside the design's 20 by 20 icon slot; the SVG is not recolored.
- Preserve existing allotment, pending-redemption, full-redemption and positive
  unit eligibility checks. A valid positive `mfuOrderFundId` is also required;
  no order-ID fallback is used. Pending SIP cancellations disable cancellation.
- Disable both actions while a dialog/navigation flow is active or the
  Dashboard portfolio is refreshing. Recheck the latest holding and eligibility
  before redemption navigation. The page observes the already registered
  Dashboard controller by fund ID, so its existing cancellation refresh can
  update the holding, banners and action availability. No controller is created
  and no additional portfolio request is introduced by this page.
- Preserve the goal-linked redemption warning, all existing `RedeemArgs`
  fields (including the exit-load argument used by the redemption flow), and
  mobile/nested-web navigation. No endpoints, payload fields, bindings,
  cancellation modal or repositories change.
- Investment Details > View all details opens Additional details, as a mobile
  bottom sheet or desktop dialog. Collapsible groups retain performance/dates,
  the optional SIP schedule, actual redemption payout records and cancellation
  audits. The latter two sections move out of the main page into this overlay.
  Existing status banners remain on the main page.
- Additional-detail rows wrap within the available width and use the reference
  font. One-day losses retain their negative sign; no financial formula changes.
  Exit Load & Redemption Forecast remains excluded from every mounted layout.
  Existing submitted redemption records may still include their unit-based
  estimated value and backend payout timeline; these are transaction details,
  separate from the excluded prospective exit-load forecast.

New reusable presentation widgets: `portfolio_fund_actions.dart` and
`portfolio_additional_details_section.dart`. The legacy portfolio popup remains
outside the scope of this full-page redesign.

## Phase 5: final review and documentation

Completed on 11 November 2026 within the authorized static-review scope.
This does not constitute rendered pixel verification or live transaction testing.

Source review found and corrected two layout constraints in
`lib/features/dashboard/presentation/pages/portfolio_fund_details_page.dart`:

- Add side safe-area padding around the page content so a landscape notch does
  not overlap cards. The header background remains full width; the original
  header/card positions remain at zero side inset.
- Let the additional-details SIP schedule heading and status badge wrap onto
  separate lines when necessary. The heading text can wrap within its available
  width, avoiding the previous fixed-row width requirement at larger text sizes.

No other implementation file changes in this phase. No routes, bindings,
controllers, repositories, API requests, calculation formulas, dependencies or
assets are added or changed.

### Responsive source review

| Area | Source behavior reviewed | Remaining verification |
| --- | --- | --- |
| Mobile/tablet widths below 960 | Single scrollable column; growing cards/text; three flexible metric/transaction columns | Render at 320, 360, 430, 600 and 768 logical pixels |
| Desktop widths from 960 | Two flexible columns inside a 1140-pixel maximum content width; shared details/actions widgets | Render at the breakpoint and wider browser sizes |
| Larger text and long values | Header height follows text scaling; card badge stacks; text wraps; money metrics scale down; additional rows use flexible widths | Device accessibility text-scale review; scaled-down metric readability |
| Actions | Pair stacks below 340 pixels of available width, at larger text, or for longer state labels; footer accounts for safe-area insets | Short screens, landscape, keyboard/dialog interaction |
| Overlays | Scrollable mobile sheet/desktop dialog; optional collapsible groups; safe-area constraints | Open/close, expansion and scrolling on a device |

These are source-level observations, not executed viewport scenarios. The
reference images were inspected, but no rendered Flutter screenshot was produced.

### Data and state visibility

| Data/state | Final location or behavior |
| --- | --- |
| Fund name/logo, folio, goal, plan/option, NAV/date, invested/current value, gain/return and units | Header and holding card; missing explicit metadata uses a dash; long folio/goal text may truncate in the card |
| Compact investment/SIP data | Expandable main-page panels; mutually exclusive; no request on expansion |
| One-day returns, additional investment dates/NAV, full folio | Investment Details > View all details > Performance & dates |
| Debit day and detailed SIP schedule | Optional SIP schedule group in Additional details |
| Submitted redemption payout details and SIP cancellation audit | Optional Additional details groups, retained from the old page |
| Transactions | All loaded API records initially, in API order; more/fewer only changes the visible count |
| No transactions | Main page omits the Activity section, preserving the existing visibility rule |
| No selected holding | Existing No Portfolio Fund Selected screen and back action |
| Portfolio refresh/loading/error | Existing Dashboard controller owns requests/errors; actions disable during refresh and the page retains available holding data |
| Pending allotment/redemption, fully redeemed or no positive units | Transaction actions withheld by the existing eligibility rules |
| Invalid/missing fund ID | Actions withheld; an order ID is not substituted |
| Active SIP / pending cancellation | Separate actions; pending cancellation disables Cancel SIP; applicable status is shown on the holding card |
| Exit Load & Redemption Forecast | Excluded from mounted main-page and Additional details layouts |

### Navigation, dependencies and request review

- Existing portfolio callers supply the holding through `navFund` and route
  arguments. The page retains existing mobile back behavior, nested-web fallback,
  goal-linked warning and redemption navigation. The shell's existing Dashboard
  and MFU bindings supply dependencies; none are registered from these widgets.
- No new portfolio request is made by build, panel expansion, transaction toggles
  or opening Additional details. The page observes the registered Dashboard's
  existing portfolio refresh; cancellation still uses the existing OTP modal.
- `RedeemArgs` mappings remain as in Phase 4, including `mfuOrderFundId`, goal
  information and the exit-load argument consumed by the redemption flow.
  No endpoints, payload fields, response parsing or session storage change.
- All six static SVGs are present, nonempty and parseable. Back is 20 by 20;
  selected/unselected investment/calendar icons are 17 by 17; cancellation is
  11.6 by 11.6 centered in its 20 by 20 slot. Callsites preserve native dimensions
  and the existing asset-directory registration. Plus Jakarta Sans is registered
  and its local font file is present. No temporary Figma URLs are runtime assets.

### Existing limitations retained for separate follow-up

- A cold browser load/refresh cannot reconstruct the selected holding from
  `/portfolioDetails` alone: selection depends on in-memory `navFund` or an
  entity argument, with no persisted fund ID in this route. The empty-selection
  fallback remains. Route restoration was not changed in a UI review.
- The retained detailed SIP schedule defaults an absent frequency to Monthly
  and describes debit day as "of every month". The compact panel instead uses
  the actual frequency or a dash. Correcting these legacy schedule assumptions
  requires a separate agreed data-display change.
- Existing fallback banners contain fixed payout/allotment timeline text when
  the backend message is absent; these are not guarantees verified by this work.
- Existing redemption arguments pass zero locked units and the holding's total
  units/value as free. This review does not validate lock-in eligibility or
  backend transaction rules. The page's positive-unit guard also does not assert
  server-side idempotency or guarantee a fresh backend snapshot.
- Same-ID refresh matching depends on the existing controller returning that
  record. Network failure or a missing matching record leaves the supplied
  snapshot. OTP/API, route and browser-history interactions need an authorized
  runtime check before release.

All five implementation phases are complete within the approved scope. No tests,
builds, app launches or live financial API calls were performed.

## Verification limits

Only formatting, static analysis, source inspection and asset metadata checks
are authorized. No tests, builds, application launch or live financial API calls
are part of this change. Rendered pixel comparison remains unverified until
the application can be run with user authorization.

Phase 1 checks completed: targeted `dart format`, `flutter analyze --no-pub`
for the two affected Dart files (no issues), and `git diff --check`. The exported
back SVG is nonempty and has a 20 by 20 root size/view box, matching its design
slot and callsite. The existing Plus Jakarta Sans font file is present.

Phase 2 checks completed: targeted `dart format`, `flutter analyze --no-pub`
for the page and panel widget (no issues), and `git diff --check`. All four
new SVG files are nonempty, parse as SVG, and retain 17 by 17 root dimensions
matching their design slots and callsites. Interaction and rendered layout
verification remain pending an authorized app run.

Phase 3 checks completed: targeted `dart format`, `flutter analyze --no-pub`
for the page and transaction widget (no issues), and `git diff --check`.
Source review confirms both layouts use the same section, only the visible
record count changes on toggle, and transaction/order handlers are unchanged.
No tests, builds, live financial API calls or rendered interaction checks ran.

Phase 4 checks completed: targeted `dart format` for the page and two new Dart
widgets (final run: zero changes), `flutter analyze --no-pub` for those three
files (no issues), and `git diff --check`. Source comparison confirms the
`RedeemArgs` construction retains every previous field/value mapping, both
layouts share the action row, and the forecast builder has no mounted callsite.
The cancellation SVG is nonempty (323 bytes), parses as SVG and retains native
11.6 by 11.6 root dimensions and view box in the 20 by 20 design slot. Its asset
directory was already registered in Phase 1; Phase 4 does not change pubspec.

Actual OTP delivery/verification, goal-warning interaction, route transitions,
backend pending-state updates and rendered responsive layouts were not executed.
The page depends on the existing Dashboard refresh succeeding and returning the
same holding ID; without a registered controller or matching refreshed record,
it retains the supplied holding snapshot. Server-side duplicate protection is
unchanged.

Phase 5 checks completed: targeted `dart format` across the page and five
presentation-widget files (six files processed; only the page required
formatting), `flutter analyze --no-pub` for all six files (no issues), and
`git diff --check`. Source review covered responsive constraints, empty and
pending-state branches, action eligibility, dependency lookup, routing,
asset registration and existing request wiring. Asset XML metadata and font
presence were inspected locally. Device/browser rendering, financial requests
and interactive behavior remain unverified as described above.

## Portfolio Details shared styling: Phase 1

Completed on 12 November 2026 after approval of the three-phase styling plan.
This phase adds shared definitions only. Existing Portfolio Details widgets
still use their current styling; applying these definitions is Phase 2.

### Changed files and purpose

- `lib/core/utils/constant/colors.dart`: add the missing Portfolio colors and
  exact header/glow/redemption gradients under the existing `Ucolors` class.
- `lib/core/utils/constant/text_style.dart`: add an opt-in `portfolioText`
  helper and seven common typography presets under the existing `UTextStyles`
  class, delegating font creation to `homeText`.
- This implementation report: document the shared definitions, usage and checks.

No existing constant, gradient, helper default or theme is changed. No widget,
controller, binding, repository, endpoint, request field, financial calculation,
route, asset or package changes in Phase 1.

### Color and gradient definitions

All 27 new color values were taken from the current Portfolio UI. Similar
existing colors were not substituted where their actual values differ.

| Role | Shared source |
| --- | --- |
| White/background/positive returns | Existing `white`, `homeBackground`, `homePositive` |
| Navy and purple gradient endpoints | Existing `homeHeaderEnd` and `goalPrimary` |
| Secondary text, legacy card border/shadow | Existing `homeTextSecondary`, `homeTileBorder`, `homePanelShadowFarColor` |
| Portfolio purple/text/heading | `portfolioAccent`, `portfolioInk`, `portfolioTextMuted`, `portfolioHeading`, `portfolioValueBlue` |
| Loss, positive/pending/warning text | `portfolioNegative`, `portfolioPositiveText`, `portfolioPendingText`, `portfolioWarningText` |
| Card/divider/metadata | `portfolioCardBorder`, `portfolioDivider`, `portfolioMetadataSurface`, `portfolioMetadataBorder` |
| Selected panel/count badge/empty state | `portfolioSelectedSurface`, `portfolioCountBadgeSurface`, `portfolioEmptyBackground` |
| Schedule/info colors | `portfolioInfoSurface`, `portfolioInfoText` |
| Payout audit surfaces/borders | `portfolioPayoutPendingSurface`, `portfolioPayoutPendingBorder`, `portfolioPayoutSettledSurface`, `portfolioPayoutSettledBorder` |
| Cancel fill/border and redemption shadow | `portfolioCancelFill`, `portfolioCancelBorder`, `portfolioRedeemShadow` |
| Header glow | `portfolioHeaderGlow`, `portfolioHeaderGlowTransparent` |

The new `portfolioHeaderGradient`, `portfolioHeaderGlowGradient` and
`portfolioRedeemGradient` preserve their current color order, alpha values,
directions, alignment coordinates, stops and radial geometry. Existing Home and
Goal gradients keep their original definitions and consumers.

### Typography and later usage

`UTextStyles.portfolioText` defaults to Plus Jakarta Sans and the Portfolio ink
color. It forwards size, weight, color, family, nullable line height and letter
spacing to `homeText`, preserving its variable-font weight handling. An explicit
family override remains available for legacy callsites with a different font.
It does not change the existing Inter helper default or Roboto application theme.

The new presets are `portfolioHeaderTitle`, `portfolioSectionHeading`,
`portfolioMetricLabel`, `portfolioMetricValue`, `portfolioMetricValueProminent`,
`portfolioCaption` and `portfolioActionLabel`. Their sizes and weights come from
the current header, transaction heading, metrics and actions. They are getters
so callers cannot replace the shared definitions by assigning another style.

Example usage for Phase 2:

```dart
color: Ucolors.portfolioCardBorder,
style: UTextStyles.portfolioHeaderTitle,
```

For a callsite with different typography, use `portfolioText` with its current
arguments or an appropriate preset override. Do not force different sizes,
fonts or line heights into one preset. In particular, the metric caption's
1.35 line height differs from transaction captions using 1.5, and action labels
currently leave height unspecified.

### Verification and remaining phases

- Targeted `dart format` completed for both shared Dart files.
- `flutter analyze --no-pub` for both files reported one existing informational
  lint: `constant_identifier_names` for `Ucolors.Orange` at `colors.dart:8`.
  The command exits nonzero for that info. It reported no new findings from the
  added definitions. The existing public identifier is deliberately unchanged.
- `git diff --check` passed. Source comparison against the start of this phase
  confirms both files retain every pre-existing definition/default; all changes
  are additions. Every added color value occurs in the current Portfolio source.
- No tests, builds, app launches, live APIs or rendered checks ran. These
  definitions have no screen callsites until the next migration phase.

Phase 2: apply the shared colors/styles to the active page, panels, transaction
cards, action row, overlays and page states while preserving appearance and
existing public interfaces. Phase 3: final source/responsive review, targeted
static checks and documentation. Pause here for approval before Phase 2.

## Portfolio Details shared styling: Phase 2

Completed on 12 November 2026 after approval. The active Portfolio Details page
and its five presentation widgets now consume the shared Portfolio palette and
typography added in Phase 1. This is a styling-reference migration; existing
layout, content, conditions, financial calculations and navigation are retained.

### Changed files and usage

- `portfolio_holding_header.dart`: preserve the public `gradient` name as an
  alias to `Ucolors.portfolioHeaderGradient`; use the shared header/metric/caption
  presets and palette. Keep `_text` as a thin forwarding helper for other labels.
- `portfolio_details_panels.dart`: use shared surface, accent, text, divider and
  border colors; forward label/value styling to `portfolioText` with the same
  sizes, weights and 1.5 line height.
- `portfolio_transactions_section.dart`: use the shared heading, transaction
  colors and helper while preserving status resolution, ordering and expansion.
- `portfolio_fund_actions.dart`: use the shared cancellation fill/border, loss
  color, redemption gradient/shadow and action-label preset. Preserve busy state,
  eligibility, tap handlers, icon geometry and responsive stacking.
- `portfolio_additional_details_section.dart`: use shared surface, accent and
  heading colors with `portfolioText`, preserving its current typography.
- `portfolio_fund_details_page.dart`: migrate active empty-state, desktop action,
  overlay, metric/schedule/audit and status-banner styling. Use the shared radial
  glow and retain the existing header gradient alias and page wiring.
- `colors.dart`: add exact aliases for existing legacy Material shades used by
  the page/audits. These include body/secondary/subtitle/placeholder text, neutral
  status, banner colors and legacy gain/loss shades. Getter-based Material shades
  remain immutable `static final` colors; existing constant definitions stay intact.
- `text_style.dart`: add `portfolioInheritedText` for legacy text whose font,
  size, weight or line height was inherited rather than explicitly specified.
- This report: record the migration and its static verification limits.

The five widget files are under
`lib/features/dashboard/presentation/widgets/`; the page is under
`lib/features/dashboard/presentation/pages/`. Shared files remain under
`lib/core/utils/constant/`.

### Appearance and compatibility

- All active custom color literals now reference the shared palette. White uses
  `Ucolors.white`. Framework transparency remains `Colors.transparent`.
  File-local duplicate color constants are removed; local widget geometry and
  decoration composition remain in their existing widgets.
- The header, glow and redemption gradients keep their original endpoints,
  directions, alignment, stops, alpha and radius. The shared Home/Goal gradients
  and app color defaults are unchanged.
- The seven Phase 1 text presets are now used where their values match exactly.
  Other sizes/colors/heights continue through `portfolioText` or preset
  `copyWith` overrides. Thin `_text` wrappers preserve existing private callsites.
- The Additional details title explicitly retains its original black color,
  rather than adopting the new helper's default Portfolio ink color.
- `portfolioInheritedText` creates a text style with nullable attributes, matching
  the original direct `TextStyle` semantics. It does not inject Plus Jakarta Sans,
  a weight, size or variable-font axis into legacy text that inherited those
  values. Existing explicit Inter attributes remain explicit. Other Portfolio
  widgets retain Plus Jakarta Sans through the original `homeText` font handling.
- Existing `homeText`, `portfolioText`, text presets, primary colors and theme
  defaults remain unchanged. No unrelated screen is migrated and no package,
  asset, public widget interface, route, repository, API or session logic changes.
- The unmounted Exit Load & Redemption Forecast builder is left untouched.
  Its remaining inline styles are outside the active-screen migration. It is
  still not mounted; the styling of active payout records remains separate.

### Phase 2 verification

- Targeted `dart format` completed across all eight affected Dart files.
- `flutter analyze --no-pub` across those eight files reported only the existing
  `constant_identifier_names` info for `Ucolors.Orange` at `colors.dart:8`.
  It reported no new findings. The command exits nonzero because of that info;
  the public identifier was not renamed or suppressed.
- `git diff --check` passed.
- Source comparison across all six presentation files resolved the shared color
  aliases and excluded text-style expressions from the structural comparison;
  layout, data and color expressions match the starting source. A separate
  source-parameter review of 57 style expressions found no mapping differences
  in size, weight, family, color, line height, letter spacing or variable-font
  handling. This is source inspection, not executed Flutter rendering.
- The back/navigation/transaction handlers and existing redemption arguments
  match the start of this phase. The excluded forecast builder matches its
  original source. No new request or dependency registration was added.

No tests, builds, app launches, live financial API calls or rendered pixel/
interaction checks ran. Device font rendering, accessibility text scaling and
responsive appearance remain unverified until an authorized runtime review.

Phase 3 remains: final responsive/source review, targeted static checks and
documentation. Pause here for approval before that phase.

## Portfolio Details shared styling: Phase 3

Final source review completed on 12 November 2026 within the approved static
verification scope. This phase updates this report only; it does not modify Dart
files or alter the current screen layout.

### Migration coverage and compatibility review

- The active page and all five presentation widgets contain no custom inline
  `Color(0x...)` values, direct `TextStyle(...)` construction or calls to
  `UTextStyles.homeText`. They use `Ucolors`, the Portfolio text helpers/presets,
  or thin feature-local forwarding helpers. Framework transparency remains
  `Colors.transparent`.
- Remaining inline colors and text styles in the page belong to the retained,
  unmounted Exit Load & Redemption Forecast builder. Its only reference is its
  definition. No forecast content was restored by this migration.
- All six presentation files exactly match the verified Phase 2 source. Shared
  color/default definitions and existing theme defaults are preserved. The app
  still uses its existing light theme and Roboto defaults; explicitly selected
  Inter and Plus Jakarta Sans callsites retain their original behavior.
- The Phase 2 source comparison covers layout, data/color expressions and 57
  style expressions. The final review found no additional mapping correction
  needed. These comparisons do not establish rendered pixel equivalence.
- Font-family handling, variable weights, metric-caption line height of 1.35,
  transaction-text line height of 1.5 and nullable action-label height remain
  distinct where required. The inherited-text helper retains null attributes
  instead of injecting another font or weight into legacy text.
- GetX registration, routes, callbacks, API requests/arguments, status predicates,
  record visibility and financial calculations are unchanged. The migration
  adds no requests, dependencies, packages or assets.

### Responsive and asset source review

| Area | Preserved source behavior | Runtime follow-up |
| --- | --- | --- |
| Page layout | Existing 960-pixel desktop breakpoint, 1140-pixel content maximum, side safe areas and mobile/desktop padding | Device/browser review at narrow, intermediate and wide widths |
| Header | Full-name wrapping and growing header; current decoration setting retained | Long names and larger text against the fixed-height page gradient band |
| Holding card | Flexible metric columns, scale-down for large metric values, two-line metadata ellipsis, wrapping units/status strip | Value readability and long folio/goal truncation |
| Panels/transactions | Existing minimum heights, flexible columns, text wrapping and unchanged expansion state | Larger text, long API values and large transaction lists |
| Actions | Existing stacking below 340 pixels, scaled text and longer labels; 56-pixel minimum button height | Short screens, safe areas and dialog/navigation interaction |
| Additional details | Existing scrollable mobile sheet/desktop dialog and 560-pixel dialog maximum | Expansion, scrolling and keyboard/back behavior |

These rows are source observations, not executed viewport scenarios. In
particular, a very tall header can extend beyond the existing 174-pixel page
gradient band. That layout condition predates this styling migration and is
recorded for a separate device review; the current header decoration comment
and geometry were not changed here.

All six SVG files are nonempty and parse as SVG. Native sizes and callsites
remain: back 20 by 20, selected/unselected investment/calendar 17 by 17, and
cancellation 11.6 by 11.6 centered in its 20 by 20 slot. The asset-directory
registration and Plus Jakarta Sans font registration/file are present. SVG
artwork, including embedded fills, remains unchanged by Dart color tokens.

### Maintaining the shared styles

- Change Portfolio-specific colors in `Ucolors.portfolio...` when updating this
  screen's palette. Existing shared Home/Goal/white values also have other app
  consumers, so changes to those shared values require checking those consumers.
- Change common Portfolio text roles through the named `UTextStyles.portfolio...`
  presets. Screen-specific size/color/height overrides continue to take precedence.
- `portfolioText` owns the default Portfolio font; `portfolioInheritedText`
  follows ambient text defaults unless a property is supplied. Unifying the app's
  different font families is a separate visual change, outside this migration.
- Widget geometry, state-dependent opacity and interaction logic stay in the
  feature widgets. A future palette change should also consider any SVG fills
  that need to match the new colors; shared Dart constants do not rewrite SVGs.

### Final static-check results and completion

- `dart format --output=none --set-exit-if-changed` across all eight affected
  Dart files completed with exit code 0: eight files checked, zero changes.
- `flutter analyze --no-pub` across those eight files completed with the same
  single existing informational lint: `constant_identifier_names` for
  `Ucolors.Orange` at `colors.dart:8`. No new findings were reported. The command
  exits 1 because of that info; the public name is unchanged and unsuppressed.
- `git diff --check` passed. Remaining Git LF/CRLF notices describe the existing
  checkout conversion behavior and are not whitespace errors.
- Local SVG XML metadata, font presence/registration and icon callsites were
  inspected. No image or font files were changed.
- The eight Dart files were not edited in this phase. The only Phase 3 change
  is this report; the Phase 1/2 changes remain available for user review.

All three shared-styling phases are complete within the approved scope. No
tests, builds, app launches, live API calls or rendered screenshots ran.
Rendered appearance, device accessibility and interactive behavior remain
unverified; the source-level observations above do not replace that runtime
review. No further implementation phase is pending for this styling migration.
