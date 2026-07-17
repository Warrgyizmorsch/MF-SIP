# MFU implementation guide

This guide summarizes the developer-relevant rules in the MF Utility Fintech Transaction API Specification V2.9, Scheme Master Data Structure Specifications v2.3, and UAT test-data workbook. It is an implementation aid, not a replacement for the field-level source tables.

For exact request and response fields, conditional-mandatory rules, possible values, endpoints, and examples, use the [complete documentation](generated/MFU_COMPLETE_DOCUMENTATION.md) or the split [API](generated/MFU_API_REFERENCE.md), [scheme master](generated/MFU_SCHEME_MASTER_REFERENCE.md), and [UAT](generated/MFU_UAT_REFERENCE.md) references.

## Integration sequence

1. Obtain the UAT configuration from MFU: `entityId`, OAuth credentials, public key, IV key, applicable endpoint base URL, and entity feature/workflow flags.
2. Generate an OAuth access token.
3. Build the service-specific business JSON using the exact field names and allowed values in that service sheet.
4. Apply the service's stated encryption model. Most service requests encrypt the complete business JSON into `reqBody.data`; several mandate and push services explicitly use unencrypted fields.
5. Send the shared request header plus the service body, using the token in the HTTP `Authorization` header.
6. Check the HTTP status before parsing the business response. Authentication errors use a different, unencrypted response shape.
7. Decrypt `respData` when the service uses the standard encrypted response envelope, then process `respFlag`, service errors, and section-wise errors.
8. Validate the implementation using the UAT workbook's CAN, bank, folio, mandate, depository, ARN/RIA, EUIN, and scheme data.
9. Consume the daily incremental scheme and threshold files so transaction validation uses current product rules.

## OAuth 2.0

Access-token generation uses `POST` at the endpoint pattern:

```text
https://<UAT or PROD URL>/GetAccessTokenV1
```

The form/request fields are:

| Field | Requirement |
| --- | --- |
| `entityId` | MFU-provided entity identifier. |
| `clientUser` | Required; encrypt with `AES/CBC/PKCS7Padding` using the MFU-provided key and IV. |
| `clientPwd` | Required; encrypt with `AES/CBC/PKCS7Padding` using the MFU-provided key and IV. |

A successful response contains `access_token`, `token_type`, and `expires_in`. The specification states that the default token validity is 24 hours. Send the token on later calls as:

```http
Authorization: {{token_type}} {{access_token}}
```

OAuth token-generation failures use `errorCode` and `errorMsg`. If a token used on another service is invalid or expired, the source says the HTTP status will be `400` or `401`, and the unencrypted body wraps those fields in `errorRespData`:

```json
{"errorRespData":{"errorCode":"100006","errorMsg":"Authorization Token is invalid"}}
```

```json
{"errorRespData":{"errorCode":"100007","errorMsg":"Token validity period is expired"}}
```

When the HTTP status is not `200`, read the error input stream/body rather than attempting to process a normal encrypted service response.

## Shared request and response envelope

The standard request header is `reqHeader`:

| Field | Source type | Required behavior |
| --- | --- | --- |
| `entityId` | `Char(6)` | MFU-provided identifier for the configured environment. |
| `version` | `Char(5)` | Web-service version, for example `1.00`. |
| `reqTS` | Date Time | Entity timestamp in `YYYY-MM-DD HH:MM:SS` format. |
| `apiType` | `Char(20)` | Service discriminator. Values are case-sensitive; use the exact value stated by the selected service sheet. |
| `uniqueId` | `Char(50)` | Entity-created request identifier; it must not be duplicated. |

For services using the standard encrypted model, the request body container is `reqBody`. Serialize the full service-specific request body as JSON, encrypt it with `AES/CBC/PKCS7Padding`, and place the result in its `data` field (`reqBody.data`):

```json
{
  "reqHeader": {
    "entityId": "<MFU entity ID>",
    "version": "1.00",
    "reqTS": "YYYY-MM-DD HH:MM:SS",
    "apiType": "<exact service apiType>",
    "uniqueId": "<unique entity request ID>"
  },
  "reqBody": {
    "data": "<encrypted business JSON>"
  }
}
```

The standard response places the encrypted success-or-error business JSON in `respData`. Decrypt it before interpreting the service-specific `respHeader` and `respBody`.

Do not send JSON `null`. The System FAQs sheet says that a key must remain in the request with an empty value when no value is available. Preserve the expected JSON type and follow the service's field-level rules; do not remove a required key merely because its value is empty.

## Encryption exceptions and callbacks

Do not assume that every sheet uses `reqBody.data` or encrypted `respData`. The following sheets explicitly describe unencrypted data structures:

- `eNACH-PUSH` — push payload sections are described as without encryption.
- `MAND-CREATION-API` — request and response fields are described as without encryption.
- `MAND-CREATION-STATUS-API` — request and response fields are described as without encryption.
- `MAND-CALLBK-PUSH` — callback payload sections are described as without encryption.

`REDIRECT-TO-ENTITY` supports configured response modes: Server-to-Server (`S`), UI redirection (`U`), or both (`B`). The source says the Server-to-Server request body may optionally be encrypted when the entity's encryption flag is enabled, using `AES/CBC/PKCS7Padding`. Treat callback URLs, encryption flags, and keys as environment configuration supplied by MFU.

For UPI intent payments, MFU receives the payment-aggregator callback and uses the existing `REDIRECT-TO-ENTITY` flow to push `netBkPayDt` to the entity. Build the callback handler to be idempotent because the API's unique references identify business events even if transport retries occur.

## Service map

Always use the corresponding source sheet for the exact endpoint, `apiType`, required fields, and response model.

### Account, CAN, and consent services

| Sheet | Purpose |
| --- | --- |
| `eCAN-PAN-VERIFY` | Verify PAN data before CAN registration. |
| `CAN-REG` | Create or modify a CAN and its holder, KYC, contact, FATCA, bank, depository, and nomination details. |
| `CAN-STATUS` | Check CAN registration/data status. |
| `CAN-PROOF-IMG` | Upload CAN proof images. |
| `CAN-VAL` | Validate a CAN. |
| `CAN-FETCH` | Fetch CAN data. |
| `CAN-BNK-VAL` | Validate CAN bank details. |
| `CAN-FOLIO-VAL` | Validate CAN/folio holding details; see the naming discrepancy below. |
| `PRN-VAL` | Validate a payment reference number. |
| `INV-CON-ENTRY` | Record investor consent. |
| `INV-CON-VIEW` | View investor consent details. |

For entities enabled for workflow type 3, `CAN-REG.panVerifyRefNo` is conditionally mandatory and is sourced from `eCAN-PAN-VERIFY`. The `CAN-REG.kycSecType` values documented are `ENT`, `NAK`, and `NA`; its nested requirements depend on the configured workflow and KYC result.

### Transaction and order services

| Sheet | Purpose |
| --- | --- |
| `NORMAL-TXN` | Submit purchase, redemption, switch, and related normal orders. |
| `SYS-TXN` | Submit SIP, STP, and SWP systematic instructions. |
| `SYS-CANCEL-TXN` | Cancel SIP, STP, or SWP instructions. |
| `TXN-AUT-DET` | Retrieve transaction-authorization details; see the naming discrepancy below. |
| `TXN-APPROVAL` | Submit transaction approval. |
| `TXN-HIST` | Fetch transaction history. |
| `STATUS-CHK-TXN` | Check order/transaction status. |
| `ORD-PAYMT-LINK` | Retrieve approval/payment links and, when eligible, `upiIntentLink`. |
| `ORDER-UTILITY` | Perform the documented order utility operation. |

In `NORMAL-TXN`, the detailed V2.9 sheet documents `txnType` values `B`, `R`, `S`, `U`, and `Z`, and says `orderMode` must be `Z`. In `SYS-TXN`, the sheet documents `txnType` values `V`, `J`, and `E`, with `orderMode` `Z`. Use all conditional fields exactly as documented for the selected transaction type, account mode, payment mode, and configured entity features.

For UPI intent support, `NORMAL-TXN` and `SYS-TXN` responses include `upiIntentLink`. `ORD-PAYMT-LINK` accepts `deviceType`; `ipAddress` is conditionally mandatory when `deviceType` is `M`. Its response returns `upiIntentLink` only under the enablement and UPI-order conditions listed in that sheet. If intent-link generation fails, the System FAQs sheet says the order can still be created and `paymentLink` can be used or the intent link can be fetched later.

### Mandate services

| Sheet | Purpose |
| --- | --- |
| `eNACH-REG` | Register an eNACH/PayEezz mandate. |
| `eNACH-STATUS` | Check eNACH registration status. |
| `eNACH-PUSH` | Receive eNACH status/data pushed by MFU. |
| `MAND-CREATION-API` | Create a UPI AutoPay mandate. |
| `MAND-CREATION-STATUS-API` | Check UPI AutoPay mandate creation status. |
| `MAND-CALLBK-PUSH` | Receive UPI AutoPay callback data pushed by MFU. |
| `SWP-PAYEEZ` | Swap an active SIP from PayEezz to UPI AutoPay as documented. |

The V2.9 revision of `MAND-CREATION-API` removes request fields `vpaId` and `workflowType`, adds `deviceType` and `linkType`, and adds response field `qrCode`. `deviceType` allows `B`, `A`, and `I`; `linkType` is conditionally mandatory for iOS (`deviceType` `I`). Follow the current V2.9 field table, not examples or earlier revision notes that still describe superseded fields.

### MFU-to-entity and scheme services

| Sheet | Purpose |
| --- | --- |
| `REDIRECT-TO-ENTITY` | Return UI and/or Server-to-Server payment/approval results to the entity. |
| `HIGH-VAL-TXN` | Push high-value transaction information. |
| `CHNL-RESP-FEED` | Push channel response feedback. |
| `SCHEME-PUSH` | Push Scheme Master File or Scheme Threshold Data. |
| `SCHSTSCHK` | Check the status of scheme-file processing. |

Expose callback endpoints only after validating the configured MFU authentication/encryption contract. Record the request identifiers and return the exact acknowledgement format documented by each push sheet.

## Source discrepancies to resolve during onboarding

The source workbook contains conflicting identifiers. They are preserved in the full reference and must be confirmed with MFU for the target environment:

- The services list and sheet heading use `TXN-AUT-DET`, while request-header and service field tables use `TXN-AUT-DETH`.
- The sheet heading uses `CAN-FOLIO-VAL`, while its detailed `apiType` table and samples use `CAN-FOL-VAL`.
- The sheet heading uses `eNACH-STATUS`, while its detailed `apiType` table and samples use `eNACH_STATUS`.
- The services overview describes `NORMAL-TXN` order modes `X` and `Z`, while the detailed V2.9 `NORMAL-TXN` request table says the value should always be `Z`.
- Some sample request headers use an `apiType` copied from another service. Treat the service's field table as the stronger source, but confirm discrepancies rather than changing values by inference.
- The workbook contains earlier revision notes and samples alongside V2.9 tables. When they conflict, verify the production contract with MFU.

## Scheme master ingestion

MFU supplies incremental, pipe-delimited files only when data changed during the day. The source says the files are emailed to the entity's designated email address.

| Data set | File-name pattern | Key/usage |
| --- | --- | --- |
| Scheme master | `MFU_SCHEME_MASTER_INC_<yyyymmdd>.dat` | `Fund_Code` plus `Scheme_Code` is the documented unique combination. |
| Scheme threshold | `MFU_SCHEME_THRESHOLD_INC_<Date>.dat` | Contains scheme thresholds and transaction parameters. |

Implement ingestion as an idempotent upsert process:

1. Archive the received file and record its name, receipt time, checksum, and processing state.
2. Validate the pipe-delimited column count and field types against the [scheme master reference](generated/MFU_SCHEME_MASTER_REFERENCE.md).
3. Stage the entire file before changing active data.
4. Upsert records using the source's documented identifiers; do not treat an incremental file as a full snapshot.
5. Reject or quarantine malformed records without inventing defaults.
6. Publish the staged changes atomically and retain an auditable processing report.

The source explicitly says scheme data is maintained by AMCs and supplied on an “as is where is” basis. Build transaction validation from the received values and preserve unknown codes for investigation.

## UAT usage

The UAT reference contains scheme links and samples for CANs, depository accounts, email/mobile combinations, folio holdings, banks, PayEezz registrations, ARN/RIA records, EUINs, virtual-account logic, and supported payment banks. Use it only in the UAT environment.

Test at least:

- token generation, expiry, invalid-token handling, and token refresh;
- encryption/decryption with the MFU-provided UAT key and IV;
- a successful and failed call for every implemented service;
- required, optional, and conditional-mandatory fields;
- duplicate `uniqueId` behavior and safe client retry handling;
- business failures returned with HTTP `200`, plus transport/authentication failures with non-`200` status;
- callback authentication, duplicate delivery, delayed delivery, and out-of-order status updates;
- scheme/threshold incremental-file replay, malformed rows, and partial processing failure;
- UPI intent success, missing intent link, fallback `paymentLink`, and later `ORD-PAYMT-LINK` retrieval.

Do not copy UAT account, PAN, bank, mobile, email, or mandate values into production configuration, logs, fixtures distributed outside the approved test environment, or public documentation.

## Implementation checklist

- [ ] MFU confirmed the UAT and production base URLs and the exact `apiType` values affected by source discrepancies.
- [ ] Secrets, encryption keys, and IVs are stored outside source control and separated by environment.
- [ ] OAuth token caching uses `expires_in` and refreshes safely before expiry.
- [ ] JSON serialization preserves exact field names, empty-value rules, array shapes, and conditional sections.
- [ ] Encryption is applied only to the sections specified by each service.
- [ ] HTTP status handling separates authentication/transport errors from decrypted business responses.
- [ ] `uniqueId` values are collision-resistant and persisted for traceability and retries.
- [ ] Logs redact credentials, tokens, encrypted secrets, PANs, account numbers, personal data, and mandate identifiers.
- [ ] Callback handlers authenticate requests, are idempotent, and persist raw/auditable status transitions securely.
- [ ] Scheme and threshold increments are validated, archived, replay-safe, and applied atomically.
- [ ] UAT covers happy paths, documented validation errors, timeouts, retries, and callbacks.
- [ ] Production readiness is confirmed against the original V2.9 workbook and MFU onboarding configuration.
