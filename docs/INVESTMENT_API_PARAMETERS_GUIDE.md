# Investment API Parameters Guide (Lumpsum & SIP)

Comprehensive reference manual for the **Lumpsum** and **SIP (Systematic Investment Plan)** investment APIs in `SIP-Backend-Ridit`.

---

## 1. Architectural Philosophy ("Smart Backend")

The backend follows a **Backend-Heavy Abstraction** model:
- **Frontend Client (Flutter Mobile App):** Only sends minimal required fields (e.g., `scheme_code`, `amount`, `folio`, `sip_day`, `goal_id`).
- **Backend Auto-Resolution:** Automatically handles:
  1. Investor CAN number & CAN category (`users.can_number`, `users.can_account_category`).
  2. Primary / verified bank account (`bank_accounts`).
  3. Active eNACH / UPI AutoPay mandate (`mfu_mandates`).
  4. AMC codes (`rta_amc_code`, `mfu_amc_code`) & MFU internal scheme codes (`rta_sch_code`).
  5. Recurring debit schedule calculation (minimum 6-day lead time for recurring debit presentation).
  6. AES-128-CBC payload encryption and MFU authentication token management.

---

## 2. Global Headers & Authentication

All investment endpoints require Laravel Sanctum bearer token authentication.

```http
POST /api/v1/invest/lumpsum HTTP/1.1
Host: your-domain.com
Authorization: Bearer <sanctum_token>
Accept: application/json
Content-Type: application/json
```

---

## 3. LUMPSUM INVESTMENT API (`POST /api/v1/invest/lumpsum`)

Used for one-time purchases. Generates an MFU payment gateway link (`payment_link`) for user payment completion via NetBanking or UPI.

The endpoint supports two modes:
1. **Single Fund Mode:** Direct top-level fields.
2. **Multiple Funds Mode (Cart):** When passing a `funds` array.

---

### 3.1 Single Fund Lumpsum

#### Required Parameters

| Parameter | Type | Validation Rules | Description | Example |
| :--- | :--- | :--- | :--- | :--- |
| `scheme_code` | `string` | `required\|string\|max:50` | Unique AMFI Scheme Code or MFU Scheme Code of the target mutual fund. | `"152074"` or `"INF204K01226"` |
| `amount` | `numeric` | `required\|numeric\|min:100` | Investment amount in INR. Must meet or exceed the scheme's `min_lumpsum`. | `5000` |

#### Optional Parameters

| Parameter | Type | Validation Rules | Default / Auto-Resolution | Description | Example |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `folio` | `string` | `nullable\|string\|max:50` | `"NEW"` | Existing AMC folio number to invest in. Pass `"NEW"` or omit for fresh folio allotment. | `"1234567/89"` or `"NEW"` |
| `payment_type` | `string` | `nullable\|string\|max:50` | `"UPI"` | Desired payment mode. Allowed values: `UPI` (`UP`), `NETBANKING` / `NB` (`OT`). | `"UPI"` |
| `bank_id` / `bank_account_id` | `integer` | `nullable\|integer` | User's verified default bank account | Specific local database ID from `bank_accounts` table to debit funds from. | `1` |
| `goal_id` | `integer` | `nullable\|integer` | `null` | Financial goal ID (`goals.id`) to map this investment to. Validates that the goal belongs to the authenticated user. | `12` |
| `div_opt` / `dividend_option` | `string` | `nullable\|string\|max:50` | Scheme's default dividend option | IDCW payout/reinvestment option: `Z` (Growth), `P` (Payout), `R` (Reinvestment). Aliases supported: `devopt`, `devOpt`, `divOpt`, `divoption`. | `"Z"` |
| `rta_amc_code` / `amc_code` | `string` | `nullable\|string\|max:10` | Auto-resolved from `mutual_funds.rta_amc_code` | Explicit AMC code (e.g. `RMF`, `H`, `L`). Usually omitted. | `"RMF"` |

#### Minimal Request (Recommended for Flutter)
```json
{
  "scheme_code": "152074",
  "amount": 5000
}
```

#### Full Request (With all optional fields)
```json
{
  "scheme_code": "152074",
  "amount": 5000,
  "folio": "NEW",
  "payment_type": "UPI",
  "bank_id": 1,
  "goal_id": 12,
  "div_opt": "Z"
}
```

---

### 3.2 Multiple Funds Lumpsum (Cart Purchase)

When investing in multiple schemes simultaneously from a cart.

#### Parameters

| Parameter | Level | Type | Requirement | Description | Example |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `funds` | Root | `array` | **Required** | List of fund objects (Min: 1, Max: 20). | `[...]` |
| `funds.*.scheme_code`| Array Item | `string` | **Required** | Scheme code of the individual fund. | `"152074"` |
| `funds.*.amount` | Array Item | `numeric` | **Required** | Purchase amount for this specific fund (Min: 100). | `3000` |
| `funds.*.folio` | Array Item | `string` | Optional | Folio for this fund. Defaults to `"NEW"`. | `"NEW"` |
| `funds.*.div_opt` | Array Item | `string` | Optional | Dividend option for this fund (`Z`, `P`, `R`). | `"Z"` |
| `payment_type` | Root | `string` | Optional | Payment mode for the entire transaction (`UPI` or `NETBANKING`). Default: `UPI`. | `"UPI"` |
| `bank_id` | Root | `integer` | Optional | Specific bank account ID to debit. | `1` |
| `goal_id` | Root | `integer` | Optional | Goal ID to attach to this purchase. | `12` |

#### Example Multi-Lumpsum Request
```json
{
  "funds": [
    {
      "scheme_code": "152074",
      "amount": 5000,
      "folio": "NEW"
    },
    {
      "scheme_code": "100552",
      "amount": 3000,
      "folio": "123456/78"
    }
  ],
  "payment_type": "UPI",
  "goal_id": 12
}
```

---

### 3.3 Lumpsum Success Response (`HTTP 200`)

```json
{
  "success": true,
  "message": "Lumpsum submitted successfully",
  "txn_type": "lumpsum",
  "investment_type": "normal",
  "ent_group_ref": "ENT20261113144501234",
  "mfu_order_id": 1045,
  "mfu_gorn": "GORN2026111300001",
  "corn": null,
  "order_status": "SUBMITTED",
  "payment_link": "https://www.mfuindia.com/FinTechPaymentGateway?ref=EGRN...",
  "approval_link": null,
  "mfu_itrn": "ITRN2026111300001",
  "selected_bank": {
    "bank_id": 1,
    "bank_name": "HDFC BANK",
    "account_number_masked": "XXXXXX1234",
    "ifsc_code": "HDFC0001234",
    "pay_mode": "UP"
  }
}
```

---

## 4. SIP INVESTMENT API (`POST /api/v1/invest/sip`)

Used for setting up recurring Systematic Investment Plans. Automatically links the investor's approved eNACH or UPI AutoPay mandate and schedules the recurring deduction.

Supports both **Single Fund SIP** and **Multiple Funds SIP**.

---

### 4.1 Single Fund SIP

#### Required Parameters

| Parameter | Type | Validation Rules | Description | Example |
| :--- | :--- | :--- | :--- | :--- |
| `scheme_code` | `string` | `required\|string\|max:50` | Unique AMFI Scheme Code or MFU Scheme Code. | `"152074"` or `"INF204K01226"` |
| `amount` | `numeric` | `required\|numeric\|min:100` | Monthly SIP installment amount in INR. Must meet `min_sip_amount`. | `1000` |

#### Optional Parameters

| Parameter | Type | Validation Rules | Default / Auto-Resolution | Description | Example |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `sip_day` / `day` | `string\|integer` | `nullable\|max:10` | Auto-selected from scheme's `allowed_sip_dates` (Default: `25`) | Day of the month for SIP deduction (1 to 28). Aliases: `sip_date`, `date`. | `10` or `"10"` |
| `frequency` | `string` | `nullable\|string\|max:20` | `"M"` (Monthly) | SIP frequency. Supported values: `M` (Monthly), `W` (Weekly), `Q` (Quarterly), `Y` (Yearly). | `"M"` |
| `folio` | `string` | `nullable\|string\|max:50` | `"NEW"` | Existing AMC folio number. Pass `"NEW"` or omit for fresh allotment. | `"NEW"` |
| `mandate_id` | `integer` | `nullable\|integer` | User's active approved mandate | Specific mandate ID from `mfu_mandates`. If omitted, backend automatically resolves active UPI / eNACH mandate. | `5` |
| `mandate_ref_no` | `string` | `nullable\|string\|max:80` | Auto-resolved from mandate's `mumrn` / `mmrn` | MFU mandate reference number. | `"MUMRN123456789"` |
| `bank_id` / `bank_account_id` | `integer` | `nullable\|integer` | Bank linked to the active mandate | Specific bank account ID from `bank_accounts`. | `1` |
| `start_month` | `string` | `nullable\|string\|max:2` | Next month with >= 6 days lead time | 2-digit starting month (`"01"` to `"12"`). Auto-calculated if omitted. | `"12"` |
| `start_year` | `string` | `nullable\|string\|max:4` | Current or next year | 4-digit starting year. Auto-calculated if omitted. | `"2026"` |
| `end_month` | `string` | `nullable\|string\|max:2` | Same as `start_month` | 2-digit ending month. Auto-calculated if omitted. | `"12"` |
| `end_year` | `string` | `nullable\|string\|max:4` | `start_year + 10` (10-year tenure) | 4-digit ending year. Defaults to 10-year tenure if omitted. | `"2036"` |
| `goal_id` | `integer` | `nullable\|integer` | `null` | Financial goal ID (`goals.id`) to map this recurring SIP to. | `12` |
| `div_opt` / `dividend_option` | `string` | `nullable\|string\|max:50` | Scheme's default dividend option | IDCW payout/reinvestment option (`Z`, `P`, `R`). Aliases: `devopt`, `divOpt`, `divoption`. | `"Z"` |

#### Minimal Request (Recommended for Flutter)
```json
{
  "scheme_code": "152074",
  "amount": 1000,
  "sip_day": 10
}
```

#### Full Request (With all optional fields)
```json
{
  "scheme_code": "152074",
  "amount": 1000,
  "sip_day": 10,
  "frequency": "M",
  "folio": "NEW",
  "bank_id": 1,
  "mandate_id": 5,
  "goal_id": 12,
  "start_month": "12",
  "start_year": "2026",
  "end_month": "12",
  "end_year": "2036",
  "div_opt": "Z"
}
```

---

### 4.2 Multiple Funds SIP (Multi-SIP / Cart SIP)

When starting recurring SIPs in multiple funds simultaneously.

#### Parameters

| Parameter | Level | Type | Requirement | Description | Example |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `funds` | Root | `array` | **Required** | List of fund objects (Min: 1, Max: 20). | `[...]` |
| `funds.*.scheme_code`| Array Item | `string` | **Required** | Scheme code of the individual fund. | `"152074"` |
| `funds.*.amount` | Array Item | `numeric` | **Required** | SIP installment amount for this fund. | `1000` |
| `funds.*.sip_day` | Array Item | `string\|integer`| Optional | Deduction day for this fund. Inherits root `sip_day` if omitted. | `10` |
| `funds.*.folio` | Array Item | `string` | Optional | Folio for this fund. Defaults to `"NEW"`. | `"NEW"` |
| `funds.*.frequency` | Array Item | `string` | Optional | Frequency for this fund (Default: `"M"`). | `"M"` |
| `funds.*.div_opt` | Array Item | `string` | Optional | Dividend option (`Z`, `P`, `R`). | `"Z"` |
| `sip_day` | Root | `string\|integer`| Optional | Global fallback deduction day for all funds in the list. | `10` |
| `mandate_id` | Root | `integer` | Optional | Specific mandate ID to link. Auto-resolved if omitted. | `5` |
| `bank_id` | Root | `integer` | Optional | Bank account ID. | `1` |
| `goal_id` | Root | `integer` | Optional | Goal ID to attach to this SIP order. | `12` |

#### Example Multi-SIP Request
```json
{
  "funds": [
    {
      "scheme_code": "152074",
      "amount": 1000,
      "sip_day": 10,
      "folio": "NEW"
    },
    {
      "scheme_code": "100552",
      "amount": 2000,
      "sip_day": 15,
      "folio": "NEW"
    }
  ],
  "mandate_id": 5,
  "goal_id": 12
}
```

---

### 4.3 SIP Success Response (`HTTP 200`)

```json
{
  "success": true,
  "message": "Sip submitted successfully",
  "txn_type": "sip",
  "investment_type": "systematic",
  "ent_group_ref": "ENT20261113144805678",
  "mfu_order_id": 1046,
  "mfu_gorn": "GORN2026111300002",
  "corn": null,
  "order_status": "SUBMITTED",
  "payment_link": null,
  "approval_link": null,
  "mfu_itrn": "ITRN2026111300002",
  "selected_bank": {
    "bank_id": 1,
    "bank_name": "HDFC BANK",
    "account_number_masked": "XXXXXX1234",
    "ifsc_code": "HDFC0001234"
  },
  "selected_mandate": {
    "mandate_id": 5,
    "mandate_mode": "UPI",
    "mandate_ref": "MUMRN123456789",
    "amount_limit": 100000
  }
}
```

> **Note on Payment / Approval Links for SIP:**  
> When an active eNACH or UPI AutoPay mandate is already linked, `payment_link` is `null` because recurring debits are handled automatically by NPCI. If the mandate requires secondary investor authorization, MFU returns a verification link in `approval_link`.

---

## 5. STEP-UP SIP API (`POST /api/v1/invest/stepup`)

A Step-Up SIP automatically increments the SIP installment by a fixed amount at periodic intervals (e.g. increases by ₹500 every year).

### Parameters
Includes all parameters from **Section 4 (SIP)** plus these three step-up parameters:

| Parameter | Type | Requirement | Default | Description | Example |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `stepup_amount` | `numeric\|string` | Optional | `500` | The increment amount to add to the SIP installment at each step. | `500` |
| `stepup_frequency` | `string` | Optional | `"Y"` (Yearly) | How often to increase: `"Y"` (Yearly) or `"H"` (Half-Yearly). | `"Y"` |
| `stepup_month` | `string` | Optional | Same as `start_month` | Month in which the increase takes effect each cycle (`"01"` to `"12"`). | `"04"` |

#### Example Step-Up SIP Request
```json
{
  "scheme_code": "152074",
  "amount": 2000,
  "sip_day": 10,
  "stepup_amount": 500,
  "stepup_frequency": "Y",
  "stepup_month": "04",
  "goal_id": 12
}
```

---

## 6. Common Validation & Business Logic Errors (`HTTP 422`)

All errors follow a unified JSON envelope:

```json
{
  "success": false,
  "message": "Detailed error explanation",
  "error_code": "MACHINE_READABLE_CODE",
  "data": { ... }
}
```

| Error Code | HTTP Status | Cause | Resolution |
| :--- | :--- | :--- | :--- |
| `CAN_NOT_REGISTERED` | `422` | Investor has not completed CAN setup (`users.can_number` is null). | Call `POST /api/v1/onboarding/can-setup`. |
| `CAN_CANCELLED_OR_REJECTED` | `422` | Investor CAN was terminated or rejected by MFU. | Re-register CAN via `POST /api/v1/onboarding/can-setup`. |
| `BANK_NOT_FOUND` | `422` | User has no verified bank account registered in `bank_accounts`. | Add/verify bank via `POST /api/v1/onboarding/bank-validate`. |
| `MANDATE_NOT_FOUND` | `422` | For SIP: User has no approved eNACH or UPI AutoPay mandate. | Register mandate via `POST /api/v1/onboarding/mandate-setup`. |
| `MANDATE_REF_MISSING` | `422` | Selected mandate has not received its UMRN/MMRN from NPCI/bank yet. | Wait for mandate approval callback or poll mandate status. |
| `SCHEME_PURCHASE_SUSPENDED` | `422` | AMC or MFU has suspended fresh purchase (`is_lumpsum_allowed = 0`). | User cannot invest in this scheme (e.g. foreign cap reached). |
| `SCHEME_SIP_SUSPENDED` | `422` | AMC or MFU has suspended fresh SIPs (`is_sip_allowed = 0`). | Choose an alternative active scheme. |
| `FOREIGN_FOLIO_REJECTED` | `422` | The requested folio number does not belong to the authenticated user. | Omit folio or pass `"NEW"`. |
| `GOAL_NOT_FOUND` | `404` | The passed `goal_id` does not belong to the authenticated user. | Pass a valid goal ID or omit the field. |

