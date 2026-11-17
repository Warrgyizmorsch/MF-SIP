# Flutter Integration Guide: Goal Investment & Calculation API

> **Target Audience:** Flutter Mobile Application Developers  
> **Backend Module:** Goal Management & Portfolio Sync (`GoalController.php`)  
> **API Endpoints Affected:**  
> - `GET /api/v1/goals`  
> - `GET /api/v1/goals/user/{user_id}`  
> - `GET /api/v1/goals/{id}`  

---

## 1. Quick Summary for UI Mapping

| UI Screen Element | JSON Key to Bind | Description |
| :--- | :--- | :--- |
| **Total SIP Invested** | **`total_sip_amount`** *(or `total_sip_invested`)* | Real cumulative money debited and allotted via SIP installments so far. |
| **Monthly SIP (Per Month / Running)** | **`monthly_sip_amount`** | Only active, running SIP commitments. Cancelled SIPs are **excluded**. |
| **Total Lumpsum (Net After Redeem)** | **`total_lumpsum_amount`** *(or `lumpsum_amount`)* | Net lumpsum invested after deducting any redemptions. |
| **Total Invested Capital** | **`total_invested_amount`** | Overall invested money: `Total SIP Invested + Net Lumpsum`. |
| **Current Value (Live Portfolio)** | **`saved_amount`** | Live market value of holding units (`Units × Latest NAV`). |
| **Goal Target Amount** | **`target_amount`** | Target savings goal set by the user. |
| **Remaining Amount** | **`remaining_amount`** | `target_amount - saved_amount` (clamped to 0). |
| **Progress %** | **`progress_percent`** | `(saved_amount / target_amount) * 100` (max 100%). |

---

## 2. Key Business Logic Explained

### 2.1 SIP Invested vs Monthly SIP Commitment

#### A. Running Monthly SIP (`monthly_sip_amount`)
- Represents the **recurring commitment** to be debited in upcoming cycles.
- **Rule:** Cancelled or stopped SIPs are **NOT** included here.
- *Example:* If Goal has Fund A (₹1,000 active) + Fund B (₹500 cancelled) + Fund C (₹1,000 active):  
  `monthly_sip_amount` = `₹2,000` (₹1,000 + ₹1,000). The cancelled ₹500 is excluded.

#### B. Total SIP Invested (`total_sip_amount` / `total_sip_invested`)
- Represents the **actual money debited from the bank and allotted by the AMC**.
- **Daily / Weekly / Monthly Accumulation:**
  - If a daily SIP of ₹500 completes 15 debits: `total_sip_amount` = `₹7,500`.
- **Cancelled SIP Historical Value:**
  - If an investor ran a daily SIP of ₹500 for 2 days and then cancelled it:  
    The 2 completed debits (₹1,000) remain invested in the fund. Therefore, that `₹1,000` **stays included** in `total_sip_amount`.
  - Future recurring commitment for this cancelled SIP becomes `₹0`.

---

### 2.2 Lumpsum: Net Amount After Redemptions (`total_lumpsum_amount`)
- In previous versions, `total_lumpsum_amount` always showed the original purchase amount, ignoring withdrawals.
- **New Formula:**
  $$\text{Net Lumpsum} = \max(0, \text{Gross Lumpsum Purchases} - \text{Total Redemptions})$$
- *Example:*
  - User invested ₹5,000 lumpsum in LIC MF Value Fund.
  - Later, user redeemed ₹3,000.
  - `total_lumpsum_amount` and `lumpsum_amount` now return **`2000.00`** (₹5,000 − ₹3,000).
- Audit fields provided in the response:
  - `gross_lumpsum_amount`: Original total lumpsum bought (e.g., `5000.00`).
  - `redeemed_lumpsum_amount`: Total redeemed from lumpsum (e.g., `3000.00`).

---

### 2.3 Overall Total Invested (`total_invested_amount`)
- Total principal capital currently deployed in this goal:
  $$\text{total\_invested\_amount} = \text{total\_sip\_invested} + \text{total\_lumpsum\_amount}$$
- *Example:* ₹7,500 (SIP debits) + ₹2,000 (Net Lumpsum) = **`₹9,500.00`**.

---

## 3. Granular Breakdown Objects

### 3.1 `sip_calculation` & `sip_breakdown`

```json
"sip_calculation": {
    "total_monthly_sip": 2500.00,
    "total_sip_invested": 8500.00,
    "funds_count": 4,
    "active_funds_count": 3,
    "formula": "₹1,000.00 (Abakkus...) + ₹1,000.00 (Kotak...) + ₹500.00 (Motilal...)",
    "breakdown": [
        {
            "scheme_code": "154041",
            "mfu_scheme_code": "FCRGG",
            "fund_name": "Abakkus Flexi Cap Fund - Regular - Growth",
            "amc_name": "Abakkus Asset Manager",
            "sip_amount": 1000.00,
            "running_sip_amount": 1000.00,
            "invested_amount": 7500.00,
            "total_sip_invested": 7500.00,
            "installments_count": 15,
            "frequency": "Daily",
            "sip_day": null,
            "status": "active",
            "source": "goal_fund"
        },
        {
            "scheme_code": "116547",
            "mfu_scheme_code": "BCGPG",
            "fund_name": "Groww Large Cap Fund - Regular Plan",
            "amc_name": "Groww Asset Management Limited",
            "sip_amount": 500.00,
            "running_sip_amount": 0.00,
            "invested_amount": 1000.00,
            "total_sip_invested": 1000.00,
            "installments_count": 2,
            "frequency": "Daily",
            "sip_day": null,
            "status": "cancelled",
            "source": "goal_fund"
        }
    ]
}
```

#### Fund Item Keys:
- `status`: `'active'` or `'cancelled'`.
- `sip_amount`: Base installment amount configured.
- `running_sip_amount`: Active monthly commitment (`0.00` if status is cancelled).
- `invested_amount`: Real money debited so far for this fund.
- `installments_count`: Number of successful installment debits executed.

---

### 3.2 `lumpsum_calculation` & `lumpsum_breakdown`

```json
"lumpsum_calculation": {
    "total_lumpsum": 2000.00,
    "gross_lumpsum": 5000.00,
    "total_redeemed": 3000.00,
    "funds_count": 1,
    "formula": "₹2,000.00 (LIC MF Value Fund-Regular Plan-Growth)",
    "breakdown": [
        {
            "scheme_code": "152016",
            "mfu_scheme_code": "LVGPG",
            "fund_name": "LIC MF Value Fund-Regular Plan-Growth",
            "amc_name": "LIC Mutual Fund Asset Management Limited",
            "lumpsum_amount": 2000.00,
            "invested_amount": 2000.00,
            "gross_amount": 5000.00,
            "redeemed_amount": 3000.00,
            "status": "active",
            "source": "goal_fund"
        }
    ]
}
```

#### Fund Item Keys:
- `lumpsum_amount`: Net lumpsum after redemptions (`gross_amount - redeemed_amount`).
- `gross_amount`: Total purchase money.
- `redeemed_amount`: Total withdrawn money.

---

## 4. Complete Goal Response Structure (`GET /api/v1/goals/user/{user_id}`)

```json
{
    "success": true,
    "message": "Goals fetched successfully.",
    "goal": [
        {
            "id": 235,
            "goal_name": "Car",
            "target_amount": 10000.00,
            "saved_amount": 10814.39,
            "remaining_amount": 0.00,
            "progress_percent": 100.00,
            "goal_cover": "https://sip-backend.londonstreetstore.com/assets/goal-img/car.png",
            "investment_type": "sip",
            "frequency": "Monthly",

            // --- SIP AMOUNTS ---
            "sip_amount": 2500.00,
            "monthly_sip_amount": 2500.00,
            "running_sip_commitment": 2500.00,
            "total_sip_amount": 8500.00,
            "total_sip_invested": 8500.00,

            // --- LUMPSUM AMOUNTS ---
            "lumpsum_amount": 2000.00,
            "total_lumpsum_amount": 2000.00,
            "gross_lumpsum_amount": 5000.00,
            "redeemed_lumpsum_amount": 3000.00,

            // --- OVERALL INVESTED CAPITAL ---
            "total_invested_amount": 10500.00,

            // --- DETAILED BREAKDOWNS ---
            "sip_calculation": { ... },
            "sip_breakdown": [ ... ],
            "lumpsum_calculation": { ... },
            "lumpsum_breakdown": [ ... ],

            "start_date": "2026-11-16",
            "end_date": "2038-11-16",
            "duration": "12 Years"
        }
    ]
}
```

---

## 5. Dart / Flutter Model Migration Guide

If using a Dart model class for Goal (e.g. `GoalModel`), add or map these fields:

```dart
class GoalModel {
  final int id;
  final String goalName;
  final double targetAmount;
  final double savedAmount;
  final double monthlySipAmount;     // Active monthly installment
  final double totalSipAmount;       // Cumulative SIP debited money
  final double totalSipInvested;     // Alias for totalSipAmount
  final double totalLumpsumAmount;   // Net lumpsum after redemptions
  final double grossLumpsumAmount;   // Original lumpsum purchases
  final double redeemedLumpsumAmount;// Total redeemed
  final double totalInvestedAmount;  // Net Lumpsum + Total SIP Invested
  final String? goalCover;
  final double progressPercent;

  GoalModel({
    required this.id,
    required this.goalName,
    required this.targetAmount,
    required this.savedAmount,
    required this.monthlySipAmount,
    required this.totalSipAmount,
    required this.totalSipInvested,
    required this.totalLumpsumAmount,
    required this.grossLumpsumAmount,
    required this.redeemedLumpsumAmount,
    required this.totalInvestedAmount,
    this.goalCover,
    required this.progressPercent,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as int? ?? 0,
      goalName: json['goal_name'] as String? ?? '',
      targetAmount: (json['target_amount'] as num?)?.toDouble() ?? 0.0,
      savedAmount: (json['saved_amount'] as num?)?.toDouble() ?? 0.0,
      monthlySipAmount: (json['monthly_sip_amount'] as num?)?.toDouble() ?? 0.0,
      totalSipAmount: (json['total_sip_amount'] as num?)?.toDouble() ?? 0.0,
      totalSipInvested: (json['total_sip_invested'] as num?)?.toDouble() ?? 0.0,
      totalLumpsumAmount: (json['total_lumpsum_amount'] as num?)?.toDouble() ?? 0.0,
      grossLumpsumAmount: (json['gross_lumpsum_amount'] as num?)?.toDouble() ?? 0.0,
      redeemedLumpsumAmount: (json['redeemed_lumpsum_amount'] as num?)?.toDouble() ?? 0.0,
      totalInvestedAmount: (json['total_invested_amount'] as num?)?.toDouble() ?? 0.0,
      goalCover: json['goal_cover'] as String?,
      progressPercent: (json['progress_percent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
```

---

## 6. Verification Checklist for Flutter Team

1. [ ] **Goal Card:** Display `monthly_sip_amount` for recurring SIP (e.g. `₹2,500/mo`).
2. [ ] **Goal Details Screen:**
   - Display `total_sip_amount` for Total SIP Invested so far.
   - Display `total_lumpsum_amount` for Net Lumpsum.
   - Display `total_invested_amount` for Total Invested Capital.
   - Display `saved_amount` for Current Portfolio Valuation.
3. [ ] **SIP Funds List in Goal:**
   - Show badge `'Active'` if `item.status == 'active'`.
   - Show badge `'Cancelled'` if `item.status == 'cancelled'`.
   - For cancelled funds, show `invested_amount` (money already debited) while showing recurring SIP as `₹0`.
