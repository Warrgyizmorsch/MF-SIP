# Goal API implementation plan

This document is the execution plan for completing and improving the MF SIP Goal module. Use it together with:

- [`GOAL_IMPLEMENTATION_GUIDE.md`](GOAL_IMPLEMENTATION_GUIDE.md)
- [`Goal_API_Documentation.pdf`](Goal_API_Documentation.pdf)

The guide describes the API contract and integration rules. This plan describes the implementation order, affected files, expected behavior, tests, and completion criteria.

No developer should infer missing endpoint behavior. Items marked **Backend confirmation required** must be resolved before the dependent code is released.

## Objectives

The completed Goal module should allow a user to:

1. Browse master goal templates or create a custom goal.
2. Define a target amount and target date.
3. Review an estimated SIP or lump-sum plan.
4. Save the goal without accidentally placing an investment order.
5. Add, edit, remove, or move planned funds.
6. Proceed separately to the existing investment checkout flow.
7. Track actual invested value, current value, gain/loss, progress, and MFU status.
8. Update or delete a goal safely.
9. Use the complete flow on mobile, tablet, and Flutter Web.

## Non-negotiable business rules

- A planned fund is not an executed investment.
- Saving a goal or linking a fund must not increase actual investment or progress.
- Actual values must come from qualifying executed transactions and allotted units.
- Planned and actual values must remain separate in models, entities, controller state, and UI.
- Goal deletion must not be presented as MFU SIP cancellation.
- Moving a planned fund must not be presented as moving actual holdings unless the backend explicitly supports that behavior.
- Scheme codes remain strings.
- Goal tenure is expressed in months according to the PDF; confirm this before correcting existing requests.
- Never use a fallback investor or user ID.
- Never log tokens, complete investor payloads, transaction references, or portfolio responses.

## Current implementation baseline

The existing module already contains:

- `GoalSipController`
- `GoalBinding`
- `GoalRepository` and `GoalRepositoryImpl`
- `GoalRemoteDataSource`
- goal, master-goal, goal-fund, update, and delete models/entities
- use cases for create, list, master list, fund linking, fund update, and delete
- mobile and web goal pages
- named GetX routes

Known gaps and defects:

| Area | Current behavior | Required action |
| --- | --- | --- |
| Goal tenure | Controller appears to send years | Confirm contract and send months |
| User identity | One fund request falls back to user ID `7` | Remove fallback and require a valid session |
| Create failure | `isGoalSaved` becomes true on failure | Keep it false and preserve form data |
| Goal deletion | Local state removes funds by matching the goal ID | Remove/refetch the actual goal record |
| Fund creation | Controller uses `/goal-orders/save` with a flat payload | Confirm legacy behavior and adopt the documented contract |
| Fund update | URL omits `{id}` and ignores `fundId` | Confirm single versus bulk endpoint and correct it |
| Goal list | Live valuation fields are not fully modeled | Add typed actual and MFU summary fields |
| Single goal | No dedicated `GET /goal/{id}` integration | Add complete vertical slice |
| Goal update | Missing | Add complete vertical slice |
| Goal funds | No dedicated portfolio endpoint integration | Add if required after contract comparison |
| Fund movement | Single and bulk move APIs are missing | Add both vertical slices |
| Logging | Complete API results may be logged | Replace with safe operation/status logging |
| Tests | No goal-specific automated tests were found | Add model, repository, controller, and widget tests |

## Backend contract decisions

Resolve these questions before implementation begins. Record the answers in `GOAL_IMPLEMENTATION_GUIDE.md`.

| ID | Question | Blocks |
| --- | --- | --- |
| BC-01 | Is the master-goal response a raw list or a `data` envelope? | Master-goal parsing |
| BC-02 | Are master fields `name`/`icon` or `goal_type`/`goal_icon`? | Master model and UI |
| BC-03 | Is `user_id` derived from the token or required in request bodies? | Create and fund-link requests |
| BC-04 | Is goal tenure always in months? | Create and update requests |
| BC-05 | Is the frequency value literally `Quaterly` or `Quarterly`? | Validation and serialization |
| BC-06 | Are `invested_amount`, `created_date`, and `status` allowed on create? | Create payload |
| BC-07 | Is `/goal-orders/save` supported, and how does it differ from `/goal-orders`? | Fund linking |
| BC-08 | Is planned-fund update single-resource, bulk, or both? | Fund update |
| BC-09 | Which endpoints return `success`, `status`, or both? | Response normalization |
| BC-10 | Which MFU statuses qualify as actual investment? | Progress and valuation |
| BC-11 | Does deleting a goal/fund affect active MFU instructions? | Delete confirmation and action |
| BC-12 | Do move endpoints affect planned records only? | Move UI and business behavior |
| BC-13 | What is the complete step-up request contract? | Step-up UI and request model |
| BC-14 | Does create use multipart whenever `goal_cover` is present? | Create request transport |
| BC-15 | What are the standard validation and error envelopes? | Error parsing |

## Delivery strategy

Use small vertical slices. Do not combine this work with unrelated redesign or architecture replacement.

```text
Phase 0 - Confirm API contract
Phase 1 - Stabilize existing integration
Phase 2 - Add live valuation and goal details
Phase 3 - Complete goal CRUD
Phase 4 - Complete planned-fund APIs
Phase 5 - Improve the user journey
Phase 6 - Harden, test, and release
```

Each phase must pass its acceptance criteria before the next dependent phase is released.

## Phase 0: Confirm and capture the deployed contract

### Tasks

1. Use the selected non-production environment.
2. Capture sanitized responses for all available Goal endpoints.
3. Record HTTP status, response container, boolean flags, nullability, and numeric types.
4. Confirm every item in the backend decision table.
5. Update `GOAL_IMPLEMENTATION_GUIDE.md` with confirmed behavior.
6. Do not copy tokens, PAN, CAN, bank, or investor information into fixtures.

### Deliverables

- Sanitized JSON fixtures under a test fixture location approved by the project.
- Updated contract notes.
- Written backend confirmation for ambiguous endpoints.

### Acceptance criteria

- No implementation relies solely on a guessed response envelope.
- Create, list, detail, update, delete, fund link, fund update, fund delete, and move contracts are known.
- MFU statuses used for progress are explicitly defined.

## Phase 1: Stabilize the existing integration

This phase should be completed before new Goal UI is enabled.

### 1.1 Session identity

Affected file:

- `lib/features/goal/presentation/controller/goal_sip_controller.dart`

Tasks:

- Remove the fallback user ID.
- Stop the operation when session user data is unavailable.
- Use the application's existing expired/uninitialized session behavior.
- Show a safe user-facing session message.

Acceptance criteria:

- No Goal request can be sent for a fabricated user ID.
- Loading state resets when the session is unavailable.
- No token or user payload appears in logs.

### 1.2 Create-goal request correctness

Affected files:

- `lib/features/goal/presentation/controller/goal_sip_controller.dart`
- `lib/features/goal/data/datasource/goal_remote_data_source.dart`
- `lib/features/goal/data/model/goal_model.dart`

Tasks:

- Convert UI tenure to confirmed API months.
- Send only backend-approved fields.
- Keep `isGoalSaved` false on failure.
- Preserve the user's form after validation or network failure.
- Use multipart only when a cover image is present and the contract requires it.
- Prevent repeated submit taps.
- Ensure actual invested amount is not initialized from projected investment.

Acceptance criteria:

- One tap creates at most one goal.
- Success stores the returned goal ID.
- Failure does not navigate forward or mark the goal saved.
- Both SIP and lump-sum create requests match confirmed fixtures.

### 1.3 Delete-goal state correctness

Affected files:

- `lib/features/goal/presentation/controller/goal_sip_controller.dart`
- delete response model, if the confirmed envelope requires it

Tasks:

- Do not remove goal funds using the goal ID.
- Remove the matching goal or refetch the list after success.
- Normalize `success`/`status` only according to the confirmed contract.
- Add explicit confirmation.
- Warn when active or pending MFU instructions exist.

Acceptance criteria:

- Deleting one goal never changes another goal locally.
- A failed delete leaves all local data unchanged.
- The UI never says an MFU SIP was cancelled unless a separate confirmed cancellation succeeded.

### 1.4 Safe error and log handling

Affected files:

- `lib/features/goal/data/datasource/goal_remote_data_source.dart`
- `lib/features/goal/data/repositories/goal_repository_impl.dart`
- `lib/features/goal/presentation/controller/goal_sip_controller.dart`

Tasks:

- Remove complete request/response logging.
- Replace generic `Login Failed` errors with operation-specific errors.
- Handle unexpected response types safely.
- Preserve a safe backend message where appropriate.
- Avoid showing raw exception strings to users.

Acceptance criteria:

- Logs contain operation names and safe status information only.
- Timeout, unauthorized, validation, malformed response, and server failure produce distinct safe behavior.
- Every loading flag resets in `finally` or equivalent guaranteed paths.

### 1.5 User-goal list stability

Endpoint:

```http
GET /api/v1/goals/user/{user_id}
```

Affected files:

- `lib/features/goal/data/datasource/goal_remote_data_source.dart`
- `lib/features/goal/data/model/goal_model.dart`
- `lib/features/goal/presentation/controller/goal_sip_controller.dart`
- `lib/features/goal/presentation/pages/goal.dart`

Tasks:

- Require a valid session user ID.
- Treat an empty `goal` array as a successful empty state.
- Preserve previously loaded goals during a background refresh.
- Prevent route initialization and widget lifecycle from triggering duplicate calls.
- Parse the confirmed lowercase/legacy investment fields safely.
- Prepare the list model for the live valuation fields implemented in Phase 2.

Acceptance criteria:

- A new user sees an empty state rather than an error.
- A refresh sends one request and does not blank existing content.
- Unauthorized and malformed responses reset loading state safely.
- Goal list errors never use unrelated authentication wording such as `Login Failed`.

## Phase 2: Live valuation and single-goal details

### 2.1 Extend the goal-list model

Affected files:

- `lib/features/goal/data/model/goal_model.dart`
- `lib/features/goal/domain/entity/goal_entity.dart`
- relevant model-to-entity mappings

Add confirmed typed fields for:

- `actual_invested_amount`
- `actual_current_value`
- `actual_gain_loss`
- `actual_gain_loss_percent`
- `progress_percent`
- `mfu_order_status`
- `mfu_order_summary`

Suggested MFU summary entity fields:

```text
totalOrders
latestStatus
pendingCount
successCount
failedCount
totalAmount
```

Parsing requirements:

- Accept confirmed numeric string/number variations.
- Keep `invested_amount` separate from `actual_invested_amount`.
- Support empty `goal_funds`.
- Do not silently substitute planned values for missing actual values.

Acceptance criteria:

- The PDF sample and confirmed UAT fixture parse without data loss.
- Zero and missing values are distinguishable where the UI needs that distinction.
- Existing goal-list fields remain backward compatible where required.

### 2.2 Add single-goal details

Endpoint:

```http
GET /api/v1/goal/{id}
```

Recommended new artifacts, subject to existing naming conventions:

```text
data/model/goal_details_model.dart
domain/entity/goal_details_entity.dart
domain/usecases/get_goal_details_use_case.dart
```

Existing files to extend:

```text
data/datasource/goal_remote_data_source.dart
data/repositories/goal_repository_impl.dart
domain/repositories/goal_repository.dart
domain/usecases/goal_use_cases.dart
presentation/bindings/goal_binding.dart
presentation/controller/goal_sip_controller.dart
```

Typed nested data should include:

- actual display values, if retained;
- actual fund holdings;
- executed transactions;
- scheme code and name;
- invested amount and units;
- current NAV and value;
- gain/loss values;
- transaction type, status, NAV, and date.

Controller state:

```text
selectedGoalDetails
isLoadingGoalDetails
goalDetailsError
```

Behavior:

- Load by goal ID, not only by a previously passed entity.
- Support direct web URL access and refresh.
- Keep previously loaded data visible during a background refresh.
- Avoid calling list and detail APIs repeatedly from widget builds.

Acceptance criteria:

- A detail page opened directly can load itself.
- Empty actual holdings render a planned-only state.
- Missing NAV renders an unavailable state without crashing.
- Planned funds and actual holdings are visibly distinguished.

## Phase 3: Complete goal CRUD

### 3.1 Update goal

Endpoint:

```http
PATCH /api/v1/goals/{id}
```

Recommended artifacts:

```text
data/model/update_goal_request_model.dart
domain/usecases/update_goal_use_case.dart
```

Tasks:

- Add repository and remote-data-source methods.
- Register the use case in `GoalBinding`.
- Add operation-specific controller state.
- Send only changed, backend-approved fields.
- Validate target, tenure, name, rate, frequency, and status.
- Refresh the affected goal once after success.

Acceptance criteria:

- Update failure preserves form values.
- Invalid values do not reach the API.
- One update causes no more than one refresh.
- Browser refresh displays the updated backend state.

### 3.2 Master-goal compatibility

Endpoint:

```http
GET /api/v1/goal/master
```

Tasks:

- Implement the confirmed response shape.
- If legacy and current environments differ, normalize both in the data layer.
- Expose a stable domain entity to the UI.
- Provide a custom-goal fallback when master loading fails.

Acceptance criteria:

- Templates render with valid name, icon, description, and suggested tenure.
- A broken icon shows a local fallback.
- An empty master list does not block custom goal creation.

## Phase 4: Complete planned-fund operations

### 4.1 Consolidate fund linking

Endpoint documented in the PDF:

```http
POST /api/v1/goal-orders
```

Tasks:

- Resolve `/goal-orders` versus `/goal-orders/save`.
- Create a typed request containing `goal_id` and `funds`.
- Validate fields according to `order_type`.
- Keep scheme codes as strings.
- Remove duplicate controller methods after confirming all callers.
- Preserve backward compatibility only if the deployed backend requires it.

SIP fields:

```text
scheme_code
order_type
sip_amount
sip_day
sip_start_date
sip_end_date (optional)
```

Lump-sum fields:

```text
scheme_code
order_type
lumpsum_amount
```

Step-up fields must remain disabled until BC-13 is resolved.

Acceptance criteria:

- Multiple funds can be submitted in the documented array when supported.
- A partial or complete failure is displayed accurately.
- Linking funds never increases actual investment.
- The success message says the fund was added to the plan, not invested.

### 4.2 Fetch planned funds and portfolio

Endpoint:

```http
GET /api/v1/goal/{id}/funds
```

Tasks:

- Compare this response with single-goal details.
- Add it only when it provides required independent data.
- Model `summary`, `funds`, and `actual` separately.
- Prevent simultaneous duplicate detail/fund calls.

Acceptance criteria:

- Planned totals do not overwrite actual totals.
- Empty funds produce an add-funds state.
- Detail-page refresh performs the minimum required requests.

### 4.3 Correct planned-fund update

Documented endpoint:

```http
PATCH /api/v1/goal-fund/{id}
```

Tasks:

- Resolve single versus bulk contract.
- Use `fundId` in the confirmed endpoint.
- Send the confirmed body shape.
- Validate SIP day, amount, dates, scheme rules, and order type.
- Clarify that editing a plan does not amend an active MFU instruction.

Acceptance criteria:

- Only the selected planned fund changes.
- Failed update leaves the previous UI value intact.
- Active SIP changes require the correct separate MFU workflow.

### 4.4 Planned-fund deletion

Endpoint:

```http
DELETE /api/v1/goal-fund/{id}
```

Tasks:

- Add duplicate-tap protection per fund ID.
- Recalculate or refetch planned totals after success.
- Preserve actual holdings and transaction history.
- Warn about active MFU instructions when applicable.

Acceptance criteria:

- Deleting one planned fund does not remove similarly numbered records from other goals.
- Monthly planned totals update correctly.
- Actual valuation remains unchanged.

### 4.5 Move one planned fund

Endpoint:

```http
POST /api/v1/goal-fund/{id}/move
```

Tasks:

- Add request/response model and entity.
- Add repository, use case, binding, and controller methods.
- Prevent moving to the same goal.
- Show source, destination, and fund in confirmation.
- Refresh both affected goals once.

Acceptance criteria:

- Ownership is validated by the backend.
- Failure leaves both goals unchanged.
- Actual holdings are not presented as moved.

### 4.6 Move all planned funds

Endpoint:

```http
POST /api/v1/goal/{id}/move-funds
```

Tasks:

- Add request/response model and entity.
- Require explicit bulk confirmation.
- Handle `moved_count: 0` according to confirmed behavior.
- Refresh source and destination goals.

Acceptance criteria:

- The user sees exactly which goal is the destination.
- Repeated taps do not send duplicate requests.
- Planned and actual data remain separate.

## Phase 5: User-friendly Goal experience

### 5.1 Goal creation journey

Use a guided flow:

```text
Choose template or custom goal
    -> Set target and target date
    -> Review SIP/lump-sum estimate
    -> Choose investment type
    -> Select funds
    -> Review the plan
    -> Save plan
    -> Optionally proceed to checkout
```

UX requirements:

- Preserve inputs when moving backward.
- Save and invest must be separate actions.
- Explain that returns are estimates, not guarantees.
- Prefer target date input and convert it to confirmed tenure months.
- Show inline errors beside fields.
- Disable submission while a request is running.
- Keep a custom-goal option available if templates fail.

### 5.2 Goal dashboard

Each card should display:

- goal name;
- target date;
- actual current value;
- target value;
- progress percentage;
- planned monthly investment;
- MFU/goal status in user-friendly language;
- next recommended action.

Suggested presentation states:

| Condition | User-facing state | Primary action |
| --- | --- | --- |
| No planned funds | Add funds | `Add funds` |
| Planned funds, no transaction | Plan ready | `Proceed to invest` |
| Order submitted | Investment processing | `View status` |
| Active successful SIP | On track | `View details` |
| Failed order | Action required | `Review order` |
| Behind target | Needs attention | `Review SIP` |
| Target reached | Goal achieved | `View goal` |
| NAV unavailable | Valuation unavailable | `Retry` |

Do not expose unexplained raw backend statuses as the main label.

### 5.3 Goal details

Separate the screen into:

1. Goal progress and actual valuation.
2. Planned contribution details.
3. Actual holdings.
4. Recent qualifying transactions.
5. MFU/order status.
6. Goal and planned-fund actions.

Always label planned and actual sections clearly.

### 5.4 Loading and refresh behavior

- Use skeleton cards for the first list load.
- Keep current data visible during background refresh.
- Use button-level loaders for create, update, delete, and move.
- Avoid blocking the full screen for one planned-fund action.
- Add pull-to-refresh on mobile where consistent with existing screens.
- Provide a visible retry action after recoverable failure.

### 5.5 Empty and error states

Implement:

- no goals;
- no master templates;
- goal without planned funds;
- planned funds without investment;
- no actual holdings;
- valuation unavailable;
- offline/timeout;
- expired session;
- deleted/not-found goal;
- malformed or partial response.

Do not replace the whole page with an error when only valuation is unavailable. Show the goal and isolate the unavailable section.

## Controller state plan

Preserve `GoalSipController` initially to avoid an unnecessary architecture change, but introduce operation-specific state.

Suggested state groups:

```text
Goal list:
- isLoadingGoals
- isRefreshingGoals
- goalListError

Goal details:
- selectedGoalDetails
- isLoadingGoalDetails
- goalDetailsError

Mutations:
- isCreatingGoal
- isUpdatingGoal
- deletingGoalIds
- updatingFundIds
- deletingFundIds
- movingFundIds
- isMovingAllFunds
```

Rules:

- Do not initiate requests inside widget `build()`.
- Guard route initialization from duplicate calls.
- Use `try/finally` for loading state.
- Do not update reactive state after controller disposal.
- Refresh only the affected resource where possible.
- Avoid nested `Obx` around entire pages.
- Dispose text controllers and workers.

Consider splitting the controller only as a separately approved refactor after API behavior is stable.

## Phase 6: Harden, test, and release

Complete the automated tests, manual scenarios, performance review, security review, and release gates described below.

Tasks:

- Run focused Goal tests before the complete Flutter test suite.
- Verify that Goal pages do not trigger duplicate API calls or unnecessary full-page rebuilds.
- Verify session expiry, direct web routes, browser navigation, and responsive layouts.
- Inspect logs for tokens and sensitive Goal/MFU data.
- Exercise the confirmed non-production API for every implemented endpoint.
- Obtain product, backend, financial, security, and regulatory sign-off where applicable.

Acceptance criteria:

- All relevant automated checks pass.
- Every required manual scenario has recorded results.
- No release-blocking backend decision remains open.
- No hardcoded or fallback investor data remains.
- Planned and actual investment values remain separated in all verified flows.

## File-level implementation map

| File or directory | Planned responsibility |
| --- | --- |
| `data/datasource/goal_remote_data_source.dart` | Correct existing calls and add missing HTTP operations |
| `data/repositories/goal_repository_impl.dart` | Map data results into domain results |
| `data/model/goal_model.dart` | Goal list/create and confirmed live valuation fields |
| `data/model/` | Add focused detail, update, portfolio, and move models |
| `domain/entity/goal_entity.dart` | Preserve current public goal entities and extend carefully |
| `domain/entity/` | Add focused detail, valuation, transaction, summary, and move entities |
| `domain/repositories/goal_repository.dart` | Declare each supported operation |
| `domain/usecases/` | Add one focused use case per missing operation |
| `domain/usecases/goal_use_cases.dart` | Aggregate approved use cases consistently |
| `presentation/bindings/goal_binding.dart` | Register new use cases without duplicate services/controllers |
| `presentation/controller/goal_sip_controller.dart` | Orchestrate UI state and operations |
| `presentation/pages/goal.dart` | Goal dashboard and empty/error states |
| `presentation/pages/goaldetails.dart` | Direct-load details, valuation, planned/actual sections |
| Master-goal creation pages | Guided creation, validation, review, and save behavior |
| `lib/config/routes/` | Change only if a confirmed route requirement cannot use existing routes |
| `test/features/goal/` | Model, repository, controller, widget, and navigation tests |

Do not rename current files, classes, routes, or public methods without separate approval.

## Scenario matrix

| Scenario | Expected behavior |
| --- | --- |
| New user with no goals | Friendly empty state and create action |
| Master API fails | Custom goal remains available |
| Invalid amount or tenure | Inline validation; no API call |
| Create timeout | Inputs preserved; retry available |
| Double create tap | One request only |
| Goal saved without funds | Actual value remains zero; add-funds action shown |
| Funds linked without checkout | Plan-ready state; actual progress unchanged |
| Transaction submitted | Processing status; progress follows confirmed MFU rule |
| Transaction fails | Actual value unchanged; action-required state |
| Duplicate status callback | No double counting; backend idempotency required |
| NAV unavailable | Last known value/date or unavailable state |
| Goal exceeds target | Apply confirmed over-target display rule |
| Update fails | Previous goal values remain visible |
| Delete has active SIP | Warning and separate cancellation guidance |
| Fund already linked | Explain conflict and offer edit/view action |
| Move to same goal | Block locally before API call |
| Bulk move has no funds | Safe no-op/empty result according to contract |
| Direct web detail URL | Load by goal ID after refresh |
| Session expires | Existing authentication recovery flow |
| Partial malformed response | Render usable sections and isolate failure where safe |

## Automated test plan

### Model tests

- Parse each confirmed success fixture.
- Parse number and decimal-string variations.
- Parse empty and null nested collections.
- Verify legacy field compatibility only where approved.
- Reject or safely handle unexpected root types.
- Verify planned and actual fields never map into each other.

### Remote data source tests

- Correct method, URL, headers, and body for every endpoint.
- JSON versus multipart behavior.
- Successful response.
- Validation response.
- Unauthorized response.
- Not-found response.
- Conflict/duplicate response.
- Server error, timeout, and malformed JSON.
- No sensitive logging.

### Repository and use-case tests

- Model-to-entity mapping.
- Success and `ApiError` propagation.
- No swallowed errors.
- Correct request object forwarded.

### Controller tests

- Loading flags reset on every path.
- Create failure does not set saved state.
- Duplicate submission protection.
- Session user is required.
- Delete updates the correct goal.
- Planned-fund mutations update the correct fund.
- Move refreshes source and destination once.
- Empty list is not treated as an error.
- No update after disposal.

### Widget and navigation tests

- Initial loading, content, empty, and error states.
- Guided creation validation.
- Planned versus actual labels.
- Status presentation and actions.
- Delete and move confirmations.
- Direct detail route and browser refresh.
- Browser back/forward and Android back.
- Mobile, tablet, desktop, and intermediate widths.
- Large amount and long goal-name rendering.

### Financial/MFU tests

- Planned fund does not affect actual investment.
- Failed order does not affect actual investment.
- Qualifying transaction updates the correct goal once.
- Latest NAV changes current value but not principal.
- Zero invested and zero target avoid division by zero.
- Duplicate callbacks do not duplicate units or amounts.
- Planned-fund deletion/movement does not change actual holdings.

## Manual verification checklist

For each supported platform:

- Create custom SIP goal.
- Create custom lump-sum goal.
- Create from master template.
- Retry failed create without losing data.
- Load goal list and detail.
- Refresh after a NAV update.
- Edit goal.
- Add one and multiple planned funds.
- Update and delete a planned fund.
- Move one and all planned funds.
- Handle empty, offline, timeout, and unauthorized cases.
- Verify navigation and URL synchronization.
- Verify checkout retains the correct goal association.
- Verify no duplicate API calls occur.
- Inspect logs for sensitive data.

## Required verification commands

After implementation:

```bash
dart format lib test
flutter analyze
flutter test
```

Run targeted Goal tests first, then the complete suite. Do not claim a command or scenario passed unless it was actually run.

## Release gates

The feature must not be considered production-ready until:

- all blocking backend decisions are resolved;
- environment URLs and authentication are correct;
- no fallback or hardcoded investor data remains;
- planned and actual values are separated end to end;
- MFU status and idempotency rules are confirmed;
- active SIP delete/update behavior is safe;
- sensitive logging is removed;
- goal-specific automated tests pass;
- mobile, tablet, and web flows are verified;
- direct web navigation and session restoration work;
- product, financial, security, and regulatory reviewers approve the behavior.

## Completion reporting format

After each approved phase, report:

```text
Changed files:
- ...

What changed:
- ...

Why:
- ...

API contract used:
- Confirmed endpoint and response version

Verification performed:
- Commands and manual scenarios actually run

Risks or remaining work:
- ...
```
