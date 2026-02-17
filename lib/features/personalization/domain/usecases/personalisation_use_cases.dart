import 'package:my_sip/features/personalization/domain/usecases/add_nominee_use_case.dart';
import 'package:my_sip/features/personalization/domain/usecases/get_bank_use_cases.dart';
import 'package:my_sip/features/personalization/domain/usecases/get_riskQuestion_use_cases.dart';
import 'package:my_sip/features/personalization/domain/usecases/risk_submit_usecases.dart';

class PersonalisationUseCases {
  final GetBankUseCases _getBankUseCases;
  final GetRiskquestionUseCases getRiskquestionUseCases;
  final RiskSubmitUsecases riskSubmitUsecases;
  final AddNomineeUseCase addNomineeUseCase;

  PersonalisationUseCases(this._getBankUseCases, this.getRiskquestionUseCases, this.riskSubmitUsecases, this.addNomineeUseCase);
}
