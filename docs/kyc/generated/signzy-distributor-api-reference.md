# Signzy Distributor API Reference

Complete page-aware text conversion of [signzy_doc.pdf](../signzy_doc.pdf).

> The source is a 120-page web-print PDF. Preformatted blocks preserve the extracted page layout, JSON samples, field tables, endpoints, and reference tables without rewriting API names or values. Page headings map directly to the source PDF.

## Page index

- [Pages 1-12: introduction, authentication, file exchange, and channel APIs](#source-page-1)
- [Pages 13-17: onboarding bootstrap, captcha, and investor login](#source-page-13)
- [Pages 18-56: POI, permanent POA, correspondence POA, and address forms](#source-page-18)
- [Pages 57-71: user forensics, bank verification, KYC forms, and related-person POI](#source-page-57)
- [Pages 72-89: FATCA, signature, photo, video, contract, eSign, and verification](#source-page-72)
- [Pages 90-103: onboarding retrieval and CAMS, Karvy, and CVL responses](#source-page-90)
- [Pages 104-120: distributor dashboard, reference tables, and compatibility notes](#source-page-104)

## Source page 1

```text
                           Introduction

The following APIs are intended to serve the purpose of creating multiple distribution channel for Signzy products.
For example, say a Mutual Fund financial institution wants to onboard investors, they can use Signzy’s Investor Onboarding product.
Now say the financial institute requires to open onboardings into its systems through multiple channels, say channels A, B & C and
needs to see the data pushed by the different channels into the same Backend operations system through which they themselves
onboard the mutual fund investors, this can be achieved through the Multi-channel distribution system through APIs as detailed in the
below API documentation.

Basic philosophy

The basic philosophy of the distributor channel system exposed through APIs is to treat each channel to be created by a channel only
(sub channels) with grants and authority of the child channel controlled by the parent channel.
Distribution channel APIs are exposed in the below two categories.

      1. APIs for channels
      2. APIs for onboardings
The channels create onboardings and possess one to many relationship to onboardings. Channels also relate to other channels
through one belongs to one and one has many relationship. Which can be summed as below:
      1. A channel can have multiple channels
      2. A channel belongs to another channel
      3. A channel has many onboardings
      4. An onboarding is created by (and belogs to) a channel.

                           Basic details

API endpoint details

Protocol: HTTPS
Preproduction hostname: multi-channel-preproduction.signzy.tech
Production hostname: multi-channel.signzy.tech
Authentication: Token based authentication

                         Authentication
```

## Source page 2

```text
The authentication is done at the channel level. You can think of channel as an extension of users. It accepts general details like email,
password and username and also further details which describe the grants given to a particular channel.

A channel may be created by another channel only.

Authorizing your access

Authentication is done at the channel level. A channel can be thought of an extension of user model and authentication can be
executed using combination of username and password. The username and password are set by the channel creating another channel.
A channel’s username and password can be changed anytime using an older password.

You need to have an access token for making any further API calls, which you can receive by logging in manually or programmatically
using these credentials.

Signzy APIs adhere to authentication defined by Swagger 2.0 specifications. Each call to the APIs should include an ‘Authorization’
header or 'access_token’ query parameter for authentication.

Logging into the API service requires a simple HTTP call. Following section mentions data to be input, expected output and meaning of
fields.

URL: /api/channels/login

Hostname and protocol to be applied as described above.

     {
           "username": ".......",
           "password": "........"

     }

INPUT DATA

Two parameters to be passed as JSON payload for logging in
      1. username -> String
      2. password -> String

     {
           "id": ".......",
           "ttl": 0000,
           "created": ".......",
           "userId": "........"

     }

The userID returned above is important and is also referred to as the channel ID. The channel ID will further be required to make
onboarding API calls.

EXPECTED OUTPUT

Following 4 properties are expected as output from the Login API
      1. id -> String (This is the access token to be used in the below requests.)
      2. ttl -> Int (The time, number of seconds, for which the access token described above is valid for.)
      3. created -> String (ISO timestamp of creation date for this token.)
      4. userId -> String (Channel’s user ID, the user which created this token.)

Sending authenticated requests
```

## Source page 3

```text
Once you have an access token from the login API call, you can send further calls to different endpoints by passing the access-token in
Authorization header or in access_token query (GET) parameter.

It is advisable to send Access Token in header since, query parameters are sometimes saved in the log files thereby exposing
vulnerabilities until the access_token is deleted from sessions.

Security

Anybody with your API key/password or an Access Token generated using them can access all information you have created and also
send requests on your behalf. It is strongly recommended to not send API-key/Password to client side and instead use reverse proxy to
call Signzy APIs.
If case you think an access token is compromised, you should delete it using logout. Let us know if your Signzy Password/API-key is
compromised as soon as possible, so that we can disable & create new ones and prevent any misuse of your data.

                          File exchange

You first need to upload the required images before sending for auto reading or forgery or any other Signzy AI APIs. Use the file upload
system to upload images of ID Cards & documents to get a direct URL.

Upload

Endpoint
POST :: /api/onboardings/upload
Header
Authorization: “your access token” -> You will receive the access token from the Investor login API.
Request data
multipart-form-data with & ttl property
TTL
ttl accepts the following values:(2 mins, 10 mins, 30 mins, 2 hrs, 12 hrs, 7 days, 15 days, 1 month, 3 month, 6 month, 1 year, 3 years,
infinity)
When multiple sides or pages of an ID card are required, you need to upload each of them. For example Aadhaar card has information
on both sides whereas PAN has only front side containing useful information.
The urls expire in 30 seconds by default, unless explicitly specified in the inboud request in the ttl parameter.

EXPECTED RESPONSE.

{
  "file": {
      "id": 1388,
      "filetype": ".......",
      "size": 3181,
      "directURL": ".......",
      "protected": false
```

## Source page 4

```text
           }
       }

The upload returns with the following properties.

      1. id -> Int (The id of the file)
      2. filetype -> String (Type of file which was passed into Signzy file system API)
      3. size -> Int (Size in bytes of the uploaded file)
      4. directURL -> String (Direct URL using which the file can be accessed. This is important and required in other API calls.).

Download

Endpoint
GET :: /api/onboardings/download
Header
Authorization: “your access token” -> You will receive the access token from the Investor login API.
Request Query

Name Data type      Value

q  String Persist URL(Direct URL)

EXPECTED RESPONSE.

Raw File

                           Channel APIs

Channel Login (For existing channel)

 ENDPOINT

 /api/channels/login

 REQUEST TYPE

 POST

 HEADERS

 Content-type: “application/json”

 JSON PAYLOAD

        {
              "username" : "<username>",
              "password" : "<password>"

       }

 RESPONSE

        {
              "id": "< access token>",
              "ttl": "<access token ttl in seconds>",
```

## Source page 5

```text
              "created": "2018-12-03T20:34:37.455Z",
              "userId": "< channel Id >"
       }

Creating a new channel

 For each distributor channel you can create a channel object by providing the required properties.

 ENDPOINT

 /api/channels/….your-channel-id…./channels

 The channel-id is the userID that you get from the login call as describled above.

 REQUEST TYPE

 POST

 HEADERS

 Content-type: “application/json” -> This is constant

 Authorization: “your access token” -> You will receive the access token from the login API call as described above.

 JSON PAYLOAD

        {
              "product_productId": ".........",
              "product_customerId": ".........",
              "product_accessToken": ".........",
              "control_active": true,
              "control_allowedCount": 20,
              "control_updateProductInfo": true,
              "control_selfUpdation": true,
              "control_updateControls": true,
              "control_createChildren": true,
              "control_enableFrontendURLs": false,
              "disableEmailFromAmc": false,
              "username": ".........",
              "password": ".........",
              "email": ".........",
              "callbackOnAction": {
                     "accepted": "...",
                     "rejected": "...",
                     "draft": "..."
              },
                "pageCallbackUrl": {
                     "identity": ".....",
                     "address": ".....",
                     "corraddress": ".....",
                     "bankaccount": ".....",
                     "documents": ".....",
                     "fatca": ".....",
                     "signature": ".....",
                     "photo": ".....",
                     "video": ".....",
                     "contract": ".....",
                     "submit" : "....."
              }

       }

 The API accepts the following properties as detailed in the table below.
```

## Source page 6

```text
                 Property             Example values

username                   String                                      username

password                   String                                      password

email                      String                                      email

product_productId          String     investorOnbaording

product_customerId         String     5219872648addff

product_accessToken        String whr320jrehbfdvipkqwmnh

control_active             Boolean                                     true/false

control_allowedCount       Integer                                     Integer

control_updateProductInfo  Boolean                                     true/false

control_selfUpdation       Boolean                                     true/false

control_updateControls     Boolean                                     true/false

control_createChildren     Boolean                                     true/false

control_enableFrontendURLs Boolean                                     true/false

disableEmailFromAmc        Boolean                                     true/false

callbackOnAction           Object

pageCallbackUrl            Object

FIELD DESCRIPTIONS
PRODUCT_PRODUCTID

This information tells what Signzy’s product does this particular channel allowed to push data into.
value = 'investorOnboarding’
Currently only the above value is allowed.

PRODUCT_CUSTOMERID

The product_customerId is obtained for a particular user by logging into Signzy’s product as defined by the above definition. The userId
parameter of login call is where you get the value of this paramenter.

PRODUCT_ACCESSTOKEN

The product_accessToken is obtained for a particular user by logging into Signzy’s product as defined by the above definition. The id
parameter of login call is where you get the value of this paramenter.

CONTROL_ACTIVE

If control_active is set as true, only then the API calls from the channels will be allowed to enter into Signzy system, if this property isn’t
set or is set to false, that channel won’t be make the channel API calls or onboarding API calls. Defaults to true if not set.

CONTROL_ALLOWEDCOUNT

This property defines the number of onboarding objects that this channel can create. Defaults to 500 if not set.

CONTROL_SELFUPDATION

If this property is not set or set to false, then the update calls to their own object. The self updation API mentioned below will not be
enabled. This enables the channels to update the username, password and email. For updating product specifications and the control
```

## Source page 7

```text
parameters control_updateControls & control_updateProductInfo should also be set. Defaults to true if not set.

CONTROL_UPDATECONTROLS

If this property is not set or set to false, then the channel won’t be able to update the properties which have prefixe of control_. Defaults
to false if not set.

CONTROL_UPDATEPRODUCTINFO

If this property is not set or set to false, then the channel won’t be able to update the properties which have prefixe of product_.
Defaults to false if not set.

CONTROL_CREATECHILDREN

If this property is not set or set to false, then the channel won’t be able to child channels. Channels won’t be able to call the create
channel API if this is not set or set as false. Defaults to false if not set.

CONTROL_ENABLEFRONTENDURLS

Enables showing of frontend Web URLs for onboarding in response of create Onboarding API, in json keys: applicationUrl , autoLoginU
rL , mobileLoginUrl , mobileAutoLoginUrl

DISABLEEMAILFROMAMC

Flag to Disble/Enable Emails which are sent to investors on behalf of AMC. true implies email wont be sent.Defaults to false if not set.

CALLBACKONACTION

This object contains the list of callback URLs, to which data is to be posted, when any corresponding action is taken on the application.
Defaults to empty if not set.

PAGECALLBACKURL

This object contains the list of callback URLs, to which data is to be posted, when any step is completed by the investor. Defaults to
empty if not set.

EXPECTED RESPONSE

        {
              "product_productId": "........",
              "product_customerId": "........",
              "product_accessToken": "........",
              "control_active": false,
              "control_allowedCount": 20,
              "control_updateProductInfo": false,
              "control_selfUpdation": true,
              "control_updateControls": true,
              "control_createChildren": true,
              "control_enableFrontendURLs": false,
              "disableEmailFromAmc": false,
              "username": "......",
              "email": "......",
              "id": "......",
              "channelId": "......",
              "callbackOnAction": {
                     "accepted": "...",
                     "rejected": "...",
                     "draft": "..."
              },
                "pageCallbackUrl": {
                     "identity": ".....",
                     "address": ".....",
                     "corraddress": ".....",
                     "bankaccount": ".....",
                     "documents": ".....",
                     "fatca": ".....",
                     "signature": ".....",
                     "photo": ".....",
                     "video": ".....",
                     "contract": ".....",
                     "submit" : "....."
```

## Source page 8

```text
              }
       }

Updating a child channel

A child channel is basically a distributor of a service and controlled by parent. A child channel can be updated by sending a PUT call to
the sub channel endpoint.

ENDPOINT

/api/channels/….your-channel-id…./channels/….child-channel-id….

The channel-id is the userID that you get from the login call as describled above.

REQUEST TYPE

PUT

HEADERS

Content-type: “application/json” -> This is constant

Authorization: “your access token” -> You will receive the access token from the login API call as described above.

ALLOWED PROPERTIES FOR UPDATION

     {
           "product_productId": ".........",
           "product_customerId": ".........",
           "product_accessToken": ".........",
           "control_active": true,
           "control_allowedCount": 20,
           "control_updateProductInfo": true,
           "control_selfUpdation": true,
           "control_updateControls": true,
           "control_createChildren": true,
           "control_enableFrontendURLs": false,
           "disableEmailFromAmc": false,
           "username": ".........",
           "password": ".........",
           "email": ".........",
           "callbackOnAction": {
                  "accepted": "...",
                  "rejected": "...",
                  "draft": "..."
           },
             "pageCallbackUrl": {
                  "identity": ".....",
                  "address": ".....",
                  "corraddress": ".....",
                  "bankaccount": ".....",
                  "documents": ".....",
                  "fatca": ".....",
                  "signature": ".....",
                  "photo": ".....",
                  "video": ".....",
                  "contract": ".....",
                  "submit" : "....."
           }

     }

The API accepts the following properties as detailed in the table below.
```

## Source page 9

```text
                 Property             Example values

username                   String                                      username

password                   String                                      password

email                      String                                      email

product_productId          String     investorOnbaording

product_customerId         String     5219872648addff

product_accessToken        String whr320jrehbfdvipkqwmnh

control_active             Boolean                                     true/false

control_allowedCount       Integer                                     true/false

control_updateProductInfo  Boolean                                     true/false

control_selfUpdation       Boolean                                     true/false

control_updateControls     Boolean                                     true/false

control_createChildren     Boolean                                     true/false

control_enableFrontendURLs Boolean                                     true/false

disableEmailFromAmc        Boolean                                     true/false

callbackOnAction           Object

pageCallbackUrl            Object

Updating a channel (self update)

The self update on the channel is to be used by a channel to be update itself. A particular channel can use the self update API to
update properties like password, email and other properties not controlled by the parent. Parent controlled properties include properties
like active boolean and other allowances granted by the parent.

ENDPOINT

/api/channels/….your-channel-id….
The channel-id is the userID that you get from the login call as describled above.

REQUEST TYPE

PUT

HEADERS

Content-type: “application/json” -> This is constant
Authorization: “your access token” -> You will receive the access token from the login API call as described above.

ALLOWED PROPERTIES FOR UPDATION

        {
              "product_productId": ".........",
              "product_customerId": ".........",
              "product_accessToken": ".........",
```

## Source page 10

```text
              "control_active": true,
              "control_allowedCount": 20,
              "control_updateProductInfo": true,
              "control_selfUpdation": true,
              "control_updateControls": true,
              "control_createChildren": true,
              "control_enableFrontendURLs": false,
              "disableEmailFromAmc": false,
              "username": ".........",
              "password": ".........",
              "email": ".........",
              "callbackOnAction": {

                     "accepted": "...",
                     "rejected": "...",
                     "draft": "..."
              },
                "pageCallbackUrl": {
                     "identity": ".....",
                     "address": ".....",
                     "corraddress": ".....",
                     "bankaccount": ".....",
                     "documents": ".....",
                     "fatca": ".....",
                     "signature": ".....",
                     "photo": ".....",
                     "video": ".....",
                     "contract": ".....",
                     "submit" : "....."
              }
       }

The API accepts the following properties as detailed in the table below.

          Property                                  Data type  Example values

username                                            String             username

password                                            String             password
email                                               String                  email

product_productId                                   String     investorOnbaording

product_customerId                                  String     5219872648addff

product_accessToken                                 String whr320jrehbfdvipkqwmnh
control_active
                                                    Boolean            true/false

control_allowedCount                                Integer            Integer

control_updateProductInfo                           Boolean            true/false

control_selfUpdation                                Boolean            true/false

control_updateControls                              Boolean            true/false
control_createChildren                              Boolean            true/false

control_enableFrontendURLs Boolean                                     true/false

disableEmailFromAmc                                 Boolean            true/false

callbackOnAction                                    Object
pageCallbackUrl                                     Object
```

## Source page 11

```text
Get channel details

/api/channels/….your-channel-id….
The channel-id is the userID that you get from the login call as describled above.

REQUEST TYPE

GET

EXPECTED RESPONSE

{
      "product_productId": ".........",
      "product_customerId": ".........",
      "product_accessToken": ".........",
      "control_active": true,
      "control_allowedCount": 20,
      "control_updateProductInfo": true,
      "control_selfUpdation": true,
      "control_updateControls": true,
      "control_createChildren": true,
      "control_enableFrontendURLs": false,
      "disableEmailFromAmc": false,
      "username": ".........",
      "password": ".........",
      "email": ".........",
      "id": "......",
      "channelId": "......",
      "callbackOnAction": {
             "accepted": "...",
             "rejected": "...",
             "draft": "..."
      },
        "pageCallbackUrl": {
             "identity": ".....",
             "address": ".....",
             "corraddress": ".....",
             "bankaccount": ".....",
             "documents": ".....",
             "fatca": ".....",
             "signature": ".....",
             "photo": ".....",
             "video": ".....",
             "contract": ".....",
             "submit" : "....."
      }

}

The API is expected to return all the properties for the channel object that were used while creating the channel. The sensitive
properties like the product descriptions are hidden (product_customerId, product_accessToken)

List channels

 ENDPOINT

 /api/channels/….your-channel-id…./channels
 The channel-id is the userID that you get from the login call as describled above.

 REQUEST TYPE

 GET
```

## Source page 12

```text
 EXPECTED RESPONSE

        [{
              "product_productId": ".........",
              "product_customerId": ".........",
              "product_accessToken": ".........",
              "control_active": true,
              "control_allowedCount": 20,
              "control_updateProductInfo": true,
              "control_selfUpdation": true,
              "control_updateControls": true,
              "control_createChildren": true,
              "control_enableFrontendURLs": false,
              "disableEmailFromAmc": false,
              "username": ".........",
              "password": ".........",
              "email": ".........",
              "id": "......",
              "channelId": "......",
              "callbackOnAction": {
                     "accepted": "...",
                     "rejected": "...",
                     "draft": "..."
              },
                "pageCallbackUrl": {
                     "identity": ".....",
                     "address": ".....",
                     "corraddress": ".....",
                     "bankaccount": ".....",
                     "documents": ".....",
                     "fatca": ".....",
                     "signature": ".....",
                     "photo": ".....",
                     "video": ".....",
                     "contract": ".....",
                     "submit" : "....."
              }

       }]

List of grants

 ENDPOINT

 /api/channels/getAmcGrants

 REQUEST TYPE

 GET

 HEADERS

 Authorization: “channel access token”

 EXPECTED RESPONSE

        {
              "poi_list": ["list of Id cards applicable for POI"],
              "poa_list": ["list of Id cards applicable for POA"],
              "cpoa_list": ["list of Id cards applicable for CPOA"],
              "allowed_sections": ["List of sections allowed for the corresponding AMC"],
              "form_sections": {
                     "placeOfBirthMandatory": true,
                     "annualIncomeMandatory": true,
                     "bankAddressMandatory": true,
                     "aadhaarFieldMandatory": true
              }
```

## Source page 13

```text
       }

The API returns all the grants that are enabled by the respective AMCs. Using this API, Channels can get to know which sections are
allowed as per the AMCs.

                       Onboarding APIs

The onboarding APIs help a channel create onboarding objects. A channel can create onboardings for a parent product.
APIs which are applicable for AMC On-boarding Journey flow will be accessible by the distributor. Distributor won’t be able to access
any other API.

Create captcha image

/api/captchas/get

REQUEST TYPE

GET

EXPECTED RESPONSE
HEADER

id -> ID of the generated captcha

     {
           "id": "502cd6b2aepf021976379802"

     }

BODY

Raw File

Verify captcha

 You can use this endpoint to verify the captcha on the front-end itself before sending into the Signzy login API.

 REQUEST TYPE

 POST

 ENDPOINT

 /api/captchas/verify

 INPUT JSON

        1. text -> text to be verified.
        2. id -> id of the generated captcha.

        {
              "text":"00000",
```

## Source page 14

```text
              "id":"502cd6b2aepf021976379802"
       }

EXPECTED OUTPUT

     {
           "result": {
                  "isVerified": true
           }

     }

isVerified -> true denotes captcha is verified, false denotes catcha is not verified

Create onboarding object

ENDPOINT

/api/channels/…channel ID ../onboardings

REQUEST TYPE

POST

HEADERS

Content-type: “application/json” Authorization: “channel access token”

INPUT                                          Data type                                                    Example values

        Property

email                                 String (Required) , valid email                                       Investor’s Email

username           String (Required) string of lower case                                                   Investor’s Username

                  alphabets, digits, '.', '_', '-' with mi
                                        n length of 3

phone                                 String (Required) 10 digit string and f                               Investor’s Phone Number

                                             irst digit is one of '6,7,8,9'

name                                  String (Required) string of min length                                Investor’s Name

                                          of 2 consisting of any character

channelEmail                          String (Optional) valid email            email to get notifications at various Events (currently applicaple
                                                                               only for CAMS Response for the Investors Data push to CAMS)

redirectUrl                           String (Optional) valid URL              Investor gets redirected to this URL if onboarding via Signzy Web
                                                                                                                                                           platform

languageList                          Array (Optional) Keywords that can be p     Select the keywords for the respective languages that should be
                                                                               shown in the Merchant’s page. English - “en”, Hindi - “hi”, Kannada
                                      assed - ["en", "hi", "kn", "bn", "mr"]
                                                                                                                         - “kn”, Bengali - “bn”, Marathi - “mr”

languageSelected                      String (Optional) Any one of these ('e   This field ensures the default language that will appear in the
                                                                                Merchant’s page. English - “en”, Hindi - “hi”, Kannada - “kn”,
                                              n', 'hi', 'kn', 'bn', 'mr')
                                                                                                                          Bengali - “bn”, Marathi - “mr”

prefillData                           Object (Optional) valid JSON             Some of the data of investor can be prefilled here (For signzy
                                                                                                                                      frontend users only)

        {
              "email":"user@mail.com",
              "username":"username",
```

## Source page 15

```text
              "phone":"76xxxxxxx3",
              "name":"name",
              "channelEmail": "xyz@email.com",
              "redirectUrl": "https://xyz.com",
              "languageList" : ["...list of langauages..."],
              "languageSelected" : "...language selected...",
              "prefillData" : {
              "name": "...name...",
              "fatherName": "...father name...",
              "motherName": "...mother name...",
              "dob": "...dob...",
              "panNumber": ".. Pan number",
              "dlNumber": ".. Dl number..",
              "dlIssueDate": "...Dl IssueDate...",
              "dlExpiryDate": "...Dl Expiry Date...",
              "passportNumber": "...Passport number...",
              "passportIssueDate": "...Passport Issue Date...",
              "passportExpiryDate": "...Passport Expiry Date...",
              "aadhaarUid": "...12 digit UID...",
              "voterIdNumber": "...VoterId number...",
              "otherIdNumber": "...OtherId number",
              "otherIdIssueDate": "...OtherId Issue Date...",
              "otherIdExpiryDate": "...OtherId Expiry Date...",
              "pincode": "...pincode...",
              "state": "...state...",
              "district": "...district...",
              "city": "...city...",
              "address": "...address...",
              "corrPincode": "...corr pincode...",
              "corrState": "...corr state...",
              "corrDistrict": "...corr district...",
              "corrCity": "...corr city...",
              "corrAddress": "...corr address...",
              "bankAccountNumber": "...bank account number...",
              "bankIFSC": "...bank IFSC...",
              "bankAccountHolderName" : "...bank account holder name...",
              "bankAddress": "...bank address...",
              "gender": "...gender...",
              "maritalStatus": "...martial status...",
              "fatherSpouseTitle": "...father or spouse title...",
              "fatherSpouseName": "...father or spouse name...",
              "nomineeRelationShip": "...nominee relationship...",
              "maidenTitle": "...maiden title...",
              "maidenName": "...maiden name...",
              "motherTitle": "...mother title...",
              "emailId": "...emailId...",
              "mobileNumber": "..mobile number...",
              "placeOfBirth": "...place of birth..."
       }
       }

prefillData(For signzy frontend users only) Object details for Prefilling data

           Property                              Data type                                                      Example values
name                                                                                                              Investor’s name
fatherName           String (Optional) , string of min length of 2 consisti                              Investor’s father name
motherName                                                                                              Investor’s mother name
dob                                             ng of any character
panNumber                                                                                                           Investor’s dob
                     String (Optional) , string of min length of 2 consisti                                            Pan number

                                                ng of any character

                     String (Optional) , string of min length of 2 consisti

                                                ng of any character

                     String (Optional) , date of birth as string in DD/MM/Y

                                            YYY or DD-MM-YYYY format

                                 String (Optional) , Valid pan number
```

## Source page 16

```text
               Property  Data type                                                                  Example values

dlNumber                 String (Optional) , Valid dl number                                        dl number

dlIssueDate              String (Optional) , Issue Date as string in DD/MM/YYYY                     Dl issue date

                                or DD-MM-YYYY format, should be a past Date

dlExpiryDate             String (Optional) , Expiry Date as string DD/MM/YYYY o                     Dl expiry date

                               r DD-MM-YYYY format, should be a future Date

passportNumber           String (Optional) , Valid passport number                                  Passport number

passportIssueDate        String (Optional) , Issue Date as string in DD/MM/YYYY                     Passport issue date

                                or DD-MM-YYYY format, should be a past Date

passportExpiryDate       String (Optional) , Expiry Date as string DD/MM/YYYY o                     Passport expiry date

                               r DD-MM-YYYY format, should be a future Date

aadhaarUid               String (Optional) , string of 8 zeros followed by 4 di                     Aadhaar number

                                                                gits

voterIdNumber            String (Optional)                                                          VoterId number

otherIdNumber            String (Optional)                                                          Other document number

otherIdIssueDate         String (Optional) , Issue Date as string in DD/MM/YYYY                     Other document issue date

                                or DD-MM-YYYY format, should be a past Date

otherIdExpiryDate        String (Optional) , Expiry Date as string DD/MM/YYYY o                     Other document expiry date

                               r DD-MM-YYYY format, should be a future Date

pincode                  String (Optional), valid Pincode                                           Pincode

state                    Enum String (Optional)                                                     State, Refer 1st column of Table 1.7

district                 String (Optional)                                                          District

city                     Enum String (Optional)                                                     City

address                  String (Optional)                                                          Address

corrPincode              String (Optional), valid Pincode                                           Correspondence POA pincode

corrState                Enum String (Optional)                                                    Correspondence POA state, Refer 1st column
                                                                                                                                                of Table 1.7

corrDistrict             String (Optional)                                                          Correspondence POA District

corrCity                 Enum String (Optional)                                                     Correspondence POA city

corrAddress              String (Optional)                                                          Correspondence POA address

bankAccountNumber        String (Optional) , string of min length of 9 and max                      Account number on cancelled cheque
                                                                                                                                         document
                                       length 18 consisting of any digit

bankIFSC                 String (Optional), alphanumeric string of length 11                        IFSC code

                                        String (Optional), string of min length of 2 consistin      Bank account holder name
banckAccountHolderName

                                                                               g of any character

bankAddress              String (Optinal)                                                           Bank address

gender                   Enum String (Optional)                                                    investor’s Gender values: “F” / “M” / “T” for
                                                                                                                      Female, Male, Transgender
```

## Source page 17

```text
               Property                          Data type                                          Example values
   maritalStatus
   fatherSpouseTitle                             Enum String (Optional)           investor’s marital status, values: “MARRIED” /
   fatherSpouseName                                                                                      “UNMARRIED” / “OTHERS”
   nomineeRelationShip
   maidenTitle                                   Enum String (Optional)           Pass the title of Father or Spouse, possible
   maidenName                                                                                                    values “Mr.” / “Mrs.”
   motherTitle
   emailId               String (Optional), string of min length of 2 consisti                      Pass the Father or Spouse name
   mobileNumber
   placeOfBirth                                     ng of any character

                                                 Enum String (Optional)                   Pass either “FATHER” or “SPOUSE”,
                                                                                  accordingly pass the name in “fatherName”

                                                 Enum String (Optional)           title for maiden name, values: “Mrs.” / “Ms.” /
                                                                                                                                      “Mx.”

                         String (Optional), string of min length of 2 consisti    maiden name of investor provided investor is
                                                                                                                                 a Female
                                                    ng of any character

                                                 Enum String (Optional)           Investor mother Title, values: “Mrs.” / “Ms.” /
                                                                                                                                     “Mx.”

                                                 String (Optional) , valid email                    Investor’s Email

                         String (Optional) 10 digit string and first digit is                       Investor’s Phone Number

                                                      one of '6,7,8,9'

                         String(Optional), string of min length of 2 consistin                      Place of Brith

                                                     g of any character

RESPONSE

{
      "id": "... Onboarding Id ...",
      "createObj": {
             "customerId": "..customerId..",
             "email": "user@mail.com",
             "id": ".. onboarding password ..",
             "name": "name",
             "phone": "76xxxxxxx3",
             "username": "username"
      }

}

Investor login

 ENDPOINT

 /api/onboardings/login?ns= channel_username

 EXPECTED INPUT

        {
              "username": "....",
              "password": "....",
              "platform": 1,
              "signzyCaptchaResponse": {
                     "text": ".....",
                     "id": "......"
```

## Source page 18

```text
              }
       }

      1. username -> The username to be used in this API is the one you pass into the create onboarding API
      2. password -> The password to be used in this API is availed from the response of create Onbarding API. It can be found on the

          id property of createObj object.
      3. signzyCaptchaResponse -> This object contains the text and the ID parameter which you receive from the create captcha API.

          Text property is basically entered by the user after reading the captcha image.

EXPECTED RESPONSE

{
    "id":"<access token to be used for onboarding process>",
    "ttl":31556926,
    "created":"2018-12-09T18:22:20.184Z",
    "userId":"< merchant Id >",
    "grants":{
         "poi":"true",
         "poa":"true",
         "bankaccount":"true",
         "documents":"true",
         "video":"true",
         "contract":"true",
         "bankaccountverify":"true",
         "aadhaaresign":"true",
         "esign":"true",
         "photo":"true",
         "corrAddress":"true",
         "skip":"full",
         "aadhaarField":"true"
    }

}

Execute POI

Extraction API for POI documents

ENDPOINT

/api/onboardings/execute

HEADERS

Property           Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                             Data type                                                                                  Example values

    Property                                                                                        userId from investor login response

merchantId         String (Required) alphanumeric string of length 2    Metadata along with actual payload to be executed upon
                                                                                                                                        “identity”
                                                          4
                                                                       “individualPan” / “aadhaar” / “passport” / “drivingLicence” /
inputData                 Object (Required)                                                                                              “voterid”

– service                 Enum String (Required)

– type                    Enum String (Required)
```

## Source page 19

```text
     Property              Data type                                                                                                       Example values

– task                     Enum String (Required)                                                                                          “autoRecognition”

– data                     Object (Required)                                                                                               payload

—- images          Array (Required) array of length 2(incase of 'aad   An array of image URLs of the ID card, front and back in order.
                                                                       In case of PAN, pass URL of front Image and in case of Driving
                   haar', 'voterid', 'passport'), length 1 (incase of
                   PAN) and, length 1 or 2 (incase of DL) with valid         License pass URLs of either front or both sides of images.

                                                        URLs.

—-                         Enum String (Required)                                                                                          “identity”
proofType

{
      "merchantId": ".......",
      "inputData": {
             "service": ".......",
             "type": ".......",
             "task": ".......",
             "data": {
                   "images": ["..direct url of the images of one side(incase of driving licence and PAN ) or two sides (for others) .."],
                   "toVerifyData": {},
                   "searchParam": {},
                   "proofType": "identity"
             }
      }

}

INPUT FOR OFFLINE AADHAAR  Data type                                                                                                       Example values

     Property

merchantId         String (Required) alphanumeric string of length 24                                            userId from investor login response

inputData                  Object (Required)                           Metadata along with actual payload to be executed upon

– service                  Enum String (Required)                                                                                          “identity”

– type                     Enum String (Required)                                                                                          “aadhaar”

– task                     Enum String (Required)                                                                                          “offlineAadhaar”

– data                     Object (Required)                                                                                               payload

—- images                  Array (Required) empty array                                                          In case of Offline Aadhaar pass empty array []

—- url                     Enum String (Required)                                                                                          “url of zip or xml file ”

—- password                Enum String (Required)                      “password of the zip file (Required only if the file is zip) ”

—- proofType               Enum String (Required)                                                                                          “identity”

        {
              "merchantId": ".......",
              "inputData": {
                     "service": ".......",
                     "type": "aadhaar",
                     "task": "offlineAadhaar",
                     "data": {
                           "images": [],
                           "url":".. url of zip or xml file (only for offlineAadhaar)...",
                           "password": ".. password of the zip file (only for offlineAadhaar and zip file) ..",
                           "toVerifyData": {},
                           "searchParam": {},
```

## Source page 20

```text
                           "proofType": "identity"
                     }
              }
       }

FOR AADHAAR, PAN, DL DIGILOCKER

Must hit the execute API twice,
1) First with task as createUrl.
2) In response, will receive a url to grant permission from DigiLocker to access the documents.
3) After completion of the process, Hit the same API with task as getDetails.
Input

Property                                            Data type                                            Example values

merchantId    String (Required) alphanumeric string of length 24                                         userId from investor login response

inputData                                           Object (Required)       Metadata along with actual payload to be executed upon

– service                                           Enum String (Required)                               “identity”

– type                                              Enum String (Required)  “aadhaarDigiLocker” / “panDigiLocker” / “dlDigiLocker”

– task                                              Enum String (Required)                               “createUrl” / “getDetails”

– data                                              Object (Required)                                    payload

—- images     Array (Required) empty array                                  In case of DigiLocker pass empty array []

—- proofType                                        Enum String (Required)                               “identity”

        {
              "merchantId": ".......",
              "inputData": {
                     "service": ".......",
                     "type": ".......",
                     "task": "...creatUrl/getDetails....",
                     "data": {
                           "images": [],
                           "toVerifyData": {},
                           "searchParam": {},
                           "proofType": "identity"
                     }
              }

       }

 EXPECTED OUTPUT

 Incase of PAN Card card

        {
              "object": {
                     "result": {
                           "name": "Name as on card",
                           "fatherName": "Father's name as on card",
                           "dob": "DOB as on card",
                           "number": "number as on card"
                     }
              }

       }
```

## Source page 21

```text
 Incase of Aadhar card

        {
              "object": {
                     "result": {
                           "uid": "...00000000XXXX....masked first eight digit...",
                           "vid": "...virtual UID...",
                           "name": "...name on id card...",
                           "yob": "...year of birth...",
                           "dob": "...date of birth...",
                           "pincode": "...pincode...",
                           "address": "...address as on card...",
                           "gender": "male/female",
                           "splitAddress": {
                                  "district": [],
                                  "state": [
                                         []
                                  ],
                                  "city": [],
                                  "pincode": " ",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": ""
                           },
                           "uidHash": "Secure Cryptographic conversion of UID"
                     }
              }

       }

 Incase of Driving License

        {
              "object": {
                     "result": {
                           "issueDate": "date-of-issue",
                           "dob": "dob",
                           "expiryDate": "date-of-expiry",
                           "name": "name",
                           "number": "dl number",
                           "guardianName": "name of guardian",
                           "address": "address",
                           "splitAddress": {
                                  "state": [
                                         []
                                  ],
                                  "district": [],
                                  "city": [],
                                  "pincode": "...pincode...",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": "...addressLine..."
                           },
                           "dlType": ["array-of-vehicle-class"]
                     }
              }

       }

 Incase of Passport

        {
              "object": {
                     "result": {
```

## Source page 22

```text
                           "parentsGuardianName": "..parentsGuardianName...",
                           "issueDate": "..issueDate..",
                           "expiryDate": "..expiryDate..",
                           "birthDate": "..birthDate..",
                           "name": "..name..",
                           "country": [

                                  "..country.."
                           ],
                           "nationality": "..nationality..",
                           "sex": "F/M",
                           "address": "..address..",
                           "pincode": "..pincode..",
                           "passportNumber": "..passportNumber..",
                           "fileNumber": "..fileNumber..",
                           "placeOfBirth": "..placeOfBirth..",
                           "placeOfIssue": "..placeOfIssue..",
                           "splitAddress": {

                                  "district": [
                                         "..district.."

                                  ],
                                  "state": [

                                         [
                                               "..state.."

                                         ]
                                  ],
                                  "city": [

                                         "..city.."
                                  ],
                                  "pincode": "..pincode..",
                                  "country": [

                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": "..addressLine.."
                           }
                     }
              }
       }

 Incase of VoterId

        {
              "object": {
                     "result": {
                           "epicNumber": "...epic number...",
                           "name": "...name...",
                           "fatherName": "...father name...",
                           "state": "...state name...",
                           "dob": "...date of birth...",
                           "yob": "...year of birth...",
                           "ageAsOn": "...age in year...",
                           "address": "...address found on card...",
                           "splitAddress": {
                                  "district": [
                                         "...name of district..."
                                  ],
                                  "state": [
                                         [
                                               "...name of state...",
                                               "WB"
                                         ]
                                  ],
                                  "city": [
                                         "...name of the city..."
                                  ],
                                  "pincode": "...pincode of the city...",
                                  "country": [
                                         "IN",
                                         "IND",
```

## Source page 23

```text
                                         "INDIA"
                                  ],
                                  "addressLine": "...address line on the card..."
                           }
                     }
              }
       }

 Incase of Offline Aadhaar

     {
           "object": {
                  "result": {
                         "name": "...name on id card...",
                         "yob": "...year of birth...",
                         "dob": "...date of birth...",
                         "gender": "male/female",
                         "emailHash": "...",
                         "mobileNoHash": "...",
                         "address": "..",
                         "photo": "..image url..",
                         "generationDate": ".. date ..",
                         "generationTime": ".. time ..",
                         "unixTimeStamp": 1589445464,
                         "dateDifference": 1,
                         "splitAddress": {
                               "district": [],
                               "state": [
                                      []
                               ],
                               "city": [],
                               "pincode": " ",
                               "country": [
                                      "IN",
                                      "IND",
                                      "INDIA"
                               ],
                               "addressLine": ""
                         },
                         "x509Data": {
                               "subjectName": "......",
                               "certificate": "",
                               "details": { },
                               "validAadhaarDSC": "..yes/no..."
                         }
                  }
           }

     }

Incase of DigiLocker(Aadhaar / PAN / DL) 1st Step

     {
           "result": {
                         "url": " ... url to permit DigiLocker Account ...",
                         "requestId": " .. id .."
                  }

     }

Incase of DigiLocker(PAN / DL) 2nd Step, the response will be similar to the respective cards as mentioned above.

Incase of Aadhaar Digilocker 2nd Step

        {
              "result": {
                     "type": "aadhaarDigiLocker",
                     "input": {
                           "images": [
```

## Source page 24

```text
                                  "..image.."
                           ]
                     },
                     "category": null,
                     "output": {
                           "uid": "...00000000XXXX....masked first eight digit...",
                           "vid": "...virtual UID...",
                           "name": "...name on id card...",
                           "yob": "...year of birth...",
                           "dob": "...date of birth...",
                           "pincode": "...pincode...",
                           "address": "...address as on card...",
                           "gender": "male/female",
                           "splitAddress": {

                                  "district": [],
                                  "state": [

                                         []
                                  ],
                                  "city": [],
                                  "pincode": " ",
                                  "country": [

                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": ""
                           },
                           "uidHash": "Secure Cryptographic conversion of UID"
                           "x509Data": {
                                  "subjectName": "",
                                  "certificate": "",
                                  "details": { },
                                  "validAadhaarDSC": "..yes/no..."
                           },
                           "photo": "..Image.."
                     }
              }
       }

Update form POI

Update POI form data of a Merchant.

Only the POI that has been approved for the distributor by the AMC will be accepted and any other ID uploaded will throw an error. So if
for a particular distributor, if PAN card is the only approved POI, then uploading Aadhaar as POI will throw an error.

ENDPOINT

/api/onboardings/updateForm

HEADERS

Property     Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                          Data type                                                                          Example values

   Property

merchantId String (Required) alphanumeric string of length 24 userId from investor login response field

save                String (Required)                                                                             “formData”
```

## Source page 25

```text
                   String (Required)
     Property      Object (Required)                                                                       Example values
   type                                                                                                        “identityProof”
   data
                                                                                          payload, see below for details

data Object details when POI is PAN

Property                                        Data type                                                                       Example values

type                                            Enum String (Required)                                                          “individualPan”

name               String (Required) , string of min length of 2 consisting of any character       Name on POI document

dob                String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YYYY format  DOB on POI document

number                                          String (Required) , valid PAN number               PAN number on POI document

fatherName         String (Required) , string of min length of 2 consisting of any character       PAN number on POI document

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "identityProof",
      "data": {
             "type": "individualPan",
             "name": ".. name ..",
             "fatherName": ".. fatherName ..",
             "number": ".. Pan number ..",
             "dob": ".. dob .."
      }

}

data Object details when POI is Aadhaar

Property                                        Data type                                                                     Example values
                                                                                                                                        “aadhaar”
type                                            Enum String (Required)
                                                                                                                    Name on POI document
name        String (Required) , string of min length of 2 consisting of any cha
                                                                                                                              Aadhaar number
                                                             racter                                          Address as on POI document

uid                String (Required), string of 8 zeros followed by 4 digits                                       City as on POI document
                                                                                      State as on POI document, Refer 1st column of
address                                             String (Required)
city                                            Enum String (Required)                                                                   Table 1.7
                                                                                                               District as on POI document
state                                           Enum String (Required)
                                                                                                                                          Pincode
district                                    String (Required)
pincode                                                                                                               DOB on POI document
dob                               String (Required), valid Pincode

            String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-

                                                         YYYY format

        {
              "merchantId": ".. merchantId ..",
              "save": "formData",
              "type": "identityProof",
```

## Source page 26

```text
              "data": {
                     "type": "aadhaar",
                     "name": ".. person name ..",
                     "uid": "..12 digit UID ..",
                     "address": ".. address ..",
                     "city": ".. city ..",
                     "state": ".. state ..",
                     "district": ".. district ..",
                     "pincode": ".. pincode ..",
                     "dob": ".. dob .."

              }
       }

data Object details when POI is Passport

      Property                                               Data type                                                         Example values
                                                                                                                                        “passport”
type                                                Enum String (Required)
                                                                                                                      Name on POI document
name            String (Required) , string of min length of 2 consisting of any chara                                          Passport number

                                                                    cter                                      Address as on POI document
                                                                                                                    City as on POI document
passportNumber                                      String (Required)
                                                                                                     State as on POI document, Refer 1st
address                                             String (Required)                                                       column of Table 1.7

city                                                Enum String (Required)                                      District as on POI document
                                                                                                                       DOB on POI document
state                                               Enum String (Required)                                                                 Pincode

district                                         String (Required)                                               Issue date on the document
birthDate
pincode         String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YY                          Expiry date on the document
issueDate
expiryDate                                                      YY format

                                       String (Required), valid Pincode

                String (Required) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY

                                                format, should be a past Date

                String (Required) , Expiry Date as string in DD/MM/YYYY or DD-MM-YYYY

                                              format, should be a future Date

    {
          "merchantId": ".. merchantId ..",
          "save": "formData",
          "type": "identityProof",
          "data": {
                 "type": "passport",
                 "name": ".. name ..",
                 "birthDate": ".. dob ..",
                 "issueDate": ".. issueDate ..",
                 "expiryDate": ".. expiryDate ..",
                 "passportNumber": ".. passport number ..",
                 "address": ".. address ..",
                 "city": ".. city ..",
                 "state": ".. state ..",
                 "district": ".. district ..",
                 "pincode": ".. pincode .."
          }

    }

data Object details when POI is Driving License
```

## Source page 27

```text
    Property                                     Data type                                            Example values

type                                             Enum String (Required)                               “drivingLicence”

name               String (Required) , string of min length of 2 consisting of any characte           Name on POI document

                                                                            r

dob                String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YYYY            DOB on POI document

                                                 format

number                                           String (Required)                                    Driving License number on POI document

address                                          String (Required)                                    Address as on POI document

city                                             Enum String (Required)                               City as on POI document

state                                            Enum String (Required)                               State as on POI document, Refer 1st
                                                                                                                             column of Table 1.7

district                                         String (Required)                                    District as on POI document

pincode            String (Required), valid Pincode                                                   Pincode

issueDate          String (Required) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY for           Issue date on the document

                                                        mat, should be a past Date

expiryDate String (Required) , Expiry Date as string in DD/MM/YYYY or DD-MM-YYYY fo                   Expiry date on the document

                                                          rmat, should be a future Date

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "identityProof",
      "data": {
             "type": "drivingLicence",
             "name": ".. name ..",
             "expiryDate": "... expiryDate ..",
             "number": ".. DL number ..",
             "dob": ".. dob .. ",
             "issueDate": ".. issueDate ...",
             "address": ".. address ..",
             "city": ".. city ..",
             "state": ".. state ..",
             "district": ".. district ..",
             "pincode": ".. pincode .."
      }

}

data Object details when POI is VoterId

Property                                         Data type                                                                  Example values
                                                                                                                                       “voterId”
type                                          Enum String (Required)
name                                                                                                              Name on POI document
                   String (Required) , string of min length of 2 consisting of any ch
                                                                                                                    DOB on POI document
                                                                  aracter                             VoterId number on POI document

dob                String (Required) , date of birth as string in DD/MM/YYYY or DD-MM                      Address as on POI document

                                                 -YYYY format

epicNumber                                       String (Required)
address                                          String (Required)
```

## Source page 28

```text
     Property                                       Data type                                            Example values
   city
   state           Enum String (Required)                                                                City as on POI document
   district
   pincode         Enum String (Required)                                                  State as on POI document, Refer 1st column of
                                                                                                                                              Table 1.7

                                                    String (Required)                                    District as on POI document

                   String (Required), valid Pincode                                                      Pincode

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "identityProof",
      "data": {
             "type": "voterId",
             "epicNumber": ".. voterId number ..",
             "name": ".. name ..",
             "dob": ".. dob ..",
             "state": ".. state ..",
             "district": ".. district ..",
             "address": ".. address ..",
             "city": ".. city ..",
             "pincode": ".. pincode .."
      }

}

data Object details when POI is Offline Aadhaar

       Property                                     Data type                                            Example values

type                                                Enum String (Required)                               “aadhaarXml”

name               String (Required) , string of min length of 2 consisting of                           Name on POI document

                                                        any character

uid                String (Required), string of 8 zeros followed by 4 digits                             Aadhaar number

address                                             String (Required)                                    Address as on POI document

city                                                Enum String (Required)                               City as on POI document

state                                               Enum String (Required)                 State as on POI document, Refer 1st column
                                                                                                                                       of Table 1.7

district                                            String (Required)                                    District as on POI document

pincode                                             String (Required), valid Pincode                     Pincode

dob                String (Required) , date of birth as string in DD/MM/YYYY or                          DOB on POI document

                                                    DD-MM-YYYY format

generationDateTime String (Required) , concat the generationDate and generation            Generation date and time on POI document

                                                                                     Time

dateDifference     Number (Required) , dateDiffence                                                      dateDifference on POI document

        {
              "merchantId": ".. merchantId ..",
              "save": "formData",
              "type": "identityProof",
              "data": {
                     "type": "aadhaarXml",
```

## Source page 29

```text
                     "name": ".. person name ..",
                     "uid": "..12 digit UID ..",
                     "address": ".. address ..",
                     "city": ".. city ..",
                     "state": ".. state ..",
                     "district": ".. district ..",
                     "pincode": ".. pincode ..",
                     "dob": ".. dob ..",
                     "generationDateTime": "..generationDate+generationTime..",
                     "dateDifference": ..dateDifference..
              }
       }

data Object details when POI is Aadhaar DigiLocker

Property                                    Data type                                                                    Example values
                                                                                                                     “aadhaarDigiLocker”
type                                        Enum String (Required)
                                                                                                               Name on POI document
name      String (Required) , string of min length of 2 consisting of any ch
                                                                                                                         Aadhaar number
                                                         aracter                                        Address as on POI document

uid       String (Required), string of 8 zeros followed by 4 digits                                           City as on POI document
                                                                                 State as on POI document, Refer 1st column of
address                                     String (Required)
                                                                                                                                    Table 1.7
city                                        Enum String (Required)                                        District as on POI document

state                                       Enum String (Required)                                                                   Pincode

district                                 String (Required)                                                       DOB on POI document
pincode
dob                            String (Required), valid Pincode

          String (Required) , date of birth as string in DD/MM/YYYY or DD-MM

                                                     -YYYY format

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "identityProof",
      "data": {
             "type": "aadhaarDigiLocker",
             "name": ".. person name ..",
             "uid": "..12 digit UID ..",
             "address": ".. address ..",
             "city": ".. city ..",
             "state": ".. state ..",
             "district": ".. district ..",
             "pincode": ".. pincode ..",
             "dob": ".. dob .."
      }

}

data Object details when POI is PAN DigiLocker

Property                                        Data type                                                              Example values
                                                                                                                         “panDigiLocker”
type                                        Enum String (Required)                                            Name on POI document
                                                                                                               DOB on POI document
name      String (Required) , string of min length of 2 consisting of any character

dob       String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YYYY format
```

## Source page 30

```text
     Property                                   Data type                                                                        Example values
                                                                                                               PAN number on POI document
number                                          String (Required) , valid PAN number                           PAN number on POI document

fatherName         String (Required) , string of min length of 2 consisting of any character

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "identityProof",
      "data": {
             "type": "panDigiLocker",
             "name": ".. name ..",
             "fatherName": ".. fatherName ..",
             "number": ".. Pan number ..",
             "dob": ".. dob .."
      }

}

data Object details when POI is Driving License DigiLocker

Property                                        Data type                                                                                       Example values
                                                                                                                                                    “dlDigiLocker”
type                                            Enum String (Required)
                                                                                                                                      Name on POI document
name               String (Required) , string of min length of 2 consisting of any characte
                                                                                                                                        DOB on POI document
                                                                            r                                  Driving License number on POI document

dob                String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YYYY                                     Address as on POI document
                                                                                                                                     City as on POI document
                                                format
                                                                                                                     State as on POI document, Refer 1st
number                                          String (Required)                                                                            column of Table 1.7

address                                         String (Required)                                                                District as on POI document
                                                                                                                                                            Pincode
city                                            Enum String (Required)
                                                                                                                                 Issue date on the document
state                                           Enum String (Required)
                                                                                                                                Expiry date on the document
district                                        String (Required)

pincode                                         String (Required), valid Pincode

issueDate          String (Required) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY for

                                                        mat, should be a past Date

expiryDate         String (Required) , Expiry Date as string in DD/MM/YYYY or DD-MM-YYYY fo

                                                     rmat, should be a future Date

        {
              "merchantId": ".. merchantId ..",
              "save": "formData",
              "type": "identityProof",
              "data": {
                     "type": "dlDigiLocker",
                     "name": ".. name ..",
                     "expiryDate": "... expiryDate ..",
                     "number": ".. DL number ..",
                     "dob": ".. dob .. ",
                     "issueDate": ".. issueDate ...",
                     "address": ".. address ..",
                     "city": ".. city ..",
                     "state": ".. state ..",
```

## Source page 31

```text
                     "district": ".. district ..",
                     "pincode": ".. pincode .."
              }
       }

 EXPECTED OUTPUT

        {
              "object": "Updated Successfully"

       }

Execute POA

Extraction API for POA documents

ENDPOINT

/api/onboardings/execute

HEADERS

Property      Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                                               Data type                                                                                  Example values

    Property                                                                                                          userId from investor login response

merchantId    String (Required) alphanumeric string of leng                               Metadata along with actual payload to be executed upon
                                                                                                                                                          “identity”
                                               th 24
                                                                                                   “aadhaar” / “passport” / “drivingLicence” / “voterid”
inputData                 Object (Required)                                                                                                   “autoRecognition”
                                                                                                                                                           payload
– service                 Enum String (Required)
                                                                               An array of image URLs of the ID card, front and back in order. In
– type                    Enum String (Required)                                     case of PAN, pass URL of front Image and in case of Driving
                                                                                        License pass URLs of either front or both sides of images.
– task                    Enum String (Required)
                                                                                                                                                         “address”
– data                    Object (Required)

—- images     Array (Required) array of length 2(incase of

              'aadhaar', 'voterid', 'passport'), length 1 o
                     r 2 (incase of DL) with valid URLs.

—-                        Enum String (Required)
proofType

        {
              "merchantId": ".......",
              "inputData": {
                     "service": "identity",
                     "type": "aadhaar / passport / drivingLicence / voterid",
                     "task": "autoRecognition",
                     "data": {
                           "images": [
                                  "...direct url to the images ...",
                                  "...direct url to the images ..."
```

## Source page 32

```text
                           ],
                           "toVerifyData": {},
                           "searchParam": {},
                           "proofType": "address"
                     }
              }
       }

INPUT FOR OFFLINE AADHAAR                          Data type                                             Example values

     Property

merchantId    String (Required) alphanumeric string of length 24                                         userId from investor login response

inputData                                          Object (Required)       Metadata along with actual payload to be executed upon

– service                                          Enum String (Required)                                “identity”

– type                                             Enum String (Required)                                “aadhaar”

– task                                             Enum String (Required)                                “offlineAadhaar”

– data                                             Object (Required)                                     payload

—- images                  Array (Required) empty array                                                  In case of Offline Aadhaar pass empty array []

—- url                                             Enum String (Required)                                “url of zip or xml file ”

—- password                                        Enum String (Required)  “password of the zip file (Required only if the file is zip) ”

—- proofType                                       Enum String (Required)                                “address”

{
      "merchantId": ".......",
      "inputData": {
             "service": ".......",
             "type": "aadhaar",
             "task": "offlineAadhaar",
             "data": {
                   "images": [],
                   "url":".. url of zip or xml file (only for offlineAadhaar)...",
                   "password": ".. password of the zip file (only for offlineAadhaar and zip file) ..",
                   "toVerifyData": {},
                   "searchParam": {},
                   "proofType": "address"
             }
      }

}

FOR AADHAAR, DL DIGILOCKER

Must hit the execute API twice,
1) First with task as createUrl.
2) In response, will receive a url to grant permission from DigiLocker to access the documents.
3) After completion of the process, Hit the same API with task as getDetails.
Input

  Property                               Data type                                                                               Example values
merchantId    String (Required) alphanumeric string of length 24                                         userId from investor login response
```

## Source page 33

```text
      Property                 Data type                                                                          Example values
   inputData              Object (Required)
   – service          Enum String (Required)                                         Metadata along with actual payload to be executed upon
   – type             Enum String (Required)
   – task             Enum String (Required)                                                                      “identity”
   – data                 Object (Required)
   —- images       Array (Required) empty array                                                                   “aadhaarDigiLocker” / “dlDigiLocker”
   —- proofType       Enum String (Required)
                                                                                                                  “createUrl” / “getDetails”

                                                                                                                  payload

                                                                                     In case of Aadhaar DigiLocker pass empty array []

                                                                                                                  “address”

        {
              "merchantId": ".......",
              "inputData": {
                     "service": ".......",
                     "type": ".......",
                     "task": "...creatUrl/getDetails....",
                     "data": {
                           "images": [],
                           "toVerifyData": {},
                           "searchParam": {},
                           "proofType": "address"
                     }
              }

       }

 EXPECTED OUTPUT

 Incase of Aadhar card

        {
              "object": {
                     "result": {
                           "uid": "...00000000XXXX....masked first eight digit...",
                           "vid": "...virtual UID...",
                           "name": "...name on id card...",
                           "yob": "...year of birth...",
                           "dob": "...date of birth...",
                           "pincode": "...pincode...",
                           "address": "...address as on card...",
                           "gender": "male/female",
                           "splitAddress": {
                                  "district": [],
                                  "state": [
                                         []
                                  ],
                                  "city": [],
                                  "pincode": " ",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": ""
                           },
                           "uidHash": "Secure Cryptographic conversion of UID"
                     }
              }

       }

 Incase of Driving License
```

## Source page 34

```text
        {
              "object": {
                     "result": {
                           "issueDate": "date-of-issue",
                           "dob": "dob",
                           "expiryDate": "date-of-expiry",
                           "name": "name",
                           "number": "dl number",
                           "guardianName": "name of guardian",
                           "address": "address",
                           "splitAddress": {
                                  "state": [
                                         []
                                  ],
                                  "district": [],
                                  "city": [],
                                  "pincode": "...pincode...",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": "...addressLine..."
                           },
                           "dlType": ["array-of-vehicle-class"]
                     }
              }

       }

 Incase of Passport

        {
              "object": {
                     "result": {
                           "parentsGuardianName": "..parentsGuardianName...",
                           "issueDate": "..issueDate..",
                           "expiryDate": "..expiryDate..",
                           "birthDate": "..birthDate..",
                           "name": "..name..",
                           "country": [
                                  "..country.."
                           ],
                           "nationality": "..nationality..",
                           "sex": "F/M",
                           "address": "..address..",
                           "pincode": "..pincode..",
                           "passportNumber": "..passportNumber..",
                           "fileNumber": "..fileNumber..",
                           "placeOfBirth": "..placeOfBirth..",
                           "placeOfIssue": "..placeOfIssue..",
                           "splitAddress": {
                                  "district": [
                                         "..district.."
                                  ],
                                  "state": [
                                         [
                                               "..state.."
                                         ]
                                  ],
                                  "city": [
                                         "..city.."
                                  ],
                                  "pincode": "..pincode..",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": "..addressLine.."
                           }
```

## Source page 35

```text
                     }
              }
       }

 Incase of VoterId

        {
              "object": {
                     "result": {
                           "epicNumber": "...epic number...",
                           "name": "...name...",
                           "fatherName": "...father name...",
                           "state": "...state name...",
                           "dob": "...date of birth...",
                           "yob": "...year of birth...",
                           "ageAsOn": "...age in year...",
                           "address": "...address found on card...",
                           "splitAddress": {
                                  "district": [
                                         "...name of district..."
                                  ],
                                  "state": [
                                         [
                                               "...name of state...",
                                               "WB"
                                         ]
                                  ],
                                  "city": [
                                         "...name of the city..."
                                  ],
                                  "pincode": "...pincode of the city...",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": "...address line on the card..."
                           }
                     }
              }

       }

 Incase of Offline Aadhaar

        {
              "object": {
                     "result": {
                           "name": "...name on id card...",
                           "yob": "...year of birth...",
                           "dob": "...date of birth...",
                           "gender": "male/female",
                           "emailHash": "...",
                           "mobileNoHash": "...",
                           "address": "..",
                           "photo": "..image url..",
                           "generationDate": ".. date ..",
                           "generationTime": ".. time ..",
                           "unixTimeStamp": 1589445464,
                           "dateDifference": 1,
                           "splitAddress": {
                                  "district": [],
                                  "state": [
                                         []
                                  ],
                                  "city": [],
                                  "pincode": " ",
                                  "country": [
                                         "IN",
```

## Source page 36

```text
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": ""
                           },
                           "x509Data": {
                                  "subjectName": "......",
                                  "certificate": "",
                                  "details": { },
                                  "validAadhaarDSC": "..yes/no..."
                           }
                     }
              }
       }

 Incase of DigiLocker(Aadhaar / DL) 1st Step

     {
           "result": {
                         "url": " ... url to permit DigiLocker Account ...",
                         "requestId": " .. id .."
                  }

     }

Incase of DigiLocker(DL) 2nd Step, the response will be similar to the respective cards as mentioned above.

Incase of Aadhaar Digilocker 2nd Step

        {
              "result": {
                     "type": "aadhaarDigiLocker",
                     "input": {
                           "images": [
                                  "..image.."
                           ]
                     },
                     "category": null,
                     "output": {
                           "uid": "...00000000XXXX....masked first eight digit...",
                           "vid": "...virtual UID...",
                           "name": "...name on id card...",
                           "yob": "...year of birth...",
                           "dob": "...date of birth...",
                           "pincode": "...pincode...",
                           "address": "...address as on card...",
                           "gender": "male/female",
                           "splitAddress": {
                                  "district": [],
                                  "state": [
                                         []
                                  ],
                                  "city": [],
                                  "pincode": " ",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": ""
                           },
                           "uidHash": "Secure Cryptographic conversion of UID"
                           "x509Data": {
                                  "subjectName": "",
                                  "certificate": "",
                                  "details": { },
                                  "validAadhaarDSC": "..yes/no..."
                           },
                           "photo": "..Image.."
                     }
```

## Source page 37

```text
              }
       }

Update form Address proof

Updates Permanent POA form data of a Merchant

Only the POA that has been approved for the distributor by the AMC will be accepted and any other ID uploaded will throw an error. So
if for a particular distributor, if DL card is the only approved POA, then uploading Aadhaar as POA will throw an error.

ENDPOINT

/api/onboardings/updateForm

HEADERS

Property           Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                          Data type                                                            Example values

   Property

merchantId String (Required) alphanumeric string of length 24 userId from investor login response field

save                         String (Required)                                                      “formData”

type                         String (Required)                                                      “addressProof”

data                         Object (Required)                                    payload, see below for details

data Object details when POA is Aadhaar

Property                                 Data type                                                                         Example values
                                                                                                                                     “aadhaar”
type                           Enum String (Required)
                                                                                                                Name on POA document
name         String (Required) , string of min length of 2 consisting of any cha
                                                                                                                           Aadhaar number
                                                              racter                                     Address as on POA document

uid                String (Required), string of 8 zeros followed by 4 digits                                   City as on POA document
                                                                                  State as on POA document, Refer 1st column of
address                        String (Required)
                                                                                                                                      Table 1.7
city                           Enum String (Required)                                                      District as on POA document

state                          Enum String (Required)                                                                                  Pincode

district                                     String (Required)                                                    DOB on POA document
pincode
dob                                String (Required), valid Pincode

             String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-

                                                          YYYY format
```

## Source page 38

```text
        {
              "merchantId": ".. merchantId ..",
              "save": "formData",
              "type": "addressProof",
              "data": {
                     "type": "aadhaar",
                     "name": ".. person name ..",
                     "uid": "..12 digit UID ..",
                     "address": ".. address ..",
                     "city": ".. city ..",
                     "pincode": ".. pincode ..",
                     "state": ".. state ..",
                     "district": ".. district ..",
                     "dob": ".. dob .."
              }

       }

data Object details when POA is Passport

      Property                                          Data type                                                                  Example values
                                                                                                                                            “passport”
type                                                    Enum String (Required)
                                                                                                                         Name on POA document
name            String (Required) , string of min length of 2 consisting of any chara                                              Passport number

                                                                    cter                                         Address as on POA document
                                                                                                                       City as on POA document
passportNumber                                          String (Required)
                                                                                                        State as on POA document, Refer 1st
address                                                 String (Required)                                                       column of Table 1.7

city                                                    Enum String (Required)                                     District as on POA document
                                                                                                                          DOB on POA document
state                                                   Enum String (Required)                                                                 Pincode

district                                         String (Required)                                                   Issue date on the document
birthDate
pincode         String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YY                              Expiry date on the document
issueDate
expiryDate                                                      YY format

                                       String (Required), valid Pincode

                String (Required) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY

                                                format, should be a past Date

                String (Required) , Expiry Date as string in DD/MM/YYYY or DD-MM-YYYY

                                              format, should be a future Date

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "addressProof",
      "data": {
            "type": "passport",
            "name": ".. name ..",
            "birthDate": ".. dob ..",
            "issueDate": ".. issueDate ..",
            "expiryDate": ".. expiryDate ..",
            "passportNumber": ".. passport number ..",
            "address": ".. address ..",
            "city": ".. city ..",
            "state": ".. state ..",
            "district": ".. district ..",
            "pincode": ".. pincode .."
```

## Source page 39

```text
              }
       }

data Object details when POA is Driving License

Property                                         Data type                                            Example values

type                                             Enum String (Required)                               “drivingLicence”

name               String (Required) , string of min length of 2 consisting of any characte           Name on POA document

                                                                            r

dob                String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YYYY            DOB on POA document

                                                 format

number                                           String (Required)                           Driving License number on POA document

address                                          String (Required)                                    Address as on POA document

city                                             Enum String (Required)                               City as on POA document

state                                            Enum String (Required)                               State as on POA document, Refer 1st
                                                                                                                              column of Table 1.7

district                                         String (Required)                                    District as on POA document

pincode            String (Required), valid Pincode                                                   Pincode

issueDate          String (Required) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY for           Issue date on the document

                                                        mat, should be a past Date

expiryDate String (Required) , Expiry Date as string in DD/MM/YYYY or DD-MM-YYYY fo                   Expiry date on the document

                                                          rmat, should be a future Date

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "addressProof",
      "data": {
             "type": "drivingLicence",
             "name": ".. name ..",
             "expiryDate": "... expiryDate ..",
             "number": ".. DL number ..",
             "dob": ".. dob .. ",
             "issueDate": ".. issueDate ...",
             "address": ".. address ..",
             "city": ".. city ..",
             "state": ".. state ..",
             "district": ".. district ..",
             "pincode": ".. pincode .."
      }

}

data Object details when POA is VoterId

Property                                         Data type                                                      Example values
                                                                                                                            “voterId”
type                                             Enum String (Required)
                                                                                                      Name on POA document
name               String (Required) , string of min length of 2 consisting of any c
                                                                                                       DOB on POA document
                                                                 haracter

                         String (Required) , date of birth as string in DD/MM/YYYY or DD-M
   dob

                                                                         M-YYYY format
```

## Source page 40

```text
     Property                                       Data type                                            Example values
   epicNumber
   address                                          String (Required)                                    VoterId number on POA document
   city
   state                                            String (Required)                                    Address as on POA document
   district
   pincode         Enum String (Required)                                                                City as on POA document

                   Enum String (Required)                                                    State as on POA document, Refer 1st column of
                                                                                                                                                 Table 1.7

                                                    String (Required)                                    District as on POA document

                   String (Required), valid Pincode                                                      Pincode

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "addressProof",
      "data": {
             "type": "voterId",
             "epicNumber": ".. voterId number ..",
             "name": ".. name ..",
             "dob": ".. dob ..",
             "state": ".. state ..",
             "district": ".. district ..",
             "address": ".. address ..",
             "city": ".. city ..",
             "pincode": ".. pincode .."
      }

}

data Object details when POA is Offline Aadhaar

       Property                                     Data type                                            Example values

type                                                Enum String (Required)                               “aadhaarXml”

name               String (Required) , string of min length of 2 consisting of                           Name on POA document

                                                        any character

uid                String (Required), string of 8 zeros followed by 4 digits                             Aadhaar number

address                                             String (Required)                                    Address as on POA document

city                                                Enum String (Required)                               City as on POA document

state                                               Enum String (Required)                   State as on POA document, Refer 1st column
                                                                                                                                          of Table 1.7

district                                            String (Required)                                    District as on POA document

pincode                                             String (Required), valid Pincode                     Pincode

dob                String (Required) , date of birth as string in DD/MM/YYYY or                          DOB on POA document

                                                    DD-MM-YYYY format

                               String (Required) , concat the generationDate and generation  Generation date and time on POI document
generationDateTime

                                                                                     Time

dateDifference     Number (Required) , dateDiffence                                                      dateDifference on POA document
```

## Source page 41

```text
        {
              "merchantId": ".. merchantId ..",
              "save": "formData",
              "type": "addressProof",
              "data": {
                     "type": "aadhaarXml",
                     "name": ".. person name ..",
                     "uid": "..12 digit UID ..",
                     "address": ".. address ..",
                     "city": ".. city ..",
                     "state": ".. state ..",
                     "district": ".. district ..",
                     "pincode": ".. pincode ..",
                     "dob": ".. dob ..",
                     "generationDateTime": "..generationDate+generationTime..",
                     "dateDifference": ..dateDifference..
              }

       }

data Object details when POA is Aadhaar DigiLocker

Property  Data type                                                                                                       Example values
                                                                                                                      “aadhaarDigiLocker”
type      Enum String (Required)
                                                                                                               Name on POA document
name      String (Required) , string of min length of 2 consisting of any ch
                                                                                                                          Aadhaar number
                                                         aracter                                        Address as on POA document

uid       String (Required), string of 8 zeros followed by 4 digits                                           City as on POA document
                                                                                 State as on POA document, Refer 1st column of
address   String (Required)
                                                                                                                                     Table 1.7
city      Enum String (Required)                                                                          District as on POA document

state     Enum String (Required)                                                                                                      Pincode

district                                 String (Required)                                                       DOB on POA document
pincode
dob                            String (Required), valid Pincode

          String (Required) , date of birth as string in DD/MM/YYYY or DD-MM

                                                     -YYYY format

    {
          "merchantId": ".. merchantId ..",
          "save": "formData",
          "type": "addressProof",
          "data": {
                 "type": "aadhaarDigiLocker",
                 "name": ".. person name ..",
                 "uid": "..12 digit UID ..",
                 "address": ".. address ..",
                 "city": ".. city ..",
                 "state": ".. state ..",
                 "district": ".. district ..",
                 "pincode": ".. pincode ..",
                 "dob": ".. dob .."
          }

    }

data Object details when POA is Driving License DigiLocker
```

## Source page 42

```text
    Property                                          Data type                                            Example values

type                                                  Enum String (Required)                               “dlDigiLocker”

name               String (Required) , string of min length of 2 consisting of any characte                Name on POA document

                                                                            r

dob                String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YYYY                 DOB on POA document

                                                      format

number                                                String (Required)                      Driving License number on POA document

address                                               String (Required)                                    Address as on POA document

city                                                  Enum String (Required)                               City as on POA document

state                                                 Enum String (Required)                               State as on POA document, Refer 1st
                                                                                                                                   column of Table 1.7

district                                              String (Required)                                    District as on POA document

pincode            String (Required), valid Pincode                                                        Pincode

issueDate          String (Required) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY for                Issue date on the document

                                                        mat, should be a past Date

expiryDate String (Required) , Expiry Date as string in DD/MM/YYYY or DD-MM-YYYY fo                        Expiry date on the document

                                                          rmat, should be a future Date

     {
           "merchantId": ".. merchantId ..",
           "save": "formData",
           "type": "addressProof",
           "data": {
                  "type": "dlDigiLocker",
                  "name": ".. name ..",
                  "expiryDate": "... expiryDate ..",
                  "number": ".. DL number ..",
                  "dob": ".. dob .. ",
                  "issueDate": ".. issueDate ...",
                  "address": ".. address ..",
                  "city": ".. city ..",
                  "state": ".. state ..",
                  "district": ".. district ..",
                  "pincode": ".. pincode .."
           }

     }

EXPECTED OUTPUT

     {
           "object": "Updated Successfully"

     }

Execute Correspondence POA

 Extraction API for POA documents

 ENDPOINT

 /api/onboardings/execute
```

## Source page 43

```text
 HEADERS

Property           Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                      Data type                                                                                                   Example values

    Property                                                                                                  userId from investor login response

merchantId         String (Required) alphanumeric string of leng                  Metadata along with actual payload to be executed upon
                                                                                                                                                  “identity”
                                                    th 24
                                                                                           “aadhaar” / “passport” / “drivingLicence” / “voterid”
inputData                  Object (Required)                                                                                          “autoRecognition”
                                                                                                                                                   payload
– service                  Enum String (Required)
                                                                       An array of image URLs of the ID card, front and back in order. In
– type                     Enum String (Required)                            case of PAN, pass URL of front Image and in case of Driving
                                                                                License pass URLs of either front or both sides of images.
– task                     Enum String (Required)
                                                                                                                                            “corrAddress”
– data                     Object (Required)

—- images          Array (Required) array of length 2(incase of

                   'aadhaar', 'voterid', 'passport'), length 1 o
                          r 2 (incase of DL) with valid URLs.

—-                         Enum String (Required)
proofType

{
      "merchantId": ".......",
      "inputData": {
             "service": "identity",
             "type": "aadhaar / passport / drivingLicence / voterid",
             "task": "autoRecognition",
             "data": {
                   "images": [
                          "...direct url to the images ...",
                          "...direct url to the images ..."
                   ],
                   "toVerifyData": {},
                   "searchParam": {},
                   "proofType": "corrAddress"
             }
      }

}

INPUT FOR OFFLINE AADHAAR      Data type                                                            Example values

     Property

merchantId         String (Required) alphanumeric string of length 24                               userId from investor login response

inputData                  Object (Required)                           Metadata along with actual payload to be executed upon

– service                  Enum String (Required)                                                   “identity”

– type                     Enum String (Required)                                                   “aadhaar”

– task                     Enum String (Required)                                                   “offlineAadhaar”

– data                     Object (Required)                                                        payload
```

## Source page 44

```text
      Property                 Data type                                                                 Example values
   —- images       Array (Required) empty array
   —- url                                                                                                In case of Offline Aadhaar pass empty array []
   —- password        Enum String (Required)
   —- proofType       Enum String (Required)                                                             “url of zip or xml file ”
                      Enum String (Required)
                                                                       “password of the zip file (Required only if the file is zip) ”

                                                                                                         “corrAddress”

{
      "merchantId": ".......",
      "inputData": {
             "service": ".......",
             "type": "aadhaar",
             "task": "offlineAadhaar",
             "data": {
                   "images": [],
                   "url":".. url of zip or xml file (only for offlineAadhaar)...",
                   "password": ".. password of the zip file (only for offlineAadhaar and zip file) ..",
                   "toVerifyData": {},
                   "searchParam": {},
                   "proofType": "corrAddress"
             }
      }

}

FOR AADHAAR, DL DIGILOCKER

Must hit the execute API twice,
1) First with task as createUrl.
2) In response, will receive a url to grant permission from DigiLocker to access the documents.
3) After completion of the process, Hit the same API with task as getDetails.
Input

Property           Data type                                                                             Example values

merchantId         String (Required) alphanumeric string of length 24                                    userId from investor login response

inputData          Object (Required)                                   Metadata along with actual payload to be executed upon

– service          Enum String (Required)                                                                “identity”

– type             Enum String (Required)                                                                “aadhaarDigiLocker” / “dlDigiLocker”

– task             Enum String (Required)                                                                “createUrl” / “getDetails”

– data             Object (Required)                                                                     payload

—- images          Array (Required) empty array                                                          In case of Aadhaar DigiLocker pass empty array []

—- proofType       Enum String (Required)                                                                “corrAddress”

        {
              "merchantId": ".......",
              "inputData": {
                     "service": ".......",
                     "type": "........",
                     "task": "...creatUrl/getDetails....",
                     "data": {
                           "images": [],
```

## Source page 45

```text
                           "toVerifyData": {},
                           "searchParam": {},
                           "proofType": "corrAddress"
                     }
              }
       }

 EXPECTED OUTPUT

 Incase of Aadhar card

        {
              "object": {
                     "result": {
                           "uid": "...00000000XXXX....masked first eight digit...",
                           "vid": "...virtual UID...",
                           "name": "...name on id card...",
                           "yob": "...year of birth...",
                           "dob": "...date of birth...",
                           "pincode": "...pincode...",
                           "address": "...address as on card...",
                           "gender": "male/female",
                           "splitAddress": {
                                  "district": [],
                                  "state": [
                                         []
                                  ],
                                  "city": [],
                                  "pincode": " ",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": ""
                           },
                           "uidHash": "Secure Cryptographic conversion of UID"
                     }
              }

       }

 Incase of Driving License

        {
              "object": {
                     "result": {
                           "issueDate": "date-of-issue",
                           "dob": "dob",
                           "expiryDate": "date-of-expiry",
                           "name": "name",
                           "number": "dl number",
                           "guardianName": "name of guardian",
                           "address": "address",
                           "splitAddress": {
                                  "state": [
                                         []
                                  ],
                                  "district": [],
                                  "city": [],
                                  "pincode": "...pincode...",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": "...addressLine..."
                           },
                           "dlType": ["array-of-vehicle-class"]
                     }
```

## Source page 46

```text
              }
       }

 Incase of Passport

        {
              "object": {
                     "result": {
                           "parentsGuardianName": "..parentsGuardianName...",
                           "issueDate": "..issueDate..",
                           "expiryDate": "..expiryDate..",
                           "birthDate": "..birthDate..",
                           "name": "..name..",
                           "country": [
                                  "..country.."
                           ],
                           "nationality": "..nationality..",
                           "sex": "F/M",
                           "address": "..address..",
                           "pincode": "..pincode..",
                           "passportNumber": "..passportNumber..",
                           "fileNumber": "..fileNumber..",
                           "placeOfBirth": "..placeOfBirth..",
                           "placeOfIssue": "..placeOfIssue..",
                           "splitAddress": {
                                  "district": [
                                         "..district.."
                                  ],
                                  "state": [
                                         [
                                               "..state.."
                                         ]
                                  ],
                                  "city": [
                                         "..city.."
                                  ],
                                  "pincode": "..pincode..",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": "..addressLine.."
                           }
                     }
              }

       }

 Incase of VoterId

        {
              "object": {
                     "result": {
                           "epicNumber": "...epic number...",
                           "name": "...name...",
                           "fatherName": "...father name...",
                           "state": "...state name...",
                           "dob": "...date of birth...",
                           "yob": "...year of birth...",
                           "ageAsOn": "...age in year...",
                           "address": "...address found on card...",
                           "splitAddress": {
                                  "district": [
                                         "...name of district..."
                                  ],
                                  "state": [
                                         [
                                               "...name of state...",
```

## Source page 47

```text
                                               "WB"
                                         ]
                                  ],
                                  "city": [
                                         "...name of the city..."
                                  ],
                                  "pincode": "...pincode of the city...",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": "...address line on the card..."
                           }
                     }
              }
       }

 Incase of Offline Aadhaar

        {
              "object": {
                     "result": {
                           "name": "...name on id card...",
                           "yob": "...year of birth...",
                           "dob": "...date of birth...",
                           "gender": "male/female",
                           "emailHash": "...",
                           "mobileNoHash": "...",
                           "address": "..",
                           "photo": "..image url..",
                           "generationDate": ".. date ..",
                           "generationTime": ".. time ..",
                           "unixTimeStamp": 1589445464,
                           "dateDifference": 1,
                           "splitAddress": {
                                  "district": [],
                                  "state": [
                                         []
                                  ],
                                  "city": [],
                                  "pincode": " ",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": ""
                           },
                           "x509Data": {
                                  "subjectName": "......",
                                  "certificate": "",
                                  "details": { },
                                  "validAadhaarDSC": "..yes/no..."
                           }
                     }
              }

       }

 Incase of DigiLocker(Aadhaar / DL) 1st Step

        {
              "result": {
                           "url": " ... url to permit DigiLocker Account ...",
                           "requestId": " .. id .."
                     }

       }
```

## Source page 48

```text
Incase of DigiLocker(DL) 2nd Step, the response will be similar to the respective cards as mentioned above.

Incase of Aadhaar Digilocker 2nd Step

{
      "result": {
             "type": "aadhaarDigiLocker",
             "input": {
                   "images": [
                          "..image.."
                   ]
             },
             "category": null,
             "output": {
                   "uid": "...00000000XXXX....masked first eight digit...",
                   "vid": "...virtual UID...",
                   "name": "...name on id card...",
                   "yob": "...year of birth...",
                   "dob": "...date of birth...",
                   "pincode": "...pincode...",
                   "address": "...address as on card...",
                   "gender": "male/female",
                   "splitAddress": {
                          "district": [],
                          "state": [
                                 []
                          ],
                          "city": [],
                          "pincode": " ",
                          "country": [
                                 "IN",
                                 "IND",
                                 "INDIA"
                          ],
                          "addressLine": ""
                   },
                   "uidHash": "Secure Cryptographic conversion of UID"
                   "x509Data": {
                          "subjectName": "",
                          "certificate": "",
                          "details": { },
                          "validAadhaarDSC": "..yes/no..."
                   },
                   "photo": "..Image.."
             }
      }

}

Update form POA correspondence address proof

Updates Correspondence POA form data of a Merchant.

Only the POA that has been approved for the distributor by the AMC will be accepted and any other ID uploaded will throw an error. So
if for a particular distributor, if DL is the only approved POA, then uploading Aadhaar as POA will throw an error.

ENDPOINT

/api/onboardings/updateForm

HEADERS

Property           Value

Content-type application/json
```

## Source page 49

```text
Property           Value

Authorization …access token… (alphanumeric string of length 64)

INPUT                     Data type                                                                 Example values

   Property

merchantId String (Required) alphanumeric string of length 24 userId from investor login response field

save                      String (Required)                                                         “formData”

type                      String (Required)                                                         “corrAddressProof”

data                      Object (Required)                                       payload, see below for details

Incase Communication address is different from Permanent Address
data Object details when POA is Aadhaar

Property                  Data type                                                                                        Example values
                                                                                                                                     “aadhaar”
type                      Enum String (Required)
                                                                                                                Name on POA document
name         String (Required) , string of min length of 2 consisting of any cha
                                                                                                                           Aadhaar number
                                                              racter                                     Address as on POA document

uid                String (Required), string of 8 zeros followed by 4 digits                                   City as on POA document
                                                                                  State as on POA document, Refer 1st column of
address                   String (Required)
                                                                                                                                      Table 1.7
city                      Enum String (Required)                                                           District as on POA document

state                     Enum String (Required)                                                                                       Pincode

district                  String (Required)                                                                       DOB on POA document

pincode                   String (Required), valid Pincode

dob          String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-

                          YYYY format

    {
          "merchantId": ".. merchantId ..",
          "save": "formData",
          "type": "corrAddressProof",
          "data": {
                 "type": "aadhaar",
                 "name": ".. person name ..",
                 "uid": "..12 digit UID ..",
                 "address": ".. address ..",
                 "city": ".. city ..",
                 "state": ".. state ..",
                 "district": ".. district ..",
                 "pincode": ".. pincode ..",
                 "dob": ".. dob .."
          }

    }

data Object details when POA is Passport
```

## Source page 50

```text
        Property                                         Data type                                       Example values

type                                                     Enum String (Required)                          “passport”

name               String (Required) , string of min length of 2 consisting of any chara                 Name on POA document

                                                                       cter

passportNumber                                           String (Required)                                                Passport number
address                                                  String (Required)                               Address as on POA document

city                                                     Enum String (Required)                          City as on POA document

state                                                    Enum String (Required)                          State as on POA document, Refer 1st
                                                                                                                                 column of Table 1.7

district                                            String (Required)                                    District as on POA document
birthDate                                                                                                      DOB on POA document
                   String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YY

                                                                   YY format

pincode            String (Required), valid Pincode                                                      Pincode

issueDate          String (Required) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY                  Issue date on the document

                                                  format, should be a past Date

expiryDate         String (Required) , Expiry Date as string in DD/MM/YYYY or DD-MM-YYYY                 Expiry date on the document

                                                 format, should be a future Date

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "corrAddressProof",
      "data": {
             "type": "passport",
             "name": ".. name ..",
             "birthDate": ".. dob ..",
             "issueDate": ".. issueDate ..",
             "expiryDate": ".. expiryDate ..",
             "passportNumber": ".. passport number ..",
             "address": ".. address ..",
             "city": ".. city ..",
             "state": ".. state ..",
             "district": ".. district ..",
             "pincode": ".. pincode .."
      }

}

data Object details when POA is Driving License

Property                                                 Data type                                       Example values

type                                              Enum String (Required)                                             “drivingLicence”
name                                                                                                     Name on POA document
                   String (Required) , string of min length of 2 consisting of any characte

                                                                            r

dob                String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YYYY               DOB on POA document

                                                         format

number                                                   String (Required)                   Driving License number on POA document
address                                                  String (Required)                                   Address as on POA document
```

## Source page 51

```text
    Property                                     Data type                                            Example values

city                                             Enum String (Required)                               City as on POA document

state                                            Enum String (Required)                               State as on POA document, Refer 1st
                                                                                                                              column of Table 1.7

district                                         String (Required)                                    District as on POA document

pincode            String (Required), valid Pincode                                                   Pincode

issueDate          String (Required) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY for           Issue date on the document

                                                        mat, should be a past Date

                  String (Required) , Expiry Date as string in DD/MM/YYYY or DD-MM-YYYY fo            Expiry date on the document
expiryDate

                                                          rmat, should be a future Date

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "corrAddressProof",
      "data": {
             "type": "drivingLicence",
             "name": ".. name ..",
             "expiryDate": "... expiryDate ..",
             "number": ".. DL number ..",
             "dob": ".. dob .. ",
             "issueDate": ".. issueDate ...",
             "address": ".. address ..",
             "city": ".. city ..",
             "state": ".. state ..",
             "district": ".. district ..",
             "pincode": ".. pincode .."
      }

}

data Object details when POA is VoterId

Property                                         Data type                                            Example values

type                                             Enum String (Required)                               “voterId”

name               String (Required) , string of min length of 2 consisting of any c                  Name on POA document

                                                                 haracter

dob                String (Required) , date of birth as string in DD/MM/YYYY or DD-M                  DOB on POA document

                                                 M-YYYY format

epicNumber                                       String (Required)                                    VoterId number on POA document

address                                          String (Required)                                    Address as on POA document

city                                             Enum String (Required)                                            City as on POA document
state                                            Enum String (Required)
                                                                                      State as on POA document, Refer 1st column of
                                                                                                                                          Table 1.7

district                                         String (Required)                                    District as on POA document

pincode            String (Required), valid Pincode                                                   Pincode

        {
              "merchantId": ".. merchantId ..",
              "save": "formData",
```

## Source page 52

```text
              "type": "corrAddressProof",
              "data": {

                     "type": "voterId",
                     "epicNumber": ".. voterId number ..",
                     "name": ".. name ..",
                     "dob": ".. dob ..",
                     "state": ".. state ..",
                     "district": ".. district ..",
                     "address": ".. address ..",
                     "city": ".. city ..",
                     "pincode": ".. pincode .."
              }
       }

data Object details when POA is Offline Aadhaar

       Property                                             Data type                                            Example values

type                                                        Enum String (Required)                               “aadhaarXml”

name             String (Required) , string of min length of 2 consisting of                                     Name on POA document

                                                      any character

uid              String (Required), string of 8 zeros followed by 4 digits                                       Aadhaar number

address                                                     String (Required)                                    Address as on POA document

city                                                        Enum String (Required)                               City as on POA document

state                                                       Enum String (Required)            State as on POA document, Refer 1st column
                                                                                                                                           of Table 1.7

district                                                    String (Required)                                    District as on POA document

pincode                                                     String (Required), valid Pincode                     Pincode

dob              String (Required) , date of birth as string in DD/MM/YYYY or                                    DOB on POA document

                                                            DD-MM-YYYY format

generationDateTime String (Required) , concat the generationDate and generation               Generation date and time on POA document

                                                                                     Time

dateDifference   Number (Required) , dateDiffence                                                                dateDifference on POA document

    {
          "merchantId": ".. merchantId ..",
          "save": "formData",
          "type": "corrAddressProof",
          "data": {
                 "type": "aadhaarXml",
                 "name": ".. person name ..",
                 "uid": "..12 digit UID ..",
                 "address": ".. address ..",
                 "city": ".. city ..",
                 "state": ".. state ..",
                 "district": ".. district ..",
                 "pincode": ".. pincode ..",
                 "dob": ".. dob ..",
                 "generationDateTime": "..generationDate+generationTime..",
                 "dateDifference": ..dateDifference..
          }

    }

data Object details when POA is Aadhaar DigiLocker
```

## Source page 53

```text
   Property                                 Data type                                                      Example values

type                                        Enum String (Required)                                         “aadhaarDigiLocker”

name      String (Required) , string of min length of 2 consisting of any ch                               Name on POA document

                                                         aracter

uid                String (Required), string of 8 zeros followed by 4 digits                               Aadhaar number

address                                         String (Required)                                          Address as on POA document
city                                        Enum String (Required)                                              City as on POA document

state                                       Enum String (Required)            State as on POA document, Refer 1st column of
                                                                                                                                  Table 1.7

district                                    String (Required)                                              District as on POA document

pincode            String (Required), valid Pincode                                                        Pincode

dob       String (Required) , date of birth as string in DD/MM/YYYY or DD-MM                               DOB on POA document

                                            -YYYY format

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "corrAddressProof",
      "data": {
             "type": "aadhaarDigiLocker",
             "name": ".. person name ..",
             "uid": "..12 digit UID ..",
             "address": ".. address ..",
             "city": ".. city ..",
             "state": ".. state ..",
             "district": ".. district ..",
             "pincode": ".. pincode ..",
             "dob": ".. dob .."
      }

}

data Object details when POA is Driving License DigiLocker

Property                                    Data type                                                      Example values

type                                        Enum String (Required)                                         “dlDigiLocker”

name               String (Required) , string of min length of 2 consisting of any characte                Name on POA document

                                                                            r

dob                String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YYYY                 DOB on POA document

                                            format

number                                      String (Required)                                Driving License number on POA document

address                                     String (Required)                                              Address as on POA document

city                                        Enum String (Required)                                         City as on POA document

state                                       Enum String (Required)                                         State as on POA document, Refer 1st
                                                                                                                                   column of Table 1.7

district                                    String (Required)                                              District as on POA document

pincode                                     String (Required), valid Pincode                               Pincode
```

## Source page 54

```text
    Property                                     Data type                                                           Example values
                                                                                                       Issue date on the document
issueDate          String (Required) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY for           Expiry date on the document

                                                        mat, should be a past Date

expiryDate String (Required) , Expiry Date as string in DD/MM/YYYY or DD-MM-YYYY fo

                                                          rmat, should be a future Date

{
      "merchantId": ".. merchantId ..",
      "save": "formData",
      "type": "corrAddressProof",
      "data": {
             "type": "dlDigiLocker",
             "name": ".. name ..",
             "expiryDate": "... expiryDate ..",
             "number": ".. DL number ..",
             "dob": ".. dob .. ",
             "issueDate": ".. issueDate ...",
             "address": ".. address ..",
             "city": ".. city ..",
             "state": ".. state ..",
             "district": ".. district ..",
             "pincode": ".. pincode .."
      }

}

data Object details when POA is Gas Bill

Property                                         Data type                                                                       Example values
                                                                                                                                             “gasBill”
type                                             Enum String (Required)
                                                                                                                       Name on POA document
name               String (Required) , string of min length of 2 consisting of any characte                                       Gas Bill number

                                                                            r                                           DOB on POA document

number                                           String (Required)                                                                           Pincode

dob                String (Optional) , date of birth as string in DD/MM/YYYY or DD-MM-YYYY f                       Issue date on the document
                                                                                                               Address as on POA document
                                                 ormat
                                                                                                                     City as on POA document
pincode            String (Required), valid Pincode                                                   State as on POA document, Refer 1st

issueDate String (Optional) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY form                                           column of Table 1.7
                                                                                                                 District as on POA document
                                                            at, should be a past Date
                                                                                                                       URL of document image
address                                          String (Required)

city                                             Enum String (Required)

state                                            Enum String (Required)

district                                            String (Required)
images                                           URL String (Required)

        {
              "merchantId": ".. merchantId ..",
              "save": "formData",
              "type": "corrAddressProof",
              "data": {
                     "type": "gasBill",
                     "name": ".. person name ..",
```

## Source page 55

```text
                     "number": "..document number..",
                     "address": ".. address ..",
                     "city": ".. city ..",
                     "state": ".. state ..",
                     "district": ".. district ..",
                     "pincode": ".. pincode ..",
                     "dob": ".. dob ..",
                     "issueDate": ".. issue date ..",
                     "images": ".. image url .."
              }
       }

data Object details when other POA document

Property    Data type                                                                                                                                Example values
                                                               'passbook’ / 'bankStatement’ / 'dematStatement’ / 'rationCard’ / 'salesAgreement’ /
type        Enum String                                'telephoneBill’ / 'electricityBill’ / 'snecCertificate’ / 'flatMaintenanceBill’ / 'insuranceCopy’ /
             (Required)                                'selfDeclaration’ / 'powerOfAttorney’ / 'commercialBankProof’ / 'legislativeaddressProof’ /

name        String (Required) , str                                           'parliamentAddressProof’ / 'govtAddressProof’ / 'notaryAddressProof’ /
                                                                      'gazettedOfficerAddressProof’ / 'govtIdCard’ / 'statutoryIdCard’ / 'psuIdCard’ /
            ing of min length of 2                      'commercialBankIdCard’ / 'finanicalIdCard’ / 'collegeIdCard’ / 'professionalBodyIdCard’ /
            consisting of any char
                                                                                                                                            'nregaJobCard’ / 'others’
                         acter
                                                                                                                                           Name on POA document
number      String (Required)
                                                                                                                                                       Gas Bill number
            String (Optional) , date
                                                                                                                                            DOB on POA document
dob         of birth as string in
            DD/MM/YYYY or DD-MM-YY                                                                                                                               Pincode

            YY format                                                                                                                  Issue date on the document

pincode     String (Required), val                                                                                                    Expiry date on the document

                     id Pincode                                                                                                     Address as on POA document
                                                                                                                                         City as on POA document
issueDate   String (Optional) , Issu
                                                                                               State as on POA document, Refer 1st column of Table 1.7
             e Date as string in D                                                                                                   District as on POA document
            D/MM/YYYY or DD-MM-YYY                                                                                                          URL of document image
             Y format, should be a

                      past Date

expiryDate  String (Optional) , Expi

            ry Date as string in D
            D/MM/YYYY or DD-MM-YYY
             Y format, should be a

                     future Date

address     String (Required)

city        Enum String
             (Required)

state       Enum String
             (Required)

district    String (Required)

images      URL String (Required)

        {
              "merchantId": ".. merchantId ..",
              "save": "formData",
```

## Source page 56

```text
              "type": "corrAddressProof",
              "data": {

                     "type": "gasBill",
                     "name": ".. person name ..",
                     "number": "..document number..",
                     "address": ".. address ..",
                     "city": ".. city ..",
                     "state": ".. state ..",
                     "district": ".. district ..",
                     "pincode": ".. pincode ..",
                     "dob": ".. dob ..",
                     "issueDate": ".. issue date ..",
                     "expiryDate": ".. expiry date ..",
                     "images": ".. image url .."
              }
       }

Incase Communication address Proof is same as Permanent Address Proof
data Object details when Communication Address Proof is same as Permanent Address Proos

       Property         Data type                        Example values

sameAsPermanent Enum String (Required)                                 “true”

     {
           "merchantId": ".. merchantId ..",
           "save": "formData",
           "type": "corrAddressProof",
           "data": {
                  "sameAsPermanent": "true"
           }

     }

EXPECTED OUTPUT

     {
           "object": "Updated Successfully"

     }

Update form Address userForensics

Update forensics of form updation, must be ideally called after every step(identity / bankaccount / address / documents /fatca /
signature / photo / video / contract) of the onboading flow is complete inorder to collect user forensics corresponding the step

ENDPOINT

/api/onboardings/updateForm

HEADERS

Property         Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT
```

## Source page 57

```text
     Property       Data type                                                                       Example values

                   String (Required) alphanumeric                                                   userId from investor login response field
merchantId

                                 string of length 24

save               Enum String (*Required)                                                                                                    “formData”
                                                                                                                                       “userForensics”
type               Enum String (*Required)                                                                                    forensics data payload

data                Object (*Required)                                                                                                      “usersData”
                                                       contains forensics data grouped by steps (identity / bankaccount / address /
–type              Enum String (*Required)            documents /fatca / signature / photo / video / contract) in the onboarding flow

–userData           Object (*Required)

UserForensics object has 3 top level entries i.e geoLocationData, browserData, pageName, the description of userForensics object are
as follows:

       Property         Data type                                                                                                           Example values
geoLocationData     Object (Optional)                                                              Object as feteched from https://ipapi.co/jsonp
pageName                                              corresponding page’s name (identity / bankaccount / address / documents /fatca /
browserData            Enum String
–browserName            (Optional)                                                                                  signature / photo / video / contract)
–cookieEnabled                                                                                                                Details about browser used
–browserLanguage    Object (Optional)
–os                                                       Name of browser (can be extracted from browser’s global navigator.userAgent
–userAgent          String (Optional)                                                                                                                    Object)
–pluginsInstalled
–browserVersion     String (Optional)                                            whether cookie is enabled (source : navigator.cookieEnabled )
–screenWidth        String (Optional)                                                         Language of browser (source : navigator.language )
–screenHeight       String (Optional)
–screenPixelDepth   String (Optional)                                                   OS, browser is running on (source: navigator.platform )
                     Array of strings                                                       User Agent of browser (source: navigator.userAgent )

                        (Optional)                                                  List if plugin names in browser (source: navigator.plugins )
                    String (Optional)
                    String (Optional)                                         Version of browser (can be extracted from navigator.userAgent )
                    String (Optional)                  Screen width of browser (can be extracted from browser’s global screen Object)
                                                      Screen height of browser (can be extracted from browser’s global screen Object)
                    String (Optional)
                                                          Screen pixel depth of browser (can be extracted from browser’s global screen
–screenColorDepth   String (Optional)                                                                                                                    Object)

–                       Enum String                       Screen color depth of browser (can be extracted from browser’s global screen
signzyPlatformUsed       (Optional)                                                                                                                      Object)
–userLat
                    Decimal (Optional)                                                                                                    'Mobile’ / 'Desktop’
–userLong
                    Decimal (Optional)                                                                                                 Geolocation lattitude
–deviceInfo                                                                                                                           Geolocation Logitude
                     Object (Optional)                                                  Browser Info as fetched from https://wurfl.io/wurfl.js
```

## Source page 58

```text
        {
              "merchantId": ".......",
              "save": "formData",
              "type": "userForensics",
              "data": {
                     "type": "usersData",
                     "userData": {
                           "identity": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".....",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": "......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           },
                           "address": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           },
                           "bankaccount": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
```

## Source page 59

```text
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false

                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           }
                     }
              }
       }

 EXPECTED OUTPUT

        {
              "object": "Updated Successfully"

       }

Cancelled cheque execute

ENDPOINT

/api/onboardings/execute

HEADERS       Value

  Property

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                Data type                                                                                  Example values

    Property

merchantId    String (Required) alphanumer                                                                      userId from investor login response

                  ic string of length 24

inputData     Object (Required)                                                    Metadata along with actual payload to be executed upon

– service     Enum String (Required)                                                                            “identity”

– type        Enum String (Required)                                                                            “cheque”

– task        Enum String (Required)                                                                            “autoRecognition”

– data        Object (Required)                                                                                 payload

—- images     Array (Required) array of le                                         An array of image URLs of the ID card, front and back in order. In case of PAN, pass
                                                                                    URL of front Image and in case of Driving License pass URLs of either front or both
               ngth 1 containing valid URL                                                                                                                                    sides of images.

—-            Enum String (Required)                                                                            “cheque”
proofType

        {
              "merchantId": ".......",
              "inputData": {
```

## Source page 60

```text
                     "service": "identity",
                     "type": "cheque",
                     "task": "autoRecognition",
                     "data": {

                           "images": ["..direct url of the images one side or two sides .."],
                           "toVerifyData": {},
                           "searchParam": {},
                           "proofType": "cheque"
                     }
              }
       }

EXPECTED OUTPUT

     {
           "object": {
                  "result": {
                         "address": ".......",
                         "ifsc": ".......",
                         "accountNumber": ".......",
                         "micrCode": ".......",
                         "contact": ".......",
                         "name": ".......",
                         "splitAddress": {
                               "district": [
                                      "....."
                               ],
                               "state": [
                                      [
                                             ".....",
                                             "....."
                                      ]
                               ],
                               "city": [
                                      "....."
                               ],
                               "pincode": ".......",
                               "country": [
                                      ".....",
                                      ".....",
                                      "....."
                               ],
                               "addressLine": "......."
                         },
                         "pincode": "......."
                  }
           }

     }

Update form cancelled cheque

ENDPOINT

/api/onboardings/updateForm

HEADERS

Property  Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT
```

## Source page 61

```text
     Property                                                                                                Example values

merchantId String (Required) alphanumeric string of length 24 userId from investor login response field

save                                        String (Required)                                 “formData”

type                                        String (Required)                                 “bankAccount”

data                                        Object (Required)                                 payload, see below for details

data Object details

Property                                                       Data type                                                 Example values
                                                                                              Account number on cancelled cheque
accountNumber        String (Required) , string of min length of 9 and max length 18 consis
                                                                                                                                   document
                                                               ting of any digit                                     Name of acc. holder

name                 String (Optional), string of min length of 2 consisting of any digit                                         IFSC code
                                                                                                                            Mobile number
ifsc                      String (Required), alphanumeric string of length 11                         Micr code on cancelled cheque

contact                                     String (Optional) , valid 10 digit mobile number                                         Address

micrCode                                               String (Optional)

address                                                String (Optional)

     {
          "merchantId":"...",
          "save":"formData",
          "type":"bankAccount",
          "data":{
               "accountNumber":"...",
               "ifsc":"...",
               "micrCode":"....",
               "contact":"...",
               "name":"...",
               "address": "..."
          }

     }

EXPECTED OUTPUT

     {
           "object":"Updated successfully"

     }

Bank account penny transfer

ENDPOINT

/api/onboardings/execute

HEADERS

Property           Value

Content-type application/json
```

## Source page 62

```text
Property           Value

Authorization …access token… (alphanumeric string of length 64)

INPUT                       Data type                                                                 Example values

       Property

merchantId         String (Required) alphanumeric string of length 24                               userId from investor login response

inputData                   Object (Required)                                     Metadata along with actual payload to be executed upon

– service                   Enum String (Required)                                                    “nonRoc”

– type                      Enum String (Required)                                                    “bankaccountverifications”

– task                      Enum String (Required)                                                    “bankTransfer”

– data                      Object (Required)                                                         payload

—- searchParam              Object (Required)                                                         see below for details

searchParam Object details

Property                                                               Data type                      Example values

beneficiaryAccount String (Required) , string of min length of 9 and max length 18 consisting of any digit Account number

beneficiaryIFSC             String (Required), alphanumeric string of length 11                       IFSC code

beneficiaryMobile           String (Optional) , valid 10 digit mobile number                          Mobile number

beneficiaryName             String (Optional), string of min length of 2 consisting of any character  Benificiary Name

        {
              "merchantId": ".......",
              "inputData": {
                     "service": "nonRoc",
                     "type": "bankaccountverifications",
                     "task": "bankTransfer",
                     "data": {
                           "images": [],
                           "toVerifyData": {},
                           "searchParam": {
                                  "beneficiaryAccount": ".......",
                                  "beneficiaryIFSC": ".......",
                                  "beneficiaryName":"......",
                                  "beneficiaryMobile":"......"
                           }
                     }
              }

       }

 EXPECTED OUTPUT

        {
              "object": {
                     "result": {
                           "active": ".......",
                           "nameMatch": ".......",
                           "mobileMatch": ".......",
                           "signzyReferenceId": ".......",
                           "auditTrail": {
                                  "nature": ".......",
```

## Source page 63

```text
                                  "value": ".......",
                                  "timestamp": "......."
                           }
                     }
              }
       }

Execute verify bank account verifyAccount

ENDPOINT

/api/onboardings/execute

HEADERS

Property         Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                                                     Data type                                            Example values

       Property

merchantId       String (Required) alphanumeric string of length 24                                            userId from investor login response

inputData                                                 Object (Required)       Metadata along with actual payload to be executed upon

– service                                                 Enum String (Required)                               “nonRoc”

– type                                                    Enum String (Required)                               “bankaccountverifications”

– task                                                    Enum String (Required)                               “verifyAmount”

– data                                                    Object (Required)                                    payload

—- searchParam                                            Object (Required)                                    see below for details

searchParam Object details

Property                                                  Data type                                                                       Example values
                                                                                  Amount transferred from previous (Penny transfer) execute
amount                      Positive Number (Required)
                                                                                                                                                      API call
signzyId    String (Required), alphanumeric string of length 51 o
                                                                                   signzyReferenceId from Penny transfer API call’s response
                                                    r 52

        {
              "merchantId": ".......",
              "inputData": {
                     "service": "nonRoc",
                     "type": "bankaccountverifications",
                     "task": "verifyAmount",
                     "data": {
                           "images": [],
                           "toVerifyData": {},
                           "searchParam": {
                                  "amount": ".......",
                                  "signzyId": "......."
                           }
```

## Source page 64

```text
                     }
              }
       }

 EXPECTED OUTPUT

        {
              "object": {
                     "result": {
                           "amountMatch": "false | true",
                           "ownerName": ".......",
                           "mobile": ".......",
                           "mmid": "......."
                     }
              }

       }

Update form UserForensics after penny transfer verification

ENDPOINT

/api/onboardings/updateForm

HEADERS

Property  Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT

All field descriptions and respective validations are same as in the previously documented Userforensics update call

        {
              "merchantId": ".......",
              "save": "formData",
              "type": "userForensics",
              "data": {
                     "type": "usersData",
                     "userData": {
                           "identity": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
```

## Source page 65

```text
                                  },
                                  "pageName": "......."
                           },
                           "address": {
                                  "geoLocationData": {},
                                  "browserData": {

                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {

                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           },
                           "bankaccount": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           },
                           "documents": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
```

## Source page 66

```text
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           }
                     }
              }
       }

 EXPECTED OUTPUT

        {
              "object": "Updated Successfully"

       }

Update form call for FORMS section

ENDPOINT

/api/onboardings/updateForm

HEADERS     Value

  Property

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT

            Property                                                       Data type                                       Example values

merchantId                   String (Required), alphanumeric string of leng                                                userId from investor login response field

                                                              th 24

save                                                                       Enum String (Required)                          “formData”
type
data                                                                       Enum String (Required)                          “kycdata”
–type
–kycData                                                                   Object (Required)                               payload

                                                                           Enum String (Required)                          “kycdata”

                                                                           Object(Required)                                KYC data payload

—-gender                                                                   Enum String (Required)  investor’s Gender values: “F” / “M” / “T” for
                                                                                                                      Female, Male, Transgender

—-maritalStatus                                                            Enum String (Required)  investor’s marital status, values: “MARRIED” /
—-emailId                                                                                                                 “UNMARRIED” / “OTHERS”
—-annualIncome
                               String (Required) valid Email Id                                                            Email Id of Investor

                               Enum String (Optional), valid as per code in                                                Annual Income code (Refer Table 1.8)

                                                            table 1.8

—-nomineeRelationShip                                                      Enum String (Required)  Pass either “FATHER” or “SPOUSE”, accordingly
                                                                                                                           pass the name in “fatherName”
```

## Source page 67

```text
                 Property     Data type                                                             Example values

—-fatherName                  String (Required), string of min length of 2 c                        Pass the Father or Spouse name

                                              onsisting of any character

—-fatherTitle                 Enum String (Required)                           Pass the title of Father or Spouse, possible
                                                                                                              values “Mr.” / “Mrs.”

—-maidenName                  String (Optional), string of min length of 2 co  maiden name of investor provided investor is a
                                                                                                                                   Female
                                               nsisting of any character

—-maidenTitle                 Enum String (Optional)                           title for maiden name, values: “Mrs.” / “Ms.” /
                                                                                                                                   “Mx.”

—-motherName                  String (Required), string of min length of 2 c                        Investor mother name

                                              onsisting of any character

—-motherTitle                 Enum String (Required)                           Investor mother Title, values: “Mrs.” / “Ms.” /
                                                                                                                                  “Mx.”

—-panNumber                   String (Required), valid Pan Number or incase    Investors PAN number or incase of PAN EXEMPT
                                    of PAN EXEMPT cases pass PANEXEMPT                                                  pass PANEXEMPT

—-cvlExemptCode               String (Required incase of PAN EXEMPT cases                           PAN EXEMPT code (Refer Table 1.9)
                              for CVL KRA), valid as per code in table 1.9

—-aadhaarNumber               String (Optional), string of 8 zeros followed b                       Investor Aadhaar number

                                                           y 4 digits

—-citizenshipCountryCode      Enum String (Required)                                                Citizenship country code (Refer Table 1.1)

—-citizenshipCountry          String (Required)                                                     Citizenship country (Refer Table 1.1)

—-residentialStatus           String(Required)                                 Investor’s residential status, values: “Resident
                                                                                   Individual” / “Foreign National” / “Person of
                                                                                                                          Indian Origin”

—-occupationCode              Enum String(Required)                                                 Occupation Code (Refer Table 1.3)

—-occupationDescription       String(Required)                                                      Occupation Description (Refer Table 1.3)

—-occupationOther             String(Required in case of CVL KRA if                                 String of 50 characters
                                       Occupation Code is 99).

—-countryCode                 Number(Required)                                                      Country code of mobile number

—-mobileNumber                String(Required), valid 10 digit mobile numbe                         Mobile number

                                                                  r

—-permanentAddressCode        Enum String(Required), valid as per code in      Permanent Address code (Refer Table 1.6)

                                                           table 1.6

—-permanentAddressType        String(Required)                                 Permanent Address Type (Refer Table 1.6)

—-                            Enum String(Required), valid as per code in      Communication Address code (Refer Table 1.6)
communicationAddressCode
                                                           table 1.6

—-                            String(Required)                                 Communication Address Type (Refer Table 1.6)
communicationAddressType

—-applicationStatusCode       Enum String(Required), valid as per code in                           Application status code, (Refer Table 1.5)

                                                           table 1.5

—-                            String (Required)                                Application status description, (Refer Table 1.5)
applicationStatusDescription
```

## Source page 68

```text
                 Property                                            Data type                                       Example values
   —-kycAccountCode
   —-kycAccountDescription  Enum String(Required), valid as per code in                                              KYC account code, (Refer Table 1.4)
   —-placeOfBirth
                                                         table 1.4

                                                                     String (Required)  KYC account Description, (Refer Table 1.4)

                            String(Optional), string of min length of 2 co                                           Place of Brith

                                            nsisting of any character

     {
           "merchantId": ".......",
           "save": "formData",
           "type": "kycdata",
           "data": {
                  "type": "kycdata",
                  "kycData": {
                         "gender": ".......",
                         "maritalStatus": ".......",
                         "nomineeRelationShip": ".......",
                         "fatherTitle": ".......",
                         "maidenTitle": ".......",
                         "maidenName": ".......",
                         "panNumber": ".......",
                         "aadhaarNumber": ".......",
                         "motherTitle": ".......",
                         "residentialStatus": ".......",
                         "occupationDescription": ".......",
                         "occupationCode": ".......",
                         "kycAccountCode": ".......",
                         "kycAccountDescription": ".......",
                         "communicationAddressCode": ".......",
                         "communicationAddressType": ".......",
                         "permanentAddressCode": ".......",
                         "permanentAddressType": ".......",
                         "citizenshipCountryCode": ".......",
                         "citizenshipCountry": ".......",
                         "applicationStatusCode": ".......",
                         "applicationStatusDescription": ".......",
                         "mobileNumber": ".......",
                         "countryCode": 91,
                         "emailId": ".......",
                         "fatherName": ".......",
                         "motherName": ".......",
                         "placeOfBirth": "... placeOfBirth ..",
                         "annualIncome": ".. annualIncome .."
                  }
           }

     }

EXPECTED OUTPUT

     {
           "object": "Updated Successfully"

     }

Execute Related Person’s POI (incase Related Person is Applicable)

 Extraction API for Related Person’s POI documents

 ENDPOINT

 /api/onboardings/execute
```

## Source page 69

```text
 HEADERS

Property           Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                          Data type                                                                                                           Example values

    Property

merchantId         String (Required) alphanumeric string of length 2                                userId from investor login response

                                                          4

inputData                 Object (Required)                            Metadata along with actual payload to be executed upon

– service                 Enum String (Required)                                                                                                   “relatedIdentity”

– type                    Enum String (Required)                       “individualPan” / “aadhaar” / “passport” / “drivingLicence” /
                                                                                                                                         “voterid”

– task                    Enum String (Required)                                                                                                   “autoRecognition”

– data                    Object (Required)                                                                                                        payload

—- images          Array (Required) array of length 2(incase of 'aad   An array of image URLs of the ID card, front and back in order.
                                                                       In case of PAN, pass URL of front Image and in case of Driving
                   haar', 'voterid', 'passport'), length 1 (incase of
                   PAN) and, length 1 or 2 (incase of DL) with valid         License pass URLs of either front or both sides of images.

                                                        URLs.

—-                        Enum String (Required)                                                                                                   “identity”
proofType

        {
              "merchantId": ".......",
              "inputData": {
                     "service": ".......",
                     "type": ".......",
                     "task": ".......",
                     "data": {
                           "images": ["..direct url of the images of one side(incase of driving licence and PAN ) or two sides (for others) .."],
                           "toVerifyData": {},
                           "searchParam": {},
                           "proofType": "identity"
                     }
              }

       }

 EXPECTED OUTPUT

 Incase of PAN Card card

        {
              "object": {
                     "result": {
                           "name": "Name as on card",
                           "fatherName": "Father's name as on card",
                           "dob": "DOB as on card",
                           "number": "number as on card"
                     }
              }

       }

 Incase of Aadhar card
```

## Source page 70

```text
        {
              "object": {
                     "result": {
                           "uid": "...00000000XXXX....masked first eight digit...",
                           "vid": "...virtual UID...",
                           "name": "...name on id card...",
                           "yob": "...year of birth...",
                           "dob": "...date of birth...",
                           "pincode": "...pincode...",
                           "address": "...address as on card...",
                           "gender": "male/female",
                           "splitAddress": {
                                  "district": [],
                                  "state": [
                                         []
                                  ],
                                  "city": [],
                                  "pincode": " ",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": ""
                           },
                           "uidHash": "Secure Cryptographic conversion of UID"
                     }
              }

       }

 Incase of Driving License

        {
              "object": {
                     "result": {
                           "issueDate": "date-of-issue",
                           "dob": "dob",
                           "expiryDate": "date-of-expiry",
                           "name": "name",
                           "number": "dl number",
                           "guardianName": "name of guardian",
                           "address": "address",
                           "splitAddress": {
                                  "state": [
                                         []
                                  ],
                                  "district": [],
                                  "city": [],
                                  "pincode": "...pincode...",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": "...addressLine..."
                           },
                           "dlType": ["array-of-vehicle-class"]
                     }
              }

       }

 Incase of Passport

        {
              "object": {
                     "result": {
                           "parentsGuardianName": "..parentsGuardianName...",
                           "issueDate": "..issueDate..",
```

## Source page 71

```text
                           "expiryDate": "..expiryDate..",
                           "birthDate": "..birthDate..",
                           "name": "..name..",
                           "country": [

                                  "..country.."
                           ],
                           "nationality": "..nationality..",
                           "sex": "F/M",
                           "address": "..address..",
                           "pincode": "..pincode..",
                           "passportNumber": "..passportNumber..",
                           "fileNumber": "..fileNumber..",
                           "placeOfBirth": "..placeOfBirth..",
                           "placeOfIssue": "..placeOfIssue..",
                           "splitAddress": {

                                  "district": [
                                         "..district.."

                                  ],
                                  "state": [

                                         [
                                               "..state.."

                                         ]
                                  ],
                                  "city": [

                                         "..city.."
                                  ],
                                  "pincode": "..pincode..",
                                  "country": [

                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
                                  "addressLine": "..addressLine.."
                           }
                     }
              }
       }

 Incase of VoterId

        {
              "object": {
                     "result": {
                           "epicNumber": "...epic number...",
                           "name": "...name...",
                           "fatherName": "...father name...",
                           "state": "...state name...",
                           "dob": "...date of birth...",
                           "yob": "...year of birth...",
                           "ageAsOn": "...age in year...",
                           "address": "...address found on card...",
                           "splitAddress": {
                                  "district": [
                                         "...name of district..."
                                  ],
                                  "state": [
                                         [
                                               "...name of state...",
                                               "WB"
                                         ]
                                  ],
                                  "city": [
                                         "...name of the city..."
                                  ],
                                  "pincode": "...pincode of the city...",
                                  "country": [
                                         "IN",
                                         "IND",
                                         "INDIA"
                                  ],
```

## Source page 72

```text
                                  "addressLine": "...address line on the card..."
                           }
                     }
              }
       }

Update Fatca Form

ENDPOINT

/api/onboardings/updateForm

HEADERS

Property        Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT

            Property              Data type                                                                     Example values

merchantId                        String (Required), alpha                                                      userId from investor login response field

                                  numeric string of length
                                                   24

save                              Enum String (Required)                                                        “formData”

type                              Enum String (Required)                                                        “fatca”

data                              Object (Required)                                                             payload

–type                             Enum String (Required)                                                        “fatca”

–fatcaData                        Object (Required)                                                             fatca data

—-pep                             Enum String (Required)                           whether a 'politically exposed person’ values: “YES” / “NO”

—-rpep                            Enum String (Required)                           whether a 'related to a politically exposed person’ values: “YES” /
                                                                                                                                                                   “NO”

—-residentForTaxInIndia           Enum String (Required)                           whether a 'resident outside of India’ values: “YES” / “NO”

—-                                Enum String (Optional)                           Country of Jurisdiction of Residence code (Refer Table 1.1), to be
countryCodeJurisdictionResidence                                                                           provided given “residentForTaxInIndia” is “YES”

—-countryJurisdictionResidence    String(Optional)                                 Country of Jurisdiction of Residence (Refer Table 1.1), to be
                                                                                                   provided given “residentForTaxInIndia” is “YES”

—-taxIdentificationNumber         String(Optional)                                 Tax Identification Number, to be provided given
                                                                                                      “residentForTaxInIndia” is “YES”

—-placeOfBirth                    String(Optional)                                 Place of Birth, to be provided given “residentForTaxInIndia” is
                                                                                                                                                            “YES”

—-countryCodeOfBirth              Enum String(Optional)                            Country code of birth (Refer Table 1.1), to be provided given
                                                                                                                        “residentForTaxInIndia” is “YES”

—-countryOfBirth                  String(Optional)                                 Country of birth (Refer Table 1.1), to be provided given
                                                                                                                “residentForTaxInIndia” is “YES”
```

## Source page 73

```text
                     Property   Data type                                                           Example values

—-addressType                   String(Optional)                       Type of fatca address , values: “correspondence” / “others”, to be
                                                                                              provided given “residentForTaxInIndia” is “YES”

—-addressCity                   String(Optional)                       Fatca address city, to be provided given “residentForTaxInIndia” is
                                                                                                                                                       “YES”

—-addressDistrict               String (Optional)                           Fatca address district, to be provided given
                                                                                          “residentForTaxInIndia” is “YES”

—-addressStateCode              Enum String(Optional)                  Fatca address state code (Refer Table 1.2), to be provided given
                                                                                                                  “residentForTaxInIndia” is “YES”

—-addressState                  String(Optional)                       Fatca address State (Refer Table 1.2), to be provided given
                                                                                                           “residentForTaxInIndia” is “YES”

—-addressCountryCode            Enum String(Optional)                  Fatca address Country code (Refer Table 1.1), to be provided
                                                                                                      given “residentForTaxInIndia” is “YES”

—-addressCountry                String(Optional)                       Fatca address country (Refer Table 1.1), to be provided given
                                                                                                              “residentForTaxInIndia” is “YES”

—-addressPincode                String(Optional), valid                     Fatca address Pincode, to be provided given
                                                                                            “residentForTaxInIndia” is “YES”
                                            Pincode

—-address                       String(Optional)                       Fatca address, to be provided given “residentForTaxInIndia” is
                                                                                                                                                  “YES”

—-relatedPerson                 Enum String(Optional)                  whether a related person to investor or investor themselves,
                                                                                                                           values: “YES” / “NO”

—-relatedPersonType             Enum String(Optional)                     Type of related person, values: “1” / “2” / “3” for “Guardian of a
                                                                           Minor”, “Assignee”, “Authorised Representative” respectively,
                                                                       Required if related person is applicable (relatedPerson is “YES”)

—-relatedPersonKycNumberExists  Enum String(Optional)                  whether related person has a KYC number, values: “YES” / “NO”,
                                                                        Required if related person is applicable (relatedPerson is “YES”)

—-relatedPersonKycNumber        String (Optional), valid                    KYC number of related person (Required if
                                                                             relatedPersonKycNumberExists is “YES”)
                                          Kyc number

—-relatedPersonTitle            String                                 Related Person Title, values: “Mr.”/ “Mrs.” / “Ms.” / “Mx.”, Required
                                                                                      if related person is applicable (relatedPerson is “YES”)

—-relatedPersonName             String                                 Name of related person, Required if related person is applicable
                                                                                                                           (relatedPerson is “YES”)

—-relatedPersonIdentityProof    Object                                 Required if related person is applicable(relatedPerson is “YES”),
                                                                                                                                 see below for details

—-relatedPersonIdentityProofType Enum String(Optional)                       Type of related persons ID proof, values: “individualPan” /
                                                                       “aadhaar” / “passport” / “drivingLicence” / “voterId”, Required if

                                                                                   related person is applicable (relatedPerson is “YES”)

relatedPersonIdentityProof Object details when Related Person’s POI is PAN

Property                        Data type                                                                    Example values
                                                                                                                “individualPan”
type                            Enum String (Required)
                                                                                                    Name on POI document
name             String (Required) , string of min length of 2 consisting of any character           DOB on POI document

dob            String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YYYY format
```

## Source page 74

```text
     Property      Data type                                                                                    Example values
                                                                                              PAN number on POI document
number             String (Required) , valid PAN number                                       PAN number on POI document

fatherName         String (Required) , string of min length of 2 consisting of any character

relatedPersonIdentityProof Object details when Related Person’s POI is Aadhaar

Property           Data type                                                                                             Example values
                                                                                                                                   “aadhaar”
type               Enum String (Required)
                                                                                                               Name on POI document
name        String (Required) , string of min length of 2 consisting of any cha
                                                                                                                         Aadhaar number
                                                             racter                                     Address as on POI document

uid                String (Required), string of 8 zeros followed by 4 digits                                  City as on POI document
                                                                                 State as on POI document, Refer 1st column of
address            String (Required)
                                                                                                                                    Table 1.7
city               Enum String (Required)                                                                 District as on POI document

state              Enum String (Required)                                                                                            Pincode

district                                    String (Required)                                                    DOB on POI document
pincode
dob                               String (Required), valid Pincode

            String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-

                                                         YYYY format

relatedPersonIdentityProof Object details when Related Person’s POI is Passport

      Property     Data type                                                                                            Example values
                                                                                                                                 “passport”
type               Enum String (Required)
                                                                                                               Name on POI document
name               String (Required) , string of min length of 2 consisting of any chara                                Passport number

                                                                       cter                            Address as on POI document
                                                                                                             City as on POI document
passportNumber     String (Required)
                                                                                              State as on POI document, Refer 1st
address            String (Required)                                                                                 column of Table 1.7

city               Enum String (Required)                                                                District as on POI document
                                                                                                                DOB on POI document
state              Enum String (Required)                                                                                           Pincode

district                                            String (Required)                                     Issue date on the document
birthDate
pincode            String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YY                Expiry date on the document
issueDate
expiryDate                                                         YY format

                                          String (Required), valid Pincode

                   String (Required) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY

                                                   format, should be a past Date

                   String (Required) , Expiry Date as string in DD/MM/YYYY or DD-MM-YYYY

                                                 format, should be a future Date

  relatedPersonIdentityProof Object details when Related Person’s POI is Driving License
```

## Source page 75

```text
    Property       Data type                                                                        Example values

type               Enum String (Required)                                                           “drivingLicence”

name               String (Required) , string of min length of 2 consisting of any characte         Name on POI document

                                                                            r

dob                String (Required) , date of birth as string in DD/MM/YYYY or DD-MM-YYYY          DOB on POI document

                   format

number             String (Required)                                                                Driving License number on POI document

address            String (Required)                                                                Address as on POI document

city               Enum String (Required)                                                           City as on POI document

state              Enum String (Required)                                                           State as on POI document, Refer 1st
                                                                                                                           column of Table 1.7

district           String (Required)                                                                District as on POI document

pincode            String (Required), valid Pincode                                                 Pincode

issueDate          String (Required) , Issue Date as string in DD/MM/YYYY or DD-MM-YYYY for         Issue date on the document

                                                        mat, should be a past Date

expiryDate String (Required) , Expiry Date as string in DD/MM/YYYY or DD-MM-YYYY fo                 Expiry date on the document

                                                          rmat, should be a future Date

relatedPersonIdentityProof Object details when Related Person’s POI is VoterId

Property           Data type                                                                        Example values

type               Enum String (Required)                                                           “voterId”

name               String (Required) , string of min length of 2 consisting of any ch               Name on POI document

                                                                  aracter

dob                String (Required) , date of birth as string in DD/MM/YYYY or DD-MM               DOB on POI document

                   -YYYY format

epicNumber         String (Required)                                                                VoterId number on POI document

address            String (Required)                                                                Address as on POI document

city               Enum String (Required)                                                           City as on POI document

state              Enum String (Required)                                                   State as on POI document, Refer 1st column of
                                                                                                                                               Table 1.7

district           String (Required)                                                                District as on POI document

pincode            String (Required), valid Pincode                                                 Pincode

        {
            "merchantId":"...",
            "save":"formData",
            "type":"fatca",
            "data":{
                 "type":"fatca",
                 "fatcaData":{
                      "pep":"...",
                      "rpep":"...",
                      "residentForTaxInIndia":"...",
```

## Source page 76

```text
                      "relatedPerson":"...",
                      "addressType":"...",
                      "countryCodeJurisdictionResidence":"...",
                      "countryJurisdictionResidence":"...",
                      "taxIdentificationNumber":"...",
                      "placeOfBirth":"...",
                      "countryCodeOfBirth":"...",
                      "countryOfBirth":"...",
                      "addressCity":"...",
                      "addressDistrict":"...",
                      "addressStateCode":"...",
                      "addressState":"... ...",
                      "addressCountryCode":"...",
                      "addressCountry":"...",
                      "addressPincode": "543534",
                      "address":"...",
                      "relatedPersonType":"...",
                      "relatedPersonKycNumber":"44354355",
                      "relatedPersonKycNumberExists":"...",
                      "relatedPersonTitle":"....",
                      "relatedPersonIdentityProof":{

                           "name":"....",
                           "fatherName":"...",
                           "dob":"...",
                           "number":"..."
                      },
                      "relatedPersonName":"...",
                      "relatedPersonIdentityProofType":"..."
                 }
            }
       }

 EXPECTED OUTPUT

        {
              "object": "Updated Successfully"

       }

Update Form Signature

ENDPOINT

/api/onboardings/updateForm

HEADERS

Property           Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                                       Data type                                                                              Example values
                          String (Required) alphanumeric string                                     userId from investor login response field
         Property
  merchantId                                  of length 24                                                                                 “formData”
  save                                                                                                                                     “signature”
  type                                 String (Required)
                                       String (Required)
```

## Source page 77

```text
          Property                Data type                                                                         Example values
   data                      Object (Required)                                                                                  payload
   –type                 Enum String (Required)
   –                  String (Required) , valid URL                                                                         “signature”
   signatureImageUrl
                          Enum String(Optional)                                                                     Signature Image URL
   –consent
                                                                       Whether the signature to be linked with investor email ID for future
                                                                                                                     purposes. Value : “true” / “false”

     {
          "merchantId":".. merchantId ..",
          "save":"formData",
          "type":"signature",
          "data":{
               "type":"signature",
               "signatureImageUrl":".. signatureImageUrl ..",
               "consent":"true"
          }

     }

OUTPUT

     {
           "object":"Updated successfully"

     }

Update Form Photo

ENDPOINT

/api/onboardings/updateForm

HEADERS

Property     Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                          Data type                                                            Example values

   Property

merchantId String (Required) alphanumeric string of length 24 userId from investor login response field

save                         String (Required)                                                      “formData”

type                         String (Required)                                                      “userPhoto”

data                         Object (Required)                                                      payload

–photoUrl             String (Required) , valid URL                                                 User Photo URL

        {
            "merchantId":".. merchantId ..",
            "save":"formData",
```

## Source page 78

```text
            "type":"userPhoto",
            "data":{

                 "photoUrl":".. photo URL .."
            }
       }

 OUTPUT

        {
              "object":"Updated successfully"

       }

Execute to start video verification

ENDPOINT

/api/onboardings/execute

HEADERS

Property     Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                                          Data type                                            Example values

   Property

merchantId String (Required) alphanumeric string of length 24 userId from investor login response field

inputData                                      Object (Required)                                    payload

–service                  Enum String (Required)                                                    “video”

–type                     Enum String (Required)                                                    “video”

–task                     Enum String (Required)                                                    “start”

     {
          "merchantId":".. merchantId ..",
          "inputData":{
               "service":"video",
               "type":"video",
               "task":"start",
               "data":{}
          }

     }

EXPECTED OUTPUT

     {
           "object": [{
                  "transactionId": ".......",
                  "randNumber": "......."
           }]

     }
```

## Source page 79

```text
Execute recorded video

Note: Acceptable format : .mp4 format with video encoding of H264 and audio encoding of AAC (Advanced Audio Coding)

ENDPOINT

/api/onboardings/execute

HEADERS

Property           Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                                         Data type                                                                  Example values
                   String (Required) alphanumeric string of length 24                     userId from investor login response field
     Property
  merchantId                             Object (Required)                                                                           payload
  inputData                          Enum String (Required)                                                                           “video”
  –service                           Enum String (Required)                                                                           “video”
  –type                              Enum String (Required)                                                                           “verify”
  –task                                                                                              payload containing video details
  –data                                  Object(Required)                                                                        Video URL
  —-video                             URL String (Required)                       Image URL of snapshot from video containing
                                                                                                                                 user’s face
—-snapshot                     URL String (Optional)
                                                                                  transaction Id received in start video API call
—-                 String (Required), must be an alphanumeric string of length
transactionId                                            30                                URL of POI Image containg user Photo
—-
matchImage                                 URL String (Required)                       Array of moment strings at which face was
                                                                                  detected in the video" (Optional), must contain
—-seconds          Array of moment strings at which face was detected in the
                     video" (Optional), must contain moments in valid format,                         moments in valid format details
—-type                                                                                                                                “video”
                                            example : “00:00:08”

                                          Enum String (Required)

        {
            "merchantId":".. merchantId ..",
            "inputData":{
                 "service":"video",
                 "type":"video",
                 "task":"verify",
                 "data":{
                      "video":".. video URL ..",
                      "transactionId":".. transactionId ..",
                      "matchImage":".. URL of POI Image containg user Photo ..",
                      "seconds":[
                           "00:00:02",
                           "00:00:04",
                           "00:00:06",
                           "00:00:08"
                      ],
```

## Source page 80

```text
                      "type":"video"
                 }
            }
       }

 EXPECTED OUTPUT

        {
              "object": {
                     "n": 1,
                     "nModified": 1,
                     "ok": 1
              }

       }

Execute user forensics after video verification

ENDPOINT

/api/onboardings/updateForm

HEADERS

Property  Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT

All field descriptions and respective validations are same as in the previously documented Userforensics update call

        {
              "merchantId": ".......",
              "save": "formData",
              "type": "userForensics",
              "data": {
                     "type": "usersData",
                     "userData": {
                           "identity": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
```

## Source page 81

```text
                           },
                           "address": {

                                  "geoLocationData": {},
                                  "browserData": {

                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {

                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           },
                           "bankaccount": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           },
                           "documents": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
```

## Source page 82

```text
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           },
                           "contract": {
                                  "geoLocationData": {},
                                  "browserData": {

                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {

                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           }
                     }
              }
       }

 EXPECTED OUTPUT

        {
              "object": "......."

       }

Create Contract PDF URL

Creates a PDF which captures all details filled while onboarding.

ENDPOINT

/api/onboardings/execute

HEADERS

Property     Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                          Data type                                                                        Example values

   Property

merchantId String (Required) alphanumeric string of length 24 userId from investor login response field

inputData                 Object (Required)                                                                     payload
```

## Source page 83

```text
                          Enum String (Required)
     Property             Enum String (Required)                                                          Example values
   –service                                                                                                             “esign”
   –task
                                                                                                                  “createPdf”

     {
          "merchantId":".. merchant ID ..",
          "inputData":{
               "service":"esign",
               "type":"",
               "task":"createPdf",
               "data":{

               }
          }
     }

EXPECTED OUTPUT

     {
          "object":{
               "result":{
                    "combinedPdf":".. Unsigned PDF contract URL .."
               }
          }

     }

Generate Aadhaar Esign URL

Generate Aadhaar Esign URL to sign the Contract.

ENDPOINT

/api/onboardings/execute

HEADERS

Property           Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                                         Data type                                               Example values
                          String (Required) alphanumeric string of     userId from investor login response field
            Property
                                                   length 24                                                      payload
  merchantId                                                                                                       “esign”
  inputData                              Object (Required)                                             “createEsignUrl”
  –service                           Enum String (Required)                                                       payload
  –task                              Enum String (Required)
  –data
                                         Object (Required)
```

## Source page 84

```text
              Property   Data type                                                                         Example values

   —-inputFile           URL String (Required)                                Unsigned PDF contract URL (response from Create
                                                                                                                         Contract PDF URL)
   —-signatureType
   —-redirectUrl         ENUM Sting (Required)                                                             “aadhaaresign”
   —-redirectTime
   —-eventCallbackUrl    ENUM Sting (optional)                                                             “redirect URL”
   —-
   eventCallbackHeaders  number Integer (optional)                                                         “redirect time in seconds”

                         URL String (Optional)                                                             Callback on events of success and failure

                         Object (Optional)                                    In case of any headers needs to be passed for the
                                                                                                                          eventCallbackUrl

        {
              "merchantId":".. merchant ID ..",
              "inputData":{
                     "service": "esign",
                     "type": "",
                     "task": "createEsignUrl",
                     "data": {
                           "inputFile": ".. Unsigned PDF contract URL ..",
                           "signatureType": "aadhaaresign",
                           "redirectUrl": ".. redirect URL ..",
                           "redirectTime": ".. redirect time in seconds ..",
                           "eventCallbackUrl": ".. event Callback Url ..",
                           "eventCallbackHeaders": {
                                  " ..key.. ":".. value .."
                           }
                     }
              }

       }

 EXPECTED OUTPUT

        {
              "object": {
                     "task": "url",
                     "id": "....",
                     "customerId": "....",
                     "inputFile": "..inputUrl..",
                     "signatureType": "aadhaaresign",
                     "multiPages": "true",
                     "name": "..name..",
                     "showSignatureConsent": "...",
                     "email": "...emailId...",
                     "redirectUrl": "... redirect Url ...",
                     "createSignatureOptions": [],
                     "result": {
                           "token": "..token..",
                           "isUsed": 1,
                           "url": "..Aadhaar Esign Url...",
                           "uid": "",
                           "inputFile": "..inputUrl..",
                           "email": "...emailId...",
                           "redirectUrl": "... redirect Url ...",
                           "createSignatureOptions": [],
                           "signatureType": "aadhaaresign",
                           "name": "..name..",
                           "showSignatureConsent": "...",
                           "scaleSignature": "...",
                           "selectPage": 1,
                           "signaturePosition": "Bottom-Right",
                           "pageNo": 1
                     }
```

## Source page 85

```text
              }
       }

Save Aadhaar Esign Signed PDF

Save the Aadhaar Esign signed PDF.

ENDPOINT

/api/onboardings/execute

HEADERS

Property           Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                                    Data type                                                  Example values

   Property

merchantId String (Required) alphanumeric string of length 24 userId from investor login response field

inputData                                Object (Required)                                          payload

–service                  Enum String (Required)                                                    “esign”

–task                     Enum String (Required)                                                    “getEsignData”

{
      "merchantId":".. merchant ID ..",
      "inputData":{
             "service": "esign",
             "type": "",
             "task": "getEsignData",
             "data":{

             }
      }
}

 EXPECTED OUTPUT

        {
              "object": {
                     "customerId": "..",
                     "token": "...",
                     "id": 2341,
                     "result": {
                           "token": "...",
                           "isUsed": 0,
                           "url": ".. Unsigned PDF contract URL ..",
                           "uid": "",
                           "inputFile": "..inputUrl..",
                           "email": "...emailId...",
                           "createSignatureOptions": [],
                           "signatureType": "aadhaaresign",
                           "name": "..name..",
                           "showSignatureConsent": "...",
```

## Source page 86

```text
                           "scaleSignature": "...",
                           "selectPage": 1,
                           "signaturePosition": "Bottom-Right",
                           "pageNo": 1
                           "esignedFile": ".. Signed PDF URL ..",
                           "signatureImage": ""
                     },
                     "dscData": { }
              }
       }

Save Signed PDF (Normal Esign method only)

Saves Signed Contract PDF.

ENDPOINT

/api/onboardings/updateForm

HEADERS      Value

  Property

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT                                           Data type                                       Example values

   Property

merchantId String (Required) alphanumeric string of length 24 userId from investor login response field

save                Enum String (Required)                                                      “esign”

data                         Object (Required)                                                  payload

–signedPdf          URL String (Required)                                                       Signed PDF URL

     {
     "merchantId": ".. Merchant ID ..",
     "save": "esign",
     "data": {

           "signedPdf": ".. Signed PDF URL .."
           }
     }

EXPECTED OUTPUT

     {
           "object": "Updated successfully"

     }

Execute user forensics after contract

 ENDPOINT
```

## Source page 87

```text
 /api/onboardings/updateForm

HEADERS

Property  Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT

        {
              "merchantId": ".......",
              "save": "formData",
              "type": "userForensics",
              "data": {
                     "type": "usersData",
                     "userData": {
                           "identity": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           },
                           "address": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           },
                           "bankaccount": {
                                  "geoLocationData": {},
```

## Source page 88

```text
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833

                                  },
                                  "pageName": "......."
                           },
                           "documents": {
                                  "geoLocationData": {},
                                  "browserData": {

                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {

                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           },
                           "contract": {
                                  "geoLocationData": {},
                                  "browserData": {
                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {
                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
```

## Source page 89

```text
                           },
                           "thankyou": {

                                  "geoLocationData": {},
                                  "browserData": {

                                         "browserName": ".......",
                                         "cookieEnabled": ".......",
                                         "browserLanguage": ".......",
                                         "os": ".......",
                                         "userAgent": ".......",
                                         "pluginsInstalled": ["...."],
                                         "browserVersion": ".......",
                                         "screenWidth": ".......",
                                         "screenHeight": ".......",
                                         "screenPixelDepth": ".......",
                                         "screenColorDepth": ".......",
                                         "deviceInfo": {

                                               "complete_device_name": ".......",
                                               "form_factor": ".......",
                                               "is_mobile": false
                                         },
                                         "signzyPlatformUsed": ".......",
                                         "userLat": 12.9833,
                                         "userLong": 77.5833
                                  },
                                  "pageName": "......."
                           }
                     }
              }
       }

 EXPECTED OUTPUT

        {
              "object": "......."

       }

Execute verification engine

Executes verification on existing Onboarding information and updates it with results from verification insights.

Data which is required as per the AMC will be validated in this API. Distributor will get the error if the complete and the correct data is
not passed to the AMC.

ENDPOINT

/api/onboardings/execute

HEADERS

Property   Value

Content-type application/json

Authorization …access token… (alphanumeric string of length 64)

INPUT

Property                       Data type                                                                        Example values

merchantId String (Required) alphanumeric string of length 24 userId from investor login response field

inputData                 Object (Required)                                                                     payload
```

## Source page 90

```text
      Property                                                                                              Example values

–service                            Enum String (Required)             “verificationEngine”

–merchantId String (Required) alphanumeric string of length 24 userId from investor login response field

     {
           "merchantId": ".. merchantId ..",
           "inputData": {
                  "service": "verificationEngine",
                  "merchantId": "......."
           }

     }

EXPECTED OUTPUT

     {
           "object": "......."

     }

Pull onboarding detail

ENDPOINT

POST /api/onboardings/pullonboardings

HEADERS

Property           Value

Content-type application/json
Authorization …channel’s access token…

INPUT (FOR FETCH BY ONBOARDING STATUS)                                 Example values

   Property Data type

channelId          String                                              Channel Id

limitLength Integer                 Limit to number of onboardings that are returned (helpful in pagination)

skipLength Integer                  Skip these many onboardings before generating the list of onboardings

status             String Status of onboarding wanted to be pulled (all/pending/accepted/rejected)

{
   "channelId": "...channelId...",
   "limitLength": 10,
   "skipLength": 0,
   "status" : "accepted"

}

INPUT (FOR FETCH BY ONBOARDING ID)

Property           Data type                                           Example values
                                                                               Channel Id
channelId          String
```

## Source page 91

```text
      Property                                                                                              Example values

onboardingId       String                                              Onboarding Id

extraFields Array(optional) ExtraFields required to be appended in response (Possible values : 'CAMS’)

        {
           "channelId": "...channelId...",
           "onboardingId": "...onboardingId...",
           "extraFields" : ["..cams.."]

       }

 EXPECTED OUTPUT

        {
              "customerId": "....",
              "status": "....",
              "limitLength": "....",
              "skipLength": "....",
              "id": 4,
              "instanceId": "....",
              "result": [{
                     "email": "....",
                     "phone": "....",
                     "name": "....",
                     "username": "....",
                     "customerId": "....",
                     "merchantId": "....",
                     "status": "....",
                     "reason": "....",
                     "verificationData": {
                           "idCards": [{
                                  "type": "....",
                                  "purpose": [
                                         "POI"
                                  ],
                                  "name": "....",
                                  "idNo": "....",
                                  "dob": "....",
                                  "address": "....",
                                  "state": "....",
                                  "issueDate": "....",
                                  "images": [
                                         "...."
                                  ],
                                  "verificationStatus": {
                                         "verification": true,
                                         "message": "....",
                                         "isSet": 1
                                  },
                                  "faceExtraction": {
                                         "isSet": 1
                                  }
                           }, {
                                  "purpose": [
                                         "POA"
                                  ],
                                  "name": "....",
                                  "idNo": "....",
                                  "dob": "....",
                                  "address": "....",
                                  "state": "....",
                                  "issueDate": "....",
                                  "images": [
                                         "....",
                                         "...."
                                  ],
                                  "pincode": "....",
                                  "type": "....",
```

## Source page 92

```text
                                  "verificationStatus": {
                                         "isSet": 1

                                  },
                                  "faceExtraction": {

                                         "cropped": "....",
                                         "isSet": 1
                                  }
                           }],
                           "documents": [{
                                  "type": "....",
                                  "beneficiaryMobile": "....",
                                  "beneficiaryAccount": "....",
                                  "beneficiaryName": "....",
                                  "beneficiaryIFSC": "....",
                                  "images": [
                                         "...."
                                  ]
                           }, {
                                  "type": "....",
                                  "beneficiaryMobile": "....",
                                  "beneficiaryAccount": "....",
                                  "beneficiaryName": "....",
                                  "beneficiaryIFSC": "....",
                                  "images": [],
                                  "bankTransferOutput": {
                                         "active": "....",
                                         "nameMatch": "....",
                                         "mobileMatch": "....",
                                         "signzyReferenceId": "....",
                                         "auditTrail": {

                                               "nature": "....",
                                               "value": "....",
                                               "timestamp": "....Z"
                                         },
                                         "bankTransfer": {
                                               "response": "....",
                                               "bankRRN": "....",
                                               "beneName": "....",
                                               "beneMMID": "....",
                                               "beneMobile": "....",
                                               "beneIFSC": "....9"
                                         }
                                  },
                                  "verifyAmountOutput": {
                                         "amountMatch": "....",
                                         "owerName": "....",
                                         "mobile": "....",
                                         "mmid": "....1"
                                  }
                           }],
                           "video": {
                                  "url": "....",
                                  "matchImage": "....",
                                  "signzyVerifiableString": "....",
                                  "seconds": [
                                         "00:00:02",
                                         "00:00:03",
                                         "00:00:04"
                                  ],
                                  "videoMatch": {
                                         "matchAudioScore": "....",
                                         "isSet": 1
                                  },
                                  "matchImageEla": {
                                         "task": "....",
                                         "essentials": {
                                               "url": "...."
                                         },
                                         "id": "....",
                                         "patronId": "....",
                                         "result": "....",
                                         "isSet": 1
```

## Source page 93

```text
      },
      "forensics": {

             "staticRisk": {
                   "staticPhoto": false,
                   "ageGroup": "....",
                   "isSet": 1

             },
             "videoLandMarks": {

                   "result": "....",
                   "isSet": 1
             },
             "videoFaceMatch": {
                   "videoImages": [

                          "https://preproduction-persist.signzy.tech/api/files/64344/download/r2jhdPYWwVt3qgrEW6bbQA8EFML2QSyP7UNxzhlsnJbM2VC5kj.jpg",
                          "https://preproduction-persist.signzy.tech/api/files/64345/download/BkENcX31h0HeVPqtPHUV7prEGOmSYjlznOI5sAlKrBy2ZGJgqn.jpg",
                          "https://preproduction-persist.signzy.tech/api/files/64347/download/12KWSe9eJhh1Q517RaB4oz2SRXv3heFoaai9BM0ZzFPbAkOx4M.jpg"
                   ],
                   "finalMatchImage": "....",
                   "matchStatistics": {
                          "coVariance": "....",
                          "matchPercentage": "....%"
                   },
                   "isSet": 1
             },
             "exif": {
                   "metadataFound": "....",
                   "message": "....",
                   "image": {},
                   "gps": {},
                   "isSet": 1
             }
      },
      "faceLandmarks": {
             "result": "....",
             "isSet": 1
      }
},
"contract": {
      "signedContract": "....f"
},
"photo": {},
"fatca": {
      "pep": "....",
      "rpep": "....",
      "residentForTaxInIndia": "....",
      "relatedPerson": "....O"
},
"signature": {
      "signatureImageUrl": "...."
},
"formData": {
      "gender": "....",
      "maritalStatus": "....",
      "nomineeRelationShip": "....",
      "maidenTitle": "....",
      "motherTitle": "....",
      "occupationType": "....",
      "maidenName": "....",
      "motherName": "....",
      "applicationStatus": "....",
      "countryCode": 91,
      "emailId": "....",
      "pincode": 560078,
      "kycAccountType": "....",
      "mobileNumber": "....",
      "communicationAddress": "....",
      "nomineeTitle": "....",
      "nomineeName": "....A",
      "annualIncome": "... refer Table 1.8",
      "placeOfBirth": "...."
},
"info": {
```

## Source page 94

```text
                                  "name": "....",
                                  "dob": "....",
                                  "emailId": "....",
                                  "phone": "....",
                                  "communicationAddress": "....",
                                  "permanentAddress": "...."
                           }
                     },
                     "formFilledData": {
                           "identityProof": {
                                  "type": "....",
                                  "purpose": [

                                         "POI"
                                  ],
                                  "name": "....",
                                  "idNo": "....",
                                  "dob": "....",
                                  "expiryDate": "....",
                                  "verify": "....",
                                  "address": "....",
                                  "state": "....",
                                  "issueDate": "....",
                                  "images": [

                                         "...."
                                  ],
                                  "proofType": "....f"
                           },
                           "addressProof": [{
                                  "purpose": [

                                         "POA"
                                  ],
                                  "name": "....",
                                  "idNo": "....",
                                  "dob": "....",
                                  "verify": "....",
                                  "address": "....",
                                  "expiryDate": "....",
                                  "state": "....",
                                  "issueDate": "....",
                                  "addressType": "....",
                                  "proofType": "....",
                                  "images": [

                                         "....",
                                         "...."
                                  ],
                                  "pincode": "....",
                                  "type": "....t"
                           }],
                           "bankAccount": {
                                  "type": "....",
                                  "images": [
                                         "...."
                                  ]
                           },
                           "formFields": {
                                  "gender": "....",
                                  "maritalStatus": "....",
                                  "nomineeRelationShip": "....",
                                  "maidenTitle": "....",
                                  "motherTitle": "....",
                                  "occupationType": "....",
                                  "maidenName": "....",
                                  "motherName": "....",
                                  "applicationStatus": "....",
                                  "countryCode": 91,
                                  "emailId": "....",
                                  "pincode": 560078,
                                  "kycAccountType": "....",
                                  "mobileNumber": "....",
                                  "communicationAddress": "....",
                                  "nomineeTitle": "....",
                                  "nomineeName": "....A",
```

## Source page 95

```text
                                  "annualIncome": ".. refer Table 1.8",
                                  "placeOfBirth": "...."
                           },
                           "fatca": {
                                  "pep": "....",
                                  "rpep": "....",
                                  "residentForTaxInIndia": "....",
                                  "relatedPerson": "....O"
                           },
                           "signature": {
                                  "signatureImageUrl": "...."
                           },
                           "photo": {},
                           "video": {
                                  "url": "....",
                                  "matchImage": "....",
                                  "signzyVerifiableString": "....",
                                  "seconds": [

                                         "00:00:02",
                                         "00:00:03",
                                         "00:00:04"
                                  ]
                           },
                           "contract": {
                                  "signedContract": "....f"
                           }
                     },
                     "verificationResult": {
                           "idCards": [{
                                  "status": "....",
                                  "type": "....",
                                  "purpose": "....",
                                  "number": "....",
                                  "businessFlag": 0
                           }, {
                                  "status": "....",
                                  "type": "....",
                                  "purpose": "....",
                                  "number": "....",
                                  "businessFlag": 0
                           }],
                           "bankAccount": "....",
                           "video": "....",
                           "amlStatus": "....",
                           "overalStatus": "....y"
                     }
              }, {
                     "email": "....",
                     "phone": "....",
                     "name": "....",
                     "username": "....",
                     "customerId": "....",
                     "merchantId": "....",
                     "status": "....",
                     "reason": "....",
                     "verificationData": {
                           "idCards": [],
                           "documents": [],
                           "video": {},
                           "contract": {},
                           "photo": {},
                           "fatca": {},
                           "signature": {},
                           "formData": {}
                     },
                     "formFilledData": {
                           "identityProof": {},
                           "addressProof": [],
                           "bankAccount": {
                                  "type": "....n"
                           },
                           "formFields": {},
```

## Source page 96

```text
                           "fatca": {},
                           "signature": {},
                           "photo": {},
                           "video": {

                                  "url": "....",
                                  "matchImage": "....",
                                  "signzyVerifiableString": "....",
                                  "seconds": "...."
                           },
                           "contract": {}
                     },
                     "verificationResult": {}
              }, {
                     "email": "....",
                     "phone": "....",
                     "name": "....",
                     "username": "....",
                     "customerId": "....",
                     "merchantId": "....",
                     "status": "....",
                     "reason": "....",
                     "verificationData": {
                           "idCards": [{
                                  "type": "....",
                                  "purpose": [

                                         "POI"
                                  ],
                                  "name": "....",
                                  "idNo": "....",
                                  "dob": "....",
                                  "address": "....",
                                  "state": "....",
                                  "issueDate": "....",
                                  "images": [

                                         "...."
                                  ],
                                  "verificationStatus": {

                                         "verified": true,
                                         "message": "....",
                                         "upstreamName": "....",
                                         "isSet": 1
                                  },
                                  "faceExtraction": {
                                         "cropped": "....",
                                         "isSet": 1
                                  }
                           }, {
                                  "purpose": [
                                         "POA"
                                  ],
                                  "name": "....",
                                  "idNo": "....",
                                  "dob": "....",
                                  "address": "....",
                                  "state": "....",
                                  "issueDate": "....",
                                  "images": [
                                         "...."
                                  ],
                                  "pincode": "....",
                                  "type": "....",
                                  "verificationStatus": {
                                         "message": "....",
                                         "verified": true,
                                         "moreInfo": {

                                               "issueDate": "....",
                                               "expiryDate": "....",
                                               "vehicleClass": [

                                                      "LMV"
                                               ]
                                         },
                                         "instance": {},
```

## Source page 97

```text
             "isSet": 1
      },
      "faceExtraction": {

             "cropped": "....",
             "isSet": 1
      }
}],
"documents": [],
"video": {
      "url": "....",
      "matchImage": "....",
      "signzyVerifiableString": "....",
      "seconds": [
             "00:00:02",
             "00:00:04",
             "00:00:06",
             "00:00:08"
      ],
      "videoMatch": {
             "matchAudioScore": "....",
             "isSet": 1
      },
      "matchImageEla": {
             "task": "....",
             "essentials": {

                   "url": "...."
             },
             "id": "....",
             "patronId": "....",
             "result": "....",
             "isSet": 1
      },
      "forensics": {
             "staticRisk": {

                   "staticPhoto": false,
                   "ageGroup": "....",
                   "isSet": 1
             },
             "videoLandMarks": {
                   "result": "....",
                   "isSet": 1
             },
             "videoFaceMatch": {
                   "videoImages": [

                          "https://preproduction-persist.signzy.tech/api/files/89577/download/qtH4V9fyZz2m2P4SxOyaNoVAo9FXKn7d3YE0nW5Pw3cS50T7yj.jpg",
                          "https://preproduction-persist.signzy.tech/api/files/89578/download/yQb2EgzJzr1JUpN27hBAtngQsic1v2NlLCCGJVLGWcLVHfyEXe.jpg",
                          "https://preproduction-persist.signzy.tech/api/files/89579/download/nnLz1AL5iJlezeSxVe3jINYZTwMScWZnmVDX6ozWNQDn0FsTIk.jpg",
                          "https://preproduction-persist.signzy.tech/api/files/89580/download/fDvl5Cbn6V3RIDNV2BGhQAYn3CwV15O1Nn7caBXL0BxTSnhSzo.jpg"
                   ],
                   "finalMatchImage": "....",
                   "matchStatistics": {
                          "coVariance": "....",
                          "matchPercentage": "....%"
                   },
                   "isSet": 1
             },
             "exif": {
                   "metadataFound": "....",
                   "message": "....",
                   "image": {},
                   "gps": {},
                   "isSet": 1
             }
      },
      "faceLandmarks": {
             "result": "....",
             "isSet": 1
      }
},
"contract": {},
"photo": {},
"fatca": {
```

## Source page 98

```text
                                  "pep": "....",
                                  "rpep": "....",
                                  "residentForTaxInIndia": "....",
                                  "relatedPerson": "....O"
                           },
                           "signature": {
                                  "signatureImageUrl": "...."
                           },
                           "formData": {
                                  "gender": "....",
                                  "maritalStatus": "....",
                                  "nomineeRelationShip": "....",
                                  "maidenTitle": "....",
                                  "panNumber": "....",
                                  "aadhaarNumber": "....",
                                  "motherTitle": "....",
                                  "occupationDescription": "....",
                                  "occupationCode": "....",
                                  "kycAccountCode": "....",
                                  "kycAccountDescription": "....",
                                  "communicationAddressCode": "....",
                                  "communicationAddressType": "....",
                                  "applicationStatusCode": "....",
                                  "applicationStatusDescription": "....",
                                  "countryCode": "....",
                                  "mobileNumber": "....",
                                  "emailId": "....",
                                  "communicationAddress": "....",
                                  "pincode": "....",
                                  "motherName": "....",
                                  "nomineeTitle": "....",
                                  "nomineeName": "....a"
                           },
                           "info": {
                                  "name": "....",
                                  "dob": "....",
                                  "emailId": "....",
                                  "phone": "....",
                                  "communicationAddress": "....",
                                  "permanentAddress": "...."
                           }
                     },
                     "formFilledData": {
                           "identityProof": {
                                  "type": "....",
                                  "purpose": [

                                         "POI"
                                  ],
                                  "name": "....",
                                  "idNo": "....",
                                  "dob": "....",
                                  "expiryDate": "....",
                                  "verify": "....",
                                  "address": "....",
                                  "state": "....",
                                  "issueDate": "....",
                                  "images": [

                                         "...."
                                  ],
                                  "proofType": "....f"
                           },
                           "addressProof": [{
                                  "purpose": [

                                         "POA"
                                  ],
                                  "name": "....",
                                  "idNo": "....",
                                  "dob": "....",
                                  "verify": "....",
                                  "address": "....",
                                  "expiryDate": "....",
                                  "state": "....",
```

## Source page 99

```text
                                  "issueDate": "....",
                                  "addressType": "....",
                                  "proofType": "....",
                                  "images": [

                                         "...."
                                  ],
                                  "pincode": "....",
                                  "type": "....l"
                           }],
                           "bankAccount": {
                                  "type": "....n"
                           },
                           "formFields": {
                                  "gender": "....",
                                  "maritalStatus": "....",
                                  "nomineeRelationShip": "....",
                                  "maidenTitle": "....",
                                  "panNumber": "....",
                                  "aadhaarNumber": "....",
                                  "motherTitle": "....",
                                  "occupationDescription": "....",
                                  "occupationCode": "....",
                                  "kycAccountCode": "....",
                                  "kycAccountDescription": "....",
                                  "communicationAddressCode": "....",
                                  "communicationAddressType": "....",
                                  "applicationStatusCode": "....",
                                  "applicationStatusDescription": "....",
                                  "countryCode": "....",
                                  "mobileNumber": "....",
                                  "emailId": "....",
                                  "communicationAddress": "....",
                                  "pincode": "....",
                                  "motherName": "....",
                                  "nomineeTitle": "....",
                                  "nomineeName": "....a"
                           },
                           "fatca": {
                                  "pep": "....",
                                  "rpep": "....",
                                  "residentForTaxInIndia": "....",
                                  "relatedPerson": "....O"
                           },
                           "signature": {
                                  "signatureImageUrl": "...."
                           },
                           "photo": {},
                           "video": {
                                  "url": "....",
                                  "matchImage": "....",
                                  "signzyVerifiableString": "....",
                                  "seconds": [

                                         "00:00:02",
                                         "00:00:04",
                                         "00:00:06",
                                         "00:00:08"
                                  ]
                           },
                           "contract": {}
                     },
                     "verificationResult": {
                           "idCards": [{
                                  "status": "....",
                                  "type": "....",
                                  "purpose": "....",
                                  "number": "....",
                                  "businessFlag": 0
                           }, {
                                  "status": "....",
                                  "type": "....",
                                  "purpose": "....",
                                  "number": "....",
```

## Source page 100

```text
                                  "businessFlag": 0
                           }],
                           "bankAccount": "....",
                           "video": "....",
                           "amlStatus": "....",
                           "overalStatus": "....y"
                     }
              }]
       }

Pull CAMS responses for an Onboarding

ENDPOINT

POST /api/onboardings/pullCamsResponse

HEADERS          Value

  Property

Content-type application/json

Authorization …channel’s access token…

INPUT

Property Data type                                                        Example values

onboardingId String Onboarding Id whose CAMS responses needs to be pulled

{
      "onboardingId": "5ca78ca795c92f759d54c621"

}

EXPECTED OUTPUT           Data type                                                                                                                     Example values

      Property               String                                                                                                                         Onboarding Id
  onboardingId
                 Array of CAMS response                                   pushResponse is the exact response from CAMS , timeStamp is time of CAMS
  camsResponse              Objects                                                                                                                                     push

{
    "onboardingId": " ... ",
    "id": " .. ",
    "camsResponse": [
           {
                  "_id": " .. ",
                  "onboardingId": " ... ",
                  "pushResponse": " ... ",
                  "timeStamp": "Fri Apr 05 2019 22:31:50 GMT+0530 (IST)"
           }
    ]

}
```

## Source page 101

```text
Pull Karvy data for manual trigger purpose

ENDPOINT

POST /api/onboardings/pullKarvyData

HEADERS

Property           Value

Content-type application/json

Authorization …channel’s access token…

INPUT

Property Data type                                                     Example values

onboardingId String Onboarding Id whose Karvy data needs to be pulled

     {
           "onboardingId": "...."

     }

EXPECTED OUTPUT

  Property Data type
  karvyXml String

{
      "karvyXml": "<Contains the XMl srting>"

}

Pull Karvy responses for an Onboarding

ENDPOINT

POST /api/onboardings/pullkarvyresponse

HEADERS

Property           Value

Content-type application/json

Authorization …channel’s access token…

INPUT

Property Data type                             Example values

onboardingId String Onboarding Id for which Karvy is to be called

        {
              "onboardingId": "...."
```

## Source page 102

```text
       }                                                                                                                       Example values
                                                                                                                                      merchant Id
EXPECTED OUTPUT               Data type
                                             pushResponse is the exact response from Karvy , result is the status from karvy
      Property                                                                               response , timeStamp is time of karvy push

merchantId                    String

karvyResponse       Array of Karvy response
                               Objects

{
    "merchantId": " ... ",
    "status": " .. ",
    "karvyResponse": [
           {
                  "pushResponse": " ... ",
                  "result": " ... ",
                  "timeStamp": " ... "
           }
    ]

}

Pull CVL data

ENDPOINT

POST /api/onboardings/pullCvlData

HEADERS

Property           Value

Content-type application/json

Authorization …channel’s access token…

INPUT

Property Data type                                                     Example values

onboardingId String Onboarding Id whose CVL data needs to be pulled

{
      "onboardingId": "...."

}

EXPECTED OUTPUT

  Property Data type

cvlXml      String

{
      "cvlXml": "<Contains the XMl srting>"

}
```

## Source page 103

```text
Pull CVL responses for an Onboarding

ENDPOINT

POST /api/onboardings/pullCvlResponse

HEADERS

Property           Value

Content-type application/json

Authorization …channel’s access token…

INPUT

Property Data type                          Example values

onboardingId String Onboarding Id for which cvl is to be called

{
      "onboardingId": "...."

}

EXPECTED OUTPUT               Data type                                                                                                 Example values

    Property                                                                                                                                   merchant Id

merchantId                    String        pushResponse is the exact response from CVL , result is the status from cvl response ,
                                                                                                                         timeStamp is time of cvl push
cvlResponse        Array of CVL response
                             Objects

{
    "merchantId": " ... ",
    "status": " .. ",
    "cvlResponse": [
           {
                  "pushResponse": " ... ",
                  "result": " ... ",
                  "timeStamp": " ... "
           }
    ]

}

                    Distributor Dashboard

Basic details

 API ENDPOINT DETAILS

 Protocol: HTTPS
 Preproduction hostname: investor-onboarding-preproduction.signzy.tech
 Production hostname: investor-onboarding.signzy.tech
```

## Source page 104

```text
Distributor Login

 Login API for Distributor Dashboard

 INPUT

 Post request to :: /api/distributorAdmins/login

        {
              "username": "enter your valid username",
              "password": "enter your valid password"

       }

 EXPECTED LOGIN RESPONSE

        {
              "id": "..id..",
              "ttl": "..ttl..",
              "created": "..created..",
              "userId": "..userId.."

       }

Property Accepted values/format Description

id          String             This is your access token to be passed into other endpoints as Authorization header

ttl         Integer            Time to live (ttl for the access token that is generated)

created String                 Time and Date of creation of access-token

userId      String             ID of the distributor

Add AMC

Adding Channel to the Distributor Dashboard. This will be one time activity and the channel will be added to the Dashboard.

HEADERS     Value

  Property

Content-type application/json

Authorization … access token…

INPUT

Post request to :: /api/distributorAdmins/addChannel

Property Data type             Description

task        String             task type

id          String             Distributor ID

credentials Object             Object

username    String Channel Username
```

## Source page 105

```text
    Property Data type                         Description

password  String                         Channel Password

{
      "task" : "addAmc",
      "id" : "..distributorId..",
      "credentials" : {
             "username":"..username..",
             "password":"..password.."
      }

}

EXPECTED OUTPUT                          Description

  Property Data type

message   String                         Message

addStatus Boolean Boolean value

{
      "result": {
             "message": "Added Successfully",
             "addStatus": true
      }

}

                                                      Reference Tables

Table 1.1 (Country and Code)

                          Country                           Code
India                                                       101
Albania                                                     003
Aland Islands                                               002
Afghanistan                                                 001
Algeria                                                     004
American Samoa                                              005
Andorra                                                     006
Angola                                                      007
Anguilla                                                    008
Antarctica                                                  009
Antigua And Barbuda                                         010
```

## Source page 106

```text
                   Country      Code
                                011
Argentina                       012
                                013
Armenia                         014
                                015
Aruba                           016
                                017
Australia                       018
                                019
Austria                         020
                                021
Azerbaijan                      022
                                023
Bahamas                         024
                                025
Bahrain                         026
                                027
Bangladesh                      028
                                029
Barbados                        030
                                031
Belarus                         032
                                033
Belgium                         034
                                035
Belize                          036
                                037
Benin                           038
                                039
Bermuda                         040
                                041
Bhutan

Bolivia

Bosnia And Herzegovina

Botswana

Bouvet Island

Brazil

British Indian Ocean Territory

Brunei Darussalam

Bulgaria

Burkina Faso

Burundi

Cambodia

Cameroon

Canada

Cape Verde

Cayman Islands
```

## Source page 107

```text
                   Country             Code
                                       042
Central African Republic               043
                                       044
Chad                                   045
                                       046
Chile                                  047
                                       048
China                                  049
                                       050
Christmas Island                       051
                                       052
Cocos (Keeling) Islands                053
                                       054
Colombia                               055
                                       056
Comoros                                057
                                       058
Congo                                  059
                                       060
Congo, The Democratic Republic Of The  061
                                       062
Cook Islands                           063
                                       064
Costa Rica                             065
                                       066
Cote D'Ivoire                          067
                                       068
Croatia                                069
                                       070
Cuba                                   071
                                       072
Cyprus

Czech Republic

Denmark

Djibouti

Dominica

Dominican Republic

Ecuador

Egypt

El Salvador

Equatorial Guinea

Eritrea

Estonia

Ethiopia

Falkland Islands (Malvinas)

Faroe Islands

Fiji
```

## Source page 108

```text
                   Country         Code
                                   073
Finland                            074
                                   075
France                             076
                                   077
French Guiana                      078
                                   079
French Polynesia                   080
                                   081
French Southern Territories        082
                                   083
Gabon                              084
                                   085
Gambia                             086
                                   087
Georgia                            088
                                   089
Germany                            090
                                   091
Ghana                              092
                                   093
Gibraltar                          094
                                   095
Greece                             096
                                   097
Greenland                          098
                                   099
Grenada                            100
                                   102
Guadeloupe                         103
                                   104
Guam

Guatemala

Guernsey

Guinea

Guinea-Bissau

Guyana

Haiti

Heard Island And Mcdonald Islands

Holy See (Vatican City State)

Honduras

Hong Kong

Hungary

Iceland

Indonesia

Iran, Islamic Republic Of

Iraq
```

## Source page 109

```text
                    Country                 Code
                                            105
Ireland                                     106
                                            107
Isle Of Man                                 108
                                            109
Israel                                      110
                                            111
Italy                                       112
                                            113
Jamaica                                     114
                                            115
Japan                                       116
                                            117
Jersey                                      118
                                            119
Jordan                                      120
                                            121
Kazakhstan                                  122
                                            123
Kenya                                       124
                                            125
Kiribati                                    126
                                            127
Korea, Democratic People’s Republic Of      128
                                            129
Korea, Republic Of                          130
                                            131
Kuwait                                      132
                                            133
Kyrgyzstan                                  134
                                            135
Lao People’s Democratic Republic

Latvia

Lebanon

Lesotho

Liberia

Libyan Arab Jamahiriya

Liechtenstein

Lithuania

Luxembourg

Macao

Macedonia, The Former Yugoslav Republic Of

Madagascar

Malawi

Malaysia

Maldives

Mali
```

## Source page 110

```text
                   Country       Code
                                 136
Malta                            137
                                 138
Marshall Islands                 139
                                 140
Martinique                       141
                                 142
Mauritania                       143
                                 144
Mauritius                        145
                                 146
Mayotte                          147
                                 148
Mexico                           149
                                 150
Micronesia, Federated States Of  151
                                 152
Moldova, Republic Of             153
                                 154
Monaco                           155
                                 156
Mongolia                         157
                                 158
Montserrat                       159
                                 160
Morocco                          161
                                 162
Mozambique                       163
                                 164
Myanmar                          165
                                 166
Namibia

Nauru

Nepal

Netherlands

Netherlands Antilles

New Caledonia

New Zealand

Nicaragua

Niger

Nigeria

Niue

Norfolk Island

Northern Mariana Islands

Norway

Oman

Pakistan
```

## Source page 111

```text
                    Country       Code
                                  167
Palau                             168
                                  169
Palestinian Territory, Occupied   170
                                  171
Panama                            172
                                  173
Papua New Guinea                  174
                                  175
Paraguay                          176
                                  177
Peru                              178
                                  179
Philippines                       180
                                  181
Pitcairn                          182
                                  183
Poland                            184
                                  185
Portugal                          186
                                  187
Puerto Rico                       188
                                  189
Qatar                             190
                                  191
Reunion                           192
                                  193
Romania                           194
                                  195
Russian Federation                196
                                  197
Rwanda

Saint Helena

Saint Kitts And Nevis

Saint Lucia

Saint Pierre And Miquelon

Saint Vincent And The Grenadines

Samoa

San Marino

Sao Tome And Principe

Saudi Arabia

Senegal

Serbia And Montenegro

Seychelles

Sierra Leone

Singapore

Slovakia
```

## Source page 112

```text
                   Country    Code

Slovenia                      198

Solomon Islands               199

Somalia                       200

South Africa                  201

South Georgia And The South Sandwich Islands 202

Spain                         203

Sri Lanka                     204

Sudan                         205

Suriname                      206

Svalbard And Jan Mayen        207

Swaziland                     208

Sweden                        209

Switzerland                   210

Syrian Arab Republic          211

Taiwan, Province Of China     212

Tajikistan                    213

Tanzania, United Republic Of  214

Thailand                      215

Timor-Leste                   216

Togo                          217

Tokelau                       218

Tonga                         219

Trinidad And Tobago           220

Tunisia                       221

Turkey                        222

Turkmenistan                  223

Turks And Caicos Islands      224

Tuvalu                        225

Uganda                        226

Ukraine                       227

United Arab Emirates          228
```

## Source page 113

```text
                      Country         Code
                                      229
United Kingdom                        230
                                      231
United States                         232
                                      233
United States Minor Outlying Islands  234
                                      235
Uruguay                               236
                                      237
Uzbekistan                            238
                                      239
Vanuatu                               240
                                      241
Venezuela                             242
                                      243
Viet Nam                              CI
                                      KP
Virgin Islands, British               120

Virgin Islands, U.S.

Wallis And Futuna

Western Sahara

Yemen

Zambia

Zimbabwe

Côte D'ivoire

Korea,Democratic People'sRepublicOf

Lao People’s Democratic Republic

Table 1.2 (Cams State and code)

          State          Code

Andaman & Nicobar        AN

Andhra Pradesh           AP

Arunachal Pradesh        AR

Assam                    AS

Bihar                    BR

Chandigarh               CH

Chattisgarh              CG

Dadra and Nagar Haveli DN

Daman & Diu              DD
```

## Source page 114

```text
                State  Code
   Delhi               DL
   Goa                 GA
   Gujarat             GJ
   Haryana             HR
   Himachal Pradesh    HP
   Jammu & Kashmir     JK
   Jharkhand           JH
   Karnataka           KA
   Kerala              KL
   Lakshadweep         LD
   Madhya Pradesh      MP
   Maharashtra         MH
   Manipur             MN
   Meghalaya           ML
   Mizoram             MZ
   Nagaland            NL
   Odisha              OR
   Pondicherry         PY
   Punjab              PB
   Rajasthan           RJ
   Sikkim              SK
   Tamil Nadu          TN
   Telangana           TS
   Tripura             TR
   Uttar Pradesh       UP
   Uttarakhand         UA
   West Bengal         WB
   Other               XX

Table 1.3 (Occupation and codes)
```

## Source page 115

```text
   Code Occupation Description

01  Private Sector

02  Public Sector

03  Business

04  Professional

06  Retired

07  Housewife

08  Student

10  Government Sector

99  Others

11  Self Employed

12  Not Categorized

Table 1.4 (KYC account description and codes)

KYC Acc. Code KYC Acc. Description

01             New

02             Modify with documents

03             Modify without documents

04             Dump

05             Suspended

06             Deceased

Table 1.5 (Application status code and description)

Application status Code Application status Description

R                      Resident Indian

N                      Non-Resident Indian

P                      Foreign National

I                      Person of Indian Origin
```

## Source page 116

```text
Table 1.6 (Address Types and code)

Code Communication Address Type

01       Residential/Business

02       Residential

03       Business

04       Registered office

05       Unspecified

Table 1.7 (State and code to be used for update form for “voterID”)

            Code                           State

Andaman and Nicobar Islands Andaman and Nicobar Islands

Andhra Pradesh                 Andhra Pradesh

ArunachalPradesh               Arunachal Pradesh

Assam                          Assam

Bihar                          Bihar

Chandigarh                     Chandigarh

Chhattisgarh                   Chhattisgarh

DadraandNagar                  Dadra and Nagar

Diu-Daman                      Daman and Diu

Delhi                          Delhi

Goa                            Goa

Gujarat                        Gujarat

Haryana                        Haryana

HimachalPradesh                Himachal Pradesh

JammuKashmir                   Jammu & Kashmir

Jharkhand                      Jharkhand

Karnataka                      Karnataka

Kerala                         Kerala

Lakshadweep                    Lakshadweep

Madhya Pradesh                 Madhya Pradesh
```

## Source page 117

```text
                    Code                      State
   Maharashtra                Maharashtra
   Manipur                    Manipur
   Meghalaya                  Meghalaya
   Mizoram                    Mizoram
   Nagaland                   Nagaland
   Odisha                     Odisha
   Puducherry                 Puducherry
   Punjab                     Punjab
   Rajasthan                  Rajasthan
   Sikkim                     Sikkim
   TamilNadu                  Tamil Nadu
   Telangana                  Telangana
   Tripura                    Tripura
   Uttar Pradesh              Uttar Pradesh
   Uttarakhand                Uttarakhand
   West Bengal                West Bengal

Table 1.8 (Income Range and Code)

Income Range Code

Below 1 Lac               31

1-5 Lacs                  32

5-10 Lacs                 33

10-25 Lacs                34

25 Lacs-1 crore 35

1 crore                   36

Table 1.9 (PAN EXEMPT Categories for CVL KRA)

                                      Category                         Code
   Sikkim Resident                                                     01
```

## Source page 118

```text
                           Category                                    Code

Transactions carried out on behalf of State Government                 02

Transactions carried out on behalf of Central Government               03

Court Appointed Officials                                              04

UN Entity/Multilateral agency exempt from paying tax in India 05

Official Liquidator                                                    06

Court Receiver                                                         07

SIP of Mutual Funds upto Rs. 50,000/- p.a.                             08

Other Documents                                                        11

            Concepts and meanings of terms

Preproduction environment

The preproduction environment acts like a sandbox environment for the client and the subcontractors (channel distributors) in order to
try and play with the Signzy APIs.

Production environment

Once the client & any sub-contractors have integrated into Signzy API system in the preproduction environment, they will be moved into
production environment. At production there is no limit on the number of API calls that can be made and the requests are billed post-
facto.

Channel

A channel can be though of as an extension of the user model. A channel can be created by another channel and the child channels
are controlled by the parent in terms of grants and allocations.

Onboarding

An onboarding object is the main object which holds the data about an particular onboarding. A channel can create onboarding and
push data to a parent system (like investor onboarding) according to grant provided by the parent channel. Exact details on how to
create onboarding object and pushing data into the parent system can be found above.

Distributor
```

## Source page 119

```text
A distributor is also an instance of the channel object created by another channel. A distributor can have different rights and grants as
detailed during creation or updated by the parent channel creating the channel onbect.

                    Support & Disclaimer

This documentation is currently a work in progress and certain details properties, objects and in rare cases endpoints might change as
the product evolves. This documentation can be taken as reference of information about the APIs and integration must be started but
care must be taken to accomodate minimal changes in the API and the data properties from payload.

Update on docs

These docs are currently a work in progress and updates can be expected in properties. After the API endpoints stabilize, the docs can
still be updated with new features added into the product with extreme care being taken to not hamper existing integrations.

The docs will be updated further from time to time in order to provide more clarity to the integration & development teams on usage of
the products.

Product downtimes

Clients will be notified of any planned downtimes due to patch deployments, software updates and other maintenance activity one week
prior to execution.

Support, errors and corrections

If you find any problems with the documentation or the product, feel free to reach out to us at support@signzy.com for help.
For any support queries reach out to support@signzy.com. If you are subcontracted to use the product, please reach out to your
contractor to connect with Signzy Support.

Device Compatibility

DESKTOP

         Operating System      Browser POI POA CPOA Cheque Photo                                                 Video  Contract
                                                                                                         Verification

Windows, Linux Ubuntu, macOS   Chrome   Yes Yes                        Yes  Yes                     Yes  Yes                    Yes

Windows, Linux Ubuntu 16.04+,  Firefox  Yes Yes                        Yes  Yes                     Yes  Yes                    Yes
macOS
                               Opera    Yes Yes                        Yes  Yes                     Yes  Yes                    Yes
Windows
                               UC browser Yes Yes                      Yes  Yes                     Yes  Yes                    Yes
Windows 10
```

## Source page 120

```text
                                                                                               Verification
              Operating System                      POI POA CPOA Cheque Photo
   Windows 10
   Mac                                   IE         Yes Yes                 Yes  Yes  No            Yes       No
   Windows 10
                                         Safari     Yes Yes                 Yes  Yes  Yes           No        Yes

                                         Microsoft  Yes Yes                 Yes  Yes  Yes           Yes       Yes
                                           Edge

MOBILE              Browser              POI POA CPOA Cheque Photo Video Verification Contract

  Operating System

Android 6+, iOS                 Chrome   Yes Yes                       Yes  Yes  Yes           Yes  Yes

Android 7+          Samsung internet Yes Yes                           Yes  Yes  Yes           Yes  Yes

iOS                             Safari   Yes Yes                       Yes  Yes  NO            Yes  Yes

Android 7+          UC browser           Yes Yes                       Yes  Yes  Yes           Yes  Yes

Android 7+                      Opera    Yes Yes                       Yes  Yes  Yes           Yes  Yes

Android 7+                      FireFox  Yes Yes                       Yes  Yes  Yes           Yes  Yes

                      Advanced Features

Integration with Mobile Application

Use Chrome Custom Tab for opening Investor Onboarding in the mobile application. Integrate Mobile Auto-Login/Login URL with the
Chrome Custom Tab, since it is compatible with both android and IOS.
```
