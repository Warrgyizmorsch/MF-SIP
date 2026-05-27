import 'package:my_sip/features/dashboard/domain/usecases/portfolio_usecases.dart';
import 'package:my_sip/features/dashboard/domain/usecases/transactionlist_usecases.dart';

class DashboardUsecases {
  final GetTransactionsUseCase getTransactionsUseCase;
  final GetPortfolioUseCase getPortfolioUseCase;

  DashboardUsecases({
    required this.getTransactionsUseCase,
    required this.getPortfolioUseCase,
  });
}
