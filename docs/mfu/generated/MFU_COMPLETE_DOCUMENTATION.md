# MFU Complete Documentation

Consolidated Markdown reference generated from the MF Utility Fintech Transaction API Specification V2.9, Scheme Master Data Structure Specifications v2.3, and UAT test-data workbook.

## Contents

- [Part I: Transaction API specification](#part-i-transaction-api-specification)
- [Part II: Scheme master data structure](#part-ii-scheme-master-data-structure)
- [Part III: UAT test data](#part-iii-uat-test-data)

## Part I: Transaction API specification

Source: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)

### Revision History

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `Revision History`

#### Table 1

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

### System FAQs

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `System FAQs`

#### Table 1

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

#### JSON examples

##### JSON example 1 (cell D5)

```json
{"errorRespData":{"errorCode":"100007","errorMsg":"Token validity period is expired"}}
```

##### JSON example 2 (cell D5)

```json
{"errorRespData":{"errorCode":"100006","errorMsg":"Authorization Token is invalid"}}
```

### API Services List

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `API Services List`

#### MF Utility – Fintech Transaction API Specification

#### Table 1

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

### Authorization with OAuth 2.0

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `Authorization with OAuth 2.0`

#### Authorization with OAuth 2.0 -  Access Token Generation

#### This API will provide the access token , required to access the various API.

#### Table 1

Source cells: `B4:C8`

| Transport Method | REST |
| --- | --- |
| URL Invoke Method | POST |
| Content Type | application/json |
| Response Format Type | JSON |
| URL | https://<UAT or PROD URL>/GetAccessTokenV1 |

#### Request Parameters

#### Table 2

Source cells: `B11:E14`

| Field | Description | Data Type | Mandatory |
| --- | --- | --- | --- |
| entityId | A unique Entity ID, as available in MFU for the Distributor / RIA or such other Entity using this facility.  | String | Yes |
| clientUser | Login ID of the user – initiating the API request. The Login User ID should be encrypted using AES/CBC/PKCS7Padding algorithm. MFU will provide a  public key and a IvKey for encryption at the time of integration | String | Yes |
| clientPwd | Password of the user. The password should be encrypted using AES/CBC/PKCS7Padding algorithm. MFU will provide a  public key and a IvKey for encryption at the time of integration | String | Yes |

#### Success Response JSON Field

#### Table 3

Source cells: `B16:E19`

| Field | Description | Data Type | Mandatory |
| --- | --- | --- | --- |
| access_token | Access Token. Currently Supported only 'Bearer' | String | Yes |
| token_type | Token Type | String | Yes |
| expires_in | Validity period of the access token in hours | Integer | Yes |

#### Error Response JSON Field

#### Table 4

Source cells: `B22:E24`

| Field | Description | Data Type | Mandatory |
| --- | --- | --- | --- |
| errorCode | Error Code | Number | Yes |
| errorMsg | Error Message | String | Yes |

#### Sample Request and Response

#### Table 5

Source cells: `B27:C30`

| Sample Request  | [See JSON example 1 below] |
| --- | --- |
| Sample Success Response JSON<br>HTTP Status Code is 200 | [See JSON example 2 below] |
| Sample Error Response JSON<br>HTTP Status code is 400 | [See JSON example 3 below] |
| Sample Error Response JSON<br>HTTP Status code is 401 | [See JSON example 4 below] |

#### Accessing other service API with OAuth 2.0 access token

In order to access the FinTech APIs* with OAuth security, “access token” as received in the reponse should be passed in the HTTP header as a parameter (refer below)

#### Header Parameter - Authorization:{{token_type}} {{access_token}}

#### Sample value for Authorization : Bearer aab87efa-XXXX-XXXX-XXXX-XXXXXXXXXXXX

When calling any of the services, If the oAuth token is expired or invalid, The HTTP status code is 400 or 401.   
the error message will be in the following format only (not in encrypted format).    
[See JSON example 5 below].  
  
The entity system,First check the HTTP status code. If it is 200, success. For other than 200, It is failure. For failure case, check the Error Input stream for valid error message.

#### JSON examples

##### JSON example 1 (cell C27)

```json
{
"reqBody":{"entityId":"400001","clientUser":"lXXxd3ce62cXX364fXXXXXXbXXX18d2c6a5cXXXXX","clientPwd":"6ed73XXXXXc3454XXXXX27a4752XXXXXX9"}
}
```

##### JSON example 2 (cell C28)

```json
{
"access_token": "aab87efa-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
"token_type": "Bearer",
"expires_in": "24"
}
```

##### JSON example 3 (cell C29)

```json
{
"errorCode": "100001",
"errorMsg": "Invalid Request Details"
}
```

##### JSON example 4 (cell C30)

```json
{
"errorCode": "100007",
"errorMsg": "Token validity period is expired"
}
```

##### JSON example 5 (cell B36)

```json
{"errorRespData":{"errorCode":"100007","errorMsg":"Token validity period is expired"}}
```

### Request Header and Response Det

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `Request Header and Response Det`

#### Request Header Details

#### Table 1

Source cells: `B3:G8`

| JSON Field Name | Description | Data Type | Mandatory  | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |
| entityId | A unique Entity ID, as available in MFU for the Distributor / RIA or such other Entity using this facility. <br>The Entity ID shall be provided by MFU to the Entity while setting up the UAT / Production environments. | Char(6) | Yes |  |  |
| version | Version number for the Web service. For example, 1.00<br>The version number is used to manage future changes to the web services. | Char(5) | Yes |  |  |
| reqTS | The request initatied timestamp in Entity System.<br>The time format is YYYY-MM-DD HH:MM:SS | Date Time | Yes | 2023-04-16 15:20:09 |  |
| apiType | The requested Module Type.<br>NORMAL-TXN : Normal Transaction Service<br>SYS-TXN : Systematic Transaction Service<br>SYS-CANCEL-TXN : Systematic Cancellation Service<br>TXN-AUT-DETH : Transaction Authrization Detail service<br>TXN-APPROVAL : Transaction approval Serivce<br>TXN-HIST : Transaction History API Service<br>CAN-VAL : CAN Validation API Service<br>CAN-FETCH : CAN Fetch Service<br>PRN VAL : PRN Validation Service<br>CAN-BNK-VAL : CAN Bank Validation Service<br>SWP-PAYEEZ : Swap PayEezz Service<br>CAN-FOLIO-VAL : CAN Folio Validation Service<br>INV-CON-ENTRY : Investor Consent Entry Service<br>INV-CON-VIEW : Investor Consent View Service | Char(20) | Yes | Allowed Values :<br>NORMAL-TXN<br>SYS-TXN<br>SYS-CANCEL-TXN <br>TXN-AUT-DETH<br>TXN-APPROVAL<br>TXN-HIST<br>CAN-VAL<br>CAN-FETCH<br>PRN VAL<br>CAN-BNK-VAL<br>SWP-PAYEEZ<br>CAN-FOLIO-VAL<br>INV-CON-ENTRY<br>INV-CON-VIEW |  |
| uniqueId | Request Unique ID created at the Entity’s site and shared with MFU in the request. Request Unique Id should not be duplicated | Char(50) | Yes |  |  |

#### Request Body Details

#### Table 2

Source cells: `B12:G13`

| JSON Field Name | Description | Data Type | Mandatory | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |
| data | The full request body JSON section data should be encrypted and passed in data json field.<br>The encryption algorithm is AES/CBC/PKCS7Padding. MFU will provide a public key and a IvKey for encryption at the time of integration | Char(Max) | Yes |  |  |

#### Sample Request JSON Details

#### Table 3

Source cells: `B17:C18`

| Sample Header Structure | [See JSON example 1 below] |
| --- | --- |
| Sample body Structure | [See JSON example 2 below] |

#### Response Format Details

#### Table 4

Source cells: `B22:G23`

| JSON Field Name | Description | Data Type | Mandatory | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |
| respData | The full response Detail (Error Or Success) JSON section data should be encrypted and passed in respData json field.<br>The encryption algorithm is AES/CBC/PKCS7Padding. MFU will provide a public key and a IvKey for encryption at the time of integration | Char(Max) | Yes |  |  |

#### Sample Response

#### Table 5

Source cells: `B27:C27`

| Sample Response Structure | [See JSON example 3 below] |
| --- | --- |

#### Sample Request Header JSON

#### Table 6

Source cells: `B45:C45`

| Sample Header Structure | [See JSON example 4 below] |
| --- | --- |

#### JSON examples

##### JSON example 1 (cell C17)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-07 10:20:09","apiType":"FETCH-UTRN","uniqueId":"1000000000"},"reqBody":{}
}
```

##### JSON example 2 (cell C18)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-07 10:20:09","apiType":"FETCH-UTRN","uniqueId":"1000000000"},
"reqBody":{"data":"yXOzCUf6KJtUshOvZi+xQxdto1oQH8vFiqiTCyJBWn6PUq6sT+YfiN7mnpCBr9zAmAwZKuHY4B6SjM7R71UWqABRvI+th0mgA9K+tcCcmntX55RoWh7JKJ0FAS2fhOA9H3WeFPp/z9GxU1VoX1Lq2df6nOLqvhpD3QyMbijkoOlWguDnHcjQBhl8zgxc8htC+BEer7sODEXmxF/Tkqrkar4BrA/tN7l71cS3kzZVBqy2I0WCh+9yjqriXKAccQpGQodg6YILEmJTSwYxd99tJUVrSoT46Y5G7BmfBJgvDNA="}
}
```

##### JSON example 3 (cell C27)

```json
{
"respData":"R+O4by+eamMAqHs8qHjcLtQQLtL5NkZswAAu9YwXKKfdiIDgfaM8QVidcXaD+YjfnbUnqBY96KoaMjlUKg4kXIYCUOJ3l7/tYhLjn8YrpgQ+H/mcidupRc4wfRU1zQ8/JOBYIt5RXS5lkmKGLP"
}
```

##### JSON example 4 (cell C45)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-07 10:20:09","apiType":"FETCH-UTRN","userId":"XXXX","encryptPwd":"XXXXXXXXXXXXXXXXXXXXXXX","uniqueId":"1000000000"},"reqBody":{}
}
```

### eCAN-PAN-VERIFY

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `eCAN-PAN-VERIFY`

#### PAN Verify Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFintechPanDataChkService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be eCAN-PAN-VERIFY | Char(20) | Yes | eCAN-PAN-VERIFY | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:G12`

| modeOfHld | Mode of Holding | Char(2) | Yes | Allowed Values:<br>SI - Single<br>AS - Anyone of Survivor<br>JO  - Joint | Column G |
| --- | --- | --- | --- | --- | --- |
| resdStatus | Resident status of the Investor | Char(3) | Yes | Refer Master Data Sheet : Tax Master :: refer column tax status for the allowed values |  |
| panNo | First Holder PAN Number<br>If Minor, then Guardian PAN No to be provided | Char(10) | Yes |  |  |
| holder2PanNo | Second Holder PAN Number | Char(10) | Conditional Mandatory |  | If modeOfHld is not Single, Then holder2PanNo is mandatory else should be empty |
| holder3PanNo | Third Holder PAN Number | Char(10) | Conditional Mandatory |  | If modeOfHld is not Single, Then holder3PanNo is mandatory  else should be empty |

#### PAN Verify Service API – Response

#### Table 4

Source cells: `B16:D16`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B18:D21`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

Source cells: `B23:D25`

| panVerifyRefNo | PAN Verfiy Reference Number. This reference number used in CAN registration service API. | Char(20) |
| --- | --- | --- |
| canAvailFlg | CAN available flag.<br>Y –  CAN is already available in MFU system.<br>N – CAN is not available in MFU system. | Char(1) |
| can | Common Account Number (CAN). <br>If canAvailFlg is Y CAN number is available otherwise empty | Char(10) |

#### panList (section wise error list array section start)

#### Table 7

Source cells: `B27:D33`

| pan | PAN Number | Char(10) |
| --- | --- | --- |
| panValFlg | PAN valid Flag.<br>Y  - Valid PAN with approved KRA Status<br>N - Invalid PAN KRA Status | Char(1) |
| panName | Name of the PAN holder received from KRA | Char(105) |
| panKycSt | PAN KYC Status<br>PE – Pending<br>AP – Approved<br>RJ – Rejected<br>BL – Blacklisted in MFU<br>TM – Timed out<br>NA – Not Applicable | Char(2) |
| mfuKycStatus | PAN MFU KYC Status<br>VAL - Validated KRA<br>VRF - Verified at KRA<br>DRK - Pending-KRA<br>PEN - Pending-MFU<br>RJK - Rejected-KRA<br>HLD - On Hold-KRA<br>RJK - Rejected-KRA<br>NAK - Unknown/Not Available<br>DEL - Deactivated-KRA<br>OKR - OLD KYC RECORD<br>OHK - Pending-Non-MF KYC<br>INC - Registered-Non-MF KYC<br>OKR - On Hold-Non-MF KYC<br>PAK - Rejected-Non-MF KYC<br>INC - Registered-Non-MF KYC<br>UVK - Registered-CVL MF KYC | Char(3) |
| panAppStatus | The PAN APP_STATUS which is received from KRA's<br>This value will be empty for the existing CAN's | Char(10) |
| panAppUpdtStatus | The PAN APP_UPDT_STATUS which is received from KRA's<br>This value will be empty for the existing CAN's | Char(10) |

#### panList  (section wise error list array section end)

#### Table 8

Source cells: `B35:D35`

| txnEligFlg | CAN Transaction Eligible Flag<br>Y – CAN Transaction is eligible<br>N – CAN Transaction is not eligible | Char(1) |
| --- | --- | --- |

#### txnErrLst (section wise error list array section start) if txnEligFlg is N

#### Table 9

Source cells: `B37:D37`

| errCode | Transaction Error Code.<br>01 : CAN FATCA Detail is not available.<br>02 : CAN Contact is not verified<br>03 : CAN Nominee is not verified<br>04 : Nomination in the selected CAN is non-compliant with recent regulatory requirements | Char(2) |
| --- | --- | --- |

#### txnErrLst (section wise error list array section end)

#### respBody Section End

#### PAN Verify Service API – Sample Request and Response

#### Table 10

Source cells: `B42:C47`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C43)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2026-01-20 10:20:09","apiType": "eCAN-PAN-VERIFY","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C44)

```json
{    
"modeOfHld":"SI",    "resdStatus":"RI",    "panNo":"XXXPX1234Y",    "holder2PanNo":"",    "holder3PanNo":""
}
```

##### JSON example 3 (cell C45)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C46)

```json
{
"respHeader":{"respFlag":"S","respTs":"2026-01-20 10:20:20","errorCode":"","errorMsg":""},"respBody":{"panVerifyRefNo":"1000961689775495R36K","canAvailFlg":"Y","can":"XXXXXXXXXX","panList":[{"pan":"","panValFlg":"Y","panName":"XXXXXXXXXXXXXXXXXXXXXX","panKycSt":" AP","mfuKycStatus":"VAL","panAppStatus":"007","panAppUpdtStatus":"007"}],"txnEligFlg":"N","txnErrLst":[{"errCode":"01"},{"errCode":"02"}]}
}
```

##### JSON example 5 (cell C47)

```json
{
"respHeader":{"respFlag":"F","respTs":"2026-01-20 10:20:20","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"panVerifyRefNo":"","canAvailFlg":"","can":"","panList":[{"pan":"","panValFlg":"","panName":"","panKycSt":"","mfuKycStatus":"","panAppStatus":"","panAppUpdtStatus":""}],"txnEligFlg":"","txnErrLst":[]}
}
```

### CAN-REG

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-REG`

#### CAN Registration Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/APIFinTechCANCreateService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-REG | Char(20) | Yes | CAN-REG | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:G12`

| reqEvent | Request Event | Char(2) | Yes | Allowed Values:<br>CR-New CAN creation<br>CM – Modification of existing CAN. | Column G |
| --- | --- | --- | --- | --- | --- |
| can | Common Account Number (CAN). | Char(10) | Conditional Mandatory |  | For reqEvent CM : this field is mandatory |
| panVerifyRefNo | PAN verify Reference Number which is recevied from eCAN-PAN-Verify service .  | Char(20) | Conditional Mandatory |  | If the Entity is enabled for Workflow type 3, this field is mandatory. Otherwise empty value should  be passed |
| proofUploadByCan | Whether Proof upload facility to be given to CAN holder. | Char(1) | Yes | Allowed Values:<br>Y-Yes<br>N-No |  |
| onlineAccessFlag | Whether the enable online access flag  facility to be given to CAN Holder | Char(1) | Yes | Allowed Values:<br>Y-Yes<br>N-No |  |

#### entEmailList Array List Section Start

#### Table 4

Source cells: `B14:E14`

| emailId | Email ID of entity users to which the communication to be sent. | char(100) | No |
| --- | --- | --- | --- |

#### entEmailList Array List Section End

#### Table 5

Source cells: `B16:F19`

| holdType | Holding Type | Char(2) | Yes | Allowed Values:<br>AS – Anyone of Survivor<br>JO - Joint<br>SI – Single |
| --- | --- | --- | --- | --- |
| invCategory | Investor Category | Char(1) | Yes | Allowed Values:<br>I - Individual<br>M - Minor<br>S - Sole-proprietor  |
| taxStatus | Tax Status | Char(2) | Yes | Refer Master Data Sheet : Tax Master for the allowed values |
| holderCount | Number of Holders<br> | Numeric | Yes |  |

#### holderList Array List Section Start

#### Table 6

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

#### kycSec Section Start

#### Table 7

Source cells: `B32:F32`

| kycStatus | PAN KRA KYC Status | Char(3) | Conditional Mandatory | Allowed Values:<br>KRG -  KRA Registered<br>VAL  - KRA Validated<br>VRF  - Approved-KRA<br>DRK - Pending KRA<br>UPK - Under Processing at KRA<br>NAK - Unknown/Not Available |
| --- | --- | --- | --- | --- |

#### resAddrDetail Section Start

#### Table 8

Source cells: `B34:F40`

| addr1 | Residential Address Line 1 | Char(120) | Conditional Mandatory | Column F |
| --- | --- | --- | --- | --- |
| addr2 | Residential Address Line 2 | Char(120) | Conditional Mandatory |  |
| addr3 | Residential Address Line 3 | Char(120) | No |  |
| city | Residential City | Char(30) | Conditional Mandatory |  |
| pinCode | Residential Pin code | Char(6) | Conditional Mandatory |  |
| state | Residential State Code | Char(4) | Conditional Mandatory | Refer Master Data Sheet : State Master for the allowed values |
| country | Residential Country Code | Char(3) | Conditional Mandatory | Refer Master Data Sheet : Country Master for the allowed values |

#### resAddrDetail Section End

#### perAddrDetail Section Start

#### Table 9

Source cells: `B43:F49`

| addr1 | Permanent Address Line 1 | Char(120) | Conditional Mandatory | Column F |
| --- | --- | --- | --- | --- |
| addr2 | Permanent Address Line 2 | Char(120) | Conditional Mandatory |  |
| addr3 | Permanent Address Line 3 | Char(120) | No |  |
| city | Permanent City | Char(30) | Conditional Mandatory |  |
| pinCode | Permanent Pin code | Char(6) | Conditional Mandatory |  |
| state | Permanent State Code | Char(4) | Conditional Mandatory | Refer Master Data Sheet : State Master for the allowed values |
| country | Permanent Country Code | Char(3) | Conditional Mandatory | Refer Master Data Sheet : Country Master for the allowed values |

#### perAddrDetail Section End

#### contactSec Section Start

#### Table 10

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

#### contactSec Section End

#### OtherSec Section Start

#### Table 11

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

#### OtherSec Section End

#### fatcaSec Section Start

#### Table 12

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

#### taxDetail Section Start

#### Table 13

Source cells: `B86:G90`

| taxCountry | Tax Details Country | Char(3) | Conditional Mandatory | Refer Master Data Sheet : Country Master for the allowed values | Conditional Mandatory based on TAX_RES_FLAG |
| --- | --- | --- | --- | --- | --- |
| taxCountryOth | Tax Country Other | Char(50) | Conditional Mandatory |  | Conditional Mandatory based on TAX_RES_FLAG |
| taxRefno | Tax Reference Number | Char(20) | Conditional Mandatory |  | Conditional Mandatory based on TAX_RES_FLAG |
| identiType | Identification Type | Char(1) | Conditional Mandatory | Allowed Values:<br>F - Dependent Visa<br>K - Diplomat Visa<br>N - Global Entity Identification Number<br>D - ID Card<br>M - Mariner/Sea farer<br>I - Social Security ID Card<br>S - Sportsperson/Professional<br>J - Student Visa<br>T - TIN<br>Q - US GIIN | Conditional Mandatory based on TAX_RES_FLAG |
| identiTypeOth | Identification Type Other | Char(50) | Conditional Mandatory |  | Conditional Mandatory based on TAX_RES_FLAG |

#### taxDetailSection End

#### fatcaSec Section End

#### holderList Array List Section End

#### arnSec Section Start

#### Table 14

Source cells: `B95:E97`

| arnNo | ARN Code | Char(15) | No |
| --- | --- | --- | --- |
| riaCode | RIA Code | Char(12) | No |
| euinCode | EUIN Code | Char(20) | No |

#### arnSec Section End

#### consentList Array List Section Start

#### Table 15

Source cells: `B100:G101`

| dataSet | Consent Data Set | Char(2) | Conditional Mandatory | Allowed Values:<br>CD - CAN Data Set<br>PD - PayEezz Data<br>MF - Mapped Folio <br>HD - Holding Data | If Either ARN or RIA code is attached in request, consent Detail array is mandatory.<br>CONSENT_DETAILS array all the 4 Data set should be there enabled or disabled for data set |
| --- | --- | --- | --- | --- | --- |
| consentFlag | Consent Data Set Enabled Flag | Char(1) | Conditional Mandatory | Allowed Values:<br>Y - Consent is enabled for the given Data set<br>N - Consent is not enabled |  |

#### consentList Array List Section End

#### dpSec Section Start

#### Table 16

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

#### dpSec Section End

#### bnkList Array List Section Start

#### Table 17

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

#### bnkList Array List Section End

#### nomSec Section Start

#### Table 18

Source cells: `B128:F130`

| nomDecl | Nominee Declaration Level flag | Char(1) | Conditional Mandatory | Allowed Values:<br>C - CAN Level |
| --- | --- | --- | --- | --- |
| nomOptFlag | Nominee Opt Flag.  | Char(1) | Yes | Allowed Values:<br>Y - Checked<br>N - Not Checked |
| nomFolioSoa | Nominee Folio SOA  | Char(1) | Conditional Mandatory | Allowed Values:<br>Y - Yes<br>N - No |

#### nomList Array List Section Start (Conditional Mandatory Based on NOMIN_OPT_FLAG is Y, Then this section is mandtory )

#### Table 19

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

#### nomList Array List Section End

#### nomSec Section End

#### CAN Registration Service API – Response

#### Table 20

Source cells: `B154:D154`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 21

Source cells: `B156:D159`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 22

Source cells: `B161:D165`

| can | Common Account Number (CAN). | Char(10) |
| --- | --- | --- |
| proofUploadLink | Proof Upload Link | Char(150) |
| nomVerifyLinkH1 | Nominee Verfiy Link Holder 1 | Char(150) |
| nomVerifyLinkH2 | Nominee Verfiy Link Holder 2 | Char(150) |
| nomVerifyLinkH3 | Nominee Verfiy Link Holder 3 | Char(150) |

#### respBody Section End

#### CAN Registration Service API – Sample Request and Response

#### Table 23

Source cells: `B169:C174`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C170)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "CAN-REG","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C171)

```json
{
"reqEvent":"CR","can":"XXXXXXXXXX","panVerifyRefNo":"XXXXXXXXXX","proofUploadByCan":"","onlineAccessFlag":"N","entEmailList":[{"emailId":""}],"holdType":"SI","invCategory":"I","taxStatus":"RI","holderCount":"0","holderList":[{"holderType":"","name":"","dob":"","panExemptFlag":"","panOrPekrn":"","relationship":"","relProofType":"","nomVerifyFlag":"","nomVerifyIPAddr":"","kycSecType":"","kycSec":{"kycStatus":"","resAddrDetail":{"addr1":"","addr2":"","addr3":"","city":"","pinCode":"","state":"","country":""},"perAddrDetail":{"addr1":"","addr2":"","addr3":"","city":"","pinCode":"","state":"","country":""}},"contactSec":{"mobIsd":"","mobNo":"1234567890","mobBelongsTo":"SE","emailId":"XXXXX@gmail.com","emailBelongsTo":"SE","mobVerifyFlag":"N","emailVerifyFlag":"N","mobVerifyIpAddr":"","emailVerifyIpAddr":"","mobVerifyTs":"","emailVerifyTs":""},"OtherSec":{"grossIncome":"","networth":"","networthDate":"","sourceOfWealth":"","sourceOfWealthOth":"","kraAddrType":"","occp":"","occpOth":"","pep":"","anyOtherInfo":""},"fatcaSec":{"birthCity":"","birthCountry":"","birthCountryOth":"","citizenship":"","citizenshipOth":"","nationality":"","nationalityOth":"","taxResFlag":"","taxDetail":{"taxCountry":"","taxCountryOth":"","taxRefno":"","identiType":"","identiTypeOth":""}}}],"arnSec":{"arnNo":"","riaCode":"","euinCode":""},"consentList":[{"dataSet":"","consentFlag":""}],"dpSec":{"nsdlDpId":"","nsdlClientId":"","nsdlProofId":"","nsdlVerifyFlag":"","cdslDpId":"","cdslClientId":"","cdslProofId":"","cdslVerifyFlag":""},"bnkList":[{"defaultAccFlag":"","accNo":"","accType":"","bankId":"","ifsc":"","micr":"","proof":"","rupVerifyFlag":"","rupBenName":"","rupThresHold":"","rupIpAddr":"","rupTs":""}],"nomSec":{"nomDecl":"","nomOptFlag":"","nomFolioSoa":"","nomList":[{"nomName":"","relation":"","percentage":"","dob":"","gurdName":"","gurdRel":"","gurdDOB":"","piType":"","piNo":"","mobile":"","email":"","addr1":"","addr2":"","addr3":"","pinCode":"","city":"","country":""}]}
}
```

##### JSON example 3 (cell C172)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C173)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"can":"XXXXXXXXX","proofUploadLink ":"XXXXXXXXXXXXXXXXXXXXXXXXX","nomVerifyLinkH1":"","nomVerifyLinkH2":"","nomVerifyLinkH3":""}
}
```

##### JSON example 5 (cell C174)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"can":"","proofUploadLink ":"","nomVerifyLinkH1":"","nomVerifyLinkH2":"","nomVerifyLinkH3":""}
}
```

### CAN-STATUS

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-STATUS`

#### CAN Data Status Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFintechCanStatusService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-STATUS | Char(20) | Yes | CAN-STATUS | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:E8`

| can | Common Account Number (CAN). | Char(10) | Yes |
| --- | --- | --- | --- |

#### CAN Data Status Service  API – Response

#### Table 4

Source cells: `B12:D12`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B14:D17`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

Source cells: `B19:D22`

| can | Common Account Number (CAN). | Char(10) |
| --- | --- | --- |
| proofUploadLink | Proof Upload Link | Char(150) |
| msg | Response message | Char(100) |
| canStatus | CAN Status | Char(2) |

#### blockRespList (section wise error list array section start)

#### Table 7

Source cells: `B24:D27`

| blockName | Block Name | Char(50) |
| --- | --- | --- |
| blockSubName | Block Sub Name | Char(50) |
| seqNo | Sequence Number | Numeric |
| respType | Response Type | Char(150) |

#### blockRespList (section wise error list array section end)

#### respBody Section End

#### CAN Data Status Service  API – Sample Request and Response

#### Table 8

Source cells: `B32:C37`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C33)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "CAN-STATUS","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C34)

```json
{
"can":"XXXXXXXXXX"
}
```

##### JSON example 3 (cell C35)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C36)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"can":"XXXXXXXXXXX","proofUploadLink ":"","msg":"Data submitted suuceesfully","canStatus":"PE","blockRespList":[{"blockName":"","blockSubName":"","seqNo":"","respType":"","respCode":""}]}
}
```

##### JSON example 5 (cell C37)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"can":"","proofUploadLink ":"","msg":"","canStatus":"","blockRespList":[{"blockName":"","blockSubName":"","seqNo":"","respType":"","respCode":""}]}
}
```

### CAN-PROOF-IMG

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-PROOF-IMG`

#### CAN Image Proof Upload Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechCanProofImageService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-PROOF-IMG | Char(20) | Yes | CAN-PROOF-IMG | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:G12`

| can | Common Account Number (CAN). | Char(10) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| event | Event Type of the Image | Char(2) | Yes | Allowed values are:<br>  AD - Upload New Proof Image for the CAN<br>  UP - Update Existing Proof Image for the CAN<br>  DE - Delete the existing Proof Image for the CAN |  |
| imgRefNo | Image Reference Number | Char(10) | Conditional Mandatory |  | This field is mandatory for Update and Delete event only. For Add event it should be empty.<br>In Case of Update, Old Image will not be available in MFU System. |
| proofType | Proof Type.<br>Module Related information to indicate the type of proof being uploaded.  | Char(5) | Yes | <br><br>Refer Master Data Sheet : eCAN Image Proof Type :: refer column code for the allowed values |  |
| imgData | Image byte array Data. The byte array should be converted in  Base64 encoded format. | Text | Yes |  | The size of the image data should not be greater than  500KB.<br>Only jpg, jpeg,png formats are allowed |

#### CAN Image Proof Upload API – Response

#### Table 4

Source cells: `B16:D16`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B18:D21`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

Source cells: `B23:D24`

| imgRefNo | Image Reference Number | Char(10) |
| --- | --- | --- |
| msg | Response message | Char(100) |

#### respBody Section End

#### CAN Image Proof Upload API – Sample Request and Response

#### Table 7

Source cells: `B28:C32`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Success Response withOut Encryption | [See JSON example 3 below] |
| Failure Response withOut Encryption  | [See JSON example 4 below] |

#### JSON examples

##### JSON example 1 (cell C29)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "CAN-PROOF-IMG","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C30)

```json
{
"can":"XXXXXXXXXX","event":"AD","imgRefNo":"","proofType":"4#FA","imgData":"SUkqAEpNAgBKTjd1eWJucltwdF2Chm98gGmDh3COknuDh3CEiHGEiHGFiXKGinOHi3SHi3SIjHWJjHmLkHyPk4KNloOIlYGAknx2jHdwiXOAmYR+m4WAnYeBoYqEpI+Hp5KLqJSMqZWDopCDopCDopCEo5GEo5OEo5OFpJSFpJSBoJGCoZKDopOEo5SFo5eGpJiHpZmHp5yAn5qFpaJ2lpN5mZZ9nZp3l5SLq6iFpaKFpaKCop+d9k4d+kod+kod+MAAAo/C9QAAAAAQNxqgAAAAAAIrhwoAAAAgAA=="
}
```

##### JSON example 3 (cell C31)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"imgRefNo":"XXXXXXXXXXXX","msg":"Data submited successfully"}
}
```

##### JSON example 4 (cell C32)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"imgRefNo":"","msg":""}
}
```

### eNACH-REG

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `eNACH-REG`

#### eNach Registration Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/MfuePayEezzRegService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be eNACH-REG | Char(20) | Yes | eNACH-REG | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

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

#### eNach Registration API – Response

#### Table 4

Source cells: `B25:D25`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B27:D30`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

Source cells: `B32:D33`

| mmrn | MFU Mandate Reference Number (Reference Number generated by MFU for the Mandate Request).  | Char(20) |
| --- | --- | --- |
| approveLink | Link for approving the Mandate request. This link will either be shared in response to entity system or may be directly sent to the concerned investor depending configuration. In case the system is configured to send the link to investor, this field will be empty in response | Char(500) |

#### respBody Section End

#### eNach Registration API – Sample Request and Response

#### Table 7

Source cells: `B37:C41`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Success Response withOut Encryption | [See JSON example 3 below] |
| Failure Response withOut Encryption  | [See JSON example 4 below] |

#### JSON examples

##### JSON example 1 (cell C38)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "eNACH-REG","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C39)

```json
{
"mandateType":"T","regMode" : "PN","can":"","arnCode" : "","riaCode" : "INA987654321","euin":"","accNo":"","accType":"","ifscCode":"","micrCode":"","maxAmt":"","perpetualFlag":"","startDate":"","endDate":""
} 
```

##### JSON example 3 (cell C40)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"mmrn":"15253198911272F080CC ","approveLink":"http://14.141.212.169:7002/callEPayeezzConfirm.do?param1=XXXXXXXXXXXXXXXX&param2=NBBC9&param3=A "}
}
```

##### JSON example 4 (cell C41)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid RIA code"},"respBody":{"mmrn":"","approveLink":""}
}
```

### eNACH-STATUS

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `eNACH-STATUS`

#### eNach Registration Status check Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/MfuePayEezzStatusService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be eNACH_STATUS | Char(20) | Yes | eNACH_STATUS | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:F10`

| mandateType | Mandate Creation Type. | Char(1) | Yes | By Default T should be passed |
| --- | --- | --- | --- | --- |
| can | Common Account Number (CAN). | Char(10) | Yes |  |
| mmrn | MMRN | Char(20) | Yes |  |

#### eNach Registration Status check Service API – Response

#### Table 4

Source cells: `B14:D14`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B16:D19`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

Source cells: `B21:D23`

| prn | PRN number | Char(20) |
| --- | --- | --- |
| mfuRegStatus | MMRN (Mandate) Registration Status as available in MFU.Value will be two character code like RQ / CL / PA - accordingly it should be handled<br>RQ	- Pending       <br>PA	- Approved   <br>PR	- Rejected      <br>CL	- Cancelled | Char(2) |
| aggrStatus | Mandate Status as provided by the Payment Aggregator<br>PE - Pending                         <br>AC - Aggregator Accepted<br>RA  - Aggregator Rejected<br>CL - Cancelled                      <br>MX - Mandate Expired      <br>RV - Mandate Revoked     <br>PS - Mandate Paused         | Char(2) |

#### respBody Section End

#### eNach Registration Status check Service API – Sample Request and Response

#### Table 7

Source cells: `B27:C31`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Success Response withOut Encryption | [See JSON example 3 below] |
| Failure Response withOut Encryption  | [See JSON example 4 below] |

#### JSON examples

##### JSON example 1 (cell C28)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "eNACH_STATUS","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C29)

```json
{
"mandateType":"T","can":"XXXXXXXXXX","mmrn":"XXXXXXXXXXXXXXXXXXXX"
}
```

##### JSON example 3 (cell C30)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"prn":"XXXXXXXXXXXXXX","regStatus":"RQ","aggrStatus":"PE"}
}
```

##### JSON example 4 (cell C31)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"prn":"","mfuRegStatus":"","aggrStatus":""}]}
}
```

### eNACH-PUSH

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `eNACH-PUSH`

#### eNach Push Service API

#### Table 1

Source cells: `B3:E3`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

This is a Mandate callback push service. MFU will iniaite the request to send the data to entity. The entity need to share the Push URL for recevied this transaction response.

For this service, oAuth is mandatory. Entity need to provide the oAuth URL. The oAuth request and repsonse format should be in MFU oAuth Format. For oAuth refer sheet Authorization with OAuth 2.0

#### respHeader Section – without encryption JSON Field Details

#### Table 2

Source cells: `B7:D10`

| versionNo | Char(5) | Version number for the Web service. The version number is 1.00 |
| --- | --- | --- |
| reqTS | Date Time | The request initatied timestamp in Entity System.<br>The time format is YYYY-MM-DD HH:MM:SS |
| apiType | Char(20) | The API Type should be eNACH-PUSH |
| uniqueId | Char(50) | Unique ID created at the MFU system and shared in the request. Unique Id should not be duplicated |

#### respHeader Section End

#### respBody Section – without encryption JSON Field Details

#### mandateLst Array List Section Start

#### Table 3

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

#### mandateLst Array List Section End

#### respBody Section End

#### eNach Push Service Service Sample Response

#### Table 4

Source cells: `B27:C29`

| Sample Type | Sample |
| --- | --- |
| Response with Encryption | [See JSON example 1 below] |
| Response withOut Encryption | [See JSON example 2 below] |

#### JSON examples

##### JSON example 1 (cell C28)

```json
{"respData":"3Dlv69kqFld9U_p3MLLpL3dfov-pF46nBAm3qGH6W-FC1iIOEbMHreRMts8NvfBuSzSR6RwDAd2LX7lnKQkZIKDZr1Td3RsFJbMbG04LMSZ9ykVNEmFKyobsSnALxJFlb6-Igo1LWu973hNzSUsQ-Mlordx6Y5fJqOsaO2n-t8F37Z7tpIF2sGf0sp6hyIpvmq1AVLTn4ERfbLvy-D6-v4tDdWfHHwqGOzwVIghiiyTeEc3oxT1XxhMytV2qUJxgrbJ-5xzpJjqdMrL51NtlN5V0YqGC8QLC1w0rt1o599OAmHhnbLnKhiOvhoPby_xHy2IE71Kp5_bIll6GzT9WSnL5en1844aHrNQxQtb6Ufm6v95u7aya1sQQL-72N_gxIgvsOpJIzOcexlLX0BVJ-vxjq1dYAxFU0GJjU_tw5VCsJPtS1takm9iS9ex7MMLQBwtJZXYl52exghbNlgNaLNnEFahvhMhdvzR0H7Tp2xROnKH0UE01NJLnwfXK-R64cs8FqIigMF8Qb1vHHA5tAMrwIcwJDRvC0-di1mI2PkuianlY4W-2Un7S39eEdsaInshBMlZUXJxmIaqV4DeEv159yKIYpH282QZsEifDV4xJ4RBkXB-Bet_VNwrSLfJ1jfliIGPVIAKOT8zdAFivWAKOaQa86PGu4yBLa4QqlGbRJOep-9khNC9JZ-EJ5hAF3GAvxvFGK-Q3TjaYdTNB8ktm97UihSJA1bbn_0XLdh1dfsHey_qpcRcQimL4biZiBAl2oPkOeQepHqiyE9nQdNE3rOhTMjaN-2HMrD6mRzyHfZ4swtVvbKkJvbeKYyCYP5ESKFFRGNrHe5sVM-m-wi_MqfKvP1HMi4YSD9bV560R469mUQI838It8LswhUgA"}
```

##### JSON example 2 (cell C29)

```json
{"respHeader":{"respFlag": "S","respCode": "0","respMsg": "Success"},"respBody":"mandateLst": [{"mandateType":"T","can": "","canName": "","mmrn": "","prn":"","mfuStatus":"","aggrStatus":"","remarks":""}]]}}
```

### MAND-CREATION-API

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `MAND-CREATION-API`

#### UPI Auto Pay Mandate Creation API – Request

#### URL to Invoke this API : https://<UAT or PROD URL>/MfuUpiAutoPayRegService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The API Type should be UPI-AUTOPAY | Char(20) | Yes | UPI-AUTOPAY | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section – without encryption JSON Field Details

#### Table 3

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

#### UPI Auto Pay Mandate Creation API– Response

#### Table 4

Source cells: `B24:D24`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respData Section – without encryption JSON Field Details

#### Table 5

Source cells: `B26:D32`

| respFlag | Response Flag.<br>The Possiable values are <br>S – Success<br>F – Failure | Char(1) |
| --- | --- | --- |
| respCode | Response Code.<br>If respFlag is S , the respCode is Zero<br>If respFlag is F, the respCode contains the Error code | Char(10) |
| respMsg | For Success, the respMsg have success Message.<br>For Failure case, the respMsg have the error message for the request | Char(500) |
| mumrn | MFU Mandate Reference Number (Reference Number generated by MFU for the Mandate Request). | Char(20) |
| approveLink | Link for approving the Mandate request. This link will either be shared in response to entity system or may be directly sent to the concerned investor depending configuration. In case the system is configured to send the link to investor, this field will be empty in response | Char(500) |
| deepLink | UPI Intent Flow Deep Link URL if this is a intent workflow otherwise empty value will be passed<br>This field is available only if workflowType is 'I'. | Char(1000) |
| qrCode | UPI QR Code base64  to display the payment QR code to the investor. | Char(5000) |

#### UPI Auto Pay Mandate Creation API– Sample Request and Response

#### Table 6

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

#### JSON examples

##### JSON example 1 (cell C36)

```json
{
"reqHeader": {"entityId":"420002","apiType" : "UPI-AUTOPAY","version": "1.00","reqTS": "2021-08-24 10:20:09","uniqueId" : "REQ2687654212802" }, 
"reqBody": {"data": "yXOzCUf6KJtUshOvZi+xQxdto1oQH8vFiqiTCyJBWn6PUq6sT+YfiN7mnpCBr9zAmAwZKuHY4B6SjM7R71UWqABRvI+th0mgA9K+tcCcmntX55RoWh7JKJ0FAS2fhOA9H3WeFPp/z9GxU1VoX1Lq2df6nOLqvhpD3QyMbijkoOlWguDnHcjQBhl8zgxc8htC+BEer7sODEXmxF/Tkqrkar4BrA/tN7l71cS3kzZVBqy2I0WCh+9yjqriXKAccQpGQodg6YILEmJTSwYxd99tJUVrSoT46Y5G7BmfBJgvDNA=" }
}
```

##### JSON example 2 (cell C37)

```json
{
"mandateType":"T","can":"","arnCode" : "","riaCode" : "INA987654321","euin":"","accNo":"","accType":"","ifscCode":"","micrCode":"","maxAmt":"","endDate":"","deviceType":"","linkType":""
}
```

##### JSON example 3 (cell C38)

```json
{
"respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C39)

```json
{ "respFlag": "S","respCode": "0","respMsg": "","mumrn":"15253198911272F080CC ","approveLink":"http://14.141.212.169:7002/callUpiAutoPayConfirm.do?param1=1563443398216CD91FA9&param2=NBBC9&param3=A","deepLink":"","qrCode":"" }
```

##### JSON example 5 (cell C40)

```json
{"respFlag":"S","respCode":0,"respMsg":"Success","mumrn":"14176AYA012635104929000431EFB","approveLink":"","deepLink":"upi://mandate?pa=cpayupiap@icici&pn=CAMSPay&tr=EZM2026020410493009778950&am=1.00&cu=INR&orgid=400011&mc=6211&purpose=14&tn=Mandate%20Creation&validitystart=04022026&validityend=28022026&amrule=MAX&recur=ASPRESENTED&rev=Y&share=Y&block=N&txnType=CREATE&mode=04&sign=MEQCIFkOu/WBxGZ/MFDdLhjhe7XO+w4wxjQaEhPBaC+gxcLOAiBNpj5Ct4NIidHV11s39Gj29pdEapw7zB/SpMOIOAa9wA==" ,"qrCode":"iVBORw0KGgoAAAANSUhEUgAAB0QAAAdECAYAAADUj7i/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAP+lSURBVHhe7NnBqi1LsizZ9/8/XdXIrkyIjSpn6TWXAdJWx2LulQnn//1/kiRJkiRJkiRJknSU/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW/0FUkiRJkiRJkiRJ0ln+B1FJkiRJkiRJkiRJZ/kfRCVJkiRJkiRJkiSd5X8QlSRJkiRJkiRJknSW"}
```

##### JSON example 6 (cell C41)

```json
{
"respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 7 (cell C42)

```json
{
"respFlag": "F","respCode": "10058","respMsg": "Invalid RIA code","mumrn":"","approveLink":"","deepLink":"","qrCode":""
}
```

### MAND-CREATION-STATUS-API

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `MAND-CREATION-STATUS-API`

#### UPI Auto Pay Mandate Creation Status API – Request

#### URL to Invoke this API : https://<UAT or PROD URL>/MfuUpiAutoPayStatusService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The API Type should be UPIAUTPY-STATUS | Char(20) | Yes | UPIAUTPY-STATUS | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section – without encryption JSON Field Details

#### Table 3

Source cells: `B8:F10`

| mandateType | Mandate Creation Type. | Char(1) | Yes | By Default T should be passed |
| --- | --- | --- | --- | --- |
| can | Investor Common Account Number | Char(10) | Yes |  |
| mumrn | MFU Mandate Reference Number | Char(20) | Yes |  |

#### UPI Auto Pay Mandate Creation Status API – Response

#### Table 4

Source cells: `B14:D14`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respData Section – without encryption JSON Field Details

#### Table 5

Source cells: `B16:D21`

| respFlag | Response Flag.<br>The Possiable values are <br>S – Success<br>F – Failure | Char(1) |
| --- | --- | --- |
| respCode | Response Code.<br>If respFlag is S , the respCode is Zero<br>If respFlag is F, the respCode contains the Error code | Char(10) |
| respMsg | For Success, the respMsg have success Message.<br>For Failure case, the respMsg have the error message for the request | Char(500) |
| aumrn | ​Aggregator Mandate Reference Number. This reference number is used to place the transaction using UPI Auto Pay. | Char(20) |
| regStatus | MMRN (Mandate - UPI AutoPay) Registration Status as available in MFU.Value will be two character code like RQ / CL / PA - accordingly it should be handled<br>RQ        : Pending<br>PA        :  Approved<br>PR        :  Rejected<br>CL        : Cancelled | Char(2) |
| aggrStatus | Mandate (UPI AutoPay) Status as provided by the Payment Aggregator<br>PE        :  Pending<br>AC        :  Aggregator Accepted<br>RA        :  Aggregator Rejected<br>RV        :  Mandate Revoked<br>PS        :  Mandate Paused | Char(2) |

#### UPI Auto Pay Mandate Creation Status API – Sample Request and Response

#### Table 6

Source cells: `B25:C31`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Success Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response with Encryption | [See JSON example 5 below] |
| Failure Response withOut Encryption | [See JSON example 6 below] |

#### JSON examples

##### JSON example 1 (cell C26)

```json
{
"reqHeader": {"entityId":"420002","apiType" : "UPIAUTPY-STATUS","version": "1.00","reqTS": "2021-08-24 10:20:09","uniqueId" : "REQ2687654212802" }, 
"reqBody": {"data": "yXOzCUf6KJtUshOvZi+xQxdto1oQH8vFiqiTCyJBWn6PUq6sT+YfiN7mnpCBr9zAmAwZKuHY4B6SjM7R71UWqABRvI+th0mgA9K+tcCcmntX55RoWh7JKJ0FAS2fhOA9H3WeFPp/z9GxU1VoX1Lq2df6nOLqvhpD3QyMbijkoOlWguDnHcjQBhl8zgxc8htC+BEer7sODEXmxF/Tkqrkar4BrA/tN7l71cS3kzZVBqy2I0WCh+9yjqriXKAccQpGQodg6YILEmJTSwYxd99tJUVrSoT46Y5G7BmfBJgvDNA=" }
}
```

##### JSON example 2 (cell C27)

```json
{
"mandateType":"T","can":"XXXXXXXXX","mumrn":"XXXXXXXXXXXXXXXXXXXX"
}
```

##### JSON example 3 (cell C28)

```json
{
"respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C29)

```json
{
"respFlag": "S","respCode": "0","respMsg": "","aumrn":"XXXXXXXXXXXXXXXXXXXX","regStatus":"RQ","aggrStatus":"PE"
}
```

##### JSON example 5 (cell C30)

```json
{
"respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 6 (cell C31)

```json
{
"respFlag": "F","respCode": "10058","respMsg": "Invalid CAN","aumrn":"","regStatus":"","aggrStatus":""
}
```

### MAND-CALLBK-PUSH

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `MAND-CALLBK-PUSH`

#### Mandate Callback Push Service API

#### Table 1

Source cells: `B3:E3`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

This is a Mandate callback push service. MFU will iniaite the request to send the data to entity. The entity need to share the Push URL for recevied this transaction response.

For this service, oAuth is mandatory. Entity need to provide the oAuth URL. The oAuth request and repsonse format should be in MFU oAuth Format. For oAuth refer sheet Authorization with OAuth 2.0

#### respHeader Section – without encryption JSON Field Details

#### Table 2

Source cells: `B7:D8`

| versionNo | Char(5) | Version number for the Web service. The version number is 1.00 |
| --- | --- | --- |
| rptDateTime | Date Time | Mandate Callback Push send time stamp. Timestamp format is YYYY-MM-DD HH:MM:SS |

#### respHeader Section End

#### respBody Section – without encryption JSON Field Details

#### mandCallbkList Array List Section Start

#### Table 3

Source cells: `B12:D17`

| can | Char(10) | The Common Account Number as allotted by MFU system. |
| --- | --- | --- |
| mumrn | Char(20) | MFU Mandate Reference Number (Reference Number generated by MFU for the Mandate Request). |
| regStatus | Char(2) | Mandate - UPI AutoPay Registration Status as available in MFU.<br>Allowed values:<br>RQ:Pending<br>CL:Cancelled<br>PA:Confirmed<br>PR:Rejected |
| aggrStatus | Char(2) | Mandate (UPI AutoPay) Status as provided by the Payment Aggregator<br>Allowed values:<br>PE        :  Pending<br>AC        :  Aggregator Accepted<br>RA        :  Aggregator Rejected<br>RV        :  Mandate Revoked<br>PS        :  Mandate Paused<br>PR        : Rejected<br>PA        : Approved |
| aumrn | Char(20) | ​Aggregator Mandate Reference Number. This reference number is used to place the transaction using UPI Auto Pay. |
| eventTs | Date Time | Timestamp of the event<br>The date time format is YYYY-MM-DD HH:MM:SS |

#### mandCallbkList Array List Section End

#### respBody Section End

#### Mandate Callback Push Service Sample Response

#### Table 4

Source cells: `B23:C25`

| Sample Type | Sample |
| --- | --- |
| Response with Encryption | [See JSON example 1 below] |
| Response withOut Encryption | [See JSON example 2 below] |

#### JSON examples

##### JSON example 1 (cell C24)

```json
{"respData":"3Dlv69kqFld9U_p3MLLpL3dfov-pF46nBAm3qGH6W-FC1iIOEbMHreRMts8NvfBuSzSR6RwDAd2LX7lnKQkZIKDZr1Td3RsFJbMbG04LMSZ9ykVNEmFKyobsSnALxJFlb6-Igo1LWu973hNzSUsQ-Mlordx6Y5fJqOsaO2n-t8F37Z7tpIF2sGf0sp6hyIpvmq1AVLTn4ERfbLvy-D6-v4tDdWfHHwqGOzwVIghiiyTeEc3oxT1XxhMytV2qUJxgrbJ-5xzpJjqdMrL51NtlN5V0YqGC8QLC1w0rt1o599OAmHhnbLnKhiOvhoPby_xHy2IE71Kp5_bIll6GzT9WSnL5en1844aHrNQxQtb6Ufm6v95u7aya1sQQL-72N_gxIgvsOpJIzOcexlLX0BVJ-vxjq1dYAxFU0GJjU_tw5VCsJPtS1takm9iS9ex7MMLQBwtJZXYl52exghbNlgNaLNnEFahvhMhdvzR0H7Tp2xROnKH0UE01NJLnwfXK-R64cs8FqIigMF8Qb1vHHA5tAMrwIcwJDRvC0-di1mI2PkuianlY4W-2Un7S39eEdsaInshBMlZUXJxmIaqV4DeEv159yKIYpH282QZsEifDV4xJ4RBkXB-Bet_VNwrSLfJ1jfliIGPVIAKOT8zdAFivWAKOaQa86PGu4yBLa4QqlGbRJOep-9khNC9JZ-EJ5hAF3GAvxvFGK-Q3TjaYdTNB8ktm97UihSJA1bbn_0XLdh1dfsHey_qpcRcQimL4biZiBAl2oPkOeQepHqiyE9nQdNE3rOhTMjaN-2HMrD6mRzyHfZ4swtVvbKkJvbeKYyCYP5ESKFFRGNrHe5sVM-m-wi_MqfKvP1HMi4YSD9bV560R469mUQI838It8LswhUgA"}
```

##### JSON example 2 (cell C25)

```json
{"respHeader":{"versionNo":"1.00","rptDateTime":"2025-11-11 10:30:29"},"respBody":{"mandCallbkList":[{"can":"XXXXXXXX","mumrn":"XXXXXXXXXXX","regStatus":"RQ","aggrStatus":"PE","aumrn":"","eventTs":"2025-01-31 21:07:48"}]}}
```

### NORMAL-TXN

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `NORMAL-TXN`

#### Normal Transaction Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechNormalTxnService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be NORMAL-TXN | Char(20) | Yes | NORMAL-TXN | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:G12`

| txnType | Transaction Type | Char(1) | Yes | Allowed Values:<br>B – Purchase<br>R - Redeem<br>S - Switch<br>U - Invest-Cum-Switch<br>Z - Switch from Existing Folio | Column G |
| --- | --- | --- | --- | --- | --- |
| entGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes |  |  |
| orderMode | Transaction Order Mode | Char(1) | Yes | Allowed Values:<br>Z – API TransactEezz |  |
| entityRemarks | Entity Remarks | Char(1000) | No |  |  |
| folioTxnFlag | Folio based Transaction Flag | Char(1) | Yes | Allowed Values:<br>Y – Folio Based <br>N - CAN Based | if(txnType = “U” \|\| txnType = “Z”), then the value should be N<br> |

#### folioDetSec Section Start

#### Table 4

Source cells: `B14:G19`

| holdNat | Holding Nature of the Investor | Char(2) | No | Allowed Values:<br>AS – Anyone of Survivor<br>JO - Joint<br>SI – Single | Column G |
| --- | --- | --- | --- | --- | --- |
| taxStatus | Tax Status of the Investor holder | Char(3) | No | Refer Master Data Sheet : Tax Status for the allowed values |  |
| priPanOrPekrn | PAN or PEKRN of the Primary Holder | Char(10) | No |  |  |
| secPanOrPekrn | PAN or PEKRN of the Second Holder in case of Joint Holding | Char(10) | Conditional Mandatory |  | The value is required only if folioTxnFlag is Y and holdNat is AS or JO |
| thrPanOrPekrn | PAN or PEKRN of the Third Holder in case of Joint Holding | Char(10) | Conditional Mandatory |  | The value is required only if folioTxnFlag is Y and holdNat is AS or JO |
| gurPanOrPekrn | PAN or PEKRN of the Guardian in case of Investor being a Minor  | Char(10) | Conditional Mandatory |  | The value is required only if folioTxnFlag is Y and Minor folio |

#### folioDetSec Section End

#### Table 5

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

#### schList Array List Section Start

#### Table 6

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

#### payOutDtl (payout detail section start)

#### Table 7

Source cells: `B45:G47`

| invAccNo | Investor Bank Account number | Char(20) | Conditional Mandatory | Column F | if(payOutFlag =”Y”)  value is required <br>else empty. |
| --- | --- | --- | --- | --- | --- |
| micr | Bank MICR | Char(9) | Conditional Mandatory |  | if(payOutFlag =”Y”)  value is required <br>else empty. |
| ifsc | Bank IFSC Code | Char(11) | Conditional Mandatory |  | if(payOutFlag =”Y”)  value is required <br>else empty. |

#### payOutDtl (payout detail section end)

#### Table 8

Source cells: `B49:G49`

| schPayFlag | Y - For Direct transfer to AMC account, The scheme level Payment section is mandatory.<br>N – for payment made to MFU escrow account<br> | Char(1)<br> | Conditional Mandatory | Allowed Values:<br>Y - for Non Individual Transaction as only Direct to AMC payment is supported<br>N – for payment made to MFU account | If the ordermode = "Z" and  canType = "N" and txnType = "B" and  paySecFlag ='Y' schPayFlag is mandatory, else should be empty.<br><br>if  paySecFlag ='Y' and directTranToAmcFlag= Y then, schPayFlag should be Y else, N |
| --- | --- | --- | --- | --- | --- |

#### schPaySec (schPay detail section start)

#### Table 9

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

#### schPaySec (schPay detail section end)

#### Table 10

Source cells: `B63:G66`

| priOtpFlag | Primary OTP Flag<br> | Char(1) | Conditional Mandatory | Allowed Values: <br>B – Both<br>M – Mobile<br>E – Email | If the Entity is enabled for transaction 2FA, the field is mandatory. Otherwise empty value should be passed.<br>if canType is 'N' value should be empty |
| --- | --- | --- | --- | --- | --- |
| priMob | Mobile number.<br> | Char(10) | Conditional Mandatory |  | if(priOtpFlag  = 'B' or priOtpFlag  = 'M') value is required. else empty<br>if canType is 'N' value should be empty |
| priEmail | Email ID<br> | Char(50) | Conditional Mandatory |  | if(priOtpFlag  = 'B' or priOtpFlag  = 'E') value is required. else empty<br>if canType is 'N' value should be empty |
| isSpclProductFlag | Payment Section Flag | Char(1) | Conditional Mandatory | Allowed values:<br>Y – Special Product Section<br>N -No | if(txnType= "U" \|\| "Z") And canType = "I"  value should be Y. <br>else N |

#### spclProductDtls(Special Product detail section start)

#### Table 11

Source cells: `B68:F69`

| smartSwitchVolType | Transaction Volume Type | Char(1) | Yes | Allowed Values:<br>E - All Units<br>A - Amount<br>U – Units |
| --- | --- | --- | --- | --- |
| smartSwitchVol | Transaction Volume | Numeric(14,3) | Conditional Mandatory |  |

#### spclProductDtls(Special Product detail section end)

#### schList Array List Section end

#### Table 12

Source cells: `B72:G72`

| dpSecFlag | Depository Account Details  Section Flag | Char(1) | Conditional Mandatory | Allowed values:<br>Y – DP Section<br>N -No | if(txnType =”B” \|\| txnType = “S”) value is required <br>else empty |
| --- | --- | --- | --- | --- | --- |

#### dpSec (depository detail section start)

#### Table 13

Source cells: `B74:G75`

| dpType | Depository Type | Char(4) | Conditional Mandatory | Allowed values:<br>NSDL<br>CDSL | if(dpSecFlag = “Y”) value is required <br>else empty |
| --- | --- | --- | --- | --- | --- |
| dpAccNo | Depository Account number | Char(16) | Conditional Mandatory |  | if(dpSecFlag = “Y”) value is required <br>else empty |

#### dpSec (depository detail section end)

#### Table 14

Source cells: `B77:G77`

| paySecFlag | Payment Section Flag | Char(1) | Conditional Mandatory | Allowed values:<br>Y – Payment Section<br>N -No | if(txnType= “B”  \|\| txnType = “U”)  value is required. <br>else empty |
| --- | --- | --- | --- | --- | --- |

#### paySec (payment section start)

#### Table 15

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

#### paySec (payment section end)

#### logDtl (Customer Devicce Details Section Start)

#### Table 16

Source cells: `B94:F95`

| deviceType | Device Type | Char(1) | Yes | Allowed values:<br>M - Mobile<br>W - Web |
| --- | --- | --- | --- | --- |
| custIpAddress | Customer Loged In IP Address | Char(20) | Yes |  |

#### logDtl (Customer Devicce Details Section End)

#### Normal Transaction Service API – Response

#### Table 17

Source cells: `B100:D100`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 18

Source cells: `B102:D105`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 19

Source cells: `B107:D107`

| ordCreatedFlag | In MFU system Order Created is generated or not.<br>Possible Values:<br>Y - Order is created<br>N - Order is not created | Char(1) |
| --- | --- | --- |

#### secWisErrorList (section wise error list array section start)

#### Table 20

Source cells: `B109:D111`

| secName | Error Section Name | Char(50) |
| --- | --- | --- |
| secErrorCode | Error Code  | Char(10) |
| secErrorMsg | Error Message | Char(250) |

#### secWisErrorList (section wise error list array section end)

#### ordDtl (order detail section start)

#### Table 21

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

#### itrnWiseStatus (ITRN Wise Status ArrayList start)

#### Table 22

Source cells: `B127:D131`

| entUnqItrn | Entity Unique ITRN Reference number | Char(50) |
| --- | --- | --- |
| mfuItrn | MFU ITRN | Char(18) |
| itrnOrdStatus | ITRN Level Order Status. <br>Refer Master Data Sheet : ITRN Level Order Status for the possible values | Char(2) |
| errorCode | If ITRN level order status is rejected, this field containts the value for the order rejected error code | Char(10) |
| errorMsg | If error code containts the values, this field have the error message for the error code | Char(250) |

#### itrnWiseStatus (ITRN Wise Status ArrayList end)

#### ordDtl (order detail section end)

#### Normal Transaction Service API – Sample Request and Response

#### Table 23

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

#### JSON examples

##### JSON example 1 (cell C138)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "NORMAL-TXN","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C139)

```json
{"txnType":"B","entGroupRefNo":"PPP1003","orderMode":"Z","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","canType":"I","txnEvent":"","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"5000","schList":[{"entUnqItrn":"01","mfuUtrn":"","rtaAmcCode":"B","rtaSchCode":"292G","outRtaSchCode":"","folio":"NEW","divOpt":"N","txnVolTyp":"A","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"schPayFlag":"","schPaySec":{"payType":"","payRefNo":"","payDate":"","srcMicrNo":"","srcIfscNo":"","srcInvAccType":"","srcInvAccNo":"","targetMicrNo":"","targetIfscNo":"","targetInvAccType":"","targetInvAccNo":""},"priOtpFlag":"","priMob":"","priEmail":""}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"Y","paySec":{"directTranToAmcFlag":"","payMode":"NE","micr":"110211006","ifsc":"UTIB0000040","accType":"SB","accNo":"XXXXX","payDate":"2025-12-15","payAmt":"5000","beneVan":"MFUYES30170AJ001","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"14.141.212.169"}}
```

##### JSON example 3 (cell C140)

```json
{"txnType":"R","entGroupRefNo":"20240627001","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"10000","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"AXF","rtaSchCode":"CMGPG","outRtaSchCode":"","folio":"KARLGOIN","divOpt":"","txnVolTyp":"E","vol":"5000","payOutFlag":"Y","payOutDtl":{"invAccNo":"20141113","micr":"XXXXXXXX","ifsc":"XXXXXXXXXXX"},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

##### JSON example 4 (cell C141)

```json
{"txnType":"S","entGroupRefNo":"20240626001","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXX","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"AXF","rtaSchCode":"BDDPD","outRtaSchCode":"CMGPG","folio":"KARLGOIN","divOpt":"P","txnVolTyp":"E","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"directTranToAmcFlag":"","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

##### JSON example 5 (cell C142)

```json
{"txnType":"U","entGroupRefNo":"20240626001","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXX","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"AXF","rtaSchCode":"BDDPD","outRtaSchCode":"CMGPG","folio":"KARLGOIN","divOpt":"P","txnVolTyp":"E","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"Y","spclProductDtls":{"smartSwitchVolType":"E","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"directTranToAmcFlag":"","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

##### JSON example 6 (cell C143)

```json
{"txnType":"Z","entGroupRefNo":"20240626001","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXX","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"AXF","rtaSchCode":"BDDPD","outRtaSchCode":"CMGPG","folio":"KARLGOIN","divOpt":"P","txnVolTyp":"E","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"Y","spclProductDtls":{"smartSwitchVolType":"E","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"directTranToAmcFlag":"","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

##### JSON example 7 (cell C144)

```json
{"txnType":"B","entGroupRefNo":"E2024022700469","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","canType":"N","txnEvent":"Q","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"5000","schList":[{"entUnqItrn":"01","mfuUtrn":"","rtaAmcCode":"B","rtaSchCode":"BW015","outRtaSchCode":"","folio":"NEW","divOpt":"R","txnVolTyp":"A","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"schPayFlag":"N","schPaySec":{"payType":"","payRefNo":"","payDate":"","srcBnkId":"229","srcMicrNo":"","srcIfscNo":"","srcInvAccType":"","srcInvAccNo":"","targetBnkId":"240","targetMicrNo":"","targetIfscNo":"","targetInvAccType":"","targetInvAccNo":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"Y","paySec":{"directTranToAmcFlag":"N","payMode":"NE","micr":"123456789","ifsc":"XXXXXXXXXX","accType":"SB","accNo":"11021981","payDate":"2024-10-18","payAmt":"5000","beneVan":"MFSYESXXXXXXXXXX","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

##### JSON example 8 (cell C145)

```json
{"txnType":"B","entGroupRefNo":"E20240627004","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","canType":"N","txnEvent":"Q","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"5000","schList":[{"entUnqItrn":"01","mfuUtrn":"","rtaAmcCode":"B","rtaSchCode":"BW015","outRtaSchCode":"","folio":"NEW","divOpt":"R","txnVolTyp":"A","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"schPayFlag":"Y","schPaySec":{"payType":"NE","payRefNo":"1234","payDate":"2024-10-18","srcBnkId":"229","srcMicrNo":"11112332","srcIfscNo":"XXXXXXXXXXX","srcInvAccType":"SB","srcInvAccNo":"9876543210","targetBnkId":"240","targetMicrNo":"403240020","targetIfscNo":"XXXXXXXXXXX","targetInvAccType":"SB","targetInvAccNo":"123344444"},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"Y","paySec":{"directTranToAmcFlag":"Y","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"2024-10-18","payAmt":"5000","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

##### JSON example 9 (cell C146)

```json
{"txnType":"R","entGroupRefNo":"20240626001","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","canType":"N","txnEvent":"B","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"10000","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"AXF","rtaSchCode":"BDDPR","outRtaSchCode":"","folio":"manicorp/01","divOpt":"","txnVolTyp":"E","vol":"5000","payOutFlag":"Y","payOutDtl":{"invAccNo":"11021982","micr":"XXXXXXX","ifsc":"XXXXXXXXXXX"},"schPayFlag":"","schPaySec":{"payType":"","payRefNo":"","payDate":"","srcMicrNo":"","srcIfscNo":"","srcInvAccType":"","srcInvAccNo":"","targetMicrNo":"","targetIfscNo":"","targetInvAccType":"","targetInvAccNo":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"directTranToAmcFlag":"","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

##### JSON example 10 (cell C147)

```json
{"txnType":"S","entGroupRefNo":"06260014","orderMode":"Z","entityRemarks":"","folioTxnFlag":"N","folioDetSec":{"holdNat":"","taxStatus":"","priPanOrPekrn":"","secPanOrPekrn":"","thrPanOrPekrn":"","gurPanOrPekrn":""},"can":"XXXXXXXXXX","canType":"N","txnEvent":"Q","reqPrntEnt":"","riaCode":"","arnCode":"ARN-XXXX","subArnCode":"","euin":"","euinDeclaration":"Y","subBrokCode":"","branchRMIntCode":"","totAmt":"","schList":[{"entUnqItrn":"02","mfuUtrn":"","rtaAmcCode":"FTI","rtaSchCode":"405","outRtaSchCode":"046","folio":"CIMB009","divOpt":"R","txnVolTyp":"E","vol":"5000","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"schPayFlag":"N","schPaySec":{"payType":"","payRefNo":"","payDate":"","srcMicrNo":"","srcIfscNo":"","srcInvAccType":"","srcInvAccNo":"","targetMicrNo":"","targetIfscNo":"","targetInvAccType":"","targetInvAccNo":""},"priOtpFlag":"","priMob":"","priEmail":"","isSpclProductFlag":"N","spclProductDtls":{"smartSwitchVolType":"","smartSwitchVol":""}}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"directTranToAmcFlag":"","payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"logDtl":{"deviceType":"W","custIpAddress":"000.00.0.000"}}
```

##### JSON example 11 (cell C148)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 12 (cell C149)

```json
{"respHeader":{"respTs":"2023-04-15 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"Y","secWisErrorList":[{"secName":"","secErrorCode":"","secErrorMsg":""}],"ordDtl":{"entGroupRefNo":"ENTGORN12345","mfuGorn":"XXXXXXXXXX000001","corn":"","orderstatus":"OA","virtualAccNo":"","virtAccIfsc":"","appLinkPri":"","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":"","itrnWiseStatus":[{"entUnqItrn":"ENTITRN00001","mfuItrn":"XXXXXXXXXX00000101","itrnOrdStatus":"OA","errorCode":"","errorMsg":""}]}}}                
```

##### JSON example 13 (cell C150)

```json
{"respHeader":{"respTs":"2023-04-15 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"N","secWisErrorList":[{"secName":"canSection","secErrorCode":"20000","secErrorMsg":"Invalid CAN"},{"secName":"paymentSection","secErrorCode":"20001","secErrorMsg":"Invalid Payment"}],"ordDtl":{"entGroupRefNo":"","mfuGorn":"","corn":"","orderstatus":"","virtualAccNo":"","virtAccIfsc":"","appLinkPri":"","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":"","itrnWiseStatus":[]}}}                
```

##### JSON example 14 (cell C151)

```json
{"respHeader":{"respTs":"2023-04-15 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"Y","secWisErrorList":[{"secName":"","secErrorCode":"","secErrorMsg":""}],"ordDtl":{"entGroupRefNo":"ENTGORN12345","mfuGorn":"XXXXXXXXXX000001","corn":"","orderstatus":"OA","virtualAccNo":"","virtAccIfsc":"","appLinkPri":"","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":"","itrnWiseStatus":[{"entUnqItrn":"ENTITRN00001","mfuItrn":"XXXXXXXXXX00000101","itrnOrdStatus":"SS","errorCode":"89090","errorMsg":"Scheme Threashold not matched with order"}]}}}	
```

### SYS-TXN

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `SYS-TXN`

#### Systematic Transaction Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechSystematicTxnService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be SYS-TXN | Char(20) | Yes | SYS-TXN | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

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

#### sysSchList Array List Section Start

#### Table 4

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

#### payOutDtl (payout detail section start)

#### Table 5

Source cells: `B40:G42`

| invAccNo | Investor Bank Account number | Char(20) | Conditional Mandatory | Column F | if(payOutFlag =”Y”)  value is required <br>else empty. |
| --- | --- | --- | --- | --- | --- |
| micr | Bank MICR | Char(9) | Conditional Mandatory |  | if(payOutFlag =”Y”)  value is required <br>else empty. |
| ifsc | Bank IFSC Code | Char(11) | Conditional Mandatory |  | if(payOutFlag =”Y”)  value is required <br>else empty. |

#### payOutDtl (payout detail section end)

#### Table 6

Source cells: `B44:G46`

| priOtpFlag | Primary OTP Flag | Char(1) | Conditional Mandatory | Allowed Values: <br>B – Both<br>M – Mobile<br>E – Email | If the Entity is enabled for transaction 2FA, the field is mandatory. Otherwise empty value should be passed. |
| --- | --- | --- | --- | --- | --- |
| priMob | Mobile number. | Char(10) | Conditional Mandatory |  | if(priOtpFlag  = 'B' or priOtpFlag  = 'M') value is required. else empty. |
| priEmail | Email ID | Char(50) | Conditional Mandatory |  | if(priOtpFlag  = 'B' or priOtpFlag  = 'E') value is required. else empty. |

#### schList Array List Section end

#### Table 7

Source cells: `B48:G48`

| dpSecFlag | Depository Account Details  Section Flag | Char(1) | Conditional Mandatory | Allowed values:<br>Y – DP Section<br>N -No | The value is required only if txnType ="V" \|\| txnType = "E".<br>Otherwise the value should be empty |
| --- | --- | --- | --- | --- | --- |

#### dpSec (depository detail section start)

#### Table 8

Source cells: `B50:G51`

| dpType | Depository Type | Char(4) | Conditional Mandatory | Allowed values:<br>NSDL<br>CDSL | if(dpSecFlag = “Y”) value is required <br>else empty |
| --- | --- | --- | --- | --- | --- |
| dpAccNo | Depository Account number | Char(16) | Conditional Mandatory |  | if(dpSecFlag = “Y”) value is required <br>else empty |

#### dpSec (depository detail section end)

#### Table 9

Source cells: `B53:G53`

| paySecFlag | Payment Section Flag | Char(1) | Conditional Mandatory | Allowed values:<br>Y – Payment Section<br>N -No | The value is required only if txnType is V.<br>Otherwise the value should be empty. |
| --- | --- | --- | --- | --- | --- |

#### paySec (Current dated payment detail section start)

#### Table 10

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

#### paySec (Current dated payment detail section start)

#### Table 11

Source cells: `B65:G65`

| subSeqPayFlag | For ApiEezz, the Subsequent Payment flag  Y and N are allowed. If the flag is  "N" then the customer should select the bank details in Link confirmation page. If the flag is "Y", then the susequent payment information is mandatory. | Char(1) | Conditional Mandatory | Allowed values:<br>Y – Sub Sequent Payment Section is mandatory<br>N – Sub Sequent Payment Section is non mandatory | if(txnType= “V”)  value is required. <br>else empty |
| --- | --- | --- | --- | --- | --- |

#### subSeqSec (Sub-Sequent payment section start)

#### Table 12

Source cells: `B67:G72`

| payMode | Subsequent Payment Mode | Char(2) | Conditional Mandatory | Allowed values:<br>DM – PayEezz<br>AP - UPI AutoPay | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |
| --- | --- | --- | --- | --- | --- |
| invAccType | Bank Account Type | Char(4) | Conditional Mandatory | Refer Master Data Sheet : Account Type for the allowed values | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |
| invAccNo | Bank Account number | Char(20) | Conditional Mandatory |  | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |
| micr | MICR Number | Char(9) | Conditional Mandatory |  | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |
| ifsc | IFSC Code | Char(11) | Conditional Mandatory |  | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |
| mandateRefNo | CAN Payeez UMRN number | Char(35) | Conditional Mandatory |  | This value is required only if subSeqPayFlag is Y.<br>Otherwise the value should be empty. |

#### subSeqSec (Sub-Sequent payment section end)

#### logDtl (Customer Devicce Details Section Start)

#### Table 13

Source cells: `B75:F76`

| deviceType | Device Type | Char(1) | Yes | Allowed values:<br>M - Mobile<br>W - Web |
| --- | --- | --- | --- | --- |
| custIpAddress | Customer Loged In IP Address | Char(20) | Yes |  |

#### logDtl (Customer Devicce Details Section End)

#### Systematic Transaction Service API – Response

#### Table 14

Source cells: `B81:D81`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 15

Source cells: `B83:D86`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 16

Source cells: `B88:D88`

| ordCreatedFlag | In MFU system Order Created is generated or not.<br>Y - Order is created<br>N - Order is not created | Char(1) |
| --- | --- | --- |

#### secWisErrorList (section wise error list array section start)

#### Table 17

Source cells: `B90:D92`

| secName | Error Section Name | Char(50) |
| --- | --- | --- |
| secErrorCode | Error Code  | Char(10) |
| secErrorMsg | Error Message | Char(250) |

#### secWisErrorList (section wise error list array section end)

#### ordDtl (order detail section start)

#### Table 18

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

#### itrnList (ITRN Wise Status ArrayList start)

#### Table 19

Source cells: `B107:D111`

| entUnqItrn | Entity Unique ITRN Reference number | Char(50) |
| --- | --- | --- |
| mfuItrn | MFU ITRN | Char(18) |
| itrnOrdStatus | ITRN Level Order Status. <br>Refer Master Data Sheet : ITRN Level Order Status for the possible values | Char(2) |
| errorCode | If ITRN level order status is rejected, this field containts the value for the order rejected error code | Char(10) |
| errorMsg | If error code containts the values, this field have the error message for the error code | Char(250) |

#### itrnList (ITRN Wise Status ArrayList end)

#### ordDtl (order detail section end)

#### Systematic Transaction Service API – Sample Request and Response

#### Table 20

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

#### JSON examples

##### JSON example 1 (cell C118)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "SYS-TXN","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C119)

```json
{"txnType":"V","entGroupRefNo":"20241122001","orderMode":"Z","entityRemarks":"","can":"20244CG001","canType":"I","reqPrntEnt":"","riaCode":"INA987654321","arnCode":"","subArnCode":"","euin":"","euinDeclaration":"","subBrokCode":"","branchRMIntCode":"","totAmt":"1000","sysSchList":[{"entUnqItrn":"20241122701","rtaAmcCode":"AXF","rtaSchCode":"BDGPG","outRtaSchCode":"","folio":"NEW","divOpt":"N","txnVolTyp":"A","vol":"1000","frequency":"M","day":"25","startMonth":"12","startYear":"2024","endMonth":"12","endYear":"2026","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"B","priMob":"9489588768","priEmail":"binuaswini@gmail.com"}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"Y","paySec":{"payMode":"DM","micr":"123456789","ifsc":"ICIC0000281","accType":"SB","accNo":"320320","payDate":"2024-11-23","payAmt":"1000","beneVan":"","paymentRefNo":"EXEMPTPRN","paymentBankRefNo":"20241123705","paymentConfirmTs":"2024-06-23 10:20:23","amcPaymentTs":"2024-06-23 10:20:23"},"subSeqPayFlag":"Y","subSeqSec":{"payMode":"DM","invAccType":"SB","invAccNo":"320320","micr":"123456789","ifsc":"ICIC0000281","mandateRefNo":"EXEMPTPRN"},"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}}
```

##### JSON example 3 (cell C120)

```json
{"txnType":"J","entGroupRefNo":"20241122001","orderMode":"Z","entityRemarks":"","can":"15250CAA01","canType":"I","reqPrntEnt":"","riaCode":"INA987654321","arnCode":"","subArnCode":"","euin":"","euinDeclaration":"","subBrokCode":"","branchRMIntCode":"","totAmt":"1000","sysSchList":[{"entUnqItrn":"20241122701","rtaAmcCode":"AXF","rtaSchCode":"CMGPG","outRtaSchCode":"","folio":"KARLGOIN/01","divOpt":"","txnVolTyp":"F","vol":"1000","frequency":"M","day":"25","startMonth":"12","startYear":"2024","endMonth":"12","endYear":"2026","payOutFlag":"N","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"B","priMob":"9489588768","priEmail":"binuaswini@gmail.com"}],"dpSecFlag":"","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"payMode":"","micr":"","ifsc":"","accType":"","accNo":"","payDate":"","payAmt":"","beneVan":"","paymentRefNo":"","paymentBankRefNo":"","mandateRefNo":"","paymentConfirmTs":"","amcPaymentTs":""},"subSeqPayFlag":"N","subSeqSec":{"payMode":"","invAccType":"","invAccNo":"","micr":"","ifsc":"","paymentRefNo":""},"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}}
```

##### JSON example 4 (cell C121)

```json
{"txnType":"E","entGroupRefNo":"2024112203","orderMode":"Z","entityRemarks":"","can":"15250CAA01","canType":"I","reqPrntEnt":"","riaCode":"INA987654321","arnCode":"","subArnCode":"","euin":"","euinDeclaration":"","subBrokCode":"","branchRMIntCode":"","totAmt":"1000","sysSchList":[{"entUnqItrn":"20241122709","rtaAmcCode":"AXF","rtaSchCode":"BDGPG","outRtaSchCode":"CMGPG","folio":"KARLGOIN/01","divOpt":"N","txnVolTyp":"F","vol":"1000","frequency":"M","day":"25","startMonth":"12","startYear":"2024","endMonth":"12","endYear":"2026","payOutFlag":"","payOutDtl":{"invAccNo":"","micr":"","ifsc":""},"priOtpFlag":"B","priMob":"9489588768","priEmail":"binuaswini@gmail.com"}],"dpSecFlag":"N","dpSec":{"dpType":"","dpAccNo":""},"paySecFlag":"","paySec":{"payMode":"DM","micr":"123456789","ifsc":"ICIC0000281","accType":"SB","accNo":"320320","payDate":"2024-11-23","payAmt":"1000","beneVan":"","paymentRefNo":"EXEMPTPRN","paymentBankRefNo":"20241123705","mandateRefNo":"12","paymentConfirmTs":"2024-06-23 10:20:23","amcPaymentTs":"2024-06-23 10:20:23"},"subSeqPayFlag":"N","subSeqSec":{"payMode":"DM","invAccType":"SB","invAccNo":"320320","micr":"123456789","ifsc":"ICIC0000281","paymentRefNo":"EXEMPTPRN"},"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}}
```

##### JSON example 5 (cell C122)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 6 (cell C123)

```json
{"respHeader":{"respFlag":"S","respTs":"2024-11-26 10:57:45","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"Y","secWisErrorList":[],"ordDtl":{"entGroupRefNo":"20241122005","mfuGorn":"U20244CG00100052","orderstatus":"AC","virtualAccNo":"","virtAccIfsc":"","appLinkPri":"","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":"","itrnList":[{"entUnqItrn":"20241122702","mfuItrn":"U20244CG0010005201","itrnOrdStatus":"OA","errorCode":"","errorMsg":""}]}}}        
```

##### JSON example 7 (cell C124)

```json
{ 
"respHeader": {    "respTs": "2023-04-15 10:20:10",    "respFlag": "S",    "errorCode": "",    "errorMsg": ""  }, 
"respBody": {    "ordCreatedFlag": "N",    "secWisErrorList": [      {        "secName": "canSection",        "secErrorCode": "20000",        "secErrorMsg": "Invalid CAN"      },        {        "secName": "paymentSection",        "secErrorCode": "20001",        "secErrorMsg": "Invalid Payment"      }    ],    "ordDtl": {      "entGroupRefNo": "",      "mfuGorn": "",      "orderstatus": "",      "virtualAccNo": "",      "virtAccIfsc": "",      "appLinkPri": "",      "appLinkH1": "",      "appLinkH2": "",      "appLinkPOA": "",      "paymentLink": "", "upiIntentLink":"",     "itrnWiseStatus": [      ]    }  }
}
```

##### JSON example 8 (cell C125)

```json
{  
"respHeader": {    "respTs": "2023-04-15 10:20:10",    "respFlag": "S",    "errorCode": "",    "errorMsg": ""  },  
"respBody": {    "ordCreatedFlag": "Y",    "secWisErrorList": [      {        "secName": "",        "secErrorCode": "",        "secErrorMsg": ""      }    ],    "ordDtl": {      "entGroupRefNo": "ENTGORN12345",      "mfuGorn": "XXXXXXXXXX000001",      "orderstatus": "OA",      "virtualAccNo": "",      "virtAccIfsc": "",      "appLinkPri": "",      "appLinkH1": "",      "appLinkH2": "",      "appLinkPOA": "",      "paymentLink": "",  "upiIntentLink":"",     "itrnWiseStatus": [        {          "entUnqItrn": "ENTITRN00001",          "mfuItrn": "XXXXXXXXXX00000101",          "itrnOrdStatus": "SS",          "errorCode": "89090",          "errorMsg": "Scheme Threashold not matched with order"        }      ]    }  }
}
```

### SYS-CANCEL-TXN

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `SYS-CANCEL-TXN`

#### Systematic Cancellation Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechSystCancellationService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be SYS-CANCEL-TXN | Char(20) | Yes | SYS-CANCEL-TXN | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:G13`

| txnType | Transaction Type | Char(1) | Yes | Allowed Values:<br>C - SIP Cancellation<br>T - STP Cancellation<br>W - SWP Cancellation | Column G |
| --- | --- | --- | --- | --- | --- |
| extGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes |  | Values should be Alphabets,Numeric or Alphanumeric |
| orderMode | Transaction Order Mode | Char(1) | Yes | Allowed Values:<br>Z - API TransactEezz  | The value should be Z always.  |
| entityRemarks | Entity Remarks | Char(250) | No |  |  |
| can | Common Account Number (CAN). | Char(10) | Yes |  |  |
| reqPrntEnt | Parent Entity ID for audit | Char(6) | No |  | The value can be empty |

#### cancelSysTxnDet Array List Section Start

#### Table 4

Source cells: `B15:G18`

| parentGORN | Parent Group Order Number | Char(16) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| parentITRN | Parent ITRN  | Char(2) | Yes |  |  |
| cancelReasonCode | SIP Cancellation Reason Code | Char(4) | Yes | Refer Master Data Sheet : Cancel Reason Code for the allowed values |  |
| cancelReasonRemarks | SIP Cancellation Reason Remarks | Char(180) | Conditional Mandatory |  | If cancelReasonCode is OTH(Others), cancelReasonRemarks is mandatory. |

#### cancelSysTxnDet Array List Section End

#### logDtl (Customer Devicce Details Section Start)

#### Table 5

Source cells: `B21:F22`

| deviceType | Device Type | Char(1) | Yes | Allowed values:<br>M - Mobile<br>W - Web |
| --- | --- | --- | --- | --- |
| custIpAddress | Customer Loged In IP Address | Char(20) | Yes |  |

#### logDtl (Customer Devicce Details Section End)

#### Systematic Cancellation Service API – Response

#### Table 6

Source cells: `B27:D27`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 7

Source cells: `B29:D32`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 8

Source cells: `B34:D34`

| ordCreatedFlag | In MFU system Order Created is generated or not.<br>Y - Order is created<br>N - Order is not created | Char(1) |
| --- | --- | --- |

#### itrnWiseErrDetail (ITRN wise error list array section start)

#### Table 9

Source cells: `B36:D41`

| parentGorn | Parent GORN Number | Char(16) |
| --- | --- | --- |
| parentItrn | Parent ITRN Number | Char(2) |
| noOfInstallment | No of Installment | Numeric |
| installmentDate | Installment Date | Date |
| errorCode | Error Code  | Char(10) |
| errorMsg | Error Message | Char(600) |

#### itrnWiseErrDetail (ITRN wise error list array section end)

#### secWisErrorList (section wise error list array section start)

#### Table 10

Source cells: `B44:D46`

| secName | Error Section Name | Char(50) |
| --- | --- | --- |
| secErrorCode | Error Code  | Char(10) |
| secErrorMsg | Error Message | Char(250) |

#### secWisErrorList (section wise error list array section end)

#### ordDtl (order detail section start)

#### Table 11

Source cells: `B49:D50`

| extGroupRefNo | Entity Unique Group Reference number | Char(50) |
| --- | --- | --- |
| mfuGorn | MFU GORN | Char(16) |

#### ordDtl (order detail section end)

#### Systematic Cancellation Service API – Sample Request and Response

#### Table 12

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

#### JSON examples

##### JSON example 1 (cell C56)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "SYS-CANCEL-TXN","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C57)

```json
{
"txnType":"C","extGroupRefNo":"EXTGRPREF09","orderMode":"Z","entityRemarks":"","can":"20255BC001","reqPrntEnt":"","cancelSysTxnDet":[{"parentGORN":"U20255BC00101677","parentITRN":"02","cancelReasonCode":"M001","cancelReasonRemarks":""}],"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}
}
```

##### JSON example 3 (cell C58)

```json
{
"txnType":"W","extGroupRefNo":"EXTGRPREF09","orderMode":"Z","entityRemarks":"","can":"20255BC001","reqPrntEnt":"","cancelSysTxnDet":[{"parentGORN":"U20255BC00101677","parentITRN":"02","cancelReasonCode":"M001","cancelReasonRemarks":""}],"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}
}
```

##### JSON example 4 (cell C59)

```json
{
"txnType":"T","extGroupRefNo":"EXTGRPREF09","orderMode":"Z","entityRemarks":"","can":"20255BC001","reqPrntEnt":"","cancelSysTxnDet":[{"parentGORN":"U20255BC00101677","parentITRN":"02","cancelReasonCode":"M001","cancelReasonRemarks":""}],"logDtl":{"deviceType":"W","custIpAddress":"111.11.0.000"}
}
```

##### JSON example 5 (cell C60)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 6 (cell C61)

```json
{
"respHeader":{"respTs":"2023-04-15 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"Y","itrnWiseErrDetail":[{"parentGorn":"","parentItrn":"","noOfInstallment":"","installmentDate":"","errorCode":"","errorMsg":""}],"secWisErrorList":[],"ordDtl":{"extGroupRefNo":"ENTGORN12345","mfuGorn":"XXXXXXXXXX000001"}}
}
```

##### JSON example 7 (cell C62)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-11-26 17:13:28","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"N","itrnWiseErrDetail":null,"secWisErrorList":[{"secName":"commonSection","secErrorCode":"100401","secErrorMsg":"Invalid txnType"}],"ordDtl":{"extGroupRefNo":null,"mfuGorn":null}}
}
```

##### JSON example 8 (cell C63)

```json
{
"respHeader":{"respTs":"2023-04-15 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"ordCreatedFlag":"N","itrnWiseErrDetail":[{"parentGorn":"U20255BC00101677","parentItrn":"02","noOfInstallment":"44","installmentDate":"0","errorCode":"18423","errorMsg":"One of the ITRN Parent Order is Affected.Cannot Approve the Order"}],"secWisErrorList":[],"ordDtl":{"extGroupRefNo":"ENTGORN12345","mfuGorn":""}}
}
```

### TXN-AUT-DET

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `TXN-AUT-DET`

#### Transaction Order Auth Detail Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechTxnAuthDetService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be TXN-AUT-DETH | Char(20) | Yes | TXN-AUT-DETH | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:E9`

| entGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes |
| --- | --- | --- | --- |
| mfuGorn | MFU System Gorup Order Reference Number | Char(16) | Yes |

#### Transaction Order Auth Detail ServiceAPI – Response

#### Table 4

Source cells: `B13:D13`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B15:D18`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### gornOrdDet (gorn order detail section start)

#### Table 6

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

#### itrnList (ITRN ArrayList start)

#### Table 7

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

#### itrnList (ITRN ArrayList End)

#### gornOrdDet (gorn order detail section End)

#### authMasterDet (Auth Master Detail Section Start)

#### grpLvlList (grpLvlList ArrayList Start)

#### Table 8

Source cells: `B57:D57`

| lvlSetDet | This is to indicate how many users to approve in each applicable group and levels within that group. All 3 levels count will be provided always under the group. <br><br>Group id and Level id are separated with double # (##) symbols. Level required for approval is given after level number separated by “-“ (Minus) symbol<br>Sample value:<br> G1##L1-1,L2-1,L3-1,L4-1,L5-1<br> G2##L1-0,L2-0,L3-0,L4-0,L5-0 | Char(30) |
| --- | --- | --- |

#### grpLvlList (grpLvlList ArrayList End)

#### Table 9

Source cells: `B59:D65`

| l1Pans | List of approver PANs set in Level 1 in Authorization Matrix. In case of more than one approver user is configured in Level 1, then the PANs will be separated by # symbol | Char(200) |
| --- | --- | --- |
| l2Pans | List of approver PANs set in Level 2 in Authorization Matrix. In case of more than one approver user is configured in Level 2, then the PANs will be separated by # symbol | Char(200) |
| l3Pans | List of approver PANs set in Level 3 in Authorization Matrix. In case of more than one approver user is configured in Level 3, then the PANs will be separated by # symbol | Char(200) |
| l4Pans | List of approver PANs set in Level 4 in Authorization Matrix. In case of more than one approver user is configured in Level 4, then the PANs will be separated by # symbol | Char(200) |
| l5Pans | List of approver PANs set in Level 5 in Authorization Matrix. In case of more than one approver user is configured in Level 5, then the PANs will be separated by # symbol | Char(200) |
| selPans | In case, Maker User already selected the Approvers who can approve the order at the time of order entry, that list of selected approver PANs is provided here separated by # symbol. | Char(200) |
| verfPans | List of approver PANs set for Verifier. In case of more than one verifier user is configured, then the PANs will be separated by # symbol | Char(200) |

#### authMasterDet (Auth Master Detail Section End)

#### Table 10

Source cells: `B67:D67`

| verfierApprPan | Verifier PAN who already approved the orders. | Char(200) |
| --- | --- | --- |

#### apprLvlList (apprLvlList ArrayList Start)

#### Table 11

Source cells: `B69:D71`

| lvlType | Level Type is repeated for each level (L1, L2, L3,L4,L5) | Char(2) |
| --- | --- | --- |
| apprCount | Count of approvers who approved the order in each of the level type (L1 / L2 / L3/L4/L5) | Numeric(2) |
| apprPans | List of approver PANs set in each level who already approved the orders. The PANs will be separated by # symbol | Char(200) |

#### apprLvlList (apprLvlList ArrayList End)

#### Transaction Order Auth Detail ServiceAPI – Sample Request and Response

#### Table 12

Source cells: `B77:C82`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C78)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "TXN-AUT-DETH","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C79)

```json
{
"entGroupRefNo":"2024062701","mfuGorn":"U24169DZ00300086"
}
```

##### JSON example 3 (cell C80)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C81)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-28 12:42:02","errorCode":"","errorMsg":""},"respBody":{"gornOrdDet":{"can":"XXXXXXXXXXX","mfuGorn":"XXXXXXXX","entGroupRefNo":"XXXXXXXXX","txnType":"PUR","noOfSch":"1","totalAmt":"5000.0","ordStatus":"Created","ordInsertTs":"2024-10-28 09:40:33","ordBussTs":"","payMode":"NEFT","payInstrNo":"","itrnList":[{"itrn":"01","entUnqItrn":"01","itrnTxnType":"Purchase","volType":"Amount","value":"5000.0000","payStatus":"Payment Initiated","itrnTxnSt":"Order Created","schCode":"BW015","schName":"Birla Sun Life Cash Manager - IP - Daily Dividend","divOpt":"Re-Invest","reqFolio":"","reqFolioCkDigit":"","utrn":XXXXXXXXXXX,"ftrnBkTs":"","rspUnits":"0.0","rspAmt":"0.0","rspPrice":"0.0","rspValDate":"","rspFolio":"","rspFolioCkDigit":""}]},"authMasterDet":{"grpLvlList":[{"lvlSetDet":""},{"lvlSetDet":""},{"lvlSetDet":""},{"lvlSetDet":""},{"lvlSetDet":""}],"l1Pans":"XXXXXXXXXX#XXXXXXXXXX","l2Pans":"XXXXXXXXXX","l3Pans":"XXXXXXXXXXX","l4Pans":"","l5Pans":"","selPans":" ","verfPans":"XXXXXXXXXX"},"verfierApprPan":"","apprLvlList":[]}
}
```

##### JSON example 5 (cell C82)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:11:09","errorCode":"10007","errorMsg":"Invalid Request details"},"respBody":{"gornOrdDet":{"can":"","mfuGorn":"","entGroupRefNo":"","txnType":"","noOfSch":"","totalAmt":"","ordStatus":"","ordInsertTs":"","ordBussTs":"","payMode":"","payInstrNo":"","itrnList":[]},"authMasterDet":{"grpLvlList":[],"l1Pans":"","l2Pans":"","l3Pans":"","l4Pans":"","l5Pans":"","selPans":""},"apprLvlList":[]}
}
```

### TXN-APPROVAL

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `TXN-APPROVAL`

#### Transaction Order Approval Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechTxnApprovalService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be TXN-APPROVAL | Char(20) | Yes | TXN-APPROVAL | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:G14`

| entGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| mfuGorn | MFU System Gorup Order Reference Number | Char(16) | Yes |  |  |
| apprUsrPan | Approver User PAN to be provided | Char(10) | Yes |  |  |
| apprUsrIP | Approver User IP address to be provided | Char(20) | Yes |  |  |
| apprUsrLogTS | Approver Logged Timestamp to be provided | Date Time | Yes |  |  |
| apprRejFlag | Flag to Indicate whether the given transaction is Approved or Reject by the Approver. | Char(1) | Yes | Allowed Values:<br>A -  Approve<br>R - Reject  |  |
| rejReason | Based on the Approve or Reject Flag, the Reason to be provided. | Char(250) | Conditional Mandatory  |  | (if apprRejFlag == 'R') rejReason is required else should be empty |

#### Transaction Order Approval Service API – Response

#### Table 4

Source cells: `B18:D18`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B20:D23`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

Source cells: `B25:D25`

| orderStatus | Current Order status in MFU System for the generated GORN. | Char(100) |
| --- | --- | --- |

#### respBody Section End

#### Transaction Order Approval Service API – Sample Request and Response

#### Table 7

Source cells: `B30:C35`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C31)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "TXN-APPROVAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C32)

```json
{
"entGroupRefNo":"20241021002","mfuGorn":"U23129GD00100084","apprUsrPan":"XXXXXXXXXX","apprUsrIP":"000.00.0.000","apprUsrLogTS":"2024-10-21 10:20:23","apprRejFlag":"A","rejReason":""
}
```

##### JSON example 3 (cell C33)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C34)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"orderStatus":"Order Approved"}
}
```

##### JSON example 5 (cell C35)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"orderStatus":""}
}
```

### TXN-HIST

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `TXN-HIST`

#### Transaction Order History Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechTxnHistoryService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be TXN-HIST | Char(20) | Yes | TXN-HIST | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:E9`

| entGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes |
| --- | --- | --- | --- |
| mfuGorn | MFU System Gorup Order Reference Number | Char(16) | Yes |

#### Transaction Order History Service  API – Response

#### Table 4

Source cells: `B13:D13`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B15:D18`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

Source cells: `B20:D20`

| mfuGorn | MFU System Group Order Reference Number | Char(16) |
| --- | --- | --- |

#### orderHistList ArrayList Section start

#### Table 7

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

#### orderHistList ArrayList Section end

#### respBody Section End

#### Transaction Order History Service  API – Sample Request and Response

#### Table 8

Source cells: `B39:C44`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C40)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "TXN-APPROVAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C41)

```json
{
"entGroupRefNo":"20241021002","mfuGorn":"U23129GD00100084"
}
```

##### JSON example 3 (cell C42)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C43)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"mfuGorn":"","orderHistList":[{"pan":"","orderNo":"","orderHistoryRefNo":"","event":"","eventTs":"","eventEntity":"","eventEntityName":"","eventUser":"","eventUserName":"","eventUserLevel":"","rtaRemarks":"","internalRemarks":""}]}
}
```

##### JSON example 5 (cell C44)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"mfuGorn":"","orderHistList":[{"pan":"","orderNo":"","orderHistoryRefNo":"","event":"","eventTs":"","eventEntity":"","eventEntityName":"","eventUser":"","eventUserName":"","eventUserLevel":"","rtaRemarks":"","internalRemarks":""}]}
}
```

### CAN-VAL

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-VAL`

#### CAN Validation Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechCanValidationService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-VAL | Char(20) | Yes | CAN-VAL | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:E11`

| can | Common Account Number (CAN). | Char(10) | Yes |
| --- | --- | --- | --- |
| pan | PAN Number of the Primary Holder | Char(10) | Yes |
| dob | Date Of Birth of the Primary Holder | Date | Yes |
| emailId | Emailid of the Primary Holder | Char(100) | Yes |

#### CAN Validation Service API – Response

#### Table 4

Source cells: `B15:D15`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B17:D20`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

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

#### CAN Validation Service API – Sample Request and Response

#### Table 7

Source cells: `B33:C38`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C34)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-06 10:20:09","apiType":"CAN-VAL","uniqueId":"1000000001"},"reqBody":{"data":"zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="}
}
```

##### JSON example 2 (cell C35)

```json
{
"can":"XXXXXXXXXX","pan":"XXXXXXXXXXX","dob":"1982-02-03","emailId":"arvind@mail.com"
}
```

##### JSON example 3 (cell C36)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C37)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"isValidCan":"TRUE","isValidPan":"FALSE","isValidDob":"TRUE","isValidEmail":"TRUE","canStatus":"","allowForTrans":"TRUE","accountCategory":"","canModeOfHolding":""}
}
```

##### JSON example 5 (cell C38)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"F","errorCode":"10023","errorMsg":"Invalid Details"},"respBody":{"isValidCan":"","isValidPan":"","isValidDob":"","isValidEmail":"","canStatus":"","allowForTrans":"","accountCategory":"","canModeOfHolding":""}
}
```

### CAN-FETCH

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-FETCH`

#### CAN Fetch Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechCanFetchService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-FETCH | Char(20) | Yes | CAN-FETCH | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

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

#### CAN Fetch Service API – Response

#### Table 4

Source cells: `B20:D20`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B22:D25`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

Source cells: `B27:D28`

| can | CAN of the investor in MFU system for the given input combination | Char(10) |
| --- | --- | --- |
| canStatus | CAN Status.<br>Refer Master Data Sheet : CAN Status for the possible values | Char(2) |

#### CAN Fetch Service API – Sample Request and Response

#### Table 7

Source cells: `B32:C37`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C33)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-06 10:20:09","apiType":"CAN-FETCH","uniqueId":"1000000001"},"reqBody":{"data":"zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="}
}
```

##### JSON example 2 (cell C34)

```json
{
"panNo":"XXXXXXXXXX","resdStatus":"RI","modeOfHld":"AS","dob":"1990-03-12","holder2PanNo":"XXXXXXXXXX","holder3PanNo":"XXXXXXXXXX","holder2DOB":"2014-03-28","holder3DOB":"2014-03-28"
}
```

##### JSON example 3 (cell C35)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C36)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"can":"XXXXXXXXXX","canStatus":""}
}
```

##### JSON example 5 (cell C37)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"F","errorCode":"10001","errorMsg":"Invalid Request Details"},"respBody":{"can":"","canStatus":""}
}
```

### PRN-VAL

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `PRN-VAL`

#### PRN Validation Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechPRNValidationService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be PRN-VAL | Char(20) | Yes | PRN-VAL | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:G11`

| can | Common Account Number (CAN). | Char(10) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| prn | PRN number | Char(20) | Conditional Mandatory  |  | Either PRN or MMRN is mandatory |
| mmrn | MMRN | Char(20) | Conditional Mandatory  |  | Either PRN or MMRN is mandatory |
| bankAccNo | BANK Account Number | Char(20) | Yes |  |  |

#### PRN Validation Service API – Response

#### Table 4

Source cells: `B15:D15`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B17:D20`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody Section –  JSON Field Details

#### Table 6

Source cells: `B22:D24`

| prn | PRN Number will be provided if available. | Char(20) |
| --- | --- | --- |
| PRNExistsFlag | This Flag will return as 'Y' if the PRN is available in the system else the value will be 'N'. | Char(1) |
| status | Refer Master Data Sheet : PRN Status for the possible values | Char(2) |

#### respBody Section End

#### PRN Validation Service API – Sample Request and Response

#### Table 7

Source cells: `B29:C34`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C30)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "PRN-VAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C31)

```json
{
"can":"XXXXXXXXXX","prn":"UMRN002","mmrn":"15253198911272F080CC","bankAccNo":"333333333330"
}
```

##### JSON example 3 (cell C32)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C33)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"prn":"UMRN002","prnExistsFlag":"Y","status":"PE"}
}
```

##### JSON example 5 (cell C34)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"prn":"","prnExistsFlag":"","status":""}
}
```

### CAN-BNK-VAL

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-BNK-VAL`

#### CAN Bank Validation Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechBankValidationService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-BNK-VAL | Char(20) | Yes | CAN-BNK-VAL | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:E11`

| can | Common Account Number (CAN). | Char(10) | Yes |
| --- | --- | --- | --- |
| accountNo | Bank Account Number of the CAN. | Char(20) | Yes |
| micrNo | MICR Number | Char(9) | Yes |
| ifscCode | IFSC Code | Char(11) | Yes |

#### CAN Bank Validation Service API – Response

#### Table 4

Source cells: `B15:D15`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B17:D20`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody Section –  JSON Field Details

#### Table 6

Source cells: `B22:D22`

| bankExistFlag | If the provided CAN Bank is available in MFU system, then this flag will be "Y" else "N". | Char(10) |
| --- | --- | --- |

#### respBody Section End

#### CAN Bank Validation Service API – Sample Request and Response

#### Table 7

Source cells: `B27:C32`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C28)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "CAN-BNK-VAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C29)

```json
{
"can":"XXXXXXXXXX","accountNo":"20141113","micrNo":"XXXXXXXX","ifscCode":"XXXXXXXXXXX"
}
```

##### JSON example 3 (cell C30)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C31)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"bankExistFlag":"Y"}
}
```

##### JSON example 5 (cell C32)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"bankExistFlag":""}
}
```

### SWP-PAYEEZ

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `SWP-PAYEEZ`

#### Swap PayEezz Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechSwpPayEezService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be SWP-PAYEEZ | Char(20) | Yes | SWP-PAYEEZ | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

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

#### Swap PayEezz Service API – Response

#### Table 4

Source cells: `B20:D20`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B22:D25`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

Source cells: `B27:D28`

| makerRefNo | Reference number | Char(10) |
| --- | --- | --- |
| respMsg | Swapped PayEezz will be effective for instalments falling due on or after 5 Calendar days | Char(500) |

#### Swap PayEezz Service API – Sample Request and Response

#### Table 7

Source cells: `B32:C37`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C33)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "SWP-PAYEEZ","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C34)

```json
{
{"can":"XXXXXXXXXX","mfuGorn":"XXXXXXXXXXXXXX","subSeqPayMode":"AP","newPRN":"XXXXXXXX","bnkId":"240","micr":"999999999","ifsc":"HDFC900045","accType":"SB","accNo":"XXXXXXXXXXXX"}}
```

##### JSON example 3 (cell C35)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C36)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-11-19 15:00:54","errorCode":"","errorMsg":""},"respBody":{"makerRefNo":"MXXXXXXX","respMsg":"Swapped PayEezz will be effective for instalments falling due on or after 5 Calendar days"}
}
```

##### JSON example 5 (cell C37)

```json
{
"respHeader":{"respFlag":"F","respTs":"2024-11-19 13:10:03","errorCode":"16289","errorMsg":"Provision not given for MMRN based SIP Registration."},"respBody":{"makerRefNo":"","respMsg":""}
}
```

### CAN-FOLIO-VAL

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CAN-FOLIO-VAL`

#### CAN Folio Validation Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechCanFolioValService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be CAN-FOL-VAL | Char(20) | Yes | CAN-FOL-VAL | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:G11`

| can | Common Account Number (CAN) | Char(10) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| folio | Folio Number to be validated | Char(21) | Yes |  |  |
| txnType | Transaction Type | Char(1) | Conditional Mandatory | Allowed Values:<br>B - Purchase<br>R - Redeem<br>S - Switch<br>V - SIP<br>J - SWP<br>E - STP<br>Blank value | Possible Values Mapping |
| rtaAmcCode | RTA AMC Fund Code  | Char(6) | Yes |  |  |

#### CAN Folio Validation Service API – Response

#### Table 4

Source cells: `B16:D16`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B18:D21`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

Source cells: `B23:D25`

| canFolioValidFlag | If the provided Folio is mapped with the CAN in the MFU system, then this flag will be "Y" else "N". | Char(1) |
| --- | --- | --- |
| isHoldingAvail | If the holding is avaliable for the provided, then this flag will be "Y" else "N". | Char(1) |
| message | Folio is mapped with CAN / Folio is not mapped with CAN | Char(500) |

#### CAN Folio Validation Service API – Sample Request and Response

#### Table 7

Source cells: `B29:C34`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C30)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "CAN-FOL-VAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C31)

```json
{
"can":"XXXXXXXXXX","folio":"SAMEFOLIO/76","txnType":"V","rtaAmcCode":"FTI"
}
```

##### JSON example 3 (cell C32)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C33)

```json
{"respHeader":{"respFlag":"S","respTs":"2024-11-19 16:24:54","errorCode":"","errorMsg":""},"respBody":{"canFolioValidFlag":"YES","isHoldingAvail":"N","message":"Folio is mapped with CAN"}}
```

##### JSON example 5 (cell C34)

```json
{
"respHeader":{"respFlag":"S","respTs":"2024-11-19 16:25:37","errorCode":"","errorMsg":""},"respBody":{"canFolioValidFlag":"N","isHoldingAvail":"N","message":"Folio is not mapped with CAN"}
}
```

### INV-CON-ENTRY

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `INV-CON-ENTRY`

#### Investor Consent Entry Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechInvConsentEntryService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be INV-CON-ENTRY | Char(20) | Yes | INV-CON-ENTRY | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:E10`

| can | Common Account Number (CAN). | Char(10) | Yes |
| --- | --- | --- | --- |
| pan | Primary Holder PAN. | Char(10) | Yes |
| mobNo | CAN First Holder Contact Mobile Number | Char(15) | Yes |

#### dataSetArr Array List Section Start

#### Table 4

Source cells: `B12:F12`

| dataSetKey | Consent data set key | Char(2) | Conditional Mandatory | Allowed Values:<br>CD - CAN Details<br>PD - PayEezz Details<br>MF - Mapped Folio Details<br>HD - Holding Data |
| --- | --- | --- | --- | --- |

#### Investor Consent Entry Service API – Response

#### Table 5

Source cells: `B15:D15`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 6

Source cells: `B17:D20`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 7

Source cells: `B22:D26`

| refNo | Reference number | Char(20) |
| --- | --- | --- |
| priLink | Primary Holder link | Char(800) |
| joint1Link | Second Holder Link. This value will be empty in case of single holder | Char(800) |
| joint2Link | Third Holder Link. This value will be empty in case of single holder | Char(800) |
| poaLink | POA Link. If CAN have POA , then POA link will be provided. | Char(800) |

#### Investor Consent Entry Service API – Sample Request and Response

#### Table 8

Source cells: `B30:C35`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C31)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-06 10:20:09","apiType":"INV-CON-ENTRY","uniqueId":"1000000001"},"reqBody":{"data":"zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="}
}
```

##### JSON example 2 (cell C32)

```json
{
"can":"XXXXXXXXXX","pan":"XXXXXXXXXXX","mobNo":"XXXXXXXXXXX","dataSetArr":[{"dataSetKey":"CD"},{"dataSetKey":"PD"}]
}
```

##### JSON example 3 (cell C33)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C34)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"refNo":"XXXXXXXXXXX55990M3JZ","priLink":https:apiFintechInvConEntry?key=AEcus7+/g0xNHnonSXy81dUZzRwvRl2GDmRiUCCA7WilWvNZX99wyfgEnk8ifd5h,"joint1Link":"","joint2Link":"","poaLink":""}
}
```

##### JSON example 5 (cell C35)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"F","errorCode":"10023","errorMsg":"Invalid Details"},"respBody":{"refNo":"","priLink":"","joint1Link":"","joint2Link":"","poaLink":""}
}
```

### INV-CON-VIEW

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `INV-CON-VIEW`

#### Investor Consent View Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechInvConsentViewService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be INV-CON-VIEW | Char(20) | Yes | INV-CON-VIEW | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:F9`

| type | Type of the Investor consent request. | Char(1) | Yes | Allowed Values:<br>V – Investor Consent View <br>R – Re-Triger |
| --- | --- | --- | --- | --- |
| refNo | Investor Consent Entry Registration Number | Char(20) | Yes |  |

#### Investor Consent View Service API – Response

#### Table 4

Source cells: `B12:D12`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B14:D17`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody  Section –  JSON Field Details

#### Table 6

Source cells: `B19:D21`

| refNo | Reference number | Char(20) |
| --- | --- | --- |
| status | Status of the Consent record. | Char(2) |
| statusDesc | Status Description | Char(50) |

#### dataSetList Array List Section Start

#### Table 7

Source cells: `B23:D25`

| dataSetVal | Data Set Key | Char(2) |
| --- | --- | --- |
| dataSetDesc | Data Set Description | Char(50) |
| dataSetSts | Possible Values:<br>Empty – Investor is not acted on the Request.<br>Y – approved by Investor<br>N – Reject by Investor | Char(1) |

#### dataSetList Array List Section End

#### This section belongs to type R

#### invApprlink Section Start

#### Table 8

Source cells: `B29:D32`

| priLink | Primary Holder Link for Investor consent approve | Char(800) |
| --- | --- | --- |
| joint1Link | Second Holder Link for Investor consent approve | Char(800) |
| joint2Link | Third Holder Link for Investor consent approve | Char(800) |
| poaLink | POA Link for Investor consent approve | Char(800) |

#### invApprlink Section End

#### Investor Consent View Service API – Sample Request and Response

#### Table 9

Source cells: `B36:C41`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C37)

```json
{
"reqHeader":{"entityId":"400005","version":"1.00","reqTS":"2024-06-06 10:20:09","apiType":"INV-CON-VIEW","uniqueId":"1000000001"},"reqBody":{"data":"zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="}
}
```

##### JSON example 2 (cell C38)

```json
{
"type":"V","refNo":"XXXXXXXXXXX55990M3JZ"
}
```

##### JSON example 3 (cell C39)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C40)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"refNo":"1085961732037487S9E7","status":" ","statusDesc":"","dataSetList":[],"invApprlink":{"priLink":"http://InvestorConsentView?key=XEguXf6/VZq8kIoTtURdCQFUvvK6n9fHl0I7ogZEdzWefPGhmG7dokvSG6cT1Sci","joint1Link":"","joint2Link":"","poaLink":""}
}
```

##### JSON example 5 (cell C41)

```json
{
"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"F","errorCode":"10023","errorMsg":"Invalid Details"},"respBody":{"refNo":"","status":" ","statusDesc":"","dataSetList":[],"invApprlink":{"priLink":"","joint1Link":"","joint2Link":"","poaLink":""}
}
```

### STATUS-CHK-TXN

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `STATUS-CHK-TXN`

#### Status Check Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechTranStatusChkService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be STATUS-CHK-TXN | Char(20) | Yes | STATUS-CHK-TXN | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:F10`

| stType | Status API Type | Char(20) | Yes | NORMAL-TXN <br>SYS-TXN<br>SYS-CANCEL-TXN |
| --- | --- | --- | --- | --- |
| entGroupRefNo | Entity external Group Unique Reference Number for the transaction. | Char(50) | Yes |  |
| orderDate | Order placed date(The date format is YYYY-MM-DD). | Char(10) | Yes |  |

#### Status Check Service API – Response

#### Table 4

Source cells: `B14:D14`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B16:D19`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody Section –  JSON Field Details

#### This section is applicable only stType is NORMAL-TXN or SYS-TXN

#### Table 6

Source cells: `B22:D22`

| stType | Status API Type | Char(20) |
| --- | --- | --- |

#### orderDetail (Order Detail section start)

#### Table 7

Source cells: `B24:D27`

| ordCreatedFlag | In MFU system Order Created is generated or not.<br>Possible Values:<br>Y - Order is created<br>N - Order is not created | Char(1) |
| --- | --- | --- |
| mfuGorn | MFU System Gorup Order Reference Number | Char(16) |
| corn | The unique reference number will be generated in the MFU system for the given SCHD Entry Request.<br>For Success case , the CORN will be populated.<br>For Failure case , It should be empty | Char(20) |
| orderstatus | Current Order status in MFU System for the generated GORN.<br>Refer Master Data Sheet : Gorn Level Order Status for the possible values | Char(100) |

#### itrnWiseStatus Array List Section Start

#### Table 8

Source cells: `B29:D31`

| entUnqItrn | Entity Unique ITRN Reference number | Char(50) |
| --- | --- | --- |
| mfuItrn | MFU ITRN | Char(18) |
| itrnOrdStatus | ITRN Level Order Status. <br>Refer Master Data Sheet : ITRN Level Order Status for the possible values | Char(2) |

#### itrnWiseStatus Array List Section End

#### Order Detail Section End

#### This section is applicable only stType is SYS-CANCEL-TXN

#### Table 9

Source cells: `B35:D35`

| stType | Status API Type | Char(20) |
| --- | --- | --- |

#### cancellationDetail (Cancellation Detail section start)

#### Table 10

Source cells: `B37:D38`

| ordCreatedFlag | In MFU system Order Created is generated or not.<br>Possible Values:<br>Y - Order is created<br>N - Order is not created | Char(1) |
| --- | --- | --- |
| mfuGorn | MFU System Gorup Order Reference Number | Char(16) |

#### Cancellation Detail Section End

#### Status Check Service API – Sample Request and Response

#### Table 11

Source cells: `B44:C49`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption For NORMAL-TXN or SYS-TXN | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C45)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "STATUS-CHK-TXN","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C46)

```json
{
"stType":"NORMAL-TXN","entGroupRefNo":"ENTGORN12345","orderDate":"2024-06-10"
}
```

##### JSON example 3 (cell C47)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C48)

```json
{"respHeader":{"respTs":"2024-06-07 10:20:10","respFlag":"S","errorCode":"","errorMsg":""},"respBody":{"stType":"NORMAL-TXN","orderDetail":{"ordCreatedFlag":"Y","mfuGorn":"XXXXXXXX","corn":"","orderstatus":"AC","itrnWiseStatus":[{"entUnqItrn":"ENTITRN00001","mfuItrn":"XXXXXXXXXX00000101","itrnOrdStatus":"OA"}]}}}
```

##### JSON example 5 (cell C49)

```json
{"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"stType":"","orderDetail":{"ordCreatedFlag":"","mfuGorn":"","corn":"","orderstatus":"","itrnWiseStatus":[{"entUnqItrn":"","mfuItrn":"","itrnOrdStatus":""}]}}}
```

### ORD-PAYMT-LINK

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `ORD-PAYMT-LINK`

#### Order Payment Link Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechOrdPaymtLinkService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be ORD-PAYMT-LINK | Char(20) | Yes | ORD-PAYMT-LINK | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:G10`

| mfuGorn | MFU System Gorup Order Reference Number | Char(16) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| deviceType | Device Type. This field is used for in-flow transactions with payMode as UP (UPI)-based orders. If the entity does not receive the UPI Intent Link in the immediate response, this field is used to fetch the UPI Intent Link for the order | Char(1) | No | Allowed values:<br>M - Mobile<br> |  |
| ipAddress | Customer Loged In IP Address | Char(20) | Conditional Mandatory |  | If deviceType is M means, ipAddress is mandatory otherwise empty |

#### Order Payment Link Service API – Response

#### Table 4

Source cells: `B13:D13`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B15:D18`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody Section –  JSON Field Details

#### Table 6

Source cells: `B21:D26`

| appLinkPri | Primary Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| --- | --- | --- |
| appLinkH1 | Secondary Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| appLinkH2 | Third Holder Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| appLinkPOA | POA Approval Link. It is only applicable for API TransactEezz transaction. | Char(150) |
| paymentLink | Net Banking / UPI payment Link for API TransactEezz.<br>If upiIntentLink is provided this field should be empty | Char(150) |
| upiIntentLink | UPI Payment Intent Link is applicable only under the following conditions:<br><br> - The entity must be enabled for the Transaction 2FA Flag with MFU.<br> - The entity must be enabled for the UPI Intent Link Flag with MFU.<br>- In the request, the deviceType must be M (Mobile) and the order must be UPI based order<br><br>Otherwise, an empty value will be passed. | Char(200) |

#### respBody Section End

#### Order Payment Link Service API – Sample Request and Response

#### Table 7

Source cells: `B31:C36`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C32)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "PRN-VAL","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C33)

```json
{"mfuGorn":"XXXXXXXXXX","deviceType":"","ipAddress":""}
```

##### JSON example 3 (cell C34)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C35)

```json
{"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""},"respBody":{"appLinkPri":"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":""}}	
```

##### JSON example 5 (cell C36)

```json
{"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"appLinkPri":"","appLinkH1":"","appLinkH2":"","appLinkPOA":"","paymentLink":"","upiIntentLink":""}}		
```

### REDIRECT-TO-ENTITY

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `REDIRECT-TO-ENTITY`

#### API TransactEezz Redirection to Entity Page

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

#### Table 1

Source cells: `B4:E4`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

#### This section is applicable for NetBanking and UPI Transactions

#### netBkPayDt Section Start

#### Table 2

Source cells: `B7:D10`

| gorn | Char(16) | Group Order Reference Number |
| --- | --- | --- |
| payRefNo | Char(35) | Payment reference number |
| payRemarks | Char(500) | Remarks received from Payment Aggregator |
| payStatus | Char(50) | Status of the Payment. Success or Failure |

#### netBkPayDt Section End

#### This section is applicable for Other than NetBanking and UPI Transactions

#### orderDtl Section Start

#### Table 3

Source cells: `B15:D18`

| gorn | Char(16) | Group Order Reference Number |
| --- | --- | --- |
| entGroupRefNo | Char(50) | Entity external Group Unique Reference Number for the transaction. |
| orderstatus | Char(50) | Order Approval Status. Success or Failure |
| remarks | Char(500) | If the user enters any remarks during approval or rejection, those remarks will be populated in this field |

#### orderDtl Section End

#### API TransactEezz Redirection to Entity Page  Sample Response

#### Table 4

Source cells: `B22:C25`

| Sample Type | Sample |
| --- | --- |
| Server to Server Response with Encryption | /q+tihrI6oQl1v0iFy5vVEBjlU6Etw2ZjK/u/GDjll+POON7R0gE9WMv3Z1FEA+NoUmJzZOBr4sRVjitCettR1khss8YFRVetQ4V1sivvjzm/bXMBWVDMihZzZHXx/1vJlG+c07aUkt7PzK/4sFlwFrsUOcjI1Y4d5YLSkJUHTbGpXMXiZqNnFmJ4lkuTluLVSFKPvvs07bbY4L5wgeqQm1Az4Yn6+20ZJeiYzT1rTP+zLJYgSLvjW7rlp++lWVOHtBQx0LjnYDelJIa3Q8VmHmzB8stsxZV7fPOptdVcYWkorhE6eIKBbErvsNuwxNV0b4Gu4j6CI0q2Ax1+OAvO8HuHXJmaFdEm5Mh7f8jx5N0P1pAEf4S65hHNEPt9CVL+jCfEmtjQWywlkeEthdTJwfjIPv6g3vzJ8iQY2STcPdGRmROxgAlzwGgwvhppADIFRQOAs5Bl9kUyc357urcANE6FI0XXKOT+b9piSEmPcI+EaD+ZqhHDGJ5DJQiLTeDWFcLiPbn/1jyJx9Q2vCKYA== |
| Response withOut Encryption<br>(For NetBanking and UPI Transactions ) | [See JSON example 1 below] |
| Response Response withOut Encryption<br>(For Other than NetBanking and UPI Transactions) | [See JSON example 2 below] |

#### JSON examples

##### JSON example 1 (cell C24)

```json
[{"netBkPayDt":{"gorn":"1417XXXXXXXXXXXXX","payRefNo":"QHDF8016384458","payRemarks":"Payment Success","payStatus":"success"}}]
```

##### JSON example 2 (cell C25)

```json
{"orderDtl":{"gorn":"1980XXXXXXXXXXXXX","entGroupRefNo":"XXXXXXXXXXXXXX","orderstatus":"success","remarks":""}}
```

### HIGH-VAL-TXN

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `HIGH-VAL-TXN`

#### High Value Transaction Push Service API

#### Table 1

Source cells: `B3:E3`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

This is a High value transaction push service. MFU will iniaite the request to send the data to entity. The entity need to share the Push URL for recevied this transaction response.

For this service, oAuth is mandatory. Entity need to provide the oAuth URL. The oAuth request and repsonse format should be in MFU oAuth Format. For oAuth refer sheet Authorization with OAuth 2.0

#### respHeader Section - without encryption JSON Field Details

#### Table 2

Source cells: `B7:D9`

| amcCode | Char(6) | The AMC Code as available with the RTA for the AMC to which the notification is sent |
| --- | --- | --- |
| versionNo | Char(5) | Version number for the Web service. |
| rptDateTime | Date Time | Transaction Detail Report Generated Time stamp. Format is YYYY-MM-DD HH:MM:SS |

#### respHeader Section End

#### respBody Section Start - without encryption JSON Field Details

#### txnList Array List Section Start -  ITRN Detail of the Order (Repeated as many times as per number of ITRNs)

#### Table 3

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

#### payDetail Section Start

#### Table 4

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

#### payDetail Section End

#### txnList Array List Section End

#### respBody Section End

#### High Value Transaction API Sample Response

#### Table 5

Source cells: `B44:C46`

| Sample Type | Sample |
| --- | --- |
| Response with Encryption | [See JSON example 1 below] |
| Response withOut Encryption | [See JSON example 2 below] |

#### JSON examples

##### JSON example 1 (cell C45)

```json
{
"respData":"3Dlv69kqFld9U_p3MLLpL3dfov-pF46nBAm3qGH6W-FC1iIOEbMHreRMts8NvfBuSzSR6RwDAd2LX7lnKQkZIKDZr1Td3RsFJbMbG04LMSZ9ykVNEmFKyobsSnALxJFlb6-Igo1LWu973hNzSUsQ-Mlordx6Y5fJqOsaO2n-t8F37Z7tpIF2sGf0sp6hyIpvmq1AVLTn4ERfbLvy-D6-v4tDdWfHHwqGOzwVIghiiyTeEc3oxT1XxhMytV2qUJxgrbJ-5xzpJjqdMrL51NtlN5V0YqGC8QLC1w0rt1o599OAmHhnbLnKhiOvhoPby_xHy2IE71Kp5_bIll6GzT9WSnL5en1844aHrNQxQtb6Ufm6v95u7aya1sQQL-72N_gxIgvsOpJIzOcexlLX0BVJ-vxjq1dYAxFU0GJjU_tw5VCsJPtS1takm9iS9ex7MMLQBwtJZXYl52exghbNlgNaLNnEFahvhMhdvzR0H7Tp2xROnKH0UE01NJLnwfXK-R64cs8FqIigMF8Qb1vHHA5tAMrwIcwJDRvC0-di1mI2PkuianlY4W-2Un7S39eEdsaInshBMlZUXJxmIaqV4DeEv159yKIYpH282QZsEifDV4xJ4RBkXB-Bet_VNwrSLfJ1jfliIGPVIAKOT8zdAFivWAKOaQa86PGu4yBLa4QqlGbRJOep-9khNC9JZ-EJ5hAF3GAvxvFGK-Q3TjaYdTNB8ktm97UihSJA1bbn_0XLdh1dfsHey_qpcRcQimL4biZiBAl2oPkOeQepHqiyE9nQdNE3rOhTMjaN-2HMrD6mRzyHfZ4swtVvbKkJvbeKYyCYP5ESKFFRGNrHe5sVM-m-wi_MqfKvP1HMi4YSD9bV560R469mUQI838It8LswhUgA"
}
```

##### JSON example 2 (cell C46)

```json
{"respHeader":{"amcCode":"FTA","versionNo":"1.00","rptDateTime":"2025-02-04 12:10:37"},"respBody":{"txnList":[{"itrn":"5101","utrn":"0","itrnTxnType":"Purchase","ordMode":"Physical","can":"XXXXXXXXXX","folio":"FOLIO","schCode":"RTA1","schName":"AXIS","invName":"Investor Name","txnVolType":"","amount":"100.0000","units":"0.0000","estAmt":"0.0000","ordStatus":"","ordTs":"2025-01-31 21:54:30","payDetail":{"payMode":"NEFT","invBnkName":"HDFC","payStatus":"Payment Confirmed","srcAccNo":"100000112","targetAccNo":"10000012234","amcBank":"HDFC","ftrn":"","ftrnTs":"2025-01-31 21:54:30","payStReason":""}}]}}
```

### CHNL-RESP-FEED

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `CHNL-RESP-FEED`

#### Channel Response Feed Push API

#### Table 1

Source cells: `B3:E3`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

This is a channel response feed push service. MFU will iniaite the request to send the data to entity. The entity need to share the Push URL for recevied this transaction response.

For this service, oAuth is mandatory. Entity need to provide the oAuth URL. The oAuth request and repsonse format should be in MFU oAuth Format. For oAuth refer sheet Authorization with OAuth 2.0

#### respHeader Section – without encryption JSON Field Details

#### Table 2

Source cells: `B7:D8`

| versionNo | Char(5) | Version number for the Web service. The version number is 1.00 |
| --- | --- | --- |
| rptDateTime | Date Time | Channel Response feed push send time stamp. Timestamp format is YYYY-MM-DD HH:MM:SS |

#### respHeader Section End

#### respBody Section – without encryption JSON Field Details

#### txnFeedList Array List Section Start

#### Table 3

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

#### txnFeedList Array List Section End

#### respBody Section End

#### Channel Response Feed Push Sample Response

#### Table 4

Source cells: `B49:C51`

| Sample Type | Sample |
| --- | --- |
| Response with Encryption | [See JSON example 1 below] |
| Response withOut Encryption | [See JSON example 2 below] |

#### JSON examples

##### JSON example 1 (cell C50)

```json
{"respData":"3Dlv69kqFld9U_p3MLLpL3dfov-pF46nBAm3qGH6W-FC1iIOEbMHreRMts8NvfBuSzSR6RwDAd2LX7lnKQkZIKDZr1Td3RsFJbMbG04LMSZ9ykVNEmFKyobsSnALxJFlb6-Igo1LWu973hNzSUsQ-Mlordx6Y5fJqOsaO2n-t8F37Z7tpIF2sGf0sp6hyIpvmq1AVLTn4ERfbLvy-D6-v4tDdWfHHwqGOzwVIghiiyTeEc3oxT1XxhMytV2qUJxgrbJ-5xzpJjqdMrL51NtlN5V0YqGC8QLC1w0rt1o599OAmHhnbLnKhiOvhoPby_xHy2IE71Kp5_bIll6GzT9WSnL5en1844aHrNQxQtb6Ufm6v95u7aya1sQQL-72N_gxIgvsOpJIzOcexlLX0BVJ-vxjq1dYAxFU0GJjU_tw5VCsJPtS1takm9iS9ex7MMLQBwtJZXYl52exghbNlgNaLNnEFahvhMhdvzR0H7Tp2xROnKH0UE01NJLnwfXK-R64cs8FqIigMF8Qb1vHHA5tAMrwIcwJDRvC0-di1mI2PkuianlY4W-2Un7S39eEdsaInshBMlZUXJxmIaqV4DeEv159yKIYpH282QZsEifDV4xJ4RBkXB-Bet_VNwrSLfJ1jfliIGPVIAKOT8zdAFivWAKOaQa86PGu4yBLa4QqlGbRJOep-9khNC9JZ-EJ5hAF3GAvxvFGK-Q3TjaYdTNB8ktm97UihSJA1bbn_0XLdh1dfsHey_qpcRcQimL4biZiBAl2oPkOeQepHqiyE9nQdNE3rOhTMjaN-2HMrD6mRzyHfZ4swtVvbKkJvbeKYyCYP5ESKFFRGNrHe5sVM-m-wi_MqfKvP1HMi4YSD9bV560R469mUQI838It8LswhUgA"}
```

##### JSON example 2 (cell C51)

```json
{"respHeader":{"versionNo":"1.00","rptDateTime":"2025-02-04 09:30:29"},"respBody":{"txnFeedList ":[{"entRefNo":"XXXXXXXXX","gorn":"XXXXXXXX","seqNo":"01","isInstOrd":"N","txnType":"V","utrn":"0","can":"XXXXXXXXXX","ordTS":"2025-01-31 21:07:48","fndCode":"MAF","rtaSchCode":"EBRGG","reInvFlg":"Z","witdrwOpt":"A","payMode":"DM","payRefNo":"","payStatus":"CR","prntGorn":"XXXXXXXXXXXXXXXXXX","prntSeqNo":"01","currInsNo":"35","txnStatus":"RP","regStatus":"NA","rspFolio":"7776285685","price":"133.4230","rspAmt":"999.95","rspUnit":"7.4950","rspValDt":"2025-01-27","rtaRemark":"","arnCode":"","subArnCode":"","riaCode":"","corn":"","cornSeq":"","stampAmt":""}]}}
```

### SCHEME-PUSH

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `SCHEME-PUSH`

#### Scheme Push API

#### Table 1

Source cells: `B3:E3`

| JSON Field Name | Data Type | Description | Remarks |
| --- | --- | --- | --- |

This is a scheme push service. MFU will iniaite the request to send the data to entity. The entity need to share the Push URL to recevied this transaction response.

For this service, oAuth is not mandatory. If Entity need oAuth,They should provide the oAuth URL. The oAuth request and repsonse format should be in MFU oAuth Format. For oAuth refer sheet Authorization with OAuth 2.0

#### respHeader Section – without encryption JSON Field Details

#### Table 2

Source cells: `B7:D8`

| versionNo | Char(5) | Version number for the Web service. The version number is 1.00 |
| --- | --- | --- |
| rptDateTime | Date Time | Channel Response feed push send time stamp. Timestamp format is YYYY-MM-DD HH:MM:SS |

#### respHeader Section End

#### respBody Section – without encryption

#### Table 3

Source cells: `B11:D11`

| type | Char(15) | ​Scheme Push Type. Type contains the following values:<br>Scheme<br>Threshold<br>Based on type, the detail section structure​ will be different. |
| --- | --- | --- |

#### detail  section JSON Field Start For Scheme

#### Table 4

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

#### detail  section JSON Field End For Scheme

#### detail  section JSON Field Start for Threshold

#### schemeList Array List Section Start

#### Table 5

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

#### schemeList Array List Section End

#### detail  section JSON Field End for Threshold

#### Scheme Push API Sample Response

#### Table 6

Source cells: `B67:C70`

| Sample Type | Sample |
| --- | --- |
| Response with Encryption | [See JSON example 1 below] |
| Response For SMF withOut Encryption | [See JSON example 2 below] |
| Response For STD withOut Encryption | [See JSON example 3 below] |

#### JSON examples

##### JSON example 1 (cell C68)

```json
{"respData":"3Dlv69kqFld9U_p3MLLpL3dfov-pF46nBAm3qGH6W-FC1iIOEbMHreRMts8NvfBuSzSR6RwDAd2LX7lnKQkZIKDZr1Td3RsFJbMbG04LMSZ9ykVNEmFKyobsSnALxJFlb6-Igo1LWu973hNzSUsQ-Mlordx6Y5fJqOsaO2n-t8F37Z7tpIF2sGf0sp6hyIpvmq1AVLTn4ERfbLvy-D6-v4tDdWfHHwqGOzwVIghiiyTeEc3oxT1XxhMytV2qUJxgrbJ-5xzpJjqdMrL51NtlN5V0YqGC8QLC1w0rt1o599OAmHhnbLnKhiOvhoPby_xHy2IE71Kp5_bIll6GzT9WSnL5en1844aHrNQxQtb6Ufm6v95u7aya1sQQL-72N_gxIgvsOpJIzOcexlLX0BVJ-vxjq1dYAxFU0GJjU_tw5VCsJPtS1takm9iS9ex7MMLQBwtJZXYl52exghbNlgNaLNnEFahvhMhdvzR0H7Tp2xROnKH0UE01NJLnwfXK-R64cs8FqIigMF8Qb1vHHA5tAMrwIcwJDRvC0-di1mI2PkuianlY4W-2Un7S39eEdsaInshBMlZUXJxmIaqV4DeEv159yKIYpH282QZsEifDV4xJ4RBkXB-Bet_VNwrSLfJ1jfliIGPVIAKOT8zdAFivWAKOaQa86PGu4yBLa4QqlGbRJOep-9khNC9JZ-EJ5hAF3GAvxvFGK-Q3TjaYdTNB8ktm97UihSJA1bbn_0XLdh1dfsHey_qpcRcQimL4biZiBAl2oPkOeQepHqiyE9nQdNE3rOhTMjaN-2HMrD6mRzyHfZ4swtVvbKkJvbeKYyCYP5ESKFFRGNrHe5sVM-m-wi_MqfKvP1HMi4YSD9bV560R469mUQI838It8LswhUgA"}
```

##### JSON example 2 (cell C69)

```json
{  "respHeader": {    "rptDateTime": "2025-09-25 16:01:05",    "versionNo": "1.00"  },  "respBody": {    "type": "Scheme",    "detail": {      "exchangeId": "",      "txnType": "",      "fundCode": "FTI",      "schemeCode": "414",      "planName": "Franklin INFOTECH FUND - Direct-DIRECT-DIVIDEND",      "schemeType": "OE",      "planType": "DIR",      "divOpt": "REINV",      "sysFreq": "",      "sysFreqOpt": "",      "sysDates": "",      "txnMinAmount": "",      "txnMaxAmount": "",      "txnMulAmount": "",      "txnMinUnits": "",      "txnMulUnits": "",      "minInst": "",      "maxInst": "",      "sysPerpetual": "",      "minCumAmt": "",      "startDate": "",      "endDate": "",      "amfiId": "118536",      "priIsin": "INF090I01FG1",      "secIsin": "INF090I01FF3",      "nfoStart": "2019-04-19",      "nfoEnd": "2025-04-20",      "allotDate": "2025-05-02",      "reopenDate": "2025-05-03",      "maturityDate": "1900-01-01",      "entryLoad": "",      "exitLoad": "",      "purAllowed": "Y",      "nfoAllowed": "N",      "redeemAllowed": "Y",      "sipAllowed": "Y",      "switchOutAllowed": "Y",      "switchInAllowed": "Y",      "stpOutAllowed": "Y",      "stpInAllowed": "Y",      "swpAllowed": "Y",      "dematAllowed": "Y",      "catgId": "1",      "subCatgId": "3",      "schemeFlag": "AC"    }  }}
```

##### JSON example 3 (cell C70)

```json
{  "respHeader": {    "rptDateTime": "2025-09-24 10:15:50",    "versionNo": "1.00"  },  "respBody": {    "type": "Threshold",    "detail": {      "schemeList": [        {          "fundCode": "FTI",          "schemeCode": "414",          "txnType": "A",          "sysFreq": "",          "sysFreqOpt": "",          "sysDates": "",          "minAmt": "5.0000",          "maxAmt": "99999.0000",          "multipleAmt": "5.0000",          "minUnits": "0.0000",          "mulUnits": "0.0000",          "minInst": "0",          "maxInst": "0",          "sysPerpetual": "",          "minCumAmt": "0.0000",          "startDate": "2013-01-02",          "endDate": "2099-12-31"        }      ]    }  }}
```

### ORDER-UTILITY

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `ORDER-UTILITY`

#### Order Utility Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/ApiFinTechOrderUtilityService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be ORDER-UTILITY | Char(20) | Yes | ORDER-UTILITY | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:F9`

| reqType | Request Type | Char(1) | Yes | Allowed Values:<br>T - Link Retrigger<br>C - Order Cancellation |
| --- | --- | --- | --- | --- |
| mfuGorn | MFU System Group Order Reference Number | Char(16) | Yes |  |

#### Order Utility Service API – Response

#### Table 4

Source cells: `B13:D13`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B15:D18`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure. | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respHeader Section End

#### Order Utility Service API – Sample Request and Response

#### Table 6

Source cells: `B23:C28`

| Sample Type | Sample |
| --- | --- |
| Request with Encryption | [See JSON example 1 below] |
| Request body without Encryption | [See JSON example 2 below] |
| Response with Encryption | [See JSON example 3 below] |
| Success Response withOut Encryption | [See JSON example 4 below] |
| Failure Response withOut Encryption  | [See JSON example 5 below] |

#### JSON examples

##### JSON example 1 (cell C24)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "ORDER-UTILITY","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C25)

```json
{
"reqType":"","mfuGorn":""
}
```

##### JSON example 3 (cell C26)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 4 (cell C27)

```json
{"respHeader":{"respFlag":"S","respTs":"2024-10-21 12:24:30","errorCode":"","errorMsg":""}}
```

##### JSON example 5 (cell C28)

```json
{"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"}}
```

### SCHSTSCHK

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `SCHSTSCHK`

#### Scheme Status Check Service API – Request

#### URL  to Invoke this API : https://<UAT or PROD URL>/APIFinTechSchemeStatusChkService

#### Table 1

Source cells: `B4:G4`

| JSON Field Name | Description | Data Type | Mandatory Field | Possible / Sample Values | Remarks |
| --- | --- | --- | --- | --- | --- |

#### reqHeader Section - Refer Request Header Detail Sheet

#### Table 2

Source cells: `B6:G6`

| apiType | The request Type should be SCHSTSCHK | Char(20) | Yes | SCHSTSCHK | The values are Case-sensitive |
| --- | --- | --- | --- | --- | --- |

#### reqBody Section –  JSON Field Details

#### Table 3

Source cells: `B8:G11`

| rtaSchCode | RTA Scheme Code | Char(6) | Yes | Column F | Column G |
| --- | --- | --- | --- | --- | --- |
| rtaAmcCode | RTA AMC Code | Char(6) | Yes |  |  |
| actionType | Action Type | Char(3) | Yes | SMF<br>STD |  |
| txnType | Transaction Type | Char(1) | Conditional mandatory | N - Normal Transaction<br>S - Systematic Transaction | txnType is mandatory when actionType is "STD", otherwise it should be empty. |

#### Scheme Status Check Service API – Response

#### Table 4

Source cells: `B15:D15`

| JSON Field Name | Description | Data Type |
| --- | --- | --- |

#### respHeader Section –  JSON Field Details

#### Table 5

Source cells: `B17:D20`

| respTs | The response timestamp will be provided.<br>The date time format is YYYY-MM-DD HH:MM:SS | Date Time |
| --- | --- | --- |
| respFlag | If respFlag is S , request is Success.<br>If respFlag is F , request is Failure and the respBody will be empty | Char(1) |
| errorCode | If respFlag is F, then the error code will be provided in this field else this value will be empty. | Char(10) |
| errorMsg | if respFlag  is F, the error message will be provided in this field  else this value will be empty.  | Char(500) |

#### respBody Section –  JSON Field Details For SMF

#### Table 6

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

#### respBody Section End For SMF

#### respBody Section – without encryption JSON Field Details For STD

#### schemeList Array List Section Start

#### Table 7

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

#### schemeList Array List Section End

#### respBody Section End  For STD

#### Scheme Status Check Service API – Sample Request and Response

#### Table 8

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

#### JSON examples

##### JSON example 1 (cell C77)

```json
{  
"reqHeader": {"entityId": "400005","version": "1.00","reqTS": "2024-06-06 10:20:09","apiType": "SCHSTSCHK","uniqueId": "1000000001"  },  
"reqBody": {"data": "zo3RAgR87RqYVFuvcWP54mFDBv4qxHRg6a2s2D2LZUxNTFb6PbDRu52IXBnPOrw0cCO2UAL6HA3R21bqbBlobw=="  }
}
```

##### JSON example 2 (cell C78)

```json
{"rtaSchCode":"123456","rtaAmcCode":"AXF","actionType":"SMF","txnType":""}
```

##### JSON example 3 (cell C79)

```json
{"rtaSchCode":"123456","rtaAmcCode":"AXF","actionType":"STD","txnType":"N"}
```

##### JSON example 4 (cell C80)

```json
{
  "respData": "UDzBzEzfpbkd9z1DUCs09OCkhsvSc+YDk/6BXZqZ0skrsLMvlYLoG47eWIz7cQkkqSU/KvgS5Gep0Rjw+zg9gU5VrTL66fNQ02LKwPq/T6lfIZGomNhSDBZvO1n3wRiSDnKeZoxEQVjhaBtsBUvcSA=="
}
```

##### JSON example 5 (cell C81)

```json
{"respHeader":{"respFlag":"S","respTs":"2025-03-13 10:48:19","errorCode":"","errorMsg":""},"respBody":{"schemeCode":"REQ","fundCode":"RMF   ","planName":"Reliance Equity Scheme DIR Plan GR NA","schemeType":"IN","planType":"DIR","divOpt":"NA","amfiId":"105265","priIsin":"ISIN12345680","secIsin":"            ","nfoStart":"2012-10-10","nfoEnd":"2012-10-20","allotDate":"2012-10-30","reopenDate":"2012-11-01","maturityDate":"3000-12-31","entryLoad":"","exitLoad":"","purAllowed":"Y","nfoAllowed":"N","redeemAllowed":"Y","sipAllowed":"N","switchOutAllowed":"N","switchInAllowed":"N","stpOutAllowed":"N","stpInAllowed":"N","swpAllowed":"N","dematAllowed":"Y","catgId":"1","subCatgId":"3","schemeFlag":"AC","planOpt":"GR    "}}
```

##### JSON example 6 (cell C82)

```json
{"respHeader":{"respFlag":"S","respTs":"2025-03-12 19:24:59","errorCode":"","errorMsg":""},"respBody":{"sysTxnDtl":[{"fundCode":"FTI","schemeCode":"046","txnType":"I","sysFreq":" ","sysFreqOpt":" ","sysDates":" ","minInst":"0","maxInst":"0","sysPerpetual":" ","minCumAmt":"0.0000","startDate":"2023-05-15","endDate":"2023-06-15","minAmt":"0.0000","maxAmt":"9999999999999.9900","multipleAmt":"0.0000","minUnits":"0.0000","multipleUnits":"0.0000"},{"fundCode":"FTI","schemeCode":"046","txnType":"N","sysFreq":" ","sysFreqOpt":" ","sysDates":" ","minInst":"0","maxInst":"0","sysPerpetual":" ","minCumAmt":"0.0000","startDate":"2023-05-15","endDate":"2023-06-15","minAmt":"0.0000","maxAmt":"9999999999999.9900","multipleAmt":"0.0000","minUnits":"0.0000","multipleUnits":"0.0000"}]}}
```

##### JSON example 7 (cell C83)

```json
{"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"schemeCode":"","fundCode":"","planName":"","schemeType":"","planType":"","divOpt":"","amfiId":"","priIsin":"","secIsin":"","nfoStart":"","nfoEnd":"","allotDate":"","reopenDate":"","maturityDate":"","entryLoad":"","exitLoad":"","purAllowed":"","nfoAllowed":"","redeemAllowed":"","sipAllowed":"","switchOutAllowed":"","switchInAllowed":"","stpOutAllowed":"","stpInAllowed":"","swpAllowed":"","dematAllowed":"","catgId":"","subCatgId":"","schemeFlag":"","planOpt":""}
```

##### JSON example 8 (cell C84)

```json
{"respHeader":{"respFlag":"F","respTs":"2024-10-23 12:36:44","errorCode":"10052","errorMsg":"Invalid Input details"},"respBody":{"sysTxnDtl":[]}
```

### ERROR CODE

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `ERROR CODE`

#### General Error Codes

#### Table 1

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

#### Transaction Error Codes

#### Table 2

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

### Master Data Sheet

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `Master Data Sheet`

#### Table 1

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

#### Direct Debit

#### Bankers Cheque

#### Account Type

#### Table 2

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

#### Tax Master

#### Table 3

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

### Possible Values Mapping

Source workbook: [MF Utility Fintech Transaction API Specification V2.9.xlsx](../MF%20Utility%20Fintech%20Transaction%20API%20Specification%20V2.9.xlsx)  
Source sheet: `Possible Values Mapping`

#### Table 1

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

## Part II: Scheme master data structure

### Scheme Master Data Structure Specifications v2.3

Source document: [Scheme Master Data Structure Specifications v2.3.docx](../Scheme%20Master%20Data%20Structure%20Specifications%20v2.3.docx)

Scheme Master – Data Structure Specifications

#### Overview

This document outlines the data structure of the Scheme Master for sharing with the entities whose system is integrated with MFU for transaction submission.  The Scheme data with MFU is maintained by the AMCs themselves and as such, the data is provided on as is where is basis.

MFU will offer this data as an incremental file on a daily basis. Incremental data will not be provided if there were no changes during the day. The data will be emailed to a designated email id of the entity.

#### Scheme MASTER

###### This file will contain the Master details of the Scheme Plans supported by MFU. The file format will be delimited text file with the ‘|’ symbol (pipe) being the delimiter. The file will be named as below:

###### Incremental – MFU_SCHEME_MASTER_INC_<yyyymmdd>.dat

#### Table 1

| Sl. No | Field Name | Data Type | Description |
| --- | --- | --- | --- |
|  | Scheme_Code | Char(15) | The code assigned by the RTA for the given Scheme Plan and Option This combined with the Fund_Code shall be unique. |
|  | Fund_Code | Char(6) | This is the Fund Code as assigned by the RTAs for the Mutual Fund. This field combined with the Scheme_Code shall be unique. |
|  | Plan_Name | Char(200) | The Name of the Scheme Plan as maintained at MFU |
|  | Scheme_Type | Char(3) | The Type of the Scheme. Contains one of the following values:<br>OE – Open Ended<br>CE – Closed Ended<br>IN – Interval Schemes |
|  | Plan_Type | Char(6) | The type of the Plan. Contains one of the following values:<br>DIR – Direct Plan<br>REG – Regular Plan<br>RET – Retail Plan<br>INST – Institutional Plan<br>SINST – Super Institutional Plan |
|  | Plan_Opt | Char(6) | The Plan Dividend Option. Contains one of the following values:<br>GR – Growth<br>DIV – Dividend<br>BO – Bonus<br>DDIV – Daily Dividend<br>WDIV – Weekly Dividend<br>MDIV – Monthly Dividend<br>FDIV – Fortnightly Dividend<br>QDIV – Quarterly Dividend<br>HDIV – Half Yearly Dividend<br>ADIV – Annual Dividend |
|  | Div_Opt | Char(6) | The Dividend Reinvestment options supported at the Scheme Plan level. Contains one of the following values:<br>PAYOUT – Dividend Payout Option<br>REINV – Dividend Reinvestment Option<br>BOTH – Supports both Payout and Reinvestment the options<br>NA – Not Applicable (In case of Growth / Bonus Plans) |
|  | AMFI_ID | Char(15) | The Scheme ID as maintained by AMFI |
|  | PRI_ISIN | Char(12) | The Primary ISIN Key of the scheme plan.<br>Note: When DIV_OPT is ‘Both’ then this ISIN is for Payout. |
|  | SEC_ISIN | Char(12) | The Secondary ISIN Key of the scheme plan.<br>Note: When DIV_OPT is ‘Both’ then this ISIN is for Re-Investment. |
|  | NFO_Start | Char(11) | NFO Start date for the scheme plan – in dd-MMM-yyyy format. |
|  | NFO_End | Char(11) | NFO End date for the scheme plan – in dd-MMM-yyyy format. |
|  | Allot_Date | Char(11) | Allotment date for the scheme plan – in dd-MMM-yyyy format. |
|  | Reopen_Date | Char(11) | Re-Open date for the scheme plan – in dd-MMM-yyyy format. |
|  | Maturity_Date | Char(11) | Maturity date for the scheme plan – in dd-MMM-yyyy format. |
|  | Entry_Load | Char(1000) | Entry Load for the Scheme Plan |
|  | Exit_Load | Char(1000) | Exit Load for the Scheme Plan |
|  | Pur_Allowed | Char(1) | Flag to indicate whether Purchase Transactions are permissible for the scheme plan. Contains one of the following values:<br>Y – Yes<br>N – No |
|  | NFO_Allowed | Char(1) | Flag to indicate whether NFO Transactions are permissible for the scheme plan. Contains one of the following values:<br>Y – Yes<br>N – No |
|  | Redeem_Allowed | Char(1) | Flag to indicate whether Redemption Transactions are permissible for the scheme plan. Contains one of the following values:<br>Y – Yes<br>N – No |
|  | SIP_Allowed | Char(1) | Flag to indicate whether SIP Transactions are permissible for the scheme plan. Contains one of the following values:<br>Y – Yes<br>N – No |
|  | Switch_Out_Allowed | Char(1) | Flag to indicate whether Switch Out Transactions are permissible for the scheme plan. Contains one of the following values:<br>Y – Yes<br>N – No |
|  | Switch_In_Allowed | Char(1) | Flag to indicate whether Switch In Transactions are permissible for the scheme plan. Contains one of the following values:<br>Y – Yes<br>N – No |
|  | STP_Out_Allowed | Char(1) | Flag to indicate whether STP Out Transactions are permissible for the scheme plan. Contains one of the following values:<br>Y – Yes<br>N – No |
|  | STP_In_Allowed | Char(1) | Flag to indicate whether STP In Transactions are permissible for the scheme plan. Contains one of the following values:<br>Y – Yes<br>N – No |
|  | SWP_Allowed | Char(1) | Flag to indicate whether SWP Transactions are permissible for the scheme plan. Contains one of the following values:<br>Y – Yes<br>N – No |
|  | Demat_Allowed | Char(1) | Flag to indicate whether the units can be allotted in DEMAT mode for the scheme plan. Contains one of the following values:<br>Y – Yes<br>N – No |
|  | Catg ID | Char(2) | Flag to indicate the category type for the scheme Plan. Contains one of the following values. |
|  | Sub-Catg ID | Char(2) | Flag to indicate the Sub-category type within the main category for the scheme Plan. Contains one of the following values. |
|  | Scheme Flag | Char(2) | Flag to indicate the whether the scheme is active or not. Contains one of the following values.<br>AC – Active<br>SU – Suspended |

#### Table 2

| Cat. Code | Category Description |
| --- | --- |
| 1 | EQUITY |
| 2 | DEBT |
| 3 | CASH/LIQUID/MONEY MARKET |
| 4 | HYBRID |

#### Table 3

| Cat. Code | Sub-Cat. Code | Sub-Cat. Description |
| --- | --- | --- |
| 1 | 1 | EQUITY LINKED SAVINGS SCHEMES (ELSS) |
| 1 | 2 | BALANCED SCHEMES |
| 1 | 3 | OTHER EQUITY SCHEMES |
| 1 | 4 | GOLD EXCHANGE TRADED FUND (GETF) |
| 1 | 5 | OTHER EXCHANGE TRADED FUNDS (OETF) |
| 1 | 6 | FUND OF FUNDS - DOMESTIC |
| 1 | 7 | FUND OF FUNDS - INVESTING OVERSEAS |
| 1 | 8 | INDEX FUNDS |
| 2 | 1 | GILT SCHEMES |
| 2 | 2 | INFRASTRUCTURE DEBT FUND SCHEMES |
| 2 | 3 | DEBT (ASSURED RETURN SCHEMES) |
| 2 | 4 | DEBT (OTHER THAN ASSURED RETURN SCHEMES) |
| 2 | 5 | OTHER DEBT SCHEMES |
| 2 | 6 | FUND OF FUNDS - DOMESTIC |
| 2 | 7 | FUND OF FUNDS - INVESTING OVERSEAS |
| 2 | 8 | INDEX FUND |
| 3 | 1 | LIQUID/CASH/MONEY MARKET SCHEMES |
| 4 | 1 | AGGRESSIVE HYBRID FUND |
| 4 | 2 | ARBITRAGE FUND |
| 4 | 3 | BALANCED HYBRID FUND |
| 4 | 4 | CONSERVATIVE HYBRID FUND |
| 4 | 5 | DYNAMIC ASSET ALLOCATION OR BALANCED ADVANTAGE |
| 4 | 6 | EQUITY SAVINGS |
| 4 | 7 | MULTI ASSET ALLOCATION |

#### Scheme THRESHOLD MASTER

###### This file contains the Scheme Threshold and other parameters for the Scheme Plans supported by MFU. The file format will be delimited text file with the ‘|’ symbol (pipe) being the delimiter. The file will be named as below:

###### Incremental – MFU_SCHEME_THRESHOLD_INC_<Date>.dat

#### Table 4

| Sl. No | Field Name | Data Type | Description |
| --- | --- | --- | --- |
|  | Fund_Code | Char (6) | This is the Fund Code as assigned by the RTAs for the Mutual Fund. This field combined with the Scheme_Code shall be unique. |
|  | Scheme_Code | Char (15) | The code assigned by the RTA for the given Scheme Plan and Option This combined with the Fund_Code shall be unique. |
|  | Txn_Type | Char (1) | The Transaction Type. Contains one of the following values:<br>A – Additional Purchase<br>B – Fresh Purchase<br>N – NFO Purchase<br>R – Redemption<br>V – SIP<br>I – Switch In<br>O – Switch Out<br>X – STP In<br>Y – STP Out<br>J – SWP |
|  | Sys_Freq | Char (1) | The Frequency in case of Systematic Transactions. Contains one of the following:<br>D – Daily<br>W- Weekly<br>F – Fortnightly<br>M – Monthly<br>Q – Quarterly<br>S – Semi Annual (Half Yearly)<br>A – Annual<br>In case of Non-Systematic Transactions, this field will contain the value ‘D’ |
|  | Sys_Freq_Opt | Char (1) | Flag to indicate the date option for the Systematic Transaction. Contains one of the following:<br>A – Any Date<br>S – Specific Date<br>May contain empty values also in certain cases. |
|  | Sys_Dates | Char (50) | The permissible dates for systematic transactions by the Fund, for the scheme, for the Systematic Transaction Type. For normal transactions, this input shall be specified as Blank. Applicable only for Systematic transaction types, if the Systematic Transaction Date option is provided as 'S'.<br>For Daily Frequency, the dates shall not be specified.<br>For Weekly DAY based Frequency, this column shall have values from 1-5, denoting 1-Monday, 2-Tuesday...,5-Friday.<br>For Weekly DATE based Frequency, this column shall have the values of the date sets each separated by a comma (,) as shown below:<br>"1,8,15,22/3,10,17,24/5,12,19,27" and so on<br>For Fortnightly Frequency, this column shall be provided with the list of pair of dates, with each pair of dates separated by a semi colon (;), within which each date separated by a comma (,) as shown below:<br>"1,16;5,20;7,29"<br>For other frequencies, the respective dates shall be specified each separated by a slash (/).<br>For example, "2/8/15/24", "5/10/15/25" etc.<br>If there is a configuration for the Last Working Date, the same shall be specified as "LD" along with the other transaction dates. |
|  | Min_Amt | Numeric (20,4) | Minimum Scheme Threshold in amount |
|  | Max_Amt | Numeric (20,4) | Maximum Scheme Threshold in amount |
|  | Multiple_Amt | Numeric (20,4) | Threshold for Amount in multiples beyond the minimum threshold |
|  | Min_Units | Numeric (20,4) | Minimum scheme threshold in units |
|  | Multiple_Units | Numeric (20,4) | Multiple scheme threshold in units |
|  | Min_Inst | Numeric (5,0) | Minimum number of installments for Systematic transactions |
|  | Max_Inst | Numeric (5,0) | Maximum number of installments for Systematic transactions |
|  | Sys_Perpetual | Char (1) | Flag to indicate whether perpetual Systematic setup is permissible. Contains Y / N |
|  | Min_Cum_Amt | Numeric (20,4) | Minimum cumulative amount (all installments put together) for Systematic transactions |
|  | Start_Date | Char (11) | The effective start date for the threshold setting |
|  | End_Date | Char (11) | The effective end date for the threshold setting |

#### Document Change History

#### Table 5

| Version | Revision<br>Date | Change<br>Description |
| --- | --- | --- |
| 1.0 |  | Base Version |
| 1.1 |  | Scheme: New fields [Demat, Scheme Category& Scheme Sub-Category] introduced, Fund Name will not be shown<br>Threshold: Label Maximum_Units changed to Multiple_Units |
| 2.0 |  | Scheme: New field to indicate Scheme is active or not<br>Threshold: NFO threshold details added |
| 2.1 | 24 Jul 2018 | New dataset with source and target scheme whenever the scheme is merged. |
| 2.2 | 07 Sep 2021 | Scheme Category and Scheme subcategory value list updated |
| 2.3 | 28 Jan 2023 | Scheme Merger Dataset removed |

## Part III: UAT test data

Source: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)

### AMC-Scheme Master

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `AMC-Scheme Master`

#### UAT Environment

#### Scheme / Threshold Dropbox Link

#### Table 1

Source cells: `A3:B4`

| Scheme: | https://www.dropbox.com/scl/fi/52ywzic4fnhhkvwskis0s/UAT-All-Scheme-20210811.xlsx?dl=0&rlkey=rws7klr0vh6o72bqo8q5tlku6 |
| --- | --- |
| Threshold: | https://www.dropbox.com/scl/fi/z9s02ifw76rqkq4zei4y1/UAT-All-Threshold-20210811.xlsx?dl=0&rlkey=v6zhi0bgn28aygqa9hufkhejh |

#### Table 2

Source cells: `A6:C39`

| RTA<br>Short<br>Code | RTA<br>Fund<br>Code | Fund<br>Name |
| --- | --- | --- |
| CAMS | B      | Birla Sunlife Mutual Fund Ltd., |
|  | D      | DSP Blackrock Mutual Fund |
|  | F      | L & T Mutual Fund |
|  | G      | IDFC Mutual Fund |
|  | H      | HDFC Mutual Fund Ltd., |
|  | IF     | IIFL Mutual Fund |
|  | K      | Kotak Mutual Fund |
|  | L      | SBI Mutual Fund |
|  | MM     | MAHINDRA Mutual Fund |
|  | O      | HSBC Mutual Fund |
|  | P      | ICICI Prudential Mutual Fund |
|  | PP     | PPFAS Mutual Fund |
|  | T      | TATA Mutual Fund |
| FT | FTI    | Franklin Templeton MF |
| KARVY | 135    | IDBI Mutual Fund |
|  | AXF    | AXIS Mutual Fund |
|  | CRF    | CRAMC |
|  | EMF    | Edelweiss Mutual Fund |
|  | IBM    | Indiabulls Mutual Fund |
|  | MOF    | Motilal Oswal Mutual Fund |
|  | PLF    | Peerless Mutual Fund |
|  | PMF    | Principal Mutual Fund |
|  | PRF    | DHFL |
|  | QMF    | Quantum Mutual Fund |
|  | RGF    | Religare Invesco Mutual Fund |
|  | RMF    | RELIANCE Mutual Fund |
|  | TMF    | Taurus Mutual Fund |
|  | UTI    | UTI Mutual Fund |
|  | 166    | QUANT MF |
|  | JMF    | JM mutual fund |
|  | MAF    | Mirae Asset Mutual Fund |
| SUN | BNP    | BNP Paribas |
|  | SMF    | Sundaram Mutual Fund |

### CAN

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `CAN`

#### Table 1

Source cells: `A1:AA25`

| CAN ID | Investory Category | CAN Category | Residential Status | PAN_PEKRN | First Applicant | Primary Holder DOB/DOI | Place of Incorporation | Commencement Date | Registration Number | Joint 1 PAN | Second Applicant | Joint 1 DOB | Joint 2 PAN | Joint 2 Applicant | Joint 2 DOB | Guardian PAN | Guardian Name | Guardian DOB | RegnDate | Address1 | Address2 | Address3 | City | PinCode | State Name | Holding Mode |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 14157AKA01 | Individual  | I | 01-RES.IND | CTXPS3820B           | silvi | 1991-06-05 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-06 | qqe |  |  | gjfg | 245874 | Puducherry | Single  |
| 14157AKA02 | Individual  | I | 01-RES.IND | ASDFG1234G           | nayu | 1994-06-02 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-05 | srtga |  |  | lkijol | 135486 | Assam | Single  |
| 14157AKA03 | Individual  | I | 01-RES.IND | MNBVC1234X           | naya | 1991-06-05 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-06 | D |  |  | DSGSDG | 231024 | Tamil Nadu | Single  |
| 14157AZA01 | Individual  | I | 01-RES.IND | PAAKA1251Q           | Harry | 1980-10-10 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-06 | a | a | a | qq | 400606 | Punjab | Single  |
| 14162ANA02 | Individual  | I | 01-RES.IND | AJEBD1245A           | ab | 1970-10-10 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-11 | aa |  |  | fg | 212121 | Meghalaya | Single  |
| 14162AZA01 | Individual  | I | 01-RES.IND | AOBPP5246C           | AKASH | 1985-06-22 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-11 | MUMBAI |  |  | MUMBAI | 421202 | Maharashtra | Single  |
| 14163AKA01 | Individual  | I | 01-RES.IND | EBOND1234E           | tom | 1991-10-05 |  |  |  | FBOND1234F | maggi | 1991-10-04 | GBOND1234G | soup | 1991-10-03 |                      |   |  | 2014-06-12 | mnajkh |  |  | thane | 123456 | Maharashtra | Joint |
| 14163BEA01 | Individual  | I | 01-RES.IND | PPPPP5555P           | MANOJ | 1970-06-01 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-12 | MUMBAI |  |  | MUMBAI | 421202 | Maharashtra | Single  |
| 14167AZA01 | Individual  | I | 01-RES.IND | MONEY7777D           | MATHAN | 1960-06-01 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-16 | MUMBAI |  |  | MUMBAI | 421202 | Maharashtra | Single  |
| 14188AMA06 | Individual  | I | 04-Foreign National | GEWPS3117R           | Dinesh Poojary | 1978-08-22 |  |  |  | DEWPS3117R | Deevakar K Shetty | 1975-10-03 |  |  |  |                      |   |  | 2014-07-05 | xy |  |  | Hongkong | 600015 | Not Applicable | Joint |
| 14188BAA01 | Individual  | I | 01-RES.IND | DEWPS3117R           | Dinkar Shetty | 1975-10-03 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-07-05 | xyz |  |  | THANE | 421202 | Maharashtra | Single  |
| 14189AMA02 | Individual  | I | 02-NRI-NRE | AGPPR3689R           | BIPIN KAKODKAR | 1954-07-19 |  |  |  | AGYPR3689R | SATISH RATHOD | 1972-07-29 |  |  |  |                      |   |  | 2014-07-05 | 333 | ABC | XYZ | WASHINGTON | 000000 | Not Applicable | Joint |
| 14189BAA01 | Individual  | I | 01-RES.IND | DDDDD1234Z           | raju kasare | 1982-01-01 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-07-08 | holy family church |  |  | MUMBAI | 400093 | Maharashtra | Single  |
| 14189BAA04 | Individual  | I | 01-RES.IND | ABCDT1234G           | TOMY GONSALVES | 1992-12-12 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-07-05 | xxxx |  |  | MUMBAI | 400093 | Maharashtra | Single  |
| 14189BAA05 | Individual  | I | 01-RES.IND | AAABC1234D           | santosh agarwal | 1990-01-01 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-07-05 | XXXXXX |  |  | THANE | 400601 | Maharashtra | Single  |
| 14190BEA01 | Individual  | I | 01-RES.IND | FBOND1234F           | NAYAN | 1991-10-03 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-17 | fdz |  |  | jgikj | 213545 | Andhra Pradesh | Single  |
| 14190BIA01 | Individual  | I | 01-RES.IND | AFRPT5172M           | Monali | 1982-08-02 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-07-09 | 103 Orion Park Society |  |  | THANE | 400601 | Maharashtra | Single  |
| 14195AZA01 | Individual  | I | 01-RES.IND | TESTI1234N           | ALOK | 1980-07-01 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-07-14 | mumbai |  |  | THANE | 421202 | Maharashtra | Single  |
| 14212AYA01 | Individual  | I | 01-RES.IND | WERTY5466Y           | test | 1988-07-15 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-07-31 | mettu street |  |  | CHENNAI | 600020 | Tamil Nadu | Single  |
| 14213AJA01 | Individual  | I | 01-RES.IND | KYCTE1234T           | mfu marketing | 1988-12-12 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-08-01 | mettu street |  |  | CHENNAI | 600021 | Tamil Nadu | Single  |
| 14213AMA01 | Individual  | I | 01-RES.IND | BBBBB1234C           | RAM PRATAP SINGH | 1972-06-03 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-08-01 | RAM NIWAS | SULTANPUR |  | PATNA | 800001 | Bihar | Single  |
| 14214AZA06 | Individual  | I | 01-RES.IND | AMXPG9123F           | Saramma George | 1956-08-09 |  |  |  | AQCPB0193R | Rahul Pankajkumar Bhagat | 1990-05-09 |  |  |  |                      |   |  | 2014-08-02 | Eattickal House | Mundiappally PO |  | Kunnamthanam | 689593 | Kerala | Joint |
| 16056BAA01 | Non-Individual | N | 01-Pvt. Ltd. Company | NONIN0001B           | Aircel Cellular Pvt Ltd | 1985-05-31 | Chennai | 1985-06-01 | 1234567              |  |  |  |  |  |  |                      |   |  | 2016-02-25 | 45 roop emerald building |  | T Nagar | CHENNAI | 600017 | Tamil Nadu | Single  |
| 16056BAA02 | Non-Individual | N | 01-Pvt. Ltd. Company | NONIN0001C           | GRT Jewellers Pvt Ltd | 1985-05-31 | Mumbai | 1985-06-01 | 6541254521           |  |  |  |  |  |  |                      |   |  | 2016-02-25 | 45 roop emerald building |  | T Nagar | CHENNAI | 600017 | Tamil Nadu | Single  |

#### Table 2

Source cells: `A27:AA32`

| CAN ID | Investory Category | CAN Category | Residential Status | PAN_PEKRN | First Applicant | Primary Holder DOB/DOI | Place of Incorporation | Commencement Date | Registration Number | Joint 1 PAN | Second Applicant | Joint 1 DOB | Joint 2 PAN | Joint 2 Applicant | Joint 2 DOB | Guardian PAN | Guardian Name | Guardian DOB | RegnDate | Address1 | Address2 | Address3 | City | PinCode | State Name | Holding Mode |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 14163AKA01 | Individual  | I | 01-RES.IND | EBOND1234E           | tom | 1991-10-05 |  |  |  | FBOND1234F | maggi | 1991-10-04 | GBOND1234G | soup | 1991-10-03 |                      |   |  | 2014-06-12 | mnajkh |  |  | thane | 123456 | Maharashtra | Joint |
| 14175AYA05 | Individual  | I | 01-RES.IND | AWHPM7811L           | Manish Dangra | 1979-07-01 |  |  |  | APZPV0087J | Karunakar | 1974-11-30 |  |  |  |                      |   |  | 2014-06-24 | 1-86 South Kalliadappu | Sasthankarai |  | Kanyakumari | 629251 | Tamil Nadu | Joint |
| 14188AMA06 | Individual  | I | 04-Foreign National | GEWPS3117R           | Dinesh Poojary | 1978-08-22 |  |  |  | DEWPS3117R | Deevakar K Shetty | 1975-10-03 |  |  |  |                      |   |  | 2014-07-05 | xy |  |  | Hongkong | 600015 | Not Applicable | Joint |
| 14189AMA02 | Individual  | I | 02-NRI-NRE | AGPPR3689R           | BIPIN KAKODKAR | 1954-07-19 |  |  |  | AGYPR3689R | SATISH RATHOD | 1972-07-29 |  |  |  |                      |   |  | 2014-07-05 | 333 | ABC | XYZ | WASHINGTON | 000000 | Not Applicable | Joint |
| 14206BAA01 | Individual  | I | 01-RES.IND | APZPV0087J           | Bhavana Verma | 1974-11-30 |  |  |  | AARPA0708N | Pushpa R | 1970-12-10 |  |  |  |                      |   |  | 2014-07-25 | Plot No 15 Lek Palace | Village, Chhota Bagandada | Tehsil Indor Disctric, | Indore | 452006 | Madhya Pradesh | Joint |

#### PayEezz Registered CANs

#### Table 3

Source cells: `A34:AA39`

| CAN ID | Investory Category | CAN Category | Residential Status | PAN_PEKRN | First Applicant | Primary Holder DOB/DOI | Place of Incorporation | Commencement Date | Registration Number | Joint 1 PAN | Second Applicant | Joint 1 DOB | Joint 2 PAN | Joint 2 Applicant | Joint 2 DOB | Guardian PAN | Guardian Name | Guardian DOB | RegnDate | Address1 | Address2 | Address3 | City | PinCode | State Name | Holding Mode |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 14157AZA01 | Individual  | I | 01-RES.IND | PAAKA1251Q           | Harry | 1980-10-10 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-06 | a | a | a | qq | 400606 | Punjab | Single  |
| 14163BEA01 | Individual  | I | 01-RES.IND | PPPPP5555P           | MANOJ | 1970-06-01 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-12 | MUMBAI |  |  | MUMBAI | 421202 | Maharashtra | Single  |
| 15309BAA01 | Individual  | I | 01-RES.IND | AAAAA7896S           | Sheetal | 1980-11-13 |  |  |  |  |  |  |  |  |  |                      |   |  | 2015-11-05 | 45 Roop Emerald Building |  | T Nagar | CHENNAI | 600017 | Tamil Nadu | Single  |
| 15343BAA01 | Individual  | I | 01-RES.IND | UERTY1234U           | mfu Marketing | 1983-08-21 |  |  |  |  |  |  |  |  |  |                      |   |  | 2015-12-09 | 24, Testing | Usman Road | T.Nagar | CHENNAI | 600017 | Tamil Nadu | Single  |
| 16018BAA03 | Individual  | I | 01-RES.IND | AAAAA0101A           | Sukumar | 1985-05-31 |  |  |  |  |  |  |  |  |  |                      |   |  | 2016-01-18 | 18 kumarappan mudali street |  |  | CHENNAI | 600017 | Tamil Nadu | Single  |

#### Anyone or Survivor

#### Table 4

Source cells: `A41:AB44`

| 14219SSA01 | Individual  | I | 01-RES.IND | AEOPP5984N           | SUNDAR | 1964-07-21 | Column H | Column I | Column J | APZPV0087J | Bhavana Verma | 1974-11-30 | AWHPM7811L | R Murugadhas | 1979-07-01 |                      |   | Column S | 2014-08-07 | 7 C, Shatri Namge | Adyar | CHennai | Chennai | 600020 | Tamil Nadu | Anyone or Survivor | AP |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 15014BAA03 | Individual  | I | 01-RES.IND | AGKPJ8175D           | VIJENDRA SURAJ JABRA | 1979-03-06 |  |  |  | ADUPL6168M | MADAN LAL | 1956-02-15 | ADHPP4619E | AKHILESH PANDYA | 1963-04-18 |                      |   |  | 2015-01-14 | C 8 Jeevan Vikas | V P Road | Santacruz W | Mumbai | 400054 | Maharashtra | Anyone or Survivor | AP |
| 15111AXA03 | Individual  | I | 01-RES.IND | DADDY1003A           | Daddy Three | 1985-10-10 |  |  |  | DADDY1002A | Daddy Two | 1985-10-10 | DADDY1001A | Daddy One | 1985-10-11 |                      |   |  | 2015-04-21 | One | Two | Three | MUMBAI | 400001 | Maharashtra | Anyone or Survivor | AP |
| 16035BAA01 | Individual  | I | 01-RES.IND | ACDPP0707A           | Swaminathan KR | 1964-09-16 |  |  |  | ARWPP3455H | apoorva | 1966-08-21 | AEOPP5984N | manish | 1964-07-21 |                      |   |  | 2016-02-04 | 17-YESHODIP SOCIETY 1ST WING | NEAR MONIS HOTEL | M G ROAD NAUPADA | THANE WEST | 400602 | Maharashtra | Anyone or Survivor | AP |

### Depository

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `Depository`

#### Table 1

Source cells: `A1:C24`

| CAN | DP/Client ID | Depository ID |
| --- | --- | --- |
| 14157AKA01 | IN30302923188719 | NSDL |
| 14157AKA02 | IN80602923192719 | NSDL |
| 14157AKA03 | 1234567891234567 | CDSL |
| 14157AZA01 | 2134234234234234 | CDSL |
| 14157AZA01 | IN23456789012345 | NSDL |
| 14162ANA02 | 2102909006173242 | CDSL |
| 14162ANA02 | IN40602923129182 | NSDL |
| 14163AKA01 | 5654463543456456 | CDSL |
| 14167AZA01 | 8888888888888888 | CDSL |
| 14167AZA01 | IN99999999999999 | NSDL |
| 14188AMA06 | 3012532062444444 | CDSL |
| 14188BAA01 | 3012325366222111 | CDSL |
| 14189AMA02 | 1301930090000002 | CDSL |
| 14189AMA02 | IN30009590000001 | NSDL |
| 14206BAA01 | 9876543210987654 | CDSL |
| 14206BAA01 | IN12345678901234 | NSDL |
| 15014BAA03 | 9898989898989898 | CDSL |
| 15014BAA03 | IN12345678123456 | NSDL |
| 16056BAA01 | IN12345678912345 | NSDL |
| 16056BAA02 | 6789012345678901 | CDSL |
| 16056BAA02 | IN56789012345678 | NSDL |
| 17017BAA01 | 24680023113579   | CDSL |
| 17017BAA01 | IN13579923182468 | NSDL |

### Email-Mobile

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `Email-Mobile`

#### Table 1

Source cells: `A1:D10`

| CAN | Primary Mobile | Primary Email | Consent Data |
| --- | --- | --- | --- |
| 14157AKA02 | 9819963779 | ravindran@mfuindia.in | Y |
| 14157AKA03 | 7208205081 | rutik421134@gmail.com | Y |
| 14157AZA01 | 9833940275 | nitin@mfuindia.in | Y |
| 14162ANA02 | 7867898700 | jigar@mfuindia.in | N |
| 14162AZA01 | 8793608638 | abhishekkumar.890@gmail.com | N |
| 14163AKA01 | 9042136911 | gdfggh@fdsf.gfd | Y |
| 14163BEA01 | 8369397922 | sundar.chandrasekaran@tridentsqa.com | N |
| 14167AZA01 | 9763564979 | theresaf@mfuindia.in | Y |
| 14175AYA05 | 8054810985 | manish@mfuindia.com | N |

### CAN Folio Holding

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `CAN Folio Holding`

#### Table 1

Source cells: `A1:S21`

| CAN | Folio No | Folio Check Digit | Scheme Name | Unit Holding | Fund Code | RTA Scheme Code | Scheme Type | Plan Type | Div Option | nfo_allowed | redeem_allowed | sip_allowed | switch_out_allowed | Switch_In_Allowed | stp_out_allowed | stp_in_allowed | swp_allowed | Scheme Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 14157AKA03 | AKA031415713 |  | RELIANCE LIQUIDITY FUND - DIRECT QUARTERLY DIVIDEND REINVESTMENT OPTION | 26768.7130 | RMF | LQAQ | OE  | DIR    | PAYOUT |  |  |  |  |  |  |  |  |  |
| 14163AKA01 | AKA011416321 | 64 | RELIANCE LIQUIDITY FUND - DIRECT WEEKLY DIVIDEND REINVESTMENT OPTION | 44022.3210 | RMF | LQAW | OE  | DIR    | REINV  |  |  |  |  |  |  |  |  |  |
| 14167AZA01 | AZA011416725 |  | RELIANCE LIQUIDITY FUND - DIRECT GROWTH - BONUS OPTION | 55535.7250 | RMF | LQAB | OE  | DIR    | NA     |  |  |  |  |  |  |  |  |  |
| 14167AZA01 | AZA011416730 |  | RELIANCE LIQUIDITY FUND - DIRECT GROWTH PLAN GROWTH OPTION | 57480.7300 | RMF | LQAG | OE  | DIR    | NA     |  |  |  |  |  |  |  |  |  |
| 14157AKA03 | AKA031415711 |  | Birla Sun Life'95 Fund - Dividend Reinvest-Direct Plan | 72589.7110 | B | ADZ | OE  | DIR    | REINV  |  |  |  |  |  |  |  |  |  |
| 14157AKA03 | AKA031415715 |  | Birla Sun Life Buy India Fund - Dividend-Direct Plan | 79236.7150 | B | 11Z | OE  | DIR    | BOTH   |  |  |  |  |  |  |  |  |  |
| 14167AZA01 | AZA011416726 |  | Tax Relief'96 Fund-ELSS - Dividend Reinvest-Direct Plan | 165500.7260 | B | 02DZ | OE  | DIR    | REINV  |  |  |  |  |  |  |  |  |  |
| 14167AZA01 | AZA011416728 |  | Tax Relief'96 Fund-ELSS - Dividend Reinvest-Regular Plan | 172146.7280 | B | 02D | OE  | REG    | REINV  |  |  |  |  |  |  |  |  |  |
| 14157AKA03 | FT000001111 |  | Franklin India PRIMA FUND-REGULAR-DIVIDEND | 196.3535 | FTI | 001 | OE  | REG    | REINV  |  |  |  |  |  |  |  |  |  |
| 14157AKA03 | FT000002111 |  | Franklin India PRIMA FUND-REGULAR-DIVIDEND | 196.3535 | FTI | 001 | OE  | REG    | REINV  |  |  |  |  |  |  |  |  |  |
| 14157AKA03 | FT000001112 |  | Franklin India BLUECHIP FUND-REGULAR-DIVIDEND | 152.2367 | FTI | 006 | OE  | REG    | BOTH   |  |  |  |  |  |  |  |  |  |
| 14157AKA03 | FT000002112 |  | Franklin India BLUECHIP FUND-REGULAR-DIVIDEND | 152.2367 | FTI | 006 | OE  | REG    | BOTH   |  |  |  |  |  |  |  |  |  |
| 14167AZA01 | FT000001115 |  | Franklin India Income Builder Account - Plan A-REGULAR-GROWTH | 6595.1177 | FTI | 012 | OE  | REG    | NA     |  |  |  |  |  |  |  |  |  |
| 14167AZA01 | FT000002115 |  | Franklin India Income Builder Account - Plan A-REGULAR-GROWTH | 6595.1177 | FTI | 012 | OE  | REG    | NA     |  |  |  |  |  |  |  |  |  |
| 14167AZA01 | AZA011416727 |  | Franklin INFOTECH FUND Regular-Growth | 1782.7270 | FTI | 025 | OE  | REG    | NA     |  |  |  |  |  |  |  |  |  |
| 14167AZA01 | AZA011416729 |  | Franklin INFOTECH FUND-REGULAR-DIVIDEND | 1876.7290 | FTI | 026 | OE  | REG    | REINV  |  |  |  |  |  |  |  |  |  |
| 14157AKA03 | AKA031415712 |  | Franklin India Pension Plan-REGULAR-GROWTH | 754.7120 | FTI | 010 | OE  | REG    | NA     |  |  |  |  |  |  |  |  |  |
| 14157AZA01 | 18314548 |  | Franklin INFOTECH FUND - Direct-DIRECT-DIVIDEND | 2006.0020 | FTI | 414 | OE  | DIR    | REINV  |  |  |  |  |  |  |  |  |  |
| 14157AZA01 | 18314550 |  | Franklin INFOTECH FUND - Direct-DIRECT-DIVIDEND | 4012.0040 | FTI | 414 | OE  | DIR    | REINV  |  |  |  |  |  |  |  |  |  |
| 14157AKA03 | AKA031415714 |  | IDFC Ultra Short Term Fund-Monthly Dividend-(Direct Plan) | 43860.7140 | G | D68 | OE  | DIR    | BOTH   |  |  |  |  |  |  |  |  |  |

### CAN Bank

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `CAN Bank`

#### Table 1

Source cells: `A1:H106`

| CAN ID | Bank ID | Bank Name | MICR# | IFSC | A/c No. | A/c Type | Support for ePayEezz |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 14157AKA01 | 065  | ABHYUDAYA CO-OP BANK | 400065002 | ABHY0065002 | 1234656789 | SB   |  |
| 14157AKA02 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 11111111111111111111 | PSB  |  |
| 14157AKA02 | 065  | ABHYUDAYA CO-OP BANK | 400065018 | ABHY0065018 | 1000000000 | SB   |  |
| 14157AKA03 | 065  | ABHYUDAYA CO-OP BANK | 400065002 | ABHY0065002 | 987654321 | SB   |  |
| 14157AZA01 | 010  | ALLAHABAD BANK | 440010004 | ALLA0210191 | 1000121 | SB   |  |
| 14157AZA01 | 011  | ANDHRA BANK | 560011005 | ANDB0000093 | 009311100003235 | SB   |  |
| 14157AZA01 | 013  | BANK OF INDIA | 110013001 | BKID0006100 | 234567890 | SB   |  |
| 14157AZA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 1213 | SB   |  |
| 14157AZA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 12345 | SB   |  |
| 14157AZA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 1234567890 | SB   |  |
| 14157AZA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 5678901234 | SB   |  |
| 14157AZA01 | 036  | STANDARD CHARTERED BANK | 360036002 | SCBL0036064 | 1234567353 | CA   |  |
| 14157AZA01 | 036  | STANDARD CHARTERED BANK | 400036008 | SCBL0036052 | 1234567654132425 | SB   |  |
| 14157AZA01 | 036  | STANDARD CHARTERED BANK | 360036002 | SCBL0036064 | 1234567890 | SB   |  |
| 14157AZA01 | 036  | STANDARD CHARTERED BANK | 560036002 | SCBL0036073 | 21345675432 | OD   |  |
| 14157AZA01 | 211  | AXIS BANK LTD | 560211016 | UTIB0000558 | 913010038337725 | SB   |  |
| 14157AZA01 | 240  | HDFC BANK LTD | 110240012 | HDFC0000090 | 50200013404502 | SB   |  |
| 14157AZA01 | 259  | IDBI LTD | 411259019 | IBKL0000677 | 12345 | SB   |  |
| 14157AZA01 | 259  | IDBI LTD | 695180018 | IBKL0046T54 | 12345 | SB   |  |
| 14162ANA02 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 2500 | SB   |  |
| 14162ANA02 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 333 | SB   |  |
| 14162ANA02 | 229  | ICICI BANK LTD | 411229017 | ICIC0006450 | 125 | SB   |  |
| 14162ANA02 | 240  | HDFC BANK LTD | 400240003 | HDFC0000001 | 50100015780210 | SB   |  |
| 14162AZA01 | 010  | ALLAHABAD BANK | 110010002 | ALLA0210835 | 1212012301 | SB   |  |
| 14162AZA01 | 015  | CANARA BANK | 673015006 | CNRB0002385 | 254545 | CA   |  |
| 14162AZA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 99999999999999999999 | SB   |  |
| 14162AZA01 | 072  | DEVELOPMENT CREDIT BANK | 600072002 | DCBL0000060 | 5420102 | SB   |  |
| 14162AZA01 | 211  | AXIS BANK LTD | 522211302 | UTIB0000475 | 888889885888 | SB   |  |
| 14162AZA01 | 229  | ICICI BANK LTD | 411229017 | ICIC0006450 | 12222222222222222222 | SB   |  |
| 14162AZA01 | 240  | HDFC BANK LTD | 400240003 | HDFC0000001 | 50100015780210 | SB   |  |
| 14162AZA01 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 5555 | SB   |  |
| 14162AZA01 | 240  | HDFC BANK LTD | 682240026 | HDFC0001222 | 77899898 | SB   |  |
| 14162AZA01 | 532  | YES BANK LTD | 171532002 | YESB0000091 | 54545 | SB   |  |
| 14163AKA01 | 065  | ABHYUDAYA CO-OP BANK | 400065013 | ABHY0065013 | 1234 | SB   |  |
| 14163BEA01 | 012  | BANK OF BARODA | 110012001 | BARB0SERDEL | 12345678990 | SB   |  |
| 14163BEA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 12345 | SB   |  |
| 14163BEA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 1234567890 | SB   |  |
| 14163BEA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 12345678901234567890 | CLSB |  |
| 14163BEA01 | 072  | DEVELOPMENT CREDIT BANK | 110072006 | DCBL0000092 | 1234567890 | SB   |  |
| 14163BEA01 | 096  | AHMEDNAGAR SAHAKARI BANK LTD,BOMBAY | 400096004 | MCBL0960004 | 1234567891230120 | OD   |  |
| 14163BEA01 | 118  | AHMEDABAD DIST.CO-OP BANK LTD | 380118321 | HDFC0CGNCBL | 1234567890 | SB   |  |
| 14163BEA01 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 123456 | SB   |  |
| 14163BEA01 | 240  | HDFC BANK LTD | 110240029 | HDFC0000248 | 1234567 | SB   |  |
| 14163BEA01 | 240  | HDFC BANK LTD | 400240003 | HDFC0000001 | 423423423432432 | SB   |  |
| 14167AZA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 1 | SB   |  |
| 14167AZA01 | 065  | ABHYUDAYA CO-OP BANK | 400065002 | ABHY0065002 | 654321 | SB   |  |
| 14188AMA06 | 211  | AXIS BANK LTD | 411211017 | UTIB0000862 | 2345606266 | SNRA |  |
| 14188AMA06 | 229  | ICICI BANK LTD | 560229011 | ICIC0006252 | 4001234241 | FCNR |  |
| 14188AMA06 | 240  | HDFC BANK LTD | 560240056 | HDFC0001746 | 3001245360 | SNRR |  |
| 14188BAA01 | 211  | AXIS BANK LTD | 411211017 | UTIB0000862 | 3025255555 | SB   |  |
| 14188BAA01 | 240  | HDFC BANK LTD | 403240020 | HDFC0001221 | 234564621313 | SB   |  |
| 14188BAA01 | 240  | HDFC BANK LTD | 825240102 | HDFC0001742 | 25302525555 | CA   |  |
| 14189AMA02 | 229  | ICICI BANK LTD | 411229017 | ICIC0006450 | 1234567896 | NRE  |  |
| 14189AMA02 | 229  | ICICI BANK LTD | 570229003 | ICIC0006255 | 1234567897 | NRE  |  |
| 14189AMA02 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 1234567895 | NRE  |  |
| 14189BAA01 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 12345 | SB   |  |
| 14189BAA04 | 229  | ICICI BANK LTD | 411229017 | ICIC0006450 | 123789 | SB   |  |
| 14189BAA04 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 12346789 | SB   |  |
| 14189BAA05 | 065  | ABHYUDAYA CO-OP BANK | 400065002 | ABHY0065002 | 1122334455 | SB   |  |
| 14189BIA02 | 229  | ICICI BANK LTD | 695229002 | ICIC0006262 | 1234567888 | NRE  |  |
| 14189BIA02 | 229  | ICICI BANK LTD | 560229009 | ICIC0006254 | 1234567896 | NRE  |  |
| 14189BIA02 | 229  | ICICI BANK LTD | 800229001 | ICIC0006259 | 9999999992 | NRE  |  |
| 14189BIA02 | 229  | ICICI BANK LTD | 800229001 | ICIC0006259 | 9999999993 | NRE  |  |
| 14189BIA02 | 229  | ICICI BANK LTD | 411229017 | ICIC0006450 | 9999999994 | NRE  |  |
| 14189BIA02 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 8888888881 | NRE  |  |
| 14189BIA02 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 9999999991 | NRE  |  |
| 14190BAA01 | 229  | ICICI BANK LTD | 411229017 | ICIC0006450 | 0208 | SB   |  |
| 14190BAA01 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 0208 | CA   |  |
| 14190BEA01 | 065  | ABHYUDAYA CO-OP BANK | 400065002 | ABHY0065002 | 3453245 | SB   |  |
| 14190BIA01 | 240  | HDFC BANK LTD | 560240056 | HDFC0001746 | 0208 | SB   |  |
| 14195AZA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 1234 | SB   |  |
| 14213AJA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 1111 | CLSB |  |
| 14213AJA01 | 065  | ABHYUDAYA CO-OP BANK | 400065013 | ABHY0065013 | 88888 | SB   |  |
| 14213AMA01 | 065  | ABHYUDAYA CO-OP BANK | 400065010 | ABHY0065010 | 123456 | SB   |  |
| 16056BAA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 12345678 | SB   |  |
| 16056BAA01 | 240  | HDFC BANK LTD | 142240006 | HDFC0002893 | 23456789 | SB   |  |
| 16056BAA02 | 019  | INDIAN BANK | 110019003 | IDIB000D008 | 3456789012 | OD   |  |
| 16056BAA02 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 123456899 | SB   |  |
| 14163BEA01 | 485  | KOTAK MAHINDRA BANK LTD | 411485017 | KKBK0001756 | 9711610515 | SB   |  |
| 14163BEA01 | 222  | A.P. VARDHAMAN (MAHILA) CO-OP BANK LTD | 500222009 | HDFC0CVB009 | 1234567 | SB   |  |
| 14163BEA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 123450000000001 | CC   |  |
| 14163BEA01 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 123456 | OTH  |  |
| 14163BEA01 | 240  | HDFC BANK LTD | 110240001 | HDFC0000003 | 1234562 | SB   |  |
| 14163BEA01 | 072  | DEVELOPMENT CREDIT BANK | 110072003 | DCBL0000062 | 1234561 | PSB  |  |
| 14163BEA01 | 240  | HDFC BANK LTD | 110240013 | HDFC0000093 | 78896846540101 | SB   |  |
| 14163BEA01 | 211  | AXIS BANK LTD | 636211999 | UTIB0000716 | 1234567890 | SB   |  |
| 14163BEA01 | 229  | ICICI BANK LTD | 600229024 | ICIC0000275 | 027501536864 | SB   |  |
| 14157AZA01 | 532  | YES BANK LTD | 600532002 | YESB0000005 | 012345 | SB   |  |
| 14163BEA01 | 532  | YES BANK LTD | 635532302 | YESB0000293 | 1234567890 | SB   |  |
| 14157AZA01 | 240  | HDFC BANK LTD | 400240035 | HDFC0000182 | 01821160000169 | SB   |  |
| 14157AZA01 | 240  | HDFC BANK LTD | 110240002 | HDFC0000011 | 123456 | SB   |  |
| 14157AZA01 | 036  | STANDARD CHARTERED BANK | 110036002 | SCBL0036020 | 12345 | SB   |  |
| 14157AKA02 | 485  | KOTAK MAHINDRA BANK LTD | 411485017 | KKBK0001756 | 9711610515 | PSB  |  |
| 14157AZA01 | 532  | YES BANK LTD | 110532002 | YESB0000003 | 124551 | SB   |  |
| 14157AZA01 | 532  | YES BANK LTD | 110532002 | YESB0000003 | 38374922 | SB   |  |
| 14157AZA01 | 532  | YES BANK LTD | 110532002 | YESB0000003 | 2345673 | CA   |  |
| 14157AZA01 | 532  | YES BANK LTD | 110532003 | YESB0000002 | 7342342 | CA   |  |
| 14157AZA01 | 532  | YES BANK LTD | 110532003 | YESB0000002 | 4534562 | CA   |  |
| 14157AZA01 | 532  | YES BANK LTD | 110532002 | YESB0000003 | 4221233 | SB   |  |
| 14157AZA01 | 532  | YES BANK LTD | 110532002 | YESB0000003 | 634277 | CA   |  |
| 14157AZA01 | 532  | YES BANK LTD | 110532002 | YESB0000003 | 8327344 | CA   |  |
| 14157AZA01 | 532  | YES BANK LTD | 110532002 | YESB0000003 | 95674565 | SB   |  |
| 14157AKA01 | 229  | ICICI BANK LTD | 395229042 | ICIC0007506 | 750601500069 | SB   |  |
| 14157AZA01 | 532  | YES BANK LTD | 799532002 | YESB0000155 | 025199000006066 | SB   |  |
| 14157AZA01 | 532  | YES BANK LTD | 799532002 | YESB0000155 | 025199000006067 | SB   |  |

#### Joint CAN Bank(s)

#### Table 2

Source cells: `A110:G144`

| CAN ID | Bank ID | Bank Name | MICR | IFSC | Account No | Account Type |
| --- | --- | --- | --- | --- | --- | --- |
| 14163AKA01 | 065  | ABHYUDAYA CO-OP BANK | 400065013 | ABHY0065013 | 1234 | SB   |
| 14175AYA05 | 240  | HDFC BANK LTD | 560240056 | HDFC0001746 | 0005019602577 | SB   |
| 14188AMA06 | 211  | AXIS BANK LTD | 411211017 | UTIB0000862 | 2345606266 | SNRA |
| 14188AMA06 | 229  | ICICI BANK LTD | 560229011 | ICIC0006252 | 4001234241 | FCNR |
| 14188AMA06 | 240  | HDFC BANK LTD | 560240056 | HDFC0001746 | 3001245360 | SNRR |
| 14189AMA02 | 229  | ICICI BANK LTD | 411229017 | ICIC0006450 | 1234567896 | NRE  |
| 14189AMA02 | 229  | ICICI BANK LTD | 570229003 | ICIC0006255 | 1234567897 | NRE  |
| 14189AMA02 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 1234567895 | NRE  |
| 14206BAA01 | 013  | BANK OF INDIA | 400013099 | BKID0000105 | 1604 | SB   |
| 14206BAA01 | 013  | BANK OF INDIA | 523013002 | BKID0005610 | 1911 | SB   |
| 14206BAA01 | 014  | BANK OF MAHARASHTRA | 400014013 | MAHB0000119 | 0508 | SB   |
| 14206BAA01 | 015  | CANARA BANK | 452015011 | CNRB0003199 | 001 | SB   |
| 14206BAA01 | 015  | CANARA BANK | 695015026 | CNRB0002968 | 0208 | SB   |
| 14206BAA01 | 015  | CANARA BANK | 400015028 | CNRB0000129 | 1604 | SB   |
| 14206BAA01 | 016  | CENTRAL BANK OF INDIA | 400016018 | CBIN0280600 | 0508 | SB   |
| 14206BAA01 | 018  | DENA BANK | 390018012 | BKDN0210559 | 1805 | SB   |
| 14206BAA01 | 027  | UNITED BANK OF INDIA | 700027154 | UTBI0MAYA30 | 3108 | SB   |
| 14206BAA01 | 027  | UNITED BANK OF INDIA | 000000000 | UTBI0AHP273 | A001 | SB   |
| 14206BAA01 | 065  | ABHYUDAYA CO-OP BANK | 400065013 | ABHY0065013 | 1805 | SB   |
| 14206BAA01 | 146  | KARNATAKA STATE CO-OP APEX BANK LTD,BANGLORE | 560226001 | KSCB0000001 | 0208 | SB   |
| 14206BAA01 | 211  | AXIS BANK LTD | 400211012 | UTIB0000063 | 0208 | SB   |
| 14206BAA01 | 229  | ICICI BANK LTD | 560229009 | ICIC0006254 | 008 | SB   |
| 14206BAA01 | 229  | ICICI BANK LTD | 411229017 | ICIC0006450 | 3108 | SB   |
| 14206BAA01 | 240  | HDFC BANK LTD | 403240020 | HDFC0001221 | 006 | SB   |
| 14206BAA01 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 1911 | SB   |
| 14206BAA01 | 269  | ABU DHABI COMMERCIAL BANK | 560269002 | ADCB0000002 | 11 | SB   |
| 14216BAA02 | 229  | ICICI BANK LTD | 560229009 | ICIC0006254 | 0121110251251 | SB   |
| 14216BAA02 | 229  | ICICI BANK LTD | 411229017 | ICIC0006450 | 121400012542 | SB   |
| 14231AZA09 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 45325 | CA   |
| 14231AZA09 | 211  | AXIS BANK LTD | 683211052 | UTIB0000803 | 0035647888999 | SB   |
| 14231AZA09 | 229  | ICICI BANK LTD | 800229001 | ICIC0006259 | 00124512162535 | SB   |
| 14238BAA02 | 229  | ICICI BANK LTD | 388229120 | ICIC0000085 | 3512253131 | SB   |
| 14238BAA02 | 229  | ICICI BANK LTD | 411229017 | ICIC0006450 | 987654321 | SB   |
| 14238BAA02 | 240  | HDFC BANK LTD | 143240503 | HDFC0001369 | 987654 | CA   |

#### CAN PayEezz Samples

#### Table 3

Source cells: `A160:G160`

| CAN ID | Bank ID | Bank Name | MICR | IFSC | Account No | Account Type |
| --- | --- | --- | --- | --- | --- | --- |

### PayEezz

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `PayEezz`

#### Table 1

Source cells: `A1:R15`

| RequestType | RequestMode | CAN | MMRN | Column E | PRN | AccountType | AccountNo | Bank ID | BankName | MICR NO | IFSC CODE | MaxAmount | PerpetualFlag | PRNStartDate | PRNEndDate | Registration Status | Aggregator Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Registration | SIP | 14157AZA01 | 14157AZA01000559     | Single  | TRIS00101            | SB   | 12345 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 50005.0000 | Y | 2016-05-30 | 3000-12-31 | PA | AK |
| Registration | SIP | 14157AZA01 | 14157AZA01000560     | Single  | TRIS00102            | SB   | 50200013404502 | 240  | HDFC BANK LTD | 110240012 | HDFC0000090 | 7000.0000 | Y | 2016-05-30 | 3000-12-31 | PA | AK |
| Registration | SIP | 14163BEA01 | 14163BEA01000905     | Single  | TRIT1234             | SB   | 123456 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 20000.0000 | Y | 2016-04-18 | 3000-12-31 | PA | AK |
| Registration | SIP | 14163BEA01 | 14163BEA01000980     | Single  | TRID0001             | SB   | 123456 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 6001.0000 | Y | 2016-05-17 | 3000-12-31 | PA | AK |
| Registration | SIP | 14163BEA01 | 14163BEA01001021     | Single  | TRIS00104            | SB   | 123456 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 6000.0000 | Y | 2016-05-30 | 3000-12-31 | PA | AK |
| Registration | NCT | 14157AZA01 | 14496610622890579A7C | Single  | TRI8888              | SB   | 1213 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 4000.0000 | Y | 2015-12-09 | 3000-12-31 | PA | AK |
| Registration | NCT | 14157AKA03 | 1501223187119615A4AC | Single  | RIAPayEezz017        | SB   | 987654321 | 065  | ABHYUDAYA CO-OP BANK | 400065002 | ABHY0065002 | 55000.0000 | Y | 2017-07-28 | 3000-12-31 | PA | AK |
| Registration | NCT | 14163BEA01 | 1510031136124308192  | Single  | TRI00010             | SB   | 123456 | 240  | HDFC BANK LTD | 110240140 | HDFC0001220 | 5000.0000 | Y | 2015-10-03 | 3000-12-31 | PA | AK |
| Registration | NCT | 14157AZA01 | 1510261231437073279  | Single  | TRI00050             | SB   | 1213 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 6000.0000 | Y | 2015-10-26 | 3000-12-31 | PA | AK |
| Registration | NCT | 14157AZA01 | 1510281221204760364  | Single  | Tri00062             | SB   | 1213 | 027  | UNITED BANK OF INDIA | 123456789 | UTBI0BEC135 | 20000.0000 | Y | 2015-10-28 | 3000-12-31 | PA | AK |
| Registration | CAN | 15309BAA01 | 1511051536363409490  | Single  | CBIN0000000000098483 | SB   | 12345 | 016  | CENTRAL BANK OF INDIA | 400016018 | CBIN0280600 | 5000.0000 | Y | 2015-11-05 | 3000-12-31 | PA | AK |
| Registration | NCT | 14167AZA01 | 15669912891834F07846 | Single  | PRNUAT001            | SB   | 654321 | 065  | ABHYUDAYA CO-OP BANK | 400065002 | ABHY0065002 | 500000.0000 | Y | 2019-08-28 | 3000-12-31 | PA | AK |
| Registration | NCT | 14157AKA03 | 1501223187119615A4AC | Single  | RIAPayEezz017        | SB   | 987654321 | 065  | ABHYUDAYA CO-OP BANK | 400065002 | ABHY0065002 | 55000.0000 | Y | 2017-07-28 | 3000-12-31 | PA | AK |
| Registration | NCT | 14167AZA01 | 15669912891834F07846 | Single  | PRNUAT001            | SB   | 654321 | 065  | ABHYUDAYA CO-OP BANK | 400065002 | ABHY0065002 | 500000.0000 | Y | 2019-08-28 | 3000-12-31 | PA | AK |

### ARN-RIA-Master

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `ARN-RIA-Master`

#### Table 1

Source cells: `A1:D42`

| ARN/RIA<br>Code | Entity<br>Name | EUIN<br>Code | EUIN Name |
| --- | --- | --- | --- |
| ARN-0005 | HDFC Bank Limited | E000354 | Abhishek j Vohra   |
| ARN-0005 | HDFC Bank Limited | E000356 | Husain Abbas Mahuvawala   |
| ARN-0005 | HDFC Bank Limited | E000389 | Harish Sharma   |
| ARN-0005 | HDFC Bank Limited | E000396 | Santanu Sisir Mitra   |
| ARN-0005 | HDFC Bank Limited | E000415 | Sarika Arya   |
| ARN-0005 | HDFC Bank Limited | E000417 | Garima Singh   |
| ARN-0002 | JM Financial Services Limited | E000037 | Maulik A Shah   |
| ARN-0002 | JM Financial Services Limited | E000053 | Vivek Newar   |
| ARN-0002 | JM Financial Services Limited | E000075 | Swapnil Shrikant Joshi   |
| ARN-0002 | JM Financial Services Limited | E000088 | G Mallesh   |
| ARN-0002 | JM Financial Services Limited | E000099 | Anand G. Shirke   |
| ARN-0019 | Axis Bank Limited | E005221 | Ravi Mohan Srivastava   |
| ARN-0019 | Axis Bank Limited | E005997 | Upender Sharma   |
| ARN-0019 | Axis Bank Limited | E006178 | Rohen Brahmleenkumar Gandhi   |
| ARN-0019 | Axis Bank Limited | E006247 | Samir Ramesh Trivedi   |
| ARN-0845 | ICICI Securities Limited | E003511 | Sayak Chakrabarti   |
| ARN-0845 | ICICI Securities Limited | E005244 | Preenu Mathew   |
| ARN-0845 | ICICI Securities Limited | E005710 | Pankaj Patwardhan   |
| ARN-0845 | ICICI Securities Limited | E012043 | Vikrant Mahajan   |
| ARN-0845 | ICICI Web Trade | E012204 | Ajay Khasgiwal   |
| ARN-0845 | ICICI Securities Limited | E003511 | Sayak Chakrabarti   |
| ARN-0845 | ICICI Securities Limited | E005244 | Preenu Mathew   |
| ARN-0845 | ICICI Securities Limited | E005710 | Pankaj Patwardhan   |
| ARN-0845 | ICICI Securities Limited | E012043 | Vikrant Mahajan   |
| ARN-0477 | Kishor N Bhanushali | E030845 | Kishor N Bhanushali   |
| ARN-0478 | Paresh A Shah | E030846 | Paresh A Shah   |
| ARN-0479 | Satish Sitaram Gade | E030847 | Satish Sitaram Gade   |
| ARN-0483 | K K Sudhakaran | E030848 | K K Sudhakaran   |
| ARN-0485 | Krishnamurari S Bhimrajka | E030850 | Krishnamurari S Bhimrajka   |
| ARN-0490 | Shankerlal R Fatnani | E030852 | Shankerlal R Fatnani   |
| ARN-0492 | Anil B Parikh | E030853 | Anil B Parikh   |
| ARN-0493 | Mahesh G Gattani | E030854 | Mahesh G Gattani   |
| ARN-0496 | Manju Poddar | E030856 | Manju K Poddar   |
| ARN-0497 | Atul J Tolia | E030857 | Atul J Tolia   |
| INA100000001 | Expowealth Technologies |  |  |
| INA100000002 | ACEVESTOR |  |  |
| INA000000007 | tridentria7 |  |  |
| INA000000680 | Quantum Information Services Private Limited |  |  |
| INA100000003 | Cumulus Consulting Services Private Limited |  |  |
| INATRIA00002 | TridentRIA7 |  |  |
| INA123242342 | Eastern Financiers Ltd.t |  |  |

### ARN-EUIN-Master

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `ARN-EUIN-Master`

#### Table 1

Source cells: `A1:E13`

| Tax | ARN | ARN | EUIN | EUIN |
| --- | --- | --- | --- | --- |
| Status | Code | Name |  | Name |
| Individual | ARN-5001 | A. Rajagopalan | E032984 | A. Rajagopalan   |
| Individual | ARN-6001 | Virendra Kumar Arya | E033498 | Virendra Kumar Arya   |
| Company | ARN-6091 | Indexarb Securities (Pvt) Ltd | E019966 | Mukund T.Bhammer   |
| Individual | ARN-7004 | Md. Ayub Alam | E109898 | Md. Ayub Alam   |
| Individual | ARN-7005 | Papia Alam | E109632 | Papia Alam   |
| Individual | ARN-7006 | Pradeep Kumar Verma | E074820 | Pradeep Kumar Verma   |
| Company | ARN-7007 | Three Cheers | E075988 | Sangeeta Vaidyanathan   |
| Individual | ARN-8001 | Pavan Manikchand Shah | E034671 | Pavan Manikchand Shah   |
| Company | ARN-0137 | DSFS Advisory Services (P) Ltd | E029341 | Nilesh Ajitbhai Rana   |
| Company | ARN-0137 | DSFS Advisory Services (P) Ltd | E030499 | Joshi Bhavin J   |
| Company | ARN-0137 | DSFS Advisory Services (P) Ltd | E098784 | Ajay Bharatkumar Patel   |

###  Bank Master

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: ` Bank Master`

#### Table 1

Source cells: `A1:B440`

| Bank<br>ID | Bank<br>Name |
| --- | --- |
| 001  | RESERVE BANK OF INDIA |
| 002  | STATE BANK OF INDIA |
| 003  | STATE BANK OF BIKANER AND JAIPUR |
| 004  | STATE BANK OF HYDERABAD |
| 005  | STATE BANK OF INDORE |
| 006  | STATE BANK OF MYSORE |
| 007  | STATE BANK OF PATIALA |
| 009  | STATE BANK OF TRAVANCORE |
| 010  | ALLAHABAD BANK |
| 011  | ANDHRA BANK |
| 012  | BANK OF BARODA |
| 013  | BANK OF INDIA |
| 014  | BANK OF MAHARASHTRA |
| 015  | CANARA BANK |
| 016  | CENTRAL BANK OF INDIA |
| 017  | CORPORATION BANK |
| 018  | DENA BANK |
| 019  | INDIAN BANK |
| 020  | INDIAN OVERSEAS BANK |
| 022  | ORIENTAL BANK OF COMMERCE |
| 023  | PUNJAB AND SIND BANK |
| 024  | PUNJAB NATIONAL BANK |
| 025  | SYNDICATE BANK |
| 026  | UNION BANK OF INDIA |
| 027  | UNITED BANK OF INDIA |
| 028  | UCO BANK |
| 029  | VIJAYA BANK |
| 030  | THE ROYAL BANK OF SCOTLAND N V |
| 032  | BANK OF AMERICA |
| 033  | BANK OF TOKYO MITSUBISHI LIMITED |
| 034  | B N P PARIBAS |
| 036  | STANDARD CHARTERED BANK |
| 037  | CITI BANK |
| 039  | HSBC BANK |
| 047  | CATHOLIC SYRIAN BANK LIMITED |
| 048  | DHANALAKSHMI BANK LIMITED |
| 049  | FEDERAL BANK LIMITED |
| 051  | JAMMU AND KASHMIR BANK LIMITED |
| 052  | KARNATAKA BANK LIMITED |
| 053  | KARUR VYSYA BANK LIMITED |
| 054  | CITY UNION BANK |
| 056  | LAKSHMI VILAS BANK LIMITED |
| 059  | SOUTH INDIAN BANK LIMITED |
| 060  | TAMILNADU MERCANTILE BANK LIMITED |
| 064  | ING VYSYA BANK LIMITED |
| 065  | ABHYUDAYA COOPERATIVE BANK LIMITED |
| 066  | THE AHMEDABAD MERCANTILE CO-OPERATIVE BANK LIMITED |
| 068  | THE MUMBAI DISTRICT CENTRAL COOPERATIVE BANK LIMITED |
| 069  | Bombay Mercantile Co-operative Bank Ltd |
| 071  | THE DECCAN MERCHANTS CO-OP BANK LTD. |
| 072  | DEVELOPMENT CREDIT BANK |
| 073  | The Jain Sahakari Bank Ltd |
| 074  | JANATA SAHAKARI BANK LIMITED |
| 075  | KONKAN MERCANTILE BANK |
| 076  | THE KAPOL COOPERATIVE BANK LIMITED |
| 077  | THE KURLA NAGARIK SAHAKARI BANK LTD |
| 079  | The Malad Sahakari Bank Ltd. |
| 082  | MAHARASHTRA STATE CO OPERATIVE BANK |
| 084  | MOGAVEERA BANK |
| 085  | NEW  INDIA CO-OPERATIVE  BANK  LIMITED |
| 086  | NKGSB COOPERATIVE BANK LIMITED |
| 087  | SAHYADRI SAH. BANK LTD,BOMBAY |
| 088  | SARASWAT COOPERATIVE BANK LIMITED |
| 089  | THE SHAMRAO VITHAL COOPERATIVE BANK |
| 091  | THE TAMIL NADU STATE APEX COOPERATIVE BANK |
| 092  | CHENNAI CENTRAL CO-OPERATIVE BANK LTD |
| 093  | THE WEST BENGAL STATE COOPERATIVE BANK |
| 094  | THE DELHI STATE COOPERATIVE BANK LIMITED |
| 095  | THE GREATER BOMBAY COOPERATIVE BANK LIMITED |
| 096  | MAHANAGAR COOPERATIVE BANK |
| 098  | APNA SAHAKARI BANK LIMITED |
| 103  | LILUAH CO-OPERATIVE BANK LTD |
| 105  | JANAKALYAN SAHAKARI BANK LIMITED |
| 107  | THE SATARA SAHAKARI BANK LTD,BOMBAY |
| 108  |  Excellent Co-Op. Bank Ltd |
| 109  | THANE JANATA SAHAKARI BANK LIMITED |
| 110  | THE MUNCIPAL CO-OP BANK LIMITED,BOMBAY |
| 111  | CHIEF POSTMASTER GPO |
| 112  | THE BHARAT CO-OP BANK LIMITED |
| 115  | The Co-operative City Bank Ltd |
| 118  | THE Mehsana Nagrik Sahakari Bank Ltd. |
| 124  | THE KARNAVATI CO OP BANK LTD |
| 126  | THE KALUPUR COMMERCIAL CO. OP. BANK LIMITED. |
| 128  | NUTAN NAGARIK SAHAKARI BANK LIMITED |
| 130  | The Social Co-operative Bank Ltd |
| 131  | TEXTILE TRADERS CO-OP BANK LTD. |
| 132  | VIJAY COOPERATIVE BANK LTD |
| 134  | The Bhagyodaya Co-operative Bank Ltd |
| 135  | The Sarangpur Co-op Bank Ltd |
| 136  | The Union Co-operative Bank Ltd |
| 138  | Colour Merchants Co-operative Bank Ltd |
| 139  | The Navnirman Co-op. Bank Ltd |
| 141  | Progressive Mercantile Co-op Bank Ltd |
| 142  | THE A.P. MAHESH COOPERATIVE URBAN BANK LIMITED |
| 143  | THE ANDHRA PRADESH STATE COOPERATIVE BANK LIMITED |
| 149  | PATAN CO-OPERATIVE BANK |
| 150  | BANK OF BAHRAIN AND KUWAIT |
| 153  | The Baroda Central Co-operative Bank Ltd |
| 156  | The Baroda City Co-operative Bank Ltd |
| 160  | SHREE VARDHAMAN SAHAKARI BANK LTD |
| 164  | THE COSMOS CO-OPERATIVE BANK LIMITED |
| 167  | Pune Merchants Co-op Bank Ltd |
| 168  | PUNE PEOPLE s CO-OP Bank Ltd. |
| 171  | Vidya Sahakari Bank Ltd |
| 172  | POST OFFICE SAVINGS BANK |
| 174  | PAVANA SAHAKARI BANK LTD PUNE |
| 175  | MAHESH SAHAKARI BANK LTD PUNE |
| 176  | THE RATNAKAR BANK LIMITED |
| 182  | SHIKSHAK SAHAKARI BANK LTD NAGPUR |
| 183  | NAGPUR NAGARIK SAHAKARI BANK LIMITED |
| 184  | THE NAINITAL BANK LIMITED |
| 190  | THE RAJASTHAN STATE COOPERATIVE BANK LIMITED |
| 192  | Fingrowth Co-operative Bank Ltd |
| 195  | THE VAISH CO-OPERATIVE NEW BANK LTD |
| 196  | Delhi Nagrik Sehkari Bank Ltd. |
| 200  | DEUTSCHE BANK |
| 202  | Pragati Sahakari Bank Ltd |
| 208  | THE VAISH CO-OPERATIVE ADARSH BANK LTD |
| 209  | CITIZEN CREDIT COOPERATIVE BANK LIMITED |
| 211  | AXIS BANK LIMITED |
| 215  | Saraspur Nagarik Co-op. Bank Ltd |
| 217  | Rajkot Nagarik Sahakari Bank Ltd |
| 225  | The Bangalore City Co-operative Bank Limited |
| 226  | THE KARANATAKA STATE COOPERATIVE APEX BANK LIMITED |
| 229  | ICICI BANK LIMITED |
| 234  | INDUSIND BANK LIMITED |
| 235  | DOMBIVLI NAGARI SAHAKARI BANK LIMITED |
| 238  | BASSEIN CATHOLIC COOPERATIVE BANK LIMITED |
| 239  | THE BANK OF NOVA SCOTIA |
| 240  | HDFC BANK LIMITED |
| 242  | The Panchsheel Mercantile Co-op Bank Ltd |
| 244  | THE SURAT DISTRICT COOPERATIVE BANK LIMITED |
| 245  | THE SURAT MERCANTILE CO-OP BANK LTD |
| 246  | Surat National Co-operative Bank Ltd |
| 248  | SUTEX COOPERATIVE BANK LIMITED |
| 249  | The Sarvodaya Sahakari Bank Ltd |
| 250  | PRIME COOPERATIVE BANK LIMITED |
| 251  | THE SURATH PEOPLES COOPERATIVE BANK LIMITED |
| 255  | INDRAPRASTHA SAH. BANK LTD |
| 256  | Sardar Vallabhbhai Sahakari Bank Ltd |
| 257  | JANASEVA SAHAKARI BANK LIMITED |
| 259  | IDBI BANK LIMITED |
| 269  | ABU DHABI COMMERCIAL BANK |
| 272  | Bhagini Nivedita Sahakari Bank Ltd Pune |
| 275  | The National Co-operative Bank Ltd |
| 278  | Indore Cloth Market Co-operative Bank Ltd. |
| 279  | Indore Paraspar Sahakari Bank Ltd |
| 280  | INDORE PREMIER CO OPERATIVE BANK LTD |
| 281  | M P Rajya Sahakari Bank Mydt. |
| 283  | NAGRIK SAHAKARI BANK LTD |
| 287  | Vyaparik Audhyogik Sahakari Bank Ltd |
| 289  | THE VARACHHA COOPERATIVE BANK LIMITED |
| 291  | SHIVAJIRAO BHOSALE SAHAKARI BANK LTD |
| 297  | The Citizens Urban Co-op Bank Ltd |
| 302  | The NARODA NAGRIK CO-OPERATIVE BANK LTD |
| 303  | KANKARIA MANINAGAR NAGRIK SAHAKARI BANK LTD |
| 304  | THE KANGRA COOPERATIVE BANK LIMITED |
| 305  | The Khattri Co-operative Urban Bank Ltd |
| 307  | Pune Urban Co-operative Bank Ltd. Pune |
| 308  | Jharneshwar Nagrik Sahakari Bank Maryadit |
| 309  | Bhopal Co-op Central Bank Ltd |
| 310  | SADGURU NAGRIK SAHAKARI BANK MYDT |
| 311  | The H P State Co-op Bank Ltd |
| 312  | G P PARSIK BANK |
| 313  | THE MEHSANA URBAN COOPERATIVE BANK |
| 314  | The City Co-operative Bank Ltd.,  |
| 315  | SHRI CHHANI NAGRIK SAHAKARI BANK LTD |
| 320  | M S Co-operative Bank Ltd |
| 322  | Alavi Co-operative Bank Ltd |
| 323  | UMA Co-Operative Bank Ltd. |
| 328  | PUNJAB AND MAHARSHTRA COOPERATIVE BANK |
| 329  | JAIN CO-OPERATIVE BANK LTD |
| 331  | BANK OF CEYLON |
| 332  | STATE BANK OF MAURITIUS LIMITED |
| 335  | THE VISHWESHWAR SAHAKARI BANK LIMITED |
| 344  | Tirupati Urban Co-operative Bank Ltd |
| 345  | THE ABHINAV SAHAKARI BANK LTD |
| 346  | The Haryana State Co-operative Apex Bank Ltd |
| 348  | RAJASTHAN MARUDHARA GRAMIN BANK |
| 349  | SAHEBRAO DESHMUKH COOPERATIVE BANK LIMITED |
| 350  | THE PUNJAB STATE COOPERATIVE BANK LIMITED |
| 351  | THE CHANDIGARH STATE CO-OPERATIVE BANK LTD |
| 352  | Suvarnayug Sahakari Bank Ltd |
| 353  | RAJARSHI SHAHU SAHAKARI BANK LTD |
| 355  | Bharati Sahakari Bank Limited |
| 358  | SHREE SHARADA SAHAKARI BANK LTD |
| 361  | THE JANTA CO OPERATIVE BANK LTD |
| 363  | KRISHNA MERCANTILE COOP BANK LTD |
| 364  | AKOLA JANATA COMMERCIAL COOPERATIVE BANK |
| 367  | THE KALYAN JANATA SAHAKARI BANK LIMITED |
| 369  | THE NASIK MERCHANTS COOPERATIVE BANK LIMITED |
| 372  | Nasik District Central Co-op Bank Ltd Nasik |
| 373  | The Janalaxmi Co-operative Bank Ltd |
| 374  | The Nasik Road Deolali Vyapari Sahakari Bank Ltd |
| 375  | SHREE SAMARTH SAHAKARI BANK LTD |
| 376  | Godavari Urban Co-op Bank Ltd |
| 386  | KALLAPPANNA AWADE ICHALKARANJI JANATA SAHAKARI BANK LIMITED |
| 387  | KOLHAPUR DISTRICT CENTRAL CO-OPERATIVE BANK LTD. |
| 389  | Shri Mahalaxmi Co-op Bank Ltd |
| 390  | State Transport Co-operative Bank Ltd |
| 393  | Youth Development Co-op Bank |
| 394  | THE AJARA URBAN CO-OP BANK LTD |
| 397  | SHREE WARANA SAHAKARI BANK LTD |
| 398  | THE KOLHAPUR URBAN CO-OP BANK LTD |
| 401  | KOLHAPUR MAHILA SAHAKARI BANK LTD |
| 402  | SHRI PANCHGANGA NAGARI SAHKARI BANK LTD |
| 403  | DR ANNASAHEB CHOWGULE URBAN CO-OP BANK LTD |
| 404  | The Gadhinglaj Urban Co-op Bank Ltd |
| 407  | SHRI VEERSHAIV CO-OP BANK LTD KOLHAPUR |
| 408  | THE COMMERCIAL CO-OP BANK LTD |
| 409  | The National Co-op Bank Ltd |
| 412  | THE SEVA VIKAS COOPERATIVE BANK LIMITED |
| 413  | THE BICHOLIM URBAN CO-OPERATIVE BANK LTD |
| 415  | THE GOA State CO-OP Bank Ltd. |
| 416  | The GOA Urban Co-Operative Bank Ltd. |
| 417  | THE MADGAUM URBAN CO-OPERATIVE BANK LTD |
| 418  | The Mapusa Urban Co-Op. Bank of GOA Ltd. |
| 420  | APNI SAHAKARI BANK LIMITED |
| 421  | The Bavla Nagrik Sahakari Bank Ltd |
| 422  | The United Co-op Bank Ltd |
| 424  | RAJDHANI NAGAR SAHKARI BANK LTD |
| 434  | The Kukarwada Nagarik Sahakari Bank Ltd |
| 441  | The Co-operative Bank of Rajkot Ltd |
| 443  | JIVAN COMMERCIAL CO-OP BANK LTD |
| 445  | Rajkot Peoples Co-operative Bank Ltd |
| 448  | GRAMIN BANK OF ARYAVART |
| 454  | Baroda Uttar Pradesh Gramin Bank |
| 459  | BARODA GUJARAT GRAMIN BANK |
| 460  | NORTH MALABAR GRAMIN BANK,CANNANORE |
| 465  | Shree Laxmi Co-op Bank Ltd |
| 470  | NAGRIK SAHAKARI BANK MARYADIT GWALIOR |
| 472  | The Veraval Mercantile Co-op Bank Ltd |
| 473  | The Rajkot Commercial Co-op Bank Ltd |
| 474  | Shree Rajkot District Co-op Bank Ltd |
| 480  | Kerala Gramin Bank |
| 483  | KARNATAKA VIKAS GRAMEENA BANK |
| 485  | KOTAK MAHINDRA BANK LIMITED |
| 486  | Kashi Gomti Samyut Gramin Bank |
| 488  | THE KARAD URBAN COOPERATIVE BANK LIMITED |
| 491  | C G RAJYA SAHAKARI BANK MYDT |
| 493  | Laxmi Mahila Nagrik Sahakari Bank Maryadit |
| 495  | Vyavsaik Sahakari Bank |
| 497  | Laxmibai Mahila Nagarik Sahakari Bank Mydt |
| 500  | JP MORGAN BANK |
| 502  | THE BUSINESS CO-OP BANK LTD |
| 503  | JANKALYAN CO-OP BANK LTD |
| 504  | VISHWAS CO-OP BANK LTD |
| 507  | JALGAON JANATA SAHAKARI BANK LIMITED |
| 508  | Shree Mahesh Co-op Bank Ltd Nashik |
| 512  | Central Madhya Pradesh Gramin Bank |
| 513  | RAJLAXMI URBAN CO-OPERATIVE BANK LTD |
| 514  | Jodhpur Nagrik Sahakari Bank Ltd |
| 521  | CHHATTISGARH GRAMIN BANK |
| 522  | JILA SAHAKARI KENDRIYA BANK MARYADIT-RAIPUR |
| 524  | THE THANE DISTRICT CENTRAL COOPERATIVE BANK LIMITED |
| 525  | THE THANE BHARAT SAHAKARI BANK LIMITED |
| 532  | YES BANK LIMITED |
| 544  | UTTARAKHAND GRAMIN BANK |
| 545  | CAPITAL SMALL FINANCE BANK LTD |
| 554  | Uttarakhand State Co-Op Bank Ltd |
| 561  | The Malkapur Urban Co-op Bank Ltd |
| 562  | Jila Sahakari Kendriya Bank Maryadit, Bilaspur |
| 564  | SUNDARLAL SAWJI URBAN CO-OP. BANK LTD, JINTUR |
| 570  | MAHARASHTRA GRAMIN BANK |
| 574  | TUMKUR GRAIN MERCHANTS COOPERATIVE BANK LIMITED |
| 582  | DEOGIRI NAGARI SAHAKARI BANK LTD. |
| 583  | SUBHADRA LOCAL AREA BANK LTD |
| 584  | Rajarambapu Sahakari Bank Ltd |
| 587  | SOLAPUR JANATA SAHAKARI BANK LIMITED |
| 597  | SAMARTH SAHAKARI BANK LTD. |
| 604  | LOKMANGAL CO-OP BANK LTD |
| 606  | The Baramati Sahakari Bank Ltd |
| 608  | SOCIETE GENERALE |
| 615  | Shree Bhavnagar Nagrik Sahakari Bank Ltd |
| 619  | Dena Gujarat Gramin Bank |
| 621  | The Nawanagar Co-operative Bank Ltd |
| 622  | PARSHWANATH CO-OP BANK LTD |
| 639  | THE CITIZEN CO-OPERATIVE BANK LTD |
| 641  | DBS Bank Ltd |
| 647  | Baroda Rajasthan Kshetriya Gramin Bank |
| 653  | Narmada Jhabua Gramin Bank |
| 658  | BARCLAYS BANK PLC |
| 659  | SHINHAN BANK |
| 662  | Saurashtra Gramin Bank |
| 693  | Zoroastrian Co-operative Bank Ltd |
| 694  | MIZUHO CORPORATE BANK LIMITED |
| 696  | Sarva Haryana Gramin Bank |
| 697  | PRAGATHI KRISHNA GRAMIN BANK |
| 699  | ALLAHABAD UP GRAMIN BANK |
| 703  | ANDHRA PRAGATHI GRAMEENA BANK |
| 706  | Odisha Gramya Bank |
| 723  | ZILA SAHAKRI BANK LIMITED GHAZIABAD |
| 725  | PURVANCHAL GRAMIN BANK |
| 733  | BHARATIYA MAHILA BANK LIMITED |
| 740  | THE JALGAON PEOPELS CO-OP BANK LTD |
| 746  | DOHA BANK |
| 750  | BANDHAN BANK |
| 751  | IDFC BANK |
| 756  | EQUITAS SMALL FINANCE BANK LIMITED |
| 761  | Ujjivan Small Finance Bank |
| 765  | AU SMALL FINANCE BANK |
| 800  | The Panipat Urban Co-op. Bank Ltd. |
| 801  | THE HINDUSTHAN CO-OP BANK LTD |
| 802  | Dattatraya Maharaj Kalambe Jaoli Sahakari Bank Ltd. |
| 803  | VASAI VIKAS SAHAKARI BANK LIMITED |
| 804  | Janaseva Sahakari Bank (Borivli) Ltd. |
| 805  | The Janata Co-op Bank Ltd- Godhra |
| 806  | The Chembur Nagarik Sahakari Bank Ltd |
| 807  | Model Co-operative Bank Ltd |
| 808  | The Dahod Urban Co-operative Bank Ltd |
| 809  | Amarnath Co-operative Bank Limited |
| 810  | The Vallabh Vidyanagar Commercial Co-op Bank Ltd |
| 811  | The Gandhinagar Nagarik Co-op Bank Ltd. |
| 812  | Poornawadi Nagarik Sahakari Bank M. Beed |
| 814  | Shri Mahila Sewa Sahakari Bank Ltd |
| 815  | THE CHOPDA PEOPLES CO-OP BANK LTD |
| 816  | The Kalol Nagarik Sahakari Bank Ltd |
| 822  | SARVA U.P. GRAMIN BANK |
| 823  | SHREE MAHAVIR SAHAKARI BANK LTD |
| 827  | The Urban Co-operative Bank Ltd |
| 828  | Himachal Pradesh Gramin Bank |
| 831  | THE AKOLA DISTRICT CENTRAL COOPERATIVE BANK |
| 835  | The Kottakkal Co-operative Urban Bank Ltd |
| 836  | THE JALGAON PEOPELS COOPERATIVE BANK LIMITED |
| 840  | SHRI CHHATRAPATI RAJASHRI SHAHU URBAN COOPERATIVE BANK LIMITED |
| 841  | Nagarik Sahakari Bank Maryadit Durg |
| 842  | GURGAON GRAMIN BANK LTD |
| 843  | PRATHAMA BANK |
| 846  | THE KURMANCHAL NAGAR SAHAKARI BANK LIMITED |
| 849  | ALMORA URBAN COOPERATIVE BANK LIMITED |
| 850  | THE KANGRA CENTRAL COOPERATIVE BANK LIMITED |
| 851  | SARVODAYA COMMERCIAL  CO-OP BANK LTD |
| 852  | GUJARAT AMBUJA CO-OP BANK LTD. |
| 861  | The Sangli District Central Co-op. Bank Ltd |
| 867  | The Shahada Peoples Co-operative Bank Limited |
| 876  | ACE CO-OPERATIVE BANK LTD |
| 877  | THE KAGAL CO-OP BANK LTD |
| 893  | The Niphad Urban Co-op Bank Ltd |
| 9001 | The Sonepat Urban Co-Op. Bank Ltd. |
| 9002 | THE AHMEDABAD DISTRICT CO-OP BANK LTD |
| 9003 | The Chembur Nagarik Sahakari Bank Limited |
| 9004 | GUARDIAN SOUHARDA SAHAKARI BANK NIYAMITA |
| 9005 | MARATHA SAHAKARI BANK LTD |
| 9006 | VIMA KAMGAR CO-OPERATIVE BANK LTD |
| 9007 | ACE CO-OPERATIVE BANK LTD |
| 9008 | FirstRand Bank Limited |
| 9009 | NAGARIK SAMABAY BANK LTD |
| 9010 | PRAGATI MAHILA NAGARIK SAHAKARI BANK LTD |
| 9011 | PALLAVAN GRAMA BANK |
| 9012 | UDYAM VIKAS SAHAKARI BANK LTD PUNE |
| 9013 | AHMEDNAGAR MERCHANTS CO-OP BANK LTD |
| 9014 | Sardar Bhiladwala Pardi Peoples Co-op Bank Ltd |
| 9015 | Model Co-op Bank Ltd |
| 9016 | The Uttarpara Co-operative Bank Ltd |
| 9017 | The Vijay Co-op Bank Ltd |
| 9018 | Vasai Janata Sahakari Bank Ltd |
| 9019 | Shri Arihant Co-operative Bank Ltd |
| 9020 | Ahmednagar Shahar Sahakari Bank Maryadit |
| 9021 | The Kaira District Central Co-op Bank Ltd |
| 9022 | Shri Mahila Sewa Sahakari Bank Ltd |
| 9023 | Sardargunj Mercantile Co-op Bank Ltd |
| 9024 | THE GANDHIDHAM MERCANTILE CO-OPERATIVE BANK LTD |
| 9025 | The Nav Jeevan Co-op Bank Ltd |
| 9026 | Ratnagiri District Central Co-op Bank Ltd |
| 9027 | The Makarpura Industrial Estate Co-op Bank Ltd |
| 9028 | The Gandevi Peoples Co-op Bank Ltd |
| 9029 | The Wai Urban Co-op Bank Ltd |
| 903  | THE ASTHA PEOPLES CO-OP BANK LTD |
| 9030 | DURGAPUR STEEL PEOPLES CO-OPERATIVE BANK LTD |
| 9031 | SHREE KADI NAGARIK SAHAKARI BANK LTD |
| 9032 | Chaitanya Godavari Grameena Bank |
| 9033 | The Sarvodaya Co-op Bank Ltd |
| 9035 | Jila Sahakari Kendriya Bank Maryadit, Raipur |
| 9036 | The Suvikas Peoples Co-operative Bank Ltd |
| 9037 | The Kunbi Sahakari Bank Ltd |
| 9038 | Kutch Co-operative Bank Ltd |
| 9039 | Sangli Sahakari Bank Ltd |
| 9040 | Shri D T Patil Co-operative Bank Ltd |
| 9041 | THE INCOME TAX DEPT. CO OP BANK LTD |
| 9042 | Amarnath Co-operative Bank Ltd |
| 9043 | GUJARAT MERCANTILE CO-OP BANK LTD |
| 9044 | DEFENCE ACCOUNTS CO-OPERATIVE BANK LTD |
| 9045 | The Valsad Mahila Nagrik Sahakari Bank Ltd |
| 9046 | The Akola Urban Co-operative Bank Ltd |
| 9047 | The Vita Merchants Co-operative Bank Ltd |
| 9048 | NAVSARJAN INDUSTRIAL CO OP BANK LTD |
| 9049 | LONAVALA SAHAKARI BANK LTD |
| 9050 | The Anand Mercantile Co-operative Bank Ltd |
| 9051 | SINDHUDURG CO-OPERATIVE BANK LTD. |
| 9052 | Jijamata Mahila Sahakari Bank Ltd |
| 9053 | The Saurashtra Co-Operative Bank Ltd |
| 9054 | The Bapunagar Mahila Co-op Bank Ltd |
| 9055 | The Gandhinagar Urban Co-op Bank Ltd |
| 9056 | The Honavar Urban Co-Operative Bank Ltd |
| 9057 | Sree Narayana Guru Co-operative Bank Ltd |
| 9058 | D Y Patil Sahakari Bank Ltd |
| 9059 | The Bhuj Commercial Co-operative Bank Limited |
| 9060 | Dapoli Urban Co-op Bank Ltd |
| 9061 | Nagar Urban Co-op Bank Ltd |
| 9062 | Pimpri Chinchwad Sahakari Bank Maryadit |
| 9063 | The Viramgam Mercantile Co-op Bank Ltd |
| 9064 | Nashik Zilha Sarkari and Parishad Karmachari Sahakari Bank Niyamit |
| 9065 | Nagarik Sahakari Bank Ltd Bhiwandi |
| 9066 | Sree Thyagaraja Co-operative Bank Ltd |
| 9067 | PUNE DISTRICT CENTRAL CO-OP BANK LTD |
| 9068 | The Raigad District Central Co-operative Bank Ltd |
| 9069 | ADARSH CO-OPERATIVE BANK LTD |
| 9070 | NIDHI CO-OP. BANK LIMITED |
| 9071 | Latur Urban Co-op Bank Ltd |
| 9072 | The Gujarat State Co-op Bank Ltd |
| 9073 | Sampada Sahakari Bank Ltd |
| 9074 | Mansing Co-operative Bank Ltd |
| 9075 | The Shirpur Peoples Co-op Bank Ltd |
| 9076 | The Khambhat Nagarik Sahakari Bank Ltd |
| 9077 | Andhra Pradesh Grameena Vikas Bank |
| 9078 | The Raddi Sahakara Bank Niyamitha |
| 9079 | Bhavnagar District Co-operative Bank Ltd |
| 9080 | Independence Co-op Bank Ltd |
| 9081 | The Kanara District Central Co-op Bank Ltd |
| 9082 | The Nandurbar Merchants Co-operative Bank Ltd |
| 9083 | SINDHUDURG DISTRICT CENTRAL CO OP BANK LTD |
| 9084 | The Sabarkantha District Central Co-op Bank Ltd |
| 9085 | The Guntur Co-operative Urban Bank Ltd |
| 9086 | JANATHA SEVA CO-OPERATIVE BANK LIMITED |
| 9087 | THE BHARUCH DISTRICT CENTRAL CO-OP BANK LTD |
| 9088 | The Nilambur Co-operative Urban Bank Ltd |
| 9089 | THE NAVAL DOCKYARD CO-OP BANK LTD |
| 9090 | Sihor Nagarik Sahakari Bank Ltd |
| 9091 | Ambarnath Jai-hind Co-op Bank Ltd |
| 9092 | ASTHA MAHILA NAGRIK SAHAKARI BANK |
| 9093 | KARNALA NAGARI SAHAKARI BANK LTD |
| 9094 | Vaishya Sahakari Bank Ltd |
| 9095 | The Veraval Peoples Co-op Bank Ltd |
| 9096 | Shree Gajanan Lokseva Sahakari Bank Maryadit |
| 9097 | The Satara District Central Co-operative Bank Ltd |
| 9098 | The Chiplun Urban Co-op Bank Ltd |
| 9099 | Pune Municipal Corporation Servants Co-op Urban Bank Ltd |
| 9100 | The Maharashtra Mantralaya And Allied Offices Co-op Bank Ltd |
| 9101 | Surguja Kshetriya Gramin Bank |

#### Table 2

Source cells: `A443:B2033`

| 008  | STATE BANK OF SAURASHTRA |
| --- | --- |
| 031  | AMERICAN EXPRESS BANK LTD |
| 035  | BRITISH BANK OF MIDDLE EAST |
| 038  | GRINDLAYS BANK |
| 040  | SUMITOMO MITSUI BANKING CORP.,BOMBAY |
| 041  | BANK OF MADURA LTD |
| 043  | BANK OF RAJASTHAN LTD |
| 044  | BHARAT OVERSEAS BANK LTD |
| 046  | BANK OF THANJAVAR LTD |
| 057  | NEDUNGADI BANK LTD |
| 058  | SANGLI BANK LTD |
| 062  | UNITED INDUSTRIAL BANK LTD |
| 063  | UNITED WESTERN BANK LTD |
| 067  | SHREE LABH CO-OP BANK LTD (ALEN CO-OP BANK LTD),BOMBAY |
| 070  | CO-OP BANK OF AHMEDABAD |
| 078  | MADHAVPURA MERCANTILE CO-OP BANK LTD,BOMBAY |
| 080  | MANDVI CO-OP BANK LTD,BOMBAY |
| 081  | METROPOLITAN CO-OP BANK LTD,BOMBAY |
| 083  | MEMON CO-OP BANK LTD,BOMBAY |
| 090  | SWASTIK JANATA SAH.BANK LTD,BOMBAY |
| 097  | BANK OF KARAD |
| 099  | SONALI BANK LTD,CALCUTTA |
| 100  | PURBANCHAL BANK LTD,CALCUTTA |
| 1000 | HARYANA KSHETRIYA GRAMEENA BANK LTD |
| 1001 | HAZARIBAGH KSHETRIYA GRAMIN BANK LIMITED |
| 1002 | HIMACHAL GRAMIN BANK |
| 1003 | HIMATNAGAR NAGARIK SAHAKARI BANK LTD |
| 1004 | HINGOLI PEOPLES CO-OP BANK |
| 1005 | HISAR SIRSA KSHETRIYA GRAMIN BANK |
| 1006 | HOSDURG SERVICE CO-OP BANK LTD |
| 1007 | HOSHIARPUR CENTRAL CO-OP BANK LIMITED |
| 1008 | THE HOTEL INDUSTRIALISTS COOP BANK LTD |
| 1009 | HOWRAH GRAMIN BANK |
| 101  | BANTRA CO-OP BANK LTD,CALCUTTA |
| 1010 | HUTATMA SAHAKARI BANK LIMITED |
| 1011 | I B M L |
| 1012 | I U K G BANK |
| 1013 | IDUKKI DISTRICT CO-OP BANK LTD |
| 1014 | ILAYANGUDI CO-OP URBAN BANK LTD |
| 1015 | INDORE UJJAIN KSHETRIYA GRAMIN BANK |
| 1016 | INVALID |
| 1017 | J D C C BANK LIMITED |
| 1018 | J J S B |
| 1019 | J V S L PROJECTS TORANAGALLU |
| 102  | PUNJAB CO-OP BANK LTD,DELHI |
| 1020 | JABALPUR MAHILA NAGRIK SAHAKARI BANK LTD |
| 1021 | JAGRUTI COOP BANK |
| 1022 | JAI BHAVANI SAHAKARI BANK LTD |
| 1023 | JAI HIND COOPERATIVE BANK LTD |
| 1024 | JAIHIND URBAN CO-OP BANK LTD |
| 1025 | JAIPUR THAR GRAMIN BANK |
| 1026 | JALAUN DISTRICT CO-OPERATIVE LTD |
| 1027 | JALGAON DISTRICT CENTRAL CO-OPERATIVE BANK LTD |
| 1028 | JALGAON MERCANTILE SAHAKARI BANK LTD |
| 1029 | JALGAON MERCHANT SAHAKARI BANK LTD |
| 1030 | JALGAON PEOPLES CO-OP BANK LIMITED |
| 1031 | JALGON JANTA SAHKARI BANK LTD |
| 1032 | JALNA DISTRICT CENTRAL CO-OP BANK LTD |
| 1033 | JALNA MERCHANTS COOP BANK LTD |
| 1034 | JALPAIGURI CENTRAL CO-OPBANK LTD |
| 1035 | JAMBUSAR PIPLE CO-OP BANK LTD |
| 1036 | JAMNAGAR DISTRICT CO-OPERATIVE BANK |
| 1037 | JAMNAGAR MAHILA SAHAKARI BANK |
| 1038 | JAMNAGAR PEOPLES CO-OPERATIVE BANK |
| 1039 | JAMNAGAR RAJKOT GRAMIN BANK |
| 104  | THANE PEOPLES CO-OP BANK LTD,BOMBAY |
| 1040 | JANESHWAR NAGARIK SAHAKARI BANK MARYADIT |
| 1041 | JAYSINGPUR UDGAON CO-OP BANK |
| 1042 | JBC |
| 1043 | JEEVAN COMMERCIAL CO-OP BANK |
| 1044 | JHARKHAND GRAMIN BANK |
| 1045 | JHARNESHWAR NAGRIK SAHAKARI BANK |
| 1046 | JIAGANJ CO-OPERATIVE BANK LTD |
| 1047 | JIJAMATA CO-OP BANK LTD |
| 1048 | JIJAU COMMERCIAL CO-OP BANK LIMITED |
| 1049 | JOGINDRA CENTRAL CO-OP BANK LTD |
| 1050 | JUNAGADH CO-OP BANK LTD |
| 1051 | JUNAGADH COMMERCIAL CO-OP BANK LTD |
| 1052 | JUNAGADH DISTRICT CO-OP BANK LTD |
| 1053 | JUNAGADH JILLA SAHAKARI BANK LTD |
| 1054 | JUNAGADH NAGRIK SAHAKARI BANK PVT LTD |
| 1055 | JUNAGADH VIBHAGIYA NAGARIK SAHAKARI BANK LTD |
| 1056 | JVNS BANK LTD |
| 1057 | K G D B KANAKADURGA GRAMEENA BANK |
| 1058 | K G R R BANK |
| 1059 | KADANAD SERVICE CO-OP BANK |
| 106  | THE MARATHA MANDIR CO-OP BANK LTD,BOMBAY |
| 1060 | KADUTHURUTHY URBAN CO-OP BANK |
| 1061 | KAKATHIYA GRAMEENA BANK |
| 1062 | KALAHANDI ANCHALIKA GRAMYA BANK |
| 1063 | KALINGA GRAMYA BANK |
| 1064 | KALLIYOOR SERVICE CO-OP BANK |
| 1065 | KALPATHARU GRAMEENA BANK |
| 1066 | KAMATHI CO-OP BANK LTD |
| 1067 | KAMUTHI CO-OP URBAN BANK |
| 1068 | KANAKA PATTANA SAHAKARA BANK |
| 1069 | KANAKADURGA GRAMEENA BANK |
| 1070 | KANCHEEPURAM CENTRAL CO-OPERATIVE BANK |
| 1071 | KANKARIA MANINAGAR SAHAKARI BANK LTD |
| 1072 | KANNUR TOWN SERVICE CO-OP BANK |
| 1073 | KAPUR COMMERCIAL CO-OP BANK LTD |
| 1074 | KAPURTHALA CENTRAL CO-OP BANK |
| 1075 | KARNAL CENTRAL CO-OP BANK LIMITED |
| 1076 | KARNATAKA CENTRAL CO-OP BANK |
| 1077 | KARNATAKA RAJYA KAIGARIKA SAHAKARI BANK |
| 1078 | KARTHEDOM MARANAVASIA CO-OP SOCIETY LTD |
| 1079 | KASHIPUR URBAN CO-OPERATIVE BANK LTD |
| 1080 | KASUNDIA CO-OP BANK |
| 1081 | KATKOL CO-OP BANK |
| 1082 | KEDIL SEVA SAHAKARI BANK |
| 1083 | KEMPEGOWDA PATTANA SAHAKARI BANK NIYAMITHA |
| 1084 | KHEDA DIST CENTRAL CO-OP BANK LTD |
| 1085 | KHERALU NAG SAH BANK LTD |
| 1086 | KISAN GRAMIN BANK |
| 1087 | KISCO BANK |
| 1088 | KODAGU DISTRICT CO-OPERATIVE CENTRAL BANK LTD |
| 1089 | KOKAN MERCANTILE COOPERATIVE BANK LTD |
| 1090 | KOLAR GRAMEENA BANK |
| 1091 | KOLHAPUR ZILLA MADHYAVARTI SAHAKARI BANK LTD |
| 1092 | KOLLOORVILA SERVICE CO-OP BANK LTD |
| 1093 | KONKAN PRANT SAHAKARI BANK LTD |
| 1094 | KOSHI KSHETRIYA GRAMIN BANK |
| 1095 | KOTESHWARA SAHAKARI BANK NIYAMITHA |
| 1096 | KOTTAKKAL CO-OPERATIVE URBAN BANK |
| 1097 | KOTTAYAM DISTRICT CO-OPERATIVE BANK LTD |
| 1098 | KRISHNA BHIMA SAMRUDDHI LOCAL AREA BANK LTD |
| 1099 | KRISHNAGIRI CO-OP BANK LTD |
| 1100 | KSHETRIYA GRAMIN BANK |
| 1101 | KUMACHAL NAGAR SAHKARI BANK LTD |
| 1102 | KUMARANALLOOR SERVICE CO-OP BANK |
| 1103 | KUMBAKONAM CENTRAL COOPERATIVE BANK |
| 1104 | KUMBAKONAM MUTUAL BENEFIT FUND LTD |
| 1105 | KUMBHI KASARI CO-OP BANK |
| 1106 | KUMBHI KASARI SAHAKARI BANK LTD |
| 1107 | KUNNAMKULAM CO-OPERATIVE URBAN BANK LTD |
| 1108 | KURMANCHAL NAGAR SAHAKARI BANK LIMITED |
| 1109 | KUTCH CO-OPERATIVE BANK LTD |
| 1110 | KUTCH GRAMIN BANK |
| 1111 | KUTTIPPURAM SERV COOP BANK |
| 1112 | L I C EMPLOYEES CO-OPERATIVE BANK LTD |
| 1113 | LAKHIMI GAONLIA BANK LTD |
| 1114 | LALA URBAN CO-OP BANK LTD |
| 1115 | LOKNETE DATTAJI PATIL SAHAKARI BANK LIMITED |
| 1116 | LUCKNOW KSHETRIYA GRAMIN BANK |
| 1117 | LUCKNOW URBAN CO-OPERATIVE BANK LTD |
| 1118 | M G BANK |
| 1119 | M K G BANK |
| 1120 | M P R S BANK |
| 1121 | M.P STATE CO.OP BANK LTD. |
| 1122 | M U N S BANK LTD |
| 1123 | MADHYA BHARAT GRAMIN BANK |
| 1124 | MADHYA BIHAR GRAMIN BANK |
| 1125 | MAGADH GRAMIN BANK |
| 1126 | MAHAJAN BANK |
| 1127 | MAHAKAUSHAL KSHETRIYA GRAMIN BANK |
| 1128 | MAHALAXMI PATTANA SOUHARDA SAHAKARI BANK LTD |
| 1129 | MAHARASHTRA GRAMIN BANK |
| 113  | GUWAHATI CO-OP URBAN BANK LTD |
| 1130 | MAHILA CO-OP BANK |
| 1131 | MAHILA URBAN SAHAKARI BANK LTD |
| 1132 | MAHILA UTKARSH CO-OP BANK LTD |
| 1133 | MAHILA UTKARSH NAGRIK SAHAKARI BANK LTD |
| 1134 | MAHILA VIKAS CO OPERATIVE BANK LTD |
| 1135 | MAKARPURA COOP BANK LTD |
| 1136 | MALAD SAHAKARI CO-OP BANK LTD |
| 1137 | MALAPPURAM DISTRICT CO-OP BANK LTD |
| 1138 | MALAPRABHA GRAMEENA BANK |
| 1139 | MALDA DISTRICT CENTRAL CO-OPERATIVE BANK LIMITED |
| 114  | INDUSTRIAL CO-OP BANK LTD,GUWAHATI |
| 1140 | MALEGAON MERCHANT CO-OP BANK |
| 1141 | MALKAPUR URBAN CO OPERATIVE BANK LIMITED |
| 1142 | MALLABHUM GRAMIN BANK |
| 1143 | MALWA GRAMIN BANK |
| 1144 | MANASSA CO-OP URBAN BANK |
| 1145 | MANDLA-BALAGHAT KSHETRIYA GRAMIN BANK |
| 1146 | MANGAL CO-OP BANK LTD |
| 1147 | MANINAGAR CO-OP BANK LTD |
| 1148 | MANIPAL CO-OPERATIVE BANK LTD |
| 1149 | MANJEERA GRAMEENA BANK |
| 1150 | MANJERI CO-OPERATIVE URBAN BANK LIMITED |
| 1151 | MANVI PATTANA SOUHARDA SAHAKARI BANK LTD |
| 1152 | MANWATH URBAN CO-OP BANK LTD |
| 1153 | MARADU SERVICE CO-OP BANK LTD |
| 1154 | MARATHA BANK |
| 1155 | MARATHA CO-OP CREDIT BANK LTD |
| 1156 | MARATHA CO-OP URBAN BANK LTD |
| 1157 | MARATHA CO-OPERATIVE URBAN BANK LTD |
| 1158 | MARATHA SAHAKARI BANK LIMITED |
| 1159 | MARATHWADA GRAMIN BANK |
| 116  | PRAGJYOTISH GAONLYA BANK LTD,GUWAHATI |
| 1160 | MARKANDEY NAGARI SAHAKARI BANK LTD |
| 1161 | MARLIN BANK |
| 1162 | MERCANTILE CO-OP BANK |
| 1163 | MERCHANT COOPERATIVE BANK LTD |
| 1164 | MIDHAA BANK |
| 1165 | MILLATH CO-OPERATIVE BANK LTD |
| 1166 | MODEL CO-OPERATIVE BANK LTD |
| 1167 | MORADABAD ZILA SAHAKARI BANK LTD |
| 1168 | MORBI NAGRIK SAHAKARI BANK LTD |
| 1169 | MSD GRAMIN BANK |
| 117  | ASSAM CO-OP APEX BANK LTD,GUWAHATI |
| 1170 | MUDADI SERVICE CO-OP BANK |
| 1171 | MUDAVANMUGAL SERVICE CO-OP BANK |
| 1172 | MUNGER KSHETRIYA GRAMIN BANK |
| 1173 | MURGHRARAJENDRA CO-OP BANK |
| 1174 | MURSHIDABAD GRAMIN BANK |
| 1175 | MUZAFFARNAGAR DISTRICT CO-OP BANK |
| 1176 | MUZAFFARNAGAR KSHETRIYA GRAMIN BANK |
| 1177 | N K G S B CO-OPERATIVE BANK |
| 1178 | NADIA GRAMIN BANK |
| 1179 | NAGAPATTINAM URBAN CO-OPERATIVE CREDIT SOCIETY LTD |
| 1180 | NAGAR SAHKARI BANK LIMITED |
| 1181 | NAGARIK SAMABAY BANK LTD |
| 1182 | NAGARIL JUNAGADH VIBHAG SAHAKARI BANK LTD |
| 1183 | NAGARJUNA GRAMEENA BANK |
| 1184 | NAGAUR ANCHALIK GRAMIN BANK |
| 1185 | NAGPUR MAHANAGAR PALIKA KARMACHARI SAHAKARI BANK LTD |
| 1186 | NAINITAL ALMORA KSHETREYA GRAMIN BANK |
| 1187 | NAINITAL BANK LTD |
| 1188 | NAINITAL DISTRICT CO-OPERATIVE BANK LTD |
| 1189 | NAMCO BANK LTD |
| 1190 | NAMCO NASIK MERCHANT CO-OP BANK LTD |
| 1191 | NANDI SAHAKARI BANK LTD |
| 1192 | NANDURBAR MERCHANTS CO-OP BANK |
| 1193 | NARMADA MALWA GRAMIN BANK STATE |
| 1194 | NARODA INDUSTRIAL CO-OPERATIVE BANK LTD |
| 1195 | NARODA NAGRIK COOPERATIVE BANK LTD |
| 1196 | NASHIK DISTRICT GIRNA SAHAKARI BANK LTD |
| 1197 | NASHIK MERCHANT CO-OP BANK LTD |
| 1198 | NASHIK ZILLA SARKARI AND PARI KARMACHI S BANK |
| 1199 | NATIONAL MERCANTILE CO-OP BANK |
| 120  | AHMEDABAD PEOPLES CO-OP BANK LTD |
| 1200 | NAVAL DOCKYARD CO-OP BANK LTD |
| 1201 | NAVHIND CO-OP CREDIT SOCIETY LTD |
| 1202 | NAVJIVAN COMMERCIAL COOP BANK |
| 1203 | NAVSARJAN INDUSTRIAL CO-OP BANK LTD |
| 1204 | NAYA NAGAR CO BANK LTD |
| 1205 | NIRMAL URBAN CO-OP BANK LTD |
| 1206 | NOBLE CO-OPERATIVE BANK LIMITED |
| 1207 | NORTH KANARA GSB COOPERATIVE BANK LTD |
| 1208 | NORTH MALABAR GRAMIN BANK |
| 1209 | NUTAN NAGRIK CO-OP BANK LTD |
| 1210 | PACHORA PEOPLES CO-OPERATIVE BANK LTD |
| 1211 | PADMAVATHI CO-OP URBAN BANK LTD |
| 1212 | PALANI CO-OP BANK |
| 1213 | PALI URBAN CO-OP BANK LTD |
| 1214 | PALLIPURAM SERVICE CO-OP BANK LTD |
| 1215 | PANCHKULA URBAN CO-OP BANK LTD |
| 1216 | PARAVUR S N V R C BANK |
| 1217 | PARWANOO URBAN CO-OP BANK LIMITED |
| 1218 | PASCHIM BANGA GRAMIN BANK |
| 1219 | PAVANA SAHAKARI BANK LTD |
| 122  | GENERAL CO-OP BANK LTD,AHMEDABAD |
| 1220 | PAYYOLI CO-OPERATIVE URBAN BANK |
| 1221 | PINAKINI GRAMEENA BANK |
| 1222 | PINELANDS DEVELOPMENT CREDIT BANK |
| 1223 | PITHORAGARH ZILA SAHKARI BANK LTD |
| 1224 | POTHANICAD FARMERS CO-OP BANK LTD |
| 1225 | PRAGATHI GRAMENA BANK |
| 1226 | PRATAPGARH KSHETRIYA GRAMIN BANK |
| 1227 | PRATHAMIKA KRISHI SAHAKARI BANK NI |
| 1228 | PRAVARA SAHAKARI BANK |
| 1229 | PRAVARA SAHAKARI BANK LTD |
| 123  | GUJRATH INDUSTRIAL CO-OP BANK LTD |
| 1230 | PRIYADARSHINI NAGARI SAHAKARI BANK LTD |
| 1231 | PRIYADARSHINI URBAN CO-OPERATIVE BANK LTD |
| 1232 | PUNE CANTONMENT SAHAKARI BANK LTD |
| 1233 | PUNE DISTRICT CENTRAL CO-OPERATIVE BANK LTD |
| 1234 | PURASAWALKAM CO-OP BANK LTD |
| 1235 | PURI GRAMEENA BANK |
| 1236 | PUSAD URBAN CO-OP BANK LTD |
| 1237 | PUTHUPALLY VILLAGE SERVICE CO-OPERATIVE BANK LTD |
| 1238 | R C F AND D BANK |
| 1239 | R D C C BANK LTD |
| 1240 | R N S B L |
| 1241 | R N S BANK |
| 1242 | R R BANK |
| 1243 | RAHILA SEEMA GRAMEENA BANK |
| 1244 | RAICHUR ZILLA MAHILA PATTANA SAHAKARI BANK LTD |
| 1245 | RAIGAD ZILLA MADHYAVARTI SAHAKARI BANK LTD |
| 1246 | RAIGARH KSHETRIYA GRAMIN BANK |
| 1247 | RAIGARH NAGARIK SAHAKARI BANK |
| 1248 | RAJALAKSHMI NAGRIK SAHAKARI BANK LTD |
| 1249 | RAJAPALAYAM CO-OP URBAN BANK LTD |
| 125  | HARISIDDH CO-OP BANK LTD,AHMEDABAD |
| 1250 | RAJASTHAN GRAMIN BANK |
| 1251 | RAJGARH SEHORE KSHETRIYA GRAMEEN BANK LTD |
| 1252 | RAJGURU NAGAR SAHKARI BANK LTD |
| 1253 | RAJKOT DEVELOPMENT CREDIT BANK |
| 1254 | RAJKOT NAGARIK SAHAKARI BANK LTD |
| 1255 | RAJPIPLA NAGRIK SAHAKARI BANK |
| 1256 | RAJPUTANA MAHILA CO-OP BANK LTD |
| 1257 | RAJSAMAND URBAN CO-OP. BANK LTD. |
| 1258 | RANCHI KSHETRIYA GRAMIN BANK |
| 1259 | RANGA REDDY COOP URBAN BANK LTD |
| 1260 | RANI LAXMI BAI KSHETRIYA GRAMIN BANK |
| 1261 | RANI LAXMI BAI URBAN COOP BANK LTD |
| 1262 | RANUJ NAGARIK SAHAKARI BANK LTD |
| 1263 | RASIPURAM COOPERATIVE URBAN BANK |
| 1264 | RATLAM MANDSAUR KSHETRIYA GRAMIN BANK |
| 1265 | RAYALASEEMA GRAMEENA BANK |
| 1266 | RCC BANK |
| 1267 | REPCO BANK LTD |
| 1268 | S A M M C BANK LTD |
| 1269 | S B GRAMIN BANK |
| 127  | MANEKCHOWK CO-OP BANK LTD,AHMEDABAD |
| 1270 | S B P SOUHARDA SAHAKARI NIYAMITA |
| 1271 | S C D C C BANK LTD |
| 1272 | S G GRAMIN BANK |
| 1273 | S J M CREDIT COOP SOCIETY LTD |
| 1274 | S K GOLDSMITH INDUSTRIAL CO-OP SOCIETY LTD |
| 1275 | S K GRAMIN BANK |
| 1276 | S K P CO-OP BANK |
| 1277 | S L M CO-OP BANK |
| 1278 | S M M CO-OP BANK |
| 1279 | S M THIRUVALLUVAR TOWN CO-OP BANK LTD |
| 1280 | S N V R C BANK |
| 1281 | S P S S BANK |
| 1282 | S S J M S BANK LTD |
| 1283 | S T CO-OP BANK |
| 1284 | S V C BANK |
| 1285 | S V GRAMEENA BANK |
| 1286 | SABARKANTHA DISTRICT CENTRAL COOPERATIVE BANK LIMITED |
| 1287 | SABARKANTHA GANDHINAGAR GRAMEEN BANK |
| 1288 | SACHIN IND. CO-OP. BANK |
| 1289 | SADALGA URBAN CO-OP BANK LTD |
| 129  | SHRI LAXMI CO-OP BANK LTD,AHMEDABAD |
| 1290 | SADALGA URBAN SOUHARDA SAHAKARI BANK NIYAMIT |
| 1291 | SADHANA CO-OP BANK |
| 1292 | SAGAR GRAMIN BANK |
| 1293 | SAHAKANTHA JILLA MADHYASTH CO-OP BANK |
| 1294 | SAHAKARI KENDRIYA BANK |
| 1295 | SAHARA BANK |
| 1296 | SAHARA URBAN COOP CREDIT SOCIETY LTD |
| 1297 | SAHYADRI GRAMEENA BANK |
| 1298 | SAHYADRI MAHILA URBAN CO-OP BANK LTD |
| 1299 | SAINIK SAHAKARI BANK |
| 1300 | SAKTHI P A CO-OP BANK LTD |
| 1301 | SAMBALPUR DIST COOP BANK LTD |
| 1302 | SAMCO BANK LTD |
| 1303 | SAMRUDDHI CO-OPERATIVE BANK LTD |
| 1304 | SAMYUT KSHETRIYA GRAMIN BANK |
| 1305 | SANDUR PATTANA SOUHARDA SAHAKARI BANK |
| 1306 | SANKAKU NAGRIK SAHAKARI BANK |
| 1307 | SANMITRA MAHILA NAGRIK SAHAKARI BANK MARYADIT |
| 1308 | SANMITRA URBAN CO-OP BANK LTD |
| 1309 | SANTHAL PARGANAS GRAM BANK |
| 1310 | SANTRAGACHI CO-OPERATIVE BANK LTD |
| 1311 | SAPTAGIRI GRAMEENA BANK |
| 1312 | SARANGPUR CO-OP BANK LTD |
| 1313 | SARASWATI GRAMIN BANK |
| 1314 | SARAYU GRAMEENA BANK |
| 1315 | SARDAR BHILADWALA PARDI PEOPLES CO-OP BANK LTD |
| 1316 | SARDAR GUNJ MERCANTILE COOPERATIVE BANK LIMITED |
| 1317 | SARJERAO DADA NAIK SHIRALA SAHAKARI BANK LTD |
| 1318 | SARVA U.P GRAMIN BANK |
| 1319 | SARVODAYA COMMERCIAL CO-OP BANK LIMITED |
| 1320 | SATARA JILHA MADHYAVARTI SAHAKARI BANK LIMITED |
| 1321 | SATPURA BALAGHAT KSHETRIYA GRAMIN BANK |
| 1322 | SATYASHODHAK SAHAKARI BANK LTD |
| 1323 | SBBSI |
| 1324 | SBS LTD |
| 1325 | SEB ENSKILDA BANKEN |
| 1326 | SEHORE NAGRIK SAHAKARI BANK LTD |
| 1327 | SERVICE COOPERATIVE BANK |
| 1328 | SEVALIA URBAN CO-OP BANK LTD |
| 1329 | SEVEN HILLS CO-OP URBAN CO-OP BANK |
| 133  | AHMEDABAD URBAN CO-OP BANK LTD |
| 1330 | SGRLPSSN BANK |
| 1331 | SHANKAR NAGARI SAHAKARI BANK LTD |
| 1332 | SHANKHA NAGRIK SAHAKARI BANK LTD |
| 1333 | SHARDA GRAMIN BANK |
| 1334 | SHEKHAWATI GRAMIN BANK |
| 1335 | SHENDA GRAMIN BANK |
| 1336 | SHETKARI SAHAKARI BANK LTD |
| 1337 | SHIBLI BANK |
| 1338 | SHIKSHAK SAHAKARI BANK LTD |
| 1339 | SHIVA CO-OPERATIVE BANK LIMITED |
| 1340 | SHIVA SAHAKARI BANK NIYAMITHA |
| 1341 | SHIVAJIRAO BHOSALE SAHAKARI BANK LTD |
| 1342 | SHIVALIK MERCANTILE CO-OPERATIVE BANK LTD |
| 1343 | SHREE BALAJI URBAN CO-OPERATIVE BANK LTD |
| 1344 | SHREE BARIA NAGRIK SAHAKARI BANK |
| 1345 | SHREE BASAVESHWAR URBAN CO-OP BANK |
| 1346 | SHREE BHAILALBHAI CONTRACTOR SMARAK CO-OP BANK LTD |
| 1347 | SHREE CHANDRAPRABHU URBAN COOP CREDIT SOCIETY LTD |
| 1348 | SHREE CHHANI NAGRIK SAHAKARI BANK LTD |
| 1349 | SHREE DEESA NAGARIK SAHAKARI BANK LIMITED |
| 1350 | SHREE GAJANAN LOKSEVA SAHAKARI BANK LTD |
| 1351 | SHREE GAJANAN URBAN CO-OP BANK LTD |
| 1352 | SHREE KADI NAGARIK SAHAKARI BANK LTD |
| 1353 | SHREE MAHALAXMI MERCANTILE CO-OP BANK LTD |
| 1354 | SHREE MAHALAXMI URBAN COOPERATIVE CREDIT BANK LTD |
| 1355 | SHREE MAHAVIR SAHAKARI BANK LTD |
| 1356 | SHREE MAHUVA NAGRIK SAHAKARI BANK LTD |
| 1357 | SHREE MURUGHARAJENDRA CO-OP BANK LTD |
| 1358 | SHREE RAMA CREDIT CO-OP SOCIETY |
| 1359 | SHREE RENUKA URBAN CO-OP CREDIT SOCIETY LTD |
| 1360 | SHREE SAMARTH CO-OP BANK |
| 1361 | SHREE SIDDHIVINAYAK NAGARI SAH BANK LTD |
| 1362 | SHREE WARANA CO-OP BANK LTD |
| 1363 | SHREE YUGPRABHAVA SAHAKARI BANK LTD |
| 1364 | SHREENATH CO-OPERATIVE BANK LTD |
| 1365 | SHREYAS GRAMIN BANK |
| 1366 | SHRI ANAND NAGAR SAHAKARI BANK LTD |
| 1367 | SHRI ARIHANT CO-OP BANK LTD |
| 1368 | SHRI BASAVESHWAR CO-OP BANK LTD |
| 1369 | SHRI BASAVESHWAR SAHAKARI BANK LTD |
| 137  | CITI CO-OP BANK LTD,AHMEDABAD |
| 1370 | SHRI BEERESHWARA SOUHARD CREDIT SAHAKARI LTD |
| 1371 | SHRI BRAHMANAND CREDIT SOUHARDA SAHAKARI NIYAMIT |
| 1372 | SHRI CHHATRAPATI SHIVAJI URBAN CO-OP CREDIT SOC LTD |
| 1373 | SHRI DADASAHEB GAJMAL CO-OP BANK LTD |
| 1374 | SHRI DEERESHWAR SOUHARD CREDIT SAHAKARI LTD |
| 1375 | SHRI HARIHARESHWAR URBAN COOP BANK LTD |
| 1376 | SHRI KANYAKA NAGARI SAHAKARI BANK LTD |
| 1377 | SHRI LAXMI CREDIT SOUHARDA SAHAKARI NIYAMIT |
| 1378 | SHRI MAHANT SHIBANAGI SAHAKARI BANK LTD |
| 1379 | SHRI MAHARANA PRATAP CO OPERATIVE BANK LIMITED |
| 1380 | SHRI MAHILA SEWA SAHAKARI BANK LTD |
| 1381 | SHRI PARSHWANATH SAHAKARA BANK NIYAMITHA |
| 1382 | SHRI S S CO-OP BANK LTD |
| 1383 | SHRI SATYAVIJAY SAHAKARI BANK LTD |
| 1384 | SHRI SHAILA CO-OP SOCIETY BANK |
| 1385 | SHRI SHANTAPPA MIRJI URBAN COOP BANK LTD |
| 1386 | SHRI SHARANAVEERESHWAR SAHAKARI BANK NIYAMIT |
| 1387 | SHRI SIDDHESHWAR CO-OP BANK LTD |
| 1388 | SHRI SIDDHI VENKATESH SAHAKARI BANK LIMITED |
| 1389 | SHRI TUKARAM CO-OPERATIVE BANK LTD |
| 1390 | SHRI VYAS DHANVARSHA HSA BANK LTD |
| 1391 | SIDDAGANGA URBAN CO-OPERATIVE BANK LTD |
| 1392 | SIDDHA RAGHAVA SOUHARDA SAHAKARA BANK NIYAMITHA |
| 1393 | SIDDHI CO-OPERATIVE BANK LTD |
| 1394 | SIHOR MERCANTILE CO-OP BANK |
| 1395 | SIKAR KENDRIYA SAHAKARI BANK LTD |
| 1396 | SINDHANUR URBAN CO-OPERATIVE BANK LIMITED |
| 1397 | SINDHANUR URBAN SOUHARDA COOPERATIVE BANK LIMITED |
| 1398 | SINDHUDURG DISTRICT CENTRAL CO-OP BANK |
| 1399 | SIRA TALUK SRI KANAKA CO-OP CREDIT SOC LTD |
| 140  | PRAGATI CO-OP BANK LTD,AHMEDABAD |
| 1400 | SIRSA CENTRAL CO-OP BANK |
| 1401 | SIRSI URBAN CO-OP BANK LTD |
| 1402 | SIWAN KSHETRIYA GRAMIN BANK |
| 1403 | SKPC BANK |
| 1404 | SLN CO-OP URBAN BANK LTD |
| 1405 | SMM CO-OP BANK LTD |
| 1406 | SMRITI NAGAR SAHAKARI BANK MARYADIT |
| 1407 | SNEHA SAGAR SOUHARDA CO-OP BANK |
| 1408 | SOLAIMANI COOP BANK LTD |
| 1409 | SOPANKAKA SAHAKARI BANK LTD |
| 1410 | SOURASHTRA CO-OP BANK |
| 1411 | SOUTH ARCOT DIST CENTRAL CO-OP BANK |
| 1412 | SPS BANK |
| 1413 | SRAVASTI GRAMIN BANK |
| 1414 | SREE ANANTHA GRAMEENA BANK |
| 1415 | SREE ANJANEYA COOP BANK LTD |
| 1416 | SREE BANASHANKARI MAHILA CO-OP BANK |
| 1417 | SREECHARAN SOUHARDA CO-OP BANK LTD |
| 1418 | SREENIDHI SOUHARDA SAHAKARI BANK NIYAMITHA |
| 1419 | SRI ANANTAPUR GRAMIN BANK |
| 1420 | SRI BHRAMARAMBA PATTINA SHARADA SAHAKARI NYAMITA |
| 1421 | SRI CHANNABASAVA SWAMY URBAN CO-OP BANK LTD |
| 1422 | SRI GANAPATHI URBAN CO-OPERATIVE BANK LTD |
| 1423 | SRI GANESH CO-OPERATIVE BANK LTD |
| 1424 | SRI GURU RAGHAVENDRA SAHAKARA BANK NIYAMITHA |
| 1425 | SRI GURU VAPPATHINA SWAMY BANK |
| 1426 | SRI KANYAKA PARAMESWARI CO-OP BANK LTD |
| 1427 | SRI LAKSHMI NARAYANA CO-OPERATIVE URBAN BANK LTD |
| 1428 | SRI MAHAYOGI LAKSHMAMMA CO-OP BANK LTD |
| 1429 | SRI MALLIKARJUNA PATTANA SAHAKARI BANK |
| 1430 | SRI RAMA CO-OPERATIVE BANK |
| 1431 | SRI RAMA GRAMEENA BANK |
| 1432 | SRI RAMA KRISHNA CREDIT CO-OP BANK |
| 1433 | SRI RAMA NAGAR PATTANA SAHAKARA BANK NIYAMITA |
| 1434 | SRI RAMKRISHNAPUR CO-OPERATIVE BANK LTD |
| 1435 | SRI SATHAVAHANA GRAMEENA BANK |
| 1436 | SRI SHARDA MAHILA CO-OP URBAN BANK LTD |
| 1437 | SRI SRI SHILA CREDIT CO-OPERATIVE SOCIETY LIMITED |
| 1438 | SRI SUDHA CO-OPERATIVE BANK LTD |
| 1439 | SRI VENKATESWARA GRAMEENA BANK |
| 144  | HYDERABAD DIST.CO-OP CENTRAL BANK LTD |
| 1440 | SRIGANGANAGAR CHETRIYA GRAMIN BANK |
| 1441 | SRIMATHA MAHILA SAHAKARI BANK NIYAMITHA |
| 1442 | STATE BANK OF BARODA |
| 1443 | STATE BANK OF MAHARASHTRA |
| 1444 | STATE BANK OF PONDY |
| 1445 | STATE BANK OF RAJASTHAN LTD |
| 1446 | STATE BANK OF SIKKIM |
| 1447 | STATE BANK OF TALASARI |
| 1448 | SUCO BANK LTD |
| 1449 | SULTANPUR KSHETRIYA GRAMIN BANK |
| 145  | VASAVI CO-OP URBAN BANK LTD,HYDERABAD |
| 1450 | SURAT BHARUCH GRAMIN BANK |
| 1451 | SURENDRANAGAR BHAVNAGAR GRAMIN BANK LTD |
| 1452 | SURI MAYURAKSHI GRAMIN BANK |
| 1453 | SUSCO |
| 1454 | SUSHIL KUMAR NAHATA URBAN CO-OP BANK LIMITED |
| 1455 | SUVAM S BANK |
| 1456 | SUVARNA COOPERATIVE CREDIT SOCIETY LIMITED |
| 1457 | SV GRAMEENA BANK |
| 1458 | SVC CO-OP BANK |
| 1459 | SWARNA BHARATHI SAHAKARI BANK NIYAMITHA |
| 146  | KARNATAKA STATE CO-OP APEX BANK LTD,BANGLORE |
| 1460 | T A P C M S LTD |
| 1461 | T D C C BANK LTD |
| 1462 | T G BANK |
| 1463 | T G M C BANK LTD |
| 1464 | T N B BANK |
| 1465 | T O B |
| 1466 | T V F S COOP BANK LTD |
| 1467 | TAMEER CO-OPERATIVE CREDIT SOCIETY LTD |
| 1468 | TANJORE CENTRAL CO-OP BANK LTD |
| 1469 | TARGO BANK |
| 147  | MADHUPURA MERC.CO-OP BANK LTD,AHMEDABAD |
| 1470 | TARN TARAN CENTRAL CO-OP BANK |
| 1471 | TELLICHERRY CO-OPERATIVE BANK LTD |
| 1472 | THALASSERY CO-OP URBAN CO-OP BANK LTD |
| 1473 | THANE GRAMIN BANK LTD |
| 1474 | THE A D C CO-OP BANK |
| 1475 | THE ADARSH CO-OP URBAN BANK LTD |
| 1476 | THE ADHYAPAKA CO-OP BANK LTD |
| 1477 | THE ADOOR CO-OPERATIVE URBAN BANK LTD |
| 1478 | THE ALATHUR SERVICE CO-OP BANK LTD |
| 1479 | THE ALNAVAR URBAN CO-OPERATIVE BANK LTD |
| 148  | BANK OF CR. AND COMM.INTERNL.(OVERSEAS)LTD,BOMBAY |
| 1480 | THE AMBALA CENTRAL CO-OP BANK LTD |
| 1481 | THE AMBALAVAYAL SERVICE CO-OPERATIVE BANK LTD |
| 1482 | THE AMOD NAGARIK SAHAKARI BANK LTD |
| 1483 | THE AMRAVATI DIST CENTRAL SAHAKARI BANK LTD |
| 1484 | THE AMRAVATI JILHA MADHYAVARTI SAHAKARI BANK LTD |
| 1485 | THE AMRAVATI PEOPLES CO-OP BANK LTD |
| 1486 | THE ANCHAL SERVICE CO-OP BANK |
| 1487 | THE ANDHRA BANK FARMERS SERVICE CO-OP SOCIETY LTD |
| 1488 | THE ANGEL UCC BANK |
| 1489 | THE AP M C V B LTD |
| 1490 | THE APNA CO-OP URBAN BANK LTD |
| 1491 | THE ARACKAL SERVICE CO-OP BANK LTD |
| 1492 | THE ARAKONNAM CO-OP URBAN BANK LTD |
| 1493 | THE ARAKULAM FARMERS SERVICE CO-OP BANK LIMITED |
| 1494 | THE ARYAPURAM CO-OP URBAN BANK LTD |
| 1495 | THE B D C C BANK |
| 1496 | THE B KOMARAPALAYAM COOPERATIVE URBAN BANK LTD |
| 1497 | THE BADAGABETTU COOP SOCIETY LTD |
| 1498 | THE BAIDYABATI SHEORAPHULI COOP BANK LTD |
| 1499 | THE BAILHONGAL MERCHANTS CO-OPERATIVE BANK LTD |
| 1500 | THE BANGALORE CITY CO-OP BANK LTD |
| 1501 | THE BAPUNAGAR MAHILA COOP BANK LTD |
| 1502 | THE BARAMATI URBAN CO-OPERATIVE BANK LTD |
| 1503 | THE BATHINDA CENTRAL CO-OP BANK LTD |
| 1504 | THE BEGUSARAI CENTRAL CO-OP BANK LTD |
| 1505 | THE BELGAUM CATHOLIC CO-OP BANK |
| 1506 | THE BELGAUM DIST CENTRALCOOPERATIVE BANK |
| 1507 | THE BELGAUM PIONEER URBAN CO-OP CREDIT BANK LTD |
| 1508 | THE BELGAUM ZILLA KENDRIYA SAHAKARI BANK NIYAMIT |
| 1509 | THE BELGAUM ZILLA RANI CHANNAMMA MAH SAH BANK |
| 151  | CALYON BANK , BOMBAY |
| 1510 | THE BELLAD BAGEWADI URBAN CO-OP BANK LTD |
| 1511 | THE BELLAMPALLY CO-OPERATIVE URBAN BANK |
| 1512 | THE BENGAL DIST CENTRAL CO-OP BANK LTD |
| 1513 | THE BERHAMPORE CO-OPERATIVE CENTRAL BANK LTD |
| 1514 | THE BGM DT REVENUE EMPLOYEE CO-OP BANK |
| 1515 | THE BHAGALPUR CENTRAL CO-OPERATIVE BANK LTD |
| 1516 | THE BHAGYALAKSHMI MAHILA SAHAKARI BANK LTD |
| 1517 | THE BHARUCH SAHAKARI NAGRIK BANK LTD |
| 1518 | THE BHAVANI KUDAL CO-OP URBAN BANK |
| 1519 | THE BHAVASAR KSHATRIYA CO-OPERATIVE BANK LTD |
| 152  | ANYONYA SAH.MANDALI CO-OP BANK LTD,BARODA |
| 1520 | THE BIHAR AWAMI CO-OP BANK |
| 1521 | THE BIRBHUM DISTRICT CENTRAL CO-OPERATIVE BANK LTD |
| 1522 | THE BODELI URBAN CO-OP BANK LTD |
| 1523 | THE BOLANGIR DIST CENTRAL COOP BANK LTD |
| 1524 | THE BROACH DISTRICT CENTRAL CO-OP BANK LTD |
| 1525 | THE BUCHIREDDY PALEM CO-OP RURAL BANK LTD |
| 1526 | THE BULDHANA DISTRICT CENTRAL CO-OP BANK LTD |
| 1527 | THE BURDWAN CENTRAL CO-OPERATIVE BANK LTD |
| 1528 | THE C K P CO OPERATIVE BANK LTD |
| 1529 | THE CANNANORE DISTRICT CO-OP BANK LTD |
| 1530 | THE CARDAMOM MERCHANTS CO-OP BANK LIMITED |
| 1531 | THE CATHOLIC CO-OPERATIVE URBAN BANK LTD |
| 1532 | THE CENTRAL RITU SEVA SAHAKARI SANGAM |
| 1533 | THE CHANASMA NAGARIK SAHAKARI BANK LTD |
| 1534 | THE CHANDRAPUR DIST CENTRAL CO-OP BANK LTD |
| 1535 | THE CHENNIMALAI CO-OP URBAN BANK LTD |
| 1536 | THE CHERPALCHERY CO-OPERATIVE BANK LTD |
| 1537 | THE CHITRADURGA DIST CO-OP BANK LTD |
| 1538 | THE CHOPRA PEOPLES COOP BANK LTD |
| 1539 | THE CKP CO-OPERATIVE BANK LTD |
| 154  | BARODA TRADERS CO-OP BANK LTD |
| 1540 | THE COASTAL URBAN CO-OP BANK LTD |
| 1541 | THE COMPTROLLERS OFFICE CO-OPERATIVE BANK LTD |
| 1542 | THE COONOOR CO-OPERATIVE URBAN BANK LTD |
| 1543 | THE COOPERATIVE TOWN BANK LTD |
| 1544 | THE CUDDAPAH DISTRICT COOPERATIVE CENTRAL BANK LTD |
| 1545 | THE DAKOR NAGRIK SAHAKARI BANK LTD |
| 1546 | THE DECCAN URBAN CO-OP BANK LTD |
| 1547 | THE DEOLA MERCHANTS CO-OP BANK LTD |
| 1548 | THE DHANBAD CENTRAL CO-OP BANK LTD |
| 1549 | THE DHARAPURAM CO-OP URBAN BANK LTD |
| 155  | BARODA PEOPLES CO-OP BANK LTD |
| 1550 | THE DHARMADAM SERVICE COOP BANK LTD |
| 1551 | THE DULIYA DISTRICT CO-OP BANK |
| 1552 | THE DWARKADAS MANTRI NAGARI SAHAKARI BANK LTD |
| 1553 | THE ELIKULAM SERVICE CO-OP BANK LTD |
| 1554 | THE FAIL MERCANTILE CO-OP BANK LTD |
| 1555 | THE FAZILKA CENTRAL CO-OPERATIVE BANK LTD |
| 1556 | THE GADHINGLAJ URBAN CO-OPERATIVE BANK LTD |
| 1557 | THE GANDEVI PEOPLES CO-OP BANK |
| 1558 | THE GANDHI NAGAR URBAN CO-OP BANK LTD |
| 1559 | THE GANDHINAGAR NAGRIK CO-OP BANK |
| 1560 | THE GAUHATI CO-OP URBAN BANK LTD |
| 1561 | THE GI NAGAR NAGRIK CO-OP BANK LTD |
| 1562 | THE GODHRA CITY CO-OP BANK LTD |
| 1563 | THE GOKAK URBAN CO-OPERATIVE CREDIT BANK LTD |
| 1564 | THE GOVERNMENT EMPLOYEES CO-OP BANK |
| 1565 | THE GOVERNMENT SERVANTS COOP BANK LTD |
| 1566 | THE GPR CO-OP URBAN BANK LTD |
| 1567 | THE GURGAON CENTRAL CO-OP BANK LTD |
| 1568 | THE GURUVAYOOR CO-OP URBAN BANK |
| 1569 | THE HALOL MERC CO-OP BANK LTD |
| 157  | CO-OPERATIVE BANK BARODA LTD |
| 1570 | THE HASTI COOPERATIVE BANK LTD |
| 1571 | THE HAVERI URBAN CO-OP BANK LTD |
| 1572 | THE HIREKERUR URBAN CO-OP BANK LTD |
| 1573 | THE HISAR DIST CENTRAL COOPERATIVE BANK LTD |
| 1574 | THE HONAVAR URBAN CO-OPERATIVE BANK LTD |
| 1575 | THE HOOGHLY CO-OP BANK LTD |
| 1576 | THE HOOGHLY CO-OP CREDIT BANK LTD |
| 1577 | THE HOSPET CO-OP CITY BANK |
| 1578 | THE HUBLI URBAN CO-OPERATIVE BANK LTD |
| 1579 | THE ILKAL CO-OP BANK LTD |
| 1580 | THE INCHAKUNDU SERVICE CO-OPERATIVE BANK LTD |
| 1581 | THE INNESPETA CO-OPERATIVE URBAN BANK LIMITED |
| 1582 | THE IRINJALAKUDA TOWN CO-OPERATIVE BANK LTD |
| 1583 | THE JALNA DIST SAHAKARI BANK LTD |
| 1584 | THE JALNA PEOPLES CO-OP BANK LIMITED |
| 1585 | THE JALNA ZILLA MADHYAVARTI SAHAKARI BANK LTD |
| 1586 | THE JAOLI SAHAKARI BANK |
| 1587 | THE JILLA DISTRICT CO-OP BANK LTD |
| 1588 | THE K D C C BANK LTD |
| 1589 | THE KAKINADA CO-OP BANK LTD |
| 159  | MAKARPURA INDL.EST.CO-OP BANK LTD,BARODA |
| 1590 | THE KAKINADA CO-OPERATIVE TOWN BANK LTD |
| 1591 | THE KAKINADA COMMERCIAL CO-OP BANK LTD |
| 1592 | THE KALAKKODU SERVICE CO-OPERATIVE SOCIETY |
| 1593 | THE KALUPUR COMMERCIAL CO-OP BANK LTD |
| 1594 | THE KALUPUR COMMERCIAL COOP BANK LTD |
| 1595 | THE KAMADHENU SEVA SAHAKARI BANK LTD |
| 1596 | THE KAMARAJAR DIST CENTRAL COOP BANK LTD |
| 1597 | THE KANGRA CENTRAL CO-OPERATIVE BANK LTD |
| 1598 | THE KANNUR DISTRICT CO-OPERATIVE BANK LTD |
| 1599 | THE KAPADWANJ PEOPLES CO-OP BANK LTD |
| 1600 | THE KAPOL CO-OP BANK LTD |
| 1601 | THE KARAD URBAN BANK CO-OP BANK LTD |
| 1602 | THE KARAIKUDI CO-OP TOWN BANK LTD |
| 1603 | THE KARIMANNOOR SERVICE CO-OPERATIVE BANK LTD |
| 1604 | THE KARIMNAGAR COOPERATIVE URBAN BANK LTD |
| 1605 | THE KARJAN NAGARIK SAHAKARI BANK LTD |
| 1606 | THE KARNA DIDTRICT CENTRAL CO-OP BANK LTD |
| 1607 | THE KARUNAGAPPALLY SERVICE CO-OPERATIVE BANK |
| 1608 | THE KARUR TOWN CO-OPERATIVE BANK LTD |
| 1609 | THE KARUVANNUR SERVICE CO-OPERATIVE BANK LTD |
| 161  | VEPAR VIKAS CO-OP BANK LTD,BARODA |
| 1610 | THE KASARAGOD CO-OPERATIVE TOWN BANK LTD |
| 1611 | THE KAUJALGI URBAN COOPERATIVE CREDIT BANK LTD |
| 1612 | THE KENDRAPARA URBAN CO-OP BANK LTD |
| 1613 | THE KEONJHAR CENTRAL CO-OPERATIVE BANK LTD |
| 1614 | NAGPUR NAGARIK SAHAKARI BANK |
| 1615 | THE KHAMGAON URBAN CO-OP BANK LTD |
| 1616 | THE KHATTRI CO-OP URBAN BANK |
| 1617 | THE KIDANGOOR SERVICE CO-OPERATIVE BANK LTD |
| 1618 | THE KIZHATHADIYOOR SERVICE CO-OPERATIVE BANK LTD |
| 1619 | THE KODIYERI SERVICE CO-OP BANK LTD |
| 162  | BARODA DIST.INDL.CO-OP BANK LTD |
| 1620 | THE KODUR SERVICE CO-OP BANK LTD |
| 1621 | THE KOLLAM DISTRICT CO-OP BANK LTD |
| 1622 | THE KOPARGAON PEOPLES CO-OP BANK LTD |
| 1623 | THE KORAPUT CENTRAL CO-OP BANK LTD |
| 1624 | THE KOTACHERY SERVICE CO-OP BANK LTD |
| 1625 | THE KOUJALGI URBAN CO-OP CREDIT BANK LTD |
| 1626 | THE KOVILPATTI CO-OPERATIVE URBAN BANK LTD |
| 1627 | THE KOYLANCHAL URBAN CO-OP BANK LTD |
| 1628 | THE KRANTI CO-OPERATIVE BANK LTD |
| 1629 | THE KUDAMALOOR SERVICE CO-OPERATIVE BANK LTD |
| 163  | PATNI CO-OP BANK LTD,BARODA |
| 1630 | THE KUNBI SAHAKARI BANK LTD |
| 1631 | THE KURUKSHETRA CENTRAL CO-OP BANK LTD |
| 1632 | THE KUTTALAM COOP RURAL BANK LTD |
| 1633 | THE KUZHUPILLY SERVICE CO-OP BANK LTD |
| 1634 | THE M M CO-OP BANK LTD |
| 1635 | THE MACHILIPATNAM CO-OP URBAN BANK LTD |
| 1636 | THE MALAD SAHAKARI BANK LTD |
| 1637 | THE MALGUDI CO-OP BANK LTD |
| 1638 | THE MANANJE VYAVASAYA SEVA SAHAKARI NIYAMITA |
| 1639 | THE MANAPPARAI TOWN CO-OPERATIVE BANK LTD |
| 1640 | THE MANDYA DIST CO-OP CENTRAL BANK |
| 1641 | THE MANNANAM SERVICE CO-OPERATIVE BANK LTD |
| 1642 | THE MANSA NAGRIK SAHAKARI BANK LTD |
| 1643 | THE MARGAO URBAN CO-OP BANK LTD |
| 1644 | THE MASHARPURA MERC CO-OP BANK LTD |
| 1645 | THE MATTANCHERRY MAHAJANIK URBAN CO-OP BANK LTD |
| 1646 | THE MATTANCHERRY SARVAJANIK CO-OPERATIVE BANK LTD |
| 1647 | THE MATTANUR CO-OP RURAL BANK |
| 1648 | THE MAW NAGAR CO-OPERATIVE BANK LTD |
| 1649 | THE MAYYANAD SERVICE COOP BANK LTD |
| 165  | THE MUSLIM CO-OP BANK LTD,PUNE |
| 1650 | THE MDCC BANK LTD |
| 1651 | THE MEDINA CO-OP CREDIT SOCIETY LTD |
| 1652 | THE MEENACHIL EAST URBAN CO-OP BANK LTD |
| 1653 | THE MEHMADAVAD URBAN PEOPLES CO-OP BANK |
| 1654 | THE MEHSANA J P KARMA CO-OP BANK LTD |
| 1655 | THE MEHSANA MAHILA SAHAKARI BANK LTD |
| 1656 | THE MEHSANA NAGARIK SAHAKARI BANK LIMITED |
| 1657 | THE MERCANTILE CO-OPERATIVE BANK |
| 1658 | THE MERCHANTS CO-OPERATIVE BANK LTD |
| 1659 | THE MERCHANTS LIBERAL BANK |
| 1660 | THE MERCHANTS SOUHARDA SAHAKARA BANK NIYAMITA |
| 1661 | THE MERCHANTS URBAN CO-OPERATIVE LTD |
| 1662 | THE METTUPALAYAM CO-OP URBAN BANK LTD |
| 1663 | THE METTUR CHEMICALS EMPLOYEES CO-OP SOC LTD |
| 1664 | THE MIRAJ URBAN CO-OP BANK LTD |
| 1665 | THE MIRZAPUR URBAN CO-OP BANK LTD |
| 1666 | THE MORAZHA KALLIASSERI SERVICE CO-OP BANK LTD |
| 1667 | THE MSCM CO-OP BANK LTD |
| 1668 | THE MTM CO-OP URBAN BANK LTD |
| 1669 | THE MUDALGI CO-OPERATIVE BANK LTD |
| 1670 | THE MUDALGI URBAN CO-OPERATIVE CREDIT BANK LTD |
| 1671 | THE MUDHOL CO-OPERATIVE BANK LTD |
| 1672 | THE MUGBERIA CENTRAL COOPERATIVE BANK LIMITED |
| 1673 | THE MULGUND URBAN SOUHARDA CO-OP BANK LTD |
| 1674 | THE MUNDUR SERVICE CO-OP BANK |
| 1675 | THE MURICKASSERY SERVICE CO-OP BANK |
| 1676 | THE MURSHIDABAD DISTRICT CENTRAL CO-OP BANK LTD |
| 1677 | THE MUVATTUPUZHA URBAN CO-OP BANK |
| 1678 | THE MYNAGAPPALLY VILLAGE SERVICE CO-OP BANK LTD |
| 1679 | THE MYSORE DISTRICT CO-OP CENTRAL BANK |
| 1680 | THE NADAKKAL SERVICE CO-OP BANK LTD |
| 1681 | THE NADIA CENTRAL CO-OP BANK LTD |
| 1682 | THE NADIAD PEOPLE CO-OP URBAN BANK LTD |
| 1683 | THE NAMAKKAL CO OPERATIVE URBAN BANK LTD |
| 1684 | THE NASIK LINE PHARMACEUTICALS LTD |
| 1685 | THE NAVODAYA URBAN CO-OPERATIVE BANK LTD |
| 1686 | THE NAWANSHAHR CENTRAL CO-OPERATIVE BANK LTD |
| 1687 | THE NEHRU NAGAR CO-OP BANK |
| 1688 | THE NELLAI NAGAR CO-OPERATIVE URBAN BANK LIMITED |
| 1689 | THE NESARGI URBAN CO-OPERATIVE CREDIT BANK LIMITED |
| 169  | RUPEE CO-OP BANK LTD,PUNE |
| 1690 | THE NICHOLSON CO-OP TOWN BANK LTD |
| 1691 | THE NILESHWAR SERVICE CO-OP BANK LTD |
| 1692 | THE NILGIRIS DISTRICT CENTRAL CO-OP BANK |
| 1693 | THE NIPHAD URBAN CO-OP BANK LTD |
| 1694 | THE NIZAMABAD DISTRICT CO-OP CENTRAL BANK LTD |
| 1695 | THE NKGSB COOP BANK LTD |
| 1696 | THE NMC BANK LTD |
| 1697 | THE NORTH ARCOT DISTRICT CENTRAL CO-OP BANK LTD |
| 1698 | THE NRDV BANK LTD |
| 1699 | THE ODE URBAN CO-OP BANK LTD |
| 170  | SHREE SUVARNA SAH.BANK LTD,PUNE |
| 1700 | THE ORIENTAL WESTERN BANK LTD |
| 1701 | THE ORISSA STATE CO-OPERATIVE BANK LTD |
| 1702 | THE PACHHAPUR URBAN CO-OP BANK LTD |
| 1703 | THE PALGHAT CO-OPERATIVE BANK LTD |
| 1704 | THE PALI CENTRAL COOP BANK LTD |
| 1705 | THE PALLIKKARA SERVICE CO-OP BANK LTD |
| 1706 | THE PANCHKULA CENTRAL CO-OP BANK LTD |
| 1707 | THE PANIPAT CENTRAL CO-OPERATIVE BANK LTD |
| 1708 | THE PANIPAT URBAN COOPERATIVE BANK LTD |
| 1709 | THE PAPANASAM CO-OP URBAN BANK LTD |
| 1710 | THE PARAKKOTTUKAVU PANCHAYAT SERVICE CO OP BANK LTD |
| 1711 | THE PARAMAKUDI CO-OP BANK LTD |
| 1712 | THE PARAMAKUDI CO-OP URBAN BANK LTD |
| 1713 | THE PATHANAMTHITTA DISTRICT CO-OP BANK LTD |
| 1714 | THE PATIALA CENTRAL CO-OP BANK LTD |
| 1715 | THE PATTAMBI SERVICE CO-OP BANK LTD |
| 1716 | THE PATTATHANAM SERVICE CO-OP BANK LTD |
| 1717 | THE PATTEPADAM RURAL CO-OPERATIVE SOCIETY LIMITED |
| 1718 | THE PATTUKOTTAI CO-OP URBAN BANK |
| 1719 | THE PEN CO-OP URBAN BANK LTD |
| 1720 | THE PERINTHALMANNA CO-OP URBAN BANK LTD |
| 1721 | THE PERIYAR DISTRICT CENTRAL CO-OP BANK LTD |
| 1722 | THE PEROORKADA SERVICE CO-OPERATIVE BANK LTD |
| 1723 | THE PERUMANNA SERVICE CO-OP BANK LTD |
| 1724 | THE PHALTAN URBAN COOP BANK LTD |
| 1725 | THE PIJ PEOPLES CO-OP BANK |
| 1726 | THE PIMPRI CHINCHWAD BANK LTD |
| 1727 | THE POLLACHI CO-OP URBAN BANK |
| 1728 | THE POORNAWADI NAGARIK SAHAKARI BANK LTD |
| 1729 | THE POOVATHUMKADAVIL FARMERS SERVICE CO-OP BANK |
| 173  | POONA CONTRACTOR CO-OP BANK LTD |
| 1730 | THE POSTAL AND RMS EMPLOYEES CO-OP BANK LTD |
| 1731 | THE PRAKASAM DIST CO-OPERATIVE CENTRAL BANK LTD |
| 1732 | THE PRAKASAPURAM CO-OP URBAN BANK |
| 1733 | THE PRERNA CO-OP BANK LTD |
| 1734 | THE PRODDATUR CO-OP BANK LIMITED |
| 1735 | THE PRODDATUR CO-OP TOWN BANK LIMITED |
| 1736 | THE PUDUKKOTTAI DIST CENTRAL CO-OPERATIVE BANK LTD |
| 1737 | THE PULLUR SERVICE CO-OP BANK LTD |
| 1738 | THE PUNALUR SERVICE COOP BANK LTD |
| 1739 | THE PURI URBAN CO-OPERATIVE BANK LTD |
| 1740 | THE PUTTUR CO-OPERATIVE TOWN BANK LTD |
| 1741 | THE QUILON CO-OPERATIVE URBAN BANK LTD |
| 1742 | THE RADDI CO-OP BANK LTD |
| 1743 | THE RADDI CO-OP CREDIT BANK LTD |
| 1744 | THE RADDI SAHAKARA BANK NIYAMITHA |
| 1745 | THE RADHASOAMI URBAN CO-OP BANK LTD |
| 1746 | THE RAICHUR DIST CO-OPERATIVE CENTRAL BANK LTD |
| 1747 | THE RAJAPUR SAHAKARI BANK LTD |
| 1748 | THE RAJWADE MANDAL PEOPLES CO-OPERATIVE BANK LTD |
| 1749 | THE RAMANATTUKARA SERVICE CO-OP BANK LTD |
| 1750 | THE RAMANTHAPURAM DISTRICT CENTRAL CO-OP BANK LTD |
| 1751 | THE RASIPURAM COOPERATIVE URBAN BANK |
| 1752 | THE RAYAT SEVAK CO-OP BANK LTD |
| 1753 | THE REGIONAL COOP BANK LTD |
| 1754 | THE REPATRIATES CO-OP FINANCE AND DEVELOPMENT BANK LTD |
| 1755 | THE RIDE BETTAMPADY SERVICE CO-OP BANK LTD |
| 1756 | THE ROHTAK CENTRAL CO-OPERATIVE BANK LTD |
| 1757 | THE ROSHAN COOP CREDIT SOCIETY LTD |
| 1758 | THE S T (EMP) CO-OPERATIVE BANK LTD |
| 1759 | THE S V COOP BANK LTD |
| 1760 | THE SADGURU JANGLI MAHARAJ SHAYARI BANK |
| 1761 | THE SAHEBRAO DESHMUKH CO-OPERATIVE BANK LTD |
| 1762 | THE SAHYADRI SAHAKARI BANK LTD |
| 1763 | THE SANGLI DIST CENTRAL CO-OPERATIVE BANK LTD |
| 1764 | THE SANTRAMPUR URBAN CO-OPERATIVE BANK LTD |
| 1765 | THE SATARA DIST CENTRAL CO-OPERATIVE BANK LTD |
| 1766 | THE SATARA DIST MERCHANTS CO-OP BANK LTD |
| 1767 | THE SECUNDERABAD MERCANTILE CO-OP BANK |
| 1768 | THE SHAHADA PEOPLES CO-OP BANK LTD |
| 1769 | THE SHIBPUR CO-OPERATIVE BANK LIMITED |
| 177  | KERALA STATE CO-OP BANK LTD,TRIVANDRUM |
| 1770 | THE SHIMOGA DIST CO-OP CENTRAL BANK LTD |
| 1771 | THE SHINGA DIST CENTRAL CO-OP BANK LTD |
| 1772 | THE SHIRPUR PEOPLES CO-OP BANK LTD |
| 1773 | THE SIND CO-OPERATIVE URBAN BANK LTD |
| 1774 | THE SINDAGI URBAN COOP BANK LTD |
| 1775 | THE SIRSI URBAN CO-OPERATIVE BANK LTD |
| 1776 | THE SIRSI URBAN SOUHARDA SAHAKARI BANK |
| 1777 | THE SIVAGANGAI DISTRICT CENTRAL CO-OP BANK LTD |
| 1778 | THE SIVAKASI CO-OPERATIVE URBAN BANK LTD |
| 1779 | THE SONEPAT CENTRAL CO-OPERATIVE BANK LTD |
| 178  | LORD KRISHNA BANK LTD,TRIVANDRUM |
| 1780 | THE SONEPAT URBAN CO-OP BANK LTD |
| 1781 | THE SRIVILLIPUTTUR CO-OP URBAN BANK LTD |
| 1782 | THE STAMP BHANDARI CO-OPERATIVE URBAN BANK LTD |
| 1783 | THE SUBRAMANYA NAGAR CO- OP URBAN BANK LTD |
| 1784 | THE SUNDARGARH DISTRICT CENTRAL CO-OP BANK |
| 1785 | THE SUTEX CO-OPERATIVE BANK LIMITED |
| 1786 | THE SUVIKAS PEOPLES CO-OP BANK LTD |
| 1787 | THE SWARNA CO-OP URBAN BANK LTD |
| 1788 | THE SWASAKTHI MERCANTILE URBAN COOP BANK LTD |
| 1789 | THE TALIKOTI URBAN COOP BANK LTD |
| 179  | NGP |
| 1790 | THE TAMILNADU CIRCLE POSTAL CO-OP BANK LTD |
| 1791 | THE TENALI CO-OP URBAN BANK LTD |
| 1792 | THE TEXTILE PROCESSORS CO-OP BANK LTD |
| 1793 | THE THADUKKASSERY SERVICE CO-OP BANK LTD |
| 1794 | THE THIRUCHENDUR CO-OP URBAN BANK LTD |
| 1795 | THE THOOTHUKUDI DIST CENTRAL CO-OP BANK LTD |
| 1796 | THE THURAIYUR CO-OP RURAL BANK LTD |
| 1797 | THE TIRUCHENGODE COOPERATIVE URBAN BANK LTD |
| 1798 | THE TIRUNELVELI CENTRAL CO-OPERATIVE BANK LTD |
| 1799 | THE TIRUNELVELI DISTRICT CENTRAL CO-OP BANK LTD |
| 180  | TRIVANDRUM DIST.CO-OP BANK LTD |
| 1800 | THE TIRUVANNAMALAI DISTRICT CENTRAL CO-OP BANK LTD |
| 1801 | THE TOWN CO-OPERATIVE BANK LTD |
| 1802 | THE UDMA SERVICE CO-OP BANK |
| 1803 | THE UDUMALPET CO-OPERATIVE URBAN BANK LTD |
| 1804 | THE UDUPI CO-OP TOWN BANK LTD |
| 1805 | THE URBAN DEVELOPMENT CO-OPERATIVE BANK LTD |
| 1806 | THE UTTAR PRADESH STATE CO-OPERATIVE BANK LTD |
| 1807 | THE UTTARPARA CO-OP BANK |
| 1808 | THE UTTARSANDA PEOPLES CO-OP BANK |
| 1809 | THE V V COMMERICAL CO-OP BANK LTD |
| 181  | NAGPUR URBAN CO-OP BANK LTD,NAGPUR |
| 1810 | THE VADAKARA CO-OP URBAN BANK LTD |
| 1811 | THE VADAKKEVILA SERVICE CO-OP BANK LTD |
| 1812 | THE VAIDYANATH URBAN CO-OP BANK LTD |
| 1813 | THE VAKKAM FARMERS SERVICE CO-OPERATIVE BANK LTD |
| 1814 | THE VALLABH VIDYANAGAR COMMERCIAL CO-OP BANK LTD |
| 1815 | THE VANI CO-OPERATIVE URBAN BANK LTD |
| 1816 | THE VANI MERCHANT CO-OP BANK LTD |
| 1817 | THE VANIYAMBADI TOWN CO-OPERATIVE BANK LTD |
| 1818 | THE VARADA GRAMEENA BANK |
| 1819 | THE VASO CO-OPERATIVE BANK LTD |
| 1820 | THE VELLALA CO-OPERATIVE BANK LTD |
| 1821 | THE VELLIAMATTOM SERVICE CO-OPERATIVE BANK LTD |
| 1822 | THE VERAVAL PEOPLES CO-OP BANK LTD |
| 1823 | THE VIDARBHA URBAN CO-OP BANK LTD |
| 1824 | THE VILLUPURAM DISTRICT CENTRAL CO-OP BANK LTD |
| 1825 | THE VIRAJPET PATTANA SAHAKARI BANK |
| 1826 | THE VIRUDHUNAGAR DISTRICT CENTRAL CO-OP BANK LTD |
| 1827 | THE VISAKHA CO-OP BANK LTD |
| 1828 | THE VITTAL GRAMIN SAHAKARI BANK |
| 1829 | THE VIZIANAGARAM CO-OP BANK |
| 1830 | THE WAHIM URBAN COOP BAN LTD |
| 1831 | THE WAYANAD DISTRICT CO-OPERATIVE BANK LTD |
| 1832 | THE WILTON BANK |
| 1833 | THE YAMUNANAGAR CENTRAL CO-OPERATIVE BANK LTD |
| 1834 | THE YARAGATTI URBAN CO-OPERATIVE BANK LTD |
| 1835 | THE YAVATMAL DISTRICT CENTRAL CO-OP BANK LTD |
| 1836 | THE YAVATMAL GRAMIN BANK |
| 1837 | THE YAVATMAL MAHILA SAHAKARI BANK LTD |
| 1838 | THE YAVATMAL URBAN CO-OPERATIVE BANK LTD |
| 1839 | THE YELLAPUR URBAN CO-OPERATIVE CREDIT SOCIETY LTD |
| 1840 | THE ZOROASTRIAN CO-OP BANK LTD |
| 1841 | TIRUMALA CO-OP URBAN BANK LTD |
| 1842 | TRICHY HIRUDAYAPURAM CO-OP BANK |
| 1843 | TRIVENI KSHETRIYA GRAMIN BANK |
| 1844 | TULSI GRAMIN BANK |
| 1845 | TUMKUR GRAIN MERCHANTS CO-OP BANK LIMITED |
| 1846 | TUMKUR PATTANA SAHAKARA BANK NIYAMITHA |
| 1847 | TUMKUR VEERASHAIVA CO-OPERATIVE BANK LTD |
| 1848 | TUNGABHADRA GRAMEEN BANK |
| 1849 | TUNGABHADRA PATTINA SAHAKARA SANGHA NIYAMITHA |
| 185  | U.P.CO-OP BANK LTD.KANPUR |
| 1850 | TUTICORIN MELUR CO-OP BANK |
| 1851 | U B K G BANK |
| 1852 | UMAN BANK OF INDIA |
| 1853 | UMIYA URBAN CO-OPERATIVE BANK |
| 1854 | UNION BANK OF ROORKEE |
| 1855 | UTHAMAPALAYAM CO-OP BANK |
| 1856 | UTHIRAMERUR CO-OP BANK |
| 1857 | UTTAR BANGA KSHETRIYA GRAMIN BANK |
| 1858 | UTTAR BIHAR KSHETRIYA GRAMIN BANK |
| 1859 | UTTAR PRADESH GRAMIN BANK |
| 186  | BENARAS STATE BANK LTD,DELHI |
| 1860 | V C C BANK |
| 1861 | V K G BANK |
| 1862 | V M C BANK LTD |
| 1863 | V V C C BANK LIMITED |
| 1864 | VADAKKENCHERRY COOP SERVICE BANK LTD |
| 1865 | VADODARA DIST CO-OP SAHAKARI BANK LTD |
| 1866 | VADODARA DIST INDUSTRIAL CO-OP BANK |
| 1867 | VAISHALI KSHETRIYA GRAMIN BANK |
| 1868 | VAISHYA NAGARI SAHAKARI BANK LTD |
| 1869 | VALAPAD SERVICE COOPERATIVE BANK LTD |
| 187  | BAREILLY CORPORATION BANK LTD |
| 1870 | VALLALAR GRAMA BANK |
| 1871 | VALSAD DISTRICT CO-OPERATIVE BANK LTD |
| 1872 | VANANCHAL GRAMIN BANK |
| 1873 | VARALAKSHMI CREDIT COOP SOCIETY |
| 1874 | VARALAKSHMI CREDIT SAHAKARA SANGHA LTD |
| 1875 | VASAI JANTA SAHAKARI BANK LTD |
| 1876 | VDS-BPL KSHETRIYA GRAMEENA BANK |
| 1877 | VEER PULIKESHI CO-OP BANK |
| 1878 | VEERASHAIVA SAHAKARI CO-OP BANK |
| 1879 | VEJALPUR NAGRIK BANK |
| 1880 | VELLOOR SERVICE CO-OP BANK |
| 1881 | VIDARBHA KSHETRIYA GRAMIN BANK |
| 1882 | VIDISHA BHOPAL KENDRIYA GRAMIN VIKAS BANK |
| 1883 | VIDUR GRAMIN BANK |
| 1884 | VIDYA SAHAKARI BANK LTD |
| 1885 | VIDYASAGAR CENTRAL CO-OP BANK LTD |
| 1886 | VIKAS CO-OPERATIVE BANK LTD |
| 1887 | VIKAS PURI NEW DELHI |
| 1888 | VIKAS SHARDA CO-OPERATIVE BANK LTD |
| 1889 | VIKAS URBAN CO-OPERATIVE BANK NIYAMITHA |
| 189  | JAIPUR CENTRAL BANK LTD, JAIPUR |
| 1890 | VIKHE PATIL CO-OP BANK LTD. |
| 1891 | VIMA KAMGAR COOPERATIVE BANK LTD |
| 1892 | VINDHYAVASINI GRAMIN BANK |
| 1893 | VIPUL |
| 1894 | VIRUDHACHALAM CO-OP URBAN BANK LTD |
| 1895 | VISHWAKARMA NAGARI SAHAKARI BANK |
| 1896 | VISHWESHWAR CO-OP BANK |
| 1897 | VMC |
| 1898 | VYAPARI VYAVASAYI CO-OPERATIVE SOCIETY LTD |
| 1899 | VYSYA CO-OPERATIVE BANK LTD |
| 1900 | WAINGANGA KSHETRIYA GRAMIN BANK |
| 1901 | WALCHANDNAGAR SAHAKARI BANK LTD |
| 1902 | WARANA SAHAKARI BANK LTD |
| 1903 | WARANGAL URBAN CO-OPERATIVE BANK LTD |
| 1904 | WARDHAMAN URBAN COOPERATIVE BANK LTD |
| 1905 | WASHINGTON MUTUAL BANK |
| 1906 | WBS CO-OPERATIVE BANK |
| 1907 | WELLS FARGO BANK |
| 1908 | YAVATMAL DIST MAHESH NAGARI SAHAKARI CO-OP BANK |
| 1909 | ZILA SAHAKARI BANK LIMITED |
| 191  | RAJASTHAN STATE INDL.CO-OP BANK LTD |
| 1910 | ZILA SAHAKARI GRAM VIKAS BANK |
| 1911 | THE CITY CO-OP. BANK LTD. |
| 1912 | COSMOS CO-OP BANK LTD,PUNE |
| 1913 | NAGAR URBAN CO-OP BANK LTD |
| 1914 | SULEMANI CO OP BANK LTD |
| 1915 | VIKAS SOUHARDHA CO OP BANK LTD |
| 1916 | ANZ |
| 1917 | DANSKE BANK |
| 1918 | THE CO-OPERATIVE BANK |
| 1919 | BHINGAR URBAN CO-OPERATIVE BANK LIMITED |
| 1920 | UNIVERSITY FEDERAL CREDIT UNION |
| 1921 | THE SANTANDER |
| 1922 | HANG SENG BANK |
| 1923 | CITADELE BANKA |
| 1924 | FIRST DIRECT |
| 1925 | RAJ STATE CO-OP BANK LTD |
| 1926 | JHARNESHWAR CO-OP BANK LTD |
| 1927 | EKM DISTRICT CO-OP BANK |
| 1928 | BANK AUSTRIA |
| 1929 | MANSAROVAR URBAN CO-OP BANK LTD |
| 193  | PRUDENTIAL CO-OP URBAN BANK LTD,HYDERABAD |
| 1930 | NIDHI CO OP BANK LIMITED |
| 194  | AMANATH CO-OP BANK LTD,BANGLORE |
| 197  | GRAIN MERCHANTS CO-OP BANK LTD |
| 1971 | IDFC Bank |
| 198  | TRIVANDRUM CO-OP URBAN BANK LTD |
| 199  | CHITANVISPURA FRIENDS CO-OP BANK LTD |
| 2001 | Chennai Super Kings - CSK |
| 2002 | Mumbai Indians |
| 201  | SHREE MAHALAXMI MER.CO-OP BANK LTD |
| 203  | NUTAN SAHAKARI BANK LTD |
| 204  | UNNATI CO-OP BANK LTD |
| 205  | MASHREQBANK PSC |
| 206  | NAGPUR DIST.CENTRAL CO-OP BANK LTD |
| 207  | SADHANA SAHAKARI BANK LTD |
| 210  | OMAN INTERNATIONAL BANK SAOG |
| 212  | UFJ BANK LTD |
| 213  | BIHAR STATE CO-OP BANK LTD |
| 214  | MAHILA UTKARSHA NAGARIK SAH. BANK LTD,AHMEDABAD |
| 216  | SABARMATI CO-OP BANK LTD,AHMEDABAD |
| 218  | ORRISA STATE CO-OP BANK LTD,BHUBANESHWAR |
| 219  | NEELANCHAL GRAMYA BANK, BHUBNESHWAR |
| 220  | URBAN CO-OP BANK LTD,BHUBANESHWAR |
| 221  | UTKAL CO-OP BANKING SOCIETY,BHUBANESHWAR |
| 222  | A.P. VARDHAMAN (MAHILA) CO-OP BANK LTD |
| 223  | CHARMINAR CO-OP BANK,HYDERABAD |
| 227  | MALLESWARAN CO-OP BANK LTD,BANGLORE |
| 228  | KARNATAKA INDUSTRIAL CO-OP BANK LTD,BANGLORE |
| 230  | GLOBAL TRUST BANK LTD |
| 231  | CREDIT LYONNAIS |
| 232  | THE SINDH MERCANTILE CO-OP BANK LTD |
| 233  | CENTURION BANK LTD |
| 236  | VISNAGAR NAGRIK SAH.BANK LTD |
| 237  | BANK OF PUNJAB LTD |
| 241  | DIAMOND JUBILEE CO-OP BANK LTD,SURAT |
| 243  | THE RANDER PEOPLES CO-OP BANK LTD,SURAT |
| 247  | SURAT NAGRIK SAHAKARI BANK LTD |
| 252  | NAGPUR MAHILA NAG.SAH.BANK LTD |
| 253  | TIMES BANK LTD |
| 254  | SURAT MAHILA NAG. SAH. BANK LTD |
| 258  | SIDDI CO-OP BANK LTD, AHMEDABAD |
| 260  | THE TEXTILE CO-OP BANK LTD,BANGLORE |
| 261  | SHRI M.VISVESVASRAYA CO-OP BANK LTD, BANGLORE |
| 262  | DEEPAK SAHAKARI BANK LTD |
| 263  | THE MYSORE SILK CLOTH MERCHANTS CO-OP BANK LTD,BANGLORE |
| 264  | VEERASHAIVA CO-OP BANK LTD |
| 265  | HANUMANTHNAGAR CO-OP BANK LTD,BANGLORE |
| 266  | RAJAJINAGAR CO-OP BANK LTD, BANGLORE |
| 267  | MAHILA CO-OP BANK LTD, BANGLORE |
| 270  | SURYAPUR CO-OP BANK LTD, SURAT |
| 271  | THE TEXTILE CO-OP BANK OF SURAT LTD |
| 273  | SIKKIM BANK LTD |
| 274  | THE BHARAT CO-OPERATIVE BANK (MUMBAI) LTD |
| 276  | SOCIETE GENERALE |
| 277  | HINDU NAG. SAH. BANK LTD, INDORE |
| 282  | MAHARASHTRA BRAHMAN SAH. BANK LTD, INDORE |
| 284  | PARASPAR SAHAYAK CO-OP BANK LTD, INDORE |
| 285  | SHUBH-LAXMI MAHILA CO-OP BANK LTD, INDORE |
| 286  | TRANSPORT CO-OP BANK LTD, INDORE |
| 288  | RESERVE BANK EMPLOYEES CO-OP BANK LTD, BANGLORE |
| 290  | THE UDHANA CITIZEN CO-OP BANK LTD, SURAT |
| 292  | SRI BHAGAVATI CO-OP BANK LTD, MANGLORE |
| 293  | MAHALAKSHMI CO-OP BANK LTD, UDIPI |
| 294  | SRI GOKARNANATH CO-OP BANK LTD, MANGLORE |
| 295  | THE MANGLORE CO-OP TOWN BANK LTD, MANGLORE |
| 296  | JALANDHAR CENTRAL CO-OP BANK LTD |
| 298  | THE SOUTH CANARA DIST. CENTRAL CO-OP BANK LTD,MANGLORE |
| 299  | DISTRICT CO-OP BANK LTD,VARANASI |
| 300  | NAGARIYA CO-OP BANK LTD, VARANASI |
| 301  | MANGLORE CATHOLIC CO-OP BANK LTD,MANGLORE |
| 306  | MADURAI DISTRICT CENTRAL CO-OP BANK LTD,MADURAI |
| 316  | SHRI KRISHNA SAHAKARI BANK LTD, BARODA |
| 317  | BARODA MERCANTILE CO-OP BANK LTD |
| 318  | COMMERCIAL CO-OP BANK LTD,BARODA |
| 319  | SANKHEDA NAG.SAH.BANK LTD,BARODA |
| 321  | SHRI SWAMINARAYAN CO-OP BANK LTD,BARODA |
| 324  | DABHOI NAG.SAH.BANK LTD,BARODA |
| 325  | SULAIMANI CO-OP BANKING SOCIETY LTD,BARODA |
| 326  | SHRI CO-OP BANK LTD,BARODA |
| 327  | MADURA SOURASHTRA CO-OP BANK LTD,MADURAI |
| 330  | AKOLA URBAN CO-OP BANK LTD |
| 333  | AMRITSAR CENTRAL CO-OP BANK LTD |
| 334  | GANESH BANK OF KURUNDWAD LTD,PUNE |
| 336  | VIDISHA-BHOPAL KSHETRIYA GRAMIN BANK |
| 337  | GURDASPUR-AMRITSAR KSHETRIYA GRAMIN VIKAS BANK |
| 338  | APEX CO-OP BANK OF URBAN BANKS OF MAHARASHTRA AND GOA LTD |
| 339  | BHOPAL NAGRIK SAHAKARI BANK LTD,BHOPAL |
| 340  | ASTHA MAHILA NAGRIK SAHAKARI BANK MARYADIT,BHOPAL |
| 341  | MAHANAGAR NAGRIK SAHAKARI BANK MARYADIT,BHOPAL |
| 342  | VAISHALI URBAN CO-OP BANK LTD, JAIPUR |
| 343  | CHAROTAR NAGRIK SAHAKARI BANK LTD,ANAND |
| 347  | SHREE VIKAS CO-OP BANK LTD,SURAT |
| 354  | UDYAM VIKAS SAHAKARI BANK LTD,PUNE |
| 356  | JIJAMATA MAHILA SAHAKARI BANK LTD,PUNE |
| 357  | SHREE SADGURU JANGALI MAHARAJ SAHAKARI BANK LTD,PUNE |
| 359  | ROPAR CENTRAL CO-OP BANK LTD,ROPAR-CHANDIGARH |
| 360  | GANDHIBAGH SAHAKARI BANK LTD,NAGPUR |
| 362  | BANK MUSCAT  SAOG |
| 365  | SHRIRAM URBAN CO-OP BANK LTD,NAGPUR |
| 366  | PARMATMA EK SEVAK NAGRIK SAHAKARI BANK LTD,NAGPUR |
| 368  | MITRA MANDAL SAHAKARI BANK LTD,INDORE |
| 370  | NASIK PEOPLES CO-OP BANK LTD,NASIK |
| 371  | NASIK ZILHA MAHILA SAHAKARI BANK LTD,NASIK |
| 377  | NASIK DISTRICT INDUSTRIAL AND MERCANTILE CO-OP BANK LTD |
| 378  | SHRIRAM SAHAKARI BANK MARYADIT, NASIK |
| 379  | LUDHIANA CENTRAL CO-OP BANK LTD,LUDHIANA |
| 380  | TAPI CO-OP BANK LTD,SURAT |
| 381  | NASIK JILHA MAHILA VIKAS SAHAKARI BANK LTD,NASIK |
| 382  | SHREE SINNAR VYAPARI SAHAKARI BANK LTD, SINNAR |
| 383  | THE CITIZEN CO-OP BANK LTD,NEW DELHI |
| 384  | TRICHUR URBAN CO-OP BANK LTD, TRICHUR |
| 385  | INDIAN MERCANTILE CO-OP BANK LTD |
| 388  | KOLHAPUR JANATA SAHAKARI BANK LTD,KOLHAPUR |
| 391  | SHRI SHAHU CO-OP BANK LTD, KOLHAPUR |
| 392  | SHRI BALBHIM CO-OP BANK LTD, KOLHAPUR |
| 395  | CHOUNDESHWARI CO-OP BANK LTD, KOLHAPUR |
| 396  | SHRIPATRAO DADA SAHAKARI BANK LTD,KOLHAPUR |
| 399  | KOLHAPUR MARATHA CO-OP BANK LTD, KOLHAPUR |
| 400  | THE RAVI CO-OP BANK LTD, KOLHAPUR |
| 405  | THE ICHALKARANJI URBAN CO-OP BANK LTD,ICHALKARANJI |
| 406  | JANATA SAHAKARI BANK LTD |
| 410  | JAMIA CO-OP BANK LTD, NEW DELHI |
| 411  | TAMILNADU INDUSTRIAL CO-OP BANK LTD, CHENNAI |
| 414  | GOAN PEOPLES URBAN CO-OP BANK LTD, PANAJI-GOA |
| 419  | FINANCIAL CO-OP BANK LTD, SURAT |
| 423  | PANDYAM GRAMA BANK |
| 425  | SRI SATYA SAI NAGRIK SAHAKARI BANK MARYADIT, BHOPAL |
| 426  | STERLING URBAN CO-OP BANK LTD,JAIPUR |
| 427  | MADURAI URBAN CO-OP BANK LTD, MADURAI |
| 428  | STANDARD CO-OP BANK LTD, AHMEDABAD |
| 429  | SACHIN INDUSTRIAL CO-OP BANK LTD, SURAT |
| 430  | ADAJAN NAGRIK SAHAKARI BANK LTD, SURAT |
| 431  | ROYALE CO-OP BANK LTD, SURAT |
| 432  | ADINATH CO-OP BANK LTD, SURAT |
| 433  | SAMATA SAHAKARI BANK LTD, NAGPUR |
| 435  | THE CENTURY CO-OP BANK LTD, SURAT |
| 436  | THE METRO CO-OP BANK LTD, SURAT |
| 437  | AKHAND ANAND CO-OP BANK LTD, SURAT |
| 438  | THE ANDHRA BANK EMPLOYEES CO-OP BANK LTD |
| 439  | ROYAL CO-OP BANK LTD, AHMEDABAD |
| 440  | CITY CO-OP BANK LTD, LUCKNOW |
| 442  | SHREE DHARTI CO-OP BANK LTD, RAJKOT |
| 444  | RAJKOT MAHILA NAG. SAH. BANK LTD, RAJKOT |
| 446  | SREE CHARAN CO-OP BANK LTD, BANGLORE |
| 447  | UNITED COMMERCIAL CO-OP BANK LTD, KANPUR |
| 449  | ASSOCIATE CO-OP BANK LTD, SURAT |
| 450  | NAGRIK SAMABAY BANK LTD, GUWAHATI |
| 451  | THE WOMENS CO-OP BANK LTD, PANJI, GOA |
| 452  | THE ERNAKULAM DISTRICT CO-OP BANK LTD, ERNAKULAM |
| 453  | DEVLOPMENT CO-OP BANK LTD, KANPUR |
| 455  | SREE SUBRAMANYESWARA CO-OP BANK LTD, BANGLORE |
| 456  | INTEGRAL URBAN CO-OP BANK LTD, JAIPUR |
| 457  | ANKLESHWAR NAGRIK SAHAKARI BANK LTD. (VADODARA) |
| 458  | GEORGE TOWN CO-OP BANK LTD, CHENNAI |
| 461  | AGRA DISTRICT CO-OP BANK LTD, AGRA |
| 462  | JAMUNA GRAMIN BANK, AGRA |
| 463  | MALVIYA URBAN CO-OP BANK LTD, JAIPUR |
| 464  | COIMBATORE DISTRICT CENTRAL CO-OP BANK LTD, COIMBATORE |
| 466  | THE ALWAYE URBAN CO-OP BANK LTD |
| 467  | COIMBATORE CITY CO-OP BANK LTD, COIMBATORE |
| 468  | VIJAY COMMERCIAL CO-OP BANK LTD, RAJKOT |
| 469  | VISAKHAPATNAM CO-OP BANK LTD,VISAKHAPATNAM |
| 471  | CITIZENS CO-OP BANK LTD, RAJKOT |
| 475  | SHREE PARSWANATH CO-OP BANK LTD, RAJKOT |
| 476  | JILA SAHAKARI KENDRIYA BANK MARYADIT, JABALPUR |
| 477  | IMPERIAL URBAN CO-OP BANK LTD,JALANDHAR |
| 478  | TEACHERS CO-OP BANK LTD, MANGALORE |
| 479  | JILA SAHAKARI CENTRAL BANK MARYADIT, GWALIOR |
| 481  | THRISSUR DISTRICT CO-OP BANK LTD, THRISSUR |
| 482  | KSHETRIYA GRAMIN BANK, HOSHANGABAD |
| 484  | ALLAHABAD KSHETRIYA GRAMIN BANK, ALLAHABAD |
| 487  | BANARAS MERCANTILE CO-OP BANK LTD, VARANASI |
| 489  | GWALIOR DATIA KSHETRIYA GRAMIN BANK, GWALIOR |
| 490  | ALLAHABAD DISTRICT CO-OP BANK LTD, ALLAHABAD |
| 492  | INDIRA PRIYADARSHINI MAHILA NAG.SAH.BANK MARYADIT |
| 494  | RAIPUR URBAN MERCANTILE CO-OP BANK LTD, RAIPUR |
| 496  | NAGRIK SAHAKARI BANK LTD, RAIPUR |
| 498  | KOZHIKODE DISTRICT CO-OP BANK LTD, KOZHIKODE (CALICUT) |
| 499  | KERALA MERCANTILE CO-OP BANK LTD, CALICUT |
| 5000 | ICIICIBANK |
| 501  | CALICUT CO-OP URBAN BANK LTD, CALICUT |
| 5010 | ICIICIBANK10 |
| 5013 | ICIICIBANK13 |
| 5014 | ICIICIBANK14 |
| 5025 | ICIICIBANK25 |
| 505  | SHRI GANESH SAHAKARI BANK LTD, NASIK |
| 5050 | ICIICIBANK |
| 506  | PADMASHRI DR. VITHALRAO VIKHE PATIL CO-OP BANK LTD |
| 509  | NASIK ZILLA GIRNA SAHAKARI BANK LTD, NASIK |
| 510  | JANASEVA CO-OP BANK LTD, NASIK |
| 511  | DR.BABASAHEB AMBEDKAR SAH. BANK LTD, NASIK |
| 515  | SRI VISAKHA GRAMEENA BANK, SRIKAKULAM |
| 516  | THAR ANCHALIK GRAMIN BANK, JODHPUR |
| 517  | JODHPUR CENTRAL CO-OP BANK LTD, JODHPUR |
| 518  | PIMPALGAON MERCHANTS CO-OP BANK LTD, NASIK |
| 519  | THE DISTRICT CO-OP CENTRAL BANK LTD, VISAKHAPATNAM |
| 520  | FEROKE CO-OP URBAN BANK LTD, CALICUT |
| 523  | SHRI VITRAG CO-OP BANK LTD, SURAT |
| 526  | DR. AMBEDKAR NAGRIK  SAHAKARI  BANK MARYADIT, GWALIOR |
| 527  | THE BAGHAT URBAN CO-OP BANK LTD, H.O. SOLAN(H.P) |
| 528  | THE KANAKAMAHALAKSHMI CO-OP BANK LTD, VISHAKHAPATNAM |
| 529  | DURG-RAJNANAGAON GRAMIN BANK, BHILAI |
| 530  | PRAGATI MAHILA NAGARIK SAHAKARI BANK LTD., BHILAI NAGAR |
| 531  | BHILAI NAGARIK SAHAKARI BANK LTD.,BHILAI NAGAR |
| 533  | VIKRAMADITYA NAGARIK SAHAKARI BANK LTD |
| 534  | CITIZEN CO-OP BANK LTD, M.P. |
| 535  | DEENDAYAL NAGARIK SAHAKARI BANK LTD. |
| 536  | UJJAIN PARASPAR SAHAKARI BANK LTD, UJJAIN |
| 537  | UJJAIN AUDYOGIK VIKAS NAGARIK SAHAKARI BANK LTD, UJJAIN |
| 538  | BHARAT HEAVY ELECTRICALS EMPLOYEES CO-OP BANK LTD |
| 539  | ANANDESHWARI NAGARIK SAHAKARI BANK LTD., UJJAIN |
| 540  | JILA SAHAKARI KENDRIYA BANK LTD |
| 541  | DEHRADUN DISTRICT CO-OP BANK, DEHRADUN |
| 542  | URBAN CO-OP BANK, DEHRADUN |
| 543  | DOON VALLEY URBAN CO-OP BANK, DEHRADUN |
| 546  | UJJAIN NAGARIK SAHAKARI BANK LTD., UJJAIN |
| 547  | TRICHIRAPALLI DISTRICT CENTRAL CO-OP BANK LTD, TIRUCHI |
| 548  | BASTAR KSHETRIYA GRAMIN BANK, JAGDALPUR |
| 549  | JILA SAHAKRI KENDRIYA BANK, JAGDALPUR |
| 550  | NAGARIK SAHAKARI BANK, JAGDALPUR |
| 551  | JILA SAHAKARI KENDRIYA BANK LTD., BETUL (M.P.) |
| 552  | BETUL NAGARIK SAHAKARI BANK LTD., BETUL (M.P.) |
| 553  | TRICHIRAPALLI CITY CO-OP BANK LTD, TIRUCHI (TAMIL NADU) |
| 555  | CUTTACK GRAMYA BANK, CUTTACK |
| 556  | SHRAMIK NAGARIK SAHAKARI BANK LTD., INDORE |
| 557  | BILASPUR NAGARIK SAHAKARI BANK, BILASPUR |
| 558  | BILASA MAHILA NAGARIK SAHAKARI BANK, BILASPUR |
| 559  | CHOUNDESHWARI CO-OP BANK LTD, ICHALKARANJI, KOLHAPUR (M.S.) |
| 560  | VASANTDADA SHETKARI SAHAKARI BANK LTD. , SANGLI (M.S.) |
| 563  | MAHISHMATI NAGARIK SAHAKARI BANK LTD., MANDLA (M.P.) |
| 565  | MYSORE MERCHANTS CO-OPERATIVE BANK LTD., MYSORE |
| 566  | SRI KANYAKAPARAMESWARI CO-OP. BANK LTD., MYSORE |
| 567  | GRADUATE CO-OPERATIVE BANK LTD., MYSORE |
| 568  | CAUVERY GRAMEENA BANK , MYSORE |
| 569  | PEOPLES CO-OPERATIVE BANK LTD.HINGOLI,DIST.AURANGABAD (M.S) |
| 571  | ERODE CO-OP. URBAN BANK LTD., ERODE (TAMILNADU) |
| 572  | ERODE DIST. CENTRAL CO-OP BANK LTD., ERODE |
| 573  | MYSORE AND CHAMARAJNAGAR DIST. CO-OP. BANK LTD., MYSORE |
| 575  | MADHAV NAGARIK SAHAKARI BANK LTD., UDAIPUR |
| 576  | RAJSAMAND URBAN CO-OP.BANK LTD., UDAIPUR |
| 577  | UDAIPUR URBAN CO-OP. BANK LTD., UDAIPUR |
| 578  | UDAIPUR CENTRAL CO-OP. BANK LTD., UDAIPUR |
| 579  | AURANGABAD DIST. CENTRAL CO-OP.BANK LTD., AURANGABAD (M.S.) |
| 580  | MEWAR AANCHALIK GRAMIN BANK, UDAIPUR |
| 581  | UDAIPUR MAHILA URBAN CO-OP. BANK LTD. UDAIPUR |
| 585  | GAUTAM SAHAKARI BANK LTD., GAUTAMNAGAR(DIST.AHMEDNAGAR)M.S. |
| 586  | SOLAPUR DIST., CENTRAL CO-OP. BANK LTD., SOLAPUR (M.S.) |
| 588  | PANDHARPUR URBAN CO-OP. BANK LTD., SOLAPUR (M.S.) |
| 589  | SOLAPUR SIDDEHWAR SAHAKARI BANK LTD.,SOLAPUR (M.S) |
| 590  | SOLAPUR SOCIAL URBAN CO-OP.BANK LTD., SOLAPUR (M.S.) |
| 591  | VIKAS SAHAKARI BANK LTD., SOLAPUR (M.S.) |
| 592  | VYAPARI SAHAKARI BANK LTD., SOLAPUR (M.S.) |
| 593  | BRAHMADEODADA MANE SAHAKARI BANK LTD., SOLAPUR (M.S.) |
| 594  | INDIRA SHRAMIK MAHILA NAGARI SAHAKARI BANK SOLAPUR (M.S.) |
| 595  | ARJUN URBAN CO-OP. BANK LTD., SOLAPUR (M.S.) |
| 596  | MANORAMA CO-OP. BANK LTD., SOLAPUR (M.S.) |
| 598  | MAHESH URBAN CO-OP. BANK LTD., SOLAPUR (M.S.) |
| 599  | OSMANABAD JANTA SAHAKARI BANK LTD.SOLAPUR(M.S.) |
| 600  | NILKANTH URBAN CO-OP. BANK LTD., SOLAPUR (M.S.) |
| 6001 | ICIICIBANK1 |
| 601  | VITA MERCHANTS CO-OP. BANK LTD., SOLAPUR (M.S.) |
| 602  | VIDYANANAD CO-OP. BANK LTD., SOLAPUR (M.S.) |
| 603  | SHRI MAHAVEER URBAN CO-OP. BANK LTD., SOLAPUR (M.S.) |
| 605  | KAMALA CO-OP. BANK LTD., SOLAPUR (M.S.) |
| 607  | SHARAD NAGARI SAHAKARI BANK LTD., SOLAPUR (M.S.) |
| 609  | BELGAUM DIST. CENTRAL CO-OP. BANK LTD., BELGAUM (M.S.) |
| 610  | UDAIPUR MAHILA SAMRIDHI URBAN CO-OP. BANK LTD., UDAIPUR |
| 611  | NAGAR SAHAKARI BANK LTD., GORAKHPUR (U.P.) |
| 612  | LAXMI CO-OPERATIVE BANK LTD.,  SOLAPUR |
| 613  | SOLAPUR NAGRI AUDHYOGIK SAHAKARI BANK |
| 614  | MANIPUR RURAL BANK, IMPHAL (MANIPUR) |
| 616  | KOTA CENTRAL CO-OP. BANK LTD., KOTA |
| 617  | KOTA NAGRIK SAHAKARI BANK LTD., KOTA(RAJASTHAN) |
| 618  | MEGHALAYA CO-OP. APEX BANK LTD., SHILLONG (MEGHALAYA) |
| 620  | KA BANK NONGKYNDONG RI KHASI JAINTIA , SHILLONG |
| 623  | BHILWARA URBAN CO-OP. BANK LTD., BHILWARA |
| 624  | SALEM DIST. CENTRAL CO-OP. BANK LTD. |
| 625  | SALEM URBAN CO-OP. BANK LTD., SALEM(TAMIL NADU) |
| 626  | SURAMANIANAGAR CO-OP.URBAN BANK LTD. , SALEM (TAMIL NADU) |
| 627  | SHEVAPET URBAN CO-OP. BANK LTD. , SALEM (TAMIL NADU) |
| 628  | AMMAPET URBAN CO-OP. BANK LTD., SALEM (TAMIL NADU) |
| 629  | TIRUPUR CO-OP. URBAN BANK LTD. , TIRUPUR (TAMIL NADU) |
| 630  | CENTRAL CO-OP. BANK LTD., BHILWARA |
| 631  | BHILWARA MAHILA URBAN CO-OP. BANK LTD., BHILWARA |
| 632  | PONDICHERRY STATE CO-OP. BANK LTD., PONDICHERRY |
| 633  | PONDICHERRY CO-OP.URBAN BANK LTD., PONDICHERRY |
| 634  | ELURI CO-OP. URBAN BANK LTD., GUNTUR |
| 635  | GUNTUR DIST. CO-OP. CENTRAL BANK LTD., TENALI (A.P.) |
| 636  | NAGALAND STATE CO-OP. BANK LTD., DIMAPUR (NAGALAND) |
| 637  | TRIPURA STATE CO-OP. BANK LTD., AGARTALA (TRIPURA) |
| 638  | ARUNNACHAL PRADESH STATE CO-OP. APEX BANK LTD., ITANAGAR |
| 640  | HINDUSTAN CO-OP. BANK LTD.,LUCKNOW (U.P.) |
| 642  | JAMMU RURAL BANK, SHAKTI NAGAR, JAMMU |
| 643  | RANCHI KHUNTI CENTRAL CO-OP. BANK LTD. SHAHEED CHOWK, RANCHI |
| 644  | ELLAQUAI DEHATI BANK, JAMMU |
| 645  | THE JAMMU CENTRAL CO-OPERATIVE BANK LTD. |
| 646  | RAILWAY EMPLOYEES CO-OP BANK LTD., JODHPUR |
| 648  | SINGHBHUM DIST. CENTRAL CO-OP. BANK LTD.,JHARKHAND |
| 649  | GANDHI CO-OP URBAN BANK LTD., VIJAYAWADA |
| 650  | KRISHNA DIST CO-OP. CENTRAL BANK LTD., VIJAYAWADA |
| 651  | DURGA CO-OP. URBAN BANK LTD., VIJAYAWADA |
| 652  | COASTAL LOCAL AREA BANK LTD. |
| 654  | J AND K STATE CO-OP. BANK LTD., SRINAGAR |
| 655  | PALLAVAN GRAMA BANK, SALEM |
| 656  | ANDAMAN AND NICOBAR CO-OP. BANK LTD., PORTBLAIR |
| 657  | SIKKIM STATE CO-OP. BANK LTD., GANGTOK |
| 660  | CITIZEN COOPERATIVE BANK ,  JAMMU |
| 661  | LOKVIKAS NAGARI SAHAKARI BANK LTD. |
| 663  | STATE BANK OF TRIVANDRUM |
| 664  | SANDUR PATTANA BANK |
| 665  | HASSAN BANK LTD |
| 666  | KRISHNA GRAMEENA BANK |
| 667  | THE AHMEDNAGAR MERCHANTS CO-OP. BANK LTD |
| 668  | CHHATISGARH GRAMIN BANK |
| 669  | REWA SIDHI GRAMIN BANK |
| 670  | LLOYDS TSB |
| 671  | NATWEST |
| 672  | THE ROYAL BANK OF SCOTLAND |
| 673  | ELLAQUAI DEHATI BANK |
| 674  | SHIVPURI-GUNA KSHETRIYA GRAMEENA BANK HAT ROAD |
| 675  | SRI VISAKHA GRAMEENA BANK |
| 676  | JPMORGAN CHASE BANK |
| 677  | MAHAVEER CO-OP URBAN BANK LTD |
| 678  | OSUUSPANKKI |
| 679  | ALIGARH GRAMIN BANK |
| 680  | ANDHRA PRAGATI GRAMEENA BANK |
| 681  | ANNASAHEB MAGAR SAH.BANK |
| 682  | BALASORE BHADRAK CENTRAL CO OP BANK LTD |
| 683  | BARODA EASTERN UTTAR PRADESH GRAMIN BANK |
| 684  | BHARAT URBAN CO-OP. BANK LTD. |
| 685  | BHATKAL URBAN CO-OP BANK |
| 686  | CHAMBAL KSHETRIY GRAMIN BANK |
| 687  | DEVELOPMENT CO-OP BANK LTD |
| 688  | DOMBIVALI NAGARI SAH BANK LTD |
| 689  | GANGA YAMUNA GRAMIN BANK |
| 690  | GODHRA URBAN CO OPERATIVE BANK LTD |
| 691  | GONDAL NAGRIK SAH. BANK LTD. (SU MEMBER OF RDCC) |
| 692  | GORAKHPUR KSHETRIY GRAMIN BANK |
| 695  | KASHI GOMIT SAMYUT GRAMIN BANK |
| 698  | NOIDA COMMERCIAL COOP BANK LTD |
| 700  | PEOPLES URBAN CO OPERATIVE BANK LTD |
| 7000 | ICIICIBANK |
| 701  | PRATHAMA BANK |
| 702  | PRIMARY AGRICULTURE CO OPERATIVE BANK LTD |
| 704  | RATNAKAR CO-OP BANK LTD. |
| 705  | SANGLI URBAN CO.OP. BANK |
| 707  | SREE THYAGARAJA CO OPERATIVE BANK LTD |
| 708  | SULTAN BATHERY CO OP URBAN BANK |
| 709  | THE ALMORA CO OPERATIVE BANK LTD |
| 710  | THE DAHOD MERCANTILE CO OP BANK LTD |
| 711  | THE DAHOD URBAN CO OP BANK LTD |
| 712  | THE EXCELLENT CO-OP.BANK LTD.(SCO) |
| 713  | THE GANDHINAGAR NAGARIK CO OP BANK LTD |
| 714  | THE GOBICHETTIPALAYAM CO OP URBAN BANK LTD |
| 715  | THE KASARGOD DISTRICT CO OPERATIVE BANK LTD |
| 716  | THE KODUNGALLUR TOWN CO OP BANK LTD |
| 717  | THE KURUNDWAD URBAN CO OP BANK LTD |
| 718  | THE MALAPPURAM SERVICE CO OP BANK LTD |
| 719  | THE SANGRUR CENTRAL CO OPERATIVE BANK LTD |
| 720  | THE UMRETH URBAN CO OPERATIVE BANK LTD |
| 721  | THE VELLORE DISTRICT CENTRAL CO OP BANK LTD |
| 722  | THE WAI URBAN CO-OP BANK LTD |
| 724  | THODUPUZHA URBAN CO OPERATIVE BANK LTD |
| 726  | UNITED MERCANTILE CO-OP. BANK LTD. |
| 727  | PUNJAB GRAMIN BANK |
| 728  | CHINA TRUST COMMERCIAL BANK |
| 729  | MIZUHO CORPORATE BANK LTD |
| 730  | DICGC |
| 731  | CREDIT AGRICOLE CORPORATE AND INVESTEMENT BANK |
| 732  | BNP PARIBAS |
| 734  | NKGSB CO-OP BANK LTD |
| 735  | THE TAMILNADU STATE APEX COOPERATIVE BANK LIMITED |
| 736  | ABN AMRO BANK |
| 737  | OCBC BANK |
| 738  | POSBANK |
| 739  | VASAI JANATA SAHAKARI BANK LTD |
| 741  | JALGOAN JANATA CO-OP BANK |
| 742  | ANNASAHEB JANATA SAHAKARI BANK LTD |
| 743  | CO-OPERATIVE BANK OF INDIA |
| 744  | ABHINANDAN URBAN CO-OP BANK |
| 745  | ADAYAPAKA URBAN CO-OP BANK LTD |
| 747  | AGRASEN URBAN CO-OP BANK |
| 748  | AGRASEN NAGARI SAHAKARI CO-OP CREDIT SOCIETY LTD |
| 749  | AJANTA URBAN CO-OP BANK LTD |
| 752  | SHRI AKHAND ANAND CO-OP BANK LTD |
| 753  | ALAVI CO-OP BANK LTD |
| 754  | ALAPPUZHA DISTRICT CO-OP BANK LTD |
| 755  | ALIBAG CO-OPERATIVE URBAN BANK LTD |
| 757  | ABHINANDAN SAHAKARI BANK NIYAMIT |
| 758  | ABHIVRUDDHI MAHILA SAHAKARA BANK |
| 759  | ACCOUNTANT GENERAL OFFICE EMPLOYEES CO-OP BANK |
| 760  | ADCC BANK |
| 762  | AGRASEN NAGARIK SAHAKARI BANK LTD |
| 763  | AGROHA CO OP URBAN BANK LTD |
| 764  | AHMEDNAGAR DIST CENTRAL CO OP BANK LTD |
| 766  | AJIT SAHAKARI BANK LTD |
| 767  | AJRA URBAN COOP BANK LTD |
| 768  | AKOT URBAN CO-OP BANK |
| 769  | AL FATAH CREDIT COOP SOCIETY LTD |
| 770  | ALAKNANDA GRAMIN BANK |
| 771  | ALASKA USA FEDERAL CREDIT UNION |
| 772  | ALIGARH ZILA SAHAKARI BANK LIMITED |
| 773  | ALWAR URBAN CO OPERATIVE BANK LTD |
| 774  | AMARNATH CO OP BANK LTD |
| 775  | AMBAJOGAI PEOPLES CO-OP BANK |
| 776  | AMBALA KURUKSHETRA GRAMIN BANK |
| 777  | AMBALAPAD SERVICE CO-OPERATIVE BANK LTD |
| 778  | AMBARNATH JAI HIND COOPERATIVE BANK LTD |
| 779  | AMBIKA URBAN CO-OP BANK LTD |
| 780  | AMCO BANK |
| 781  | ANAND MERCANTILE COOPERATIVE BANK LTD |
| 782  | ANANTAPUR DIST CO-OPERATIVE BANK |
| 783  | ANANYA CO-OP BANK LTD |
| 784  | ANDARSUL URBAN CO-OP BANK |
| 785  | ANDHRA PRADESH GRAMEENA VIKAS BANK LTD |
| 786  | ANJARAKANDY FARMERS SERVICE CO-OP BANK |
| 787  | ANKLESHWAR UDYOGNAGAR CO-OP BANK LTD |
| 788  | ANNASAHEB PATIL URBAN CO-OP BANK LTD |
| 789  | ANYONYA CO-OPERATIVE BANK LTD |
| 790  | AP RAJA RAJESHWARI MAHILA CO-OP URBAN BANK LTD |
| 791  | APPASAHEB BIRNALE SAHAKARI BANK LTD |
| 792  | ARBAN BANK |
| 793  | AREA CODE SERVICE CO-OP BANK LIMITED |
| 794  | ARIHANT URBAN CO-OP CREDIT SOCIETY LTD |
| 795  | ARIHANT URBAN SOUHARDA CREDIT SAHAKARI LTD |
| 796  | ARUNA KANTILAL SAHAKARI BANK |
| 797  | ARYAVART GRAMIN BANK |
| 798  | ASHOK NAGAR CO-OPERATIVE BANK LIMITED |
| 799  | ASHTA PEOPLES CO-OP BANK LTD |
| 8000 | TMB Bank |
| 813  | BALASORE CO-OPERATIVE URBAN BANK LTD |
| 817  | BANASKANTHA DIST CENTRAL CO-OP BANK LTD |
| 818  | BANGALORE CENTRAL CO-OP BANK LTD |
| 819  | BANGALORE SOUHARDA CENTRAL CO-OP BANK LTD |
| 820  | BANGIYA GRAMIN VIKASH BANK |
| 821  | BANK INTERNASIONAL INDONESIA |
| 824  | BANK ONE N.A. |
| 825  | BANKURA DISTRICT CENTRAL CO-OP BANK LTD |
| 826  | BAPUJI CO-OPERATIVE BANK LIMITED |
| 829  | BARDHAMAN GRAMIN BANK |
| 830  | BAREILLY KSHETRIYA GRAMIN BANK |
| 832  | BARODA GUJARAT GRAMIN BANK |
| 833  | BARODA U P GRAMIN BANK |
| 834  | BARODA ZILA SAHAKARI BANK |
| 837  | BELGAUM INDUSTRIAL CO-OP BANK LTD |
| 838  | BELLAD BAGEWADI URBAN SOUHARDA SAHAKARI BANK LTD |
| 839  | BELLARY DISTRICT CO-OP CENTRAL BANK LTD |
| 844  | BHAGALPUR BANKA KSHETRIYA GRAMIN BANK |
| 845  | BHAGAT URBAN CO OP BANK LTD |
| 847  | BHAILALBHAI CONTRACTOR SAMRAK CO-OP BANK |
| 848  | BHAIRAVESHWARA CO-OP BANK LIMITED |
| 853  | BHARATIYA SAHAKARA BANK NIYAMITHA |
| 854  | BHARATIYA STATE BANK |
| 855  | BHARUCH DIST CENTRAL CO-OP BANK LTD |
| 856  | BHATPARA NAIHATI CO-OPERATIVE BANK LTD |
| 857  | BHAVANI SAHAKARI BANK LIMITED |
| 858  | BHAVNAGAR DISTRICT CO-OP BANK |
| 859  | BHILWARA AJMER KSHETRIYA GRAMIN BANK |
| 860  | BHIMAVARAM CO-OPERATIVE BANK |
| 862  | BHUJ MERCANTILE CO-OP BANK LTD |
| 863  | BHUPATHIRAJU CO-OPERATIVE BANK |
| 864  | BHUSAWAL PEOPLES CO-OP BANK |
| 865  | BIHAR KSHETRIYA GRAMIN BANK LTD |
| 866  | BIJAPUR DISTRICT CENTRAL CO-OP BANK |
| 868  | BIJAPUR MAHALAXMI URBAN CO-OP BANK LTD |
| 869  | BIJAPUR SAHAKARI BANK |
| 870  | BOLANGIR ANCHALIK GRAMIN BANK |
| 871  | BORAL UNION CO-OP BANK LTD |
| 872  | BRAHMAWART COMMERCIAL CO-OP BANK LTD |
| 873  | BULDANA URBAN CO-OP CREDIT SOCIETY |
| 874  | BZRC MAHILA BANK |
| 875  | C G BANK |
| 878  | C K P COOPERATIVE BANK LTD |
| 879  | C RANJANA CATHOLIC SYRIAN BANK |
| 880  | C S B BANK |
| 881  | CALICUT CITY SERVICE CO-OP BANK |
| 882  | CANNANORE CO-OP URBAN BANK LTD |
| 883  | CENTRAL BANK GULBARGA |
| 884  | CENTRAL BANK OF COMMERCE |
| 885  | CENTRAL BANK OF PUNJAB LTD |
| 886  | CHAITANYA CREDIT CO-OP BANK LTD |
| 887  | CHAITANYA GODAVARI GRAMEENA BANK |
| 888  | CHAITANYA GRAMEENA BANK |
| 889  | CHAMBAL GWALIOR KSHETRIYA GRAMIN BANK |
| 890  | CHANGANACHERRY NORTH SERVICE CO-OP BANK LTD |
| 891  | CHARA PADA MINI BANK |
| 892  | CHARTERED SAHAKARI BANK NIYAMITHA |
| 894  | CHATREE GRAMEEN BANK |
| 895  | CHEMBUR NAGARIK SAHAKARI BANK LTD |
| 896  | CHENGALAM SERVICE CO-OPERATIVE BANK LTD |
| 897  | CHENNAI CENTRAL CO-OP BANK |
| 898  | CHETNA SAHAKARI BANK NIYAMITA |
| 899  | CHHATRASAL GRAMIN BANK |
| 900  | CHHINDWARA-SEONI KSHETRIYA GRAMIN BANK |
| 901  | CHIDAMBARAM CO-OP URBAN BANK LTD |
| 902  | CHIKHLI URBAN CO-OP BANK LTD |
| 904  | CHIKMAGALUR KODAGU GRAMEENA BANK |
| 905  | CHIKMAGALUR PATTANA SAHAKARI BANK NIYAMITHA |
| 906  | CHIKO BANK |
| 907  | CHIKO GRAMEENA BANK |
| 908  | CHIKODI URBAN COOPERATIVE BANK LTD |
| 909  | CHITANVIS PURA SAHAKARI BANK LTD |
| 910  | CHITRADURGA GRAMEENA BANK |
| 911  | CHOPDA URBAN CO-OP BANK |
| 912  | CITY PATTINA SAHAKARI SANGHA NIYAMI |
| 913  | CLARKSTON STATE BANK |
| 914  | CONTAI COOPERATIVE BANK LTD |
| 915  | COOPERATIVE URBAN BANK LIMITED |
| 916  | CUDDALORE DISTRICT CENTRAL CO-OP BANK LTD |
| 917  | CUTTACK CENTRAL CO-OP BANK LTD |
| 918  | D G G B BANK |
| 919  | D H V CO-OPERATIVE BANK |
| 920  | DADASAHEB RAWAL CO-OP BANK |
| 921  | DAHOD MERCANTILE CO OP CREDIT SOC LTD |
| 922  | DAIVADNYA SAHAKARI BANK NIYAMIT |
| 923  | DAIVAJNA CREDIT CO-OP SOCIETY LTD |
| 924  | DAMOH PANNA SAGAR KSHETRIYA GRAMIN BANK LTD |
| 925  | DARUSSALAM CO-OP BANK |
| 926  | DATTATRAY MAHARAJ KALAMBE JAOLI SAHAKARI BANK LTD |
| 927  | DAVANGERE DISTRICT CENTRAL CO-OPERATIVE BANK |
| 928  | DAVANGERE HARIHAR URBAN SAHAKARI BANK LTD |
| 929  | DAVANGERE HARIHARA URBAN CO-OP BANK |
| 930  | DAVANGERE URBAN CO-OPERATIVE BANK LIMITED |
| 931  | DECCAN GRAMEENA BANK |
| 932  | NAGARI SAHAKARI BANK LTD |
| 933  | DEVGIRI CO-OP BANK |
| 934  | DEVIPATAN KSHETRIYA GRAMIN BANK |
| 935  | DEWAS SHAJAPUR KSHETRIYA GRAMIN BANK |
| 936  | DHAKURIA COOPERATIVE BANK LTD |
| 937  | DHARMAPURI DISTRICT CENTRAL CO-OP BANK |
| 938  | DHARMVEER SAMBHAJI URBAN CO-OP BANK LTD |
| 939  | DHENKANAL GRAMIN BANK |
| 940  | DHULE DISTRICT COOPERATIVE BANK LTD |
| 941  | DHULE VIKAS SAHAKARI BANK LIMITED |
| 942  | DHULE ZILLA MADHYAVARTI SAHAKARI BANK LTD |
| 943  | DINDIGUL CENTRAL CO-OP BANK LTD |
| 944  | DISTRICT CENTRAL COOPERATIVE BANK |
| 945  | DISTT CO-OPERATIVE BANK |
| 946  | DPSRRB |
| 947  | DR PUNJABRAO DESHMUKH URBAN CO-OP BANK LIMITED |
| 948  | DRGB |
| 949  | DURGAPUR STEEL PEOPLES CO-OP BANK |
| 950  | E D C C BANK |
| 951  | EAST ELERI SERVICE CO-OP BANK LTD |
| 952  | EENADU CO-OP URBAN BANK LTD |
| 953  | ETAH GRAMIN BANK |
| 954  | ETAWAH DIST CO-OP BANK LTD |
| 955  | ETAWAH KSHETRIYA GRAMIN BANK |
| 956  | ETAWAH ZILA SAHAKARI BANK LTD |
| 957  | EUROPEAN CENTRAL BANK |
| 958  | FAIZABAD KSHETRIYA GRAMIN BANK |
| 959  | FARMERS CO-OPERATIVE BANK |
| 960  | FARRUKHABAD GRAMIN BANK |
| 961  | FATIMA NAGAR CO-OPERATIVE BANK LTD |
| 962  | FAZILKA CENTRAL COOPERATIVE BANK |
| 963  | G C U BANK |
| 964  | G D C C BANK |
| 965  | G K G BANK |
| 966  | G N C B LTD |
| 967  | G T C BANK |
| 968  | GADA CO-OP BANK LTD |
| 969  | GAN NAGARIK CO-OP BANK |
| 970  | GANDHIDHAM CO-OPERATIVE BANK LTD |
| 971  | GANDHIDHAM GRAMIN COOP BANK |
| 972  | GANDHIDHAM MERCANTILE CO-OPERATIVE BANK |
| 973  | GANGANAGAR KSHETRIYA GRAMIN BANK |
| 974  | GARHA CO-OP BANK LTD |
| 975  | GHAZIABAD ZILA SAHAKARI BANK LTD |
| 976  | GHAZIPUR URBAN CO-OP BANK LTD |
| 977  | GHOTI MERCHANTS CO-OP BANK LIMITED |
| 978  | GODAVARI LAXMI CO-OPERATIVE BANK LTD |
| 979  | GOLCONDA GRAMEENA BANK |
| 980  | GOMTI GRAMIN BANK |
| 981  | GOOTY CO-OPERATIVE BANK |
| 982  | GOUR GRAMIN BANK |
| 983  | GOZARIA NAGRIK SAHAKARI BANK LIMITED |
| 984  | GRAMEENA BANK |
| 985  | GUDIVADA CO-OP URBAN BANK LTD |
| 986  | GUJARAT AMBUJA CO-OPERATIVE BANK LTD |
| 987  | GUJARAT MERCANTILE CO-OP BANK |
| 988  | GULBARGA DIST CO-OP CENTRAL BANK LTD |
| 989  | GULSHAN MERCANTILE URBAN CO-OP BANK LTD |
| 990  | GUNA KSHETRIYA GRAMIN BANK |
| 991  | GUNA NAGARIK SAHAKARI BANK |
| 992  | GURGAON GRAMIN BANK LTD |
| 993  | GURU NITYANANDA CREDIT CO-OPERATIVE SOCIETY LTD |
| 994  | GUTTHIGEDARAR CREDIT CO-OP SOCIETY |
| 995  | HADOTI KSHETRIYA GRAMIN BANK |
| 996  | HALOL URBAN CO-OP BANK LTD |
| 997  | HAMIRPUR DISTT CO-OP BANK |
| 998  | HARIHARESHWAR SAHAKARI BANK LTD |
| 999  | HARYANA GRAMIN BANK |
| 9999 | ashok |

### Virtual Acc No Logic

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `Virtual Acc No Logic`

#### Table 1

Source cells: `A1:F7`

| Enviornment | Payment Mode | RBI<br>Bank<br>ID | Collection Bank Name (Payment Aggregator) | Virtual<br>Code | Beneficiary A/c Number (Payment Virtual Account Number) |
| --- | --- | --- | --- | --- | --- |
| UAT | NEFT /RTGS | 485 | KOTAK MAHINDRA BANK LTD | MFKU | For CAN based transactions - MFKU<<CAN>><br>e-g. If your CAN is 12345QZA67 then Beneficiary A/C Number is MFKU12345QZA67<br> <br>For Folio based transactions - MFKU<<PAN>><br>If your PAN is BCAAA1122X then Beneficiary A/c Number is MFKUBCAAA1122X |
| UAT | NEFT /RTGS | 532 | YES BANK LTD | MFUYES | For CAN based transactions - MFUYES<<CAN>><br>e-g. If your CAN is 12345QZA67 then Beneficiary A/C Number is MFUYES12345QZA67<br><br>For Folio based transactions - MFUYES<<PAN>><br>If your PAN is BCAAA1122X then Beneficiary A/c Number is MFUYESBCAAA1122X |
| UAT | InstaUPI | 532 | YES BANK LTD |  | 	For CAN-based transaction – VPA ID is MFUYES‹‹CAN››@yesbankltd<br>e-g. If your CAN is 12345QZA67 then Beneficiary A/C Number is MFUYES12345QZA67@yesbankltd<br><br>For Folio-based transaction - VPA ID is MFUYES‹‹PAN››@yesbankltd<br>If your PAN is BCAAA1122X then Beneficiary A/c Number is MFUYESBCAAA1122X@yesbankltd |
| LIVE | NEFT /RTGS | 485 | KOTAK MAHINDRA BANK LTD |  | Visit: https://mfuindia.com/for-investors/neft-rtgs |
| LIVE | NEFT /RTGS | 532 | YES BANK LTD |  | Visit: https://mfuindia.com/for-investors/neft-rtgs |
| LIVE | InstaUPI | 532 | YES BANK LTD |  | Visit : https://mfuindia.com/insta-upi |

### ePayEezz Supported Banks UAT

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `ePayEezz Supported Banks UAT`

#### Table 1

Source cells: `A1:E8`

| Bank ID | Bank Name | Auth Type | Column D | ** Authentication Type |
| --- | --- | --- | --- | --- |
| 012  | BANK OF BARODA | PN |  | PN - Netbanking Based |
| 016  | CENTRAL BANK OF INDIA | PN |  | PD - Debit Card Based |
| 211  | AXIS BANK LTD | PN |  |  |
| 229  | ICICI BANK LTD | PD |  |  |
| 229  | ICICI BANK LTD | PN |  |  |
| 240  | HDFC BANK LTD | PD |  |  |
| 532  | YES BANK LTD | PN |  |  |

### Net Banking supported Bank

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `Net Banking supported Bank`

#### Table 1

Source cells: `A1:C53`

| Bank ID | Bank Name | PG Bank<br>Code |
| --- | --- | --- |
| 002  | STATE BANK OF INDIA | SBI |
| 003  | STATE BANK OF BIKANER AND JAIPUR | SBJ |
| 004  | STATE BANK OF HYDERABAD | SBH |
| 006  | STATE BANK OF MYSORE | SBM |
| 007  | STATE BANK OF PATIALA | SBP |
| 009  | STATE BANK OF TRAVANCORE | SBT |
| 010  | ALLAHABAD BANK | ALB |
| 011  | ANDHRA BANK | ADB |
| 012  | BANK OF BARODA | BBC |
| 012  | BANK OF BARODA | BBR |
| 013  | BANK OF INDIA | BOI |
| 014  | BANK OF MAHARASHTRA | BOM |
| 015  | CANARA BANK | CNB |
| 016  | CENTRAL BANK OF INDIA | CBI |
| 017  | CORPORATION BANK | CRP |
| 018  | DENA BANK | DEN |
| 019  | INDIAN BANK | INB |
| 020  | INDIAN OVERSEAS BANK | IOB |
| 022  | ORIENTAL BANK OF COMMERCE | OBC |
| 023  | PUNJAB AND SIND BANK | PSB |
| 024  | PUNJAB NATIONAL BANK | CPN |
| 024  | PUNJAB NATIONAL BANK | PNB |
| 025  | SYNDICATE BANK | SYD |
| 026  | UNION BANK OF INDIA | UBI |
| 027  | UNITED BANK OF INDIA | UNI |
| 028  | UCO BANK | UCO |
| 029  | VIJAYA BANK | VJB |
| 036  | STANDARD CHARTERED BANK | SCB |
| 037  | CITI BANK | CMP |
| 047  | CATHOLIC SYRIAN BANK LTD | CSB |
| 049  | FEDERAL BANK LTD | FBK |
| 051  | JAMMU AND KASHMIR BANK LTD | JKB |
| 052  | KARNATAKA BANK LTD | KBL |
| 053  | KARUR VYSYA BANK LTD | KVB |
| 054  | CITY UNION BANK | CUB |
| 059  | SOUTH INDIAN BANK LTD | SIB |
| 060  | TAMILNADU MERCANTILE BANK LTD | TMB |
| 064  | ING VYSYA BANK LIMITED | ING |
| 072  | DEVELOPMENT CREDIT BANK | DCB |
| 089  | SHAMRAO VITHAL CO-OP.BANK LTD | SVC |
| 150  | BANK OF BAHRAIN AND KUWAIT | BBK |
| 176  | THE RATNAKAR BANK LTD | RTN |
| 200  | DEUTSCHE BANK | DBK |
| 211  | AXIS BANK LTD | UTI |
| 229  | ICICI BANK LTD | ICI |
| 234  | INDUSIND BANK LTD | IDS |
| 240  | HDFC BANK LTD | HDF |
| 259  | IDBI LTD | IDB |
| 328  | PUNJAB AND MAHARASHTRA CO-OP BANK LTD | PMC |
| 485  | KOTAK MAHINDRA BANK LTD | 162 |
| 532  | YES BANK LTD | YBK |
| 672  | THE ROYAL BANK OF SCOTLAND | RBS |
