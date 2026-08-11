# MFU Mutual Fund Investment API Documentation

Complete API Reference for **Lumpsum Investments (Single & Multi-Fund)**, **SIP Registration**, **Redemption/Cancellation**, **Order Tracking**, and **User Readiness**.

---

## 1. Base Setup & Authentication

* **Base URL**: `https://sip-backend.londonstreetstore.com/api/v1`  
* **Default Headers**:
  ```http
  Content-Type: application/json
  Accept: application/json
  Authorization: Bearer <YOUR_SANCTUM_TOKEN>
  ```

---

## 2. Readiness & Helper APIs

### 2.1 User Investment Readiness Summary
Check if user has an active CAN, linked bank, and mandate before opening investment forms.

* **Endpoint**: `GET /invest/user-summary`
* **cURL**:
  ```bash
  curl -X GET http://127.0.0.1:8000/api/v1/invest/user-summary \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN"
  ```
* **Sample Response**:
  ```json
  {
    "success": true,
    "is_ready_lumpsum": true,
    "is_ready_sip": true,
    "can": { "registered": true, "can_number": "26216OM003", "category": "I" },
    "bank": { "added": true, "bank_name": "HDFC Bank", "account_no": "XXXX1981", "ifsc": "HDFC0000240" },
    "mandate": { "active": true, "mandate_ref": "MUMRN123456", "mandate_mode": "enach", "amount_limit": 100000 }
  }
  ```

---

### 2.2 Scheme Investment Rules & Allowed SIP Dates
Fetch scheme threshold limits, minimum amounts, and valid SIP dates (`1`, `5`, `10`, `15`, `25`) for UI date pickers.

* **Endpoint**: `GET /invest/scheme-info/{schemeCode}`
* **cURL**:
  ```bash
  curl -X GET http://127.0.0.1:8000/api/v1/invest/scheme-info/152074 \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN"
  ```
* **Sample Response**:
  ```json
  {
    "success": true,
    "scheme": {
      "id": 2,
      "scheme_name": "360 ONE Balanced Hybrid Fund - Regular Plan - IDCW",
      "scheme_code": "152074",
      "mfu_scheme_code": "IBHRP",
      "rta_amc_code": "IF",
      "min_lumpsum": 1000,
      "min_sip_amount": 1000,
      "allowed_sip_dates": ["1", "2", "3", "4", "5"],
      "is_sip_allowed": true,
      "is_lumpsum_allowed": true
    }
  }
  ```

---

## 3. Lumpsum Purchase APIs

### 3.1 Single Fund Lumpsum (New Folio)
* **Endpoint**: `POST /invest/lumpsum`
* **Description**: Create a fresh lumpsum investment with a new folio.
* **cURL**:
  ```bash
  curl -X POST http://127.0.0.1:8000/api/v1/invest/lumpsum \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN" \
    -d '{
      "scheme_code": "152074",
      "amount": 5000,
      "folio": "NEW"
    }'
  ```

---

### 3.2 Single Fund Lumpsum (Existing Folio)
* **Endpoint**: `POST /invest/lumpsum`
* **Description**: Invest additional lumpsum amount into an existing folio.
* **cURL**:
  ```bash
  curl -X POST http://127.0.0.1:8000/api/v1/invest/lumpsum \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN" \
    -d '{
      "scheme_code": "152074",
      "amount": 5000,
      "folio": "12345678"
    }'
  ```

---

### 3.3 Goal-Linked Lumpsum Purchase
* **Endpoint**: `POST /invest/lumpsum`
* **Description**: Lumpsum purchase mapped to a specific financial goal.
* **cURL**:
  ```bash
  curl -X POST http://127.0.0.1:8000/api/v1/invest/lumpsum \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN" \
    -d '{
      "scheme_code": "152074",
      "amount": 10000,
      "folio": "NEW",
      "goal_id": 1
    }'
  ```

---

### 3.4 Multi-Fund Lumpsum / Cart Checkout
* **Endpoint**: `POST /invest/lumpsum`
* **Description**: Pass multiple scheme objects in a single API call or call sequentially per fund.
* **Sample Lumpsum Success Response**:
  ```json
  {
    "success": true,
    "message": "Lumpsum submitted successfully",
    "mfu_order_id": 4,
    "mfu_gorn": "26216OM003000001",
    "order_status": "RQ",
    "approval_link": "https://www.mfuonline.com/CallInInvOrdConfirm.do?gon=26216OM003000001..."
  }
  ```

---

## 4. Lumpsum Cancellation & Redemption (Selling Units)

### 4.1 Partial Redemption (Selling Specific Amount)
* **Endpoint**: `POST /invest/redeem`
* **Description**: Sell units worth a specific rupee amount (e.g. ₹2,000). Money is credited to investor's bank account.
* **cURL**:
  ```bash
  curl -X POST http://127.0.0.1:8000/api/v1/invest/redeem \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN" \
    -d '{
      "scheme_code": "152074",
      "folio": "12345678",
      "amount": 2000
    }'
  ```

---

### 4.2 Full Redemption (Sell All Units / Folio Exit)
* **Endpoint**: `POST /invest/redeem`
* **Description**: Sell all holdings in a scheme.
* **cURL**:
  ```bash
  curl -X POST http://127.0.0.1:8000/api/v1/invest/redeem \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN" \
    -d '{
      "scheme_code": "152074",
      "folio": "12345678",
      "redeem_all": true
    }'
  ```

---

## 5. SIP (Systematic Investment Plan) APIs

### 5.1 Start New SIP
* **Endpoint**: `POST /invest/sip`
* **Description**: Register a new monthly SIP with automated mandate debit.
* **cURL**:
  ```bash
  curl -X POST http://127.0.0.1:8000/api/v1/invest/sip \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN" \
    -d '{
      "scheme_code": "152074",
      "amount": 1000,
      "frequency": "M",
      "day": "25"
    }'
  ```

---

### 5.2 SIP Step-Up
* **Endpoint**: `POST /invest/stepup`
* **Description**: Increase installment amount on an existing SIP.
* **cURL**:
  ```bash
  curl -X POST http://127.0.0.1:8000/api/v1/invest/stepup \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN" \
    -d '{
      "scheme_code": "152074",
      "amount": 2000,
      "frequency": "M",
      "day": "25"
    }'
  ```

---

### 5.3 Cancel Active SIP
* **Endpoint**: `POST /invest/cancel`
* **Description**: Stop an active recurring SIP.
* **cURL**:
  ```bash
  curl -X POST http://127.0.0.1:8000/api/v1/invest/cancel \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN" \
    -d '{
      "mfu_order_id": 6,
      "type": "sip",
      "cancel_reason": "User requested cancellation"
    }'
  ```

---

## 6. Order Tracking & Real-Time Status

### 6.1 User Order History
* **Endpoint**: `GET /orders`
* **cURL**:
  ```bash
  curl -X GET http://127.0.0.1:8000/api/v1/orders \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN"
  ```

---

### 6.2 Real-time Order Status Refresh (MFU Live Check)
* **Endpoint**: `POST /orders/{id}/check-status`
* **cURL**:
  ```bash
  curl -X POST http://127.0.0.1:8000/api/v1/orders/4/check-status \
    -H "Accept: application/json" \
    -H "Authorization: Bearer YOUR_TOKEN"
  ```
