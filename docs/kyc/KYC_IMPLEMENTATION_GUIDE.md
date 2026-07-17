# KYC Implementation Guide

This guide summarizes the 120-page Signzy Distributor API Reference supplied in `signzy_doc.pdf`. Use the [complete page-aware conversion](generated/signzy-distributor-api-reference.md) for exact field descriptions, validation rules, reference values, and payload samples. The [endpoint index](generated/signzy-api-endpoint-index.md) maps each documented operation to its source page.

## Scope and source status

The API supports a hierarchical distributor/channel model and a multi-step investor onboarding workflow. A channel creates onboarding records, investors authenticate into an onboarding, and KYC data is collected through document extraction, form updates, verification, and downstream AMC/KRA integration.

The source itself states that the documentation is a work in progress and that properties, objects, and, in rare cases, endpoints may change. Confirm current endpoint contracts, HTTP methods, grants, and production credentials with Signzy before release. This guide does not fill in methods or values that the PDF does not state.

## Environments

| Surface | Preproduction hostname | Production hostname |
| --- | --- | --- |
| Multi-channel and onboarding APIs | `multi-channel-preproduction.signzy.tech` | `multi-channel.signzy.tech` |
| Distributor Dashboard APIs | `investor-onboarding-preproduction.signzy.tech` | `investor-onboarding.signzy.tech` |

All documented API traffic uses HTTPS.

## Authentication scopes

The reference describes three related login contexts. Keep their tokens and identifiers separate.

| Context | Login | Token field | Principal identifier | Used for |
| --- | --- | --- | --- | --- |
| Channel | `/api/channels/login` | `id` | `userId`, also called the channel ID | Channel management, grants, onboarding creation, and channel-level retrieval APIs |
| Investor onboarding | `/api/onboardings/login?ns= channel_username` | `id` | `userId`, used as `merchantId` in onboarding operations | The investor’s onboarding workflow |
| Distributor Dashboard | `/api/distributorAdmins/login` | `id` | `userId`, the distributor ID | Dashboard operations such as adding an AMC/channel |

The channel login request contains `username` and `password`. Its response contains `id`, `ttl`, `created`, and `userId`. The investor login uses the onboarding `username`, the password returned as `createObj.id` when the onboarding is created, `platform`, and `signzyCaptchaResponse`.

Authenticated calls accept the access token in the `Authorization` header. The source also mentions the `access_token` query parameter for GET requests, but explicitly recommends the header because query parameters may be logged.

```text
Authorization: <access token>
```

Keep channel passwords, investor tokens, and dashboard tokens on trusted server infrastructure. The source recommends a reverse proxy and warns against sending API keys/passwords to client-side code.

## Identifiers to retain

| Identifier | Source | Later use |
| --- | --- | --- |
| Channel ID | Channel login response `userId` | Child-channel paths, onboarding creation, channel queries, and onboarding pulls |
| Onboarding ID | Create-onboarding response `id` | Onboarding retrieval and CAMS/Karvy/CVL response pulls |
| Onboarding password | Create-onboarding response `createObj.id` | Investor login |
| Merchant ID | Investor login response `userId` | `merchantId` in `execute` and `updateForm` calls |
| Investor access token | Investor login response `id` | `Authorization` for onboarding workflow calls |
| File ID and `directURL` | Upload response | Document extraction, form images, signature, photo, video, and contract inputs |
| Video `transactionId` | Video start response | Recorded-video verification |
| Unsigned contract URL | `esign/createPdf` response `combinedPdf` | Aadhaar eSign URL generation |
| Signed contract URL | eSign result | Saving the signed contract and completing verification |

## High-level workflow

| Phase | Main operation | Result |
| --- | --- | --- |
| 1. Channel setup | Login, create/update child channels, list channels, fetch AMC grants | A channel token, channel ID, controls, and the sections/documents allowed by the AMC |
| 2. Onboarding bootstrap | Captcha, create onboarding, investor login | Onboarding ID, onboarding password, merchant ID, investor token, and investor grants |
| 3. File exchange | Upload supporting files and retain `directURL` values | URLs for POI, POA, cheque, signature, photo, video, and contracts |
| 4. Identity and address | Execute recognition/DigiLocker/offline-Aadhaar tasks, then persist normalized forms | POI, permanent POA, and correspondence POA data |
| 5. Bank verification | Cheque extraction, bank form update, penny transfer, and amount verification | Verified bank-account data |
| 6. KYC forms | KYC data, related-person POI, FATCA, signature, and user photo | Completed regulatory and profile sections |
| 7. Video and contract | Start/verify video, create contract PDF, eSign or save signed PDF | Video verification and signed onboarding contract |
| 8. Final validation | Execute verification engine and pull onboarding/downstream responses | Consolidated onboarding status and AMC/KRA integration results |

The AMC grants response determines which sections are enabled. Do not hard-code a single universal journey; use `poi_list`, `poa_list`, `cpoa_list`, `allowed_sections`, and `form_sections` returned by `/api/channels/getAmcGrants`, plus the `grants` returned by investor login.

## File exchange

### Upload

- Endpoint: `POST /api/onboardings/upload`
- Authentication: investor access token
- Request: multipart form data with `ttl`
- Response object: `file.id`, `file.filetype`, `file.size`, `file.directURL`, and `file.protected`

The documented `ttl` values are 2 minutes, 10 minutes, 30 minutes, 2 hours, 12 hours, 7 days, 15 days, 1 month, 3 months, 6 months, 1 year, 3 years, and `infinity`. The PDF states that URLs expire after 30 seconds by default unless `ttl` is supplied. Upload each required side/page separately; for example, Aadhaar normally needs both sides while PAN normally uses the front.

### Download

- Endpoint: `GET /api/onboardings/download`
- Query field: `q`
- Value: the persisted/direct URL
- Response: raw file content

Download or process short-lived URLs promptly. Do not log URLs containing access-bearing paths.

## Channel and onboarding bootstrap

### Channel hierarchy

A channel can create child channels, belongs to another channel, and owns many onboardings. Parent controls include activation, allowed counts, self-updating, child creation, frontend URL access, product information, callback behavior, and grants. The complete property tables are on [source pages 5-12](generated/signzy-distributor-api-reference.md#source-page-5).

### Captcha

- `GET /api/captchas/get` returns an `id` and raw captcha image.
- `POST /api/captchas/verify` accepts `text` and `id`, returning `result.isVerified`.

### Create onboarding

`POST /api/channels/…channel ID ../onboardings` uses the channel token. Required fields include `email`, `username`, `phone`, and `name`. Optional fields include `channelEmail`, `redirectUrl`, `languageList`, `languageSelected`, and `prefillData`.

The response returns the onboarding `id` and a `createObj` containing the investor-facing `username` and password (`createObj.id`). Preserve both; they are required for investor login.

### Investor login

The investor login namespace uses the channel username:

```text
/api/onboardings/login?ns= channel_username
```

The response `id` is the investor access token and `userId` is the merchant ID used in subsequent onboarding calls. The response also includes journey grants such as `poi`, `poa`, `bankaccount`, `documents`, `video`, `contract`, `bankaccountverify`, `aadhaaresign`, `esign`, `photo`, and `corrAddress`.

## Generic onboarding operation shapes

Many journey actions share two endpoints. Their behavior is selected by exact nested discriminator values, so do not build one untyped “catch-all” request.

### `/api/onboardings/execute`

The recurring request shape contains:

- `merchantId`
- `inputData.service`
- `inputData.type`
- `inputData.task`
- `inputData.data`

Examples of documented discriminator combinations include:

| Purpose | `service` | `type` | `task` |
| --- | --- | --- | --- |
| POI/POA recognition | `identity` | `individualPan`, `aadhaar`, `passport`, `drivingLicence`, or `voterid` as applicable | `autoRecognition` |
| Offline Aadhaar | `identity` | `aadhaar` | `offlineAadhaar` |
| DigiLocker | `identity` | `aadhaarDigiLocker`, `panDigiLocker`, or `dlDigiLocker` as applicable | `createUrl` or `getDetails` |
| Cancelled cheque | `identity` | `cheque` | `autoRecognition` |
| Penny transfer | `nonRoc` | `bankaccountverifications` | `bankTransfer` |
| Verify transfer amount | `nonRoc` | `bankaccountverifications` | `verifyAmount` |
| Related-person POI | `relatedIdentity` | Document-specific | `autoRecognition` |
| Start video | `video` | `video` | `start` |
| Verify recorded video | `video` | `video` | `verify` |
| Create contract PDF | `esign` | Empty in the sample | `createPdf` |
| Create Aadhaar eSign URL | `esign` | Empty in the sample | `createEsignUrl` |
| Retrieve eSign data | `esign` | Empty in the sample | `getEsignData` |
| Final validation | `verificationEngine` | Not defined in the field table | Not defined in the field table |

Use the exact operation section for required `data` fields. The PDF does not explicitly print an HTTP method next to many `execute` occurrences; confirm it with Signzy rather than assuming.

### `/api/onboardings/updateForm`

The recurring form-update shape contains:

- `merchantId`
- `save`
- `type`
- `data`

Documented `type` values include `identityProof`, `addressProof`, `corrAddressProof`, `userForensics`, `bankAccount`, `kycdata`, `fatca`, `signature`, and `userPhoto`. Saving a normally signed contract uses `save: "esign"` and `data.signedPdf` instead of the ordinary `save: "formData"` pattern.

The PDF also does not explicitly print an HTTP method next to many `updateForm` occurrences. Confirm the method before implementation.

## Identity and address documents

### POI

The POI flow supports `individualPan`, `aadhaar`, `passport`, `drivingLicence`, and `voterid`, plus offline Aadhaar and the documented DigiLocker types. Execute extraction first, validate the response, then persist normalized fields with `type: "identityProof"`.

The `proofType` for normal POI extraction is `identity`. Document image-array requirements vary by document; PAN uses one front image, Aadhaar/passport/voter ID generally use two images, and driving licence accepts one or two as described in the source.

### Permanent POA

Execute extraction with `proofType: "address"`, then save normalized data with `type: "addressProof"`. Supported document-specific forms include Aadhaar, passport, driving licence, voter ID, Aadhaar XML, and supported DigiLocker variants.

### Correspondence POA

Execute extraction with `proofType: "corrAddress"`, then save normalized data with `type: "corrAddressProof"`. The correspondence-address section additionally documents `gasBill` and other accepted proof categories.

State, country, category, account, occupation, and related codes must come from the reference tables on [source pages 105-118](generated/signzy-distributor-api-reference.md#source-page-105). Do not substitute display names when a code is required.

## User forensics

The source says the forensics update should ideally be called after each onboarding step. The update uses:

- `save: "formData"`
- `type: "userForensics"`
- `data.type: "usersData"`

The payload groups `geoLocationData`, `browserData`, device information, coordinates, and `pageName` by journey areas such as identity, address, bank account, documents, video, contract, and thank-you. Collect this information only with the required notice/consent and protect it as sensitive telemetry.

## Bank-account verification

1. Upload and execute cancelled-cheque recognition with `service: "identity"`, `type: "cheque"`, and `task: "autoRecognition"`.
2. Save reviewed bank details with `type: "bankAccount"`, including the exact required fields such as `accountNumber` and `ifsc`.
3. Start penny transfer using `service: "nonRoc"`, `type: "bankaccountverifications"`, and `task: "bankTransfer"`.
4. Retain the returned amount and `signzyReferenceId`.
5. Verify the amount with task `verifyAmount`.
6. Send the corresponding user-forensics update.

Do not infer successful ownership solely from cheque OCR; use the documented penny-transfer verification result.

## KYC data, related person, and FATCA

- The main form section uses `type: "kycdata"` and contains identity/profile details, occupation/account classifications, contact data, and AMC/KRA codes.
- When a related person is applicable, the source documents a separate POI extraction using `service: "relatedIdentity"`, followed by related-person fields in the FATCA payload.
- FATCA uses `type: "fatca"` and includes `pep`, `rpep`, `residentForTaxInIndia`, tax-jurisdiction fields, birth-country fields, and conditional related-person information.

Required fields vary based on residency and related-person flags. Implement conditional validation from the field tables rather than sending placeholders for every branch.

## Signature, photo, video, and contract

### Signature and photo

- Signature form: `type: "signature"`, with `signatureImageUrl` and optional `consent`.
- User photo form: `type: "userPhoto"`, with `photoUrl`.

### Video

1. Start with `service: "video"`, `type: "video"`, `task: "start"`.
2. Retain `transactionId` and `randNumber`.
3. Submit an MP4 using H264 video and AAC audio with task `verify`.
4. Include the required `video`, `transactionId`, and `matchImage`; `snapshot` and face-detection `seconds` are documented as optional.

### Contract and eSign

1. Create the contract using `service: "esign"`, `task: "createPdf"`; retain `combinedPdf`.
2. For Aadhaar eSign, create the signing URL with task `createEsignUrl`, `inputFile`, and `signatureType: "aadhaaresign"`.
3. Retrieve signed data with task `getEsignData`; retain `esignedFile`.
4. For the normal eSign path, save `data.signedPdf` with `save: "esign"`.
5. Send the contract user-forensics update.

## Verification and downstream responses

Run the verification engine only after all AMC-required data is present. The source says missing or incorrect AMC-required data produces an error.

`POST /api/onboardings/pullonboardings` supports:

- Status-based retrieval using `channelId`, `limitLength`, `skipLength`, and `status` (`all`, `pending`, `accepted`, or `rejected`).
- ID-based retrieval using `channelId`, `onboardingId`, and optional `extraFields` such as `CAMS`.

Additional channel-token endpoints retrieve downstream integration data:

- `POST /api/onboardings/pullCamsResponse`
- `POST /api/onboardings/pullKarvyData`
- `POST /api/onboardings/pullkarvyresponse`
- `POST /api/onboardings/pullCvlData`
- `POST /api/onboardings/pullCvlResponse`

Treat returned CAMS, Karvy, and CVL payloads as external-system responses. Preserve their timestamps and raw push/XML data for reconciliation and support diagnostics.

## Implementation safeguards

- Keep channel, investor, and dashboard tokens in separate typed credential containers.
- Never log passwords, access tokens, Aadhaar/PAN data, bank details, file URLs, signature images, video URLs, or signed-contract URLs.
- Enforce all documented length, date, enum, and conditional rules before calling Signzy.
- Use AMC grants to build the journey dynamically.
- Download or process `directURL` values before expiry and never assume indefinite availability.
- Make `execute` and `updateForm` payloads operation-specific and validate discriminator combinations.
- Make retries idempotent at the application layer where possible; the source does not define idempotency keys.
- Record the source operation, `merchantId`, onboarding ID, response timestamp, and downstream status for auditability without copying sensitive payloads into general logs.
- Confirm all HTTP methods marked `Not stated` in the [endpoint index](generated/signzy-api-endpoint-index.md) with Signzy.
- Test the device/browser matrix on [source pages 119-120](generated/signzy-distributor-api-reference.md#source-page-119), especially video and contract behavior on Safari/iOS.
- Reconfirm the contract with Signzy before production because the source explicitly describes itself as evolving documentation.

## Recommended test coverage

- Channel login, expiry, invalid token, and channel deactivation.
- Parent controls and AMC grants for multiple child channels.
- Captcha success/failure and onboarding creation validation.
- Investor login with incorrect namespace, password, or captcha.
- One-sided/two-sided document uploads and expired file URLs.
- Every enabled POI/POA type, including offline Aadhaar and DigiLocker branches.
- Permanent and correspondence address divergence.
- Cheque OCR, penny-transfer success/failure, and amount mismatch.
- Resident/non-resident FATCA and related-person conditional branches.
- Signature/photo upload, video codec rejection, face-match failure, and retry.
- Contract creation, Aadhaar eSign callback/result, and normal signed-PDF path.
- Verification failure caused by missing AMC-required data.
- Pagination and status filters for onboarding pulls.
- CAMS, Karvy, and CVL success, failure, empty, and delayed-response reconciliation.
