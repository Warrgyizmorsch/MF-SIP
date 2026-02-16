import 'package:my_sip/features/personalization/domain/usecases/get_bank_use_cases.dart';
import 'package:my_sip/features/personalization/domain/usecases/get_riskQuestion_use_cases.dart';

class PersonalisationUseCases {
  final GetBankUseCases _getBankUseCases;
  final GetRiskquestionUseCases getRiskquestionUseCases;

  PersonalisationUseCases(this._getBankUseCases, this.getRiskquestionUseCases);
}
