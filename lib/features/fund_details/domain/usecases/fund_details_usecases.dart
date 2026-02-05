import 'package:my_sip/features/fund_details/domain/usecases/get_fund_detail_usecase.dart';
import 'package:my_sip/features/fund_details/domain/usecases/portfolio_analysis_usecases.dart';

class FundDetailsUsecases {
  final GetFundDetailUseCase fundDetailUseCase;
  final PortfolioAnalysisUsecases portfolioAnalysisUsecases;

  FundDetailsUsecases({
    required this.fundDetailUseCase,
    required this.portfolioAnalysisUsecases,
  });
}
