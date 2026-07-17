# MFU Transaction API Reference V2.9

Complete Markdown conversion of [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx).

## Sheet index

- [Revision History](#revision-history)
- [System FAQs](#system-faqs)
- [API Services List](#api-services-list)
- [Authorization with OAuth 2.0](#authorization-with-oauth-20)
- [Request Header and Response Det](#request-header-and-response-det)
- [eCAN-PAN-VERIFY](#ecan-pan-verify)
- [CAN-REG](#can-reg)
- [CAN-STATUS](#can-status)
- [CAN-PROOF-IMG](#can-proof-img)
- [eNACH-REG](#enach-reg)
- [eNACH-STATUS](#enach-status)
- [eNACH-PUSH](#enach-push)
- [MAND-CREATION-API](#mand-creation-api)
- [MAND-CREATION-STATUS-API](#mand-creation-status-api)
- [MAND-CALLBK-PUSH](#mand-callbk-push)
- [NORMAL-TXN](#normal-txn)
- [SYS-TXN](#sys-txn)
- [SYS-CANCEL-TXN](#sys-cancel-txn)
- [TXN-AUT-DET](#txn-aut-det)
- [TXN-APPROVAL](#txn-approval)
- [TXN-HIST](#txn-hist)
- [CAN-VAL](#can-val)
- [CAN-FETCH](#can-fetch)
- [PRN-VAL](#prn-val)
- [CAN-BNK-VAL](#can-bnk-val)
- [SWP-PAYEEZ](#swp-payeez)
- [CAN-FOLIO-VAL](#can-folio-val)
- [INV-CON-ENTRY](#inv-con-entry)
- [INV-CON-VIEW](#inv-con-view)
- [STATUS-CHK-TXN](#status-chk-txn)
- [ORD-PAYMT-LINK](#ord-paymt-link)
- [REDIRECT-TO-ENTITY](#redirect-to-entity)
- [HIGH-VAL-TXN](#high-val-txn)
- [CHNL-RESP-FEED](#chnl-resp-feed)
- [SCHEME-PUSH](#scheme-push)
- [ORDER-UTILITY](#order-utility)
- [SCHSTSCHK](#schstschk)
- [ERROR CODE](#error-code)
- [Master Data Sheet](#master-data-sheet)
- [Possible Values Mapping](#possible-values-mapping)

## Revision History

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `Revision History`

### Table 1

Source cells: `B2:F22`

| Version No | Sheet Name | Description | Revised Date | Author |
| --- | --- | --- | --- | --- |
| 1.0 | Initial Baseline Version | First API Specification Version | 2024-06-07 | Subbulakshmi |
| 1.1 | Error Code<br>Fetch UTRN<br>Normal-TXN | a. New Error Code sheet is added for General and Transaction Error Code<br>b.Fetch UTRN Service field level condtional mandatory is changed for reqType "S"<br>c.Normal TXN service , amcPaymentTs field is added in Payment section | 2024-06-26 | Subbulakshmi |
| 1.2 | Normal-TXN<br>TXN-AUT-DET<br>TXN-APPROVAL<br>Service Details | New Sheet is added for Service Details and usage for service.<br>In Normal Transaction , Order Mode Z  and Purchase,Redeem,Switch is supported for Individual and Non Individual transactions.<br>For Non Individual, exposed two services for Transaction authrization details and Transaction approval . | 2024-10-28 | Renuka |
| 1.3 | CAN-VAL<br>CAN-FETCH<br>PRN VAL<br>CAN-BNK-VAL<br>SWP-PAYEEZ<br>CAN-FOLIO-VAL<br>INV-CON-ENTRY<br>INV-CON-VIEW | The following FinTech API Utility Services are added<br>i. CAN Validation Service<br>ii. CAN Fetch Service<br>iii. PRN validation service<br>iv. CAN Bank validation service<br>v. Swap PayEezz<br>vi. CAN Folio validation service<br>vii. Investor consent Entry<br>Viii. Investor Consent Detail view | 2024-11-26 | Renuka & Saraswathi |
| 1.4 | SYS-TXN<br>SYS-CANCEL-TXN | a. The following FinTech API Utility Services are added<br>     i. Systematic Transaction Service<br>     ii. Systematic Cancellation Service<br>b. Removed bnkId field from the Payment section in NORMAL-TXN Service<br>c. The description and the cell alignment has been changed for all sheets. | 2024-11-27 | Binu |
| 1.5 | NORMAL-TXN | srcBankId and targetBankId fields are removed in Scheme level payment strucutre for Direct to AMC Orders | 2025-01-01 | Subbulakshmi |
| 1.6 | STATUS-CHK-TXN<br>ORD-PAYMT-LINK<br>HIGH-VAL-TXN<br>CHNL-RESP-FEED | The following FinTech API Services are added<br>a. Status Check Service.<br>b. Order Payment Link.<br>c. High Value Transaction Service.<br>d. Channel Response Feed Service. | 2025-02-04 | Renuka & Saraswathi |
| 1.7 | NORMAL-TXN<br>SYS-TXN | The field entityEOPNo has been added in SCHD-ENTRY sheet | 2025-03-13 | Binu |
| 1.8 | CAN-FOLIO-VAL<br>SCHEME_PUSH<br>SCHSTSCHK | a. The new field isHoldingAvail has been added and removed checkDigit field in CAN-FOLIO-VAL service.<br>b. Added possible values mapping sheet <br>c. The following FinTech API Services are added<br>         i. Scheme push for SMF and STD<br>         ii. status check api for SMF and STD | 2025-03-21 | Renuka & Saraswathi |
| 1.9 | SWP-PAYEEZ | The following FinTech API Utility Services are added for Swapping from PayEezz to UPI AutoPay for Active SIP<br>        1. Swap PayEezz Service | 2025-05-20 | Subramani |
| 2.0 | oAuth<br>Request Header Detail change | ​Improvements done in OAuth 2 service.<br>i)In the Request Header and Response Detail sheet, User ID and encrypted password is removed as these are  part of oAuth service<br>ii)While calling any service (if the Token is not valid), instead of oAuth response structure, HTTP Error Code will be passed as Authentication is failed.<br>iii)When HTTP status code is other than 200,  the oAuth Error response data is passed in the Error Input stream. Entity System should read the error Input stream of HTTP Error Codes.<br>iv)Because of this change, the service URL of oA​uth2 Service is changed. | 2025-05-26 | Subbulakshmi |
| 2.1 | MAND-CREATION-API<br>MAND-CREATION-STATUS-API<br>SYS-TXN<br>Scheme-Push | The following FinTech API Utility Services are added<br>i. UPI AutoPay Mandate Creation for Transaction Service<br>ii. UPI AutoPay Mandate Creation Status Service<br>iii.The field payMode has been updated with the possible values in SYS-TXN sheet under subSeqSec section<br>iv. Scheme Push API , Based on strucutre type is added in response body | 2025-07-25 | Subbulakshmi |
| 2.2 | NORMAL-TXN<br>SYS-TXN<br>SYS-CANCEL-TXN | The new field entityRemarks has been added in the reqBody section for the below services.<br>i.   NORMAL-TXN<br>ii.  SYS-TXN<br>iii. SYS-CANCEL-TXN<br><br>As part of Halt ticket removal activity, entityEOPNo is not needed. entityEOPNo is removed from the below services<br>i.   NORMAL-TXN<br>ii.  SYS-TXN<br><br>Based on Axis Custoday, For Folio Based transactions, Holding nature , tax status, pan number make it as optional | 2025-10-31 | Subbulakshmi |
| 2.3 | NORMAL-TXN<br>STATUS-CHK-TXN | i. The following fields has been added in the request details of the NORMAL-TXN service.<br>    1. isSpclProductFlag<br>    2. smartSwitchVolType<br>    3. smartSwitchVol<br>ii. The field txnType has been updated with the possible values in NORMAL-TXN service.<br>iii. The field corn has been adden in the response details section under the ordDtl section.<br>iv. Added corn in the response body of STATUS-CHK-TXN Service. <br>v. Updated the Error Code sheet | 2025-11-07 | Binu |
| 2.4 | MAND-CALLBK-PUSH | The following FinTech API Utility New service is added<br>i. UPI AutoPay Mandate Callback Push API Service<br>ii.Mandate createion status API sheet is updated for MFU status and Payment Aggregator status | 2025-11-24 | Saraswathi |
| 2.5 | eCAN-PAN-VERIFY<br>CAN-REG<br>CAN-STATUS<br>CAN-PROOF-IMG<br>eNACH-REG<br>eNACH-STATUS<br>eNACH-PUSH | The following FinTech API Utility Services are added for CAN and PayEezz Mandate registration service<br>i. PAN Verify Service<br>ii. CAN Registration Service<br>iii. CAN Data Status Service<br>iv. CAN Image Proof Upload Service<br>v. eNach Registration Service<br>vi. eNach Status check Service<br>vii. eNach Push Service | 2026-01-20 | Saraswathi |
| 2.6 | <br>ORDER_UTILITY<br>SCHSTSCHK <br>MAND-CREATION-API<br>SWP-PAYEEZ | i. The following FinTech API Utility New service is added<br>     1. Order Utility Service<br>ii. SCHSTSCHK service request details has been updated.<br>iii. The following changes made in MAND-CREATION-API service for Intent flow<br>     1. Added workflowType field in the request body<br>     2. Added deepLink field in the response body<br>iv. In SWP-PAYEEZ service removed jointHolderFlag and holderDetail fields  | 2026-01-30 | Subbulakshmi |
| 2.7 | REDIRECT-TO-ENTITY | i. The following FinTech API Utility is added for this CR#260207<br>     1. APIEezz Link UI Redirection to entity page after approval | 2026-03-18 | Saraswathi |
| 2.8 | UPI Intent Link changes | The following services have been updated for the UPI Intent Link feature:<br><br>i. In the NORMAL-TXN service response, a new field upiIntentLink has been added.<br>ii. In the SYS-TXN service response, a new field upiIntentLink has been added.<br>iii. In the ORD-PAYMT-LINK service, the following updates have been made:<br>        1. In the request, the deviceType & ipAddress field has been added.<br>        2. In the response, the upiIntentLink field has been added.<br>iv. System FAQs sheet is updated for upi intent callback response workflow  | 2026-05-14 | Subbulakshmi |
| 2.9 | MAND-CREATION-API | For the CR#260307 - Kotak Bank UPI AutoPay Mandate Registration via Intent/Dynamic QR <br>UPI Auto Pay Mandate Creation API – Request & Response is updated<br>The following changes are done in MAND-CREATION-API service:<br>i. Removed the vpaId and workflowType from the UPI Auto Pay Mandate Creation request.<br>ii. In UPI Auto Pay Mandate Creation request, a new field deviceType and linkType has been added.<br>iii. In UPI Auto Pay Mandate Creation response , a new field qrCode has been added. | 2026-05-25 | Subramani |

## System FAQs

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `System FAQs`

### Table 1

Source cells: `B2:D10`

| S.No | Questions | Answers |
| --- | --- | --- |
| 1 | Is OAuth mandatory for all services | Yes , OAuth is mandatory for all services. The OAuth access token must be included in the HTTP authorization header of the service request. |
| 2 | What is the expiry time for the OAuth token | The OAuth token expires after 24 hours. Each token is valid for one day only. |
| 3 |  if the OAuth token is expired or invalid, What will be the response  | If the OAuth token is expired or invalid, HTTP status code will be 400 or 401. The error message will not be in encrypted format. The entity will receive the error JSON structure.<br>When HTTP status code is other than 200,  the oAuth Error response data is passed in the Error Input stream. Entity System should read the error Input stream of HTTP Error Codes.<br>Sample Response for HTTP Status Code 401 : <br>[See JSON example 1 below]<br>Sample Response for HTTP Status Code 400 : <br>[See JSON example 2 below] |
| 4 | Is a null value allowed in a JSON request | No, null value is not allowed. If the value is not there, the JSON key should be present in request body with empty values. |
| 5 | Does the API support Payload Encryption | The API does not support full Payload Encryption. The request body is encrypted  |
| 6 | What is the algorithm used for Encryption | The Algorithm used for encryption in all the API's is  AES/CBC/PKCS7Padding |
| 7 | UPI intent Callback Response workflow in Entity | Once the customer successfully completes the payment using the UPI deep link, the MFU system will receive the UPI callback response from the payment aggregator.<br>Based on the callback response, the MFU system will push the payment response to the entity system through a Server-to-Server communication mechanism.<br>For this response push, the existing REDIRECT-TO-ENTITY service in the FinTech API will be utilized. The same netBkPayDt response payload will be pushed to the entity in encrypted format. |
| 8 | What happens if a UPI intent link is not generated during a transaction? | If BillDesk returns an error (any HTTP status code other than 200) or if the BillDesk server is down, a UPI intent link will not be generated.<br><br>In this scenario, an order will still be created in the MFU system, and the MFU payment link will be provided in the response via the paymentLink field. The entity can either use this payment link directly or fetch the intent link later using the Order Payment Link Service API. |

### JSON examples

#### JSON example 1 (cell D5)

```json
{"errorRespData":{"errorCode":"100007","errorMsg":"Token validity period is expired"}}
```

#### JSON example 2 (cell D5)

```json
{"errorRespData":{"errorCode":"100006","errorMsg":"Authorization Token is invalid"}}
```

## API Services List

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `API Services List`

### MF Utility – Fintech Transaction API Specification

### Table 1

Source cells: `B3:F39`

| S.No | Sheet Name | API | Description | Service Details |
| --- | --- | --- | --- | --- |
| 1 | Authorization with OAuth 2.0 | Authorization with OAuth 2.0 | Authorization with OAuth 2.0 API Details | MFU oAuth 2.0 is a mandatory service. An oAuth Token must be included in the HTTP header before starting any service. By default, the oAuth Token is valid for 24 hours. |
| 2 | Request Header and Response Detail | Request Header and Response Detail | Request Header and Response Detail | Request Header and Response Detail |
| 3 | Normal Transaction Service | Normal Transaction  | Normal Transaction Service | The Normal Transaction service is designed to process various transaction types through a single API. The available transaction types include:<br>  Purchase<br>  Redeem<br>  Switch<br><br>This API supports two order modes: <br>     API TransactEezz  - Z<br>     APIPay2Pa  - X<br><br>Please note that the X order mode (APIPay2Pa) supports only Purchase transactions and is limited to Individual CAN transactions. The Entity should handle the Payment in their side.<br><br>In contrast, the Z-order mode (API TransactEezz) supports Purchase, Redeem, and Switch transactions for both Individual and Non-Individual CAN's. |
| 4 | Systematic Transaction Service | SYS-TXN | Systematic Transaction Service | The Systematic Transaction service is designed to process various transaction types through a single API. The available transaction types include:<br>  1. SIP<br>  2. SWP<br>  3. STP<br><br>This API supports the following type of order mode: <br>     API TransactEezz  - Z |
| 5 | Systematic Cancellation Service | SYS-CANCEL-TXN | Systematic Cancellation Service | Systematic Cancellation Service is designed to process various Cancellation types through a single API. The available transation types are:<br>   1. SIP<br>   2. STP<br>   3. SWP |
| 6 | Transaction Authorization Detail | TXN-AUT-DET | Transaction Authorization Details  | Transaction Authorization Detail service is exclusively for Non-Individual CAN transactions. This service allows the entity to retrieve order details and authorization approval level for the order. It only supports order mode Z. |
| 7 | Transaction Order Approval Service | TXN-APPROVAL | Transaction Order Approval Service | The transaction approval service is exclusively for Non-Individual CAN transactions. It is utilized to either approve or reject orders for Non-Individual transactions. |
| 8 | Transaction History API Service | TXN-HIST | Transaction History API Service | Transaction History API service allows the entity to retrieve the all order history details.  |
| 9 | CAN Validation Service | CAN-VAL | CAN Validation API Service | CAN Validation Service allows the entity to check whether the given CAN is valid or not and provides few more Validation Details |
| 10 | CAN Fetch Service | CAN-FETCH | CAN Fetch Service | CAN Fetch Service allows the entity to fetch CAN and CAN Status for the provided input details. |
| 11 | PRN Validation Service | PRN VAL | PRN Validation Service | PRN Validation Service allows the entity to validate the PRN for the provided input details. |
| 12 | CAN Bank Validation Service | CAN-BNK-VAL | CAN Bank Validation Service | CAN Bank Validation Service allows the entity to validate the bank details against the CAN. |
| 13 | Swap PayEezz Service | SWP-PAYEEZ | Swap PayEezz Service | Swap PayEezz Service allows the entity to swap the payeezz from the given transaction. |
| 14 | CAN Folio Validation Service | CAN-FOLIO-VAL | CAN Folio Validation Service | CAN Folio Validation Service allows the entity to validate if the provided CAN and Folio are mapped. |
| 15 | Investor Consent Entry Service | INV-CON-ENTRY | Investor Consent Entry Service | Using this service the entity will be able to create an investor consent link. |
| 16 | Investor Consent View Service | INV-CON-VIEW | Investor Consent View Service | Investor Consent Detail view Service allows the entity to view the consent details and Retrigger Investor consent Details |
| 17 | Status Check Service | STATUS-CHK-TXN | Status Check Service | Status check Service |
| 18 | Order Payment Link Service | ORD-PAYMT-LINK | Order Payment Link Service | This service is used to fetch the Order payment link details |
| 19 | Redirection to Entity Page | REDIRECT-TO-ENTITY | Redirection to Entity Page | This is not a service. In the APIEezz TransacEezz flow, after successful investor approval, the user is redirected to the entity page via browser redirection. The MFU system will also send the same response to the entity server based on the entity configuration.<br><br>The same APIEezz entity callback URL will be used for all transaction redirections.<br><br>For server-to-server responses, if the entity is enabled with the encryption flag, the entire request body will be encrypted. The entity must use a separate Secret Key and IV Key to decrypt the data. (MFU will provide the key upon doing integration)<br><br>In browser redirection, the data will be passed as a plain JSON string along with the URL. |
| 20 | High Value Transaction Service | HIGH-VAL-TXN | High Value Transaction API Service | High value transaction push service from MFU to AMC entity |
| 21 | Channel Response Feed Service | CHNL-RESP-FEED | Channel Response Feed Service | Channel Response Feed Push Service from MFU to Entity |
| 22 | Scheme Push Service | SCHEME_PUSH | Scheme Push Service | Scheme Push Service from MFU to Entity |
| 23 | Scheme Push Status Check Service | SCHSTSCHK | Scheme Push Status Check Service | Satus check service for Scheme push |
| 24 | Mandate Creation API Service | MAND-CREATION-API | Mandate Creation API Service | Mandate Creation API Service for UPI AutoPay |
| 25 | Mandate Creation Status Check API Service | MAND-CREATION-STATUS-API | Mandate Creation Status Check API Service | Mandate Creation Status Check API Service for UPI AutoPay |
| 26 | Mandate Callback Push Service API | MAND-CALLBK-PUSH | Mandate Callback Push Service API | Mandate callback for UPI AutoPay |
| 27 | PAN Verify Service | PAN-VERFIY-API | PAN Verify Service | ​This service is for verifying the PAN KRA Status for CAN Registration. If the Entity is configured for Workflow Type 3 this service is mandatory. |
| 28 | CAN Registration Service | CAN-REG-SERVICE | CAN Registration Service | This service is used to create the eCAN in the MFU system.  The finTech API supports 3 kinds of workflow types for entities.<br>Type 1 : Normal Workflow. <br>Type 2 : Auto approval workflow. The owner for KYC Data is Entity<br>Type 3 : Auto approval workflow. But the KYC data is not received from the entity for valid PAN. If PAN KYC Status is NAK, the entity needs to provide the KYC Address section upon creating the CAN |
| 29 | CAN Data Status Service | CAN-DATA-STATUS | CAN Data Status Service | This service is used to get status of CAN |
| 30 | CAN Image Proof Upload Service | CAN-IMG-PROOF-UPLD | CAN Image Proof Upload Service | This service is used to upload the eCAN Proof image electronically. |
| 31 | eNach Registration Service | ENACH-REG-SERVICE | eNach Registration Service | This service is used to create a new PayEezz mandate |
| 32 | eNach Status check Service | ENACH-STATUS | eNach Status check Service | This service is used to check the status of the PayEezz Mandate |
| 33 | eNach Push Service | ENACH-PUSH-SERVICE | eNach Push Service | This service is used to Push the Mandate callback data |
| 34 | Order Utility Service | ORDER-UTILITY | Order Utility Service | The service is used to retrigger link for an order or to cancel the order |
| 35 | ERROR CODE | Error Code Sheet | General and Transaction Error Codes in MFU System | General and Transaction Error Codes in MFU System |
| 36 | Master Data Sheet | Master data Sheet | Master Data Sheet | Master Data Sheet |

## Authorization with OAuth 2.0

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `Authorization with OAuth 2.0`

### Authorization with OAuth 2.0 -  Access Token Generation

### This API will provide the access token , required to access the various API.

### Table 1

Source cells: `B4:C8`

| Transport Method | REST |
| --- | --- |
| URL Invoke Method | POST |
| Content Type | application/json |
| Response Format Type | JSON |
| URL | https://<UAT or PROD URL>/GetAccessTokenV1 |

### Request Parameters

### Table 2

Source cells: `B11:E14`

| Field | Description | Data Type | Mandatory |
| --- | --- | --- | --- |
| entityId | A unique Entity ID, as available in MFU for the Distributor / RIA or such other Entity using this facility.  | String | Yes |
| clientUser | Login ID of the user – initiating the API request. The Login User ID should be encrypted using AES/CBC/PKCS7Padding algorithm. MFU will provide a  public key and a IvKey for encryption at the time of integration | String | Yes |
| clientPwd | Password of the user. The password should be encrypted using AES/CBC/PKCS7Padding algorithm. MFU will provide a  public key and a IvKey for encryption at the time of integration | String | Yes |

### Success Response JSON Field

### Table 3

Source cells: `B16:E19`

| Field | Description | Data Type | Mandatory |
| --- | --- | --- | --- |
| access_token | Access Token. Currently Supported only 'Bearer' | String | Yes |
| token_type | Token Type | String | Yes |
| expires_in | Validity period of the access token in hours | Integer | Yes |

### Error Response JSON Field

### Table 4

Source cells: `B22:E24`

| Field | Description | Data Type | Mandatory |
| --- | --- | --- | --- |
| errorCode | Error Code | Number | Yes |
| errorMsg | Error Message | String | Yes |

### Sample Request and Response

### Table 5

Source cells: `B27:C30`

| Sample Request  | [See JSON example 1 below] |
| --- | --- |
| Sample Success Response JSON<br>HTTP Status Code is 200 | [See JSON example 2 below] |
| Sample Error Response JSON<br>HTTP Status code is 400 | [See JSON example 3 below] |
| Sample Error Response JSON<br>HTTP Status code is 401 | [See JSON example 4 below] |

### Accessing other service API with OAuth 2.0 access token

In order to access the FinTech APIs* with OAuth security, “access token” as received in the reponse should be passed in the HTTP header as a parameter (refer below)

### Header Parameter - Authorization:{{token_type}} {{access_token}}

### Sample value for Authorization : Bearer aab87efa-XXXX-XXXX-XXXX-XXXXXXXXXXXX

When calling any of the services, If the oAuth token is expired or invalid, The HTTP status code is 400 or 401.   
the error message will be in the following format only (not in encrypted format).    
[See JSON example 5 below].  
  
The entity system,First check the HTTP status code. If it is 200, success. For other than 200, It is failure. For failure case, check the Error Input stream for valid error message.

### JSON examples

#### JSON example 1 (cell C27)

```json
{
"reqBody":{"entityId":"400001","clientUser":"lXXxd3ce62cXX364fXXXXXXbXXX18d2c6a5cXXXXX","clientPwd":"6ed73XXXXXc3454XXXXX27a4752XXXXXX9"}
}
```

#### JSON example 2 (cell C28)

```json
{
"access_token": "aab87efa-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
"token_type": "Bearer",
"expires_in": "24"
}
```

#### JSON example 3 (cell C29)

```json
{
"errorCode": "100001",
"errorMsg": "Invalid Request Details"
}
```

#### JSON example 4 (cell C30)

```json
{
"errorCode": "100007",
"errorMsg": "Token validity period is expired"
}
```

#### JSON example 5 (cell B36)

```json
{"errorRespData":{"errorCode":"100007","errorMsg":"Token validity period is expired"}}
```

## Request Header and Response Det

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `Request Header and Response Det`

### Request Header Details

### Table 1

Source cells: `B3:G8`

| JSON Field Name | Description | Data Type | Mandatory  | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |
| entityId | A unique Entity ID, as available in MFU for the Distributor / RIA or such other Entity using this facility. <br>The Entity ID shall be provided by MFU to the Entity while setting up the UAT / Production environments. | Char(6) | Yes |  |  |
| version | Version number for the Web service. For example, 1.00<br>The version number is used to manage future changes to the web services. | Char(5) | Yes |  |  |
| reqTS | The request initatied timestamp in Entity System.<br>The time format is YYYY-MM-DD HH:MM:SS | Date Time | Yes | 2023-04-16 15:20:09 |  |
| apiType | The requested Module Type.<br>NORMAL-TXN : Normal Transaction Service<br>SYS-TXN : Systematic Transaction Service<br>SYS-CANCEL-TXN : Systematic Cancellation Service<br>TXN-AUT-DETH : Transaction Authrization Detail service<br>TXN-APPROVAL : Transaction approval Serivce<br>TXN-HIST : Transaction History API Service<br>CAN-VAL : CAN Validation API Service<br>CAN-FETCH : CAN Fetch Service<br>PRN VAL : PRN Validation Service<br>CAN-BNK-VAL : CAN Bank Validation Service<br>SWP-PAYEEZ : Swap PayEezz Service<br>CAN-FOLIO-VAL : CAN Folio Validation Service<br>INV-CON-ENTRY : Investor Consent Entry Service<br>INV-CON-VIEW : Investor Consent View Service | Char(20) | Yes | Allowed Values :<br>NORMAL-TXN<br>SYS-TXN<br>SYS-CANCEL-TXN <br>TXN-AUT-DETH<br>TXN-APPROVAL<br>TXN-HIST<br>CAN-VAL<br>CAN-FETCH<br>PRN VAL<br>CAN-BNK-VAL<br>SWP-PAYEEZ<br>CAN-FOLIO-VAL<br>INV-CON-ENTRY<br>INV-CON-VIEW |  |
| uniqueId | Request Unique ID created at the Entity’s site and shared with MFU in the request. Request Unique Id should not be duplicated | Char(50) | Yes |  |  |

### Request Body Details

### Table 2

Source cells: `B12:G13`

| JSON Field Name | Description | Data Type | Mandatory | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |
| data | The full request body JSON section data should be encrypted and passed in data json field.<br>The encryption algorithm is AES/CBC/PKCS7Padding. MFU will provide a public key and a IvKey for encryption at the time of integration | Char(Max) | Yes |  |  |

### Sample Request JSON Details

### Table 3

Source cells: `B17:C18`

| Sample Header Structure | [See JSON example 1 below] |
| --- | --- |
| Sample body Structure | [See JSON example 2 below] |

### Response Format Details

### Table 4

Source cells: `B22:G23`

| JSON Field Name | Description | Data Type | Mandatory | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |
| respData | The full response Detail (Error Or Success) JSON section data should be encrypted and passed in respData json field.<br>The encryption algorithm is AES/CBC/PKCS7Padding. MFU will provide a public key and a IvKey for encryption at the time of integration | Char(Max) | Yes |  |  |

### Sample Response

### Table 5

Source cells: `B27:C27`

| Sample Response Structure | [See JSON example 3 below] |
| --- | --- |

### Sample Request Header JSON

### Table 6

Source cells: `B45:C45`

| Sample Header Structure | [See JSON example 4 below] |
| --- | --- |

### JSON examples

#### JSON example 1 (cell C17)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-07 10:20:09","apiType":"FETCH-UTRN","uniqueId":"1000000000"},"reqBody":{}
}
```

#### JSON example 2 (cell C18)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-07 10:20:09","apiType":"FETCH-UTRN","uniqueId":"1000000000"},
"reqBody":{"data":"yXOzCUf6KJtUshOvZi+xQxdto1oQH8vFiqiTCyJBWn6PUq6sT+YfiN7mnpCBr9zAmAwZKuHY4B6SjM7R71UWqABRvI+th0mgA9K+tcCcmntX55RoWh7JKJ0FAS2fhOA9H3WeFPp/z9GxU1VoX1Lq2df6nOLqvhpD3QyMbijkoOlWguDnHcjQBhl8zgxc8htC+BEer7sODEXmxF/Tkqrkar4BrA/tN7l71cS3kzZVBqy2I0WCh+9yjqriXKAccQpGQodg6YILEmJTSwYxd99tJUVrSoT46Y5G7BmfBJgvDNA="}
}
```

#### JSON example 3 (cell C27)

```json
{
"respData":"R+O4by+eamMAqHs8qHjcLtQQLtL5NkZswAAu9YwXKKfdiIDgfaM8QVidcXaD+YjfnbUnqBY96KoaMjlUKg4kXIYCUOJ3l7/tYhLjn8YrpgQ+H/mcidupRc4wfRU1zQ8/JOBYIt5RXS5lkmKGLP"
}
```

#### JSON example 4 (cell C45)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-07 10:20:09","apiType":"FETCH-UTRN","userId":"XXXX","encryptPwd":"XXXXXXXXXXXXXXXXXXXXXXX","uniqueId":"1000000000"},"reqBody":{}
}
```

## eCAN-PAN-VERIFY

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `eCAN-PAN-VERIFY`

### PAN Verify Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFintechPanDataChkService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be eCAN-PAN-VERIFY | Char(20) | Yes | eCAN-PAN-VERIFY | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G12`

| modeOfHld | Mode of Holding | Char(2) | Yes | Allowed Values:<br>SI - Single<br>AS - Anyone of Survivor<br>JO  - Joint | Column G |
| --- | --- | --- | --- | --- | --- |
| resdStatus | Resident status of the Investor | Char(3) | Yes | Refer Master Data Sheet : Tax Master :: refer column tax status for the allowed values |  |
| panNo | First Holder PAN Number<br>If Minor, then Guardian PAN No to be provided | Char(10) | Yes |  |  |
| holder2PanNo | Second Holder PAN Number | Char(10) | Conditional Mandatory |  | If modeOfHld is not Single, Then holder2PanNo is mandatory else should be empty |
| holder3PanNo | Third Holder PAN Number | Char(10) | Conditional Mandatory |  | If modeOfHld is not Single, Then holder3PanNo is mandatory  else should be empty |

### PAN Verify Service API – Response

### Table 4

Source cells: `B16:D16`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B18:D21`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B23:D25`

| panVerifyRefNo | PAN Verfiy Reference Number. This reference number used in CAN registration service API. | Char(20) |
| --- | --- | --- |
| canAvailFlg | CAN available flag.<br>Y –  CAN is already available in MFU system.<br>N – CAN is not available in MFU system. | Char(1) |
| can | Common Account Number (CAN). <br>If canAvailFlg is Y CAN number is available otherwise empty | Char(10) |

### panList (section wise error list array section start)

### Table 7

Source cells: `B27:D33`

| pan | PAN Number | Char(10) |
| --- | --- | --- |
| panValFlg | PAN valid Flag.<br>Y  - Valid PAN with approved KRA Status<br>N - Invalid PAN KRA Status | Char(1) |
| panName | Name of the PAN holder received from KRA | Char(105) |
| panKycSt | PAN KYC Status<br>PE – Pending<br>AP – Approved<br>RJ – Rejected<br>BL – Blacklisted in MFU<br>TM – Timed out<br>NA – Not Applicable | Char(2) |
| mfuKycStatus | PAN MFU KYC Status<br>VAL - Validated KRA<br>VRF - Verified at KRA<br>DRK - Pending-KRA<br>PEN - Pending-MFU<br>RJK - Rejected-KRA<br>HLD - On Hold-KRA<br>RJK - Rejected-KRA<br>NAK - Unknown/Not Available<br>DEL - Deactivated-KRA<br>OKR - OLD KYC RECORD<br>OHK - Pending-Non-MF KYC<br>INC - Registered-Non-MF KYC<br>OKR - On Hold-Non-MF KYC<br>PAK - Rejected-Non-MF KYC<br>INC - Registered-Non-MF KYC<br>UVK - Registered-CVL MF KYC | Char(3) |
| panAppStatus | The PAN APP_STATUS which is received from KRA's<br>This value will be empty for the existing CAN's | Char(10) |
| panAppUpdtStatus | The PAN APP_UPDT_STATUS which is received from KRA's<br>This value will be empty for the existing CAN's | Char(10) |

### panList  (section wise error list array section end)

### Table 8

Source cells: `B35:D35`

| txnEligFlg | CAN Transaction Eligible Flag<br>Y – CAN Transaction is eligible<br>N – CAN Transaction is not eligible | Char(1) |
| --- | --- | --- |

### txnErrLst (section wise error list array section start) if txnEligFlg is N

### Table 9

Source cells: `B37:D37`

| errCode | Transaction Error Code.<br>01 : CAN FATCA Detail is not available.<br>02 : CAN Contact is not verified<br>03 : CAN Nominee is not verified<br>04 : Nomination in the selected CAN is non-compliant with recent regulatory requirements | Char(2) |
| --- | --- | --- |

### txnErrLst (section wise error list array section end)

### respBody Section End

### PAN Verify Service API – Sample Request and Response

### Table 10

Source cells: `B42:C47`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C43)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2026-01-20 10:20:09","apiType": "eCAN-PAN-VERIFY","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C44)

```json
{    
"modeOfHld":"SI",    "resdStatus":"RI",    "panNo":"XXXPX1234Y",    "holder2PanNo":"",    "holder3PanNo":""
}
```

#### JSON example 3 (cell C45)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C46)

```json
{
"respHeader":{"respFlag":"S","respTs":"2026-01-20 10:20:20","errorCode":"","errorMsg":""},"respBody":{"panVerifyRefNo":"1000961689775495R36K","canAvailFlg":"Y","can":"XXXXXXXXXX","panList":[{"pan":"","panValFlg":"Y","panName":"XXXXXXXXXXXXXXXXXXXXXX","panKycSt":" AP","mfuKycStatus":"VAL","panAppStatus":"007","panAppUpdtStatus":"007"}],"txnEligFlg":"N","txnErrLst":[{"errCode":"01"},{"errCode":"02"}]}
}
```

#### JSON example 5 (cell C47)

```json
{
"respHeader":{"respFlag":"F","respTs":"2026-01-20 10:20:20","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"panVerifyRefNo":"","canAvailFlg":"","can":"","panList":[{"pan":"","panValFlg":"","panName":"","panKycSt":"","mfuKycStatus":"","panAppStatus":"","panAppUpdtStatus":""}],"txnEligFlg":"","txnErrLst":[]}
}
```

## CAN-REG

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-REG`

### CAN Registration Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/APIFinTechCANCreateService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-REG | Char(20) | Yes | CAN-REG | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G12`

| reqEvent | Request Event | Char(2) | Yes | Allowed Values:<br>CR-New CAN creation<br>CM – Modification of existing CAN. | Column G |
| --- | --- | --- | --- | --- | --- |
| can | Common Account Number (CAN). | Char(10) | Conditional Mandatory |  | For reqEvent CM : this field is mandatory |
| panVerifyRefNo | PAN verify Reference Number which is recevied from eCAN-PAN-Verify service .  | Char(20) | Conditional Mandatory |  | If the Entity is enabled for Workflow type 3, this field is mandatory. Otherwise empty value should  be passed |
| proofUploadByCan | Whether Proof upload facility to be given to CAN holder. | Char(1) | Yes | Allowed Values:<br>Y-Yes<br>N-No |  |
| onlineAccessFlag | Whether the enable online access flag  facility to be given to CAN Holder | Char(1) | Yes | Allowed Values:<br>Y-Yes<br>N-No |  |

### entEmailList Array List Section Start

### Table 4

Source cells: `B14:E14`

| emailId | Email ID of entity users to which the communication to be sent. | char(100) | No |
| --- | --- | --- | --- |

### entEmailList Array List Section End

### Table 5

Source cells: `B16:F19`

| holdType | Holding Type | Char(2) | Yes | Allowed Values:<br>AS – Anyone of Survivor<br>JO - Joint<br>SI – Single |
| --- | --- | --- | --- | --- |
| invCategory | Investor Category | Char(1) | Yes | Allowed Values:<br>I - Individual<br>M - Minor<br>S - Sole-proprietor  |
| taxStatus | Tax Status | Char(2) | Yes | Refer Master Data Sheet : Tax Master for the allowed values |
| holderCount | Number of Holders<br> | Numeric | Yes |  |

### holderList Array List Section Start

### Table 6

Source cells: `B21:G30`

| holderType | Holder Type | Char(2) | Yes | Allowed Values:<br>PR - Primary<br>SE - Secondary<br>TH -Third<br>GU - Guardian  | Column G |
| --- | --- | --- | --- | --- | --- |
| name | Holder Name | Char(105) | Yes |  |  |
| dob | Holder Date of Birth. The Date format should be YYYY-MM-DD | DATE | Yes |  |  |
| panExemptFlag | Holder PAN Exempt flag | Char(1) | Yes | Allowed Values:<br>Y - PEKRN<br>N - PAN  |  |
| panOrPekrn | Holder PAN or PEKRN number | Char(20) | Yes |  |  |
| relationship | Relation | Char(2) | Conditional Mandatory | Allowed Values:<br>01 - Mother                 <br>02 - Father                 <br>03 - Court Appointed Legal Guardian<br> | For Minor holder Relationship is mandatory |
| relProofType | Proof | Char(2) | Conditional Mandatory | Allowed Values:<br>01 - Birth Certificate<br>02 - Ration Card<br>03 - Passport<br>04 - PAN Card<br>05 - Court Order | For Minor holder Proof is mandatory |
| nomVerifyFlag | Nominee Verification Flag. If the Entity is enabled for auto verify nominee, the Nominee verify flag is mandatory. Otherwise empty value should be passed | Char(1) | Conditional Mandatory |  | If the Entity is enabled for auto verify nominee, the Nominee verify flag is mandatory. Otherwise empty value should be passed |
| nomVerifyIPAddr | Nominee Verify IP. If the Entity is enabled for auto verify nominee, the Nominee verify IP is mandatory. Otherwise empty value should be passed | Char(20) | Conditional Mandatory |  | If the Entity is enabled for auto verify nominee, the Nominee verify IP is mandatory. Otherwise empty value should be passed |
| kycSecType | KYC Section type.<br>ENT :  KYC Section details Provided by entity.  Entity is enabled for workflow type 2.<br>NAK : Unknown KRA. If the entity is enabled for Workflow type 3 and PAN KYC Status is NAK, KYC Address detail section need to provided. | Char(3) | Conditional Mandatory | Allowed Values:<br>ENT - Entity KYC Data.<br>NAK - Unknown KRA.  Address detail<br>NA -  Not Applicable |  |

### kycSec Section Start

### Table 7

Source cells: `B32:F32`

| kycStatus | PAN KRA KYC Status | Char(3) | Conditional Mandatory | Allowed Values:<br>KRG -  KRA Registered<br>VAL  - KRA Validated<br>VRF  - Approved-KRA<br>DRK - Pending KRA<br>UPK - Under Processing at KRA<br>NAK - Unknown/Not Available |
| --- | --- | --- | --- | --- |

### resAddrDetail Section Start

### Table 8

Source cells: `B34:F40`

| addr1 | Residential Address Line 1 | Char(120) | Conditional Mandatory | Column F |
| --- | --- | --- | --- | --- |
| addr2 | Residential Address Line 2 | Char(120) | Conditional Mandatory |  |
| addr3 | Residential Address Line 3 | Char(120) | No |  |
| city | Residential City | Char(30) | Conditional Mandatory |  |
| pinCode | Residential Pin code | Char(6) | Conditional Mandatory |  |
| state | Residential State Code | Char(4) | Conditional Mandatory | Refer Master Data Sheet : State Master for the allowed values |
| country | Residential Country Code | Char(3) | Conditional Mandatory | Refer Master Data Sheet : Country Master for the allowed values |

### resAddrDetail Section End

### perAddrDetail Section Start

### Table 9

Source cells: `B43:F49`

| addr1 | Permanent Address Line 1 | Char(120) | Conditional Mandatory | Column F |
| --- | --- | --- | --- | --- |
| addr2 | Permanent Address Line 2 | Char(120) | Conditional Mandatory |  |
| addr3 | Permanent Address Line 3 | Char(120) | No |  |
| city | Permanent City | Char(30) | Conditional Mandatory |  |
| pinCode | Permanent Pin code | Char(6) | Conditional Mandatory |  |
| state | Permanent State Code | Char(4) | Conditional Mandatory | Refer Master Data Sheet : State Master for the allowed values |
| country | Permanent Country Code | Char(3) | Conditional Mandatory | Refer Master Data Sheet : Country Master for the allowed values |

### perAddrDetail Section End

### contactSec Section Start

### Table 10

Source cells: `B52:F62`

| mobIsd | Mobile ISD Code | Number(5) | No | Column F |
| --- | --- | --- | --- | --- |
| mobNo | Mobile Number | Char(15) | Yes |  |
| mobBelongsTo | Mobile Declaration.  | Char(2) | Yes | Allowed Values:<br>DC-Dependent Children<br>DP-Dependent Parents<br>DS-Dependent Siblings<br>GD-Guardian<br>SE-Self<br>SP-Spouse<br>PM - PMS<br>PO - POA<br>CD – Custodian |
| emailId | Email ID | Char(15) | Yes |  |
| emailBelongsTo | Email Declaration.  | Char(2) | Yes | Allowed Values:<br>DC-Dependent Children<br>DP-Dependent Parents<br>DS-Dependent Siblings<br>GD-Guardian<br>SE-Self<br>SP-Spouse<br>PM - PMS<br>PO - POA<br>CD – Custodian |
| mobVerifyFlag | Mobile verify flag. If the Entity is enabled for contact auto verify, the field is mandatory. Otherwise empty value should be passed | Char(1) | Conditional Mandatory | Allowed Values:<br>Y – Verify |
| emailVerifyFlag | Email verify flag. If the Entity is enabled for contact auto verify, the field is mandatory. Otherwise empty value should be passed | Char(1) | Conditional Mandatory | Allowed Values:<br>Y – Verify |
| mobVerifyIpAddr | Mobile verified IP Address. If the Entity is enabled for contact auto verify, the field is mandatory. Otherwise empty value should be passed | Char(20) | Conditional Mandatory |  |
| emailVerifyIpAddr | Email Verified IP Address. If the Entity is enabled for contact auto verify, the field is mandatory. Otherwise empty value should be passed | Char(20) | Conditional Mandatory |  |
| mobVerifyTs | Mobile verified Timestamp. If the Entity is enabled for contact auto verify, the field is mandatory. Otherwise empty value should be passed.<br>The date time format should be YYYY-MM-DD HH:MM:SS | Date Time | Conditional Mandatory |  |
| emailVerifyTs | Email verified Timestamp. If the Entity is enabled for contact auto verify, the field is mandatory. Otherwise empty value should be passed.<br>The date time format should be YYYY-MM-DD HH:MM:SS | Date Time | Conditional Mandatory |  |

### contactSec Section End

### OtherSec Section Start

### Table 11

Source cells: `B65:G74`

| grossIncome | Gross Annual Income | Char(2) | Yes | Allowed Values:<br>01 - BELOW 1 LAC  <br>02 - 1-5 LAC  <br>03 - 5-10 LAC <br>04 - 10-25 LAC<br>05 - 25 Lacs to 1 Cr  <br>06 - Greater than 1 Cr | Column G |
| --- | --- | --- | --- | --- | --- |
| networth | Net Worth | Number(11) | No |  |  |
| networthDate | Net Worth Date | date | Conditional Mandatory |  | If networth is provided, networth date is mandatory |
| sourceOfWealth | Source of Wealth | Char(2) | No | Allowed Values:<br>01 - Salary<br>02 - Bussiness Income<br>03 - Gift  <br>04 - Ancestral Property   <br>05 - Rental Income   <br>06 - Prize Money<br>07 - Royalty    <br>08 – Others |  |
| sourceOfWealthOth | Source of Wealth Other | Char(50) | Conditional Mandatory |  | If Source of Wealth is 'Others' Source of Wealth Other is required |
| kraAddrType | Type of Address given at KRA | Char(1) | Yes | Allowed Values:<br>1 - Residential or Business<br>2 - Residential<br>3 - Business<br>4 - Registered Office |  |
| occp | Occupation | Char(2) | Yes | Allowed Values:<br>01  - Private Sector Service <br>02  - Public Sector          <br>03  - Business               <br>04  - Professional           <br>05  - Agriculturist          <br>06  - Retired                <br>07  - Housewife              <br>08  - Student                <br>09  - Forex Dealer           <br>10  - Government Service     <br>99  - Others                 <br>11  - Doctor                  |  |
| occpOth | Occupation Other | Char(50) | Conditional Mandatory |  | If Occupation is 'Others' Occupation Other is required |
| pep | PEP Status | Char(4) | Yes | Allowed Values:<br>PEP - Politically Exposed Person <br>RPEP - Related to Politically Exposed Person <br>NA - Not Applicable  |  |
| anyOtherInfo | Any Other Information | Char(100) | Conditional Mandatory |  |  |

### OtherSec Section End

### fatcaSec Section Start

### Table 12

Source cells: `B77:G84`

| birthCity | Place of Birth | Char(60) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| birthCountry | Country of Birth | Char(3) | Yes | Refer Master Data Sheet : Country Master for the allowed values |  |
| birthCountryOth | Country of Birth other | Char(50) | Conditional Mandatory |  | If Country of Birth is 'Others',Country of Birth other is required |
| citizenship | Citizenship | Char(3) | Yes | Refer Master Data Sheet : Country Master for the allowed values |  |
| citizenshipOth | Citizenship Other | Char(50) | Conditional Mandatory |  | If Citizenship is 'Others',Citizenship other is required |
| nationality | Nationality | Char(3) | Yes | Refer Master Data Sheet : Country Master for the allowed values |  |
| nationalityOth | Nationality Other | Char(50) | Conditional Mandatory |  | If Nationality is 'Others',Nationality others required |
| taxResFlag | Are you tax resident of any country other than India. If Tax Resident is “Y” Tax Record Detail is Mandatory. | Char(1) | Yes | Allowed Values:<br>Y - Yes<br>N - No |  |

### taxDetail Section Start

### Table 13

Source cells: `B86:G90`

| taxCountry | Tax Details Country | Char(3) | Conditional Mandatory | Refer Master Data Sheet : Country Master for the allowed values | Conditional Mandatory based on TAX_RES_FLAG |
| --- | --- | --- | --- | --- | --- |
| taxCountryOth | Tax Country Other | Char(50) | Conditional Mandatory |  | Conditional Mandatory based on TAX_RES_FLAG |
| taxRefno | Tax Reference Number | Char(20) | Conditional Mandatory |  | Conditional Mandatory based on TAX_RES_FLAG |
| identiType | Identification Type | Char(1) | Conditional Mandatory | Allowed Values:<br>F - Dependent Visa<br>K - Diplomat Visa<br>N - Global Entity Identification Number<br>D - ID Card<br>M - Mariner/Sea farer<br>I - Social Security ID Card<br>S - Sportsperson/Professional<br>J - Student Visa<br>T - TIN<br>Q - US GIIN | Conditional Mandatory based on TAX_RES_FLAG |
| identiTypeOth | Identification Type Other | Char(50) | Conditional Mandatory |  | Conditional Mandatory based on TAX_RES_FLAG |

### taxDetailSection End

### fatcaSec Section End

### holderList Array List Section End

### arnSec Section Start

### Table 14

Source cells: `B95:E97`

| arnNo | ARN Code | Char(15) | No |
| --- | --- | --- | --- |
| riaCode | RIA Code | Char(12) | No |
| euinCode | EUIN Code | Char(20) | No |

### arnSec Section End

### consentList Array List Section Start

### Table 15

Source cells: `B100:G101`

| dataSet | Consent Data Set | Char(2) | Conditional Mandatory | Allowed Values:<br>CD - CAN Data Set<br>PD - PayEezz Data<br>MF - Mapped Folio <br>HD - Holding Data | If Either ARN or RIA code is attached in request, consent Detail array is mandatory.<br>CONSENT_DETAILS array all the 4 Data set should be there enabled or disabled for data set |
| --- | --- | --- | --- | --- | --- |
| consentFlag | Consent Data Set Enabled Flag | Char(1) | Conditional Mandatory | Allowed Values:<br>Y - Consent is enabled for the given Data set<br>N - Consent is not enabled |  |

### consentList Array List Section End

### dpSec Section Start

### Table 16

Source cells: `B104:G111`

| nsdlDpId | NSDL DP ID | Char(8) | No | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| nsdlClientId | NSDL Client ID | Char(8) | Conditional Mandatory |  | If nsdlDpId is provided, nsdlClientId is mandatory |
| nsdlProofId | NSDL Proof document ID | Char(2) | Conditional Mandatory | Allowed Values:<br>34 - Statement of Accounts<br>79 - Client Master Report | If nsdlDpId is provided, nsdlProofId is mandatory |
| nsdlVerifyFlag | NSDL Verify Flag | Char(1) | Conditional Mandatory | Allowed Values:<br>Y –Yes<br>N - No |  |
| cdslDpId | CDSL DP ID | Char(8) | No |  |  |
| cdslClientId | CDSL Client ID | Char(8) | Conditional Mandatory |  | If cdslDpId is provided, cdslClientId is mandatory |
| cdslProofId | CDSL Proof document ID | Char(2) | Conditional Mandatory | Allowed Values:<br>34 - Statement of Accounts<br>79 - Client Master Report | If cdslDpId is provided, cdslProofId is mandatory |
| cdslVerifyFlag | CDSL Verify Flag | Char(1) | Conditional Mandatory | Allowed Values:<br>Y –Yes<br>N - No |  |

### dpSec Section End

### bnkList Array List Section Start

### Table 17

Source cells: `B114:G125`

| defaultAccFlag | Default Account Flag | Char(1) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| accNo | Account Number | Char(20) | Yes |  |  |
| accType | Account Type | Char(4) | Yes | Refer Master Data Sheet : Tax Master for the allowed values |  |
| bankId | Bank Id | Char(4) | Yes |  |  |
| ifsc | IFSC Code | Char(11) | Yes |  |  |
| micr | MICR Code | Char(9) | Yes |  |  |
| proof | Bank Proof | Char(2) | Yes | Allowed Values:<br>14 - Latest Bank Passbook <br>15 - Latest Bank Account Statement <br>77 - Cheque Copy<br>78 - Bank Letter<br> |  |
| rupVerifyFlag | Rupee Drop Verify Flag. Future Purpose. Always empty value should be passed. | Char(1) | Conditional Mandatory |  |  |
| rupBenName | Rupee Drop Beneficiary name. | Char(105) | Conditional Mandatory |  | Rupee Drop Beneficiary name. If the Entity is enabled for Rupee Drop, the field is mandatory. Otherwise empty value should be passed. |
| rupThresHold | Name Matching threshold value. If the Entity is enabled for Rupee Drop, the field is mandatory. Otherwise empty value should be passed | Numeric(3,2) | Conditional Mandatory |  |  |
| rupIpAddr | Rupee Drop IP Address. If the Entity is enabled for Rupee Drop, the field is mandatory. Otherwise empty value should be passed | Char(20) | Conditional Mandatory |  |  |
| rupTs | Rupee Drop Verified Timestamp. The date time format should be YYYY-MM-DD HH:MM:SS | Date Time | Conditional Mandatory |  | If the Entity is enabled for Rupee Drop, the field is mandatory. Otherwise empty value should be passed |

### bnkList Array List Section End

### nomSec Section Start

### Table 18

Source cells: `B128:F130`

| nomDecl | Nominee Declaration Level flag | Char(1) | Conditional Mandatory | Allowed Values:<br>C - CAN Level |
| --- | --- | --- | --- | --- |
| nomOptFlag | Nominee Opt Flag.  | Char(1) | Yes | Allowed Values:<br>Y - Checked<br>N - Not Checked |
| nomFolioSoa | Nominee Folio SOA  | Char(1) | Conditional Mandatory | Allowed Values:<br>Y - Yes<br>N - No |

### nomList Array List Section Start (Conditional Mandatory Based on NOMIN_OPT_FLAG is Y, Then this section is mandtory )

### Table 19

Source cells: `B132:G148`

| nomName | Nominee Name | Char(105) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| relation | Nominee Relation | Char(5) | Yes | Allowed values are:<br>MFU01	- FATHER<br>MFU02	- MOTHER<br>MFU03	- COURT APPOINTED LEGAL GUARDIAN<br>MFU04	- AUNT<br>MFU05	-  BROTHER-IN-LAW<br>MFU06	- BROTHER<br>MFU07	- DAUGHTER<br>MFU08	- DAUGHTER-IN-LAW<br>MFU09	- FATHER-IN-LAW<br>MFU10	- GRAND DAUGHTER<br>MFU11	- GRAND FATHER<br>MFU12	- GRAND MOTHER<br>MFU13	- GRAND SON<br>MFU14	- MOTHER-IN-LAW<br>MFU15	- NEPHEW<br>MFU16	- NIECE<br>MFU17	- SISTER<br>MFU18	- SISTER-IN-LAW<br>MFU19	- SON<br>MFU20	- SON-IN-LAW<br>MFU21	- SPOUSE<br>MFU22	- UNCLE<br>MFU23	- OTHERS |  |
| percentage | Nominee Percentage | Char(3) | Yes |  |  |
| dob | Nominee Date of birth. The Date format should be YYYY-MM-DD | Date | No |  |  |
| gurdName | Nominee Guardian Name | Char(105) | No |  |  |
| gurdRel | Nominee Guardian Relation | Char(5) | No | Allowed values are:<br>MFU24	- FATHER<br>MFU25	- MOTHER<br>MFU26	- COURT APPOINTED LEGAL GUARDIAN |  |
| gurdDOB | Nominee Guardian Date of birth. The Date format should be YYYY-MM-DD | Date | No |  |  |
| piType | Personal Identifier Type | Char(2) | Yes | Allowed values are:<br>PA - PAN<br>AD - Aadhaar<br>DL - Driving License<br>PS - Passport |  |
| piNo | Personal Identifier Number | Char(30) | Yes |  | Based on piType need to pass the piNo<br>if PAN - PAN format validation <br>if Driving License - Free Text. Max 30 Char (Including Special Characters)<br>if Aadhaar - Only 4 Numeric Char.<br>if Passport - Free Text. Max 30 Char (Including Special Characters) |
| mobile | Nominee Mobile | Char(10) | Yes |  |  |
| email | Nominee Email | Char(100) | Yes |  |  |
| addr1 | Nominee Address Line1 | Char(40) | Yes |  |  |
| addr2 | Nominee Address Line2 | Char(40) | No |  |  |
| addr3 | Nominee Address Line3 | Char(40) | No |  |  |
| pinCode | Nominee PinCode | Char(10) | Yes |  |  |
| city | Nominee City | Char(30) | Yes |  |  |
| country | Nominee Country | Char(3) | Yes | Refer Master Data Sheet : Country Master for the allowed values |  |

### nomList Array List Section End

### nomSec Section End

### CAN Registration Service API – Response

### Table 20

Source cells: `B154:D154`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 21

Source cells: `B156:D159`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 22

Source cells: `B161:D165`

| can | Common Account Number (CAN). | Char(10) |
| --- | --- | --- |
| proofUploadLink | Proof Upload Link | Char(150) |
| nomVerifyLinkH1 | Nominee Verfiy Link Holder 1 | Char(150) |
| nomVerifyLinkH2 | Nominee Verfiy Link Holder 2 | Char(150) |
| nomVerifyLinkH3 | Nominee Verfiy Link Holder 3 | Char(150) |

### respBody Section End

### CAN Registration Service API – Sample Request and Response

### Table 23

Source cells: `B169:C174`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C170)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "CAN-REG","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C171)

```json
{
"reqEvent":"CR","can":"XXXXXXXXXX","panVerifyRefNo":"XXXXXXXXXX","proofUploadByCan":"","onlineAccessFlag":"N","entEmailList":[{"emailId":""}],"holdType":"SI","invCategory":"I","taxStatus":"RI","holderCount":"0","holderList":[{"holderType":"","name":"","dob":"","panExemptFlag":"","panOrPekrn":"","relationship":"","relProofType":"","nomVerifyFlag":"","nomVerifyIPAddr":"","kycSecType":"","kycSec":{"kycStatus":"","resAddrDetail":{"addr1":"","addr2":"","addr3":"","city":"","pinCode":"","state":"","country":""},"perAddrDetail":{"addr1":"","addr2":"","addr3":"","city":"","pinCode":"","state":"","country":""}},"contactSec":{"mobIsd":"","mobNo":"1234567890","mobBelongsTo":"SE","emailId":"XXXXX@gmail.com","emailBelongsTo":"SE","mobVerifyFlag":"N","emailVerifyFlag":"N","mobVerifyIpAddr":"","emailVerifyIpAddr":"","mobVerifyTs":"","emailVerifyTs":""},"OtherSec":{"grossIncome":"","networth":"","networthDate":"","sourceOfWealth":"","sourceOfWealthOth":"","kraAddrType":"","occp":"","occpOth":"","pep":"","anyOtherInfo":""},"fatcaSec":{"birthCity":"","birthCountry":"","birthCountryOth":"","citizenship":"","citizenshipOth":"","nationality":"","nationalityOth":"","taxResFlag":"","taxDetail":{"taxCountry":"","taxCountryOth":"","taxRefno":"","identiType":"","identiTypeOth":""}}}],"arnSec":{"arnNo":"","riaCode":"","euinCode":""},"consentList":[{"dataSet":"","consentFlag":""}],"dpSec":{"nsdlDpId":"","nsdlClientId":"","nsdlProofId":"","nsdlVerifyFlag":"","cdslDpId":"","cdslClientId":"","cdslProofId":"","cdslVerifyFlag":""},"bnkList":[{"defaultAccFlag":"","accNo":"","accType":"","bankId":"","ifsc":"","micr":"","proof":"","rupVerifyFlag":"","rupBenName":"","rupThresHold":"","rupIpAddr":"","rupTs":""}],"nomSec":{"nomDecl":"","nomOptFlag":"","nomFolioSoa":"","nomList":[{"nomName":"","relation":"","percentage":"","dob":"","gurdName":"","gurdRel":"","gurdDOB":"","piType":"","piNo":"","mobile":"","email":"","addr1":"","addr2":"","addr3":"","pinCode":"","city":"","country":""}]}
}
```

#### JSON example 3 (cell C172)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C173)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"can":"XXXXXXXXX","proofUploadLink ":"XXXXXXXXXXXXXXXXXXXXXXXXX","nomVerifyLinkH1":"","nomVerifyLinkH2":"","nomVerifyLinkH3":""}
}
```

#### JSON example 5 (cell C174)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"can":"","proofUploadLink ":"","nomVerifyLinkH1":"","nomVerifyLinkH2":"","nomVerifyLinkH3":""}
}
```

## CAN-STATUS

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-STATUS`

### CAN Data Status Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFintechCanStatusService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-STATUS | Char(20) | Yes | CAN-STATUS | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:E8`

| can | Common Account Number (CAN). | Char(10) | Yes |
| --- | --- | --- | --- |

### CAN Data Status Service  API – Response

### Table 4

Source cells: `B12:D12`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B14:D17`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B19:D22`

| can | Common Account Number (CAN). | Char(10) |
| --- | --- | --- |
| proofUploadLink | Proof Upload Link | Char(150) |
| msg | Response message | Char(100) |
| canStatus | CAN Status | Char(2) |

### blockRespList (section wise error list array section start)

### Table 7

Source cells: `B24:D27`

| blockName | Block Name | Char(50) |
| --- | --- | --- |
| blockSubName | Block Sub Name | Char(50) |
| seqNo | Sequence Number | Numeric |
| respType | Response Type | Char(150) |

### blockRespList (section wise error list array section end)

### respBody Section End

### CAN Data Status Service  API – Sample Request and Response

### Table 8

Source cells: `B32:C37`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C33)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "CAN-STATUS","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C34)

```json
{
"can":"XXXXXXXXXX"
}
```

#### JSON example 3 (cell C35)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C36)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"can":"XXXXXXXXXXX","proofUploadLink ":"","msg":"Data submitted suuceesfully","canStatus":"PE","blockRespList":[{"blockName":"","blockSubName":"","seqNo":"","respType":"","respCode":""}]}
}
```

#### JSON example 5 (cell C37)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"can":"","proofUploadLink ":"","msg":"","canStatus":"","blockRespList":[{"blockName":"","blockSubName":"","seqNo":"","respType":"","respCode":""}]}
}
```

## CAN-PROOF-IMG

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-PROOF-IMG`

### CAN Image Proof Upload Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechCanProofImageService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-PROOF-IMG | Char(20) | Yes | CAN-PROOF-IMG | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G12`

| can | Common Account Number (CAN). | Char(10) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| event | Event Type of the Image | Char(2) | Yes | Allowed values are:<br>  AD - Upload New Proof Image for the CAN<br>  UP - Update Existing Proof Image for the CAN<br>  DE - Delete the existing Proof Image for the CAN |  |
| imgRefNo | Image Reference Number | Char(10) | Conditional Mandatory |  | This field is mandatory for Update and Delete event only. For Add event it should be empty.<br>In Case of Update, Old Image will not be available in MFU System. |
| proofType | Proof Type.<br>Module Related information to indicate the type of proof being uploaded.  | Char(5) | Yes | <br><br>Refer Master Data Sheet : eCAN Image Proof Type :: refer column code for the allowed values |  |
| imgData | Image byte array Data. The byte array should be converted in  Base64 encoded format. | Text | Yes |  | The size of the image data should not be greater than  500KB.<br>Only jpg, jpeg,png formats are allowed |

### CAN Image Proof Upload API – Response

### Table 4

Source cells: `B16:D16`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B18:D21`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B23:D24`

| imgRefNo | Image Reference Number | Char(10) |
| --- | --- | --- |
| msg | Response message | Char(100) |

### respBody Section End

### CAN Image Proof Upload API – Sample Request and Response

### Table 7

Source cells: `B28:C32`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Success Response withOut Encryption | [See JSON example 3 below] |
| Failure Response withOut Encryption  | [See JSON example 4 below] |

### JSON examples

#### JSON example 1 (cell C29)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "CAN-PROOF-IMG","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C30)

```json
{
"can":"XXXXXXXXXX","event":"AD","imgRefNo":"","proofType":"4#FA","imgData":"SUkqAEpNAgBKTjd1eWJucltwdF2Chm98gGmDh3COknuDh3CEiHGEiHGFiXKGinOHi3SHi3SIjHWJjHmLkHyPk4KNloOIlYGAknx2jHdwiXOAmYR+m4WAnYeBoYqEpI+Hp5KLqJSMqZWDopCDopCDopCEo5GEo5OEo5OFpJSFpJSBoJGCoZKDopOEo5SFo5eGpJiHpZmHp5yAn5qFpaJ2lpN5mZZ9nZp3l5SLq6iFpaKFpaKCop+d9k4d+kod+kod+MAAAo/C9QAAAAAQNxqgAAAAAAIrhwoAAAAgAA=="
}
```

#### JSON example 3 (cell C31)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"imgRefNo":"XXXXXXXXXXXX","msg":"Data submited successfully"}
}
```

#### JSON example 4 (cell C32)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"imgRefNo":"","msg":""}
}
```

## eNACH-REG

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `eNACH-REG`

### eNach Registration Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/MfuePayEezzRegService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be eNACH-REG | Char(20) | Yes | eNACH-REG | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:F21`

| mandateType | Mandate Creation Type.  | Char(1) | Yes | By Default T should be passed |
| --- | --- | --- | --- | --- |
| regMode | Payment Aggregator Options.   | Char(2) | Yes | Allowed values<br>PN - Payment Net-banking Mode<br>PD -  Payment Debit Card Mode |
| can | Common Account Number (CAN). | Char(10) | Yes |  |
| arnCode | ARN Code of the Broker who intiates the transaction | Char(12) | No |  |
| riaCode | Registered Investment Advisor Code | Char(12) | No |  |
| euin | EUIN Code | Char(20) | No |  |
| accNo | CAN Bank Account Number | Char(20) | Yes |  |
| accType | CAN Bank Account Type | Char(4) | Yes | Allowed values<br>SB- Savings<br>CA – Current |
| ifscCode | CAN Bank Account IFSC Number | Char(4) | Yes |  |
| micrCode | CAN Bank Account  MICR Number | Char(9) | Yes |  |
| maxAmt | Maximum Amount for mandate Registration | Numeric(12,2) | Yes |  |
| perpetualFlag | Perpetual Flag | Char(1) | Yes | Allowed values<br>Y -Yes<br>N – No |
| startDate | Registration start date. The Date format should be YYYY-MM-DD | Date | Yes |  |
| endDate | Registration end date. The Date format should be YYYY-MM-DD | Date | Yes |  |

### eNach Registration API – Response

### Table 4

Source cells: `B25:D25`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B27:D30`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B32:D33`

| mmrn | MFU Mandate Reference Number (Reference Number generated by MFU for the Mandate Request).  | Char(20) |
| --- | --- | --- |
| approveLink | Link for approving the Mandate request. This link will either be shared in response to entity system or may be directly sent to the concerned investor depending configuration. In case the system is configured to send the link to investor, this field will be empty in response | Char(500) |

### respBody Section End

### eNach Registration API – Sample Request and Response

### Table 7

Source cells: `B37:C41`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Success Response withOut Encryption | [See JSON example 3 below] |
| Failure Response withOut Encryption  | [See JSON example 4 below] |

### JSON examples

#### JSON example 1 (cell C38)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "eNACH-REG","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C39)

```json
{
"mandateType":"T","regMode" : "PN","can":"","arnCode" : "","riaCode" : "INA987654321","euin":"","accNo":"","accType":"","ifscCode":"","micrCode":"","maxAmt":"","perpetualFlag":"","startDate":"","endDate":""
} 
```

#### JSON example 3 (cell C40)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"mmrn":"15253198911272F080CC ","approveLink":"http://14.141.212.169:7002/callEPayeezzConfirm.do?param1=XXXXXXXXXXXXXXXX&param2=NBBC9&param3=A "}
}
```

#### JSON example 4 (cell C41)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid RIA code"},"respBody":{"mmrn":"","approveLink":""}
}
```

## eNACH-STATUS

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `eNACH-STATUS`

### eNach Registration Status check Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/MfuePayEezzStatusService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be eNACH_STATUS | Char(20) | Yes | eNACH_STATUS | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:F10`

| mandateType | Mandate Creation Type. | Char(1) | Yes | By Default T should be passed |
| --- | --- | --- | --- | --- |
| can | Common Account Number (CAN). | Char(10) | Yes |  |
| mmrn | MMRN | Char(20) | Yes |  |

### eNach Registration Status check Service API – Response

### Table 4

Source cells: `B14:D14`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B16:D19`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B21:D23`

| prn | PRN number | Char(20) |
| --- | --- | --- |
| mfuRegStatus | MMRN (Mandate) Registration Status as available in MFU.Value will be two character code like RQ / CL / PA - accordingly it should be handled<br>RQ	- Pending       <br>PA	- Approved   <br>PR	- Rejected      <br>CL	- Cancelled | Char(2) |
| aggrStatus | Mandate Status as provided by the Payment Aggregator<br>PE - Pending                         <br>AC - Aggregator Accepted<br>RA  - Aggregator Rejected<br>CL - Cancelled                      <br>MX - Mandate Expired      <br>RV - Mandate Revoked     <br>PS - Mandate Paused         | Char(2) |

### respBody Section End

### eNach Registration Status check Service API – Sample Request and Response

### Table 7

Source cells: `B27:C31`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Success Response withOut Encryption | [See JSON example 3 below] |
| Failure Response withOut Encryption  | [See JSON example 4 below] |

### JSON examples

#### JSON example 1 (cell C28)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "eNACH_STATUS","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C29)

```json
{
"mandateType":"T","can":"XXXXXXXXXX","mmrn":"XXXXXXXXXXXXXXXXXXXX"
}
```

#### JSON example 3 (cell C30)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"prn":"XXXXXXXXXXXXXX","regStatus":"RQ","aggrStatus":"PE"}
}
```

#### JSON example 4 (cell C31)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"prn":"","mfuRegStatus":"","aggrStatus":""}]}
}
```

## eNACH-PUSH

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `eNACH-PUSH`

### eNach Push Service API

### Table 1

Source cells: `B3:E3`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

This is a Mandate callback push service. MFU will iniaite the request to send the data to entity. The entity need to share the Push URL for recevied this transaction response.

For this service, oAuth is mandatory. Entity need to provide the oAuth URL. The oAuth request and repsonse format should be in MFU oAuth Format. For oAuth refer sheet Authorization with OAuth 2.0

### respHeader Section – without encryption JSON Field Details

### Table 2

Source cells: `B7:D10`

| versionNo | Char(5) | Version number for the Web service. The version number is 1.00 |
| --- | --- | --- |
| reqTS | Date Time | The request initatied timestamp in Entity System.<br>The time format is YYYY-MM-DD HH:MM:SS |
| apiType | Char(20) | The API Type should be eNACH-PUSH |
| uniqueId | Char(50) | Unique ID created at the MFU system and shared in the request. Unique Id should not be duplicated |

### respHeader Section End

### respBody Section – without encryption JSON Field Details

### mandateLst Array List Section Start

### Table 3

Source cells: `B14:D21`

| mandateType | Char(25) | Mandate Creation Type.  |
| --- | --- | --- |
| can | Char(10) | The Common Account Number as allotted by MFU system. |
| canName | Char(105) | Investor Name |
| mmrn | Char(20) | MFU Mandate Reference Number |
| prn | Char(20) | PayEezz Reference Number |
| mfuStatus | Char(50) | MMRN (Mandate - PayEezz) Registration Status as available in MFU. |
| aggrStatus | Char(50) | Mandate (PayEezz) Status as provided by the Payment Aggregator |
| remarks | Char(500) | Remarks |

### mandateLst Array List Section End

### respBody Section End

### eNach Push Service Service Sample Response

### Table 4

Source cells: `B27:C29`

| Sample Type | Sample |
| --- | --- |
| Response with Encryption | [See JSON example 1 below] |
| Response withOut Encryption | [See JSON example 2 below] |

### JSON examples

#### JSON example 1 (cell C28)

```json
{"respData":"3Dlv69kqFld9U_p3MLLpL3dfov-pF46nBAm3qGH6W-FC1iIOEbMHreRMts8NvfBuSzSR6RwDAd2LX7lnKQkZIKDZr1Td3RsFJbMbG04LMSZ9ykVNEmFKyobsSnALxJFlb6-Igo1LWu973hNzSUsQ-Mlordx6Y5fJqOsaO2n-t8F37Z7tpIF2sGf0sp6hyIpvmq1AVLTn4ERfbLvy-D6-v4tDdWfHHwqGOzwVIghiiyTeEc3oxT1XxhMytV2qUJxgrbJ-5xzpJjqdMrL51NtlN5V0YqGC8QLC1w0rt1o599OAmHhnbLnKhiOvhoPby_xHy2IE71Kp5_bIll6GzT9WSnL5en1844aHrNQxQtb6Ufm6v95u7aya1sQQL-72N_gxIgvsOpJIzOcexlLX0BVJ-vxjq1dYAxFU0GJjU_tw5VCsJPtS1takm9iS9ex7MMLQBwtJZXYl52exghbNlgNaLNnEFahvhMhdvzR0H7Tp2xROnKH0UE01NJLnwfXK-R64cs8FqIigMF8Qb1vHHA5tAMrwIcwJDRvC0-di1mI2PkuianlY4W-2Un7S39eEdsaInshBMlZUXJxmIaqV4DeEv159yKIYpH282QZsEifDV4xJ4RBkXB-Bet_VNwrSLfJ1jfliIGPVIAKOT8zdAFivWAKOaQa86PGu4yBLa4QqlGbRJOep-9khNC9JZ-EJ5hAF3GAvxvFGK-Q3TjaYdTNB8ktm97UihSJA1bbn_0XLdh1dfsHey_qpcRcQimL4biZiBAl2oPkOeQepHqiyE9nQdNE3rOhTMjaN-2HMrD6mRzyHfZ4swtVvbKkJvbeKYyCYP5ESKFFRGNrHe5sVM-m-wi_MqfKvP1HMi4YSD9bV560R469mUQI838It8LswhUgA"}
```

#### JSON example 2 (cell C29)

```json
{"respHeader":{"respFlag": "S","respCode": "0","respMsg": "Success"},"respBody":"mandateLst": [{"mandateType":"T","can": "","canName": "","mmrn": "","prn":"","mfuStatus":"","aggrStatus":"","remarks":""}]]}}
```

## MAND-CREATION-API

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `MAND-CREATION-API`

### UPI Auto Pay Mandate Creation API – Request

### URL to Invoke this API : https://<UAT or PROD URL>/MfuUpiAutoPayRegService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The API Type should be UPI-AUTOPAY | Char(20) | Yes | UPI-AUTOPAY | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section – without encryption JSON Field Details

### Table 3

Source cells: `B8:G20`

| mandateType | Mandate Creation Type. | Char(1) | Yes | By Default T should be passed | Column G |
| --- | --- | --- | --- | --- | --- |
| can | Investor CAN for placing the registration request | Char(10) | Yes |  |  |
| arnCode | ARN Code of the Broker who intiates the transaction | Char(12) | No |  |  |
| riaCode | Registered Investment Advisor Code | Char(12) | No |  |  |
| euin | EUIN Code | Char(20) | No |  |  |
| accNo | CAN Bank Account Number | Char(20) | Yes |  |  |
| accType | CAN Bank Account Type | Char(4) | Yes | Allowed values:<br>SB - Savings<br>CA – Current |  |
| ifscCode | CAN Bank Account IFSC Number | Char(11) | Yes |  |  |
| micrCode | CAN Bank Account MICR Number | Char(9) | Yes |  |  |
| maxAmt | Maximum Amount for mandate Registration | Numeric(12,2) | Yes | should not exceed 100000 |  |
| endDate | Registration end date. The Date format should be YYYY-MM-DD | Date | Yes | should be lesser than 30 years from startDate |  |
| deviceType | The type of device used to initiate the request to generate the intent link or qr image for registration | Char(1) | Yes | Allowed values:<br>B - Browser<br>A – Android<br>I - IOS |  |
| linkType | The specific UPI application link type to be used for IOS device | Char(2) | Conditional Mandatory | Allowed values:<br>GP - Gpay<br>PE - PhonePe<br>PT - Paytm<br>CD - Cred<br>BH - BHIM | This field is Mandatory only if deviceType is passed as I (iOS) |

### UPI Auto Pay Mandate Creation API– Response

### Table 4

Source cells: `B24:D24`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respData Section – without encryption JSON Field Details

### Table 5

Source cells: `B26:D32`

| respFlag | Response Flag.<br>The Possiable values are <br>S – Success<br>F – Failure | Char(1) |
| --- | --- | --- |
| respCode | Response Code.<br>If respFlag is S , the respCode is Zero<br>If respFlag is F, the respCode contains the Error code | Char(10) |
| respMsg | For Success, the respMsg have success Message.<br>For Failure case, the respMsg have the error message for the request | Char(500) |
| mumrn | MFU Mandate Reference Number (Reference Number generated by MFU for the Mandate Request). | Char(20) |
| approveLink | Link for approving the Mandate request. This link will either be shared in response to entity system or may be directly sent to the concerned investor depending configuration. In case the system is configured to send the link to investor, this field will be empty in response | Char(500) |
| deepLink | UPI Intent Flow Deep Link URL if this is a intent workflow otherwise empty value will be passed<br>This field is available only if workflowType is 'I'. | Char(1000) |
| qrCode | UPI QR Code base64  to display the payment QR code to the investor. | Char(5000) |

### UPI Auto Pay Mandate Creation API– Sample Request and Response

### Table 6

Source cells: `B35:C42`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Success Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Success Response For workflowType I | [See JSON example 5 below] |
| Failure Response with Encryption | [See JSON example 6 below] |
| Failure Response withOut Encryption | [See JSON example 7 below] |

### JSON examples

#### JSON example 1 (cell C36)

```json
{
"reqHeader": {"entityId":"420002","apiType" : "UPI-AUTOPAY","version": "1.00","reqTS": "2021-08-24 10:20:09","uniqueId" : "REQ2687654212802" }, 
"reqBody": {"data": "yXOzCUf6KJtUshOvZi+xQxdto1oQH8vFiqiTCyJBWn6PUq6sT+YfiN7mnpCBr9zAmAwZKuHY4B6SjM7R71UWqABRvI+th0mgA9K+tcCcmntX55RoWh7JKJ0FAS2fhOA9H3WeFPp/z9GxU1VoX1Lq2df6nOLqvhpD3QyMbijkoOlWguDnHcjQBhl8zgxc8htC+BEer7sODEXmxF/Tkqrkar4BrA/tN7l71cS3kzZVBqy2I0WCh+9yjqriXKAccQpGQodg6YILEmJTSwYxd99tJUVrSoT46Y5G7BmfBJgvDNA=" }
}
```

#### JSON example 2 (cell C37)

```json
{
"mandateType":"T","can":"","arnCode" : "","riaCode" : "INA987654321","euin":"","accNo":"","accType":"","ifscCode":"","micrCode":"","maxAmt":"","endDate":"","deviceType":"","linkType":""
}
```

#### JSON example 3 (cell C38)

```json
{
"respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C39)

```json
{ "respFlag": "S","respCode": "0","respMsg": "","mumrn":"15253198911272F080CC ","approveLink":"http://14.141.212.169:7002/callUpiAutoPayConfirm.do?param1=1563443398216CD91FA9&param2=NBBC9&param3=A","deepLink":"","qrCode":"" }
```

#### JSON example 5 (cell C40)

```json
{"respFlag":"S","respCode":0,"respMsg":"Success","mumrn":"14176AYA012635104929000431EFB","approveLink":"","deepLink":"upi://mandate?pa=cpayupiap@icici&pn=CAMSPay&tr=EZM2026020410493009778950&am=1.00&cu=INR&orgid=400011&mc=6211&purpose=14&tn=Mandate%20Creation&validitystart=04022026&validityend=28022026&amrule=MAX&recur=ASPRESENTED&rev=Y&share=Y&block=N&txnType=CREATE&mode=04&sign=MEQCIFkOu/WBxGZ/MFDdLhjhe7XO+w4wxjQaEhPBaC+gxcLOAiBNpj5Ct4NIidHV11s39Gj29pdEapw7zB/SpMOIOAa9wA==" ,"qrCode":"iVBORw0KGgoAAAANSUhEUgAAB0QAAAdECAYAAADUj7i/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAP+lSURBVHhe7NnBqi1LsizZ9/8/XdXIrkyIjSpn6TWXAdJWx2LulQnn//1/kiRJkiRJkiRJknSU/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW"}
```

#### JSON example 6 (cell C41)

```json
{
"respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 7 (cell C42)

```json
{
"respFlag": "F","respCode": "10058","respMsg": "Invalid RIA code","mumrn":"","approveLink":"","deepLink":"","qrCode":""
}
```

## MAND-CREATION-STATUS-API

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `MAND-CREATION-STATUS-API`

### UPI Auto Pay Mandate Creation Status API – Request

### URL to Invoke this API : https://<UAT or PROD URL>/MfuUpiAutoPayStatusService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The API Type should be UPIAUTPY-STATUS | Char(20) | Yes | UPIAUTPY-STATUS | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section – without encryption JSON Field Details

### Table 3

Source cells: `B8:F10`

| mandateType | Mandate Creation Type. | Char(1) | Yes | By Default T should be passed |
| --- | --- | --- | --- | --- |
| can | Investor Common Account Number | Char(10) | Yes |  |
| mumrn | MFU Mandate Reference Number | Char(20) | Yes |  |

### UPI Auto Pay Mandate Creation Status API – Response

### Table 4

Source cells: `B14:D14`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respData Section – without encryption JSON Field Details

### Table 5

Source cells: `B16:D21`

| respFlag | Response Flag.<br>The Possiable values are <br>S – Success<br>F – Failure | Char(1) |
| --- | --- | --- |
| respCode | Response Code.<br>If respFlag is S , the respCode is Zero<br>If respFlag is F, the respCode contains the Error code | Char(10) |
| respMsg | For Success, the respMsg have success Message.<br>For Failure case, the respMsg have the error message for the request | Char(500) |
| aumrn | ​Aggregator Mandate Reference Number. This reference number is used to place the transaction using UPI Auto Pay. | Char(20) |
| regStatus | MMRN (Mandate - UPI AutoPay) Registration Status as available in MFU.Value will be two character code like RQ / CL / PA - accordingly it should be handled<br>RQ        : Pending<br>PA        :  Approved<br>PR        :  Rejected<br>CL        : Cancelled | Char(2) |
| aggrStatus | Mandate (UPI AutoPay) Status as provided by the Payment Aggregator<br>PE        :  Pending<br>AC        :  Aggregator Accepted<br>RA        :  Aggregator Rejected<br>RV        :  Mandate Revoked<br>PS        :  Mandate Paused | Char(2) |

### UPI Auto Pay Mandate Creation Status API – Sample Request and Response

### Table 6

Source cells: `B25:C31`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Success Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response with Encryption | [See JSON example 5 below] |
| Failure Response withOut Encryption | [See JSON example 6 below] |

### JSON examples

#### JSON example 1 (cell C26)

```json
{
"reqHeader": {"entityId":"420002","apiType" : "UPIAUTPY-STATUS","version": "1.00","reqTS": "2021-08-24 10:20:09","uniqueId" : "REQ2687654212802" }, 
"reqBody": {"data": "yXOzCUf6KJtUshOvZi+xQxdto1oQH8vFiqiTCyJBWn6PUq6sT+YfiN7mnpCBr9zAmAwZKuHY4B6SjM7R71UWqABRvI+th0mgA9K+tcCcmntX55RoWh7JKJ0FAS2fhOA9H3WeFPp/z9GxU1VoX1Lq2df6nOLqvhpD3QyMbijkoOlWguDnHcjQBhl8zgxc8htC+BEer7sODEXmxF/Tkqrkar4BrA/tN7l71cS3kzZVBqy2I0WCh+9yjqriXKAccQpGQodg6YILEmJTSwYxd99tJUVrSoT46Y5G7BmfBJgvDNA=" }
}
```

#### JSON example 2 (cell C27)

```json
{
"mandateType":"T","can":"XXXXXXXXX","mumrn":"XXXXXXXXXXXXXXXXXXXX"
}
```

#### JSON example 3 (cell C28)

```json
{
"respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C29)

```json
{
"respFlag": "S","respCode": "0","respMsg": "","aumrn":"XXXXXXXXXXXXXXXXXXXX","regStatus":"RQ","aggrStatus":"PE"
}
```

#### JSON example 5 (cell C30)

```json
{
"respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 6 (cell C31)

```json
{
"respFlag": "F","respCode": "10058","respMsg": "Invalid CAN","aumrn":"","regStatus":"","aggrStatus":""
}
```

## MAND-CALLBK-PUSH

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `MAND-CALLBK-PUSH`

### Mandate Callback Push Service API

### Table 1

Source cells: `B3:E3`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

This is a Mandate callback push service. MFU will iniaite the request to send the data to entity. The entity need to share the Push URL for recevied this transaction response.

For this service, oAuth is mandatory. Entity need to provide the oAuth URL. The oAuth request and repsonse format should be in MFU oAuth Format. For oAuth refer sheet Authorization with OAuth 2.0

### respHeader Section – without encryption JSON Field Details

### Table 2

Source cells: `B7:D8`

| versionNo | Char(5) | Version number for the Web service. The version number is 1.00 |
| --- | --- | --- |
| rptDateTime | Date Time | Mandate Callback Push send time stamp. Timestamp format is YYYY-MM-DD HH:MM:SS |

### respHeader Section End

### respBody Section – without encryption JSON Field Details

### mandCallbkList Array List Section Start

### Table 3

Source cells: `B12:D17`

| can | Char(10) | The Common Account Number as allotted by MFU system. |
| --- | --- | --- |
| mumrn | Char(20) | MFU Mandate Reference Number (Reference Number generated by MFU for the Mandate Request). |
| regStatus | Char(2) | Mandate - UPI AutoPay Registration Status as available in MFU.<br>Allowed values:<br>RQ:Pending<br>CL:Cancelled<br>PA:Confirmed<br>PR:Rejected |
| aggrStatus | Char(2) | Mandate (UPI AutoPay) Status as provided by the Payment Aggregator<br>Allowed values:<br>PE        :  Pending<br>AC        :  Aggregator Accepted<br>RA        :  Aggregator Rejected<br>RV        :  Mandate Revoked<br>PS        :  Mandate Paused<br>PR        : Rejected<br>PA        : Approved |
| aumrn | Char(20) | ​Aggregator Mandate Reference Number. This reference number is used to place the transaction using UPI Auto Pay. |
| eventTs | Date Time | Timestamp of the event<br>The date time format is YYYY-MM-DD HH:MM:SS |

### mandCallbkList Array List Section End

### respBody Section End

### Mandate Callback Push Service Sample Response

### Table 4

Source cells: `B23:C25`

| Sample Type | Sample |
| --- | --- |
| Response with Encryption | [See JSON example 1 below] |
| Response withOut Encryption | [See JSON example 2 below] |

### JSON examples

#### JSON example 1 (cell C24)

```json
{"respData":"3Dlv69kqFld9U_p3MLLpL3dfov-pF46nBAm3qGH6W-FC1iIOEbMHreRMts8NvfBuSzSR6RwDAd2LX7lnKQkZIKDZr1Td3RsFJbMbG04LMSZ9ykVNEmFKyobsSnALxJFlb6-Igo1LWu973hNzSUsQ-Mlordx6Y5fJqOsaO2n-t8F37Z7tpIF2sGf0sp6hyIpvmq1AVLTn4ERfbLvy-D6-v4tDdWfHHwqGOzwVIghiiyTeEc3oxT1XxhMytV2qUJxgrbJ-5xzpJjqdMrL51NtlN5V0YqGC8QLC1w0rt1o599OAmHhnbLnKhiOvhoPby_xHy2IE71Kp5_bIll6GzT9WSnL5en1844aHrNQxQtb6Ufm6v95u7aya1sQQL-72N_gxIgvsOpJIzOcexlLX0BVJ-vxjq1dYAxFU0GJjU_tw5VCsJPtS1takm9iS9ex7MMLQBwtJZXYl52exghbNlgNaLNnEFahvhMhdvzR0H7Tp2xROnKH0UE01NJLnwfXK-R64cs8FqIigMF8Qb1vHHA5tAMrwIcwJDRvC0-di1mI2PkuianlY4W-2Un7S39eEdsaInshBMlZUXJxmIaqV4DeEv159yKIYpH282QZsEifDV4xJ4RBkXB-Bet_VNwrSLfJ1jfliIGPVIAKOT8zdAFivWAKOaQa86PGu4yBLa4QqlGbRJOep-9khNC9JZ-EJ5hAF3GAvxvFGK-Q3TjaYdTNB8ktm97UihSJA1bbn_0XLdh1dfsHey_qpcRcQimL4biZiBAl2oPkOeQepHqiyE9nQdNE3rOhTMjaN-2HMrD6mRzyHfZ4swtVvbKkJvbeKYyCYP5ESKFFRGNrHe5sVM-m-wi_MqfKvP1HMi4YSD9bV560R469mUQI838It8LswhUgA"}
```

#### JSON example 2 (cell C25)

```json
{"respHeader":{"versionNo":"1.00","rptDateTime":"2025-11-11 10:30:29"},"respBody":{"mandCallbkList":[{"can":"XXXXXXXX","mumrn":"XXXXXXXXXXX","regStatus":"RQ","aggrStatus":"PE","aumrn":"","eventTs":"2025-01-31 21:07:48"}]}}
```

## NORMAL-TXN

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `NORMAL-TXN`

### Normal Transaction Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechNormalTxnService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be NORMAL-TXN | Char(20) | Yes | NORMAL-TXN | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G12`

| txnType | Transaction Type | Char(1) | Yes | Allowed Values:<br>B – Purchase<br>R - Redeem<br>S - Switch<br>U - Invest-Cum-Switch<br>Z - Switch from Existing Folio | Column G |
| --- | --- | --- | --- | --- | --- |
| entGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes |  |  |
| orderMode | Transaction Order Mode | Char(1) | Yes | Allowed Values:<br>Z – API TransactEezz |  |
| entityRemarks | Entity Remarks | Char(1000) | No |  |  |
| folioTxnFlag | Folio based Transaction Flag | Char(1) | Yes | Allowed Values:<br>Y – Folio Based <br>N - CAN Based | if(txnType = “U” \|\| txnType = “Z”), then the value should be N<br> |

### folioDetSec Section Start

### Table 4

Source cells: `B14:G19`

| holdNat | Holding Nature of the Investor | Char(2) | No | Allowed Values:<br>AS – Anyone of Survivor<br>JO - Joint<br>SI – Single | Column G |
| --- | --- | --- | --- | --- | --- |
| taxStatus | Tax Status of the Investor holder | Char(3) | No | Refer Master Data Sheet : Tax Status for the allowed values |  |
| priPanOrPekrn | PAN or PEKRN of the Primary Holder | Char(10) | No |  |  |
| secPanOrPekrn | PAN or PEKRN of the Second Holder in case of Joint Holding | Char(10) | Conditional Mandatory |  | The value is required only if folioTxnFlag is Y and holdNat is AS or JO |
| thrPanOrPekrn | PAN or PEKRN of the Third Holder in case of Joint Holding | Char(10) | Conditional Mandatory |  | The value is required only if folioTxnFlag is Y and holdNat is AS or JO |
| gurPanOrPekrn | PAN or PEKRN of the Guardian in case of Investor being a Minor  | Char(10) | Conditional Mandatory |  | The value is required only if folioTxnFlag is Y and Minor folio |

### folioDetSec Section End

### Table 5

Source cells: `B21:G32`

| can | Common Account Number (CAN). | Char(10) | Conditional Mandatory | Column F | The value is required only if folioTxnFlag is N. <br>Else the value should be empty. |
| --- | --- | --- | --- | --- | --- |
| canType | Can Holder Type | Char(1) | Conditional Mandatory | Allowed Values:<br>I – Individual<br>N - Non Individual | The value is required only if folioTxnFlag is N. Otherwise the value should be empyt.<br><br>For Non Individual Can, canType should be 'N' For Individual Can,canType should be 'I'  |
| txnEvent | To indicate whether  the transactions to be auto approved  or to follow approval cycle as per order approval matrix.  <br>Allowed Values <br>Q - Normal (Approval Cycle - Recommended option)<br>B - Direct Approval (Auto Approval) - For marking as auto approval, the entity may need to agree to special terms with MFU.  | Char(1)<br> | Conditional Mandatory | Allowed Values:<br>Q - Normal, where the transaction orders will need to be approved by the Approvers as per the defined Transaction Order Approval Matrix before routing to RTAs<br>B - Direct Approval, where the transaction order is marked as approved directly. | if (orderMode == "Z" and canType == "N"), value is required. else empty |
| reqPrntEnt | Parent Entity ID for audit | Char(6) | No |  |  |
| riaCode | RIA Code | Char(12) | Conditional Mandatory |  | For RIA Entity , the RIA Code is mandatory |
| arnCode | ARN Code | Char(15) | Conditional Mandatory |  | For DIST Entity , the ARN Code is mandatory |
| subArnCode | Sub Broker ARN Code of the Main Broker. | Char(15) | No |  |  |
| euin | EUIN code | Char(20) | Conditional Mandatory |  | Mandatory For DIST Entity,  if euinDeclaration is N then euin code to be given<br>if euinDeclaration is Y then euin code to be empty<br>For RIA Entity it should be empty |
| euinDeclaration | EUIN declaration flag. | Char(1) | Conditional Mandatory | Allowed Values:<br>Y - Yes<br>N - No | Mandatory For DIST Entity, euinDeclaration should be either Y or N<br>For RIA Entity it should be empty |
| subBrokCode | Sub Broker Code of the Main Broker if the sub broker code is not starts with ARN | Char(15) | No |  |  |
| branchRMIntCode | Branch RM Internal code | Char(15) | No |  |  |
| totAmt | Total amount for Purchase transactions | Numeric(11,2) | Conditional Mandatory |  | if(txnType = “B”)  value is required <br>else empty |

### schList Array List Section Start

### Table 6

Source cells: `B34:G43`

| entUnqItrn | This code shall be given by the entity, MFU will map this unique reference to the corresponding scheme level transaction and the same will be returned to the Entities in the Transaction Feed Response. | Char(50) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| mfuUtrn | MFU Unique Transaction Reference number at ITRN level. This number is already shared with entity via Fetch UTRN service.  The same number should be provided for Transaction. | Number(15) | No |  |  |
| rtaAmcCode | RTA AMC Code | Char(6) | Yes |  |  |
| rtaSchCode | RTA Scheme Code | Char(6) | Yes |  |  |
| outRtaSchCode | RTA Out Scheme Code for Switch transactions | Char(6) | Conditional Mandatory |  | if(txnType = “S” \|\| txnType = “U” \|\| txnType = “Z”) value is required<br>else empty |
| folio | Folio Number | Char(21) | Yes |  | NEW folio or existing CAN mapping folio |
| divOpt | Scheme Dividend Option | Char(1) | Conditional Mandatory | Allowed Values:<br>N - Not-Applicable<br>P - Payout<br>R – Re-Invest | if(txnType =”B” \|\| txnType = “S” \|\| txnType = “U” \|\| txnType = “Z”) value is required<br>else empty |
| txnVolTyp | Transaction Volume Type | Char(1) | Yes | Allowed Values:<br>E - All Units<br>A - Amount<br>U – Units | if(txnType = "B") the txnVolType should be A<br>else any allowed values will be required |
| vol | Transaction Volume | Numeric(14,3) | Conditional Mandatory |  | Yes ( if the txnVolumeType = 'A' \|\| txnVolumeType == 'U') else left blank |
| payOutFlag | Pay out section flag | Char(1) | Conditional Mandatory | Allowed Values:<br>Y –  PayOut Bank Details<br>N – Default CAN Bank Account | if(txnType =”R”) value is required<br>else empty |

### payOutDtl (payout detail section start)

### Table 7

Source cells: `B45:G47`

| invAccNo | Investor Bank Account number | Char(20) | Conditional Mandatory | Column F | if(payOutFlag =”Y”)  value is required <br>else empty. |
| --- | --- | --- | --- | --- | --- |
| micr | Bank MICR | Char(9) | Conditional Mandatory |  | if(payOutFlag =”Y”)  value is required <br>else empty. |
| ifsc | Bank IFSC Code | Char(11) | Conditional Mandatory |  | if(payOutFlag =”Y”)  value is required <br>else empty. |

### payOutDtl (payout detail section end)

### Table 8

Source cells: `B49:G49`

| schPayFlag | Y - For Direct transfer to AMC account, The scheme level Payment section is mandatory.<br>N – for payment made to MFU escrow account<br> | Char(1)<br> | Conditional Mandatory | Allowed Values:<br>Y - for Non Individual Transaction as only Direct to AMC payment is supported<br>N – for payment made to MFU account | If the ordermode = "Z" and  canType = "N" and txnType = "B" and  paySecFlag ='Y' schPayFlag is mandatory, else should be empty.<br><br>if  paySecFlag ='Y' and directTranToAmcFlag= Y then, schPayFlag should be Y else, N |
| --- | --- | --- | --- | --- | --- |

### schPaySec (schPay detail section start)

### Table 9

Source cells: `B51:G61`

| payType | For Direct transfer to AMC payment , the Transaction Payment Type is mandatory | Char(2) | Conditional Mandatory | Allowed Values: <br>NE - NEFT<br>RT - RTGS<br>TL - Transfer | if(orderMode = "Z" and canType = "N" and  txnType = "B" and schPayFlag == "Y"), madatory else, should be empty |
| --- | --- | --- | --- | --- | --- |
| payRefNo | Payment Reference  Number | Char(30) | Conditional Mandatory |  | if(orderMode = "Z" and canType = "N" and  txnType = "B" and schPayFlag == "Y"), madatory else, should be empty |
| payDate | Payment Date in format of YYYY-MM-DD<br> | Date | Conditional Mandatory |  | if(orderMode = "Z" and canType = "N" and  txnType = "B" and schPayFlag == "Y"), madatory else, should be empty |
| srcMicrNo | Source Bank Account MICR NO <br> | Char(9) | Conditional Mandatory |  | if(orderMode = "Z" and canType = "N" and  txnType = "B" and schPayFlag == "Y"), madatory else, should be empty |
| srcIfscNo | Source Bank Account IFSC NO | Char(11) | Conditional Mandatory |  | if(orderMode = "Z" and canType = "N" and  txnType = "B" and schPayFlag == "Y"), madatory else, should be empty |
| srcInvAccType | Source Bank Account Type | Char(4) | Conditional Mandatory | Refer Master Data Sheet : Account Type for the allowed values | if(orderMode = "Z" and canType = "N" and  txnType = "B" and schPayFlag == "Y"), madatory else, should be empty |
| srcInvAccNo | Source Bank Account Number<br> | Char(20)<br> | Conditional Mandatory |  | if(orderMode = "Z" and canType = "N" and  txnType = "B" and schPayFlag == "Y"), madatory else, should be empty |
| targetMicrNo | Target Payment Bank ( AMC Bank ) MICR No | Char(9) | Conditional Mandatory |  | if(orderMode = "Z" and canType = "N" and  txnType = "B" and schPayFlag == "Y"), madatory else, should be empty |
| targetIfscNo | Target Payment Bank ( AMC Bank ) IFSC | Char(11) | Conditional Mandatory |  | if(orderMode = "Z" and canType = "N" and  txnType = "B" and schPayFlag == "Y"), madatory else, should be empty |
| targetInvAccType | Target Payment Bank ( AMC Bank ) Account Type | Char(4) | Conditional Mandatory | Refer Master Data Sheet : Account Type for the allowed values | if(orderMode = "Z" and canType = "N" and  txnType = "B" and schPayFlag == "Y"), madatory else, should be empty |
| targetInvAccNo | Target Payment Bank ( AMC Bank ) Account Number | Char(20) | Conditional Mandatory |  | if(orderMode = "Z" and canType = "N" and  txnType = "B" and schPayFlag == "Y"), madatory else, should be empty |

### schPaySec (schPay detail section end)

### Table 10

Source cells: `B63:G66`

| priOtpFlag | Primary OTP Flag<br> | Char(1) | Conditional Mandatory | Allowed Values: <br>B – Both<br>M – Mobile<br>E – Email | If the Entity is enabled for transaction 2FA, the field is mandatory. Otherwise empty value should be passed.<br>if canType is 'N' value should be empty |
| --- | --- | --- | --- | --- | --- |
| priMob | Mobile number.<br> | Char(10) | Conditional Mandatory |  | if(priOtpFlag  = 'B' or priOtpFlag  = 'M') value is required. else empty<br>if canType is 'N' value should be empty |
| priEmail | Email ID<br> | Char(50) | Conditional Mandatory |  | if(priOtpFlag  = 'B' or priOtpFlag  = 'E') value is required. else empty<br>if canType is 'N' value should be empty |
| isSpclProductFlag | Payment Section Flag | Char(1) | Conditional Mandatory | Allowed values:<br>Y – Special Product Section<br>N -No | if(txnType= "U" \|\| "Z") And canType = "I"  value should be Y. <br>else N |

### spclProductDtls(Special Product detail section start)

### Table 11

Source cells: `B68:F69`

| smartSwitchVolType | Transaction Volume Type | Char(1) | Yes | Allowed Values:<br>E - All Units<br>A - Amount<br>U – Units |
| --- | --- | --- | --- | --- |
| smartSwitchVol | Transaction Volume | Numeric(14,3) | Conditional Mandatory |  |

### spclProductDtls(Special Product detail section end)

### schList Array List Section end

### Table 12

Source cells: `B72:G72`

| dpSecFlag | Depository Account Details  Section Flag | Char(1) | Conditional Mandatory | Allowed values:<br>Y – DP Section<br>N -No | if(txnType =”B” \|\| txnType = “S”) value is required <br>else empty |
| --- | --- | --- | --- | --- | --- |

### dpSec (depository detail section start)

### Table 13

Source cells: `B74:G75`

| dpType | Depository Type | Char(4) | Conditional Mandatory | Allowed values:<br>NSDL<br>CDSL | if(dpSecFlag = “Y”) value is required <br>else empty |
| --- | --- | --- | --- | --- | --- |
| dpAccNo | Depository Account number | Char(16) | Conditional Mandatory |  | if(dpSecFlag = “Y”) value is required <br>else empty |

### dpSec (depository detail section end)

### Table 14

Source cells: `B77:G77`

| paySecFlag | Payment Section Flag | Char(1) | Conditional Mandatory | Allowed values:<br>Y – Payment Section<br>N -No | if(txnType= “B”  \|\| txnType = “U”)  value is required. <br>else empty |
| --- | --- | --- | --- | --- | --- |

### paySec (payment section start)

### Table 15

Source cells: `B79:G91`

| directTranToAmcFlag | Direct transfer to AMC payment Flag for Non Individual | Char(1) | Conditional Mandatory | Allowed values:<br>Y – Yes<br>N -No | if ( orderMode = "Z" and canType == "N" and paySecFlg == "Y" and txnType == 'B'  \|\| txnType = “U”), mandatory , else should be empty |
| --- | --- | --- | --- | --- | --- |
| payMode | Payment Mode | Char(2) | Conditional Mandatory | Allowed values:<br>OT – Net Banking<br>NE - NEFT<br>RT - RTGS<br>DM – PayEezz<br>UP – UPI<br>IU - Instsa UPI | if (paySecFlag = “Y” && orderMode = "Z") <br>             all payment modes are allowed<br>else empty.<br>For canType 'N' and orderMode 'Z'<br>Only NE,RT and DM are allowed.<br>if directTranToAmcFlag is 'Y', the value should be empty |
| micr | Bank MICR | Char(9) | Conditional Mandatory |  | if(paySecFlag = “Y”) value is required <br>else empty<br>if directTranToAmcFlag is 'Y', the value should be empty |
| ifsc | Bank IFSC Code | Char(11) | Conditional Mandatory |  | if(paySecFlag = “Y”) value is required <br>else empty.<br>if directTranToAmcFlag is 'Y', the value should be empty |
| accType | Investor Bank Account Type | Char(4) | Conditional Mandatory | Refer Master Data Sheet : Account Type for the allowed values | if(paySecFlag = “Y”) value is required <br>else empty.<br>if directTranToAmcFlag is 'Y', the value should be empty |
| accNo | Investor Bank Account number | Char(20) | Conditional Mandatory |  | if(paySecFlag = “Y”) value is required <br>else empty.<br>if directTranToAmcFlag is 'Y', the value should be empty |
| payDate | Payment Instrument Date. The Date format should be in YYYY-MM-DD | Date | Conditional Mandatory |  | if(paySecFlag = “Y”) value is required <br>else empty |
| payAmt | Payment Amount | Numeric(11,2) | Conditional Mandatory |  | if(paySecFlag = “Y”) value is required <br>else empty |
| beneVan | Beneficiary A/C No | Char(30) | Conditional Mandatory |  | if(paySecFlag = “Y” && payMode = "NE" \|\| payMode = "RT") value is required <br>else empty<br>if directTranToAmcFlag is 'Y', the value should be empty |
| paymentBankRefNo | Entity Payment Bank Transaction Reference number | Char(35) | Conditional Mandatory |  | if directTranToAmcFlag is 'Y', the value should be empty |
| mandateRefNo | Entity Mandate Reference number | Char(35) | Conditional Mandatory |  | if(paySecFlag = “Y”  && payMode = "DM") value is required <br>else empty<br>if directTranToAmcFlag is 'Y', the value should be empty |
| paymentConfirmTs | Entity system Payment confirmed time stamp | Date Time | Conditional Mandatory |  | if directTranToAmcFlag is 'Y', the value should be empty |
| amcPaymentTs | Amount Credited to AMC account time stamp | Date Time | Conditional Mandatory |  | if directTranToAmcFlag is 'Y', the value should be empty |

### paySec (payment section end)

### logDtl (Customer Devicce Details Section Start)

### Table 16

Source cells: `B94:F95`

| deviceType | Device Type | Char(1) | Yes | Allowed values:<br>M - Mobile<br>W - Web |
| --- | --- | --- | --- | --- |
| custIpAddress | Customer Loged In IP Address | Char(20) | Yes |  |

### logDtl (Customer Devicce Details Section End)

### Normal Transaction Service API – Response

### Table 17

Source cells: `B100:D100`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 18

Source cells: `B102:D105`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 19

Source cells: `B107:D107`

| ordCreatedFlag | In MFU system Order Created is generated or not.<br>Possible Values:<br>Y - Order is created<br>N - Order is not created | Char(1) |
| --- | --- | --- |

### secWisErrorList (section wise error list array section start)

### Table 20

Source cells: `B109:D111`

| secName | Error Section Name | Char(50) |
| --- | --- | --- |
| secErrorCode | Error Code  | Char(10) |
| secErrorMsg | Error Message | Char(250) |

### secWisErrorList (section wise error list array section end)

### ordDtl (order detail section start)

### Table 21

Source cells: `B114:D125`

| entGroupRefNo | Entity Unique Group Reference number | Char(50) |
| --- | --- | --- |
| mfuGorn | MFU GORN | Char(16) |
| corn | The unique reference number will be generated in the MFU system for the given SCHD Entry Request.<br>For Success case , the CORN will be populated.<br>For Failure case , It should be empty | Char(20) |
| orderstatus | Current Order status in MFU System for the generated GORN.<br>Refer Master Data Sheet : Gorn Level Order Status for the possible values | Char(2) |
| virtualAccNo | Virtual Account number for CAN | Char(30) |
| virtAccIfsc | Virtual Account number IFSC code | Char(11) |
| appLinkPri | Primary Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| appLinkH1 | Secondary Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| appLinkH2 | Third Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| appLinkPOA | POA Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| paymentLink | Net Banking / UPI payment Link for API TransactEezz.<br>If upiIntentLink is provided this field should be empty | Char(150) |
| upiIntentLink | UPI Payment Intent Link is applicable only under the following conditions:<br><br> - The entity must be enabled for the Transaction 2FA Flag with MFU.<br> - The entity must be enabled for the UPI Intent Link Flag with MFU.<br>- In the request, the deviceType must be M (Mobile) and payMode must be UP (UPI)<br><br>Otherwise, an empty value will be passed. | Char(200) |

### itrnWiseStatus (ITRN Wise Status ArrayList start)

### Table 22

Source cells: `B127:D131`

| entUnqItrn | Entity Unique ITRN Reference number | Char(50) |
| --- | --- | --- |
| mfuItrn | MFU ITRN | Char(18) |
| itrnOrdStatus | ITRN Level Order Status. <br>Refer Master Data Sheet : ITRN Level Order Status for the possible values | Char(2) |
| errorCode | If ITRN level order status is rejected, this field containts the value for the order rejected error code | Char(10) |
| errorMsg | If error code containts the values, this field have the error message for the error code | Char(250) |

### itrnWiseStatus (ITRN Wise Status ArrayList end)

### ordDtl (order detail section end)

### Normal Transaction Service API – Sample Request and Response

### Table 23

Source cells: `B137:C151`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Individual Purchase Transaction - Request body without Encryption | [See JSON example 2 below] |
| Individual Redeem Transaction - Request body without Encryption | [See JSON example 3 below] |
| Individual Switch Transaction - Request body without Encryption | [See JSON example 4 below] |
| Individual Invest cum Switch Transaction - Request body without Encryption | [See JSON example 5 below] |
| Individual Switch from Existing Folio Transaction - Request body without Encryption | [See JSON example 6 below] |
| Non Individual Purchase Transaction With orderMode 'Z' - Request body without Encryption | [See JSON example 7 below] |
| Non Individual Purchase Transaction Direct AMC Order - Request body without Encryption | [See JSON example 8 below] |
| Non Individual Redeem Transaction - Request body without Encryption | [See JSON example 9 below] |
| Non Individual Switch Transaction - Request body without Encryption | [See JSON example 10 below] |
| Response with Encryption | [See JSON example 11 below] |
| Success Response withOut Encryption | [See JSON example 12 below] |
| section wise erorr list - Failure Response withOut Encryption | [See JSON example 13 below] |
| ITRN Level Error - Failure Response withOut Encryption | [See JSON example 14 below] |

### JSON examples

#### JSON example 1 (cell C138)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "NORMAL-TXN","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C139)

```json
{"txnType":"B","entGroupRefNo":"PPP1003","orderMode":"Z","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","canType":"I","txnEvent":"","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"5000","schList":[{"entUnqItrn":"01","mfuUtrn":"","rtaAmcCode":"B","rtaSchCode":"292G","outRtaSchCode":"","folio":"NEW","divOpt":"N","txnVolTyp":"A","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"schPayFlag":"","schPaySec":{"payType":"","payRefNo":"","payDate":"","srcMicrNo":"","srcIfscNo":"","srcInvAccType":"","srcInvAccNo":"","targetMicrNo":"","targetIfscNo":"","targetInvAccType":"","targetInvAccNo":""},"priOtpFlag":"","priMob":"","priEmail":""}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"Y","paySec":{"directTranToAmcFlag":"","payMode":"NE","micr":"110211006","ifsc":"UTIB0000040","accType":"SB","accNo":"XXXXX","payDate":"2025-12-15","payAmt":"5000","beneVan":"MFUYES30170AJ001","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"14.141.212.169"}}
```

#### JSON example 3 (cell C140)

```json
{"txnType":"R","entGroupRefNo":"20240627001","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"10000","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"AXF","rtaSchCode":"CMGPG","outRtaSchCode":"","folio":"KARLGOIN","divOpt":"","txnVolTyp":"E","vol":"5000","payOutFlag":"Y","payOutDtl":{"invAccNo":"20141113","micr":"XXXXXXXX","ifsc":"XXXXXXXXXXX"},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

#### JSON example 4 (cell C141)

```json
{"txnType":"S","entGroupRefNo":"20240626001","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXX","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"AXF","rtaSchCode":"BDDPD","outRtaSchCode":"CMGPG","folio":"KARLGOIN","divOpt":"P","txnVolTyp":"E","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"directTranToAmcFlag":"","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

#### JSON example 5 (cell C142)

```json
{"txnType":"U","entGroupRefNo":"20240626001","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXX","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"AXF","rtaSchCode":"BDDPD","outRtaSchCode":"CMGPG","folio":"KARLGOIN","divOpt":"P","txnVolTyp":"E","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"Y","spclProductDtls":{"smartSwitchVolType":"E","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"directTranToAmcFlag":"","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

#### JSON example 6 (cell C143)

```json
{"txnType":"Z","entGroupRefNo":"20240626001","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXX","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"AXF","rtaSchCode":"BDDPD","outRtaSchCode":"CMGPG","folio":"KARLGOIN","divOpt":"P","txnVolTyp":"E","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"Y","spclProductDtls":{"smartSwitchVolType":"E","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"directTranToAmcFlag":"","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

#### JSON example 7 (cell C144)

```json
{"txnType":"B","entGroupRefNo":"E2024022700469","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","canType":"N","txnEvent":"Q","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"5000","schList":[{"entUnqItrn":"01","mfuUtrn":"","rtaAmcCode":"B","rtaSchCode":"BW015","outRtaSchCode":"","folio":"NEW","divOpt":"R","txnVolTyp":"A","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"schPayFlag":"N","schPaySec":{"payType":"","payRefNo":"","payDate":"","srcBnkId":"229","srcMicrNo":"","srcIfscNo":"","srcInvAccType":"","srcInvAccNo":"","targetBnkId":"240","targetMicrNo":"","targetIfscNo":"","targetInvAccType":"","targetInvAccNo":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"Y","paySec":{"directTranToAmcFlag":"N","payMode":"NE","micr":"123456789","ifsc":"XXXXXXXXXX","accType":"SB","accNo":"11021981","payDate":"2024-10-18","payAmt":"5000","beneVan":"MFSYESXXXXXXXXXX","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

#### JSON example 8 (cell C145)

```json
{"txnType":"B","entGroupRefNo":"E20240627004","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","canType":"N","txnEvent":"Q","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"5000","schList":[{"entUnqItrn":"01","mfuUtrn":"","rtaAmcCode":"B","rtaSchCode":"BW015","outRtaSchCode":"","folio":"NEW","divOpt":"R","txnVolTyp":"A","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"schPayFlag":"Y","schPaySec":{"payType":"NE","payRefNo":"1234","payDate":"2024-10-18","srcBnkId":"229","srcMicrNo":"11112332","srcIfscNo":"XXXXXXXXXXX","srcInvAccType":"SB","srcInvAccNo":"9876543210","targetBnkId":"240","targetMicrNo":"403240020","targetIfscNo":"XXXXXXXXXXX","targetInvAccType":"SB","targetInvAccNo":"123344444"},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"Y","paySec":{"directTranToAmcFlag":"Y","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"2024-10-18","payAmt":"5000","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

#### JSON example 9 (cell C146)

```json
{"txnType":"R","entGroupRefNo":"20240626001","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","canType":"N","txnEvent":"B","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"10000","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"AXF","rtaSchCode":"BDDPR","outRtaSchCode":"","folio":"manicorp/01","divOpt":"","txnVolTyp":"E","vol":"5000","payOutFlag":"Y","payOutDtl":{"invAccNo":"11021982","micr":"XXXXXXX","ifsc":"XXXXXXXXXXX"},"schPayFlag":"","schPaySec":{"payType":"","payRefNo":"","payDate":"","srcMicrNo":"","srcIfscNo":"","srcInvAccType":"","srcInvAccNo":"","targetMicrNo":"","targetIfscNo":"","targetInvAccType":"","targetInvAccNo":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"directTranToAmcFlag":"","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

#### JSON example 10 (cell C147)

```json
{"txnType":"S","entGroupRefNo":"06260014","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","canType":"N","txnEvent":"Q","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"FTI","rtaSchCode":"405","outRtaSchCode":"046","folio":"CIMB009","divOpt":"R","txnVolTyp":"E","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"schPayFlag":"N","schPaySec":{"payType":"","payRefNo":"","payDate":"","srcMicrNo":"","srcIfscNo":"","srcInvAccType":"","srcInvAccNo":"","targetMicrNo":"","targetIfscNo":"","targetInvAccType":"","targetInvAccNo":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"directTranToAmcFlag":"","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

#### JSON example 11 (cell C148)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 12 (cell C149)

```json
{"respHeader":{"respTs":"2023-04-15 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"Y","secWisErrorList":[{"secName":"","secErrorCode":"","secErrorMsg":""}],"ordDtl":{"entGroupRefNo":"ENTGORN12345","mfuGorn":"XXXXXXXXXX000001","corn":"","orderstatus":"OA","virtualAccNo":"","virtAccIfsc":"","appLinkPri":"","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":"","itrnWiseStatus":[{"entUnqItrn":"ENTITRN00001","mfuItrn":"XXXXXXXXXX00000101","itrnOrdStatus":"OA","errorCode":"","errorMsg":""}]}}}                
```

#### JSON example 13 (cell C150)

```json
{"respHeader":{"respTs":"2023-04-15 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"N","secWisErrorList":[{"secName":"canSection","secErrorCode":"20000","secErrorMsg":"Invalid CAN"},{"secName":"paymentSection","secErrorCode":"20001","secErrorMsg":"Invalid Payment"}],"ordDtl":{"entGroupRefNo":"","mfuGorn":"","corn":"","orderstatus":"","virtualAccNo":"","virtAccIfsc":"","appLinkPri":"","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":"","itrnWiseStatus":[]}}}                
```

#### JSON example 14 (cell C151)

```json
{"respHeader":{"respTs":"2023-04-15 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"Y","secWisErrorList":[{"secName":"","secErrorCode":"","secErrorMsg":""}],"ordDtl":{"entGroupRefNo":"ENTGORN12345","mfuGorn":"XXXXXXXXXX000001","corn":"","orderstatus":"OA","virtualAccNo":"","virtAccIfsc":"","appLinkPri":"","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":"","itrnWiseStatus":[{"entUnqItrn":"ENTITRN00001","mfuItrn":"XXXXXXXXXX00000101","itrnOrdStatus":"SS","errorCode":"89090","errorMsg":"Scheme Threashold not matched with order"}]}}}	
```

## SYS-TXN

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `SYS-TXN`

### Systematic Transaction Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechSystematicTxnService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be SYS-TXN | Char(20) | Yes | SYS-TXN | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G22`

| txnType | Transaction Type | Char(1) | Yes | Allowed Values:<br>V – SIP<br>J - SWP<br>E - STP | Column G |
| --- | --- | --- | --- | --- | --- |
| entGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes |  | Values should be Alphabets,Numeric or Alphanumeric |
| orderMode | Transaction Order Mode | Char(1) | Yes | Allowed Values:<br>Z – API TransactEezz | The value should be always Z.  |
| entityRemarks | Entity Remarks | Char(1000) | No |  |  |
| can | Common Account Number (CAN). | Char(10) | Yes |  |  |
| canType | Can Type | Char(3) | Yes | Allowed Values:<br>I – Individual<br>N - Non Individual | For Non Individual Can, canType should be 'N' For Individual Can,canType should be 'I'  |
| reqPrntEnt | Parent Entity ID for audit | Char(6) | No |  | The value can be empty |
| riaCode | RIA Code | Char(12) | Conditional Mandatory |  | For RIA Entity , the RIA Code is mandatory |
| arnCode | ARN Code | Char(15) | Conditional Mandatory |  | For DIST Entity , the ARN Code is mandatory |
| subArnCode | Sub Broker ARN Code | Char(15) | No |  |  |
| euin | EUIN code | Char(20) | Conditional Mandatory |  | Mandatory For DIST Entity,  if euinDeclaration is N then euin code to be given<br>if euinDeclaration is Y then euin code to be empty<br>For RIA Entity it should be empty |
| euinDeclaration | EUIN declaration flag. | Char(1) | Conditional Mandatory | Allowed Values:<br>Y - Yes<br>N - No | Mandatory For DIST Entity, euinDeclaration should be either Y or N<br>For RIA Entity it should be empty |
| subBrokCode | Sub Broker Code | Char(15) | No |  |  |
| branchRMIntCode | Branch RM Internal code | Char(15) | No |  |  |
| totAmt | Total amount for Purchase transactions | Numeric(11,2) | Conditional Mandatory |  | totAmt value is required only if txnType is V. Otherwise the value should be empty. |

### sysSchList Array List Section Start

### Table 4

Source cells: `B24:G38`

| entUnqItrn | This value shall be given by the entity, MFU will map this unique reference to the corresponding scheme level transaction and the same will be returned to the Entities in the Transaction Feed Response. This should be unique. | Char(50) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| rtaAmcCode | RTA AMC Code | Char(6) | Yes |  |  |
| rtaSchCode | RTA Scheme Code | Char(6) | Yes |  | If txnType is V or J, schemeCode to be provided.<br>If txnType is E then the schemeCode of the source scheme to be provided |
| outRtaSchCode | RTA Out Scheme Code for Switch transactions | Char(6) | Conditional Mandatory |  | If txnType is E then the outRtaSchCode param should contain the target scheme code.<br>Else,  the value should be empty. |
| folio | Folio Number | Char(21) | Yes |  | If the transaction belongs to existing CAN then the folio number should be passed.<br><br>If the transaction is of new folio then the value should be NEW. |
| divOpt | Scheme Dividend Option | Char(1) | Conditional Mandatory | Allowed Values:<br>N - Not-Applicable<br>P - Payout<br>R – Re-Invest | The divOpt value is mandatory only if txnType is V or E. <br>If txnType is E, then the source scheme's dividend option to be provided.<br>Otherwise the value should be empty. |
| txnVolTyp | Transaction Volume Type | Char(1) | Yes | Allowed Values:<br>A - Amount<br>F - Fixed | The txnVolType should be A only if txnType  is V.<br>If txnType is J or E, txnVolType should be F. |
| vol | Transaction Volume | Numeric(14,3) | Yes |  |  |
| frequency | Scheme Frequency based on selection by user | Char(1) | Yes | Refer Master Data Sheet : Frequency for the allowed values |  |
| day | transaction installment day based on scheme master.  | Char(10) | Yes |  | For Daily frequency the value should be "NA". |
| startMonth | Transaction start month | Char(2) | Yes |  |  |
| startYear | Transaction start year | Char(4) | Yes |  |  |
| endMonth | Transaction end month | Char(2) | Yes |  |  |
| endYear | Transaction end year | Char(4) | Yes |  |  |
| payOutFlag | Pay out section flag | Char(1) | Conditional Mandatory | Allowed Values:<br>Y –  PayOut Bank Details<br>N – Default CAN Bank | The value is required only if txnType is J.<br>Otherwise the value should be empty. |

### payOutDtl (payout detail section start)

### Table 5

Source cells: `B40:G42`

| invAccNo | Investor Bank Account number | Char(20) | Conditional Mandatory | Column F | if(payOutFlag =”Y”)  value is required <br>else empty. |
| --- | --- | --- | --- | --- | --- |
| micr | Bank MICR | Char(9) | Conditional Mandatory |  | if(payOutFlag =”Y”)  value is required <br>else empty. |
| ifsc | Bank IFSC Code | Char(11) | Conditional Mandatory |  | if(payOutFlag =”Y”)  value is required <br>else empty. |

### payOutDtl (payout detail section end)

### Table 6

Source cells: `B44:G46`

| priOtpFlag | Primary OTP Flag | Char(1) | Conditional Mandatory | Allowed Values: <br>B – Both<br>M – Mobile<br>E – Email | If the Entity is enabled for transaction 2FA, the field is mandatory. Otherwise empty value should be passed. |
| --- | --- | --- | --- | --- | --- |
| priMob | Mobile number. | Char(10) | Conditional Mandatory |  | if(priOtpFlag  = 'B' or priOtpFlag  = 'M') value is required. else empty. |
| priEmail | Email ID | Char(50) | Conditional Mandatory |  | if(priOtpFlag  = 'B' or priOtpFlag  = 'E') value is required. else empty. |

### schList Array List Section end

### Table 7

Source cells: `B48:G48`

| dpSecFlag | Depository Account Details  Section Flag | Char(1) | Conditional Mandatory | Allowed values:<br>Y – DP Section<br>N -No | The value is required only if txnType ="V" \|\| txnType = "E".<br>Otherwise the value should be empty |
| --- | --- | --- | --- | --- | --- |

### dpSec (depository detail section start)

### Table 8

Source cells: `B50:G51`

| dpType | Depository Type | Char(4) | Conditional Mandatory | Allowed values:<br>NSDL<br>CDSL | if(dpSecFlag = “Y”) value is required <br>else empty |
| --- | --- | --- | --- | --- | --- |
| dpAccNo | Depository Account number | Char(16) | Conditional Mandatory |  | if(dpSecFlag = “Y”) value is required <br>else empty |

### dpSec (depository detail section end)

### Table 9

Source cells: `B53:G53`

| paySecFlag | Payment Section Flag | Char(1) | Conditional Mandatory | Allowed values:<br>Y – Payment Section<br>N -No | The value is required only if txnType is V.<br>Otherwise the value should be empty. |
| --- | --- | --- | --- | --- | --- |

### paySec (Current dated payment detail section start)

### Table 10

Source cells: `B55:G63`

| payMode | Payment Mode | Char(2) | Conditional Mandatory | Allowed values:<br>OT – Net Banking<br>NE - NEFT<br>RT - RTGS<br>DM – PayEezz<br>UP – UPI<br>IU - Insta UPI | This value is required only if paySecFlag is Y.<br>Otherwise the value should be empty. |
| --- | --- | --- | --- | --- | --- |
| micr | Bank MICR | Char(9) | Conditional Mandatory |  | This value is required only if paySecFlag is Y.<br>Otherwise the value should be empty. |
| ifsc | Bank IFSC Code | Char(11) | Conditional Mandatory |  | This value is required only if paySecFlag is Y.<br>Otherwise the value should be empty. |
| accType | Investor Bank Account Type | Char(4) | Conditional Mandatory | Refer Master Data Sheet : Account Type for the allowed values | This value is required only if paySecFlag is Y.<br>Otherwise the value should be empty. |
| accNo | Investor Bank Account number | Char(20) | Conditional Mandatory |  | This value is required only if paySecFlag is Y.<br>Otherwise the value should be empty. |
| payDate | Payment Instrument Date. The Date format should be in YYYY-MM-DD | Date | Conditional Mandatory |  | This value is required only if paySecFlag is Y.<br>Otherwise the value should be empty. |
| payAmt | Payment Amount | Numeric(11,2) | Conditional Mandatory |  | This value is required only if paySecFlag is Y.<br>Otherwise the value should be empty. |
| beneVan | Beneficiary A/C No | Char(30) | Conditional Mandatory |  | This value is required only if paySecFlag is Y.<br>Otherwise the value should be empty. |
| paymentRefNo | CAN Payeez UMRN number | Char(35) | Conditional Mandatory |  | This value is required only if paySecFlag is Y.<br>Otherwise the value should be empty. |

### paySec (Current dated payment detail section start)

### Table 11

Source cells: `B65:G65`

| subSeqPayFlag | For ApiEezz, the Subsequent Payment flag  Y and N are allowed. If the flag is  "N" then the customer should select the bank details in Link confirmation page. If the flag is "Y", then the susequent payment information is mandatory. | Char(1) | Conditional Mandatory | Allowed values:<br>Y – Sub Sequent Payment Section is mandatory<br>N – Sub Sequent Payment Section is non mandatory | if(txnType= “V”)  value is required. <br>else empty |
| --- | --- | --- | --- | --- | --- |

### subSeqSec (Sub-Sequent payment section start)

### Table 12

Source cells: `B67:G72`

| payMode | Subsequent Payment Mode | Char(2) | Conditional Mandatory | Allowed values:<br>DM – PayEezz<br>AP - UPI AutoPay | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |
| --- | --- | --- | --- | --- | --- |
| invAccType | Bank Account Type | Char(4) | Conditional Mandatory | Refer Master Data Sheet : Account Type for the allowed values | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |
| invAccNo | Bank Account number | Char(20) | Conditional Mandatory |  | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |
| micr | MICR Number | Char(9) | Conditional Mandatory |  | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |
| ifsc | IFSC Code | Char(11) | Conditional Mandatory |  | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |
| mandateRefNo | CAN Payeez UMRN number | Char(35) | Conditional Mandatory |  | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |

### subSeqSec (Sub-Sequent payment section end)

### logDtl (Customer Devicce Details Section Start)

### Table 13

Source cells: `B75:F76`

| deviceType | Device Type | Char(1) | Yes | Allowed values:<br>M - Mobile<br>W - Web |
| --- | --- | --- | --- | --- |
| custIpAddress | Customer Loged In IP Address | Char(20) | Yes |  |

### logDtl (Customer Devicce Details Section End)

### Systematic Transaction Service API – Response

### Table 14

Source cells: `B81:D81`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 15

Source cells: `B83:D86`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 16

Source cells: `B88:D88`

| ordCreatedFlag | In MFU system Order Created is generated or not.<br>Y - Order is created<br>N - Order is not created | Char(1) |
| --- | --- | --- |

### secWisErrorList (section wise error list array section start)

### Table 17

Source cells: `B90:D92`

| secName | Error Section Name | Char(50) |
| --- | --- | --- |
| secErrorCode | Error Code  | Char(10) |
| secErrorMsg | Error Message | Char(250) |

### secWisErrorList (section wise error list array section end)

### ordDtl (order detail section start)

### Table 18

Source cells: `B95:D105`

| entGroupRefNo | Entity Unique Group Reference number | Char(50) |
| --- | --- | --- |
| mfuGorn | MFU GORN | Char(16) |
| orderstatus | Current Order status in MFU System for the generated GORN.<br>Refer Master Data Sheet : Gorn Level Order Status for the possible values | Char(2) |
| virtualAccNo | Virtual Account number for CAN | Char(30) |
| virtAccIfsc | Virtual Account number IFSC code | Char(11) |
| appLinkPri | Primary Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| appLinkH1 | Secondary Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| appLinkH2 | Third Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| appLinkPOA | POA Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| paymentLink | Net Banking / UPI payment Link for API TransactEezz.<br>If upiIntentLink is provided this field should be empty | Char(150) |
| upiIntentLink | UPI Payment Intent Link is applicable only under the following conditions:<br><br> - The entity must be enabled for the Transaction 2FA Flag with MFU.<br> - The entity must be enabled for the UPI Intent Link Flag with MFU.<br>- In the request, the deviceType must be M (Mobile) and payMode must be UP (UPI)<br><br>Otherwise, an empty value will be passed. | Char(200) |

### itrnList (ITRN Wise Status ArrayList start)

### Table 19

Source cells: `B107:D111`

| entUnqItrn | Entity Unique ITRN Reference number | Char(50) |
| --- | --- | --- |
| mfuItrn | MFU ITRN | Char(18) |
| itrnOrdStatus | ITRN Level Order Status. <br>Refer Master Data Sheet : ITRN Level Order Status for the possible values | Char(2) |
| errorCode | If ITRN level order status is rejected, this field containts the value for the order rejected error code | Char(10) |
| errorMsg | If error code containts the values, this field have the error message for the error code | Char(250) |

### itrnList (ITRN Wise Status ArrayList end)

### ordDtl (order detail section end)

### Systematic Transaction Service API – Sample Request and Response

### Table 20

Source cells: `B117:C125`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| SIP TXN - <br>Request body without Encryption | [See JSON example 2 below] |
| SWP TXN  - <br>Request body without Encryption | [See JSON example 3 below] |
| STP TXN - <br>Request body without Encryption | [See JSON example 4 below] |
| Response with Encryption | [See JSON example 5 below] |
| Success Response withOut Encryption | [See JSON example 6 below] |
| Section wise erorr list -<br>Failure Response withOut Encryption | [See JSON example 7 below] |
|  ITRN Level Error - <br>Failure Response withOut Encryption | [See JSON example 8 below] |

### JSON examples

#### JSON example 1 (cell C118)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "SYS-TXN","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C119)

```json
{"txnType":"V","entGroupRefNo":"20241122001","orderMode":"Z","entityRemarks":"","can":"20244CG001","canType":"I","reqPrntEnt":"","riaCode":"INA987654321","arnCode":"","subArnCode":"","euin":"","euinDeclaration":"","subBrokCode":"","branchRMIntCode":"","totAmt":"1000","sysSchList":[{"entUnqItrn":"20241122701","rtaAmcCode":"AXF","rtaSchCode":"BDGPG","outRtaSchCode":"","folio":"NEW","divOpt":"N","txnVolTyp":"A","vol":"1000","frequency":"M","day":"25","startMonth":"12","startYear":"2024","endMonth":"12","endYear":"2026","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"B","priMob":"9489588768","priEmail":"binuaswini@gmail.com"}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"Y","paySec":{"payMode":"DM","micr":"123456789","ifsc":"ICIC0000281","accType":"SB","accNo":"320320","payDate":"2024-11-23","payAmt":"1000","beneVan":"","paymentRefNo":"EXEMPTPRN","paymentBankRefNo":"20241123705","paymentConfirmTs":"2024-06-23 10:20:23","amcPaymentTs":"2024-06-23 10:20:23"},"subSeqPayFlag":"Y","subSeqSec":{"payMode":"DM","invAccType":"SB","invAccNo":"320320","micr":"123456789","ifsc":"ICIC0000281","mandateRefNo":"EXEMPTPRN"},"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}}
```

#### JSON example 3 (cell C120)

```json
{"txnType":"J","entGroupRefNo":"20241122001","orderMode":"Z","entityRemarks":"","can":"15250CAA01","canType":"I","reqPrntEnt":"","riaCode":"INA987654321","arnCode":"","subArnCode":"","euin":"","euinDeclaration":"","subBrokCode":"","branchRMIntCode":"","totAmt":"1000","sysSchList":[{"entUnqItrn":"20241122701","rtaAmcCode":"AXF","rtaSchCode":"CMGPG","outRtaSchCode":"","folio":"KARLGOIN/01","divOpt":"","txnVolTyp":"F","vol":"1000","frequency":"M","day":"25","startMonth":"12","startYear":"2024","endMonth":"12","endYear":"2026","payOutFlag":"N","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"B","priMob":"9489588768","priEmail":"binuaswini@gmail.com"}],"dpSecFlag":"","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentRefNo":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"subSeqPayFlag":"N","subSeqSec":{"payMode":"","invAccType":"","invAccNo":"","micr":"","ifsc":"","paymentRefNo":""},"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}}
```

#### JSON example 4 (cell C121)

```json
{"txnType":"E","entGroupRefNo":"2024112203","orderMode":"Z","entityRemarks":"","can":"15250CAA01","canType":"I","reqPrntEnt":"","riaCode":"INA987654321","arnCode":"","subArnCode":"","euin":"","euinDeclaration":"","subBrokCode":"","branchRMIntCode":"","totAmt":"1000","sysSchList":[{"entUnqItrn":"20241122709","rtaAmcCode":"AXF","rtaSchCode":"BDGPG","outRtaSchCode":"CMGPG","folio":"KARLGOIN/01","divOpt":"N","txnVolTyp":"F","vol":"1000","frequency":"M","day":"25","startMonth":"12","startYear":"2024","endMonth":"12","endYear":"2026","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"B","priMob":"9489588768","priEmail":"binuaswini@gmail.com"}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"payMode":"DM","micr":"123456789","ifsc":"ICIC0000281","accType":"SB","accNo":"320320","payDate":"2024-11-23","payAmt":"1000","beneVan":"","paymentRefNo":"EXEMPTPRN","paymentBankRefNo":"20241123705","mandateRefNo":"12","paymentConfirmTs":"2024-06-23 10:20:23","amcPaymentTs":"2024-06-23 10:20:23"},"subSeqPayFlag":"N","subSeqSec":{"payMode":"DM","invAccType":"SB","invAccNo":"320320","micr":"123456789","ifsc":"ICIC0000281","paymentRefNo":"EXEMPTPRN"},"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}}
```

#### JSON example 5 (cell C122)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 6 (cell C123)

```json
{"respHeader":{"respFlag":"S","respTs":"2024-11-26 10:57:45","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"Y","secWisErrorList":[],"ordDtl":{"entGroupRefNo":"20241122005","mfuGorn":"U20244CG00100052","orderstatus":"AC","virtualAccNo":"","virtAccIfsc":"","appLinkPri":"","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":"","itrnList":[{"entUnqItrn":"20241122702","mfuItrn":"U20244CG0010005201","itrnOrdStatus":"OA","errorCode":"","errorMsg":""}]}}}        
```

#### JSON example 7 (cell C124)

```json
{ 
"respHeader": {    "respTs": "2023-04-15 10:20:10",    "respFlag": "S",    "errorCode": "",    "errorMsg": ""  }, 
"respBody": {    "ordCreatedFlag": "N",    "secWisErrorList": [      {        "secName": "canSection",        "secErrorCode": "20000",        "secErrorMsg": "Invalid CAN"      },        {        "secName": "paymentSection",        "secErrorCode": "20001",        "secErrorMsg": "Invalid Payment"      }    ],    "ordDtl": {      "entGroupRefNo": "",      "mfuGorn": "",      "orderstatus": "",      "virtualAccNo": "",      "virtAccIfsc": "",      "appLinkPri": "",      "appLinkH1": "",      "appLinkH2": "",      "appLinkPOA": "",      "paymentLink": "", "upiIntentLink":"",     "itrnWiseStatus": [      ]    }  }
}
```

#### JSON example 8 (cell C125)

```json
{  
"respHeader": {    "respTs": "2023-04-15 10:20:10",    "respFlag": "S",    "errorCode": "",    "errorMsg": ""  },  
"respBody": {    "ordCreatedFlag": "Y",    "secWisErrorList": [      {        "secName": "",        "secErrorCode": "",        "secErrorMsg": ""      }    ],    "ordDtl": {      "entGroupRefNo": "ENTGORN12345",      "mfuGorn": "XXXXXXXXXX000001",      "orderstatus": "OA",      "virtualAccNo": "",      "virtAccIfsc": "",      "appLinkPri": "",      "appLinkH1": "",      "appLinkH2": "",      "appLinkPOA": "",      "paymentLink": "",  "upiIntentLink":"",     "itrnWiseStatus": [        {          "entUnqItrn": "ENTITRN00001",          "mfuItrn": "XXXXXXXXXX00000101",          "itrnOrdStatus": "SS",          "errorCode": "89090",          "errorMsg": "Scheme Threashold not matched with order"        }      ]    }  }
}
```

## SYS-CANCEL-TXN

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `SYS-CANCEL-TXN`

### Systematic Cancellation Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechSystCancellationService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be SYS-CANCEL-TXN | Char(20) | Yes | SYS-CANCEL-TXN | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G13`

| txnType | Transaction Type | Char(1) | Yes | Allowed Values:<br>C - SIP Cancellation<br>T - STP Cancellation<br>W - SWP Cancellation | Column G |
| --- | --- | --- | --- | --- | --- |
| extGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes |  | Values should be Alphabets,Numeric or Alphanumeric |
| orderMode | Transaction Order Mode | Char(1) | Yes | Allowed Values:<br>Z - API TransactEezz  | The value should be Z always.  |
| entityRemarks | Entity Remarks | Char(250) | No |  |  |
| can | Common Account Number (CAN). | Char(10) | Yes |  |  |
| reqPrntEnt | Parent Entity ID for audit | Char(6) | No |  | The value can be empty |

### cancelSysTxnDet Array List Section Start

### Table 4

Source cells: `B15:G18`

| parentGORN | Parent Group Order Number | Char(16) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| parentITRN | Parent ITRN  | Char(2) | Yes |  |  |
| cancelReasonCode | SIP Cancellation Reason Code | Char(4) | Yes | Refer Master Data Sheet : Cancel Reason Code for the allowed values |  |
| cancelReasonRemarks | SIP Cancellation Reason Remarks | Char(180) | Conditional Mandatory |  | If cancelReasonCode is OTH(Others), cancelReasonRemarks is mandatory. |

### cancelSysTxnDet Array List Section End

### logDtl (Customer Devicce Details Section Start)

### Table 5

Source cells: `B21:F22`

| deviceType | Device Type | Char(1) | Yes | Allowed values:<br>M - Mobile<br>W - Web |
| --- | --- | --- | --- | --- |
| custIpAddress | Customer Loged In IP Address | Char(20) | Yes |  |

### logDtl (Customer Devicce Details Section End)

### Systematic Cancellation Service API – Response

### Table 6

Source cells: `B27:D27`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 7

Source cells: `B29:D32`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 8

Source cells: `B34:D34`

| ordCreatedFlag | In MFU system Order Created is generated or not.<br>Y - Order is created<br>N - Order is not created | Char(1) |
| --- | --- | --- |

### itrnWiseErrDetail (ITRN wise error list array section start)

### Table 9

Source cells: `B36:D41`

| parentGorn | Parent GORN Number | Char(16) |
| --- | --- | --- |
| parentItrn | Parent ITRN Number | Char(2) |
| noOfInstallment | No of Installment | Numeric |
| installmentDate | Installment Date | Date |
| errorCode | Error Code  | Char(10) |
| errorMsg | Error Message | Char(600) |

### itrnWiseErrDetail (ITRN wise error list array section end)

### secWisErrorList (section wise error list array section start)

### Table 10

Source cells: `B44:D46`

| secName | Error Section Name | Char(50) |
| --- | --- | --- |
| secErrorCode | Error Code  | Char(10) |
| secErrorMsg | Error Message | Char(250) |

### secWisErrorList (section wise error list array section end)

### ordDtl (order detail section start)

### Table 11

Source cells: `B49:D50`

| extGroupRefNo | Entity Unique Group Reference number | Char(50) |
| --- | --- | --- |
| mfuGorn | MFU GORN | Char(16) |

### ordDtl (order detail section end)

### Systematic Cancellation Service API – Sample Request and Response

### Table 12

Source cells: `B55:C63`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| SIP Cancellation -<br>Request body without Encryption | [See JSON example 2 below] |
| SWP Cancellation -<br>Request body without Encryption  | [See JSON example 3 below] |
| STP Cancellation  -<br>Request body without Encryption | [See JSON example 4 below] |
| Response with Encryption | [See JSON example 5 below] |
| Success Response withOut Encryption | [See JSON example 6 below] |
| Section wise erorr list -<br>Failure Response withOut Encryption | [See JSON example 7 below] |
| ITRN Level Error - <br>Failure Response withOut Encryption | [See JSON example 8 below] |

### JSON examples

#### JSON example 1 (cell C56)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "SYS-CANCEL-TXN","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C57)

```json
{
"txnType":"C","extGroupRefNo":"EXTGRPREF09","orderMode":"Z","entityRemarks":"","can":"20255BC001","reqPrntEnt":"","cancelSysTxnDet":[{"parentGORN":"U20255BC00101677","parentITRN":"02","cancelReasonCode":"M001","cancelReasonRemarks":""}],"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}
}
```

#### JSON example 3 (cell C58)

```json
{
"txnType":"W","extGroupRefNo":"EXTGRPREF09","orderMode":"Z","entityRemarks":"","can":"20255BC001","reqPrntEnt":"","cancelSysTxnDet":[{"parentGORN":"U20255BC00101677","parentITRN":"02","cancelReasonCode":"M001","cancelReasonRemarks":""}],"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}
}
```

#### JSON example 4 (cell C59)

```json
{
"txnType":"T","extGroupRefNo":"EXTGRPREF09","orderMode":"Z","entityRemarks":"","can":"20255BC001","reqPrntEnt":"","cancelSysTxnDet":[{"parentGORN":"U20255BC00101677","parentITRN":"02","cancelReasonCode":"M001","cancelReasonRemarks":""}],"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}
}
```

#### JSON example 5 (cell C60)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 6 (cell C61)

```json
{
"respHeader":{"respTs":"2023-04-15 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"Y","itrnWiseErrDetail":[{"parentGorn":"","parentItrn":"","noOfInstallment":"","installmentDate":"","errorCode":"","errorMsg":""}],"secWisErrorList":[],"ordDtl":{"extGroupRefNo":"ENTGORN12345","mfuGorn":"XXXXXXXXXX000001"}}
}
```

#### JSON example 7 (cell C62)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-11-26 17:13:28","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"N","itrnWiseErrDetail":null,"secWisErrorList":[{"secName":"commonSection","secErrorCode":"100401","secErrorMsg":"Invalid txnType"}],"ordDtl":{"extGroupRefNo":null,"mfuGorn":null}}
}
```

#### JSON example 8 (cell C63)

```json
{
"respHeader":{"respTs":"2023-04-15 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"N","itrnWiseErrDetail":[{"parentGorn":"U20255BC00101677","parentItrn":"02","noOfInstallment":"44","installmentDate":"0","errorCode":"18423","errorMsg":"One of the ITRN Parent Order is Affected.Cannot Approve the Order"}],"secWisErrorList":[],"ordDtl":{"extGroupRefNo":"ENTGORN12345","mfuGorn":""}}
}
```

## TXN-AUT-DET

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `TXN-AUT-DET`

### Transaction Order Auth Detail Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechTxnAuthDetService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be TXN-AUT-DETH | Char(20) | Yes | TXN-AUT-DETH | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:E9`

| entGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes |
| --- | --- | --- | --- |
| mfuGorn | MFU System Gorup Order Reference Number | Char(16) | Yes |

### Transaction Order Auth Detail ServiceAPI – Response

### Table 4

Source cells: `B13:D13`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B15:D18`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### gornOrdDet (gorn order detail section start)

### Table 6

Source cells: `B21:D31`

| can | CAN of the Investor against the Unique ID | Char(10) |
| --- | --- | --- |
| mfuGorn | MFU GORN | Char(16) |
| entGroupRefNo | Entity Unique Group Reference number | Char(50) |
| txnType | Possible Values:<br>PUR - Purchase <br>RED - Redemption<br>SWT - Switch | Char(3) |
| noOfSch | Number of schemes in the group order | Numeric(2) |
| totalAmt | Order Total Amount (value – applicable for Purchase orders only. For other transaction this value will come as ZERO) | Numeric(15,2) |
| ordStatus | Current Order Status of the Transaction will be provided.<br>Possible Values:<br>Created<br>Authorization-In-Progress<br>Cancelled<br>Authorized<br>Rejected | Char(50) |
| ordInsertTs | Order Collected (Insert) Timestamp.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| ordBussTs | Order Business Time Stamp (after final approval).<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| payMode | Payment Mode of the order as per request (NEFT, RTGS, Transfer and so on) | Char(15) |
| payInstrNo | If order contained instrument based payment, then instrument number will be provided. It will be blank in case of no instrument number | Char(30) |

### itrnList (ITRN ArrayList start)

### Table 7

Source cells: `B33:D52`

| itrn | ITRN Number within the Group Order (01, 02. 03 and so on) | Char(2) |
| --- | --- | --- |
| entUnqItrn | Entity Unique ITRN Reference number | Char(50) |
| itrnTxnType | Type of the Transaction. <br>Possible Values:<br>Purchase<br>Additional Purchase<br>NFO<br>Redeem<br>Switch-In<br>Switch-Out | Char(20) |
| volType | Type of Transaction Volume.<br>Possible Values:<br>Amount <br>All Units <br>Units <br>Fixed <br>Variable | Char(50) |
| value | Amount / No of Units (for All units redemption, this value will be Zero) | Numeric(15,2) |
| payStatus | Refer Master Data Sheet : Payment Status for the possible values | Char(25) |
| itrnTxnSt | Refer Master Data Sheet : ITRN Transaction Status for the possible values | Char(100) |
| schCode | RTA Scheme Code of ITRN | Char(10) |
| schName | RTA Scheme Name as available in MFU for the ITRN Scheme | Char(200) |
| divOpt | Dividend option as applicable for the ITRN. Will have one of the values below:<br>Payout<br>Reinvest<br>Not-Applicable | Char(15) |
| reqFolio | Folio number as specified in the request for this ITRN | Char(18) |
| reqFolioCkDigit | Check Digit if applicable for Request Folio | Char(2) |
| utrn | This is the ITRN reference number generated for the order in MFU while routing the order to RTA | Numeric(15) |
| ftrnBkTs | Date & Time of Fund Transfer for the given ITRN | Date Time |
| rspUnits | No of Units of the scheme as processed by RTA. In case Unit is not available, it will be provided as 0 (Zero) | Numeric(20,4) |
| rspAmt | Transaction Amount as processed by RTA. In case Amount is not applicable, it will be provided as 0 (Zero) | Numeric(20,4) |
| rspPrice | NAV that is considered by RTA for processing this ITRN | Numeric(20,4) |
| rspValDate | Value date considered by RTA for the ITRN | Date |
| rspFolio | Folio number that is provided as response by RTA. This may be different from Request Folio (Folio given in request) | Char(18) |
| rspFolioCkDigit | Check digit for the Response Folio as applicable | Char(2) |

### itrnList (ITRN ArrayList End)

### gornOrdDet (gorn order detail section End)

### authMasterDet (Auth Master Detail Section Start)

### grpLvlList (grpLvlList ArrayList Start)

### Table 8

Source cells: `B57:D57`

| lvlSetDet | This is to indicate how many users to approve in each applicable group and levels within that group. All 3 levels count will be provided always under the group. <br><br>Group id and Level id are separated with double # (##) symbols. Level required for approval is given after level number separated by “-“ (Minus) symbol<br>Sample value:<br> G1##L1-1,L2-1,L3-1,L4-1,L5-1<br> G2##L1-0,L2-0,L3-0,L4-0,L5-0 | Char(30) |
| --- | --- | --- |

### grpLvlList (grpLvlList ArrayList End)

### Table 9

Source cells: `B59:D65`

| l1Pans | List of approver PANs set in Level 1 in Authorization Matrix. In case of more than one approver user is configured in Level 1, then the PANs will be separated by # symbol | Char(200) |
| --- | --- | --- |
| l2Pans | List of approver PANs set in Level 2 in Authorization Matrix. In case of more than one approver user is configured in Level 2, then the PANs will be separated by # symbol | Char(200) |
| l3Pans | List of approver PANs set in Level 3 in Authorization Matrix. In case of more than one approver user is configured in Level 3, then the PANs will be separated by # symbol | Char(200) |
| l4Pans | List of approver PANs set in Level 4 in Authorization Matrix. In case of more than one approver user is configured in Level 4, then the PANs will be separated by # symbol | Char(200) |
| l5Pans | List of approver PANs set in Level 5 in Authorization Matrix. In case of more than one approver user is configured in Level 5, then the PANs will be separated by # symbol | Char(200) |
| selPans | In case, Maker User already selected the Approvers who can approve the order at the time of order entry, that list of selected approver PANs is provided here separated by # symbol. | Char(200) |
| verfPans | List of approver PANs set for Verifier. In case of more than one verifier user is configured, then the PANs will be separated by # symbol | Char(200) |

### authMasterDet (Auth Master Detail Section End)

### Table 10

Source cells: `B67:D67`

| verfierApprPan | Verifier PAN who already approved the orders. | Char(200) |
| --- | --- | --- |

### apprLvlList (apprLvlList ArrayList Start)

### Table 11

Source cells: `B69:D71`

| lvlType | Level Type is repeated for each level (L1, L2, L3,L4,L5) | Char(2) |
| --- | --- | --- |
| apprCount | Count of approvers who approved the order in each of the level type (L1 / L2 / L3/L4/L5) | Numeric(2) |
| apprPans | List of approver PANs set in each level who already approved the orders. The PANs will be separated by # symbol | Char(200) |

### apprLvlList (apprLvlList ArrayList End)

### Transaction Order Auth Detail ServiceAPI – Sample Request and Response

### Table 12

Source cells: `B77:C82`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C78)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "TXN-AUT-DETH","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C79)

```json
{
"entGroupRefNo":"2024062701","mfuGorn":"U24169DZ00300086"
}
```

#### JSON example 3 (cell C80)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C81)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-28 12:42:02","errorCode":"","errorMsg":""},"respBody":{"gornOrdDet":{"can":"XXXXXXXXXXX","mfuGorn":"XXXXXXXX","entGroupRefNo":"XXXXXXXXX","txnType":"PUR","noOfSch":"1","totalAmt":"5000.0","ordStatus":"Created","ordInsertTs":"2024-10-28 09:40:33","ordBussTs":"","payMode":"NEFT","payInstrNo":"","itrnList":[{"itrn":"01","entUnqItrn":"01","itrnTxnType":"Purchase","volType":"Amount","value":"5000.0000","payStatus":"Payment Initiated","itrnTxnSt":"Order Created","schCode":"BW015","schName":"Birla Sun Life Cash Manager - IP - Daily Dividend","divOpt":"Re-Invest","reqFolio":"","reqFolioCkDigit":"","utrn":XXXXXXXXXXX,"ftrnBkTs":"","rspUnits":"0.0","rspAmt":"0.0","rspPrice":"0.0","rspValDate":"","rspFolio":"","rspFolioCkDigit":""}]},"authMasterDet":{"grpLvlList":[{"lvlSetDet":""},{"lvlSetDet":""},{"lvlSetDet":""},{"lvlSetDet":""},{"lvlSetDet":""}],"l1Pans":"XXXXXXXXXX#XXXXXXXXXX","l2Pans":"XXXXXXXXXX","l3Pans":"XXXXXXXXXXX","l4Pans":"","l5Pans":"","selPans":" ","verfPans":"XXXXXXXXXX"},"verfierApprPan":"","apprLvlList":[]}
}
```

#### JSON example 5 (cell C82)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:11:09","errorCode":"10007","errorMsg":"Invalid Request details"},"respBody":{"gornOrdDet":{"can":"","mfuGorn":"","entGroupRefNo":"","txnType":"","noOfSch":"","totalAmt":"","ordStatus":"","ordInsertTs":"","ordBussTs":"","payMode":"","payInstrNo":"","itrnList":[]},"authMasterDet":{"grpLvlList":[],"l1Pans":"","l2Pans":"","l3Pans":"","l4Pans":"","l5Pans":"","selPans":""},"apprLvlList":[]}
}
```

## TXN-APPROVAL

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `TXN-APPROVAL`

### Transaction Order Approval Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechTxnApprovalService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be TXN-APPROVAL | Char(20) | Yes | TXN-APPROVAL | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G14`

| entGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| mfuGorn | MFU System Gorup Order Reference Number | Char(16) | Yes |  |  |
| apprUsrPan | Approver User PAN to be provided | Char(10) | Yes |  |  |
| apprUsrIP | Approver User IP address to be provided | Char(20) | Yes |  |  |
| apprUsrLogTS | Approver Logged Timestamp to be provided | Date Time | Yes |  |  |
| apprRejFlag | Flag to Indicate whether the given transaction is Approved or Reject by the Approver. | Char(1) | Yes | Allowed Values:<br>A -  Approve<br>R - Reject  |  |
| rejReason | Based on the Approve or Reject Flag, the Reason to be provided. | Char(250) | Conditional Mandatory  |  | (if apprRejFlag == 'R') rejReason is required else should be empty |

### Transaction Order Approval Service API – Response

### Table 4

Source cells: `B18:D18`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B20:D23`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B25:D25`

| orderStatus | Current Order status in MFU System for the generated GORN. | Char(100) |
| --- | --- | --- |

### respBody Section End

### Transaction Order Approval Service API – Sample Request and Response

### Table 7

Source cells: `B30:C35`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C31)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "TXN-APPROVAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C32)

```json
{
"entGroupRefNo":"20241021002","mfuGorn":"U23129GD00100084","apprUsrPan":"XXXXXXXXXX","apprUsrIP":"000.00.0.000","apprUsrLogTS":"2024-10-21 10:20:23","apprRejFlag":"A","rejReason":""
}
```

#### JSON example 3 (cell C33)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C34)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"orderStatus":"Order Approved"}
}
```

#### JSON example 5 (cell C35)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"orderStatus":""}
}
```

## TXN-HIST

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `TXN-HIST`

### Transaction Order History Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechTxnHistoryService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be TXN-HIST | Char(20) | Yes | TXN-HIST | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:E9`

| entGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes |
| --- | --- | --- | --- |
| mfuGorn | MFU System Gorup Order Reference Number | Char(16) | Yes |

### Transaction Order History Service  API – Response

### Table 4

Source cells: `B13:D13`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B15:D18`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B20:D20`

| mfuGorn | MFU System Group Order Reference Number | Char(16) |
| --- | --- | --- |

### orderHistList ArrayList Section start

### Table 7

Source cells: `B22:D33`

| pan | PAN Number | Char(10) |
| --- | --- | --- |
| orderNo | Order Number  | Char(2) |
| orderHistoryRefNo | History Reference Number | Short |
| event | Refer Master Data Sheet : Order History Event for the possible values | Char(25) |
| eventTs | Event Timestamp.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| eventEntity | Event Entity  | Char(6) |
| eventEntityName | Event Entity Name | Char(105) |
| eventUser | Event User Code | Char(12) |
| eventUserName | Event User Name | Char(105) |
| eventUserLevel | Event User Level | Char(2) |
| rtaRemarks | Remarks provided by RTA | Char(500) |
| internalRemarks | Internal Remarks provided | Char(500) |

### orderHistList ArrayList Section end

### respBody Section End

### Transaction Order History Service  API – Sample Request and Response

### Table 8

Source cells: `B39:C44`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C40)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "TXN-APPROVAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C41)

```json
{
"entGroupRefNo":"20241021002","mfuGorn":"U23129GD00100084"
}
```

#### JSON example 3 (cell C42)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C43)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"mfuGorn":"","orderHistList":[{"pan":"","orderNo":"","orderHistoryRefNo":"","event":"","eventTs":"","eventEntity":"","eventEntityName":"","eventUser":"","eventUserName":"","eventUserLevel":"","rtaRemarks":"","internalRemarks":""}]}
}
```

#### JSON example 5 (cell C44)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"mfuGorn":"","orderHistList":[{"pan":"","orderNo":"","orderHistoryRefNo":"","event":"","eventTs":"","eventEntity":"","eventEntityName":"","eventUser":"","eventUserName":"","eventUserLevel":"","rtaRemarks":"","internalRemarks":""}]}
}
```

## CAN-VAL

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-VAL`

### CAN Validation Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechCanValidationService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-VAL | Char(20) | Yes | CAN-VAL | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:E11`

| can | Common Account Number (CAN). | Char(10) | Yes |
| --- | --- | --- | --- |
| pan | PAN Number of the Primary Holder | Char(10) | Yes |
| dob | Date Of Birth of the Primary Holder | Date | Yes |
| emailId | Emailid of the Primary Holder | Char(100) | Yes |

### CAN Validation Service API – Response

### Table 4

Source cells: `B15:D15`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B17:D20`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B22:D29`

| isValidCan | If the given CAN is availabe in MFU system, then this value will be TRUE else FALSE. | Char(5) |
| --- | --- | --- |
| isValidPan | If the given PAN belongs to the provided CAN, then this value will be TRUE else FALSE. | Char(5) |
| isValidDob | If the given DOB belongs to the provided CAN, then this value will be TRUE else FALSE. | Char(5) |
| isValidEmail | If the given Email is valid for the CAN, then this value will be TRUE else FALSE. | Char(5) |
| canStatus | If the given CAN is valid, then the status of the CAN in MFU System will be populated,For Invalid CAN it will be empty. <br>Refer Master Data Sheet : CAN Status for the possible values | Char(2) |
| allowForTrans | If Can, Pan, Dob and Email are valid for this combination, then this value will be TRUE else FALSE. | Char(5) |
| accountCategory | If the given CAN is valid, then the CAN's Account Category will be provided, For Invalid CAN this value will be empty. <br>Possible Values:<br>I – Individual CAN<br>N – Non-Individual CAN  | Char(1) |
| canModeOfHolding | If the given CAN is valid, then the CAN's  Mode of Holding will be provided, For Invalid CAN this value will be empty.<br>Possible Values: <br>SI - Single<br>JO- Joint<br>AS - Anyone or Survivor | Char(2) |

### CAN Validation Service API – Sample Request and Response

### Table 7

Source cells: `B33:C38`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C34)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-06 10:20:09","apiType":"CAN-VAL","uniqueId":"1000000001"},"reqBody":{"data":"zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="}
}
```

#### JSON example 2 (cell C35)

```json
{
"can":"XXXXXXXXXX","pan":"XXXXXXXXXXX","dob":"1982-02-03","emailId":"arvind@mail.com"
}
```

#### JSON example 3 (cell C36)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C37)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"isValidCan":"TRUE","isValidPan":"FALSE","isValidDob":"TRUE","isValidEmail":"TRUE","canStatus":"","allowForTrans":"TRUE","accountCategory":"","canModeOfHolding":""}
}
```

#### JSON example 5 (cell C38)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"F","errorCode":"10023","errorMsg":"Invalid Details"},"respBody":{"isValidCan":"","isValidPan":"","isValidDob":"","isValidEmail":"","canStatus":"","allowForTrans":"","accountCategory":"","canModeOfHolding":""}
}
```

## CAN-FETCH

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-FETCH`

### CAN Fetch Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechCanFetchService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-FETCH | Char(20) | Yes | CAN-FETCH | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G15`

| panNo | First Holder PAN Number<br>If Minor, then Guardian PAN No to be provided | Char(10) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| resdStatus | Resident status of the Investor | Char(3) | Yes | Refer Master Data Sheet : Resident Status for the allowed values |  |
| modeOfHld | Mode of holding of the Investor. | Char(2) | Yes | Allowed Values:<br>SI - Single<br>JO - Joint<br>AS - Anyone or Survivor |  |
| dob | First Holder Date of birth and if Minor, Minor applicant DOB to be provided | Date | Yes |  |  |
| holder2PanNo | Second Holder PAN Number | Char(10) | Conditional Mandatory |  | If modeOfHld is not Single, Then holder2PanNo is mandatory else should be empty |
| holder3PanNo | Third Holder PAN Number | Char(10) | Conditional Mandatory |  | If modeOfHld is not Single, Then holder3PanNo is mandatory  else should be empty |
| holder2DOB | Second Holder Date of birth | Date | Conditional Mandatory |  | If modeOfHld is not Single, Then holder2DOB is mandatory  else should be empty |
| holder3DOB | Third Holder Date of birth | Date | Conditional Mandatory |  | If modeOfHld is Single, Then holder3DOB is mandatory  else should be empty |

### CAN Fetch Service API – Response

### Table 4

Source cells: `B20:D20`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B22:D25`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B27:D28`

| can | CAN of the investor in MFU system for the given input combination | Char(10) |
| --- | --- | --- |
| canStatus | CAN Status.<br>Refer Master Data Sheet : CAN Status for the possible values | Char(2) |

### CAN Fetch Service API – Sample Request and Response

### Table 7

Source cells: `B32:C37`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C33)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-06 10:20:09","apiType":"CAN-FETCH","uniqueId":"1000000001"},"reqBody":{"data":"zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="}
}
```

#### JSON example 2 (cell C34)

```json
{
"panNo":"XXXXXXXXXX","resdStatus":"RI","modeOfHld":"AS","dob":"1990-03-12","holder2PanNo":"XXXXXXXXXX","holder3PanNo":"XXXXXXXXXX","holder2DOB":"2014-03-28","holder3DOB":"2014-03-28"
}
```

#### JSON example 3 (cell C35)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C36)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"can":"XXXXXXXXXX","canStatus":""}
}
```

#### JSON example 5 (cell C37)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"F","errorCode":"10001","errorMsg":"Invalid Request Details"},"respBody":{"can":"","canStatus":""}
}
```

## PRN-VAL

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `PRN-VAL`

### PRN Validation Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechPRNValidationService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be PRN-VAL | Char(20) | Yes | PRN-VAL | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G11`

| can | Common Account Number (CAN). | Char(10) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| prn | PRN number | Char(20) | Conditional Mandatory  |  | Either PRN or MMRN is mandatory |
| mmrn | MMRN | Char(20) | Conditional Mandatory  |  | Either PRN or MMRN is mandatory |
| bankAccNo | BANK Account Number | Char(20) | Yes |  |  |

### PRN Validation Service API – Response

### Table 4

Source cells: `B15:D15`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B17:D20`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody Section –  JSON Field Details

### Table 6

Source cells: `B22:D24`

| prn | PRN Number will be provided if available. | Char(20) |
| --- | --- | --- |
| PRNExistsFlag | This Flag will return as 'Y' if the PRN is available in the system else the value will be 'N'. | Char(1) |
| status | Refer Master Data Sheet : PRN Status for the possible values | Char(2) |

### respBody Section End

### PRN Validation Service API – Sample Request and Response

### Table 7

Source cells: `B29:C34`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C30)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "PRN-VAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C31)

```json
{
"can":"XXXXXXXXXX","prn":"UMRN002","mmrn":"15253198911272F080CC","bankAccNo":"333333333330"
}
```

#### JSON example 3 (cell C32)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C33)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"prn":"UMRN002","prnExistsFlag":"Y","status":"PE"}
}
```

#### JSON example 5 (cell C34)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"prn":"","prnExistsFlag":"","status":""}
}
```

## CAN-BNK-VAL

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-BNK-VAL`

### CAN Bank Validation Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechBankValidationService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-BNK-VAL | Char(20) | Yes | CAN-BNK-VAL | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:E11`

| can | Common Account Number (CAN). | Char(10) | Yes |
| --- | --- | --- | --- |
| accountNo | Bank Account Number of the CAN. | Char(20) | Yes |
| micrNo | MICR Number | Char(9) | Yes |
| ifscCode | IFSC Code | Char(11) | Yes |

### CAN Bank Validation Service API – Response

### Table 4

Source cells: `B15:D15`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B17:D20`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody Section –  JSON Field Details

### Table 6

Source cells: `B22:D22`

| bankExistFlag | If the provided CAN Bank is available in MFU system, then this flag will be "Y" else "N". | Char(10) |
| --- | --- | --- |

### respBody Section End

### CAN Bank Validation Service API – Sample Request and Response

### Table 7

Source cells: `B27:C32`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C28)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "CAN-BNK-VAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C29)

```json
{
"can":"XXXXXXXXXX","accountNo":"20141113","micrNo":"XXXXXXXX","ifscCode":"XXXXXXXXXXX"
}
```

#### JSON example 3 (cell C30)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C31)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"bankExistFlag":"Y"}
}
```

#### JSON example 5 (cell C32)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"bankExistFlag":""}
}
```

## SWP-PAYEEZ

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `SWP-PAYEEZ`

### Swap PayEezz Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechSwpPayEezService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be SWP-PAYEEZ | Char(20) | Yes | SWP-PAYEEZ | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:F16`

| can | Common Account Number (CAN) | Char(10) | Yes | Column F |
| --- | --- | --- | --- | --- |
| mfuGorn | MFU GORN for Swap PayEezz | Char(20) | Yes |  |
| subSeqPayMode | Subsequent Payment Mode | Char (2) | Yes | Allowed Values:<br>AP - UPI- AutoPay<br>DM - Payeezz |
| newPRN | PRN of the CAN | Char(30) | Yes |  |
| bnkId | Bank Id | Char(4) | Yes |  |
| micr | MICR Number | Char(9) | Yes |  |
| ifsc | IFSC Code | Char(11) | Yes |  |
| accType | Bank Account type | Char(4) | Yes | Refer Master Data Sheet : Account Type for the allowed values |
| accNo | Bank Account number | Char(20) | Yes |  |

### Swap PayEezz Service API – Response

### Table 4

Source cells: `B20:D20`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B22:D25`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B27:D28`

| makerRefNo | Reference number | Char(10) |
| --- | --- | --- |
| respMsg | Swapped PayEezz will be effective for instalments falling due on or after 5 Calendar days | Char(500) |

### Swap PayEezz Service API – Sample Request and Response

### Table 7

Source cells: `B32:C37`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C33)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "SWP-PAYEEZ","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C34)

```json
{
{"can":"XXXXXXXXXX","mfuGorn":"XXXXXXXXXXXXXX","subSeqPayMode":"AP","newPRN":"XXXXXXXX","bnkId":"240","micr":"999999999","ifsc":"HDFC900045","accType":"SB","accNo":"XXXXXXXXXXXX"}}
```

#### JSON example 3 (cell C35)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C36)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-11-19 15:00:54","errorCode":"","errorMsg":""},"respBody":{"makerRefNo":"MXXXXXXX","respMsg":"Swapped PayEezz will be effective for instalments falling due on or after 5 Calendar days"}
}
```

#### JSON example 5 (cell C37)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-11-19 13:10:03","errorCode":"16289","errorMsg":"Provision not given for MMRN based SIP Registration."},"respBody":{"makerRefNo":"","respMsg":""}
}
```

## CAN-FOLIO-VAL

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-FOLIO-VAL`

### CAN Folio Validation Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechCanFolioValService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-FOL-VAL | Char(20) | Yes | CAN-FOL-VAL | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G11`

| can | Common Account Number (CAN) | Char(10) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| folio | Folio Number to be validated | Char(21) | Yes |  |  |
| txnType | Transaction Type | Char(1) | Conditional Mandatory | Allowed Values:<br>B - Purchase<br>R - Redeem<br>S - Switch<br>V - SIP<br>J - SWP<br>E - STP<br>Blank value | Possible Values Mapping |
| rtaAmcCode | RTA AMC Fund Code  | Char(6) | Yes |  |  |

### CAN Folio Validation Service API – Response

### Table 4

Source cells: `B16:D16`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B18:D21`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B23:D25`

| canFolioValidFlag | If the provided Folio is mapped with the CAN in the MFU system, then this flag will be "Y" else "N". | Char(1) |
| --- | --- | --- |
| isHoldingAvail | If the holding is avaliable for the provided, then this flag will be "Y" else "N". | Char(1) |
| message | Folio is mapped with CAN / Folio is not mapped with CAN | Char(500) |

### CAN Folio Validation Service API – Sample Request and Response

### Table 7

Source cells: `B29:C34`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C30)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "CAN-FOL-VAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C31)

```json
{
"can":"XXXXXXXXXX","folio":"SAMEFOLIO/76","txnType":"V","rtaAmcCode":"FTI"
}
```

#### JSON example 3 (cell C32)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C33)

```json
{"respHeader":{"respFlag":"S","respTs":"2024-11-19 16:24:54","errorCode":"","errorMsg":""},"respBody":{"canFolioValidFlag":"YES","isHoldingAvail":"N","message":"Folio is mapped with CAN"}}
```

#### JSON example 5 (cell C34)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-11-19 16:25:37","errorCode":"","errorMsg":""},"respBody":{"canFolioValidFlag":"N","isHoldingAvail":"N","message":"Folio is not mapped with CAN"}
}
```

## INV-CON-ENTRY

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `INV-CON-ENTRY`

### Investor Consent Entry Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechInvConsentEntryService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be INV-CON-ENTRY | Char(20) | Yes | INV-CON-ENTRY | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:E10`

| can | Common Account Number (CAN). | Char(10) | Yes |
| --- | --- | --- | --- |
| pan | Primary Holder PAN. | Char(10) | Yes |
| mobNo | CAN First Holder Contact Mobile Number | Char(15) | Yes |

### dataSetArr Array List Section Start

### Table 4

Source cells: `B12:F12`

| dataSetKey | Consent data set key | Char(2) | Conditional Mandatory | Allowed Values:<br>CD - CAN Details<br>PD - PayEezz Details<br>MF - Mapped Folio Details<br>HD - Holding Data |
| --- | --- | --- | --- | --- |

### Investor Consent Entry Service API – Response

### Table 5

Source cells: `B15:D15`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 6

Source cells: `B17:D20`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 7

Source cells: `B22:D26`

| refNo | Reference number | Char(20) |
| --- | --- | --- |
| priLink | Primary Holder link | Char(800) |
| joint1Link | Second Holder Link. This value will be empty in case of single holder | Char(800) |
| joint2Link | Third Holder Link. This value will be empty in case of single holder | Char(800) |
| poaLink | POA Link. If CAN have POA , then POA link will be provided. | Char(800) |

### Investor Consent Entry Service API – Sample Request and Response

### Table 8

Source cells: `B30:C35`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C31)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-06 10:20:09","apiType":"INV-CON-ENTRY","uniqueId":"1000000001"},"reqBody":{"data":"zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="}
}
```

#### JSON example 2 (cell C32)

```json
{
"can":"XXXXXXXXXX","pan":"XXXXXXXXXXX","mobNo":"XXXXXXXXXXX","dataSetArr":[{"dataSetKey":"CD"},{"dataSetKey":"PD"}]
}
```

#### JSON example 3 (cell C33)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C34)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"refNo":"XXXXXXXXXXX55990M3JZ","priLink":https:apiFintechInvConEntry?key=AEcus7+/g0xNHnonSXy81dUZzRwvRl2GDmRiUCCA7WilWvNZX99wyfgEnk8ifd5h,"joint1Link":"","joint2Link":"","poaLink":""}
}
```

#### JSON example 5 (cell C35)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"F","errorCode":"10023","errorMsg":"Invalid Details"},"respBody":{"refNo":"","priLink":"","joint1Link":"","joint2Link":"","poaLink":""}
}
```

## INV-CON-VIEW

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `INV-CON-VIEW`

### Investor Consent View Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechInvConsentViewService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be INV-CON-VIEW | Char(20) | Yes | INV-CON-VIEW | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:F9`

| type | Type of the Investor consent request. | Char(1) | Yes | Allowed Values:<br>V – Investor Consent View <br>R – Re-Triger |
| --- | --- | --- | --- | --- |
| refNo | Investor Consent Entry Registration Number | Char(20) | Yes |  |

### Investor Consent View Service API – Response

### Table 4

Source cells: `B12:D12`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B14:D17`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody  Section –  JSON Field Details

### Table 6

Source cells: `B19:D21`

| refNo | Reference number | Char(20) |
| --- | --- | --- |
| status | Status of the Consent record. | Char(2) |
| statusDesc | Status Description | Char(50) |

### dataSetList Array List Section Start

### Table 7

Source cells: `B23:D25`

| dataSetVal | Data Set Key | Char(2) |
| --- | --- | --- |
| dataSetDesc | Data Set Description | Char(50) |
| dataSetSts | Possible Values:<br>Empty – Investor is not acted on the Request.<br>Y – approved by Investor<br>N – Reject by Investor | Char(1) |

### dataSetList Array List Section End

### This section belongs to type R

### invApprlink Section Start

### Table 8

Source cells: `B29:D32`

| priLink | Primary Holder Link for Investor consent approve | Char(800) |
| --- | --- | --- |
| joint1Link | Second Holder Link for Investor consent approve | Char(800) |
| joint2Link | Third Holder Link for Investor consent approve | Char(800) |
| poaLink | POA Link for Investor consent approve | Char(800) |

### invApprlink Section End

### Investor Consent View Service API – Sample Request and Response

### Table 9

Source cells: `B36:C41`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C37)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-06 10:20:09","apiType":"INV-CON-VIEW","uniqueId":"1000000001"},"reqBody":{"data":"zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="}
}
```

#### JSON example 2 (cell C38)

```json
{
"type":"V","refNo":"XXXXXXXXXXX55990M3JZ"
}
```

#### JSON example 3 (cell C39)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C40)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"refNo":"1085961732037487S9E7","status":" ","statusDesc":"","dataSetList":[],"invApprlink":{"priLink":"http://InvestorConsentView?key=XEguXf6/VZq8kIoTtURdCQFUvvK6n9fHl0I7ogZEdzWefPGhmG7dokvSG6cT1Sci","joint1Link":"","joint2Link":"","poaLink":""}
}
```

#### JSON example 5 (cell C41)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"F","errorCode":"10023","errorMsg":"Invalid Details"},"respBody":{"refNo":"","status":" ","statusDesc":"","dataSetList":[],"invApprlink":{"priLink":"","joint1Link":"","joint2Link":"","poaLink":""}
}
```

## STATUS-CHK-TXN

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `STATUS-CHK-TXN`

### Status Check Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechTranStatusChkService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be STATUS-CHK-TXN | Char(20) | Yes | STATUS-CHK-TXN | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:F10`

| stType | Status API Type | Char(20) | Yes | NORMAL-TXN <br>SYS-TXN<br>SYS-CANCEL-TXN |
| --- | --- | --- | --- | --- |
| entGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes |  |
| orderDate | Order placed date(The date format is YYYY-MM-DD). | Char(10) | Yes |  |

### Status Check Service API – Response

### Table 4

Source cells: `B14:D14`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B16:D19`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody Section –  JSON Field Details

### This section is applicable only stType is NORMAL-TXN or SYS-TXN

### Table 6

Source cells: `B22:D22`

| stType | Status API Type | Char(20) |
| --- | --- | --- |

### orderDetail (Order Detail section start)

### Table 7

Source cells: `B24:D27`

| ordCreatedFlag | In MFU system Order Created is generated or not.<br>Possible Values:<br>Y - Order is created<br>N - Order is not created | Char(1) |
| --- | --- | --- |
| mfuGorn | MFU System Gorup Order Reference Number | Char(16) |
| corn | The unique reference number will be generated in the MFU system for the given SCHD Entry Request.<br>For Success case , the CORN will be populated.<br>For Failure case , It should be empty | Char(20) |
| orderstatus | Current Order status in MFU System for the generated GORN.<br>Refer Master Data Sheet : Gorn Level Order Status for the possible values | Char(100) |

### itrnWiseStatus Array List Section Start

### Table 8

Source cells: `B29:D31`

| entUnqItrn | Entity Unique ITRN Reference number | Char(50) |
| --- | --- | --- |
| mfuItrn | MFU ITRN | Char(18) |
| itrnOrdStatus | ITRN Level Order Status. <br>Refer Master Data Sheet : ITRN Level Order Status for the possible values | Char(2) |

### itrnWiseStatus Array List Section End

### Order Detail Section End

### This section is applicable only stType is SYS-CANCEL-TXN

### Table 9

Source cells: `B35:D35`

| stType | Status API Type | Char(20) |
| --- | --- | --- |

### cancellationDetail (Cancellation Detail section start)

### Table 10

Source cells: `B37:D38`

| ordCreatedFlag | In MFU system Order Created is generated or not.<br>Possible Values:<br>Y - Order is created<br>N - Order is not created | Char(1) |
| --- | --- | --- |
| mfuGorn | MFU System Gorup Order Reference Number | Char(16) |

### Cancellation Detail Section End

### Status Check Service API – Sample Request and Response

### Table 11

Source cells: `B44:C49`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption For NORMAL-TXN or SYS-TXN | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C45)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "STATUS-CHK-TXN","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C46)

```json
{
"stType":"NORMAL-TXN","entGroupRefNo":"ENTGORN12345","orderDate":"2024-06-10"
}
```

#### JSON example 3 (cell C47)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C48)

```json
{"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"stType":"NORMAL-TXN","orderDetail":{"ordCreatedFlag":"Y","mfuGorn":"XXXXXXXX","corn":"","orderstatus":"AC","itrnWiseStatus":[{"entUnqItrn":"ENTITRN00001","mfuItrn":"XXXXXXXXXX00000101","itrnOrdStatus":"OA"}]}}}
```

#### JSON example 5 (cell C49)

```json
{"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"stType":"","orderDetail":{"ordCreatedFlag":"","mfuGorn":"","corn":"","orderstatus":"","itrnWiseStatus":[{"entUnqItrn":"","mfuItrn":"","itrnOrdStatus":""}]}}}
```

## ORD-PAYMT-LINK

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `ORD-PAYMT-LINK`

### Order Payment Link Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechOrdPaymtLinkService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be ORD-PAYMT-LINK | Char(20) | Yes | ORD-PAYMT-LINK | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G10`

| mfuGorn | MFU System Gorup Order Reference Number | Char(16) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| deviceType | Device Type. This field is used for in-flow transactions with payMode as UP (UPI)-based orders. If the entity does not receive the UPI Intent Link in the immediate response, this field is used to fetch the UPI Intent Link for the order | Char(1) | No | Allowed values:<br>M - Mobile<br> |  |
| ipAddress | Customer Loged In IP Address | Char(20) | Conditional Mandatory |  | If deviceType is M means, ipAddress is mandatory otherwise empty |

### Order Payment Link Service API – Response

### Table 4

Source cells: `B13:D13`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B15:D18`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody Section –  JSON Field Details

### Table 6

Source cells: `B21:D26`

| appLinkPri | Primary Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| --- | --- | --- |
| appLinkH1 | Secondary Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| appLinkH2 | Third Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| appLinkPOA | POA Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| paymentLink | Net Banking / UPI payment Link for API TransactEezz.<br>If upiIntentLink is provided this field should be empty | Char(150) |
| upiIntentLink | UPI Payment Intent Link is applicable only under the following conditions:<br><br> - The entity must be enabled for the Transaction 2FA Flag with MFU.<br> - The entity must be enabled for the UPI Intent Link Flag with MFU.<br>- In the request, the deviceType must be M (Mobile) and the order must be UPI based order<br><br>Otherwise, an empty value will be passed. | Char(200) |

### respBody Section End

### Order Payment Link Service API – Sample Request and Response

### Table 7

Source cells: `B31:C36`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C32)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "PRN-VAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C33)

```json
{"mfuGorn":"XXXXXXXXXX","deviceType":"","ipAddress":""}
```

#### JSON example 3 (cell C34)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C35)

```json
{"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"appLinkPri":"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":""}}	
```

#### JSON example 5 (cell C36)

```json
{"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"appLinkPri":"","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":""}}		
```

## REDIRECT-TO-ENTITY

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `REDIRECT-TO-ENTITY`

### API TransactEezz Redirection to Entity Page

For entities that want to regain control within their portal after completing payments (Net Banking or UPI) or the order approval cycle, a redirection option to the entity page is available.  
The following configurations are provided during entity setup:  
1. S – Server-to-Server Response  
                MFU sends a response to the entity server via an HTTP callback URL.  
                An optional encryption flag is available. If enabled, the entire request body is encrypted. Algorithm : AES/CBC/PKCS7Padding  
2. U – UI Redirection  
                The user is redirected back to the entity portal after completing the transaction.  
3. B – Both  
                The entity receives both the server-to-server response and the user is redirected back to the portal.  
4. N – None  
                The entity does not receive control back after payment completion / order approval on the MFU page.  
  
The same callback URL is used for both server-to-server calls and browser redirection.  
  
The key differences are:  
Server-to-Server Call:  
        The response data is sent in the HTTP output stream.  
UI Redirection:  
        On the Net Banking / UPI page of MFU or the TransactEezz approval page, a confirmation button is displayed. Once the user clicks this button, they are redirected to the callback URL, where the response details are passed as a JSON string in the Message parameter.

### Table 1

Source cells: `B4:E4`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

### This section is applicable for NetBanking and UPI Transactions

### netBkPayDt Section Start

### Table 2

Source cells: `B7:D10`

| gorn | Char(16) | Group Order Reference Number |
| --- | --- | --- |
| payRefNo | Char(35) | Payment reference number |
| payRemarks | Char(500) | Remarks received from Payment Aggregator |
| payStatus | Char(50) | Status of the Payment. Success or Failure |

### netBkPayDt Section End

### This section is applicable for Other than NetBanking and UPI Transactions

### orderDtl Section Start

### Table 3

Source cells: `B15:D18`

| gorn | Char(16) | Group Order Reference Number |
| --- | --- | --- |
| entGroupRefNo | Char(50) | Entity external Group Unique Reference Number for the transaction. |
| orderstatus | Char(50) | Order Approval Status. Success or Failure |
| remarks | Char(500) | If the user enters any remarks during approval or rejection, those remarks will be populated in this field |

### orderDtl Section End

### API TransactEezz Redirection to Entity Page  Sample Response

### Table 4

Source cells: `B22:C25`

| Sample Type | Sample |
| --- | --- |
| Server to Server Response with Encryption | /q+tihrI6oQl1v0iFy5vVEBjlU6Etw2ZjK/u/GDjll+POON7R0gE9WMv3Z1FEA+NoUmJzZOBr4sRVjitCettR1khss8YFRVetQ4V1sivvjzm/bXMBWVDMihZzZHXx/1vJlG+c07aUkt7PzK/4sFlwFrsUOcjI1Y4d5YLSkJUHTbGpXMXiZqNnFmJ4lkuTluLVSFKPvvs07bbY4L5wgeqQm1Az4Yn6+20ZJeiYzT1rTP+zLJYgSLvjW7rlp++lWVOHtBQx0LjnYDelJIa3Q8VmHmzB8stsxZV7fPOptdVcYWkorhE6eIKBbErvsNuwxNV0b4Gu4j6CI0q2Ax1+OAvO8HuHXJmaFdEm5Mh7f8jx5N0P1pAEf4S65hHNEPt9CVL+jCfEmtjQWywlkeEthdTJwfjIPv6g3vzJ8iQY2STcPdGRmROxgAlzwGgwvhppADIFRQOAs5Bl9kUyc357urcANE6FI0XXKOT+b9piSEmPcI+EaD+ZqhHDGJ5DJQiLTeDWFcLiPbn/1jyJx9Q2vCKYA== |
| Response withOut Encryption<br>(For NetBanking and UPI Transactions ) | [See JSON example 1 below] |
| Response Response withOut Encryption<br>(For Other than NetBanking and UPI Transactions) | [See JSON example 2 below] |

### JSON examples

#### JSON example 1 (cell C24)

```json
[{"netBkPayDt":{"gorn":"1417XXXXXXXXXXXXX","payRefNo":"QHDF8016384458","payRemarks":"Payment Success","payStatus":"success"}}]
```

#### JSON example 2 (cell C25)

```json
{"orderDtl":{"gorn":"1980XXXXXXXXXXXXX","entGroupRefNo":"XXXXXXXXXXXXXX","orderstatus":"success","remarks":""}}
```

## HIGH-VAL-TXN

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `HIGH-VAL-TXN`

### High Value Transaction Push Service API

### Table 1

Source cells: `B3:E3`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

This is a High value transaction push service. MFU will iniaite the request to send the data to entity. The entity need to share the Push URL for recevied this transaction response.

For this service, oAuth is mandatory. Entity need to provide the oAuth URL. The oAuth request and repsonse format should be in MFU oAuth Format. For oAuth refer sheet Authorization with OAuth 2.0

### respHeader Section - without encryption JSON Field Details

### Table 2

Source cells: `B7:D9`

| amcCode | Char(6) | The AMC Code as available with the RTA for the AMC to which the notification is sent |
| --- | --- | --- |
| versionNo | Char(5) | Version number for the Web service. |
| rptDateTime | Date Time | Transaction Detail Report Generated Time stamp. Format is YYYY-MM-DD HH:MM:SS |

### respHeader Section End

### respBody Section Start - without encryption JSON Field Details

### txnList Array List Section Start -  ITRN Detail of the Order (Repeated as many times as per number of ITRNs)

### Table 3

Source cells: `B13:D27`

| itrn | Char(18) | ITRN number of the order |
| --- | --- | --- |
| utrn | Number(15) | Unique Transaction Reference Number sent to RTA. This is the ITRN reference number generated for the order in MFU while routing the order  to RTA |
| itrnTxnType | Char(25) | Type of the Transaction.<br>Refer Master Data Sheet : ITRN Transaction Type for the possible values |
| ordMode | Char(25) | Order Mode of the transaction. <br>Refer Master Data Sheet : Order Mode for the possible values |
| can | Char(10) | Common Account Number of the investor for whom order is placed. In case of Folio transaction, this value may be empty. |
| folio | Char(21) | ITRN Folio Number with Check Digit. This is provided for Folio Based order. If it is a CAN based order, this value may be empty |
| schCode | Char(10) | RTA Scheme Code of the ITRN Order |
| schName | Char(200) | RTA Scheme Name as available in MFU for the ITRN Scheme |
| invName | Char(105) | The Primary Holder Name as available in CAN or with Folio |
| txnVolType | Char(15) | Transaction Volume Type. <br>Possible Values :<br>All Units<br>Specific Amount<br>Specific Units |
| amount | Number(20,4) | The transaction Amount as entered by the investor shall be populated in this field. <br>For Purchase transactions, this field is mandatory. |
| units | Number(20,4) | The transaction Units as entered by the investor shall be populated in this field. <br>For Purchase transactions, this value will be empty.<br>For Redemption and Switch Transactions, if the Transaction Option is "U" then the Transaction Units is populated else; this value will be empty |
| estAmt | Number(20,4) | Estimated Amount. For Out Flow Unit Based transactions, the amount is estimated and populated. |
| ordStatus | Char(100) | Order status at the time of Feed generation.<br>Refer Master Data Sheet : ITRN Order Status for the possible values |
| ordTs | Date Time | The Order Timestamp by MFU system. The data will be provided in YYYY-MM-DD HH:MM:SS Format |

### payDetail Section Start

### Table 4

Source cells: `B29:D37`

| payMode | Char(25) | Payment Mode of the order.<br>Not Applicable for Direct to AMC payments. For other payments,<br>Refer Master Data Sheet : Payment Mode for the possible values |
| --- | --- | --- |
| invBnkName | Char(100) | Investor Payment Bank Name |
| payStatus | Char(50) | This field contains the payment status of the inflow transaction at the time of notification generation.<br>Refer Master Data Sheet : Payment Status for the possible values |
| srcAccNo | Char(20) | Investor Bank Account Number. Applicable only for inflow transaction |
| targetAccNo | Char(20) | AMC Bank Account Number. Applicable only for inflow transaction |
| amcBank | Char(100) | Fund Transfer AMC  Bank name if the investor payment is credited to MFU for the order at the time of notification generation. If not, this value will be empty |
| ftrn | Char(20) | Bank Fund Transfer Reference Number with respect to Subscription transactions. This is provided if the fund transfer is done from MFU to AMC for the order (after receiving the credit) at the time of notification generation. If not, this value will be empty |
| ftrnTs | Date Time | Fund Transfer Time stamp with respect to subscription transactions. Date & Time of Fund Transfer for the given ITRN. This is provided if the fund transfer is done from MFU to AMC for the order (after receiving the credit) at the time of notification generation. If not, this value will be empty. The data will be provided in YYYY-MM-DD HH:MM:SS  format |
| payStReason | Char(100) | Bank Credit Remarks, if available at the time of notification generation. |

### payDetail Section End

### txnList Array List Section End

### respBody Section End

### High Value Transaction API Sample Response

### Table 5

Source cells: `B44:C46`

| Sample Type | Sample |
| --- | --- |
| Response with Encryption | [See JSON example 1 below] |
| Response withOut Encryption | [See JSON example 2 below] |

### JSON examples

#### JSON example 1 (cell C45)

```json
{
"respData":"3Dlv69kqFld9U_p3MLLpL3dfov-pF46nBAm3qGH6W-FC1iIOEbMHreRMts8NvfBuSzSR6RwDAd2LX7lnKQkZIKDZr1Td3RsFJbMbG04LMSZ9ykVNEmFKyobsSnALxJFlb6-Igo1LWu973hNzSUsQ-Mlordx6Y5fJqOsaO2n-t8F37Z7tpIF2sGf0sp6hyIpvmq1AVLTn4ERfbLvy-D6-v4tDdWfHHwqGOzwVIghiiyTeEc3oxT1XxhMytV2qUJxgrbJ-5xzpJjqdMrL51NtlN5V0YqGC8QLC1w0rt1o599OAmHhnbLnKhiOvhoPby_xHy2IE71Kp5_bIll6GzT9WSnL5en1844aHrNQxQtb6Ufm6v95u7aya1sQQL-72N_gxIgvsOpJIzOcexlLX0BVJ-vxjq1dYAxFU0GJjU_tw5VCsJPtS1takm9iS9ex7MMLQBwtJZXYl52exghbNlgNaLNnEFahvhMhdvzR0H7Tp2xROnKH0UE01NJLnwfXK-R64cs8FqIigMF8Qb1vHHA5tAMrwIcwJDRvC0-di1mI2PkuianlY4W-2Un7S39eEdsaInshBMlZUXJxmIaqV4DeEv159yKIYpH282QZsEifDV4xJ4RBkXB-Bet_VNwrSLfJ1jfliIGPVIAKOT8zdAFivWAKOaQa86PGu4yBLa4QqlGbRJOep-9khNC9JZ-EJ5hAF3GAvxvFGK-Q3TjaYdTNB8ktm97UihSJA1bbn_0XLdh1dfsHey_qpcRcQimL4biZiBAl2oPkOeQepHqiyE9nQdNE3rOhTMjaN-2HMrD6mRzyHfZ4swtVvbKkJvbeKYyCYP5ESKFFRGNrHe5sVM-m-wi_MqfKvP1HMi4YSD9bV560R469mUQI838It8LswhUgA"
}
```

#### JSON example 2 (cell C46)

```json
{"respHeader":{"amcCode":"FTA","versionNo":"1.00","rptDateTime":"2025-02-04 12:10:37"},"respBody":{"txnList":[{"itrn":"5101","utrn":"0","itrnTxnType":"Purchase","ordMode":"Physical","can":"XXXXXXXXXX","folio":"FOLIO","schCode":"RTA1","schName":"AXIS","invName":"Investor Name","txnVolType":"","amount":"100.0000","units":"0.0000","estAmt":"0.0000","ordStatus":"","ordTs":"2025-01-31 21:54:30","payDetail":{"payMode":"NEFT","invBnkName":"HDFC","payStatus":"Payment Confirmed","srcAccNo":"100000112","targetAccNo":"10000012234","amcBank":"HDFC","ftrn":"","ftrnTs":"2025-01-31 21:54:30","payStReason":""}}]}}
```

## CHNL-RESP-FEED

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CHNL-RESP-FEED`

### Channel Response Feed Push API

### Table 1

Source cells: `B3:E3`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

This is a channel response feed push service. MFU will iniaite the request to send the data to entity. The entity need to share the Push URL for recevied this transaction response.

For this service, oAuth is mandatory. Entity need to provide the oAuth URL. The oAuth request and repsonse format should be in MFU oAuth Format. For oAuth refer sheet Authorization with OAuth 2.0

### respHeader Section – without encryption JSON Field Details

### Table 2

Source cells: `B7:D8`

| versionNo | Char(5) | Version number for the Web service. The version number is 1.00 |
| --- | --- | --- |
| rptDateTime | Date Time | Channel Response feed push send time stamp. Timestamp format is YYYY-MM-DD HH:MM:SS |

### respHeader Section End

### respBody Section – without encryption JSON Field Details

### txnFeedList Array List Section Start

### Table 3

Source cells: `B12:D43`

| entRefNo | Char(50) | Unique Order Reference Number as provided by the entity when the transaction is submitted. Ideally this number expected to be unique at scheme transaction level within the Entity System. This field will be blank if no such reference number was provided while submitting the transaction.  |
| --- | --- | --- |
| gorn | Char(16) | Unique reference number generated by MFU for each set of transactions (Group Order).  In case of RTA triggered installment order (SWP / STP), this will contain the parent GORN |
| seqNo | Char(2) | Individual Transaction Reference Number shall start with 01, 02 and so on up to 12 as currently configured at MFU for each Order Number. This is a unique number generated by MFU to identify each individual transaction in a Group Order. Please note this number is padded with zero upto 9 (01-09) |
| isInstOrd | Char(1) | Flag to indicate whether the given order is a Systematic Installment order. Valid values are Y or N |
| txnType | Char(1) | Transaction Type.<br>Refer Master Data Sheet for Transaction Type |
| utrn | Number(15) | Unique Transaction Reference Number generated by MFU and maintained by RTAs for every order generated by MFU system.  |
| can | Char(10) | The Common Account Number as allotted by MFU system based on the “Investor combination”  |
| ordTS | Date Time | The Order Timestamp by MFU system. The data will be provided in YYYY-MM-DD hh:mm:ss format.  |
| fndCode | Char(6) | This is the Fund Code as assigned by the RTAs for the Mutual Fund.  |
| rtaSchCode | Char(15) | The code assigned by the RTA for the given Scheme Plan and Option. This code combined with fund code will be identified as product.  |
| reInvFlg | Char(1) | This is the flag to indicate the option chosen by the investor for the Investment. <br>Allowed values are<br> ‘Y’ for Dividend Reinvestment,<br> ‘N’ for Dividend Payout,<br> ‘Z’ for Non-Dividend Schemes.<br>Applicable only for Purchase, Switch-in, SIP<br>and STP-IN. |
| witdrwOpt | Char(1) | Allowed values are as follows for<br>inflow/outflow transactions.<br> A – Amount based outflows and all type of inflows (Units will be zeros)<br> U – Unit Based. (Amount will be zeros)<br> E – All Units (both Amount & Unit will be zeros)<br> F – Fixed (Amount based and Units will be zeros)<br> V – Variable (Both Amount and Units will be Zeros) |
| payMode | Char(2) | This field contains the mode of payment for inflow transaction.  <br>The possible values are:<br>a. NE – NEFT<br>b. RT – RTGS<br>c. OT – Online Transfer<br>d. DM – Debit Mandate (PayEezz) |
| payRefNo | Char(30) | Inflows: Payment reference number as received from bank / Payment Gateway  |
| payStatus | Char(2) | This field contains the current payment status of the inflow transaction. Record will get qualified when the payment status also changes.<br>Refer Master Data Sheet for Payment Status |
| prntGorn | Char(16) | Parent GORN for Installments and Systematic canacellation. |
| prntSeqNo | Char(2) | Parent GORN Sequence number for Installments and Systematic canacellation.  |
| currInsNo | Number(4) | Current installment of the triggered transaction by MFU. Applicable only if field 4 ("Is Installment Order") is 'Y' |
| txnStatus | Char(2) | This field contains the status at the time of Feed generation. <br>The possible values are:<br>OR-   Order Rejected (When Order rejected by MFU)<br>OA – Order Accepted by MFU<br>OR – Order Rejected by MFU<br>SA - Sent to RTA for Accept <br>SR - Sent to RTA as Rejected<br>RA - RTA Accepted<br>RP - RTA Processed<br>RR - RTA Rejected <br>NA - Not Available (this status may come only for Systematic orders without current dated installment / payment) |
| regStatus | Char(2) | Applicable only for Systematic Registration. This field contains the Systematic registration status at the time of feed generation. The possible values are:<br>OR-Order Rejected (When Order rejected by MFU)<br>AC – Registration Accepted (by MFU)<br>RJ – Registration Rejected (by MFU)<br>SA - Sent to RTA for Accept <br>SR - Sent to RTA as Rejected <br>RA - RTA Accepted<br>RP - RTA Processed<br>RR - RTA Rejected <br>RC – Registration Cancelled<br>CR – Registration Cancelled by RTA<br>CE - Registration Ceased |
| rspFolio | Char(21) | Folio Number received (if any) from RTA for the transaction  |
| price | Number(12,4) | Price with which the transaction was processed by respective RTAs  (NAV) |
| rspAmt | Number(18,2) | Actual Amount of the transaction post processing by RTAs  |
| rspUnit | Number(18,2) | Actual Units of the transaction post processing by RTAs  |
| rspValDt | Date | Date of NAV with which the transaction was processed by the RTA, provided in YYYY-MM-DD format |
| rtaRemark | Char(1000) | Remarks (if any) as provided by RTA  |
| arnCode | Char(15) | ARN Code associated in the transaction |
| subArnCode | Char(15) | Sub Broker ARN Code associated in the transaction |
| riaCode | Char(12) | RIA Code associated in the transaction |
| corn | Char(20) | Scheduled transactions Reference number |
| cornSeq | Char(20) | Scheduled transactions sequence number |
| stampAmt | Number(18,2) | RTA Stamp duty amount for In-flow transaction.  |

### txnFeedList Array List Section End

### respBody Section End

### Channel Response Feed Push Sample Response

### Table 4

Source cells: `B49:C51`

| Sample Type | Sample |
| --- | --- |
| Response with Encryption | [See JSON example 1 below] |
| Response withOut Encryption | [See JSON example 2 below] |

### JSON examples

#### JSON example 1 (cell C50)

```json
{"respData":"3Dlv69kqFld9U_p3MLLpL3dfov-pF46nBAm3qGH6W-FC1iIOEbMHreRMts8NvfBuSzSR6RwDAd2LX7lnKQkZIKDZr1Td3RsFJbMbG04LMSZ9ykVNEmFKyobsSnALxJFlb6-Igo1LWu973hNzSUsQ-Mlordx6Y5fJqOsaO2n-t8F37Z7tpIF2sGf0sp6hyIpvmq1AVLTn4ERfbLvy-D6-v4tDdWfHHwqGOzwVIghiiyTeEc3oxT1XxhMytV2qUJxgrbJ-5xzpJjqdMrL51NtlN5V0YqGC8QLC1w0rt1o599OAmHhnbLnKhiOvhoPby_xHy2IE71Kp5_bIll6GzT9WSnL5en1844aHrNQxQtb6Ufm6v95u7aya1sQQL-72N_gxIgvsOpJIzOcexlLX0BVJ-vxjq1dYAxFU0GJjU_tw5VCsJPtS1takm9iS9ex7MMLQBwtJZXYl52exghbNlgNaLNnEFahvhMhdvzR0H7Tp2xROnKH0UE01NJLnwfXK-R64cs8FqIigMF8Qb1vHHA5tAMrwIcwJDRvC0-di1mI2PkuianlY4W-2Un7S39eEdsaInshBMlZUXJxmIaqV4DeEv159yKIYpH282QZsEifDV4xJ4RBkXB-Bet_VNwrSLfJ1jfliIGPVIAKOT8zdAFivWAKOaQa86PGu4yBLa4QqlGbRJOep-9khNC9JZ-EJ5hAF3GAvxvFGK-Q3TjaYdTNB8ktm97UihSJA1bbn_0XLdh1dfsHey_qpcRcQimL4biZiBAl2oPkOeQepHqiyE9nQdNE3rOhTMjaN-2HMrD6mRzyHfZ4swtVvbKkJvbeKYyCYP5ESKFFRGNrHe5sVM-m-wi_MqfKvP1HMi4YSD9bV560R469mUQI838It8LswhUgA"}
```

#### JSON example 2 (cell C51)

```json
{"respHeader":{"versionNo":"1.00","rptDateTime":"2025-02-04 09:30:29"},"respBody":{"txnFeedList ":[{"entRefNo":"XXXXXXXXX","gorn":"XXXXXXXX","seqNo":"01","isInstOrd":"N","txnType":"V","utrn":"0","can":"XXXXXXXXXX","ordTS":"2025-01-31 21:07:48","fndCode":"MAF","rtaSchCode":"EBRGG","reInvFlg":"Z","witdrwOpt":"A","payMode":"DM","payRefNo":"","payStatus":"CR","prntGorn":"XXXXXXXXXXXXXXXXXX","prntSeqNo":"01","currInsNo":"35","txnStatus":"RP","regStatus":"NA","rspFolio":"7776285685","price":"133.4230","rspAmt":"999.95","rspUnit":"7.4950","rspValDt":"2025-01-27","rtaRemark":"","arnCode":"","subArnCode":"","riaCode":"","corn":"","cornSeq":"","stampAmt":""}]}}
```

## SCHEME-PUSH

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `SCHEME-PUSH`

### Scheme Push API

### Table 1

Source cells: `B3:E3`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

This is a scheme push service. MFU will iniaite the request to send the data to entity. The entity need to share the Push URL to recevied this transaction response.

For this service, oAuth is not mandatory. If Entity need oAuth,They should provide the oAuth URL. The oAuth request and repsonse format should be in MFU oAuth Format. For oAuth refer sheet Authorization with OAuth 2.0

### respHeader Section – without encryption JSON Field Details

### Table 2

Source cells: `B7:D8`

| versionNo | Char(5) | Version number for the Web service. The version number is 1.00 |
| --- | --- | --- |
| rptDateTime | Date Time | Channel Response feed push send time stamp. Timestamp format is YYYY-MM-DD HH:MM:SS |

### respHeader Section End

### respBody Section – without encryption

### Table 3

Source cells: `B11:D11`

| type | Char(15) | ​Scheme Push Type. Type contains the following values:<br>Scheme<br>Threshold<br>Based on type, the detail section structure​ will be different. |
| --- | --- | --- |

### detail  section JSON Field Start For Scheme

### Table 4

Source cells: `B13:D41`

| schemeCode | Char(15) | The code assigned by the RTA for the given Scheme Plan and Option This combined with the FundCode shall be unique. |
| --- | --- | --- |
| fundCode | Char(6) | This is the Fund Code as assigned by the RTAs for the Mutual Fund. This field combined with the schemeCode shall be unique. |
| planName | Char(200) | The Name of the Scheme Plan as maintained at MFU |
| schemeType | Char(3) | The Type of the Scheme.<br>The possible values are:<br>OE – Open Ended<br>CE – Closed Ended<br>IN – Interval Schemes |
| planType | Char(6) | The type of the Plan.<br>The possible values are:<br>DIR – Direct Plan<br>REG – Regular Plan<br>RET – Retail Plan<br>INST – Institutional Plan<br>SINST – Super Institutional Plan |
| divOpt | Char(6) | The Dividend Reinvestment options supported at the Scheme Plan level.<br>The possible values are:<br>PAYOUT – Dividend Payout Option<br>REINV – Dividend Reinvestment Option<br>BOTH – Supports both Payout and Reinvestment the options<br>NA – Not Applicable (In case of Growth / Bonus Plans) |
| amfiId | Char(15) | The Scheme ID as maintained by AMFI |
| priIsin | Char(12) | The Primary ISIN Key of the scheme plan.<br>Note: When divOpt is ‘Both’ then this ISIN is for Payout. |
| secIsin | Char(12) | The Secondary ISIN Key of the scheme plan.<br>Note: When divOpt is ‘Both’ then this ISIN is for Re-Investment. |
| nfoStart | Char(11) | NFO Start date for the scheme plan. The date format is YYYY-MM-DD. |
| nfoEnd | Char(11) | NFO End date for the scheme plan. The date format is YYYY-MM-DD. |
| allotDate | Char(11) | Allotment date for the scheme plan. The date format is YYYY-MM-DD. |
| reopenDate | Char(11) | Re-Open date for the scheme plan. The date format is YYYY-MM-DD. |
| maturityDate | Char(11) | Maturity date for the scheme plan. The date format is YYYY-MM-DD. |
| entryLoad | Char(1000) | Entry Load for the Scheme Plan |
| exitLoad | Char(1000) | Exit Load for the Scheme Plan |
| purAllowed | Char(1) | Flag to indicate whether Purchase Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No |
| nfoAllowed | Char(1) | Flag to indicate whether NFO Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No |
| redeemAllowed | Char(1) | Flag to indicate whether Redemption Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No |
| sipAllowed | Char(1) | Flag to indicate whether SIP Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No |
| switchOutAllowed | Char(1) | Flag to indicate whether Switch Out Transactions are permissible for the scheme plan. <br>Refer Master Data Sheet for Category ID Yes/No |
| switchInAllowed | Char(1) | Flag to indicate whether Switch In Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No |
| stpOutAllowed | Char(1) | Flag to indicate whether STP Out Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No |
| stpInAllowed | Char(1) | Flag to indicate whether STP In Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No |
| swpAllowed | Char(1) | Flag to indicate whether SWP Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No |
| dematAllowed | Char(1) | Flag to indicate whether the units can be allotted in DEMAT mode for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No |
| catgId | Char(2) | Flag to indicate the category type for the scheme Plan. Contains one of the following values.<br>Refer Master Data Sheet for Category ID |
| subCatgId | Char(2) | Flag to indicate the Sub-category type within the main category for the scheme Plan.<br>Refer Master Data Sheet for Sub Category ID |
| schemeFlag | Char(2) | Flag to indicate the whether the scheme is active or not.<br>The possible values are:<br>AC – Active<br>SU – Suspended |

### detail  section JSON Field End For Scheme

### detail  section JSON Field Start for Threshold

### schemeList Array List Section Start

### Table 5

Source cells: `B45:D61`

| fundCode | Char (6) | This is the Fund Code as assigned by the RTAs for the Mutual Fund. This field combined with the schemeCode shall be unique. |
| --- | --- | --- |
| schemeCode | Char (15) | The code assigned by the RTA for the given Scheme Plan and Option This combined with the fundCode shall be unique. |
| txnType | Char (1) | Transaction Type.<br>Refer Master Data Sheet for Transaction Type |
| sysFreq | Char (1) | The Frequency in case of Systematic Transactions. Contains one of the following:<br>Refer Master Data Sheet for Frequency<br>In case of Non-Systematic Transactions, this field will contain the value ‘D’ |
| sysFreqOpt | Char (1) | Flag to indicate the date option for the Systematic Transaction.<br>The possible values are:<br>A – Any Date<br>S – Specific Date<br>May contain empty values also in certain cases. |
| sysDates | Char (50) | The permissible dates for systematic transactions by the Fund, for the scheme, for the Systematic Transaction Type. For normal transactions, this input shall be specified as Blank. Applicable only for Systematic transaction types, if the Systematic Transaction Date option is provided as 'S'. <br>1. For Daily Frequency, the dates shall not be specified. <br>2. For Weekly DAY based Frequency, this column shall have values from 1-5, denoting 1-Monday, 2-Tuesday...,5-Friday. <br>3. For Weekly DATE based Frequency, this column shall have the values of the date sets each separated by a comma (,) as shown below:<br> "1,8,15,22/3,10,17,24/5,12,19,27" and so on<br>4. For Fortnightly Frequency, this column shall be provided with the list of pair of dates, with each pair of dates separated by a semi colon (;), within which each date separated by a comma (,) as shown below:<br>"1,16;5,20;7,29"<br>5. For other frequencies, the respective dates shall be specified each separated by a slash (/). <br>For example, "2/8/15/24", "5/10/15/25" etc. <br>If there is a configuration for the Last Working Date, the same shall be specified as "LD" along with the other transaction dates. |
| minAmt | Numeric (20,4) | Minimum Scheme Threshold in amount |
| maxAmt | Numeric (20,4) | Maximum Scheme Threshold in amount |
| multipleAmt | Numeric (20,4) | Threshold for Amount in multiples beyond the minimum threshold |
| minUnits | Numeric (20,4) | Minimum scheme threshold in units |
| mulUnits | Numeric (20,4) | Multiple scheme threshold in units |
| minInst | Numeric (5,0) | Minimum number of installments for Systematic transactions |
| maxInst | Numeric (5,0) | Maximum number of installments for Systematic transactions |
| sysPerpetual | Char (1) | Flag to indicate whether perpetual Systematic setup is permissible. Contains Y / N |
| minCumAmt | Numeric (20,4) | Minimum cumulative amount (all installments put together) for Systematic transactions |
| startDate | Char (11) | The effective start date for the threshold setting. The date format is YYYY-MM-DD. |
| endDate | Char (11) | The effective end date for the threshold setting. The date format is YYYY-MM-DD. |

### schemeList Array List Section End

### detail  section JSON Field End for Threshold

### Scheme Push API Sample Response

### Table 6

Source cells: `B67:C70`

| Sample Type | Sample |
| --- | --- |
| Response with Encryption | [See JSON example 1 below] |
| Response For SMF withOut Encryption | [See JSON example 2 below] |
| Response For STD withOut Encryption | [See JSON example 3 below] |

### JSON examples

#### JSON example 1 (cell C68)

```json
{"respData":"3Dlv69kqFld9U_p3MLLpL3dfov-pF46nBAm3qGH6W-FC1iIOEbMHreRMts8NvfBuSzSR6RwDAd2LX7lnKQkZIKDZr1Td3RsFJbMbG04LMSZ9ykVNEmFKyobsSnALxJFlb6-Igo1LWu973hNzSUsQ-Mlordx6Y5fJqOsaO2n-t8F37Z7tpIF2sGf0sp6hyIpvmq1AVLTn4ERfbLvy-D6-v4tDdWfHHwqGOzwVIghiiyTeEc3oxT1XxhMytV2qUJxgrbJ-5xzpJjqdMrL51NtlN5V0YqGC8QLC1w0rt1o599OAmHhnbLnKhiOvhoPby_xHy2IE71Kp5_bIll6GzT9WSnL5en1844aHrNQxQtb6Ufm6v95u7aya1sQQL-72N_gxIgvsOpJIzOcexlLX0BVJ-vxjq1dYAxFU0GJjU_tw5VCsJPtS1takm9iS9ex7MMLQBwtJZXYl52exghbNlgNaLNnEFahvhMhdvzR0H7Tp2xROnKH0UE01NJLnwfXK-R64cs8FqIigMF8Qb1vHHA5tAMrwIcwJDRvC0-di1mI2PkuianlY4W-2Un7S39eEdsaInshBMlZUXJxmIaqV4DeEv159yKIYpH282QZsEifDV4xJ4RBkXB-Bet_VNwrSLfJ1jfliIGPVIAKOT8zdAFivWAKOaQa86PGu4yBLa4QqlGbRJOep-9khNC9JZ-EJ5hAF3GAvxvFGK-Q3TjaYdTNB8ktm97UihSJA1bbn_0XLdh1dfsHey_qpcRcQimL4biZiBAl2oPkOeQepHqiyE9nQdNE3rOhTMjaN-2HMrD6mRzyHfZ4swtVvbKkJvbeKYyCYP5ESKFFRGNrHe5sVM-m-wi_MqfKvP1HMi4YSD9bV560R469mUQI838It8LswhUgA"}
```

#### JSON example 2 (cell C69)

```json
{  "respHeader": {    "rptDateTime": "2025-09-25 16:01:05",    "versionNo": "1.00"  },  "respBody": {    "type": "Scheme",    "detail": {      "exchangeId": "",      "txnType": "",      "fundCode": "FTI",      "schemeCode": "414",      "planName": "Franklin INFOTECH FUND - Direct-DIRECT-DIVIDEND",      "schemeType": "OE",      "planType": "DIR",      "divOpt": "REINV",      "sysFreq": "",      "sysFreqOpt": "",      "sysDates": "",      "txnMinAmount": "",      "txnMaxAmount": "",      "txnMulAmount": "",      "txnMinUnits": "",      "txnMulUnits": "",      "minInst": "",      "maxInst": "",      "sysPerpetual": "",      "minCumAmt": "",      "startDate": "",      "endDate": "",      "amfiId": "118536",      "priIsin": "INF090I01FG1",      "secIsin": "INF090I01FF3",      "nfoStart": "2019-04-19",      "nfoEnd": "2025-04-20",      "allotDate": "2025-05-02",      "reopenDate": "2025-05-03",      "maturityDate": "1900-01-01",      "entryLoad": "",      "exitLoad": "",      "purAllowed": "Y",      "nfoAllowed": "N",      "redeemAllowed": "Y",      "sipAllowed": "Y",      "switchOutAllowed": "Y",      "switchInAllowed": "Y",      "stpOutAllowed": "Y",      "stpInAllowed": "Y",      "swpAllowed": "Y",      "dematAllowed": "Y",      "catgId": "1",      "subCatgId": "3",      "schemeFlag": "AC"    }  }}
```

#### JSON example 3 (cell C70)

```json
{  "respHeader": {    "rptDateTime": "2025-09-24 10:15:50",    "versionNo": "1.00"  },  "respBody": {    "type": "Threshold",    "detail": {      "schemeList": [        {          "fundCode": "FTI",          "schemeCode": "414",          "txnType": "A",          "sysFreq": "",          "sysFreqOpt": "",          "sysDates": "",          "minAmt": "5.0000",          "maxAmt": "99999.0000",          "multipleAmt": "5.0000",          "minUnits": "0.0000",          "mulUnits": "0.0000",          "minInst": "0",          "maxInst": "0",          "sysPerpetual": "",          "minCumAmt": "0.0000",          "startDate": "2013-01-02",          "endDate": "2099-12-31"        }      ]    }  }}
```

## ORDER-UTILITY

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `ORDER-UTILITY`

### Order Utility Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechOrderUtilityService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be ORDER-UTILITY | Char(20) | Yes | ORDER-UTILITY | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:F9`

| reqType | Request Type | Char(1) | Yes | Allowed Values:<br>T - Link Retrigger<br>C - Order Cancellation |
| --- | --- | --- | --- | --- |
| mfuGorn | MFU System Group Order Reference Number | Char(16) | Yes |  |

### Order Utility Service API – Response

### Table 4

Source cells: `B13:D13`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B15:D18`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure. | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respHeader Section End

### Order Utility Service API – Sample Request and Response

### Table 6

Source cells: `B23:C28`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

### JSON examples

#### JSON example 1 (cell C24)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "ORDER-UTILITY","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C25)

```json
{
"reqType":"","mfuGorn":""
}
```

#### JSON example 3 (cell C26)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 4 (cell C27)

```json
{"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""}}
```

#### JSON example 5 (cell C28)

```json
{"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"}}
```

## SCHSTSCHK

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `SCHSTSCHK`

### Scheme Status Check Service API – Request

### URL  to Invoke this API : https://<UAT or PROD URL>/APIFinTechSchemeStatusChkService

### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

### reqHeader Section - Refer Request Header Detail Sheet

### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be SCHSTSCHK | Char(20) | Yes | SCHSTSCHK | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

### reqBody Section –  JSON Field Details

### Table 3

Source cells: `B8:G11`

| rtaSchCode | RTA Scheme Code | Char(6) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| rtaAmcCode | RTA AMC Code | Char(6) | Yes |  |  |
| actionType | Action Type | Char(3) | Yes | SMF<br>STD |  |
| txnType | Transaction Type | Char(1) | Conditional mandatory | N - Normal Transaction<br>S - Systematic Transaction | txnType is mandatory when actionType is "STD", otherwise it should be empty. |

### Scheme Status Check Service API – Response

### Table 4

Source cells: `B15:D15`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

### respHeader Section –  JSON Field Details

### Table 5

Source cells: `B17:D20`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

### respBody Section –  JSON Field Details For SMF

### Table 6

Source cells: `B22:D50`

| schemeCode | The code assigned by the RTA for the given Scheme Plan and Option This combined with the FundCode shall be unique. | Char(15) |
| --- | --- | --- |
| fundCode | This is the Fund Code as assigned by the RTAs for the Mutual Fund. This field combined with the schemeCode shall be unique. | Char(6) |
| planName | The Name of the Scheme Plan as maintained at MFU | Char(200) |
| schemeType | The Type of the Scheme.<br>The possible values are:<br>OE – Open Ended<br>CE – Closed Ended<br>IN – Interval Schemes | Char(3) |
| planType | The type of the Plan.<br>The possible values are:<br>DIR – Direct Plan<br>REG – Regular Plan<br>RET – Retail Plan<br>INST – Institutional Plan<br>SINST – Super Institutional Plan | Char(6) |
| divOpt | The Dividend Reinvestment options supported at the Scheme Plan level.<br>The possible values are:<br>PAYOUT – Dividend Payout Option<br>REINV – Dividend Reinvestment Option<br>BOTH – Supports both Payout and Reinvestment the options<br>NA – Not Applicable (In case of Growth / Bonus Plans) | Char(6) |
| amfiId | The Scheme ID as maintained by AMFI | Char(15) |
| priIsin | The Primary ISIN Key of the scheme plan.<br>Note: When divOpt is ‘Both’ then this ISIN is for Payout. | Char(12) |
| secIsin | The Secondary ISIN Key of the scheme plan.<br>Note: When divOpt is ‘Both’ then this ISIN is for Re-Investment. | Char(12) |
| nfoStart | NFO Start date for the scheme plan. The date format is YYYY-MM-DD. | Char(11) |
| nfoEnd | NFO End date for the scheme plan. The date format is YYYY-MM-DD. | Char(11) |
| allotDate | Allotment date for the scheme plan. The date format is YYYY-MM-DD. | Char(11) |
| reopenDate | Re-Open date for the scheme plan. The date format is YYYY-MM-DD. | Char(11) |
| maturityDate | Maturity date for the scheme plan. The date format is YYYY-MM-DD. | Char(11) |
| entryLoad | Entry Load for the Scheme Plan | Char(1000) |
| exitLoad | Exit Load for the Scheme Plan | Char(1000) |
| purAllowed | Flag to indicate whether Purchase Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No | Char(1) |
| nfoAllowed | Flag to indicate whether NFO Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No | Char(1) |
| redeemAllowed | Flag to indicate whether Redemption Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No | Char(1) |
| sipAllowed | Flag to indicate whether SIP Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No | Char(1) |
| switchOutAllowed | Flag to indicate whether Switch Out Transactions are permissible for the scheme plan. <br>Refer Master Data Sheet for Category ID Yes/No | Char(1) |
| switchInAllowed | Flag to indicate whether Switch In Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No | Char(1) |
| stpOutAllowed | Flag to indicate whether STP Out Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No | Char(1) |
| stpInAllowed | Flag to indicate whether STP In Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No | Char(1) |
| swpAllowed | Flag to indicate whether SWP Transactions are permissible for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No | Char(1) |
| dematAllowed | Flag to indicate whether the units can be allotted in DEMAT mode for the scheme plan.<br>Refer Master Data Sheet for Category ID Yes/No | Char(1) |
| catgId | Flag to indicate the category type for the scheme Plan. Contains one of the following values.<br>Refer Master Data Sheet for Category ID | Char(2) |
| subCatgId | Flag to indicate the Sub-category type within the main category for the scheme Plan. Contains one of the following values. <br>Refer Master Data Sheet for Sub Category ID | Char(2) |
| schemeFlag | Flag to indicate the whether the scheme is active or not.<br>The possible values are:<br>AC – Active<br>SU – Suspended | Char(2) |

### respBody Section End For SMF

### respBody Section – without encryption JSON Field Details For STD

### schemeList Array List Section Start

### Table 7

Source cells: `B54:D70`

| fundCode | This is the Fund Code as assigned by the RTAs for the Mutual Fund. This field combined with the schemeCode shall be unique. | Char (6) |
| --- | --- | --- |
| schemeCode | The code assigned by the RTA for the given Scheme Plan and Option This combined with the fundCode shall be unique. | Char (15) |
| txnType | Transaction Type.<br>Refer Master Data Sheet for Transaction Type | Char (1) |
| sysFreq | The Frequency in case of Systematic Transactions. Contains one of the following:<br>Refer Master Data Sheet for Frequency<br>In case of Non-Systematic Transactions, this field will contain the value ‘D’ | Char (1) |
| sysFreqOpt | Flag to indicate the date option for the Systematic Transaction.<br>The possible values are:<br>A – Any Date<br>S – Specific Date<br>May contain empty values also in certain cases. | Char (1) |
| sysDates | The permissible dates for systematic transactions by the Fund, for the scheme, for the Systematic Transaction Type. For normal transactions, this input shall be specified as Blank. Applicable only for Systematic transaction types, if the Systematic Transaction Date option is provided as 'S'. <br>1. For Daily Frequency, the dates shall not be specified. <br>2. For Weekly DAY based Frequency, this column shall have values from 1-5, denoting 1-Monday, 2-Tuesday...,5-Friday. <br>3. For Weekly DATE based Frequency, this column shall have the values of the date sets each separated by a comma (,) as shown below:<br> "1,8,15,22/3,10,17,24/5,12,19,27" and so on<br>4. For Fortnightly Frequency, this column shall be provided with the list of pair of dates, with each pair of dates separated by a semi colon (;), within which each date separated by a comma (,) as shown below:<br>"1,16;5,20;7,29"<br>5. For other frequencies, the respective dates shall be specified each separated by a slash (/). <br>For example, "2/8/15/24", "5/10/15/25" etc. <br>If there is a configuration for the Last Working Date, the same shall be specified as "LD" along with the other transaction dates. | Char (50) |
| minAmt | Minimum Scheme Threshold in amount | Numeric (20,4) |
| maxAmt | Maximum Scheme Threshold in amount | Numeric (20,4) |
| multipleAmt | Threshold for Amount in multiples beyond the minimum threshold | Numeric (20,4) |
| minUnits | Minimum scheme threshold in units | Numeric (20,4) |
| mulUnits | Multiple scheme threshold in units | Numeric (20,4) |
| minInst | Minimum number of installments for Systematic transactions | Numeric (5,0) |
| maxInst | Maximum number of installments for Systematic transactions | Numeric (5,0) |
| sysPerpetual | Flag to indicate whether perpetual Systematic setup is permissible. Contains Y / N | Char (1) |
| minCumAmt | Minimum cumulative amount (all installments put together) for Systematic transactions | Numeric (20,4) |
| startDate | The effective start date for the threshold setting. The date format is YYYY-MM-DD. | Char (11) |
| endDate | The effective end date for the threshold setting. The date format is YYYY-MM-DD. | Char (11) |

### schemeList Array List Section End

### respBody Section End  For STD

### Scheme Status Check Service API – Sample Request and Response

### Table 8

Source cells: `B76:C84`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption for SMF | [See JSON example 2 below] |
| Request body without Encryption for STD | [See JSON example 3 below] |
| Response with Encryption | [See JSON example 4 below] |
| Response body without Encryption for SMF | [See JSON example 5 below] |
| Response body without Encryption for STD | [See JSON example 6 below] |
| Failure Response withOut Encryption For SMF | [See JSON example 7 below] |
| Failure Response withOut Encryption For STD | [See JSON example 8 below] |

### JSON examples

#### JSON example 1 (cell C77)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "SCHSTSCHK","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

#### JSON example 2 (cell C78)

```json
{"rtaSchCode":"123456","rtaAmcCode":"AXF","actionType":"SMF","txnType":""}
```

#### JSON example 3 (cell C79)

```json
{"rtaSchCode":"123456","rtaAmcCode":"AXF","actionType":"STD","txnType":"N"}
```

#### JSON example 4 (cell C80)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

#### JSON example 5 (cell C81)

```json
{"respHeader":{"respFlag":"S","respTs":"2025-03-13 10:48:19","errorCode":"","errorMsg":""},"respBody":{"schemeCode":"REQ","fundCode":"RMF   ","planName":"Reliance Equity Scheme DIR Plan GR NA","schemeType":"IN","planType":"DIR","divOpt":"NA","amfiId":"105265","priIsin":"ISIN12345680","secIsin":"            ","nfoStart":"2012-10-10","nfoEnd":"2012-10-20","allotDate":"2012-10-30","reopenDate":"2012-11-01","maturityDate":"3000-12-31","entryLoad":"","exitLoad":"","purAllowed":"Y","nfoAllowed":"N","redeemAllowed":"Y","sipAllowed":"N","switchOutAllowed":"N","switchInAllowed":"N","stpOutAllowed":"N","stpInAllowed":"N","swpAllowed":"N","dematAllowed":"Y","catgId":"1","subCatgId":"3","schemeFlag":"AC","planOpt":"GR    "}}
```

#### JSON example 6 (cell C82)

```json
{"respHeader":{"respFlag":"S","respTs":"2025-03-12 19:24:59","errorCode":"","errorMsg":""},"respBody":{"sysTxnDtl":[{"fundCode":"FTI","schemeCode":"046","txnType":"I","sysFreq":" ","sysFreqOpt":" ","sysDates":" ","minInst":"0","maxInst":"0","sysPerpetual":" ","minCumAmt":"0.0000","startDate":"2023-05-15","endDate":"2023-06-15","minAmt":"0.0000","maxAmt":"9999999999999.9900","multipleAmt":"0.0000","minUnits":"0.0000","multipleUnits":"0.0000"},{"fundCode":"FTI","schemeCode":"046","txnType":"N","sysFreq":" ","sysFreqOpt":" ","sysDates":" ","minInst":"0","maxInst":"0","sysPerpetual":" ","minCumAmt":"0.0000","startDate":"2023-05-15","endDate":"2023-06-15","minAmt":"0.0000","maxAmt":"9999999999999.9900","multipleAmt":"0.0000","minUnits":"0.0000","multipleUnits":"0.0000"}]}}
```

#### JSON example 7 (cell C83)

```json
{"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"schemeCode":"","fundCode":"","planName":"","schemeType":"","planType":"","divOpt":"","amfiId":"","priIsin":"","secIsin":"","nfoStart":"","nfoEnd":"","allotDate":"","reopenDate":"","maturityDate":"","entryLoad":"","exitLoad":"","purAllowed":"","nfoAllowed":"","redeemAllowed":"","sipAllowed":"","switchOutAllowed":"","switchInAllowed":"","stpOutAllowed":"","stpInAllowed":"","swpAllowed":"","dematAllowed":"","catgId":"","subCatgId":"","schemeFlag":"","planOpt":""}
```

#### JSON example 8 (cell C84)

```json
{"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"sysTxnDtl":[]}
```

## ERROR CODE

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `ERROR CODE`

### General Error Codes

### Table 1

Source cells: `B3:C364`

| Error Code | Error Message |
| --- | --- |
| 1 | Your not authorized to access this facility |
| 2 | System Error. Kindly Retry. |
| 100001 | Invalid Request Details |
| 100003 | You are not authorized to access this facility |
| 100004 | An internal error occurred. Please try again later |
| 100006 | Authorization Token is invalid |
| 100007 | Token validity peroid is expired |
| 100009 | API Entity is not OAuth enabled |
| 100042 | encryptPwd is invalid |
| 100033 | version is required |
| 100034 | Invalid version number |
| 100035 | reqTS is required |
| 100037 | apiType is required |
| 100039 | userId is required |
| 100038 | apiType is Invalid |
| 100040 | userId is invalid |
| 100041 | encryptPwd is required |
| 100043 | uniqueId is required |
| 100044 | uniqueId is invalid |
| 100045 | Entity unique id is duplicated |
| 100400 | txnType is required |
| 100401 | Invalid txnType |
| 100402 | extRefNo is required |
| 100403 | Invalid extRefNo |
| 100404 | extRefNo length should be less than 50 characters |
| 100405 | CAN is required |
| 100406 | Invalid CAN |
| 100407 | entityId is required |
| 100408 | Invalid entityId |
| 100409 | arnCode is required |
| 100410 | arnCode is invalid |
| 100411 | subArnCode Should be empty for RIA Entity |
| 100412 | subArnCode format is invalid |
| 100413 | euin format is invalid |
| 100414 | subBrokCode is invalid |
| 100415 | branchRMIntCode is invalid |
| 100416 | mfuUtrn is required |
| 100417 | mfuUtrn is invalid |
| 100418 | mfuUtrn should be empty |
| 100419 | rtaAmcCode is required |
| 100420 | Invalid rtaAmcCode |
| 100421 | rtaSchCode is required |
| 100422 | Invalid rtaSchCode |
| 100423 | outRtaSchCode is required |
| 100424 | outRtaSchCode is invalid |
| 100425 | outRtaSchCode should be empty |
| 100426 | folio is required |
| 100427 | Invalid folio |
| 100428 | divOpt is required |
| 100429 | divOpt is invalid |
| 100430 | divOpt should be empty |
| 100431 | txnVolTyp is required |
| 100432 | txnVolTyp is invalid |
| 100433 | txnVolTyp is invalid |
| 100434 | payOutFlag is required |
| 100435 | payOutFlag is invalid |
| 100436 | payOutFlag should be empty |
| 100437 | invAccNo is required |
| 100438 | invAccNo is invalid |
| 100439 | invAccNo should be empty |
| 100440 | micr is required |
| 100441 | micr is invalid |
| 100442 | micr should be empty |
| 100443 | ifsc is required |
| 100444 | ifsc is invalid |
| 100445 | ifsc should be empty |
| 100456 | priOtpFlag is required |
| 100457 | priOtpFlag is invalid |
| 100448 | priOtpFlag should be empty |
| 100449 | priMob is required |
| 100450 | priMob is invalid |
| 100451 | priMob should be empty |
| 100452 | priEmail is required |
| 100453 | priEmail is invalid |
| 100454 | priEmail should be empty |
| 100455 | dpSecFlag is required |
| 100456 | dpSecFlag is invalid |
| 100457 | dpSecFlag should be empty |
| 100458 | dpType is required |
| 100459 | dpType is invalid |
| 100460 | dpType should be empty |
| 100461 | dpAccNo is required |
| 100462 | dpAccNo is invalid |
| 100463 | dpAccNo should be empty |
| 100464 | paySecFlag is required |
| 100465 | paySecFlag is invalid |
| 100466 | paySecFlag should be empty |
| 100467 | bnkId is required |
| 100468 | bnkId is invalid |
| 100469 | bnkId should be empty |
| 100470 | accNo is required |
| 100471 | accNo is invalid |
| 100472 | accNo should be empty |
| 100473 | payDate is required |
| 100474 | payDate should be empty |
| 100475 | beneVan is required |
| 100476 | beneVan is invalid |
| 100477 | beneVan should be empty |
| 100478 | paymentBankRefNo is required |
| 100479 | paymentBankRefNo is invalid |
| 100480 | paymentBankRefNo should be empty |
| 100481 | paymentConfirmTs is required |
| 100482 | paymentConfirmTs should be empty |
| 100483 | amcPaymentTs is required |
| 100484 | amcPaymentTs should be empty |
| 100485 | mandateRefNo is required |
| 100486 | mandateRefNo is invalid |
| 100487 | mandateRefNo should be empty |
| 100488 | deviceType is required |
| 100489 | deviceType is invalid |
| 100490 | custIpAddress is required |
| 100491 | custIpAddress is invalid |
| 100492 | entGroupRefNo is required |
| 100493 | entGroupRefNo is invalid |
| 100494 | entGroupRefNo length should be less than 50 characters |
| 100495 | reqType is required |
| 100496 | reqType is invalid |
| 100497 | riaCode is required |
| 100498 | riaCode is invalid |
| 100499 | riaCode should be 9 numeric characters |
| 100500 | payMode is required |
| 100501 | payMode is invalid |
| 100502 | schList is required |
| 100503 | schList size should not be greater than 12 |
| 100504 | orderMode is required |
| 100505 | orderMode is invalid |
| 100506 | For orderMode X, txnType is invalid |
| 100507 | riaCode Should be empty for Distributors |
| 100508 | arnCode Should be empty for RIA Entity |
| 100509 | Either of riaCode or arnCode is only required |
| 100510 | For riaCode , EUIN Code should be empty |
| 100511 | euin is required |
| 100511 | euinDeclaration is required |
| 100511 | euinDeclaration should be empty |
| 100512 | checkDigit should not be greater 2 digits |
| 100513 | checkDigit is invalid |
| 100512 | payDate format is invalid |
| 100513 | in payDate future date is not allowed |
| 100512 | paymentConfirmTs format is invalid |
| 100513 | paymentConfirmTs future date is not allowed |
| 100512 | amcPaymentTs format is invalid |
| 100513 | amcPaymentTs future date is not allowed |
| 100514 | totAmt is required |
| 100515 | totAmt should not be zero |
| 100516 | totAmt limit exceeded |
| 100517 | Only 2 decimals are allowed for totAmt |
| 100518 | totAmt is invalid |
| 100519 | vol is required |
| 100520 | vol should not be zero |
| 100521 | vol limit exceeded |
| 100522 | only 2 decimals are allowed for vol |
| 100523 | vol is invalid |
| 100524 | only 3 decimals are allowed for vol |
| 100525 | payMode should be empty |
| 100526 | entUnqItrn is required |
| 100527 | entUnqItrn is invalid |
| 100528 | mfuGorn is required |
| 100529 | mfuGorn is invalid |
| 100530 | apprUsrPan is required |
| 100531 | apprUsrPan is invalid |
| 100532 | apprUsrIP is required |
| 100533 | apprUsrIP is invalid |
| 100534 | apprUsrLogTs is required |
| 100535 | apprUsrLogTs is invalid |
| 100536 | apprRejFlag is required |
| 100537 | apprRejFlag is invalid |
| 100538 | rejReason is required |
| 100539 | rejReason length should not be greater than 250 |
| 100540 | canType is required |
| 100541 | canType is invalid |
| 100542 | txnEvent is required |
| 100543 | txnEvent is invalid |
| 100544 | txnEvent should be empty |
| 100545 | autoApprRemarks is required |
| 100546 | autoApprRemarks length should not be greater than 250 |
| 100547 | autoApprRemarks should be empty |
| 100548 | schPayFlag is required |
| 100549 | schPayFlag is invalid |
| 100550 | schPayFlag should be empty |
| 100551 | schPaySec should be empty |
| 100552 | payType is required |
| 100553 | payType is invalid |
| 100554 | payRefNo is required |
| 100555 | payRefNo is invalid |
| 100556 | srcMicrNo is required |
| 100557 | srcMicrNo is invalid |
| 100558 | srcIfscNo is required |
| 100559 | srcIfscNo is invalid |
| 100560 | srcInvAccType is required |
| 100561 | srcInvAccType is invalid |
| 100562 | srcInvAccType cannot be greater than 4 characters |
| 100563 | srcInvAccNo is required |
| 100564 | srcInvAccNo is invalid |
| 100565 | targetMicrNo is required |
| 100566 | targetMicrNo is invalid |
| 100567 | targetIfscNo is required |
| 100568 | targetIfscNo is invalid |
| 100569 | targetInvAccType is required |
| 100570 | targetInvAccType is invalid |
| 100571 | targetInvAccType cannot be greater than 4 characters |
| 100572 | targetInvAccNo is required |
| 100573 | targetInvAccNo is invalid |
| 100574 | directTranToAmcFlag is required |
| 100575 | directTranToAmcFlag is invalid |
| 100576 | directTranToAmcFlag should be empty |
| 100577 | accType is required |
| 100578 | accType is invalid |
| 100579 | accType should be empty |
| 100580 | accType cannot be greater than 4 characters |
| 100597 | schPayFlag should be N when directTranToAmcFlag is N |
| 100598 | schPayFlag should be Y when directTranToAmcFlag is Y |
| 100599 | payAmt is required |
| 100600 | payAmt should not be zero |
| 100601 | payAmt limit exceeded |
| 100602 | Only 2 decimals are allowed for payAmt |
| 100603 | payAmt is invalid |
| 100604 | Payment Amount and total amount should be same |
| 100605 | payAmt should be empty |
| 100606 | srcBnkId is required |
| 100607 | srcBnkId is invalid |
| 100608 | targetBnkId is required |
| 100609 | targetBnkId is invalid |
| 100610 | rejReason should be empty |
| 100611 | In apprUsrLogTs, Future Date Time is not allowed |
| 100612 | subBrokCode should be empty for RIA Entity |
| 100613 | branchRMIntCode should be empty for RIA Entity |
| 100619 | More than 12 schemes not allowed for Requested transaction |
| 100581 | pan is required |
| 100582 | pan is invalid |
| 100583 | dob is required |
| 100584 | dob is invalid |
| 100585 | resdStatus is required |
| 100586 | resdStatus is invalid |
| 100587 | modeOfHld is required |
| 100588 | modeOfHld is invalid |
| 100589 | holder2PanNo is required |
| 100590 | holder2PanNo is invalid |
| 100591 | holder3PanNo is required |
| 100592 | holder3PanNo is invalid |
| 100593 | holder2DOB is required |
| 100594 | holder2DOB is invalid |
| 100595 | holder3DOB is required |
| 100596 | holder3DOB is invalid |
| 100615 | holder2PanNo should be empty |
| 100616 | dob should not be greater than Current Date |
| 100617 | holder2DOB should not be greater than Current Date |
| 100618 | holder3DOB should not be greater than Current Date |
| 100619 | More than 12 schemes not allowed for Requested transaction |
| 100620 | frequency is required |
| 100622 | scheme day is required |
| 100623 | startMonth is required |
| 100624 | startYear is required |
| 100625 | endMonth is required |
| 100626 | endYear is required |
| 100627 | scheme's day is invalid |
| 100628 | startMonth is invalid |
| 100629 | startYear is invalid |
| 100630 | endMonth is invalid |
| 100631 | endYear is invalid |
| 100632 | subSeqPayFlag is required |
| 100633 | subSeqPayFlag is invalid |
| 100634 | payMode is required |
| 100635 | payMode is invalid |
| 100636 | invAccType is required |
| 100637 | invAccType is invalid |
| 100638 | invAccNo is required |
| 100639 | invAccNo is invalid |
| 100640 | bankId is required |
| 100641 | bankId is invalid |
| 100642 | paymentRefNo is required |
| 100643 | paymentRefNo is invalid |
| 100644 | perpetualFlag is required |
| 100645 | perpetualFlag is invalid |
| 100646 | startDate is required |
| 100647 | startDate is invalid |
| 100648 | endDate is required |
| 100649 | endDate is invalid |
| 100650 | startDate or endDate should not be greater than Current Date |
| 100651 | nomineeOptionFlag is required |
| 100652 | nomineeOptionFlag is invalid |
| 100653 | nomName is required |
| 100654 | nomName is invalid |
| 100655 | nomDOB is required |
| 100656 | nomDOB is invalid |
| 100657 | nomRelation is required |
| 100658 | nomRelation is invalid |
| 100659 | nomPercent is required |
| 100660 | nomPercent is invalid |
| 100661 | nomGuardName is required |
| 100662 | nomGuardName is invalid |
| 100663 | nomGuardDOB is required |
| 100664 | nomGuardDOB is invalid |
| 100665 | nomGuardRel is required |
| 100666 | nomGuardRel is invalid |
| 100667 | nomineeSec should be empty |
| 100668 | subSeqSec payMode should be empty |
| 100669 | subSeqSec invAccType should be empty |
| 100670 | subSeqSec invAccNo should be empty |
| 100671 | subSeqSec micr should be empty |
| 100672 | subSeqSec ifsc should be empty |
| 100673 | subSeqSec bankId should be empty |
| 100674 | subSeqSec paymentRefNo should be empty |
| 100675 | subSeqSec perpetualFlag should be empty |
| 100676 | subSeqSec startDate should be empty |
| 100677 | subSeqSec endDate should be empty |
| 100678 | newPRN is required |
| 100679 | jointHolderFlag is required |
| 100680 | jointHolderFlag is invalid |
| 100681 | holderDetail is required |
| 100682 | holderDetail should be empty |
| 100683 | type is required |
| 100684 | type is invalid |
| 100685 | ipAddr is required |
| 100686 | ipAddr is invalid |
| 100687 | logonTS is required |
| 100688 | logonTS is invalid |
| 100689 | In logonTS, Future Date Time is not allowed |
| 100690 | Either PRN or MMRN number is required |
| 100691 | PRN number is invalid |
| 100692 | MMRN number is invalid |
| 100693 | dataSetArr is required |
| 100696 | dataSetArr is invalid |
| 100697 | Type is required |
| 100698 | Type is invalid |
| 100699 | refNo is required |
| 100700 | refNo is invalid |
| 100701 | emailId is required |
| 100702 | emailId is invalid |
| 100703 | paymentRefNo should be empty |
| 100704 | extGroupRefNo is required |
| 100705 | extGroupRefNo is invalid |
| 100706 | extGroupRefNo length should be less than 50 characters |
| 100707 | parentGORN is required |
| 100708 | parentGORN is invalid |
| 100709 | parentITRN is required |
| 100710 | parentITRN is invalid |
| 100711 | cancelReasonCode is required |
| 100712 | cancelReasonRemarks is required |
| 100713 | cancelReasonRemarks should be empty |
| 100714 | cancelSysTxnDet should not be empty |
| 100715 | totAmt should be empty |
| 100717 | holder3PanNo should be empty |
| 100718 | holder2DOB should be empty |
| 100719 | holder3DOB should be empty |
| 100748 | Action type cannot be empty |
| 100749 | Invalid action type. Must be either SMF or STD |
| 100750 | Transaction type cannot be empty for STD action type |
| 100751 | Invalid transaction type. Must be either N or S |
| 100752 | Transaction type should be empty for other than STD action type |
| 100753 | Entering a value for Holding Nature, Tax Status, or Primary PAN makes all three of these fields mandatory. |
| 100754 | smartSwitchVolType is required |
| 100755 | smartSwitchVolType is invalid |
| 100756 | smartSwitchVolType should be empty |
| 100757 | smartSwitchVol is required |
| 100758 | smartSwitchVol is invalid |
| 100759 | smartSwitchVol should be empty |
| 100760 | vol limit exceeded |
| 100761 | only 2 decimals are allowed for vol |
| 100762 | isSpclProductFlag is required |
| 100763 | isSpclProductFlag is invalid |
| 100764 | Given scheme is not allowed for this transaction |

### Transaction Error Codes

### Table 2

Source cells: `B408:C908`

| Error Code | Error Message |
| --- | --- |
| 10006 | Invalid Email Id. |
| 10007 | Invalid Request details |
| 10014 | No Data Found |
| 10016 | You are not entitled to perform this operation |
| 10018 | Invalid request. Cannot process! |
| 10024 | Entity is in suspended status. |
| 16113 | Invalid CAN |
| 10030 | Invalid OTP |
| 10031 | Contact details not available for CAN / Folio |
| 10032 | Primary Mobile doesn't exists |
| 10033 | Primary Email ID doesn't exists |
| 18070 | CAN status is not active |
| 10046 | This link is redundant as your order has been modified and a new link has been sent. |
| 10047 | This link has expired / acted on. Kindly contact your transaction initiator for further clarification. |
| 10048 | You have already approved/rejected the transaction using this link. No further action required. |
| 10049 | The link seems to have been tampered with, while being pasting in the browser. Please reuse the link from the mail received from MFU. |
| 10050 | Invalid Non Individual CAN |
| 10051 | Invalid ARN |
| 10052 | Invalid Input details |
| 10053 | Not a Valid Order Mode |
| 10054 | Invalid Can Pan Combination |
| 10055 | We have already collected your details, Please Contact MFU |
| 10056 | You have entered the OTP incorrectly 3 times.For your security, kindly close the app/browser and request for a new OTP |
| 10057 | You have triggered the resend 3 times.For your security, kindly close the app/browser and request for a new OTP |
| 10058 | Invalid RIA code |
| 10059 | Invalid sub-broker ARN |
| 10060 | Requested CAN/PAN is Debarred.Kindly Contact MFU. |
| 10063 | The CAN's Authorization settings / Approver settings is not configured to proceed with the transaction. |
| 10064 | Remarks are mandatory |
| 10065 | Authenticate Data should not be empty |
| 10067 | Your previous request is under process, Kindly try again later |
| 10068 | Date should be less than or equal to current date |
| 10069 | Invalid maximum amount |
| 10070 | End Date should be greater than current date |
| 10071 | Timestamp Machine ID is not availble for the requested Office |
| 10072 | Folio Details not available |
| 10073 | Invalid ARN / RIA code |
| 10073 | You have already acted on the link. No further action required! |
| 10074 | The link has expired. |
| 10075 | You are not allowed to act on the link. |
| 10077 | Further operation is not allowed for the selected bank. Please contact the MFU Operation team. |
| 10078 | You have already acted on the link. No further action required! |
| 10079 | This link is redundant as your order has been cancelled. |
| 10080 | Invalid PAN/Pekrn |
| 10081 | Invalid ARN/RIA Code |
| 10083 | Transaction/One of the ITRN has been rejected by the system due to NFO master changes. Kindly contact MFU. |
| 10084 | Holiday Date should be greater than current date |
| 10085 | You have triggered the resend 3 times. For your security, Kindly close the popup/window and request for a new OTP |
| 10086 | Nominee detail already Verified for the reqeusted holder |
| 10087 | Nominee details already Verified for all the holders |
| 10088 | Nominee details are not Verified |
| 10089 | A request exists for the given CAN. |
| 10090 | Transaction with New Folio is not allowed for the CAN |
| 10091 | Nominee verification is not allowed for the provided CAN |
| 10092 | Mandate request date should be less than or equal to current date |
| 10093 | Cannot process the request, as the Mandate request date is older than 100 days |
| 10095 | For the selected CAN, family declaration is not available for one or more holders/contacts. Kindly complete the contact verification before proceeding to submit the new folio transaction. |
| 10096 | Start date and End date should be within 40 years as per NPCI circular NPCI/NACH/OC No.010/2023-24. |
| 10097 | Invalid request. |
| 29001 | Invalid Start Or End Date |
| 29002 | End Date should be greater than Start Date |
| 29003 | Maximum of 30 Days Activity can only be viewed. |
| 29004 | Invalid Request Mode |
| 29005 | Provision is not provided for the requested entity type |
| 29006 | Invalid ParticipantID |
| 29007 | Non Individual CAN is not allowed |
| 29008 | Invalid Primary PAN/Pekrn |
| 29009 | Invalid Mobile Number |
| 29010 | Minimum 1 Data Set is required to raise a consent request |
| 29011 | Invalid Consent Data Request |
| 29012 | Same request has already been approved |
| 29013 | Entity not allowed to raise request for the requested CAN |
| 29014 | Invalid FUND/FOLIO |
| 29015 | For requested CAN, CAN Detail is already visible to the Entity |
| 29016 | Already a pending request exists |
| 29017 | Atleast one data set should be yes for approval |
| 29018 | Request has been cancelled by the Entity.No further action required! |
| 29019 | Either PAN/Pekrn and DoB or Fund and Folio should be provided! |
| 29020 | Folio No is required |
| 29021 | Fund is required |
| 29022 | Data Of Birth is required |
| 29023 | PAN/Pekrn is required |
| 29025 | EntityID or Entity Code is required |
| 29026 | Invalid EntityID or Entity Code |
| 29027 | Minimum 1 transaction type should be selected |
| 29028 | Already a request exists for this combination |
| 29029 | Request has already been modified, refresh and try again |
| 29030 | ARN/RIA cannot be blacklisted as associated entity is restricted |
| 29031 | Entity cannot be restricted as associated ARN/RIA blacklisted |
| 29032 | Cannot restrict all the fund. |
| 29033 | Cannot process the request as no AMC is restricted or revoked |
| 29034 | CAN is not in Active Status. |
| 29035 | Invalid DOB. |
| 29036 | Nominee Percentage must be equal to 100 percent |
| 29037 | Nominee Option is mandatory |
| 29038 | External Group Reference number is already exist |
| 29039 | Invalid AMC Code |
| 18003 | Invalid distributor entity |
| 18004 | Invalid ARN code for the distributor user |
| 18005 | Invalid ARN |
| 18006 | ARN is Suspended |
| 18007 | Invalid EUIN Code |
| 18008 | EUIN is Suspended |
| 18009 | Invalid CAN |
| 18010 | Invalid guardian CAN |
| 18011 | Additional holder not found for that CAN |
| 18012 | Order cannot be placed for the KYC Status |
| 18013 | DP account not valid for the CAN |
| 18014 | Purchase not allowed for the scheme plan |
| 18015 | Redeem not allowed for the scheme plan |
| 18017 | Switch in not allowed for scheme plan |
| 18018 | SIP is not allowed for scheme plan |
| 18019 | SWP not allowed for the scheme plan |
| 18021 | Invalid request units |
| 18022 | Invalid request amount |
| 18023 | For this volume type, units and amount must be zero |
| 18024 | Invalid volume type |
| 18025 | Invalid CAN bank details |
| 18026 | Invalid bank details |
| 18027 | Payment details not required |
| 18030 | This volume type is not allowed for this transaction |
| 18032 | All schemes blocks resulted in warning status, order cannot be placed |
| 18033 | Payout Bank details not found under CAN/Folio Bank Mandate. Please obtain a copy of the cancelled cheque from the investor |
| 18036 | Invalid Group Order Reference Number |
| 18037 | Order cannot be modified, invalid order status for modification |
| 18038 | ARN is not allowed to be modified |
| 18039 | Invalid sub-broker ARN |
| 18040 | Sub-Broker ARN is Suspended |
| 18041 | Given payment mode not allowed for Purchase |
| 18042 | Given subsequent payment mode is not allowed |
| 18043 | Invalid MICR or IFSC code |
| 18044 | Invalid MICR code |
| 18045 | Invalid IFSC code |
| 18046 | Invalid end date |
| 18049 | Invalid request, order already handled by same user |
| 18050 | Direct flag is enabled, ARN must not be given |
| 18051 | Direct flag is disabled, ARN should be given |
| 18052 | Order cannot be modified, invalid payment status for modification |
| 18053 | Order cannot be modified, approval process started |
| 18054 | Order has been modified already, refresh and try again |
| 18058 | Invalid order date |
| 18064 | Given payment mode not allowed for SIP |
| 18065 | Payment Date cannot be blank |
| 18066 | Order amount is greater than payment amount |
| 18067 | Invalid bank details cannot process! |
| 18068 | Collection bank not set |
| 18069 | Collection bank is not set correctly as there exists more than one CMS bank |
| 18070 | CAN status is not active |
| 18071 | Number of installment is less than min installment |
| 18072 | Number of installment is resulting into greater than max installment |
| 18073 | Invalid date for the systematic transaction |
| 18074 | ARN and the sub-broker ARN should not be same |
| 18075 | You cannot cancel the order, this order has been already approved |
| 18076 | Scheme information is duplicate, avoid same scheme |
| 18077 | Bank is not associated with CAN Please mark the bank as third party otherwise it will be white listed against the CAN |
| 18078 | PayEezz not registered for the CAN, for the Bank |
| 18079 | Payment Date cannot be greater than current date. |
| 18080 | Instrument is stale as instrument date cannot be older than three months from the current date. |
| 18081 | Invalid individual order code |
| 18082 | Invalid scheme plan details |
| 18084 | Scheme is suspended, order cannot be placed for this scheme plan |
| 18086 | System error, scheme master data properly not set |
| 18088 | Fund suspended, order cannot be placed |
| 18090 | NFO not allowed for the scheme plan |
| 18092 | Not able to place order for open ended scheme type for the transaction date |
| 18094 | Not able to place order for close ended scheme type for the transaction date |
| 18096 | Current transaction date is not with in specific transaction dates for the interval scheme |
| 18098 | Folio Number mandatory for the scheme |
| 18100 | Entered FOLIO not mapped to CAN (or) Invalid FOLIO details. Please check with MFU BO |
| 18102 | Scheme thresholds not available for the scheme plan |
| 18104 | Scheme category thresholds not available for the requested scheme plan |
| 18106 | Request units must be greater than minimum value set |
| 18108 | Request units should be a multiple of the set configuration |
| 18110 | Request amount must be greater than minimum value set |
| 18112 | Request amount must be less than maximum value set |
| 18114 | Request amount must be a multiple of the set configuration |
| 18116 | Simple distributors shall not be able to place order for this scheme plan |
| 18118 | Direct investment not allowed for this scheme plan |
| 18120 | Regular investment not allowed for the scheme plan |
| 18122 | Payment mode not allowed for the scheme |
| 18124 | Subsequent payment mode is not allowed for the scheme |
| 18126 | Invalid scheme plan details for the AMC |
| 18128 | DP mandatory for the scheme |
| 18130 | DP not required for the scheme |
| 18132 | Invalid dividend option |
| 18134 | End date is required as perpetual (frequency) is not allowed for the scheme plan |
| 18136 | Start date should be less than or equal to end date |
| 18138 | Invalid scheme plan type |
| 18140 | Scheme plan type not allowed |
| 18142 | NFO not allowed for the out flow scheme plan |
| 18144 | Order modification not allowed for this payment mode |
| 18145 | Commission availed exceeds the computed value |
| 18146 | Bank branch details does not match with CAN bank |
| 18147 | Timestamp date should be less than or equal to current date |
| 18149 | Transfer-in not allowed to the instrument for scheme plan |
| 18151 | More than one FOLIO found for the CAN Fund combination. Enter FOLIO |
| 18156 | Switching across the funds not allowed |
| 18157 | Order status is already checked, you cannot update |
| 18158 | Default bank mandate not set for the CAN |
| 18159 | Payment made through a different Bank other than available under the Registered/White-listed Bank Mandate |
| 18160 | Cumulative amount  less than minimum value |
| 18161 | Addition / Deletion of schemes not allowed in modification |
| 18162 | Timestamp date time should be less than or equal to current date time |
| 18163 | Collection bank account not configured |
| 18164 | Image is already mapped to this order |
| 18170 | The Authorized Signatories List and / or Authorization Rules have not yet been submitted to MFU for this CAN. Hence, you cannot proceed with the transaction.Request your client to submit the details to MFU at the earliest OR please contact MFU for further information. |
| 18171 | IN and OUT schemes are same |
| 18172 | Order has been approved, image cannot be detached |
| 18173 | Sub-broker ARN details not provided |
| 18174 | EUIN details not provided |
| 18175 | Payment amount should be equal to the order amount |
| 18176 | Scheme coordinates not marked correctly |
| 18177 | Switching across the registrars not allowed |
| 18178 | Order amount less than min order amount allowed for the payment type |
| 18179 | Order amount greater than max order amount allowed for the payment type |
| 18180 | Primary mobile number does not exist.Cannot use IMPS mode |
| 18181 | Third party option selected for an existing bank mandate |
| 18182 | CAN registration should either be approved or submitted to POS |
| 18183 | CAN registration should be approved |
| 18184 | Submit to POS cannot be done unless checker approves |
| 18185 | ITRN of the parent order is not authorized |
| 18186 | Approval cannot be allowed as checker facility is not available |
| 18187 | Order cannot be canceled, invalid order status for canceled |
| 18188 | Order cannot be approved, invalid order status for approved |
| 18189 | Order cannot be rejected, invalid order status for rejected |
| 18190 | Order cannot be submitted to POS, invalid order status for submitted to POS |
| 18191 | Invalid order status, scanned image cannot be attached |
| 18192 | Invalid order status, scanned image cannot be detached |
| 18193 | Marker coordinates have not been confirmed. Order cannot be approved |
| 18231 | Start date should be greater than or equal to current date |
| 18234 | CAN is mandatory |
| 18235 | Order modification not allowed |
| 18236 | Invalid payment aggreator |
| 18237 | Invalid VAN |
| 18238 | Payment details not provided |
| 18242 | Contact Details does not exist.Cannot use PayEezz mode |
| 18243 | Order not yet approved Cannot regenerate Token no |
| 18244 | Payment not in Requested state Cannot regenerate Token no |
| 18245 | Order date should be less than PayEezz End date |
| 18246 | Total amount exceeds the registered PayEezz amount |
| 18247 | Order amount exceeds the registered PayEezz amount |
| 18248 | Order date should be greater than or equal to PayEezz Start date |
| 18249 | User not autherized to regenerate Token no |
| 18250 | Online Faclity is not avail for this bank |
| 18251 | Investor already acted on this order cannot regenerate |
| 18252 | Joint Holder CAN is not allowed for this transaction |
| 18253 | Non Individual CAN is not allowed for this transaction |
| 18254 | Online transaction is not allowed for this fund |
| 18255 | Transaction is not allowed for this fund |
| 18256 | Payment and subsequent payment details must be same for PayEezz |
| 18257 | Perpetual not set for the given PayEezz |
| 18258 | Scheme End date should be less than or equal to PayEezz/UPI AutoPay End date |
| 18259 | Scheme Start date should be greater than or equal to PayEezz Start date |
| 18260 | Total amount exceeds the new PayEezz amount |
| 18262 | SIP is not allowed for Folio based transaction |
| 18263 | Invalid End date: End date shall be within minor completing 18 years of age |
| 18264 | PayEezz not yet registered for the CAN |
| 18265 | Subsequent payment details is required |
| 18267 | Start date cannot exceed the maturity date |
| 18271 | Approval count already satisfied at this user level, So cannot act on this order |
| 18272 | ARN is canceled |
| 18273 | ARN is blacklisted |
| 18274 | ARN is suspended |
| 18275 | ARN is terminated |
| 18276 | Invalid Payment mode for re trigger |
| 18277 | Payment details already done |
| 18278 | PayEezz not allowed for this ENTITY/CAN |
| 18279 | AMC Fund not allowed for the entity |
| 18280 | Invalid RIA code |
| 18281 | Order cannot be submitted to MFU, invalid order status for submitted to MFU |
| 18282 | Invalid Order mode |
| 18283 | Requested SIP already canceled |
| 18284 | Order initiated for next installment |
| 18285 | Request already raised against the SIP |
| 18286 | Image not needed for requesting order |
| 18287 | RIA is not allowed to be modified |
| 18288 | Euin is cancelled |
| 18289 | Euin is blacklisted |
| 18290 | Euin is suspended |
| 18291 | Euin is terminated |
| 18292 | Image can not be verified, invalid order status for verification |
| 18293 | Attached Image need to be verified |
| 18294 | Since Image is verified, Order should checked before submitting to POS |
| 18295 | As we have already provided you all the eligible "Beneficiary Account Numbers" pertaining to the MFU collection banks into which you can make the RTGS/NEFT/IMPS payments, we cannot generate a new "Beneficiary Account Number" as requested by you. Request you to please choose one of the Beneficiary Account Numbers displayed in the dropdown and make the RTGS/NEFT/IMPS payment favouring the same. Regards, MFU |
| 18296 | All holder related with CAN need to create investor user to place an order |
| 18300 | Request already raised against the STP |
| 18301 | Request already raised against the SWP |
| 18302 | Scanned image not yet attached. Order cannot be Submitted |
| 18303 | Paper Based Transaction not allowed for requested CAN |
| 18304 | All holders related with CAN need to give either Email or Mobile No |
| 18305 | Invalid Order status for Systematic Cancel |
| 18306 | As requested Bank is White Listed, PayEezz not allowed |
| 18307 | Invalid Investor RIA Consent Flag |
| 18308 | All Holders respective to this CAN approved the Order |
| 18309 | Depository Details are Mandatory |
| 18312 | Requested Transaction type does not match with Parent Order |
| 18313 | Requested CAN and Parent Order CAN is different |
| 18314 | Invalid Request for API Order |
| 18315 | Invalid Order Confirm for API Order |
| 18316 | Source Bank details not available with MFU Bank Master |
| 18317 | Selected Approvers not satisfied Approval cycle count for requested Order |
| 18318 | As per MFU records, currently there is NO Unit balance in the Scheme chosen for Redemption/Switch-out. This may be because the units are already withdrawn from the Scheme or the units purchased recently are yet to get refreshed/updated in MFU. Request you to please RE-CHECK Scheme selected ONCE AGAIN before proceeding further and submitting the transaction. |
| 18320 | Invalid Source Bank Details |
| 18321 | Invalid Target Bank Details |
| 18322 | Order Status have been changed, cannot process your request |
| 18323 | Source and Target Bank cannot be same |
| 18324 | Source and Target Bank should be same |
| 18325 | More than 12 schemes not allowed for Requested transaction. |
| 18326 | More than 5 schemes not allowed for Paperbased transaction. |
| 18327 | Total Order Amount should be equal to the Sum of the Scheme amount |
| 18329 | Minimum Gap between entry date and SWP start date should be less than or equal to 100 days |
| 18330 | Folio Detail should be provided |
| 18331 | Folio Detail should not be provided for CAN based transaction |
| 18332 | Multiple Folio Detail provided |
| 18333 | For Daily Transaction Date should be NA |
| 18333 | Requested scheme is not allowed for Physical based transaction |
| 18334 | Requested scheme is not allowed for Electronic based transaction |
| 18339 | Not able to place CaST Repeat for close ended scheme type for the scheme plan |
| 18341 | Remarks are mandatory |
| 18342 | Required all mandatory fields. |
| 18343 | Required Change Type. |
| 18345 | Change Amount is invalid |
| 18347 | Required Change Period. |
| 18349 | Required Change Period Type. |
| 18351 | Required Change Period Value. |
| 18354 | Not able to place CaST Repeat for NFO schemes |
| 18355 | Required Change Units. |
| 18357 | Modification is not allowed for RTGS/NEFT payments. |
| 18358 | PayEezz Registration Page is not Cropped |
| 18365 | Modification of Payment Type is not allowed |
| 18366 | Modification of Payment Amount is not allowed |
| 18367 | Regeneration request is not allowed for the Order status |
| 18368 | Modification of Direct to AMC option is not allowed |
| 18369 | Image Regeneration Input is not valid |
| 18370 | Only CT Generation is allowed for this transaction |
| 18371 | Only ST Generation is allowed for this transaction |
| 18372 | Modification of PRN attribute is not allowed |
| 18373 | Your Regeneration request is in process, kindly try after sometime |
| 18374 | Modification is not allowed |
| 18375 | Your request is under process, Kindly try again later |
| 18376 | RTA is not enabled for the given service request |
| 18377 | Order Mode Cannot be modified. |
| 18378 | Source Account No Cannot be modified. |
| 18379 | Account Type Cannot be modified. |
| 18380 | MICR Code Cannot be modified. |
| 18381 | Payment date Cannot be modified. |
| 18382 | Payment date Should not be greater than current date. |
| 18388 | Deposit Slip has been generated,Order Cannot be Modified |
| 18391 | Modification is allowed only for Physical payment when image is attached |
| 18392 | Nominee Count Mismatch |
| 18393 | The given age Criteria Mismatch |
| 18394 | Invalid CAN Tax Status |
| 18395 | Invalid Frequency |
| 18396 | Number of installment is less than Minimum installment |
| 18397 | Minimum or Maximum Amount Mismatch |
| 18398 | Minimum or Maximum Units Mismatch |
| 18399 | Invalid Multiple Amount |
| 18400 | Invalid Multiple Units |
| 18401 | Nominee Percentage must be equal to 100 percent |
| 18410 | EUIN code is not a valid format |
| 18411 | Only Minor CANs are allowed for Selected Scheme |
| 18412 | Minor CANs are not allowed for the selected scheme |
| 18413 | Individual CAN is not allowed for this transaction |
| 18414 | Only Direct to AMC Payment is Allowed |
| 18415 | Depository is invalid |
| 18416 | Client ID is required |
| 18417 | Client ID should be equal to 14 characters |
| 18418 | Client ID should be equal to 16 characters |
| 18419 | Invalid Amount |
| 18420 | Invalid MarkUp Ratio |
| 18421 | Invalid Maximum Units\\ |
| 18423 | One of the ITRN Parent Order is Affected.Cannot Approve the Order |
| 18424 | Beneficiary A/C No cannot be modified for the request |
| 18425 | External Group Reference number is already exist |
| 18428 | One of the holder detail is missing in json holder detail |
| 18429 | Invalid Primary Holder's PAN |
| 18432 | Request data is not valid for re-generation. Kindly check with Archival Schema also |
| 18433 | Payment gatewayId should be empty for the request |
| 18434 | No new SIP registrations will be accepted post 1st Jan 2019. Please refer to FAQ for more details on www.mfuindia.com |
| 18435 | No new CaST registrations will be accepted post 1st Jan 2019. Please refer to FAQ for more details on www.mfuindia.com |
| 18436 | Payment gatewayId is Mandatory |
| 18438 | Invalid GORN! |
| 18439 | Systematic Registration is not in active period. |
| 18440 | You have only one Active PayEezz. Hence, no action is required. |
| 18441 | Non Individual CAN is not allowed for the selected scheme. |
| 18442 | Back dated transactions not allowed for SIP registrations beyond 5 days. |
| 18443 | STP Variable option is not allowed. |
| 18444 | Current Date Payment Should be mandatory for this Scheme |
| 18445 | Current Date Payment Should not be allowed for this Scheme |
| 18446 | Step Facility Investor Consent Flag is mandatory |
| 18447 | Step Facility is not available for this scheme |
| 18448 | payment Amount should be greater than or equal to step facility minimum amount |
| 18449 | Request data is not valid for re-trigger. Kindly check with Archival Schema. |
| 18450 | There is no Records for Rta data out queue, Retrigger of CAN Detail/Folio mapping file Cannot be done! |
| 18451 | Scheme request folio does not match with RTA response folio |
| 18452 | Additional KYC details not available for Primary Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=P"> click the link </a> to update the same |
| 18453 | Fatca Country details not available for Primary Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=P"> click the link </a> to update the same |
| 18454 | Fatca Tax Country details not available for Primary Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=P"> click the link </a> to update the same |
| 18455 | Additional KYC details not available for Secondary Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=S"> click the link </a> to update the same |
| 18456 | Fatca Country details not available for Secondary Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=S"> click the link </a> to update the same |
| 18457 | Fatca Tax Country details not available for Secondary Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=S"> click the link </a> to update the same |
| 18458 | Additional KYC details not available for Third Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=T"> click the link </a> to update the same |
| 18459 | Fatca Country details not available for Third Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=T"> click the link </a> to update the same |
| 18460 | Fatca Tax Country details not available for Third Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=T"> click the link </a> to update the same |
| 18461 | Additional KYC details not available for Guardian Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=G"> click the link </a> to update the same |
| 18462 | Fatca Country details not available for Guardian Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=G"> click the link </a> to update the same |
| 18463 | Fatca Tax Country details not available for Guardian Applicant. Kindly <a href="/OnlineFatcaRedirect.do?XCVSDFERTYHKLI=G"> click the link </a> to update the same |
| 18468 | Additional KYC details not available for Primary Applicant. |
| 18469 | Fatca Country details not available for Primary Applicant. |
| 18470 | Fatca Tax Country details not available for Primary Applicant. |
| 18471 | Additional KYC details not available for Secondary Applicant. |
| 18472 | Fatca Country details not available for Secondary Applicant. |
| 18473 | Fatca Tax Country details not available for Secondary Applicant. |
| 18474 | Additional KYC details not available for Third Applicant. |
| 18475 | Fatca Country details not available for Third Applicant. |
| 18479 | Fatca Tax Country details not available for Guardian Applicant. |
| 18480 | Request data is not valid for re-generation. Kindly check with MFU |
| 18481 | Selected input parameters qualify only for a single execution. Recheck the input details or change the mode to ONCE |
| 18482 | Start date should be greater than current date |
| 18483 | Start date and Frequency Day should be same |
| 18484 | Invalid Instalment day/date for the frequency |
| 18485 | CaST cannot be scheduled beyond 1000 instalment |
| 18486 | Transaction cannot be accepted as the KYC status as received from the KRA for one or more the Holder(s) is On Hold Rejected or DeActivated (as received from KRA) |
| 18499 | Transaction is not allowed for Demat Folio |
| 18502 | UPI facility is not available for this bank. |
| 18503 | Order cannot be Modified |
| 18505 | Mapped POS is in Suspended status |
| 18506 | Source and Target Scheme cannot be same |
| 18507 | Invalid Target Scheme |
| 18508 | SIP Insure is not available for the scheme |
| 18509 | Invalid Tenure period |
| 18510 | Nominee Details are required |
| 18511 | Any one of the User given PAN and RTA response PAN is mismatch |
| 18513 | Kindly requesting you to use new UI for this request. |
| 18550 | Transactions involving YES Bank is restricted |
| 18551 | Only Single and Any one of survivors PAN is allowed for Folio based transacteezz |
| 18552 | User entred PAN and RTA reponse PAN Mismatch |
| 18553 | Invalid Payment type |
| 18554 | Only PAN is allowed for this transaction |
| 18555 | Both Email Id & Mobile no is mandatory for this transaction |
| 18556 | Payout details should be empty for this transaction |
| 18557 | STP Start date should be greater than scheme's ReOpen date |
| 18558 | STP-IN is not allowed for requested Scheme Frequency |
| 18559 | A Stop and start request exists for this SIP registration, Cannot proceed |
| 18560 | Default bank mandate is in cooling period |
| 18561 | Requested bank mandate is in cooling period |
| 18562 | Execution value is invalid |
| 18563 | Bank account type not allowed for selected scheme |
| 18566 | Requested out scheme is not allowed |
| 18567 | Child Growth Schemes are not allowed |
| 18568 | No active Verify user available for the requested entity |
| 18569 | Order has been verified already |
| 18570 | Order not yet verified, hence transaction cannot be approved/rejected |
| 18571 | Transaction cannot be accepted as the CAN or Entity or PAN is restricted |
| 18572 | Bank is already registered against the CAN |
| 18573 | Bank is not registered against the CAN |
| 18574 | Image not yet attached |
| 18575 | PayEezz request was already registered with identical details |
| 18576 | Total amount exceeds the maximum amount of 50,000 allowed for a PEKRN for an AMC |
| 18578 | Transaction amount exceeding 50000 for an AMC in a financial year will be rejected |
| 18581 | SIP with DEMAT mode is not permitted |
| 18582 | Future redeem date exceeded the maximum dates allowed |
| 18583 | Invalid PMS Code |
| 18584 | More than 20 schemes not allowed for requested transaction. |
| 18585 | Requested payment mode is not allowed for the selected scheme |
| 18586 | DP is mandated, Only NFO transactions are allowed |
| 18587 | Transaction is not allowed for the selected scheme |
| 18591 | Payment status of selected ITRN is Failed |
| 18592 | Instalment has been triggered for the one of the ITRN, Order Cannot be modified. |
| 18593 | Duplicate Cheque number |
| 18594 | Start date and First installment date should be same |
| 18595 | For daily frequency saturday and sunday is not allowed |
| 18596 | Invalid CDPU Image ref number |
| 18597 | Scheme details cannot be modified, as credit have been realised for current dated payment. |
| 18598 | Payment status of linked subscription ITRN is Pending, hence cannot proceed further. |
| 18599 | External unique ref no should be unique |
| 18600 | Invalid External uniqure ref no |
| 18601 | Transaction cannot be accepted as the ARN/RIA is blacklisted |
| 18602 | Requested fund has been restricted for the ARN/RIA |
| 18603 | Scheme Payment Details are not available in the request |
| 18604 | NAV Trigger by transaction type is invalid |
| 18611 | Transaction cannot be process further due to NFO date expired. |
| 18612 | No systematic transaction available for the given Scheme and Fund details. |
| 18613 | KYC not verified for PAN(s) |
| 18614 | Invalid Tenure Amount. |
| 18616 | Nominee section is Invalid |
| 18617 | Minimum Amount for Schedule transaction is Rs. 100 |
| 18618 | UPI Mandate not registered for the CAN, for the Bank |
| 18619 | Lead time between SIP registration date and start date should be 3 days for AutoPayUPI mandate |
| 18620 | You cannot register more than 100 scheduled registrations for an AMC in a day |
| 18621 | Step Down amount cannot be less than or equals the Order amount |
| 18625 | For UPI Autopay payment mode start date should be 3 days from current date |
| 18626 | TxnUnique ID and ITRNUnique ID combination already exists |
| 18626 | Holding data is not received for the selected Folio |
| 18627 | Invalid MFU UTRN, Entity Group Ref No and Entity Unique ITRN combination |
| 18645 | Invalid CAN Type |
| 18646 | Direct to AMC is not allowed for HUF Investor |
| 18647 | Invalid GORN and External RefNo combination |
| 18648 | Entity is not in active state |
| 18649 | Entity validity period is expired |

## Master Data Sheet

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `Master Data Sheet`

### Table 1

Source cells: `B2:K95`

| Gorn Level Order Status | Column C | Column D | Payment Status  | Column F | Order History Event | Column H | Column I | Column J | Column K |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Code | Description |  | Payment Initiated |  | Order Requested |  | Sub Category ID |  |  |
| RQ | Created |  | Instrument Received |  | Order Modified |  | Cat. Code | Sub-Cat. Code | Sub-Cat. Description |
| CK | Checked |  | Deposit Slip Generated |  | Order Cancelled |  | 1 | 1 | EQUITY LINKED SAVINGS SCHEMES (ELSS) |
| CL | Canceled |  | Deposit Slip Accepted |  | Order Approved |  | 1 | 2 | BALANCED SCHEMES |
| AC | Approved |  | Payment Done |  | Order Rejected |  | 1 | 3 | OTHER EQUITY SCHEMES |
| RJ | Rejected |  | Payment Confirmed |  | Refund Transfer |  | 1 | 4 | GOLD EXCHANGE TRADED FUND (GETF) |
|  |  |  | Payment Rejected |  | Order Scheduled |  | 1 | 5 | OTHER EXCHANGE TRADED FUNDS (OETF) |
|  |  |  | Credit Received |  | Credit Received |  | 1 | 6 | FUND OF FUNDS - DOMESTIC |
| ITRN Level Order Status |  |  | Credit Failed |  | Credit Rejected |  | 1 | 7 | FUND OF FUNDS - INVESTING OVERSEAS |
| Code | Description |  | Payment Requested |  | Sent to RTA |  | 1 | 8 | INDEX FUNDS |
| RQ | Order Created |  | File Generated |  | RTA Accepted |  | 2 | 1 | GILT SCHEMES |
| CL | Order Canceled |  | Not Applicable |  | RTA Rejected |  | 2 | 2 | INFRASTRUCTURE DEBT FUND SCHEMES |
| RA | RTA Accepted |  | Payment Not Done |  | Scanned Image mapped |  | 2 | 3 | DEBT (ASSURED RETURN SCHEMES) |
| RR | RTA Rejected |  | Direct To AMC Payment |  | Scanned Image Unmapped |  | 2 | 4 | DEBT (OTHER THAN ASSURED RETURN SCHEMES) |
| OR | Order Rejected |  |  |  | Scanned Image Deleted |  | 2 | 5 | OTHER DEBT SCHEMES |
| OA | Order Accepted |  |  |  | Sent to POS |  | 2 | 6 | FUND OF FUNDS - DOMESTIC |
| CK | Order Checked |  | ITRN Transaction Status  |  | Order Uploaded |  | 2 | 7 | FUND OF FUNDS - INVESTING OVERSEAS |
| AC | Registration Accepted |  | Order Created |  | Payment Entry |  | 2 | 8 | INDEX FUND |
| RJ | Registration Rejected |  | Order Cancelled |  | Aggregator Confirmed |  | 3 | 1 | LIQUID/CASH/MONEY MARKET SCHEMES |
| RC | Registration Canceled |  | Sent to RTA for Accept Record |  | Investor Confirmed |  | 4 | 1 | AGGRESSIVE HYBRID FUND |
| CR | Registration Canceled by RTA |  | Sent to RTA for Reject Record |  | Payment Uploaded |  | 4 | 2 | ARBITRAGE FUND |
| SS | System Rejected |  | RTA Accepted |  | Approval Link Retriggered |  | 4 | 3 | BALANCED HYBRID FUND |
| CE | Order Ceased |  | RTA Rejected |  | RTA Processed |  | 4 | 4 | CONSERVATIVE HYBRID FUND |
|  |  |  | Order Rejected |  | Order Audited |  | 4 | 5 | DYNAMIC ASSET ALLOCATION OR BALANCED ADVANTAGE |
|  |  |  | Order Accepted |  | Payment Re trigger |  | 4 | 6 | EQUITY SAVINGS |
|  |  |  | RTA Processed |  | Payment Expired |  | 4 | 7 | MULTI ASSET ALLOCATION |
| Resident Status |  |  | Authorization-In-Progress |  | Submit to MFU |  |  |  |  |
| Code | Description |  | Not Applicable |  | Modify and Approve |  |  |  |  |
| PME | 05-PIO (Minor) NRE |  |  |  | Fund Transfer Instruction to Bank |  |  |  |  |
| 120 | Test Trident-NI-FN |  |  |  | Payment Initiated |  |  |  |  |
| 121 | Test Trident - IN - RI |  | Order Mode |  | Payment Done |  | Yes/No |  |  |
| IF | Foreign National |  | Physical |  | Payment Confirmed |  | Value | Description |  |
| 157 | test Deletion |  | File |  | Payment Rejected |  | Y  | Yes |  |
| 122 | Test  Trident -I -RI |  | Online |  | Deposit Slip Accepted |  | N | No |  |
| 105 | test group |  | White Labeling |  | Direct to AMC Payment |  |  |  |  |
| OES | OCI NRI-HUF (NRE-Sole-Proprietor) |  | TransactEezz |  | Order Ceased |  |  |  |  |
| 15B | 15B-NRI-HUF (NRE)- |  | FileEEZZ |  | System Rejected |  |  |  |  |
| 24 | test trident 2 |  | API |  | FIRC Image Uploaded |  |  |  |  |
| 15A | 15A-NRI-HUF (NRO) |  | ApiEEZZ |  | SIP Ceased |  |  |  |  |
| OEM | OCI NRI-HUF (NRE-Minor) |  | Entity White Labeling |  | Order Rectified |  |  |  |  |
| RI | 01-RES.IND |  |  |  | Resent to RTA |  |  |  |  |
| RM | 01-RES.IND (Minor) |  |  |  | Image Uploaded |  |  |  |  |
| RS | 01-RES.IND (Sole-Proprietor) |  | Order Status |  | Image Deleted |  |  |  |  |
| NRM | 02-NRI-NRE (Minor) |  | Order Created |  | Sent to AMC |  |  |  |  |
| PI | 04-Foreign National |  | Checked |  | Trade Processed |  |  |  |  |
| PM | 04-Foreign National (Minor) |  | Sent to POS |  | Trade Rejected |  |  |  |  |
| NRI | 02-NRI-NRE |  | Order Canceled |  | Dp Image Upload |  |  |  |  |
| NNM | 03-NRI-NRO (Minor) |  | Sent to RTA for Accept Record |  | Dp Image Delete |  |  |  |  |
| NPI | 05-PIO |  | Sent to RTA for Reject Record |  | Order Cancelled by RTA |  |  |  |  |
| NPM | 05-PIO (Minor) |  | RTA Accepted |  | Deposit Slip Added |  |  |  |  |
| NNI | 03-NRI-NRO |  | RTA Rejected |  | Deposit Slip Removed |  |  |  |  |
| 99B | 25-Section 25 Company |  | Order Rejected |  | Mandate Changed |  |  |  |  |
| 99A | 20-Non-Profit Organization |  | Order Accepted |  | Payout Initiated |  |  |  |  |
| 99 | 26-Others |  | Sent to RTA for Cancel record |  | RTA Pre Rejected |  |  |  |  |
| 17 | 23-QFI |  | RTA Processed |  | Sent to RTA for Acceptance |  |  |  |  |
| 16 | 22-LLP |  |  |  | Sent to RTA for Rejection |  |  |  |  |
| 15 | 14-Society |  |  |  | SOF Validation |  |  |  |  |
| 13 | 24-Defence Establishment |  | ITRN Transaction Type |  | Scanned Image Uploaded |  |  |  |  |
| 12 | 19-Non-Government Organization |  | Purchase |  | SaS Request Initiated |  |  |  |  |
| 11 | 18-Government Body |  | Additional Purchase |  | SaS Approved |  |  |  |  |
| 10 | 17-Bank |  | NFO |  | SaS Rejected |  |  |  |  |
| 8 | 15-HUF |  | Redeem |  | SaS Cancelled |  |  |  |  |
| 09A | 16-Social Organizations |  | Switch-In |  | SIP SaS Initiation |  |  |  |  |
| 9 | 21-AOP |  | Switch-Out |  | Special Product Info |  |  |  |  |
| 7 | 07-FII |  | SIP |  | Verifier Accepted |  |  |  |  |
| 6 | 13-Financial Institutions |  | SWP |  | Verifier Rejected |  |  |  |  |
| 05F | 12-Super Annuation Fund |  | STP |  | Proof Image Uploaded |  |  |  |  |
| 05E | 06-PF Trust |  | SIP Cancel |  | Proof Image Changed |  |  |  |  |
| 05C | 10-NPS Trust |  | SWP Cancel |  | Transaction Proof Image Uploaded |  |  |  |  |
| 05D | 11-Pension & Retirement Fund |  | STP Cancel |  | Transaction Proof Image Deleted |  |  |  |  |
| 05B | 09-Gratuity Fund |  | STP Cancel In |  | Scheme coordinates marked |  |  |  |  |
| 5 | 05-Charitable Trust |  | STP Cancel Out |  | Scheme coordinates corrected |  |  |  |  |
| 05A | 08-Fund of Fund |  | NFO |  | Image Modified by MFU |  |  |  |  |
| 4 | 04-Partnership Firm |  | Transfer-In |  | PayEezz Image Detail Update |  |  |  |  |
| 3 | 03-Body Corporate |  | Transfer-Out |  | Payment Requested |  |  |  |  |
| 2 | 02-Public Ltd. Company |  |  |  | Fund Instruction sent to Bank |  |  |  |  |
| 1 | 01-Pvt. Ltd. Company |  |  |  | Fund Transfer Initiated by PA to AMC |  |  |  |  |
| OCS | OCI NRI-HUF (NRO-Sole-Proprietor) |  | Payment Mode |  | Order Revoked |  |  |  |  |
| OCM | OCI NRI-HUF (NRO-Minor) |  | Cheque |  | Image Modified by MFU with Scheme markup |  |  |  |  |
| OCE | OCI NRI-HUF (NRE) |  | Demand Draft |  | Payout Bank Modified |  |  |  |  |
| OCO | OCI NRI-HUF (NRO) |  | Pay Order |  | Credit Received by AMC |  |  |  |  |
| 119 | Test Trident - SP |  | Transfer Letter |  | Change in Amount |  |  |  |  |
| RI1 | 00-Res.India1 |  | NEFT |  | Step Facility Request |  |  |  |  |
| 102 | Indian 1 |  | RTGS |  | Pre Debit Success |  |  |  |  |
| PMO | 05-PIO (Minor) NRO |  | NEFT \| Post |  | Pre Debit Failure |  |  |  |  |
| 101 | NRI-NRE |  | RTGS \| Post |  |  |  |  |  |  |
| CR1 | RAJRES01 |  | Debit Mandate |  |  |  |  |  |  |
| CP1 | RESIND01 |  | IMPS |  |  |  |  |  |  |
| INR | Test Trident 1 |  | Net Banking |  |  |  |  |  |  |
| NPE | 05-PIO (NRE) |  | Debit Card |  |  |  |  |  |  |
| NPO | 05-PIO (NRO) |  | ACH |  |  |  |  |  |  |
| 05G | 27-Trust |  | ECS |  |  |  |  |  |  |
| 14 | 21-BOI |  | Standing Instruction |  |  |  |  |  |  |

### Direct Debit

### Bankers Cheque

### Account Type

### Table 2

Source cells: `B99:G356`

| Code | Description | Column D | Column E | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| SB | Savings |  |  |  |  |
| CA | Current |  |  | Category ID |  |
| OD | Over Draft |  |  | Cat. Code | Category Description |
| FCNR | Foreign Currency Non Resident |  |  | 1 | EQUITY |
| NRE | Non Resident External Account |  |  | 2 | DEBT |
| PSB | Post Office Savings Account |  |  | 3 | CASH/LIQUID/MONEY MARKET |
| NRO | Non Resident Ordinary A/c |  |  | 4 | HYBRID |
| CC | Cash Credit |  |  |  |  |
| SNRA | Special Non Resident Rupee A/c |  |  |  |  |
| SNRR | Special Non Resident repatriable |  |  |  |  |
| CLSB | SAVING CUM CURRENT ACCOUNT |  |  | Country Master |  |
|  |  |  |  | Country Code | Country Bank |
|  |  |  |  | 001  | Afghanistan |
| PRN Status |  |  |  | 002  | Aland Islands |
| Code | Description |  |  | 003  | Albania |
| PE | Pending |  |  | 004  | Algeria |
| AP | PayEezz Registration Assigned to Aggregator |  |  | 005  | American Samoa |
| BA | Batched |  |  | 006  | Andorra |
| SE | PayEezz Regisration Sent to Aggregator |  |  | 007  | Angola |
| FG | PayEezz Generation File Generated to be sent to Aggregator |  |  | 008  | Anguilla |
| RA | PayEezz Registration Rejected by Aggregator |  |  | 009  | Antarctica |
| AK | PayEezz Registration Accepted by Aggregator |  |  | 010  | Antigua And Barbuda |
| AE | PayEezz Registration Cancelled by Aggregator |  |  | 011  | Argentina |
| PS | PayEezz Registration Request acknowledged by Aggregator |  |  | 012  | Armenia |
| PF | PayEezz Registration Request Rejected by Aggregator |  |  | 013  | Aruba |
| CR | Cancellecation Rejected |  |  | 014  | Australia |
|  |  |  |  | 015  | Austria |
| Frequency |  |  |  | 016  | Azerbaijan |
| Code | Description |  |  | 017  | Bahamas |
| D | Daily |  |  | 018  | Bahrain |
| W | Weekly |  |  | 019  | Bangladesh |
| F | Fortnightly |  |  | 020  | Barbados |
| M | Monthly |  |  | 021  | Belarus |
| B | Bi-Monthly |  |  | 022  | Belgium |
| Q | Quarterly |  |  | 023  | Belize |
| S | Semi-Annually |  |  | 024  | Benin |
| A | Annually |  |  | 025  | Bermuda |
|  |  |  |  | 026  | Bhutan |
|  |  |  |  | 027  | Bolivia |
|  |  |  |  | 028  | Bosnia And Herzegovina |
| Cancel Reason Code |  |  |  | 029  | Botswana |
| Code | Description |  |  | 030  | Bouvet Island |
| M001 | Non availability of Funds |  |  | 031  | Brazil |
| M002 | Scheme not performing |  |  | 032  | British Indian Ocean Territory |
| M003 | Service issue |  |  | 033  | Brunei Darussalam |
| M004 | Load Revised |  |  | 034  | Bulgaria |
| M005 | Wish to invest in other schemes |  |  | 035  | Burkina Faso |
| M006 | Change in Fund Manager |  |  | 036  | Burundi |
| M007 | Goal Achieved |  |  | 037  | Cambodia |
| M008 | Not comfortable with market volatility |  |  | 038  | Cameroon |
| M009 | Will be restarting SIP after few months |  |  | 039  | Canada |
| M010 | Modifications in bank/mandate/date  etc |  |  | 040  | Cape Verde |
| M011 | I have decided to invest elsewhere |  |  | 041  | Cayman Islands |
| M012 | This is not the right time to invest |  |  | 042  | Central African Republic |
| OTH | Others |  |  | 043  | Chad |
|  |  |  |  | 044  | Chile |
|  |  |  |  | 045  | China |
| Tax Status Code |  |  |  | 046  | Christmas Island |
| Code | Description |  |  | 047  | Cocos (Keeling) Islands |
| 1 | Pvt. Ltd. Company |  |  | 048  | Colombia |
| 2 | Public Ltd. Company |  |  | 049  | Comoros |
| 3 | Body Corporate |  |  | 050  | Congo |
| 4 | Partnership Firm |  |  | 051  | Congo, The Democratic Republic Of The |
| 5 | Charitable Trust |  |  | 052  | Cook Islands |
| 05A | Fund of Fund |  |  | 053  | Costa Rica |
| 05B | Gratuity Fund |  |  | 054  | Cote D Ivoire |
| 05C | NPS Trust |  |  | 055  | Croatia |
| 05D | Pension & Retirement Fund |  |  | 056  | Cuba |
| 05E | PF Trust |  |  | 057  | Cyprus |
| 05F | Super Annuation Fund |  |  | 058  | Czech Republic |
| 6 | Financial Institutions |  |  | 059  | Denmark |
| 7 | FII |  |  | 060  | Djibouti |
| 8 | HUF |  |  | 061  | Dominica |
| 9 | AOP |  |  | 062  | Dominican Republic |
| 09A | Social Organizations |  |  | 063  | Ecuador |
| 10 | Bank |  |  | 064  | Egypt |
| 11 | Government Body |  |  | 065  | El Salvador |
| 12 | Non Government Organization |  |  | 066  | Equatorial Guinea |
| 13 | Defence Establishment |  |  | 067  | Eritrea |
| 14 | BOI |  |  | 068  | Estonia |
| 15 | Society |  |  | 069  | Ethiopia |
| 16 | LLP |  |  | 070  | Falkland Islands (Malvinas) |
| 17 | QFI |  |  | 071  | Faroe Islands |
| 99 | Others |  |  | 072  | Fiji |
| 99A | Non Profit Organization |  |  | 073  | Finland |
| 99B | Section 25 Company |  |  | 074  | France |
| NNI | NRI NRO |  |  | 075  | French Guiana |
| NNM | NRI NRO (Minor) |  |  | 076  | French Polynesia |
| NPI | PIO |  |  | 077  | French Southern Territories |
| NPM | PIO (Minor) |  |  | 078  | Gabon |
| NRI | NRI NRE |  |  | 079  | Gambia |
| NRM | NRI NRE (Minor) |  |  | 080  | Georgia |
| PI | Foreign National |  |  | 081  | Germany |
| PM | Foreign National (Minor) |  |  | 082  | Ghana |
| RI | RES.IND |  |  | 083  | Gibraltar |
| RM | RES.IND (Minor) |  |  | 084  | Greece |
| RS | RES.IND (Sole Proprietor) |  |  | 085  | Greenland |
| 05G | Trust |  |  | 086  | Grenada |
| PMO | PIO (Minor) NRO |  |  | 087  | Guadeloupe |
| PME | PIO (Minor) NRE |  |  | 088  | Guam |
| NPE | PIO (NRE) |  |  | 089  | Guatemala |
| NPO | PIO (NRO) |  |  | 090  | Guernsey |
| 56 | FPI HUF (NRO) |  |  | 091  | Guinea |
| 15A | NRI |  |  | 092  | Guinea-Bissau |
| 15B | NRI HUF (NRE) |  |  | 093  | Guyana |
|  |  |  |  | 094  | Haiti |
|  |  |  |  | 095  | Heard Island And Mcdonald Islands |
| CAN Status |  |  |  | 096  | Holy See (Vatican City State) |
| Code | Description |  |  | 097  | Honduras |
| AP | Approved |  |  | 098  | Hong Kong |
| PE | Pending |  |  | 099  | Hungary |
| RJ | Rejected |  |  | 100  | Iceland |
| OH | On Hold |  |  | 101  | India |
| CL | Canceled |  |  | 102  | Indonesia |
| DR | Dormant |  |  | 103  | Iran, Islamic Republic Of |
| VR | Verified |  |  | 104  | Iraq |
| SM | Submit to MFU |  |  | 105  | Ireland |
| DC | Declined |  |  | 106  | Isle Of Man |
| SU | Suspended |  |  | 107  | Israel |
|  |  |  |  | 108  | Italy |
|  |  |  |  | 109  | Jamaica |
| Transaction Type |  |  |  | 110  | Japan |
| Code | Description |  |  | 111  | Jersey |
| A | Additional Purchase |  |  | 112  | Jordan |
| B | Purchase |  |  | 113  | Kazakhstan |
| N | NFO |  |  | 114  | Kenya |
| R | Redeem |  |  | 115  | Kiribati |
| I | Switch-In |  |  | 116  | Korea, Democratic Peoples Republic Of |
| O | Switch-Out |  |  | 117  | Korea, Republic Of |
| V | SIP |  |  | 118  | Kuwait |
| J | SWP |  |  | 119  | Kyrgyzstan |
| X | STP In |  |  | 120  | Lao Peoples Democratic Republic |
| Y | STP Out |  |  | 121  | Latvia |
| C | SIP Cancel |  |  | 122  | Lebanon |
| W | SWP Cancel |  |  | 123  | Lesotho |
| K | STP-In Cancel |  |  | 124  | Liberia |
| L | STP-Out Cancel |  |  | 125  | Libyan Arab Jamahiriya |
|  |  |  |  | 126  | Liechtenstein |
|  |  |  |  | 127  | Lithuania |
| Payment Status |  |  |  | 128  | Luxembourg |
| Code | Description |  |  | 129  | Macao |
| PQ | Payment Requested |  |  | 130  | Macedonia, The Former Yugoslav Republic Of |
| PI | Payment Initiated |  |  | 131  | Madagascar |
| PN | Payment Not Done |  |  | 132  | Malawi |
| PC | Payment Confirmed |  |  | 133  | Malaysia |
| PR | Payment Rejected |  |  | 134  | Maldives |
| PD | Payment Done |  |  | 135  | Mali |
| CF | Credit Failed |  |  | 136  | Malta |
| CR | Credit Received |  |  | 137  | Marshall Islands |
|  |  |  |  | 138  | Martinique |
|  |  |  |  | 139  | Mauritania |
| State Master |  |  |  | 140  | Mauritius |
| State Code | State Name |  |  | 141  | Mayotte |
| 001  | Jammu and Kashmir |  |  | 142  | Mexico |
| 002  | Himachal Pradesh |  |  | 143  | Micronesia, Federated States Of |
| 003  | Punjab |  |  | 144  | Moldova, Republic Of |
| 004  | Chandigarh |  |  | 145  | Monaco |
| 005  | Uttarakhand |  |  | 146  | Mongolia |
| 006  | Haryana |  |  | 147  | Montserrat |
| 007  | Delhi |  |  | 148  | Morocco |
| 008  | Rajasthan |  |  | 149  | Mozambique |
| 009  | Uttar Pradesh |  |  | 150  | Myanmar |
| 010  | Bihar |  |  | 151  | Namibia |
| 011  | Sikkim |  |  | 152  | Nauru |
| 012  | Arunachal Pradesh |  |  | 153  | Nepal |
| 013  | Assam |  |  | 154  | Netherlands |
| 014  | Manipur |  |  | 155  | Netherlands Antilles |
| 015  | Mizoram |  |  | 156  | New Caledonia |
| 016  | Tripura |  |  | 157  | New Zealand |
| 017  | Meghalaya |  |  | 158  | Nicaragua |
| 018  | Nagaland |  |  | 159  | Niger |
| 019  | West Bengal |  |  | 160  | Nigeria |
| 020  | Jharkhand |  |  | 161  | Niue |
| 021  | Orissa |  |  | 162  | Norfolk Island |
| 022  | Chhattisgarh |  |  | 163  | Northern Mariana Islands |
| 023  | Madhya Pradesh |  |  | 164  | Norway |
| 024  | Gujarat |  |  | 165  | Oman |
| 025  | Daman and Diu |  |  | 166  | Pakistan |
| 026  | Dadra and Nagar Haveli |  |  | 167  | Palau |
| 027  | Maharashtra |  |  | 168  | Palestinian Territory, Occupied |
| 028  | Andhra Pradesh |  |  | 169  | Panama |
| 029  | Karnataka |  |  | 170  | Papua New Guinea |
| 030  | Goa |  |  | 171  | Paraguay |
| 031  | Lakshadweep |  |  | 172  | Peru |
| 032  | Kerala |  |  | 173  | Philippines |
| 033  | Tamil Nadu |  |  | 174  | Pitcairn |
| 034  | Puducherry |  |  | 175  | Poland |
| 035  | Andaman and Nicobar Islands |  |  | 176  | Portugal |
| 037  | Telangana |  |  | 177  | Puerto Rico |
| 099  | Others |  |  | 178  | Qatar |
|  |  |  |  | 179  | Reunion |
|  |  |  |  | 180  | Romania |
| eCAN Image Proof Type |  |  |  | 181  | Russian Federation |
| Code | Description |  |  | 182  | Rwanda |
| 1#PC | Copy of PAN of all Holder(s)/Guardian |  |  | 183  | Saint Helena |
| 2#BP | Proof of Bank Account provided |  |  | 184  | Saint Kitts And Nevis |
| 3#BC | Minor Birth Certificate proof |  |  | 185  | Saint Lucia |
| 4#FA | Document proof related to other information submitted for eCAN |  |  | 186  | Saint Pierre And Miquelon |
| 5#BL | Bank Letter |  |  | 187  | Saint Vincent And The Grenadines |
| 6#GL | Gazette Letter |  |  | 188  | Samoa |
| 7#GD | Other relevant Government Document |  |  | 189  | San Marino |
| 8#NF | Nomination Form |  |  | 190  | Sao Tome And Principe |
| 9#DP | DP Statement reflecting the DP account |  |  | 191  | Saudi Arabia |
| 11#CC | Client Master Copy |  |  | 192  | Senegal |
| 12#FI | Tax Detail ID Proof |  |  | 193  | Serbia And Montenegro |
| 13#TI | TIN NA Declaration |  |  | 194  | Seychelles |
|  |  |  |  | 195  | Sierra Leone |
|  |  |  |  | 196  | Singapore |
|  |  |  |  | 197  | Slovakia |
|  |  |  |  | 198  | Slovenia |
|  |  |  |  | 199  | Solomon Islands |
|  |  |  |  | 200  | Somalia |
|  |  |  |  | 201  | South Africa |
|  |  |  |  | 202  | South Georgia And The South Sandwich Islands |
|  |  |  |  | 203  | Spain |
|  |  |  |  | 204  | Sri Lanka |
|  |  |  |  | 205  | Sudan |
|  |  |  |  | 206  | Suriname |
|  |  |  |  | 207  | Svalbard And Jan Mayen |
|  |  |  |  | 208  | Swaziland |
|  |  |  |  | 209  | Sweden |
|  |  |  |  | 210  | Switzerland |
|  |  |  |  | 211  | Syrian Arab Republic |
|  |  |  |  | 212  | Taiwan, Province Of China |
|  |  |  |  | 213  | Tajikistan |
|  |  |  |  | 214  | Tanzania, United Republic Of |
|  |  |  |  | 215  | Thailand |
|  |  |  |  | 216  | Timor-Leste |
|  |  |  |  | 217  | Togo |
|  |  |  |  | 218  | Tokelau |
|  |  |  |  | 219  | Tonga |
|  |  |  |  | 220  | Trinidad And Tobago |
|  |  |  |  | 221  | Tunisia |
|  |  |  |  | 222  | Turkey |
|  |  |  |  | 223  | Turkmenistan |
|  |  |  |  | 224  | Turks And Caicos Islands |
|  |  |  |  | 225  | Tuvalu |
|  |  |  |  | 226  | Uganda |
|  |  |  |  | 227  | Ukraine |
|  |  |  |  | 228  | United Arab Emirates |
|  |  |  |  | 229  | United Kingdom |
|  |  |  |  | 230  | United States |
|  |  |  |  | 231  | United States Minor Outlying Islands |
|  |  |  |  | 232  | Uruguay |
|  |  |  |  | 233  | Uzbekistan |
|  |  |  |  | 234  | Vanuatu |
|  |  |  |  | 235  | Venezuela |
|  |  |  |  | 236  | Viet Nam |
|  |  |  |  | 237  | Virgin Islands, British |
|  |  |  |  | 238  | Virgin Islands, U.S. |
|  |  |  |  | 239  | Wallis And Futuna |
|  |  |  |  | 240  | Western Sahara |
|  |  |  |  | 241  | Yemen |
|  |  |  |  | 242  | Zambia |
|  |  |  |  | 243  | Zimbabwe |
|  |  |  |  | NA   | Not Applicable |
|  |  |  |  | OTH  | Others |

### Tax Master

### Table 3

Source cells: `B361:E372`

| Investor_Category | Tax Status Desc | Tax Status | Bank Account Type |
| --- | --- | --- | --- |
| Individual | 03-NRI-NRO | NNI | NRO,OD,CC,SNRA,SNRR,OTH |
| Individual | 05-PIO | NPI | NRE,NRO,OD,CC,OTH |
| Individual | 02-NRI-NRE | NRI | NRE,OD,CC,OTH |
| Individual | 04-Foreign National | PI  | FCNR,NRE,NRO,OD,CC,OTH |
| Individual | 01-RES.IND | RI  | SB,CA,PSB,CC,CLSB,OD,OTH |
| Sole-proprietor | 01-RES.IND (Sole-Proprietor) | RS  | SB,CA,PSB,CC,CLSB,OD,OTH |
| Minor | 03-NRI-NRO (Minor) | NNM | NRO,OD,CC,SNRA,SNRR,OTH |
| Minor | 05-PIO (Minor) | NPM | NRE,NRO,OD,CC,OTH |
| Minor | 02-NRI-NRE (Minor) | NRM | NRE,OD,CC,OTH |
| Minor | 04-Foreign National (Minor) | PM  | FCNR,NRE,NRO,OD,CC,OTH |
| Minor | 01-RES.IND (Minor) | RM  | SB,CA,PSB,CC,CLSB,OD,OTH |

## Possible Values Mapping

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `Possible Values Mapping`

### Table 1

Source cells: `A2:E12`

| CAN Folio Validation Service API - txnType | Request | Values in MFU System | Response | Column E |
| --- | --- | --- | --- | --- |
|  | txnType |  | canFolioValidFlag | isHoldingAvail |
|  | B and V<br>(Purchase & SIP) | Available in CAN folio mapping<br>Available in CAN holding | Y | Y |
|  | B and V<br>(Purchase & SIP) | Available in CAN folio mapping<br>Not available in CAN holding | Y | N |
|  | B and V<br>(Purchase & SIP) | Not available in CAN folio mapping<br>Not available in CAN holding | N | N |
|  | R, S, J and E<br>(Redeem, Switch, SWP & STP) | Available in CAN folio mapping<br>Available in CAN holding | Y | Y |
|  | R, S, J and E<br>(Redeem, Switch, SWP & STP) | Available in CAN folio mapping<br>Not available in CAN holding | N | N |
|  | R, S, J and E<br>(Redeem, Switch, SWP & STP) | Not available in CAN folio mapping<br>Not available in CAN holding | N | N |
|  | Empty value | Available in CAN folio mapping<br>Available in CAN holding | Y | Y |
|  | Empty value | Available in CAN folio mapping<br>Not available in CAN holding | Y | N |
|  | Empty value | Not available in CAN folio mapping<br>Not available in CAN holding | N | N |
