# Complete Goal Feature API Guide & Technical Specification

> **Project:** `SIP-Backend-Ridit`  
> **Module:** Goal-Based Financial Planning & Portfolio Tracking  
> **Framework:** Laravel 12 (RESTful JSON APIs)  
> **Client Consumer:** Flutter Mobile Application (Android & iOS)  
> **Authentication:** Laravel Sanctum (`Authorization: Bearer <token>`)  

---

## 1. Architectural Overview & Goal Lifecycle

The **Goal Feature** enables investors to link mutual fund investments (both one-time Lumpsum and recurring SIPs) to real-life financial aspirations (e.g., Retirement, Dream Home, Child Education, Car, Vacation).

```
                      ┌───────────────────────────────────────┐
                      │ 1. Browse Master Catalog               │
                      │    GET /api/v1/goal/master            │
                      └──────────────────┬────────────────────┘
                                         │
                                         ▼
                      ┌───────────────────────────────────────┐
                      │ 2. Create User Goal                   │
                      │    POST /api/v1/goals                 │
                      └──────────────────┬────────────────────┘
                                         │
                 ┌───────────────────────┴───────────────────────┐
                 ▼                                               ▼
   Option A: Direct Investment                    Option B: Map Planned Funds
   POST /api/v1/invest/sip                        POST /api/v1/goal-orders
   POST /api/v1/invest/lumpsum                    (Pre-plan funds to invest)
   { "goal_id": 1, ... }                                         │
                 │                                               │
                 └───────────────────────┬───────────────────────┘
                                         │
                                         ▼
                      ┌───────────────────────────────────────┐
                      │ 3. Track Live Progress & Valuation    │
                      │    GET /api/v1/goals                  │
                      │    GET /api/v1/goals/{id}             │
                      │    (Live NAVs, returns, % achieved)   │
                      └──────────────────┬────────────────────┘
                                         │
            ┌────────────────────────────┼────────────────────────────┐
            ▼                            ▼                            ▼
  Move Fund Between Goals      Link Existing Holding        Delete / Unlink Goal
  POST /goal-fund/{id}/move    POST /goal/{id}/link-fund    DELETE /goals/{id}
```

---

## 2. Common Request Headers

All protected endpoints require the following HTTP headers:

```http
Authorization: Bearer <sanctum_bearer_token>
Accept: application/json
Content-Type: application/json
```
*(Note: For file upload endpoints like `goal_cover`, use `Content-Type: multipart/form-data`)*

---

## 3. Master Goal Catalog

### 3.1 Get Master Goals List
Fetch the predefined system goal categories with official icons, target amounts, tenures, and default expected return rates.

* **Endpoint:** `GET /api/v1/goal/master` or `GET /api/v1/goal/master/{user_id?}`
* **Auth Required:** Yes (`Bearer <token>`)

#### Request Parameters
| Parameter | In | Type | Required / Optional | Description |
| :--- | :--- | :--- | :---: | :--- |
| `user_id` | Path / Query | Integer | **Optional** | User ID for audit (defaults to token user). |

#### cURL Example
```bash
curl -X GET "https://sip-backend.londonstreetstore.com/api/v1/goal/master" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN"
```

#### Success Response (`HTTP 200`)
```json
{
  "status": true,
  "success": true,
  "message": "Master goals fetched successfully.",
  "data": [
    {
      "id": 1,
      "goal_type": "car",
      "goal_name": "Car",
      "goal_description": "Plan your dream car purchase",
      "target_amount": 1000000.00,
      "monthly_investment": 12330.00,
      "expected_return_rate": 12.00,
      "goal_tenure": 5,
      "invested_amount": 0.00,
      "status": "active",
      "goal_icon": "https://sip-backend.londonstreetstore.com/assets/goal-img/car.png",
      "logo": "https://sip-backend.londonstreetstore.com/assets/goal-img/car.png"
    },
    {
      "id": 2,
      "goal_type": "house",
      "goal_name": "Dream Home",
      "goal_description": "Save for your dream home",
      "target_amount": 3000000.00,
      "monthly_investment": 13391.00,
      "expected_return_rate": 12.00,
      "goal_tenure": 10,
      "invested_amount": 0.00,
      "status": "active",
      "goal_icon": "https://sip-backend.londonstreetstore.com/assets/goal-img/home.png",
      "logo": "https://sip-backend.londonstreetstore.com/assets/goal-img/home.png"
    },
    {
      "id": 3,
      "goal_type": "education",
      "goal_name": "Child Education",
      "goal_description": "Fund higher education for your children",
      "target_amount": 500000.00,
      "monthly_investment": 6165.00,
      "expected_return_rate": 12.00,
      "goal_tenure": 5,
      "invested_amount": 0.00,
      "status": "active",
      "goal_icon": "https://sip-backend.londonstreetstore.com/assets/goal-img/education.png",
      "logo": "https://sip-backend.londonstreetstore.com/assets/goal-img/education.png"
    },
    {
      "id": 4,
      "goal_type": "marriage",
      "goal_name": "Marriage",
      "goal_description": "Save for dream wedding",
      "target_amount": 1000000.00,
      "monthly_investment": 6368.00,
      "expected_return_rate": 12.00,
      "goal_tenure": 8,
      "invested_amount": 0.00,
      "status": "active",
      "goal_icon": "https://sip-backend.londonstreetstore.com/assets/goal-img/marr.png",
      "logo": "https://sip-backend.londonstreetstore.com/assets/goal-img/marr.png"
    },
    {
      "id": 5,
      "goal_type": "retirement",
      "goal_name": "Retirement",
      "goal_description": "Build comfortable retirement corpus",
      "target_amount": 2000000.00,
      "monthly_investment": 4202.00,
      "expected_return_rate": 12.00,
      "goal_tenure": 15,
      "invested_amount": 0.00,
      "status": "active",
      "goal_icon": "https://sip-backend.londonstreetstore.com/assets/goal-img/retirement.png",
      "logo": "https://sip-backend.londonstreetstore.com/assets/goal-img/retirement.png"
    },
    {
      "id": 6,
      "goal_type": "vacation",
      "goal_name": "Vacation",
      "goal_description": "Save for your dream holiday travel",
      "target_amount": 200000.00,
      "monthly_investment": 4643.00,
      "expected_return_rate": 12.00,
      "goal_tenure": 3,
      "invested_amount": 0.00,
      "status": "active",
      "goal_icon": "https://sip-backend.londonstreetstore.com/assets/goal-img/vacation.png",
      "logo": "https://sip-backend.londonstreetstore.com/assets/goal-img/vacation.png"
    }
  ]
}
```

---

## 4. User Goal Management (CRUD)

### 4.1 Create a User Goal
Creates an active investment goal for the authenticated user.

* **Endpoint:** `POST /api/v1/goals`
* **Auth Required:** Yes (`Bearer <token>`)

#### Request Parameters
| Parameter | Type | Required / Optional | Allowed Values / Validation | Description |
| :--- | :--- | :---: | :--- | :--- |
| `target_amount` | Numeric | **Required** | `min:0` | Target corpus amount in ₹ (e.g., `1000000`). |
| `frequency` | String | **Required** | `Daily`, `Monthly`, `Quaterly`, `Yearly` | Contribution frequency (Case-sensitive). |
| `monthly_investment`| Numeric | **Required** | `min:0` | Recommended/planned installment amount (e.g. `12330`). |
| `expected_return_rate`| Numeric | **Required** | `min:0, max:100` | Expected CAGR % (e.g., `12` or `14.5`). |
| `goal_tenure` | Integer | **Required** | `min:0` | Tenure in years (e.g., `5` for 5 years). |
| `goal_name` | String | **Conditional** | `max:120` | Custom name (e.g. "My Tesla Car"). **Required** if `goal_id` is omitted. |
| `goal_id` | Integer | **Optional** | Master goal ID (`1` to `6`) | Links to predefined Master Goal template. |
| `txn_type` | String | **Optional** | `sip`, `lumpsum`, `stepup` | Investment strategy chosen. |
| `lumpsum_amount` | Numeric | **Optional** | `min:0` | Initial one-time seed amount if any. |
| `status` | String | **Optional** | `pending`, `initial`, `active`, `achieved`, `paused` | Initial goal status (Default: `pending`). |
| `goal_cover` | File / Image | **Optional** | `jpg, jpeg, png, webp, max: 4096 KB` | Custom background cover image. |
| `user_id` | Integer | **Optional** | Automatically set to authenticated Sanctum user. |

#### cURL Example (JSON Payload)
```bash
curl -X POST "https://sip-backend.londonstreetstore.com/api/v1/goals" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN" \
  -d '{
    "goal_id": 1,
    "goal_name": "Buy BMW 3 Series",
    "target_amount": 5000000,
    "frequency": "Monthly",
    "monthly_investment": 55000,
    "expected_return_rate": 12.5,
    "goal_tenure": 5,
    "lumpsum_amount": 100000,
    "txn_type": "sip"
  }'
```

#### Success Response (`HTTP 201 Created`)
```json
{
  "status": true,
  "success": true,
  "message": "Goal created successfully.",
  "data": {
    "id": 14,
    "goal_id": 1,
    "user_id": 42,
    "goal_name": "Buy BMW 3 Series",
    "target_amount": "5000000.00",
    "frequency": "Monthly",
    "monthly_investment": "55000.00",
    "expected_return_rate": "12.50",
    "goal_tenure": 5,
    "invested_amount": "0.00",
    "lumpsum_amount": "100000.00",
    "txn_type": "sip",
    "status": "pending",
    "created_date": "2026-11-13",
    "created_at": "2026-11-13T09:40:00.000000Z",
    "updated_at": "2026-11-13T09:40:00.000000Z",
    "goal": {
      "id": 1,
      "goal_type": "car",
      "target_amount": 1000000.00
    }
  }
}
```

---

### 4.2 Update a User Goal
Updates target amount, duration, return expectation, status, or cover image of an existing goal.

* **Endpoint:** `PATCH /api/v1/goals/{id}` (also accepts `PUT` or `POST`)
* **Auth Required:** Yes (`Bearer <token>`)

#### Request Parameters
| Parameter | Type | Required / Optional | Description |
| :--- | :--- | :---: | :--- |
| `id` | Path | Integer | **Required** | Goal ID to update. |
| `goal_name` | String | **Optional** | Updated goal title. |
| `target_amount` | Numeric | **Optional** | Updated target corpus amount. |
| `frequency` | String | **Optional** | `Daily`, `Monthly`, `Quaterly`, `Yearly`. |
| `monthly_investment`| Numeric | **Optional** | Updated installment amount. |
| `expected_return_rate`| Numeric | **Optional** | Updated return percentage (`0` to `100`). |
| `goal_tenure` | Integer | **Optional** | Updated tenure in years. |
| `lumpsum_amount` | Numeric | **Optional** | Updated initial lumpsum. |
| `status` | String | **Optional** | `active`, `achieved`, `paused`, `pending`. |
| `goal_cover` | File / Image | **Optional** | Replace cover image. |

#### cURL Example
```bash
curl -X PATCH "https://sip-backend.londonstreetstore.com/api/v1/goals/14" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN" \
  -d '{
    "target_amount": 6000000,
    "monthly_investment": 65000,
    "status": "active"
  }'
```

#### Success Response (`HTTP 200`)
```json
{
  "status": true,
  "success": true,
  "message": "Goal updated successfully.",
  "data": {
    "id": 14,
    "goal_name": "Buy BMW 3 Series",
    "target_amount": 6000000.00,
    "saved_amount": 120500.00,
    "remaining_amount": 5879500.00,
    "progress_percent": 2.01,
    "status": "active"
  }
}
```

---

### 4.3 Get User Goals List (Portfolio Summary)
Fetches all active goals for the user with calculated progress, live portfolio valuations, and completion deadlines.

* **Endpoint:** `GET /api/v1/goals` or `GET /api/v1/goals/user/{user_id}`
* **Auth Required:** Yes (`Bearer <token>`)

#### Query Parameters
| Parameter | Type | Required / Optional | Description |
| :--- | :--- | :---: | :--- |
| `full` | Boolean | **Optional** | `?full=true` returns raw Eloquent models with nested relations. |
| `details` | Boolean | **Optional** | `?details=true` same as `full`. |

#### cURL Example
```bash
curl -X GET "https://sip-backend.londonstreetstore.com/api/v1/goals" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN"
```

#### Success Response (`HTTP 200`)
```json
{
  "success": true,
  "message": "Goals fetched successfully.",
  "goal": [
    {
      "id": 14,
      "goal_name": "Buy BMW 3 Series",
      "target_amount": 5000000.00,
      "saved_amount": 250000.00,
      "remaining_amount": 4750000.00,
      "progress_percent": 5.00,
      "goal_cover": "https://sip-backend.londonstreetstore.com/assets/goal-img/car.png",
      "start_date": "2026-11-13",
      "end_date": "2031-11-13",
      "duration": "5 Years"
    },
    {
      "id": 15,
      "goal_name": "Dream Villa in Goa",
      "target_amount": 10000000.00,
      "saved_amount": 1500000.00,
      "remaining_amount": 8500000.00,
      "progress_percent": 15.00,
      "goal_cover": "https://sip-backend.londonstreetstore.com/assets/goal-img/home.png",
      "start_date": "2026-01-15",
      "end_date": "2036-01-15",
      "duration": "10 Years"
    }
  ]
}
```

---

### 4.4 Get Single Goal Details & Fund Breakdown
Returns in-depth valuation of a goal, including target savings milestones, live NAVs of linked funds, allotment status, and transaction history.

* **Endpoint:** `GET /api/v1/goals/{id}` or `GET /api/v1/goal/{id}`
* **Auth Required:** Yes (`Bearer <token>`)

#### Request Parameters
| Parameter | In | Type | Required / Optional | Description |
| :--- | :--- | :--- | :---: | :--- |
| `id` | Path | Integer | **Required** | Goal ID. |

#### cURL Example
```bash
curl -X GET "https://sip-backend.londonstreetstore.com/api/v1/goals/14" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN"
```

#### Success Response (`HTTP 200`)
```json
{
  "success": true,
  "message": "Goal details fetched successfully.",
  "data": {
    "id": 14,
    "goal_name": "Buy BMW 3 Series",
    "goal_cover": "https://sip-backend.londonstreetstore.com/assets/goal-img/car.png",
    "status": "active",
    "investment_type": "SIP",
    "investment_amount": 55000.00,
    "frequency": "Monthly",
    "sip_amount": 55000.00,
    "lumpsum_amount": 100000.00,
    "target_amount": 5000000.00,
    "saved_amount": 250000.00,
    "remaining_amount": 4750000.00,
    "progress_percent": 5.00,
    "est_year": "2031",
    "start_date": "2026-11-13",
    "end_date": "2031-11-13",
    "duration": "5 Years",
    "expected_return_rate": 12.50,
    "daily_savings": 1833.33,
    "weekly_savings": 12833.33,
    "monthly_savings": 55000.00,
    "goal_tenure": 5,
    "linked_funds": [
      {
        "fund_name": "Parag Parikh Flexi Cap Fund - Regular Growth",
        "scheme_code": "122639",
        "amc_logo": "https://sip-backend.londonstreetstore.com/assets/amc-logo/ppfas.png",
        "folio_no": "1049281729",
        "investment_type": "sip",
        "type": "sip",
        "invested_amount": 150000.00,
        "current_value": 168450.25,
        "total_units": 2341.2054,
        "purchase_nav": 64.08,
        "current_nav": 71.95,
        "nav_date": "2026-11-12",
        "gain_loss": 18450.25,
        "gain_loss_percent": 12.30,
        "one_day_return": 340.50,
        "one_day_return_percent": 0.20,
        "allotment_status": "unit_allotted",
        "unit_status": "Units Allotted",
        "allotment_message": "Units allotted.",
        "is_unit_allotted": true,
        "is_sip": true,
        "sip_status": "active",
        "mfu_order_id": 89,
        "goal_id": 14
      }
    ],
    "transactions": [
      {
        "id": 102,
        "mf_order_id": "EGRN202611130001",
        "folio_no": "1049281729",
        "scheme_code": "122639",
        "amount": 55000.00,
        "nav": 71.95,
        "units": 764.4197,
        "status": "success",
        "txn_date": "2026-11-13"
      }
    ]
  }
}
```

---

### 4.5 Delete a User Goal
Deletes the goal and clears all goal associations.

> [!IMPORTANT]
> Deleting a goal **DOES NOT redeem units or stop SIPs**. The mutual fund units and active SIPs remain safe in the investor's master portfolio; they are simply unlinked from the goal.

* **Endpoint:** `DELETE /api/v1/goals/{id}` or `DELETE /api/v1/goal/{id}`
* **Auth Required:** Yes (`Bearer <token>`)

#### cURL Example
```bash
curl -X DELETE "https://sip-backend.londonstreetstore.com/api/v1/goals/14" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN"
```

#### Success Response (`HTTP 200`)
```json
{
  "status": true,
  "message": "Goal and linked funds deleted successfully.",
  "unlinked_goal_id": 14
}
```

---

## 5. Goal Fund Allocation & Mapping (`/goal-orders`)

Investors can map mutual funds to a goal either **before investing** (pre-planning) or **during order execution**.

### 5.1 Add Funds to Goal (Single or Bulk)
* **Endpoint:** `POST /api/v1/goal-orders` or `POST /api/v1/goal-orders/save`
* **Auth Required:** Yes (`Bearer <token>`)

#### Request Parameters (Single Fund Mode — Root Payload)
| Parameter | Type | Required / Optional | Allowed Values / Validation | Description |
| :--- | :--- | :---: | :--- | :--- |
| `goal_id` | Integer | **Required** | `exists:goal_creators,id` | Destination goal ID. |
| `scheme_code` | String | **Required** | `max:50` | AMFI Scheme code (e.g. `"122639"`). |
| `order_type` | String | **Required** | `sip`, `lumpsum`, `stepup` | Type of investment planned. |
| `sip_amount` | Numeric | **Conditional** | `min:0` | Mandatory if `order_type` is `sip` or `stepup`. |
| `sip_day` | Integer | **Optional** | `min:1, max:31` | Day of the month for SIP debit. |
| `sip_start_date`| Date | **Optional** | `YYYY-MM-DD` | First installment date. |
| `sip_end_date` | Date | **Optional** | `YYYY-MM-DD, >= sip_start_date` | Final installment date. |
| `lumpsum_amount`| Numeric | **Conditional** | `min:0` | Mandatory if `order_type` is `lumpsum`. |
| `top_up_amount` | Numeric | **Optional** | `min:0` | Yearly increase amount for Step-Up. |
| `step_up_percentage`| Numeric | **Optional** | `0 to 100` | Percentage step-up if applicable. |
| `status` | String | **Optional** | `pending`, `active`, `stopped`, `completed` | Status (Default: `pending`). |

#### Request Parameters (Bulk Mode — Array of Funds)
Pass `goal_id` at root and a `funds: [...]` array:

```json
{
  "goal_id": 14,
  "funds": [
    {
      "scheme_code": "122639",
      "order_type": "sip",
      "sip_amount": 25000,
      "sip_day": 10
    },
    {
      "scheme_code": "120503",
      "order_type": "lumpsum",
      "lumpsum_amount": 50000
    }
  ]
}
```

#### cURL Example (Single Fund)
```bash
curl -X POST "https://sip-backend.londonstreetstore.com/api/v1/goal-orders" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN" \
  -d '{
    "goal_id": 14,
    "scheme_code": "122639",
    "order_type": "sip",
    "sip_amount": 25000,
    "sip_day": 10,
    "sip_start_date": "2026-12-10",
    "sip_end_date": "2031-12-10"
  }'
```

#### Success Response (`HTTP 201 Created`)
```json
{
  "status": true,
  "success": true,
  "message": "Goal fund created successfully.",
  "data": {
    "id": 48,
    "goal_id": 14,
    "user_id": 42,
    "scheme_code": "122639",
    "order_type": "sip",
    "sip_amount": "25000.00",
    "sip_day": 10,
    "sip_start_date": "2026-12-10",
    "sip_end_date": "2031-12-10",
    "status": "pending",
    "order_date": "2026-11-13"
  }
}
```

#### Duplicate Mapping Conflict (`HTTP 409 Conflict`)
If the same scheme with the same order type is already linked to this goal:
```json
{
  "status": false,
  "message": "This scheme and order type is already added to this goal.",
  "duplicate": {
    "index": 0,
    "scheme_code": "122639",
    "order_type": "sip"
  }
}
```

---

### 5.2 Get Planned Funds for a Goal
Returns all fund allocations planned for a goal and aggregates their planned totals.

* **Endpoint:** `GET /api/v1/goal/{id}/funds`
* **Auth Required:** Yes (`Bearer <token>`)

#### cURL Example
```bash
curl -X GET "https://sip-backend.londonstreetstore.com/api/v1/goal/14/funds" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN"
```

#### Success Response (`HTTP 200`)
```json
{
  "success": true,
  "message": "Goal funds fetched successfully.",
  "summary": {
    "total_funds": 2,
    "lumpsum_count": 1,
    "sip_count": 1,
    "stepup_count": 0,
    "lumpsum_amount": 50000.00,
    "sip_amount": 25000.00,
    "stepup_sip_amount": 0.00,
    "stepup_top_up_amount": 0.00,
    "planned_total_amount": 75000.00,
    "display": {
      "lumpsum_amount": "₹50,000",
      "sip_amount": "₹25,000",
      "stepup_sip_amount": "₹0",
      "stepup_top_up_amount": "₹0",
      "planned_total_amount": "₹75,000"
    }
  },
  "funds": [
    {
      "id": 48,
      "goal_id": 14,
      "scheme_code": "122639",
      "order_type": "sip",
      "sip_amount": 25000.00,
      "sip_day": 10,
      "status": "pending",
      "mutual_fund": {
        "scheme_code": "122639",
        "scheme_name": "Parag Parikh Flexi Cap Fund - Regular Plan - Growth",
        "nav": 71.95
      }
    }
  ]
}
```

---

### 5.3 Update a Goal Fund Mapping
Update amount, day, or tenure of a planned fund row.

* **Endpoint:** `PATCH /api/v1/goal-fund/{id}`
* **Auth Required:** Yes (`Bearer <token>`)

#### Request Parameters
| Parameter | In | Type | Required / Optional | Description |
| :--- | :--- | :--- | :---: | :--- |
| `id` | Path | Integer | **Required** | GoalFund row ID. |
| `sip_amount` | Body | Numeric | **Optional** | Updated SIP amount. |
| `sip_day` | Body | Integer | **Optional** | Updated SIP day (`1-31`). |
| `lumpsum_amount`| Body | Numeric | **Optional** | Updated lumpsum amount. |
| `status` | Body | String | **Optional** | `pending`, `active`, `stopped`, `completed`. |

#### cURL Example
```bash
curl -X PATCH "https://sip-backend.londonstreetstore.com/api/v1/goal-fund/48" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN" \
  -d '{
    "sip_amount": 30000,
    "sip_day": 15
  }'
```

#### Success Response (`HTTP 200`)
```json
{
  "status": true,
  "message": "Goal fund updated successfully.",
  "data": {
    "id": 48,
    "goal_id": 14,
    "sip_amount": 30000.00,
    "sip_day": 15
  }
}
```

---

### 5.4 Remove / Unlink Fund from Goal
Removes a fund allocation from a goal.

* **Endpoint:** `DELETE /api/v1/goal-fund/{id?}` (or `POST`)
* **Auth Required:** Yes (`Bearer <token>`)

#### Flexible Deletion Modes
1. **By Goal Fund ID (in Path):** `DELETE /api/v1/goal-fund/48`
2. **By MFU Order ID (Unlink entire order from goal):**
   ```json
   { "mfu_order_id": 89 }
   ```
3. **By Specific Fund inside an Order:**
   ```json
   { "mfu_order_fund_id": 120 }
   ```
4. **By Goal + Scheme Code:**
   ```json
   { "goal_id": 14, "scheme_code": "122639" }
   ```

#### cURL Example
```bash
curl -X DELETE "https://sip-backend.londonstreetstore.com/api/v1/goal-fund/48" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN"
```

#### Success Response (`HTTP 200`)
```json
{
  "status": true,
  "message": "Goal fund deleted successfully."
}
```

---

## 6. Goal Fund Transfer & Reallocation

Users can move fund allocations from one goal to another without selling units or stopping investments.

### 6.1 Move a Single Fund Between Goals
* **Endpoint:** `POST /api/v1/goal-fund/{id}/move`
* **Auth Required:** Yes (`Bearer <token>`)

#### Request Parameters
| Parameter | In | Type | Required / Optional | Description |
| :--- | :--- | :--- | :---: | :--- |
| `id` | Path | Integer | **Required** | GoalFund ID to move. |
| `to_goal_id` | Body | Integer | **Required** | Destination Goal ID (must belong to same user). |

#### cURL Example
```bash
curl -X POST "https://sip-backend.londonstreetstore.com/api/v1/goal-fund/48/move" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN" \
  -d '{
    "to_goal_id": 15
  }'
```

#### Success Response (`HTTP 200`)
```json
{
  "status": true,
  "message": "Goal fund moved successfully.",
  "data": {
    "id": 48,
    "goal_id": 15,
    "scheme_code": "122639",
    "order_type": "sip"
  }
}
```

---

### 6.2 Move ALL Funds from One Goal to Another
Transfers all fund allocations of a source goal to a target goal in a single atomic transaction.

* **Endpoint:** `POST /api/v1/goal/{id}/move-funds`
* **Auth Required:** Yes (`Bearer <token>`)

#### Request Parameters
| Parameter | In | Type | Required / Optional | Description |
| :--- | :--- | :--- | :---: | :--- |
| `id` | Path | Integer | **Required** | Source Goal ID. |
| `to_goal_id` | Body | Integer | **Required** | Destination Goal ID. |

#### cURL Example
```bash
curl -X POST "https://sip-backend.londonstreetstore.com/api/v1/goal/14/move-funds" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN" \
  -d '{
    "to_goal_id": 15
  }'
```

#### Success Response (`HTTP 200`)
```json
{
  "status": true,
  "message": "All goal funds moved successfully.",
  "moved_count": 3,
  "from_goal_id": 14,
  "to_goal_id": 15
}
```

---

### 6.3 Link an Existing Portfolio Holding to a Goal
Allows an investor to link an already purchased fund/order to a goal after the fact.

* **Endpoint:** `POST /api/v1/goal/{id}/link-fund`
* **Auth Required:** Yes (`Bearer <token>`)

#### Request Parameters
| Parameter | In | Type | Required / Optional | Description |
| :--- | :--- | :--- | :---: | :--- |
| `id` | Path | Integer | **Required** | Goal ID to link the holding to. |
| `mfu_order_id` | Body | Integer | **Conditional** | ID of the order to link. |
| `mfu_order_fund_id`| Body | Integer | **Conditional** | ID of the specific order fund item. |

*(At least one of `mfu_order_id` or `mfu_order_fund_id` is required).*

#### cURL Example
```bash
curl -X POST "https://sip-backend.londonstreetstore.com/api/v1/goal/14/link-fund" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer YOUR_SANCTUM_TOKEN" \
  -d '{
    "mfu_order_id": 89
  }'
```

#### Success Response (`HTTP 200`)
```json
{
  "status": true,
  "message": "Portfolio fund successfully linked to goal.",
  "goal_id": 14,
  "linked_order_id": 89
}
```

---

## 7. Connecting Goals to Investment APIs

When placing live orders through MFU, pass `goal_id` to automatically track investments under that goal:

### 7.1 Lumpsum Purchase with Goal
`POST /api/v1/invest/lumpsum`
```json
{
  "scheme_code": "122639",
  "amount": 50000,
  "folio": "NEW",
  "payment_type": "UPI",
  "goal_id": 14
}
```

### 7.2 SIP Registration with Goal
`POST /api/v1/invest/sip`
```json
{
  "scheme_code": "122639",
  "amount": 25000,
  "sip_day": 10,
  "goal_id": 14
}
```

**Automatic Backend Actions on Investment:**
1. The backend automatically stores `goal_id` on `mfu_orders`, `mfu_order_funds`, and `mf_transactions`.
2. As soon as the transaction succeeds, the backend creates or updates a matching row in `goal_funds`.
3. If the goal was in `pending` or `initial` status, it is automatically transitioned to `active`.
4. The goal's `saved_amount` and `progress_percent` update dynamically based on live market NAV.

---

## 8. Master Endpoint Quick Reference Table

| Method | Endpoint | Description | Auth |
| :--- | :--- | :--- | :---: |
| `GET` | `/api/v1/goal/master` | Master goal catalog (Car, Home, Education, etc.) | Yes |
| `POST` | `/api/v1/goals` | Create a user goal | Yes |
| `PATCH` | `/api/v1/goals/{id}` | Update a user goal (target, tenure, name, cover) | Yes |
| `GET` | `/api/v1/goals` | List all user goals with live valuation & progress | Yes |
| `GET` | `/api/v1/goals/{id}` | Detailed valuation, linked funds & transactions | Yes |
| `DELETE` | `/api/v1/goals/{id}` | Delete goal (unlinks funds, preserves holdings) | Yes |
| `POST` | `/api/v1/goal-orders` | Map planned mutual funds to a goal (Single/Bulk) | Yes |
| `GET` | `/api/v1/goal/{id}/funds` | List planned funds & summary totals for a goal | Yes |
| `PATCH` | `/api/v1/goal-fund/{id}` | Update a planned fund mapping | Yes |
| `DELETE` | `/api/v1/goal-fund/{id?}` | Unlink fund from goal (by ID, order ID, or scheme) | Yes |
| `POST` | `/api/v1/goal-fund/{id}/move` | Move a single fund to another goal | Yes |
| `POST` | `/api/v1/goal/{id}/move-funds` | Move all funds to another goal | Yes |
| `POST` | `/api/v1/goal/{id}/link-fund` | Link existing portfolio investment to a goal | Yes |

