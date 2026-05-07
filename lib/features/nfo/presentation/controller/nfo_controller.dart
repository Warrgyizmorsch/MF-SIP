import 'package:get/get.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:my_sip/features/nfo/domain/entity/nfo_list_entity.dart';
import 'package:my_sip/features/nfo/domain/usecases/nfo_use_usecases.dart';

class NfoController extends GetxController {
  final NfoUseUsecases nfoUseUsecases;
  NfoController(this.nfoUseUsecases);

  @override
  void onInit() {
    super.onInit();
    fetchNfoList();
  }

  final isLoading = false.obs;
  final errorMessgae = ''.obs;

  final Rxn<NfoListEntity> nfoResult = Rxn<NfoListEntity>();

  Future<void> fetchNfoList() async {
    try {
      isLoading(true);
      errorMessgae.value = '';
      final result = await nfoUseUsecases.call({});
      result.fold(
        (success) {
          nfoResult.value = success.data;
          createLog("Fund details loaded successfully ${success.data}");
        },
        (error) {
          errorMessgae.value = error.message;
          createLog("Error loading fund details: $error");
        },
      );
    } catch (e) {
      isLoading(false);
      createLog("Exception in getFundDetails: $e");
    } finally {
      isLoading(false);
    }
  }
}
