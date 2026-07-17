# MFU UAT Test Data Reference

Complete Markdown conversion of [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx).

## Sheet index

- [AMC-Scheme Master](#amc-scheme-master)
- [CAN](#can)
- [Depository](#depository)
- [Email-Mobile](#email-mobile)
- [CAN Folio Holding](#can-folio-holding)
- [CAN Bank](#can-bank)
- [PayEezz](#payeezz)
- [ARN-RIA-Master](#arn-ria-master)
- [ARN-EUIN-Master](#arn-euin-master)
- [ Bank Master](#bank-master)
- [Virtual Acc No Logic](#virtual-acc-no-logic)
- [ePayEezz Supported Banks UAT](#epayeezz-supported-banks-uat)
- [Net Banking supported Bank](#net-banking-supported-bank)

## AMC-Scheme Master

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `AMC-Scheme Master`

### UAT Environment

### Scheme / Threshold Dropbox Link

### Table 1

Source cells: `A3:B4`

| Scheme: | https://www.dropbox.com/scl/fi/52ywzic4fnhhkvwskis0s/UAT-All-Scheme-20210811.xlsx?dl=0&rlkey=rws7klr0vh6o72bqo8q5tlku6 |
| --- | --- |
| Threshold: | https://www.dropbox.com/scl/fi/z9s02ifw76rqkq4zei4y1/UAT-All-Threshold-20210811.xlsx?dl=0&rlkey=v6zhi0bgn28aygqa9hufkhejh |

### Table 2

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

## CAN

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `CAN`

### Table 1

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

### Table 2

Source cells: `A27:AA32`

| CAN ID | Investory Category | CAN Category | Residential Status | PAN_PEKRN | First Applicant | Primary Holder DOB/DOI | Place of Incorporation | Commencement Date | Registration Number | Joint 1 PAN | Second Applicant | Joint 1 DOB | Joint 2 PAN | Joint 2 Applicant | Joint 2 DOB | Guardian PAN | Guardian Name | Guardian DOB | RegnDate | Address1 | Address2 | Address3 | City | PinCode | State Name | Holding Mode |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 14163AKA01 | Individual  | I | 01-RES.IND | EBOND1234E           | tom | 1991-10-05 |  |  |  | FBOND1234F | maggi | 1991-10-04 | GBOND1234G | soup | 1991-10-03 |                      |   |  | 2014-06-12 | mnajkh |  |  | thane | 123456 | Maharashtra | Joint |
| 14175AYA05 | Individual  | I | 01-RES.IND | AWHPM7811L           | Manish Dangra | 1979-07-01 |  |  |  | APZPV0087J | Karunakar | 1974-11-30 |  |  |  |                      |   |  | 2014-06-24 | 1-86 South Kalliadappu | Sasthankarai |  | Kanyakumari | 629251 | Tamil Nadu | Joint |
| 14188AMA06 | Individual  | I | 04-Foreign National | GEWPS3117R           | Dinesh Poojary | 1978-08-22 |  |  |  | DEWPS3117R | Deevakar K Shetty | 1975-10-03 |  |  |  |                      |   |  | 2014-07-05 | xy |  |  | Hongkong | 600015 | Not Applicable | Joint |
| 14189AMA02 | Individual  | I | 02-NRI-NRE | AGPPR3689R           | BIPIN KAKODKAR | 1954-07-19 |  |  |  | AGYPR3689R | SATISH RATHOD | 1972-07-29 |  |  |  |                      |   |  | 2014-07-05 | 333 | ABC | XYZ | WASHINGTON | 000000 | Not Applicable | Joint |
| 14206BAA01 | Individual  | I | 01-RES.IND | APZPV0087J           | Bhavana Verma | 1974-11-30 |  |  |  | AARPA0708N | Pushpa R | 1970-12-10 |  |  |  |                      |   |  | 2014-07-25 | Plot No 15 Lek Palace | Village, Chhota Bagandada | Tehsil Indor Disctric, | Indore | 452006 | Madhya Pradesh | Joint |

### PayEezz Registered CANs

### Table 3

Source cells: `A34:AA39`

| CAN ID | Investory Category | CAN Category | Residential Status | PAN_PEKRN | First Applicant | Primary Holder DOB/DOI | Place of Incorporation | Commencement Date | Registration Number | Joint 1 PAN | Second Applicant | Joint 1 DOB | Joint 2 PAN | Joint 2 Applicant | Joint 2 DOB | Guardian PAN | Guardian Name | Guardian DOB | RegnDate | Address1 | Address2 | Address3 | City | PinCode | State Name | Holding Mode |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 14157AZA01 | Individual  | I | 01-RES.IND | PAAKA1251Q           | Harry | 1980-10-10 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-06 | a | a | a | qq | 400606 | Punjab | Single  |
| 14163BEA01 | Individual  | I | 01-RES.IND | PPPPP5555P           | MANOJ | 1970-06-01 |  |  |  |  |  |  |  |  |  |                      |   |  | 2014-06-12 | MUMBAI |  |  | MUMBAI | 421202 | Maharashtra | Single  |
| 15309BAA01 | Individual  | I | 01-RES.IND | AAAAA7896S           | Sheetal | 1980-11-13 |  |  |  |  |  |  |  |  |  |                      |   |  | 2015-11-05 | 45 Roop Emerald Building |  | T Nagar | CHENNAI | 600017 | Tamil Nadu | Single  |
| 15343BAA01 | Individual  | I | 01-RES.IND | UERTY1234U           | mfu Marketing | 1983-08-21 |  |  |  |  |  |  |  |  |  |                      |   |  | 2015-12-09 | 24, Testing | Usman Road | T.Nagar | CHENNAI | 600017 | Tamil Nadu | Single  |
| 16018BAA03 | Individual  | I | 01-RES.IND | AAAAA0101A           | Sukumar | 1985-05-31 |  |  |  |  |  |  |  |  |  |                      |   |  | 2016-01-18 | 18 kumarappan mudali street |  |  | CHENNAI | 600017 | Tamil Nadu | Single  |

### Anyone or Survivor

### Table 4

Source cells: `A41:AB44`

| 14219SSA01 | Individual  | I | 01-RES.IND | AEOPP5984N           | SUNDAR | 1964-07-21 | Column H | Column I | Column J | APZPV0087J | Bhavana Verma | 1974-11-30 | AWHPM7811L | R Murugadhas | 1979-07-01 |                      |   | Column S | 2014-08-07 | 7 C, Shatri Namge | Adyar | CHennai | Chennai | 600020 | Tamil Nadu | Anyone or Survivor | AP |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 15014BAA03 | Individual  | I | 01-RES.IND | AGKPJ8175D           | VIJENDRA SURAJ JABRA | 1979-03-06 |  |  |  | ADUPL6168M | MADAN LAL | 1956-02-15 | ADHPP4619E | AKHILESH PANDYA | 1963-04-18 |                      |   |  | 2015-01-14 | C 8 Jeevan Vikas | V P Road | Santacruz W | Mumbai | 400054 | Maharashtra | Anyone or Survivor | AP |
| 15111AXA03 | Individual  | I | 01-RES.IND | DADDY1003A           | Daddy Three | 1985-10-10 |  |  |  | DADDY1002A | Daddy Two | 1985-10-10 | DADDY1001A | Daddy One | 1985-10-11 |                      |   |  | 2015-04-21 | One | Two | Three | MUMBAI | 400001 | Maharashtra | Anyone or Survivor | AP |
| 16035BAA01 | Individual  | I | 01-RES.IND | ACDPP0707A           | Swaminathan KR | 1964-09-16 |  |  |  | ARWPP3455H | apoorva | 1966-08-21 | AEOPP5984N | manish | 1964-07-21 |                      |   |  | 2016-02-04 | 17-YESHODIP SOCIETY 1ST WING | NEAR MONIS HOTEL | M G ROAD NAUPADA | THANE WEST | 400602 | Maharashtra | Anyone or Survivor | AP |

## Depository

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `Depository`

### Table 1

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

## Email-Mobile

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `Email-Mobile`

### Table 1

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

## CAN Folio Holding

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `CAN Folio Holding`

### Table 1

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

## CAN Bank

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `CAN Bank`

### Table 1

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

### Joint CAN Bank(s)

### Table 2

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

### CAN PayEezz Samples

### Table 3

Source cells: `A160:G160`

| CAN ID | Bank ID | Bank Name | MICR | IFSC | Account No | Account Type |
| --- | --- | --- | --- | --- | --- | --- |

## PayEezz

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `PayEezz`

### Table 1

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

## ARN-RIA-Master

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `ARN-RIA-Master`

### Table 1

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

## ARN-EUIN-Master

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `ARN-EUIN-Master`

### Table 1

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

##  Bank Master

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: ` Bank Master`

### Table 1

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

### Table 2

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

## Virtual Acc No Logic

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `Virtual Acc No Logic`

### Table 1

Source cells: `A1:F7`

| Enviornment | Payment Mode | RBI<br>Bank<br>ID | Collection Bank Name (Payment Aggregator) | Virtual<br>Code | Beneficiary A/c Number (Payment Virtual Account Number) |
| --- | --- | --- | --- | --- | --- |
| UAT | NEFT /RTGS | 485 | KOTAK MAHINDRA BANK LTD | MFKU | For CAN based transactions - MFKU<<CAN>><br>e-g. If your CAN is 12345QZA67 then Beneficiary A/C Number is MFKU12345QZA67<br> <br>For Folio based transactions - MFKU<<PAN>><br>If your PAN is BCAAA1122X then Beneficiary A/c Number is MFKUBCAAA1122X |
| UAT | NEFT /RTGS | 532 | YES BANK LTD | MFUYES | For CAN based transactions - MFUYES<<CAN>><br>e-g. If your CAN is 12345QZA67 then Beneficiary A/C Number is MFUYES12345QZA67<br><br>For Folio based transactions - MFUYES<<PAN>><br>If your PAN is BCAAA1122X then Beneficiary A/c Number is MFUYESBCAAA1122X |
| UAT | InstaUPI | 532 | YES BANK LTD |  | 	For CAN-based transaction – VPA ID is MFUYES‹‹CAN››@yesbankltd<br>e-g. If your CAN is 12345QZA67 then Beneficiary A/C Number is MFUYES12345QZA67@yesbankltd<br><br>For Folio-based transaction - VPA ID is MFUYES‹‹PAN››@yesbankltd<br>If your PAN is BCAAA1122X then Beneficiary A/c Number is MFUYESBCAAA1122X@yesbankltd |
| LIVE | NEFT /RTGS | 485 | KOTAK MAHINDRA BANK LTD |  | Visit: https://mfuindia.com/for-investors/neft-rtgs |
| LIVE | NEFT /RTGS | 532 | YES BANK LTD |  | Visit: https://mfuindia.com/for-investors/neft-rtgs |
| LIVE | InstaUPI | 532 | YES BANK LTD |  | Visit : https://mfuindia.com/insta-upi |

## ePayEezz Supported Banks UAT

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `ePayEezz Supported Banks UAT`

### Table 1

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

## Net Banking supported Bank

Source workbook: [UAT-Test-Data.xlsx](../UAT-Test-Data.xlsx)  
Source sheet: `Net Banking supported Bank`

### Table 1

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
