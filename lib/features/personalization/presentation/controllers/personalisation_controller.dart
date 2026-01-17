// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

// import 'package:get/get.dart';
// import 'package:my_sip/features/personalization/domain/entity/bank_entity.dart';
// import 'package:my_sip/features/personalization/domain/usecases/get_bank_use_cases.dart';
// import 'package:my_sip/features/personalization/domain/usecases/personalisation_use_cases.dart';

// class PersonalisationController extends GetxController {

//   final PersonalisationUseCases  _personalisationUseCases;



//   var isLoading = false.obs;
//   var bankList = <BankItemEntity>[].obs;
//   var errorMessage = ''.obs;

//   PersonalisationController({required PersonalisationUseCases personalisationUseCases}) : _personalisationUseCases = personalisationUseCases;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchBanks();
//   }

//   Future<void> fetchBanks() async {
//     try {
//       isLoading(true);
//       errorMessage('');

//       final result = await _getBankUseCases.call({});
//       // final result = await _personalisationUseCases._getBankUseCases

//       result.fold(
//         (success) {
//           if (success.data != null) {
//             // Direct assignment to trigger GetX observers
//             bankList.assignAll(success.data!.data);
//             print("CONTROLLER: Successfully assigned ${bankList.length} banks");
//           }
//         },
//         (error) {
//           errorMessage.value = error.message ?? "Failed to load banks";
//           print("CONTROLLER ERROR: ${errorMessage.value}");
//         },
//       );
//     } catch (e) {
//       errorMessage.value = "An unexpected error occurred: $e";
//     } finally {
//       isLoading(false);
//     }
//   }
// }
