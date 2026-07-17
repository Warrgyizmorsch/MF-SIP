# Signzy API Endpoint Index

Endpoint occurrences extracted from the source PDF. Repeated generic endpoints such as `/api/onboardings/execute` and `/api/onboardings/updateForm` remain separate because their request contracts differ by operation.

`Not stated` means the HTTP method was not explicitly printed beside or immediately after that endpoint occurrence in the source.

| Source page | Operation context | Method | Endpoint |
| --- | --- | --- | --- |
| [Page 2](signzy-distributor-api-reference.md#source-page-2) | Documented API operation | `Not stated` | `/api/channels/login` |
| [Page 3](signzy-distributor-api-reference.md#source-page-3) | Upload | `POST` | `/api/onboardings/upload` |
| [Page 4](signzy-distributor-api-reference.md#source-page-4) | Download | `GET` | `/api/onboardings/download` |
| [Page 4](signzy-distributor-api-reference.md#source-page-4) | Channel Login (For existing channel) | `POST` | `/api/channels/login` |
| [Page 5](signzy-distributor-api-reference.md#source-page-5) | Creating a new channel | `POST` | `/api/channels/….your-channel-id…./channels` |
| [Page 8](signzy-distributor-api-reference.md#source-page-8) | Updating a child channel | `PUT` | `/api/channels/….your-channel-id…./channels/….child-channel-id…` |
| [Page 9](signzy-distributor-api-reference.md#source-page-9) | Updating a channel (self update) | `PUT` | `/api/channels/….your-channel-id…` |
| [Page 11](signzy-distributor-api-reference.md#source-page-11) | Get channel details | `GET` | `/api/channels/….your-channel-id…` |
| [Page 11](signzy-distributor-api-reference.md#source-page-11) | List channels | `GET` | `/api/channels/….your-channel-id…./channels` |
| [Page 12](signzy-distributor-api-reference.md#source-page-12) | List of grants | `GET` | `/api/channels/getAmcGrants` |
| [Page 13](signzy-distributor-api-reference.md#source-page-13) | Create captcha image | `GET` | `/api/captchas/get` |
| [Page 13](signzy-distributor-api-reference.md#source-page-13) | Verify captcha | `POST` | `/api/captchas/verify` |
| [Page 14](signzy-distributor-api-reference.md#source-page-14) | Create onboarding object | `POST` | `/api/channels/…channel ID ../onboardings` |
| [Page 17](signzy-distributor-api-reference.md#source-page-17) | Investor login | `Not stated` | `/api/onboardings/login?ns= channel_username` |
| [Page 18](signzy-distributor-api-reference.md#source-page-18) | Extraction API for POI documents | `Not stated` | `/api/onboardings/execute` |
| [Page 24](signzy-distributor-api-reference.md#source-page-24) | Update form POI | `Not stated` | `/api/onboardings/updateForm` |
| [Page 31](signzy-distributor-api-reference.md#source-page-31) | Extraction API for POA documents | `Not stated` | `/api/onboardings/execute` |
| [Page 37](signzy-distributor-api-reference.md#source-page-37) | Updates Permanent POA form data of a Merchant | `Not stated` | `/api/onboardings/updateForm` |
| [Page 42](signzy-distributor-api-reference.md#source-page-42) | Extraction API for POA documents | `Not stated` | `/api/onboardings/execute` |
| [Page 48](signzy-distributor-api-reference.md#source-page-48) | Update form POA correspondence address proof | `Not stated` | `/api/onboardings/updateForm` |
| [Page 56](signzy-distributor-api-reference.md#source-page-56) | Update form Address userForensics | `Not stated` | `/api/onboardings/updateForm` |
| [Page 59](signzy-distributor-api-reference.md#source-page-59) | Cancelled cheque execute | `Not stated` | `/api/onboardings/execute` |
| [Page 60](signzy-distributor-api-reference.md#source-page-60) | Update form cancelled cheque | `Not stated` | `/api/onboardings/updateForm` |
| [Page 61](signzy-distributor-api-reference.md#source-page-61) | Bank account penny transfer | `Not stated` | `/api/onboardings/execute` |
| [Page 63](signzy-distributor-api-reference.md#source-page-63) | Execute verify bank account verifyAccount | `Not stated` | `/api/onboardings/execute` |
| [Page 64](signzy-distributor-api-reference.md#source-page-64) | Update form UserForensics after penny transfer verification | `Not stated` | `/api/onboardings/updateForm` |
| [Page 66](signzy-distributor-api-reference.md#source-page-66) | Update form call for FORMS section | `Not stated` | `/api/onboardings/updateForm` |
| [Page 68](signzy-distributor-api-reference.md#source-page-68) | Extraction API for Related Person’s POI documents | `Not stated` | `/api/onboardings/execute` |
| [Page 72](signzy-distributor-api-reference.md#source-page-72) | Update Fatca Form | `Not stated` | `/api/onboardings/updateForm` |
| [Page 76](signzy-distributor-api-reference.md#source-page-76) | Update Form Signature | `Not stated` | `/api/onboardings/updateForm` |
| [Page 77](signzy-distributor-api-reference.md#source-page-77) | Update Form Photo | `Not stated` | `/api/onboardings/updateForm` |
| [Page 78](signzy-distributor-api-reference.md#source-page-78) | Execute to start video verification | `Not stated` | `/api/onboardings/execute` |
| [Page 79](signzy-distributor-api-reference.md#source-page-79) | Execute recorded video | `Not stated` | `/api/onboardings/execute` |
| [Page 80](signzy-distributor-api-reference.md#source-page-80) | Execute user forensics after video verification | `Not stated` | `/api/onboardings/updateForm` |
| [Page 82](signzy-distributor-api-reference.md#source-page-82) | Create Contract PDF URL | `Not stated` | `/api/onboardings/execute` |
| [Page 83](signzy-distributor-api-reference.md#source-page-83) | Generate Aadhaar Esign URL | `Not stated` | `/api/onboardings/execute` |
| [Page 85](signzy-distributor-api-reference.md#source-page-85) | Save Aadhaar Esign Signed PDF | `Not stated` | `/api/onboardings/execute` |
| [Page 86](signzy-distributor-api-reference.md#source-page-86) | Save Signed PDF (Normal Esign method only) | `Not stated` | `/api/onboardings/updateForm` |
| [Page 87](signzy-distributor-api-reference.md#source-page-87) | Execute user forensics after contract | `Not stated` | `/api/onboardings/updateForm` |
| [Page 89](signzy-distributor-api-reference.md#source-page-89) | Execute verification engine | `Not stated` | `/api/onboardings/execute` |
| [Page 90](signzy-distributor-api-reference.md#source-page-90) | Pull onboarding detail | `POST` | `/api/onboardings/pullonboardings` |
| [Page 100](signzy-distributor-api-reference.md#source-page-100) | Pull CAMS responses for an Onboarding | `POST` | `/api/onboardings/pullCamsResponse` |
| [Page 101](signzy-distributor-api-reference.md#source-page-101) | Pull Karvy data for manual trigger purpose | `POST` | `/api/onboardings/pullKarvyData` |
| [Page 101](signzy-distributor-api-reference.md#source-page-101) | Pull Karvy responses for an Onboarding | `POST` | `/api/onboardings/pullkarvyresponse` |
| [Page 102](signzy-distributor-api-reference.md#source-page-102) | Pull CVL data | `POST` | `/api/onboardings/pullCvlData` |
| [Page 103](signzy-distributor-api-reference.md#source-page-103) | Pull CVL responses for an Onboarding | `POST` | `/api/onboardings/pullCvlResponse` |
| [Page 104](signzy-distributor-api-reference.md#source-page-104) | Login API for Distributor Dashboard | `POST` | `/api/distributorAdmins/login` |
| [Page 104](signzy-distributor-api-reference.md#source-page-104) | Add AMC/channel to Distributor Dashboard | `POST` | `/api/distributorAdmins/addChannel` |
