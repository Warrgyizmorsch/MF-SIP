import 'package:my_sip/features/mfu/domain/usecases/can_register_usecases.dart';
import 'package:my_sip/features/mfu/domain/usecases/can_status_usecases.dart';

class MfuUseCases {
  final CanRegisterUseCase canRegisterUseCase;
  final GetCanStatusUseCase getCanStatusUseCase;

  MfuUseCases({
    required this.canRegisterUseCase,
    required this.getCanStatusUseCase,
  });
}
