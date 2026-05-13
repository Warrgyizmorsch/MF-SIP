import 'package:my_sip/features/mfu/domain/usecases/can_register_usecases.dart';
import 'package:my_sip/features/mfu/domain/usecases/can_status_usecases.dart';
import 'package:my_sip/features/mfu/domain/usecases/mandate_use_cases.dart';

class MfuUseCases {
  final CanRegisterUseCase canRegisterUseCase;
  final GetCanStatusUseCase getCanStatusUseCase;
  final MfuMandateCreateUseCase mfuMandateCreateUseCase;

  MfuUseCases({
    required this.canRegisterUseCase,
    required this.getCanStatusUseCase,
    required this.mfuMandateCreateUseCase,
  });
}
