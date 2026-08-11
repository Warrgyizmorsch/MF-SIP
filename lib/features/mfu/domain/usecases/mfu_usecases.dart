import 'package:my_sip/features/mfu/domain/usecases/bank_validation_usecases.dart';
import 'package:my_sip/features/mfu/domain/usecases/can_register_usecases.dart';
import 'package:my_sip/features/mfu/domain/usecases/can_status_usecases.dart';
import 'package:my_sip/features/mfu/domain/usecases/emandate_status_usecases.dart';
import 'package:my_sip/features/mfu/domain/usecases/mandate_use_cases.dart';
import 'package:my_sip/features/mfu/domain/usecases/mfu_call_usecase.dart';
import 'package:my_sip/features/mfu/domain/usecases/normal_txn_usecases.dart';
import 'package:my_sip/features/mfu/domain/usecases/systematic_txn_usecases.dart';

import 'package:my_sip/features/mfu/domain/usecases/post_lumpsum_usecase.dart';
import 'package:my_sip/features/mfu/domain/usecases/post_sip_usecase.dart';
import 'package:my_sip/features/mfu/domain/usecases/post_stepup_usecase.dart';

class MfuUseCases {
  final CanRegisterUseCase canRegisterUseCase;
  final GetCanStatusUseCase getCanStatusUseCase;
  final MfuMandateCreateUseCase mfuMandateCreateUseCase;
  final MfuMandateStatusUseCase mfuMandateStatusUseCase;
  final MfuNormalTxnUseCase mfuNormalTxnUseCase;
  final MfuSystematicTxnUseCase mfuSystematicTxnUseCase;
  final MfuCanBankValidationUseCase mfuCanBankValidationUseCase;
  // final GetTransactionsUseCase getTransactionsUseCase;
  // final GetPortfolioUseCase getPortfolioUseCase; // 👈
  final MfuCallUseCase mfuCallUseCase;
  final PostLumpsumUseCase postLumpsumUseCase;
  final PostSipUseCase postSipUseCase;
  final PostStepUpUseCase postStepUpUseCase;

  MfuUseCases({
    required this.canRegisterUseCase,
    required this.getCanStatusUseCase,
    required this.mfuMandateCreateUseCase,
    required this.mfuMandateStatusUseCase,
    required this.mfuNormalTxnUseCase,
    required this.mfuSystematicTxnUseCase,
    required this.mfuCanBankValidationUseCase,
    // required this.getTransactionsUseCase,
    // required this.getPortfolioUseCase,
    required this.mfuCallUseCase,
    required this.postLumpsumUseCase,
    required this.postSipUseCase,
    required this.postStepUpUseCase,
  });
}
