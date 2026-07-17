# Scheme Master Data Structure Specifications v2.3

Source document: [Scheme Master Data Structure Specifications v2.3.docx](../Scheme%20Master%20Data%20Structure%20Specifications%20v2.3.docx)

Scheme Master – Data Structure Specifications

## Overview

This document outlines the data structure of the Scheme Master for sharing with the entities whose system is integrated with MFU for transaction submission.  The Scheme data with MFU is maintained by the AMCs themselves and as such, the data is provided on as is where is basis.

MFU will offer this data as an incremental file on a daily basis. Incremental data will not be provided if there were no changes during the day. The data will be emailed to a designated email id of the entity.

## Scheme MASTER

#### This file will contain the Master details of the Scheme Plans supported by MFU. The file format will be delimited text file with the ‘|’ symbol (pipe) being the delimiter. The file will be named as below:

#### Incremental – MFU_SCHEME_MASTER_INC_<yyyymmdd>.dat

## Table 1

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

## Table 2

| Cat. Code | Category Description |
| --- | --- |
| 1 | EQUITY |
| 2 | DEBT |
| 3 | CASH/LIQUID/MONEY MARKET |
| 4 | HYBRID |

## Table 3

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

## Scheme THRESHOLD MASTER

#### This file contains the Scheme Threshold and other parameters for the Scheme Plans supported by MFU. The file format will be delimited text file with the ‘|’ symbol (pipe) being the delimiter. The file will be named as below:

#### Incremental – MFU_SCHEME_THRESHOLD_INC_<Date>.dat

## Table 4

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

## Document Change History

## Table 5

| Version | Revision<br>Date | Change<br>Description |
| --- | --- | --- |
| 1.0 |  | Base Version |
| 1.1 |  | Scheme: New fields [Demat, Scheme Category& Scheme Sub-Category] introduced, Fund Name will not be shown<br>Threshold: Label Maximum_Units changed to Multiple_Units |
| 2.0 |  | Scheme: New field to indicate Scheme is active or not<br>Threshold: NFO threshold details added |
| 2.1 | 24 Jul 2018 | New dataset with source and target scheme whenever the scheme is merged. |
| 2.2 | 07 Sep 2021 | Scheme Category and Scheme subcategory value list updated |
| 2.3 | 28 Jan 2023 | Scheme Merger Dataset removed |
