import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/animated/custom_toast.dart';
import 'package:my_sip/features/mfu/data/model/normal_txn_req_model.dart';
import 'package:my_sip/features/mfu/domain/entity/can_register_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/can_status_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/emandate_status_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/mandate_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/normal_txn_entity.dart';
import 'package:my_sip/features/mfu/domain/usecases/mfu_usecases.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';

class MfuController extends GetxController {
  final MfuUseCases mfuUseCases;
  final session = SessionManager.instance;

  MfuController(this.mfuUseCases);

  // ─── State ───────────────────────────────────────────────────────────────────

  final isLoading = false.obs;
  final isLoadingMandateStatus = false.obs;
  final isLoadingCanStatus = false.obs;
  final isVerified = false.obs;
  final isVerifying = false.obs;
  final isCreatingMandate = false.obs;
  final isSubmittingTxn = false.obs;

  final mandateCreateResponse = Rxn<MfuMandateCreateEntity>();
  final mfuCanResponse = Rxn<MfuCanResponseEntity>();
  final mandateStatusResponse = Rxn<MfuMandateStatusEntity>();
  final canStatusResponse = Rxn<MfuCanStatusEntity>();
  final normalTxnResponse = Rxn<MfuNormalTxnEntity>();

  final errorMessage = ''.obs;
  final selectedMethod = 'upi'.obs; // 'upi' | 'netbanking'
  final upiId = ''.obs;
  final TextEditingController upiNumber = TextEditingController();

  // ─── Convenience Getters ─────────────────────────────────────────────────────

  String get canNumber => mfuCanResponse.value?.can ?? '';
  String get canStatus => mfuCanResponse.value?.canStatus ?? '';
  String get canStatusMessage => mfuCanResponse.value?.canStatusMessage ?? '';
  bool get isCanPending => canStatus.toLowerCase() == 'pending';

  List<BlockRespEntity> get blockRespList =>
      mfuCanResponse.value?.canStatusResponse?.respBody?.blockRespList ?? [];

  bool get hasRegistrationError =>
      mfuCanResponse.value?.canRegistrationResponse?.respHeader?.isSuccess ==
      false;

  String get registrationError =>
      mfuCanResponse.value?.canRegistrationResponse?.respHeader?.errorMsg ?? '';

  Timer? _canStatusTimer;
  static const _pollInterval = Duration(hours: 2);

  void selectMethod(String method) {
    selectedMethod.value = method;
    isVerified.value = false;
    // upiId.value = '';
  }

  Future<void> verifyUpi() async {
    if (upiId.value.isEmpty) {
      showCustomToast(
        title: 'Enter UPI Id',
        message: '',
        backgroundColor: Colors.red,
        icon: Icons.warning,
      );
      return;
    }
    isVerifying.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isVerified.value = true;
    isVerifying.value = false;
  }

  // ─── Actions ─────────────────────────────────────────────────────────────────

  // Future<void> canRegister() async {
  //   isLoading.value = true;
  //   errorMessage.value = '';

  //   // uid comes from the logged-in session
  //   final uid = session.getUserData?.id ?? 0;

  //   final result = await mfuUseCases.canRegisterUseCase(uid: uid);

  //   result.fold(
  //     (success) {
  //       mfuCanResponse.value = success.data;
  //     },
  //     (error) {
  //       errorMessage.value = error.message ?? 'Something went wrong';
  //       Get.snackbar('MFU Error', errorMessage.value);
  //     },
  //   );

  //   isLoading.value = false;
  // }
  Future<void> canRegister({String reqEvent = "CR"}) async {
    isLoading.value = true;
    errorMessage.value = '';

    final uid = session.getUserData?.id ?? 0;

    final result = await mfuUseCases.canRegisterUseCase(
      uid: uid,
      reqEvent: reqEvent,
    );

    result.fold(
      (success) {
        mfuCanResponse.value = success.data;
      },
      (error) {
        errorMessage.value = error.message ?? 'Something went wrong';
        Get.snackbar('MFU Error', errorMessage.value);
      },
    );

    isLoading.value = false;
  }

  Future<void> getCanStatus() async {
    final can = session.getUserData?.canNumber ?? '';

    if (can.isEmpty) {
      log("[MfuController] getCanStatus — no CAN number in session");
      return;
    }

    isLoadingCanStatus.value = true;
    errorMessage.value = '';

    final result = await mfuUseCases.getCanStatusUseCase.call(can: can);

    result.fold(
      (success) {
        canStatusResponse.value = success.data;
        log("[MfuController] CAN Status: ${success.data?.canStatus}");
      },
      (error) {
        errorMessage.value = error.message ?? 'Something went wrong';
        Get.snackbar('MFU Error', errorMessage.value);
      },
    );

    isLoadingCanStatus.value = false;
  }

  void _startCanStatusPolling() {
    // Cancel any existing timer before starting a new one
    _stopCanStatusPolling();

    final can =
        session.getUserData?.canNumber ?? mfuCanResponse.value?.can ?? '';

    if (can.isEmpty) {
      log("[MfuController] Cannot start polling — no CAN number");
      return;
    }

    log(
      "[MfuController] ⏱ Starting CAN status polling every 5 min for CAN: $can",
    );

    // ✅ Check immediately once, then every 5 minutes
    getCanStatus();

    _canStatusTimer = Timer.periodic(_pollInterval, (_) {
      log("[MfuController] ⏱ Polling CAN status...");
      getCanStatus();
    });
  }

  void _stopCanStatusPolling() {
    if (_canStatusTimer != null) {
      _canStatusTimer!.cancel();
      _canStatusTimer = null;
      log("[MfuController] ⏹ CAN status polling stopped");
    }
  }

  void resumePollingIfNeeded() {
    final canNumber = session.getUserData?.canNumber ?? '';
    final canStatus = session.getUserData?.canStatus?.toLowerCase() ?? '';

    if (canNumber.isNotEmpty && canStatus == 'pending') {
      log("[MfuController] 🔄 Resuming CAN status polling on app start");
      _startCanStatusPolling();
    }
  }

  /// ------   Mandate ----   ///
  Future<void> createMandate({
    required String mandateType,
    String? upiId,
  }) async {
    isCreatingMandate.value = true;
    errorMessage.value = '';

    CustomLoadingDialog.show(title: "Preparing secure gateway...");

    final uid = session.getUserData?.id ?? 0;

    try {
      final result = await mfuUseCases.mfuMandateCreateUseCase(
        uid: uid,
        mandateType: mandateType,
        upiId: upiId,
      );

      await result.fold(
        (success) async {
          mandateCreateResponse.value = success.data;
          final approveLink = success.data?.approveLink;

          // Navigator.of(Get.overlayContext!).pop();
          CustomLoadingDialog.hide();

          if (approveLink != null && approveLink.isNotEmpty) {
            final webViewResult = await Get.to(
              () => MandateWebView(url: approveLink),
            );

            debugPrint("==================================================");
            debugPrint("WEBPAGE RAW TEXT:");
            debugPrint(webViewResult.toString());
            debugPrint("==================================================");

            if (webViewResult == 'success' || webViewResult == 'check_status') {
              // Get.dialog(
              //   const Center(
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         CircularProgressIndicator(color: Colors.white),
              //         SizedBox(height: 16),
              //         Text(
              //           "Verifying status with bank...",
              //           style: TextStyle(color: Colors.white, fontSize: 16),
              //         ),
              //       ],
              //     ),
              //   ),
              //   barrierDismissible: false,
              // );
              CustomLoadingDialog.show(title: "Verifying status with bank...");

              try {
                await Future.delayed(const Duration(seconds: 2));

                await getMandateStatus(mandateType: mandateType);
              } finally {
                Navigator.of(Get.overlayContext!).pop();
              }

              await Future.delayed(const Duration(milliseconds: 300));

              final actualStatus = mandateStatusResponse.value?.status
                  ?.toLowerCase();

              if (actualStatus == 'success' || actualStatus == 'approved') {
                CustomSnackbar.success(
                  title: 'Success',
                  message: 'Mandate approved and verified successfully!',
                );
              } else if (actualStatus == 'pending') {
                CustomSnackbar.success(
                  title: 'Processing',
                  message:
                      'Your mandate is being processed. It may take a few minutes.',
                );
              } else {
                CustomSnackbar.error(
                  title: 'Failed',
                  message: 'Mandate verification failed. Status: $actualStatus',
                );
              }
            } else if (webViewResult == 'failed') {
              CustomSnackbar.error(
                title: 'Failed',
                message: 'Mandate authorization failed or was cancelled.',
              );
            }
          }
        },
        (error) async {
          // Navigator.of(Get.overlayContext!).pop();
          CustomLoadingDialog.hide();
          await Future.delayed(const Duration(milliseconds: 300));

          errorMessage.value = error.message;
          CustomSnackbar.error(
            title: 'Mandate Error',
            message: errorMessage.value,
          );
        },
      );
    } catch (e) {
      Get.back();

      CustomSnackbar.error(
        title: 'Error',
        message: 'An unexpected error occurred.',
      );
    }

    isCreatingMandate.value = false;
  }

  /*
  // Future<void> createMandate({required String mandateType}) async {
  //   isCreatingMandate.value = true;
  //   errorMessage.value = '';

  //   final uid = session.getUserData?.id ?? 0;

  //   final result = await mfuUseCases.mfuMandateCreateUseCase(
  //     uid: uid,
  //     mandateType: mandateType,
  //   );

  //   // result.fold(
  //   //   (success) {
  //   //     mandateCreateResponse.value = success.data;
  //   //     log(
  //   //       "[MfuController] Mandate created — type: $mandateType | approve link: ${success.data?.approveLink}",
  //   //     );
  //   //   },
  //   //   (error) {
  //   //     errorMessage.value = error.message;
  //   //     Get.snackbar('Mandate Error', errorMessage.value);
  //   //   },
  //   // );
  //   await result.fold(
  //     (success) async {
  //       mandateCreateResponse.value = success.data;
  //       final approveLink = success.data?.approveLink;

  //       if (approveLink != null && approveLink.isNotEmpty) {
  //         // Navigate to your new WebView screen and wait for the result
  //         final result = await Get.to(() => MandateWebView(url: approveLink));

  //         if (result == 'success' || result == 'check_status') {
  //           CustomSnackbar.success(
  //             title: 'Success',
  //             message: 'Mandate approved successfully!',
  //           );
  //           // Refresh your user data or state here
  //         } else if (result == 'failed') {
  //           CustomSnackbar.error(
  //             title: 'Failed',
  //             message: 'Mandate authorization failed or was cancelled.',
  //           );
  //         } else {
  //           Get.snackbar(
  //             'Something else ',
  //             'some other problem.',
  //             backgroundColor: Colors.orange,
  //             colorText: Colors.white,
  //           );
  //         }
  //       }
  //     },

  //     (error) {
  //       errorMessage.value = error.message;
  //       CustomSnackbar.error(
  //         title: 'Mandate Error',
  //         message: errorMessage.value,
  //       );
  //     },
  //   );

  //   isCreatingMandate.value = false;
  // }

  */

  // get mandate status
  Future<void> getMandateStatus({required String mandateType}) async {
    isLoadingMandateStatus.value = true;
    errorMessage.value = '';

    final uid = session.getUserData?.id ?? 0;

    final result = await mfuUseCases.mfuMandateStatusUseCase(
      uid: uid,
      mandateType: mandateType,
    );

    result.fold(
      (success) {
        mandateStatusResponse.value = success.data;
        log("[MfuController] Mandate Status: ${success.data?.status}");
      },
      (error) {
        errorMessage.value = error.message ?? 'Failed to fetch mandate status';
        CustomSnackbar.error(
          title: 'Mandate Status Error ----------',
          message: errorMessage.value,
        );
      },
    );

    isLoadingMandateStatus.value = false;
  }

  Future<void> normalTransaction(MfuNormalTxnRequest request) async {
    isSubmittingTxn.value = true;
    errorMessage.value = '';

    final result = await mfuUseCases.mfuNormalTxnUseCase(request);

    result.fold(
      (success) async {
        normalTxnResponse.value = success.data;
        log(
          "[MfuController] Txn submitted — ref: ${success.data?.entGroupRefNo}",
        );

        if (success.data?.hasApprovalLink == true) {
          // openLink(success.data!.approvalLink);
          final webViewResult = await Get.to(
            () => MandateWebView(url: success.data!.approvalLink),
          );
        }
      },
      (error) {
        errorMessage.value = error.message ?? 'Transaction failed';
        Get.snackbar('Transaction Error', errorMessage.value);
      },
    );

    isSubmittingTxn.value = false;
  }

  @override
  void onClose() {
    _stopCanStatusPolling();
    super.onClose();
  }
}

class MandateWebView extends StatefulWidget {
  final String url;
  const MandateWebView({super.key, required this.url});

  @override
  State<MandateWebView> createState() => _MandateWebViewState();
}

class _MandateWebViewState extends State<MandateWebView> {
  bool _succeeded = false;

  static const _desktopUA =
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36";

  InAppWebViewSettings get _settings => InAppWebViewSettings(
    javaScriptEnabled: true,
    domStorageEnabled: true,
    thirdPartyCookiesEnabled: true,
    supportMultipleWindows: true,
    javaScriptCanOpenWindowsAutomatically: true,
    useShouldOverrideUrlLoading: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    userAgent: _desktopUA,
  );

  String get _bridgeHtml =>
      '''
    <html><body>
    <script>
      window.onload = function() { window.open('${widget.url}', '_blank'); };
    </script>
    </body></html>
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approve Mandate"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(result: 'check_status'),
        ),
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(data: _bridgeHtml),
        initialSettings: _settings,

        onCreateWindow: (controller, action) async {
          final result = await Get.to(
            () =>
                _PopupWebView(windowId: action.windowId, desktopUA: _desktopUA),
          );
          if (mounted) Get.back(result: result ?? 'check_status');
          return true;
        },

        onReceivedServerTrustAuthRequest: (controller, challenge) async =>
            ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED,
            ),
      ),
    );
  }
}

// ─── Popup ────────────────────────────────────────────────────────────────────

class _PopupWebView extends StatefulWidget {
  final int windowId;
  final String desktopUA;
  const _PopupWebView({required this.windowId, required this.desktopUA});

  @override
  State<_PopupWebView> createState() => _PopupWebViewState();
}

class _PopupWebViewState extends State<_PopupWebView> {
  bool _succeeded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Approve Mandate"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(result: 'check_status'),
        ),
      ),
      body: InAppWebView(
        windowId: widget.windowId,
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          domStorageEnabled: true,
          thirdPartyCookiesEnabled: true,
          supportMultipleWindows: true,
          javaScriptCanOpenWindowsAutomatically: true,
          useShouldOverrideUrlLoading: true,
          mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          userAgent: widget.desktopUA,
        ),

        shouldOverrideUrlLoading: (controller, action) async {
          final url = action.request.url?.toString() ?? '';

          // Success return URL
          if (url.contains("EPayeezDebitResHandler.do")) {
            _succeeded = true;
            if (mounted) Get.back(result: 'success');
            return NavigationActionPolicy.CANCEL;
          }

          // External app (UPI, intent://, etc.)
          final scheme = Uri.tryParse(url)?.scheme.toLowerCase() ?? '';
          if (![
            'http',
            'https',
            'about',
            'data',
            'javascript',
          ].contains(scheme)) {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
            return NavigationActionPolicy.CANCEL;
          }

          return NavigationActionPolicy.ALLOW;
        },

        onLoadStop: (controller, url) async {
          final currentUrl = url.toString();
          debugPrint("Page Loaded: $currentUrl");

          // Safely parse the URL so we can check the actual page endpoint
          final uri = Uri.tryParse(currentUrl);

          // Use uri.path instead of currentUrl.contains
          if (uri != null && uri.path.contains("EPayeezDebitResHandler.do")) {
            debugPrint("🎉 NPCI Flow Complete! Auto-closing WebView...");

            _succeeded =
                true; // Prevent the onCloseWindow from marking it as failed

            final String rawPageText =
                await controller.evaluateJavascript(
                  source: "document.body.innerText;",
                ) ??
                "No text found";

            // Optional: Give the user 1 second to see the final "OK" page
            await Future.delayed(const Duration(seconds: 1));

            if (mounted) {
              Get.back(result: 'success');
            }
          }
        },

        onUpdateVisitedHistory: (controller, url, isReload) async {
          final currentUrl = url.toString();
          final uri = Uri.tryParse(currentUrl);

          // Use uri.path here as well!
          if (uri != null && uri.path.contains("EPayeezDebitResHandler.do")) {
            _succeeded = true;
            if (mounted) {
              Get.back(result: 'success');
            }
          }
        },

        onCloseWindow: (controller) {
          if (!_succeeded && mounted) Get.back(result: 'check_status');
        },

        onReceivedServerTrustAuthRequest: (controller, challenge) async =>
            ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED,
            ),

        gestureRecognizers: {
          Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer(),
          ),
          Factory<HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer(),
          ),
          Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
          Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
        },
      ),
    );
  }
}

// class MandateWebView extends StatefulWidget {
//   final String url;

//   const MandateWebView({super.key, required this.url});

//   @override
//   State<MandateWebView> createState() => _MandateWebViewState();
// }

// class _MandateWebViewState extends State<MandateWebView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Approve Mandate")),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(url: WebUri(widget.url)),

//         // --- 1. CRITICAL WEBVIEW SETTINGS ---
//         initialSettings: InAppWebViewSettings(
//           javaScriptEnabled: true,
//           domStorageEnabled: true,

//           // Allow BillDesk and NPCI to keep session cookies
//           thirdPartyCookiesEnabled: true,

//           // Allow NPCI to trigger its JavaScript redirects
//           javaScriptCanOpenWindowsAutomatically: true,
//           supportMultipleWindows: true,

//           // Spoof the User-Agent to look like a real Chrome browser on an Android device
//           userAgent:
//               "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
//         ),

//         onCloseWindow: (controller) {
//           debugPrint(
//             "NPCI/Bank portal called window.close(). Closing WebView.",
//           );
//           // Close the screen and return to your app
//           Get.back(result: 'window_closed');
//         },

//         // --- 2. HANDLE NEW WINDOW REQUESTS ---
//         // If NPCI tries to open the bank portal in a "new tab",
//         // we force it to load inside our current WebView window instead.
//         onCreateWindow: (controller, createWindowAction) async {
//           if (createWindowAction.request.url != null) {
//             await controller.loadUrl(urlRequest: createWindowAction.request);
//             return true; // We handled it
//           }
//           return false;
//         },

//         // --- 3. HANDLE INTENT URLs (UPI / Bank Apps) ---
//         // Sometimes eNACH prompts the user to open their UPI app
//         shouldOverrideUrlLoading: (controller, navigationAction) async {
//           var uri = navigationAction.request.url!;
//           var scheme = uri.scheme.toLowerCase();

//           // If the URL is NOT a standard webpage (e.g., upi://, intent://, paytm://)
//           if (!['http', 'https', 'about', 'data'].contains(scheme)) {
//             if (await canLaunchUrl(uri)) {
//               // Open the external banking app
//               await launchUrl(uri, mode: LaunchMode.externalApplication);
//               return NavigationActionPolicy.CANCEL;
//             }
//           }

//           return NavigationActionPolicy.ALLOW;
//         },

//         // --- 4. INTERCEPT YOUR FINAL REDIRECT ---
//         onLoadStart: (controller, url) {
//           final currentUrl = url.toString();

//           // Replace these with whatever your backend returns upon completion
//           if (currentUrl.contains("your-app-success-url.com")) {
//             Get.back(result: 'success');
//           } else if (currentUrl.contains("your-app-failure-url.com")) {
//             Get.back(result: 'failed');
//           }
//         },

//         // (Keep the SSL bypass logic here ONLY if you are still testing on the IP address)
//         onReceivedServerTrustAuthRequest: (controller, challenge) async {
//           return ServerTrustAuthResponse(
//             action: ServerTrustAuthResponseAction.PROCEED,
//           );
//         },
//       ),
//     );
//   }
// }

// class MandateWebView extends StatelessWidget {
//   final String url;

//   const MandateWebView({super.key, required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Mandate Approval")),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(url: WebUri(url)),
//         initialSettings: InAppWebViewSettings(
//           javaScriptEnabled: true,
//           // This allows content from IP addresses or mismatched certificates
//           allowContentAccess: true,
//           allowFileAccess: true,
//         ),
//         onReceivedServerTrustAuthRequest: (controller, challenge) async {
//           // This is the "Advanced -> Proceed" equivalent
//           return ServerTrustAuthResponse(
//             action: ServerTrustAuthResponseAction.PROCEED,
//           );
//         },
//       ),
//     );
//   }
// }
