# Goal module implementation guide

This guide explains how to integrate and maintain the Goal module in the MF SIP Flutter application. It is based on `Goal_API_Documentation.pdf` and the current implementation under `lib/features/goal/`.

Use this document as an implementation aid. The PDF and the deployed backend contract remain the source of truth for endpoint behavior. Where the PDF and current application disagree, the discrepancy is called out explicitly and must be confirmed with the backend team before code is changed.

## Source and contract status

- Source document: [`Goal_API_Documentation.pdf`](Goal_API_Documentation.pdf)
- API prefix shown in the PDF: `/api/v1`
- Authentication: `Authorization: Bearer <TOKEN>`
- The PDF's base URL, `https://api.yourdomain.com/api/v1`, is a placeholder. Use `Appurl.baseUrl` and the application's selected environment.
- Do not hardcode production, staging, UAT, investor, user, scheme, or transaction values.
- The PDF examples document expected shapes but do not prove that every deployed environment returns the same envelope. Confirm discrepancies before changing parsers.

## Core business rule

Adding a planned fund to a goal must not increase the goal's actual invested amount or progress.

Actual investment and progress may change only after a real SIP or lump-sum transaction has reached a backend-recognized successful state. The PDF refers to `success`, `submitted`, and `completed`; the exact accepted statuses and their case sensitivity must be confirmed with the backend and MFU reconciliation rules.

Portfolio valuation must be calculated from executed units and the latest applicable NAV:

```text
current value = total executed units x latest NAV
gain/loss = current value - actual invested amount
gain/loss percentage = gain/loss / actual invested amount x 100
progress percentage = current value / target amount x 100
```

Guard every calculation against zero, negative, missing, stale, or malformed values. Prefer backend-calculated valuation fields when the backend is the authoritative ledger. Do not derive "actual invested" from planned goal-fund records.

## Existing application architecture

The current feature follows the application's Clean Architecture-style flow:

```text
Goal page/widget
    -> GoalSipController
    -> Goal use case
    -> GoalRepository contract
    -> GoalRepositoryImpl
    -> GoalRemoteDataSource
    -> NetworkServicesApi / Dio
    -> Backend API
```

Relevant implementation locations:

| Layer | Current location |
| --- | --- |
| Pages and widgets | `lib/features/goal/presentation/pages/`, `lib/features/goal/presentation/widget/` |
| Controller | `lib/features/goal/presentation/controller/goal_sip_controller.dart` |
| GetX binding | `lib/features/goal/presentation/bindings/goal_binding.dart` |
| Use cases | `lib/features/goal/domain/usecases/` |
| Entities | `lib/features/goal/domain/entity/` |
| Repository contract | `lib/features/goal/domain/repositories/goal_repository.dart` |
| Repository implementation | `lib/features/goal/data/repositories/goal_repository_impl.dart` |
| Remote data source | `lib/features/goal/data/datasource/goal_remote_data_source.dart` |
| Models | `lib/features/goal/data/model/` |
| Routes | `lib/config/routes/app_routes.dart`, `lib/config/routes/app_pages.dart` |

Preserve this flow when adding an endpoint. Do not call `NetworkServicesApi` directly from a controller or widget.

## Endpoint summary

| No. | Method | Path | Purpose | Current integration status |
| --- | --- | --- | --- | --- |
| 1 | GET | `/api/v1/goal/master` | Fetch master goal templates | Partially integrated; response shape differs from PDF |
| 2 | POST | `/api/v1/goals` | Create a goal | Integrated; request fields and tenure unit need review |
| 3 | GET | `/api/v1/goals/user/{user_id}` | Fetch user goals and live progress | Integrated; live valuation fields are not fully modeled |
| 4 | GET | `/api/v1/goal/{id}` | Fetch one goal and its valuation | Not integrated as a dedicated operation |
| 5 | PATCH | `/api/v1/goals/{id}` | Update goal details | Not integrated |
| 6 | DELETE | `/api/v1/goal/{id}` | Delete a goal | Integrated; success envelope needs confirmation |
| 7 | POST | `/api/v1/goal-orders` | Link one or more funds to a goal | Partially integrated; an undocumented `/goal-orders/save` path is also used |
| 8 | GET | `/api/v1/goal/{id}/funds` | Fetch planned funds and portfolio summary | Not integrated as a dedicated operation |
| 9 | PATCH | `/api/v1/goal-fund/{id}` | Update a planned fund | Current implementation omits `{id}` and sends a different body |
| 10 | DELETE | `/api/v1/goal-fund/{id}` | Delete a planned fund | Integrated |
| 11 | POST | `/api/v1/goal-fund/{id}/move` | Move one planned fund | Not integrated |
| 12 | POST | `/api/v1/goal/{id}/move-funds` | Move all planned funds | Not integrated |

## Shared request rules

### Authentication and session

Use the access token managed by `SessionManager`:

```http
Authorization: Bearer <access-token>
```

Before making a request:

1. Ensure session initialization has completed.
2. Ensure the authenticated user ID is available when required.
3. Do not silently substitute a fallback user ID.
4. Let the shared network layer handle the application's approved token-expiry and refresh behavior.
5. On an unrecoverable `401`, clear or redirect through the established expired-session flow rather than leaving the page in a loading state.

Never log tokens, authorization headers, complete investor responses, CAN data, transaction references, bank information, or other personal data.

### URL construction

Use `Appurl.baseUrl` and append the documented API path once:

```dart
final url = '${Appurl.baseUrl}/api/v1/goal/master';
```

Do not use the PDF placeholder domain. Confirm whether `Appurl.baseUrl` already contains a path prefix before changing URL construction.

### Result handling

Preserve the project's result type:

```dart
Future<Either<Result<T>, ApiError>>
```

The current convention is:

- `Left(Result.success(value))` for success.
- `Right(ApiError(message: ...))` for failure.

At the remote-data-source boundary:

- Validate that the response is a map or the specifically documented list shape before indexing it.
- Do not assume both `status` and `success` are always present.
- Parse the endpoint's documented data container, not a shared guessed container.
- Preserve a safe backend message when present.
- Convert unexpected response types and parse failures to a useful `ApiError` without exposing the payload.
- Keep HTTP status handling in the shared network layer where that is already the application convention.

### Numeric and date parsing

The PDF shows monetary values as both JSON numbers and decimal strings. Models must safely accept either form without losing precision unnecessarily.

- Treat goal and transaction IDs as integers only after safe conversion.
- Treat scheme codes as strings. Leading zeroes must not be lost.
- Treat currency and rates as numeric values in the domain, even if the API returns strings.
- Keep raw precision for calculations and round only for display.
- Send dates as `YYYY-MM-DD` where documented.
- Confirm timezone and business-date rules with the backend before generating SIP start dates.

## Detailed API contract

### 1. Master goals

```http
GET /api/v1/goal/master
```

Purpose: fetch predefined templates such as retirement, education, vacation, or home purchase.

The PDF shows a top-level array:

```json
{
    "status": true,
    "success": true,
    "message": "Master goals fetched successfully.",
    "data": [
        {
            "id": 1,
            "goal_type": "car",
            "logo": null,
            "goal_icon": "assets/icons/goals/car.png",
            "goal_description": "Plan your dream car purchase",
            "target_amount": "1000000.00",
            "monthly_investment": "12330.00",
            "expected_return_rate": "12.00",
            "goal_tenure": 5,
            "Invested_amount": "0.00",
            "status": "active",
            "is_created": false,
            "user_goal": null,
            "user_goal_id": null,
            "user_goals_count": 0,
            "invested_amount": 0,
            "progress_percent": 0
        },
        {
            "id": 2,
            "goal_type": "house",
            "logo": null,
            "goal_icon": "assets/icons/goals/house.png",
            "goal_description": "Save for your dream home",
            "target_amount": "3000000.00",
            "monthly_investment": "13391.00",
            "expected_return_rate": "12.00",
            "goal_tenure": 10,
            "Invested_amount": "0.00",
            "status": "active",
            "is_created": false,
            "user_goal": null,
            "user_goal_id": null,
            "user_goals_count": 0,
            "invested_amount": 0,
            "progress_percent": 0
        },
        {
            "id": 3,
            "goal_type": "education",
            "logo": null,
            "goal_icon": "assets/icons/goals/education.png",
            "goal_description": "Fund higher education for your children",
            "target_amount": "500000.00",
            "monthly_investment": "6165.00",
            "expected_return_rate": "12.00",
            "goal_tenure": 5,
            "Invested_amount": "0.00",
            "status": "active",
            "is_created": false,
            "user_goal": null,
            "user_goal_id": null,
            "user_goals_count": 0,
            "invested_amount": 0,
            "progress_percent": 0
        },
        {
            "id": 4,
            "goal_type": "marriage",
            "logo": null,
            "goal_icon": "assets/icons/goals/marriage.png",
            "goal_description": "Plan for marriage expenses",
            "target_amount": "1000000.00",
            "monthly_investment": "6368.00",
            "expected_return_rate": "12.00",
            "goal_tenure": 8,
            "Invested_amount": "0.00",
            "status": "active",
            "is_created": false,
            "user_goal": null,
            "user_goal_id": null,
            "user_goals_count": 0,
            "invested_amount": 0,
            "progress_percent": 0
        },
        {
            "id": 5,
            "goal_type": "retirement",
            "logo": null,
            "goal_icon": "assets/icons/goals/retirement.png",
            "goal_description": "Build a comfortable retirement corpus",
            "target_amount": "2000000.00",
            "monthly_investment": "4202.00",
            "expected_return_rate": "12.00",
            "goal_tenure": 15,
            "Invested_amount": "0.00",
            "status": "active",
            "is_created": false,
            "user_goal": null,
            "user_goal_id": null,
            "user_goals_count": 0,
            "invested_amount": 0,
            "progress_percent": 0
        },
        {
            "id": 6,
            "goal_type": "vacation",
            "logo": null,
            "goal_icon": "assets/icons/goals/vacation.png",
            "goal_description": "Plan your dream vacation getaway",
            "target_amount": "200000.00",
            "monthly_investment": "4643.00",
            "expected_return_rate": "12.00",
            "goal_tenure": 3,
            "Invested_amount": "0.00",
            "status": "active",
            "is_created": false,
            "user_goal": null,
            "user_goal_id": null,
            "user_goals_count": 0,
            "invested_amount": 0,
            "progress_percent": 0
        },
        {
            "id": 7,
            "goal_type": "other",
            "logo": null,
            "goal_icon": "assets/icons/goals/other.png",
            "goal_description": "Custom wealth creation & other goals",
            "target_amount": "100000.00",
            "monthly_investment": "3695.00",
            "expected_return_rate": "12.00",
            "goal_tenure": 2,
            "Invested_amount": "0.00",
            "status": "active",
            "is_created": false,
            "user_goal": null,
            "user_goal_id": null,
            "user_goals_count": 0,
            "invested_amount": 0,
            "progress_percent": 0
        }
    ],
    "user_goals": []
}
```

Current code expects a map with `status`, `message`, and `data`, and maps fields such as `goal_type`, `goal_icon`, `goal_description`, and `goal_tenure`.

Before changing the model, capture a sanitized response from each active backend environment and confirm whether the deployed response is:

- the PDF's raw list;
- a `{status, message, data}` envelope; or
- another legacy shape.

If backward compatibility is required, normalize supported shapes in the data model or data source and expose one stable domain entity.

### 2. Create a goal

```http
POST /api/v1/goals
```

Documented fields:

| Field | Type | Requirement | Notes |
| --- | --- | --- | --- |
| `goal_name` | string | Required | Maximum 120 characters |
| `target_amount` | numeric | Required | Target amount in INR; PDF states minimum `0` |
| `monthly_investment` | numeric | Required | Planned monthly SIP amount |
| `expected_return_rate` | numeric | Required | Expected annual return percentage |
| `goal_tenure` | integer | Required | Tenure in months |
| `frequency` | string | Required | PDF lists `Daily`, `Monthly`, `Quaterly`, `Yearly` |
| `goal_id` | integer | Optional | Master goal template ID |
| `txn_type` | string | Optional | `sip`, `lumpsum`, or `stepup` |
| `goal_cover` | file | Optional | JPG, PNG, or WebP; maximum 4 MB |

The sample includes `user_id`, although the request-parameter table does not list it. Confirm whether identity is derived from the token or whether `user_id` is required.

Sample JSON request from the PDF:

```json
{
  "user_id": 13008,
  "goal_id": 1,
  "goal_name": "Dream Home 2030",
  "target_amount": 2500000,
  "frequency": "Monthly",
  "monthly_investment": 15000,
  "expected_return_rate": 12.5,
  "goal_tenure": 60,
  "txn_type": "sip"
}
```

Documented success response:

```json
{
  "success": true,
  "message": "Goal created successfully.",
  "data": {
    "id": 12,
    "user_id": 13008,
    "goal_name": "Dream Home 2030",
    "target_amount": "2500000.00",
    "monthly_investment": "15000.00",
    "invested_amount": 0,
    "status": "pending",
    "created_date": "2026-09-17"
  }
}
```

Current implementation notes:

- `GoalSipController.saveGoalToDb()` sends `(years.value * 12).toInt()` as `goal_tenure`, aligned with the PDF contract defining tenure in months.
- The controller sends `invested_amount`, `lumpsum_amount`, `status`, and `created_date`, which are not listed as create parameters in the PDF. Do not remove or retain them by assumption; confirm the deployed contract.
- `goal_cover` requires multipart handling when provided. Do not place an `XFile` object in a normal JSON map unless `NetworkServicesApi` explicitly converts it to multipart data.
- Do not let the client initialize actual investment from a projection. The authoritative value should start from executed transactions.

### 3. User goals with live progress

```http
GET /api/v1/goals/user/{user_id}
```

Purpose: fetch all goals for a user, including live NAV valuation, actual investment, gain/loss, progress, MFU status, and planned funds.

Important documented fields:

```json
{
  "success": true,
  "message": "Goal funds fetched successfully.",
  "goal": [
    {
      "id": 1,
      "user_id": 13008,
      "goal_name": "Wealth Creation SIP Demo",
      "target_amount": "500000.00",
      "frequency": "Monthly",
      "monthly_investment": "1000.00",
      "goal_tenure": 60,
      "invested_amount": 1000,
      "actual_invested_amount": 1000,
      "actual_current_value": 1150.50,
      "actual_gain_loss": 150.50,
      "actual_gain_loss_percent": 15.05,
      "progress_percent": 0.23,
      "status": "active",
      "mfu_order_status": "SUBMITTED",
      "mfu_order_summary": {
        "total_orders": 1,
        "latest_status": "SUBMITTED",
        "pending": 0,
        "success": 1,
        "failed": 0,
        "total_amount": 1000
      },
      "goal_funds": []
    }
  ]
}
```

Current `GoalResponseModel` correctly reads the list from `goal`, but `UserGoalModel` does not model the documented `actual_*`, `progress_percent`, or `mfu_order_summary` fields. Its `investedAmount` parser currently uses `Invested_amount`, while the PDF uses lowercase `invested_amount`.

When completing this model:

- Keep planned and actual values as separate properties.
- Do not replace actual values with planned values when the response is null.
- Provide an explicit UI state when valuation is unavailable.
- Treat an empty `goal` list as a successful empty state.
- Do not show an error message such as "Login Failed" for a goal-list parsing or server error.

### 4. Single goal details and valuation

```http
GET /api/v1/goal/{id}
```

Purpose: return a goal's detailed portfolio, scheme-level valuation, and executed transactions.

Documented data includes:

- `actual_invested_amount`
- `actual_current_value`
- `actual_gain_loss`
- `actual_gain_loss_percent`
- preformatted `actual_display` values
- `actual_funds` with scheme code, fund name, invested amount, units, NAV, current value, and gain/loss
- `actual_transactions` with transaction ID, scheme code, type, amount, units, NAV, status, and transaction date

Create dedicated models and entities for these nested structures rather than adding untyped maps to `GoalSipController`.

The API's numeric values should drive calculations. Use `actual_display` only for display if product requirements explicitly prefer server formatting; otherwise use the application's own INR formatting for consistency.

### 5. Update a goal

```http
PATCH /api/v1/goals/{id}
```

The PDF says this endpoint can update goal targets, monthly investment, tenure, expected return, frequency, name, or status.

Sample request:

```json
{
  "target_amount": 3000000,
  "monthly_investment": 20000,
  "goal_tenure": 72,
  "status": "active"
}
```

Implement an explicit update request rather than resending the create payload blindly. Send only fields allowed by the confirmed backend contract. Preserve the tenure-in-months rule.

After success, either update the matching reactive entity safely or refetch the relevant goal. Avoid triggering multiple list and detail refreshes for one user action.

### 6. Delete a goal

```http
DELETE /api/v1/goal/{id}
```

Documented response:

```json
{
  "success": true,
  "message": "Goal deleted successfully."
}
```

Current `DeleteGoalFundModel` checks `status`. Confirm whether the deployed endpoint returns `status`, `success`, or both. A compatible delete response model may normalize both booleans if the backend has mixed versions.

Deletion behavior must be confirmed for goals that contain:

- planned funds only;
- pending MFU orders;
- active SIPs or mandates;
- completed transactions or units;
- audit or regulatory history.

Do not assume that deleting a goal cancels an MFU instruction or deletes transaction history. Require confirmation in the UI, prevent duplicate taps, and refetch the list after confirmed success.

### 7. Link funds to a goal

```http
POST /api/v1/goal-orders
```

Documented request structure:

| Field | Type | Requirement |
| --- | --- | --- |
| `goal_id` | integer | Required |
| `funds` | array | Required and non-empty |
| `funds.*.scheme_code` | string | Required |
| `funds.*.order_type` | string | Required: `sip`, `lumpsum`, or `stepup` |
| `funds.*.sip_amount` | numeric | Required for SIP |
| `funds.*.sip_day` | integer | Required for SIP; 1 through 28 |
| `funds.*.sip_start_date` | date | Required for SIP |
| `funds.*.sip_end_date` | date | Optional |
| `funds.*.lumpsum_amount` | numeric | Required for lump sum |
| `funds.*.top_up_amount` | numeric | Required for step-up according to the PDF |

Sample request:

```json
{
  "goal_id": 1,
  "funds": [
    {
      "scheme_code": "152074",
      "order_type": "sip",
      "sip_amount": 5000,
      "sip_day": 10,
      "sip_start_date": "2026-10-10",
      "sip_end_date": "2031-10-10"
    }
  ]
}
```

Current code has two paths:

- `/api/v1/goal-orders` in `GoalRemoteDataSource.saveGoalFund()`;
- undocumented `/api/v1/goal-orders/save` in `GoalRemoteDataSource.saveGoalToFund()`.

The controller currently calls `SaveGoalFundUseCase`, which uses `/goal-orders/save` and sends a flat single-fund payload. A second `GoalFundOrderUseCase` targets the documented endpoint but is not used by the controller.

Confirm whether `/goal-orders/save` is a legacy endpoint. Then consolidate behavior through the existing architecture without retaining duplicate request logic. Do not remove the legacy path until all calling flows and backend compatibility have been verified.

Linking a fund is a planning operation. It must not be treated as an executed SIP or lump-sum purchase.

### 8. Get goal funds and portfolio

```http
GET /api/v1/goal/{id}/funds
```

Documented response sections:

```json
{
  "success": true,
  "message": "Goal funds fetched successfully.",
  "summary": {
    "total_funds": 1,
    "sip_count": 1,
    "lumpsum_count": 0,
    "sip_amount": 5000,
    "planned_total_amount": 5000
  },
  "funds": [],
  "actual": {}
}
```

Model `summary`, `funds`, and `actual` separately. The planned summary and actual portfolio serve different purposes and must not be merged.

Use this endpoint for a goal-detail fund view only after confirming whether endpoint 4 already contains all required data. Avoid calling both endpoints on every rebuild if one response is sufficient.

### 9. Update a planned fund

```http
PATCH /api/v1/goal-fund/{id}
```

Sample request:

```json
{
  "sip_amount": 7500,
  "sip_day": 15
}
```

Current code calls `/api/v1/goal-fund` without the ID and wraps a list in `{ "funds": [...] }`. The method receives `fundId` but does not use it in the URL.

Do not change this implementation until the backend confirms whether it supports:

- the PDF's single-resource endpoint;
- the current bulk endpoint;
- or both endpoints for different use cases.

Validate order-type-specific fields. Updating a planned goal allocation must not silently amend or cancel an already submitted MFU SIP. If an active transaction instruction must change, use the appropriate MFU cancellation and resubmission workflow.

### 10. Delete a planned fund

```http
DELETE /api/v1/goal-fund/{id}
```

The PDF says deletion removes the planned fund and recalculates the goal's monthly investment total.

Documented response contains `status`, `success`, and `message`. Treat the operation as successful only according to the confirmed backend contract.

After success:

- remove or refresh the correct fund record;
- refresh the goal's planned totals;
- do not alter actual holdings or transaction history;
- do not assume an active MFU SIP has been cancelled.

### 11. Move one planned fund

```http
POST /api/v1/goal-fund/{id}/move
```

Request:

```json
{
  "to_goal_id": 2
}
```

Response data contains `from_goal_id` and `to_goal_id`.

Validate that source and destination goals exist, belong to the authenticated user, and are not the same goal. Disable repeated submission and refresh both goals after success.

### 12. Move all planned funds

```http
POST /api/v1/goal/{id}/move-funds
```

Request:

```json
{
  "to_goal_id": 2
}
```

Response data contains `from_goal_id`, `to_goal_id`, and `moved_count`.

Require explicit user confirmation because this changes every planned allocation for the source goal. A successful response with `moved_count: 0` should be handled as a valid no-op unless the backend defines it as an error.

Confirm whether actual holdings, pending orders, or only planned goal-fund records are moved. The PDF describes planned funds; do not infer that transaction ownership or MFU references move with them.

## Recommended implementation pattern

For each missing or corrected operation, make the smallest consistent vertical slice.

### Data layer

1. Add a request model when the body has conditional fields or nested structures.
2. Add endpoint-specific response models with safe parsing.
3. Add one method to `GoalRemoteDataSource`.
4. Use the correct `NetworkServicesApi` method and bearer header.
5. Return `Either<Result<Model>, ApiError>`.
6. Do not log the complete request or response.

### Domain layer

1. Add or extend immutable entities for data used by presentation.
2. Map models to entities in one location.
3. Add the method to `GoalRepository`.
4. Implement it in `GoalRepositoryImpl`.
5. Add a focused use case.

Avoid importing data-layer models into domain entities for convenience. New work should preserve the intended layer boundary and should not expand existing cross-layer coupling.

### Dependency registration

Register each new use case in `GoalBinding`, then inject it through `GoalUseCases` or directly into the controller according to the existing feature convention.

Check that:

- `NetworkServicesApi` is registered before `GoalBinding` runs;
- no duplicate `GoalSipController` is created;
- `fenix: true` behavior does not cause unexpected state restoration;
- workers, controllers, and text controllers are disposed correctly.

### Controller and UI

Expose operation-specific reactive state. A single global loading boolean is not sufficient when list fetch, delete, update, and move operations can occur independently.

For each operation support:

- initial state;
- loading state;
- success state;
- empty state where applicable;
- validation failure;
- network/server failure;
- unauthorized session;
- retry without duplicate submission;
- page disposal during an in-flight request.

Keep `Obx` scopes small and do not start requests from `build()`. Deduplicate initial loads triggered by route bindings, page lifecycle, and post-frame callbacks.

## Validation rules

Apply local validation for user experience, but treat backend validation as authoritative.

### Goal validation

- Goal name: required and no more than 120 characters.
- Target amount: confirm whether zero is genuinely allowed for a usable goal; reject negative values.
- Expected return: validate the product-approved range and do not assume the PDF implies an upper bound.
- Tenure: positive integer in months.
- Frequency: use backend values exactly. The PDF spells quarterly as `Quaterly`; confirm whether this typo is the literal API enum.
- Transaction type: `sip`, `lumpsum`, or `stepup` only when confirmed.
- Cover image: JPG, PNG, or WebP, maximum 4 MB.

### Fund validation

- Scheme code: required string from scheme master data.
- SIP amount: meet the selected scheme's current minimum and increment rules.
- SIP day: 1 through 28 according to the Goal PDF.
- Start and end dates: valid ordering and eligible business dates.
- Lump-sum amount: meet current scheme thresholds.
- Step-up amount and schedule: confirm complete requirements because the PDF documents only part of the step-up contract.
- Destination goal: required, owned by the authenticated user, and different from the source goal.

Scheme minimums and transaction eligibility must come from current scheme/threshold data, not hardcoded UI values.

## MFU and transaction integration

The Goal API organizes investments around a user objective. MFU remains responsible for real transaction execution and status.

Keep these concepts separate:

| Goal concept | Transaction concept |
| --- | --- |
| Planned fund | Selected scheme allocation |
| Planned SIP amount | Intended installment |
| Goal fund status | Goal-planning record status |
| MFU order status | External transaction/instruction status |
| Actual invested amount | Money represented by qualifying executed transactions |
| Actual units | Units allotted by executed transactions |

When checkout submits a real transaction:

1. Retain the goal ID and goal-fund association in the supported transaction payload or backend mapping.
2. Store the returned MFU/application reference against the correct goal context.
3. Reconcile asynchronous status updates idempotently.
4. Do not count failed, rejected, expired, or duplicate orders as invested.
5. Confirm how `SUBMITTED` affects actual investment because the PDF's wording is broader than normal settled-unit accounting.
6. Refresh goal valuation only after the backend has processed the relevant transaction or NAV update.

Never generate or guess MFU references in the Flutter client.

## Navigation and responsive behavior

The feature uses named routes from `AppRoutes` and registrations in `AppPages`, including goal list, master-goal, and goal-detail flows.

When adding or changing a Goal screen:

- preserve `GoalBinding` registration;
- pass stable identifiers through named-route arguments or path parameters according to existing route conventions;
- support direct Flutter Web URL access and refresh;
- synchronize desktop navigation selection with the active route;
- test browser back/forward and Android system back;
- avoid depending only on an in-memory entity passed from the previous page;
- refetch by goal ID when a detail route is opened directly.

Test mobile, tablet, and desktop widths, including intermediate browser widths and constrained heights. Reuse the current theme and goal widgets rather than creating parallel mobile/web business logic.

## Security and privacy

- Never log access tokens or authorization headers.
- Do not log complete goal, fund, transaction, or portfolio responses.
- Mask user IDs and transaction references when diagnostic logging is necessary.
- Do not store valuation responses or transaction details in insecure preferences unless already approved by the application's security design.
- Use the session's authenticated identity; do not trust a user-editable `user_id`.
- Validate server-side ownership for every goal and goal-fund ID.
- Do not expose raw exception text to users if it may contain request data or internal URLs.
- Do not cache cover-image upload URLs beyond their intended lifetime without confirmation.

## Current contract gaps to resolve

Before declaring the Goal module complete, confirm the following with the backend team:

1. Is the master-goal response a raw list or a wrapped `data` response?
2. Which master-goal field names are current: `name`/`icon` or `goal_type`/`goal_icon`?
3. Is `user_id` required in create and fund-link requests, or derived from the token?
4. Is goal tenure always expressed in months?
5. Is the literal frequency enum `Quaterly`, or should it be `Quarterly`?
6. Are client-supplied `invested_amount`, `status`, and `created_date` ignored, rejected, or accepted on create?
7. Is `/goal-orders/save` still supported, and how does it differ from `/goal-orders`?
8. Does fund update use `/goal-fund/{id}` with a flat body or `/goal-fund` with a `funds` array?
9. Which endpoints return `status`, `success`, or both?
10. Which MFU statuses qualify for actual investment and progress?
11. Does deleting a goal or planned fund affect active MFU instructions?
12. Do move operations move only planned records, or can they move holdings or pending orders?
13. What are the complete step-up fields, ranges, and schedule rules?
14. What is the expected error envelope for validation, authentication, not found, conflict, and server failures?
15. Does `goal_cover` require multipart form data for the whole create request?

Record confirmed answers in this guide before implementing behavior that depends on them.

## Suggested delivery sequence

Implement and verify changes in small vertical slices:

1. Confirm the deployed API contract and sanitize representative responses.
2. Correct shared goal models for lowercase investment fields and live valuation data.
3. Add single-goal details so direct detail routes can load independently.
4. Reconcile the two goal-order creation paths and add conditional fund validation.
5. Correct or separate single-fund and bulk fund update behavior.
6. Add goal update.
7. Add the dedicated goal-funds portfolio endpoint only if endpoint 4 is insufficient.
8. Add single-fund move and bulk move with confirmation and duplicate-tap protection.
9. Harden delete behavior around active MFU instructions.
10. Add automated tests before enabling the completed flows in production.

Do not combine these steps with unrelated UI refactoring.

## Testing strategy

### Model tests

For every response model, test:

- the exact PDF sample;
- numeric strings and JSON numbers;
- absent optional fields;
- null nested objects;
- empty arrays;
- unexpected response containers;
- `status` versus `success` compatibility only where confirmed;
- lowercase and legacy field names only where backward compatibility is required.

### Remote data source and repository tests

Verify:

- correct HTTP method and URL;
- bearer header presence without logging it;
- correct JSON or multipart body;
- model-to-entity mapping;
- successful response;
- validation error;
- unauthorized response;
- not-found response;
- conflict or duplicate response;
- server error;
- timeout and offline behavior;
- malformed JSON and unexpected response type.

### Controller tests

Verify:

- loading state resets on both success and failure;
- duplicate button taps cause one request;
- empty results render as empty state, not error;
- create refreshes the list once;
- update refreshes the relevant item once;
- delete removes the goal, not a fund with a matching ID;
- moving funds refreshes both source and destination;
- no state update is attempted after disposal;
- errors use goal-specific messages.

### Widget and navigation tests

Verify:

- loading, success, empty, and error layouts;
- goal list to detail navigation;
- direct detail URL and browser refresh;
- browser back/forward and Android back;
- mobile, tablet, desktop, and intermediate widths;
- long goal names and large formatted amounts;
- unavailable NAV or valuation state;
- confirmation dialogs and disabled submit buttons.

### Financial and MFU scenarios

Verify:

- adding a planned fund does not change actual investment;
- failed transactions do not change actual investment;
- duplicate status callbacks do not double-count investment or units;
- qualifying transactions update the correct goal once;
- latest NAV updates current value without changing invested principal;
- zero target and zero invested values do not divide by zero;
- progress display follows the agreed cap or over-target product rule;
- deleting or moving a planned fund does not alter actual holdings;
- SIP cancellation and goal deletion remain separate operations.

## Verification commands

After an approved implementation change, run the smallest relevant tests first and then the project checks:

```bash
dart format lib test
flutter analyze
```

Also manually verify the affected API against the selected non-production environment. Do not report a flow as passed unless it was actually exercised.

## Definition of done

A Goal API operation is complete only when:

- its deployed contract is confirmed;
- request validation matches the confirmed business rules;
- model, entity, repository, use case, binding, controller, and UI wiring are complete;
- authentication and session-expiry behavior are handled;
- loading, success, empty, and error states are implemented;
- duplicate requests are prevented;
- sensitive data is not logged;
- mobile and web navigation work;
- planned and actual investment remain correctly separated;
- relevant automated and manual checks pass;
- this guide is updated for any contract or architecture change.
