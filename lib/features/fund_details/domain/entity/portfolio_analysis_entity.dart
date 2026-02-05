import 'package:equatable/equatable.dart';
import 'package:my_sip/features/fund_details/data/models/portfolio_analysis_model.dart';

class SchemeDetailsEntity extends Equatable {
  final int status;
  final String statusMsg;
  final String msg;
  final String isin;
  final String schemeName;

  // Lists
  final List<String> schemePortfolioHoldingsNamesString;
  final List<double> schemePortfolioHoldingsValuesString;
  final List<String> sectorNamesString;
  final List<double> sectorValuesString;
  final List<String> assetAllocationNamesString;
  final List<double> assetAllocationValuesString;

  // Maps (Kept as Maps, but handled safely)
  final Map<String, double> schemePortfolioHoldings;
  final Map<String, double> sectorAllocation;
  final Map<String, double> assetAllocation;

  // Nested Entity
  final McapAllocationEntity mcapAllocation;

  const SchemeDetailsEntity({
    required this.status,
    required this.statusMsg,
    required this.msg,
    required this.isin,
    required this.schemeName,
    required this.schemePortfolioHoldingsNamesString,
    required this.schemePortfolioHoldingsValuesString,
    required this.schemePortfolioHoldings,
    required this.sectorNamesString,
    required this.sectorValuesString,
    required this.sectorAllocation,
    required this.assetAllocationNamesString,
    required this.assetAllocationValuesString,
    required this.assetAllocation,
    required this.mcapAllocation,
  });

  @override
  List<Object?> get props => [
        status,
        schemeName,
        isin,
        schemePortfolioHoldings, // Note: Maps in Equatable only compare by reference unless wrapped
        sectorAllocation,
        assetAllocation,
        mcapAllocation,
      ];
}

class McapAllocationEntity extends Equatable {
  final double marketCapLargecapPercent;
  final double marketCapMidcapPercent;
  final double marketCapSmallcapPercent;

  const McapAllocationEntity({
    required this.marketCapLargecapPercent,
    required this.marketCapMidcapPercent,
    required this.marketCapSmallcapPercent,
  });

  @override
  List<Object?> get props => [
        marketCapLargecapPercent,
        marketCapMidcapPercent,
        marketCapSmallcapPercent,
      ];
}

extension SchemeDetailsModelX on SchemeDetailsModel {
  SchemeDetailsEntity toEntity() {
    return SchemeDetailsEntity(
      status: status ?? 0,
      statusMsg: statusMsg ?? '',
      msg: msg ?? '',
      isin: isin ?? '',
      schemeName: schemeName ?? '',
      
      schemePortfolioHoldingsNamesString: schemePortfolioHoldingsNamesString ?? [],
      schemePortfolioHoldingsValuesString: schemePortfolioHoldingsValuesString ?? [],
      schemePortfolioHoldings: schemePortfolioHoldings ?? {},
      
      sectorNamesString: sectorNamesString ?? [],
      sectorValuesString: sectorValuesString ?? [],
      sectorAllocation: sectorAllocation ?? {},
      
      assetAllocationNamesString: assetAllocationNamesString ?? [],
      assetAllocationValuesString: assetAllocationValuesString ?? [],
      assetAllocation: assetAllocation ?? {},
      
      // Handle nested nullability safely
      mcapAllocation: mcapAllocationResponse?.toEntity() ?? 
          const McapAllocationEntity(
            marketCapLargecapPercent: 0.0, 
            marketCapMidcapPercent: 0.0, 
            marketCapSmallcapPercent: 0.0
          ),
    );
  }
}

extension McapAllocationModelX on McapAllocationModel {
  McapAllocationEntity toEntity() {
    return McapAllocationEntity(
      marketCapLargecapPercent: marketCapLargecapPercent ?? 0.0,
      marketCapMidcapPercent: marketCapMidcapPercent ?? 0.0,
      marketCapSmallcapPercent: marketCapSmallcapPercent ?? 0.0,
    );
  }
}