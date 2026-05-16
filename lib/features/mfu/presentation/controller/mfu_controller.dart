import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/mfu/domain/entity/can_register_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/can_status_entity.dart';
import 'package:my_sip/features/mfu/domain/entity/mandate_entity.dart';
import 'package:my_sip/features/mfu/domain/usecases/mfu_usecases.dart';
import 'package:my_sip/services/session_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class MfuController extends GetxController {
  final MfuUseCases mfuUseCases;
  final session = SessionManager.instance;

  MfuController(this.mfuUseCases);

  // ─── State ───────────────────────────────────────────────────────────────────

  final isLoading = false.obs;
  final mfuCanResponse = Rxn<MfuCanResponseEntity>();
  final errorMessage = ''.obs;

  final isLoadingCanStatus = false.obs;
  final canStatusResponse = Rxn<MfuCanStatusEntity>();

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

  /// -------   Bank  -----------  //
  final selectedMethod = 'upi'.obs; // 'upi' | 'netbanking'
  final upiId = ''.obs;
  final isVerified = false.obs;
  final isVerifying = false.obs;

  void selectMethod(String method) {
    selectedMethod.value = method;
    isVerified.value = false;
    upiId.value = '';
  }

  Future<void> verifyUpi() async {
    if (upiId.value.isEmpty) return;
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
  final isCreatingMandate = false.obs;
  final mandateCreateResponse = Rxn<MfuMandateCreateEntity>();

  Future<void> createMandate({required String mandateType}) async {
    isCreatingMandate.value = true;
    errorMessage.value = '';

    final uid = session.getUserData?.id ?? 0;

    final result = await mfuUseCases.mfuMandateCreateUseCase(
      uid: uid,
      mandateType: mandateType,
    );

    // result.fold(
    //   (success) {
    //     mandateCreateResponse.value = success.data;
    //     log(
    //       "[MfuController] Mandate created — type: $mandateType | approve link: ${success.data?.approveLink}",
    //     );
    //   },
    //   (error) {
    //     errorMessage.value = error.message;
    //     Get.snackbar('Mandate Error', errorMessage.value);
    //   },
    // );
    result.fold(
      (success) async {
        mandateCreateResponse.value = success.data;
        final approveLink = success.data?.approveLink;

        if (approveLink != null && approveLink.isNotEmpty) {
          // Navigate to your new WebView screen and wait for the result
          final result = await Get.to(() => MandateWebView(url: approveLink));

          if (result == 'success') {
            Get.snackbar('Success', 'Mandate approved successfully!');
            // Refresh your user data or state here
          } else if (result == 'failed') {
            Get.snackbar(
              'Failed',
              'Mandate authorization failed or was cancelled.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              'Something else ',
              'some other problem.',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          }
        }
      },

      // ... error handling ...
      (error) {
        errorMessage.value = error.message;
        Get.snackbar('Mandate Error', errorMessage.value);
      },
    );

    isCreatingMandate.value = false;
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
//   String get _bridgeHtml =>
//       '''
//     <!DOCTYPE html>
//     <html>
//       <body>
//         <script>
//           window.onload = function() {
//             window.open('${widget.url}', 'mandatePopup');
//           };
//         </script>
//         <p style="font-family:sans-serif;text-align:center;margin-top:40px;">
//           Opening mandate approval...
//         </p>
//       </body>
//     </html>
//   ''';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Approve Mandate"),
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () => Get.back(result: 'check_status'),
//         ),
//       ),
//       body: InAppWebView(
//         // Step 1: Load the bridge page
//         initialData: InAppWebViewInitialData(data: _bridgeHtml),

//         initialSettings: InAppWebViewSettings(
//           javaScriptEnabled: true,
//           domStorageEnabled: true,
//           thirdPartyCookiesEnabled: true,
//           supportMultipleWindows: true,
//           javaScriptCanOpenWindowsAutomatically: true,
//           mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
//           useShouldOverrideUrlLoading: true,
//           userAgent:
//               "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 "
//               "(KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
//         ),

//         // Step 2: Bridge fires window.open() → caught here
//         // Create a NEW WebView with the windowId so window.opener is set correctly
//         onCreateWindow: (controller, createWindowAction) async {
//           debugPrint(
//             "[WebView] onCreateWindow windowId=${createWindowAction.windowId}",
//           );

//           final result = await Get.to(
//             () => _MandatePopupWebView(windowId: createWindowAction.windowId),
//           );

//           // Popup closed — pass its result back to the caller
//           if (mounted) Get.back(result: result ?? 'check_status');
//           return true;
//         },

//         onReceivedServerTrustAuthRequest: (controller, challenge) async {
//           return ServerTrustAuthResponse(
//             action: ServerTrustAuthResponseAction.PROCEED,
//           );
//         },
//       ),
//     );
//   }
// }

// // ─── The actual mandate popup WebView ────────────────────────────────────────
// class _MandatePopupWebView extends StatefulWidget {
//   final int windowId;
//   const _MandatePopupWebView({required this.windowId});

//   @override
//   State<_MandatePopupWebView> createState() => _MandatePopupWebViewState();
// }

// class _MandatePopupWebViewState extends State<_MandatePopupWebView> {
//   bool _succeeded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Approve Mandate"),
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () => Get.back(result: 'check_status'),
//         ),
//       ),
//       body: InAppWebView(
//         // ← This links the WebView to the popup opened by window.open()
//         // window.opener is now properly set → window.close() will work
//         windowId: widget.windowId,

//         initialSettings: InAppWebViewSettings(
//           javaScriptEnabled: true,
//           domStorageEnabled: true,
//           thirdPartyCookiesEnabled: true,
//           supportMultipleWindows: true,
//           javaScriptCanOpenWindowsAutomatically: true,
//           mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
//           useShouldOverrideUrlLoading: true,
//           userAgent:
//               "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 "
//               "(KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
//         ),

//         // Catch the final return URL
//         shouldOverrideUrlLoading: (controller, navigationAction) async {
//           final url = navigationAction.request.url?.toString() ?? '';
//           debugPrint("[Popup] Redirecting to: $url");

//           if (url.contains("EPayeezDebitResHandler.do")) {
//             debugPrint("[Popup] ✅ SUCCESS");
//             _succeeded = true;
//             if (mounted) Get.back(result: 'success');
//             return NavigationActionPolicy.CANCEL;
//           }

//           // Handle UPI / external app schemes
//           final scheme = Uri.tryParse(url)?.scheme.toLowerCase() ?? '';
//           if (![
//             'http',
//             'https',
//             'about',
//             'data',
//             'javascript',
//           ].contains(scheme)) {
//             final uri = Uri.parse(url);
//             if (await canLaunchUrl(uri)) {
//               await launchUrl(uri, mode: LaunchMode.externalApplication);
//             }
//             return NavigationActionPolicy.CANCEL;
//           }

//           return NavigationActionPolicy.ALLOW;
//         },

//         // window.close() now works because this WebView was created for the popup
//         onCloseWindow: (controller) {
//           debugPrint("[Popup] window.close() fired. succeeded=$_succeeded");
//           if (!_succeeded && mounted) Get.back(result: 'check_status');
//         },

//         onConsoleMessage: (controller, msg) {
//           debugPrint("[Popup Console] ${msg.message}");
//         },

//         onReceivedError: (controller, request, error) {
//           debugPrint("[Popup] ERROR: ${error.description} | ${request.url}");
//         },

//         onReceivedServerTrustAuthRequest: (controller, challenge) async {
//           return ServerTrustAuthResponse(
//             action: ServerTrustAuthResponseAction.PROCEED,
//           );
//         },

//         gestureRecognizers: {
//           Factory<VerticalDragGestureRecognizer>(
//             () => VerticalDragGestureRecognizer(),
//           ),
//           Factory<HorizontalDragGestureRecognizer>(
//             () => HorizontalDragGestureRecognizer(),
//           ),
//           Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
//           Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
//         },
//       ),
//     );
//   }
// }

// class MandateWebView extends StatefulWidget {
//   final String url;
//   const MandateWebView({super.key, required this.url});

//   @override
//   State<MandateWebView> createState() => _MandateWebViewState();
// }

// class _MandateWebViewState extends State<MandateWebView> {
//   InAppWebViewController? _webViewController;
//   bool _mandateSucceeded = false;

//   // Build a tiny bridge page that opens the mandate URL as a popup
//   // This sets window.opener correctly so MFU's JS works
//   String get _bridgeHtml =>
//       '''
//     <!DOCTYPE html>
//     <html>
//       <head><title>Loading...</title></head>
//       <body>
//         <script>
//           window.onload = function() {
//             window.open('${widget.url}', 'mandatePopup', 'width=400,height=700');
//           };
//         </script>
//         <p>Opening mandate approval...</p>
//       </body>
//     </html>
//   ''';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Approve Mandate"),
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () => Get.back(result: 'check_status'),
//         ),
//       ),
//       body: InAppWebView(
//         // Load the bridge HTML instead of the mandate URL directly
//         initialData: InAppWebViewInitialData(data: _bridgeHtml),

//         initialSettings: InAppWebViewSettings(
//           javaScriptEnabled: true,
//           domStorageEnabled: true,
//           thirdPartyCookiesEnabled: true,
//           supportMultipleWindows: true, // ← allows window.open()
//           javaScriptCanOpenWindowsAutomatically: true,
//           mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
//           userAgent:
//               "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 "
//               "(KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
//           useShouldOverrideUrlLoading: true,
//         ),

//         onWebViewCreated: (controller) {
//           _webViewController = controller;
//         },

//         // ── The mandate popup opens here ──────────────────────────────────────
//         // onCreateWindow: (controller, createWindowAction) async {
//         //   final newUrl = createWindowAction.request.url?.toString() ?? '';
//         //   debugPrint("[WebView] onCreateWindow: $newUrl");

//         //   // Load the popup URL inside the same WebView
//         //   await controller.loadUrl(urlRequest: URLRequest(url: WebUri(newUrl)));
//         //   return true;
//         // },
//         onCreateWindow: (controller, createWindowAction) async {
//           final newUrl = createWindowAction.request.url?.toString() ?? '';
//           debugPrint("[WebView] onCreateWindow: '$newUrl'");

//           // When bridge calls window.open(mandateUrl), the URL may arrive as null
//           // in the initial callback — fall back to widget.url directly
//           final targetUrl = newUrl.isNotEmpty ? newUrl : widget.url;

//           await controller.loadUrl(
//             urlRequest: URLRequest(url: WebUri(targetUrl)),
//           );
//           return true;
//         },

//         // ── Catch the final return URL ────────────────────────────────────────
//         shouldOverrideUrlLoading: (controller, navigationAction) async {
//           final url = navigationAction.request.url?.toString() ?? '';
//           debugPrint("[WebView] Redirecting to: $url");

//           // Final success return URL from MFU
//           if (url.contains("EPayeezDebitResHandler.do")) {
//             debugPrint("[WebView] ✅ SUCCESS URL caught");
//             _mandateSucceeded = true;
//             if (mounted) Get.back(result: 'success');
//             return NavigationActionPolicy.CANCEL;
//           }

//           // Handle UPI / intent:// external app links
//           final scheme = Uri.tryParse(url)?.scheme.toLowerCase() ?? '';
//           if (![
//             'http',
//             'https',
//             'about',
//             'data',
//             'javascript',
//           ].contains(scheme)) {
//             final uri = Uri.parse(url);
//             if (await canLaunchUrl(uri)) {
//               await launchUrl(uri, mode: LaunchMode.externalApplication);
//             }
//             return NavigationActionPolicy.CANCEL;
//           }

//           return NavigationActionPolicy.ALLOW;
//         },

//         // ── window.close() now works because page was opened via window.open()
//         onCloseWindow: (controller) {
//           debugPrint(
//             "[WebView] onCloseWindow fired. succeeded=$_mandateSucceeded",
//           );
//           if (!_mandateSucceeded && mounted) {
//             Get.back(result: 'check_status');
//           }
//         },

//         onConsoleMessage: (controller, msg) {
//           debugPrint("[WebView Console] ${msg.message}");
//         },

//         onReceivedError: (controller, request, error) {
//           debugPrint("[WebView] ERROR: ${error.description} | ${request.url}");
//         },

//         // Bypass SSL for UAT IP / test domain
//         onReceivedServerTrustAuthRequest: (controller, challenge) async {
//           return ServerTrustAuthResponse(
//             action: ServerTrustAuthResponseAction.PROCEED,
//           );
//         },

//         gestureRecognizers: {
//           Factory<VerticalDragGestureRecognizer>(
//             () => VerticalDragGestureRecognizer(),
//           ),
//           Factory<HorizontalDragGestureRecognizer>(
//             () => HorizontalDragGestureRecognizer(),
//           ),
//           Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
//           Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
//         },
//       ),
//     );
//   }
// }

// class _MandateWebViewState extends State<MandateWebView> {
//   InAppWebViewController? _webViewController;
//   bool hasAutoSubmitted = false;
//   bool _mandateSucceeded = false;

//   @override
//   void initState() {
//     super.initState();
//     _syncCookies();
//   }

//   // Ensures cookies persist across all redirect hops
//   Future<void> _syncCookies() async {
//     final cookieManager = CookieManager.instance();
//     await cookieManager.deleteAllCookies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Approve Mandate"),
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () => Get.back(result: 'cancelled'),
//         ),
//       ),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(url: WebUri(widget.url)),

//         // initialSettings: InAppWebViewSettings(
//         //   javaScriptEnabled: true,
//         //   domStorageEnabled: true,
//         //   databaseEnabled: true,
//         //   thirdPartyCookiesEnabled: true, // ← CRITICAL for bank session cookies
//         //   // Bank portals open auth pages via window.open()
//         //   supportMultipleWindows: true,
//         //   javaScriptCanOpenWindowsAutomatically: true,

//         //   // Prevents Android from blocking HTTP→HTTPS or HTTPS→HTTP hops
//         //   mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,

//         //   // Spoof as real Chrome so bank doesn't fingerprint as WebView and block
//         //   userAgent:
//         //       "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 "
//         //       "(KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",

//         //   useShouldOverrideUrlLoading: true,

//         //   // useOnCreateWindow: true, // ← Needed to handle window.open()
//         // ),
//         initialSettings: InAppWebViewSettings(
//           javaScriptEnabled: true,
//           domStorageEnabled: true, // Crucial for the bank's script
//           databaseEnabled: true, // Crucial for the bank's script
//           thirdPartyCookiesEnabled: true,
//           mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
//           safeBrowsingEnabled: false,
//           // allowVirtualNetwork: true,
//           supportMultipleWindows: false,
//           javaScriptCanOpenWindowsAutomatically:
//               true, // Let the bank script run automatically
//           useShouldOverrideUrlLoading: true,
//           userAgent:
//               "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
//         ),

//         onWebViewCreated: (controller) {
//           _webViewController = controller;
//         },

//         // ─── FIX 1: Handle bank portals that open in a new window ──────────────
//         onCreateWindow: (controller, createWindowAction) async {
//           final newUrl = createWindowAction.request.url;
//           debugPrint("[WebView] onCreateWindow: $newUrl");

//           if (newUrl != null) {
//             // Load the new-window URL inside our existing WebView
//             // instead of silently dropping it
//             await controller.loadUrl(urlRequest: URLRequest(url: newUrl));
//             return true; // We handled it
//           }
//           return false;
//         },

//         // ─── FIX 2: Auto-submit hidden BillDesk form ────────────────────────────
//         // onLoadStop: (controller, url) async {
//         //   final currentUrl = url.toString();
//         //   debugPrint("[WebView] onLoadStop: $currentUrl");

//         //   if (currentUrl.contains("callEPayeezzConfirm.do") &&
//         //       !hasAutoSubmitted) {
//         //     hasAutoSubmitted = true;
//         //     debugPrint("[WebView] Auto-submitting BillDesk hidden form...");
//         //     await controller.evaluateJavascript(
//         //       source: """
//         //         (function() {
//         //           try {
//         //             var forms = document.forms;
//         //             if (forms.length > 0) {
//         //               console.log('Form action: ' + forms[0].action);
//         //               forms[0].submit();
//         //             } else {
//         //               console.log('No forms found on page');
//         //             }
//         //           } catch(e) {
//         //             console.log('Submit error: ' + e);
//         //           }
//         //         })();
//         //       """,
//         //     );
//         //   }

//         //   // Fallback success catch
//         //   _checkForFinalUrl(currentUrl);
//         // },
//         onLoadStop: (controller, url) async {
//           final String currentUrl = url.toString();
//           debugPrint("Page Finished Loading: $currentUrl");

//           // WE DELETED THE JS INJECTION HERE!
//           // We are letting the bank's page do its own automatic redirect.

//           // Catch your return URL just in case
//           if (currentUrl.contains("EPayeezDebitResHandler.do")) {
//             if (currentUrl.toLowerCase().contains("reject") ||
//                 currentUrl.toLowerCase().contains("fail")) {
//               Get.back(result: 'failed');
//             } else {
//               Get.back(result: 'success');
//             }
//           }
//         },

//         // ─── FIX 3: Intercept redirects — handle intent://, upi://, and result URLs
//         // shouldOverrideUrlLoading: (controller, navigationAction) async {
//         //   final uri = navigationAction.request.url;
//         //   if (uri == null) return NavigationActionPolicy.ALLOW;

//         //   final urlString = uri.toString();
//         //   final scheme = uri.scheme.toLowerCase();
//         //   debugPrint("[WebView] shouldOverrideUrlLoading: $urlString");

//         //   // 3a. Let POST requests pass through untouched
//         //   //     Intercepting a POST drops its body, killing the transaction
//         //   final method = navigationAction.request.method ?? 'GET';
//         //   if (method.toUpperCase() == 'POST') {
//         //     debugPrint(
//         //       "[WebView] POST request — allowing without interception",
//         //     );
//         //     return NavigationActionPolicy.ALLOW;
//         //   }

//         //   // 3b. Handle intent:// and other app-scheme URLs (UPI, PhonePe, GPay)
//         //   if (![
//         //     'http',
//         //     'https',
//         //     'about',
//         //     'data',
//         //     'javascript',
//         //   ].contains(scheme)) {
//         //     debugPrint("[WebView] External scheme detected: $scheme");
//         //     try {
//         //       if (await canLaunchUrl(uri)) {
//         //         await launchUrl(uri, mode: LaunchMode.externalApplication);
//         //       } else {
//         //         Get.snackbar(
//         //           'App Not Found',
//         //           'Please install a UPI app to proceed.',
//         //         );
//         //       }
//         //     } catch (e) {
//         //       debugPrint("[WebView] Could not launch external URL: $e");
//         //     }
//         //     return NavigationActionPolicy.CANCEL;
//         //   }

//         //   // 3c. Check for final result URLs
//         //   if (_checkForFinalUrl(urlString)) {
//         //     return NavigationActionPolicy.CANCEL;
//         //   }

//         //   return NavigationActionPolicy.ALLOW;
//         // },
//         shouldOverrideUrlLoading: (controller, navigationAction) async {
//           var urlString = navigationAction.request.url.toString();
//           debugPrint("Redirecting to: $urlString");

//           // 1. Catch the Finish Line (EPayeezDebitResHandler.do)
//           if (urlString.contains("EPayeezDebitResHandler.do")) {
//             // Check if the URL contains a failure/reject code from BillDesk
//             // (e.g., you might see ?status=reject or ?err=F03 in the console)
//             if (urlString.toLowerCase().contains("reject") ||
//                 urlString.toLowerCase().contains("fail") ||
//                 urlString.toLowerCase().contains("error")) {
//               debugPrint("TRANSACTION REJECTED. Closing WebView.");
//               Get.back(result: 'failed');
//             } else {
//               debugPrint("TRANSACTION SUCCESSFUL. Closing WebView.");
//               Get.back(result: 'success');
//             }

//             return NavigationActionPolicy.CANCEL;
//           }

//           return NavigationActionPolicy.ALLOW;
//         },

//         // ─── Catch silent redirects (more reliable than onLoadStop for JS redirects)
//         onUpdateVisitedHistory: (controller, url, androidIsReload) {
//           final urlString = url.toString();
//           debugPrint("[WebView] onUpdateVisitedHistory: $urlString");
//           _checkForFinalUrl(urlString);
//         },

//         onCloseWindow: (controller) {
//           debugPrint("[WebView] Bank called window.close()");
//           if (_mandateSucceeded) {
//             // window.close() fired AFTER success URL — already handled, ignore
//             return;
//           }
//           // window.close() fired without a success URL = user cancelled or bank closed early
//           Get.back(result: 'cancelled');
//         },

//         onReceivedError: (controller, request, error) {
//           debugPrint(
//             "[WebView] ERROR: ${error.description} | URL: ${request.url}",
//           );
//         },

//         // ─── Bypass SSL for UAT/test environments only ──────────────────────────
//         onReceivedServerTrustAuthRequest: (controller, challenge) async {
//           debugPrint(
//             "[WebView] SSL challenge from: ${challenge.protectionSpace.host}",
//           );
//           return ServerTrustAuthResponse(
//             action: ServerTrustAuthResponseAction.PROCEED,
//           );
//         },

//         gestureRecognizers: {
//           Factory<VerticalDragGestureRecognizer>(
//             () => VerticalDragGestureRecognizer(),
//           ),
//           Factory<HorizontalDragGestureRecognizer>(
//             () => HorizontalDragGestureRecognizer(),
//           ),
//           Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
//           Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
//         },
//       ),
//     );
//   }

//   /// Returns true (and calls Get.back) if the URL is a final result URL.
//   // bool _checkForFinalUrl(String url) {
//   //   if (url.contains("EPayeezDebitResHandler.do")) {
//   //     debugPrint("[WebView] ✅ SUCCESS URL detected");
//   //     if (mounted) Get.back(result: 'success');
//   //     return true;
//   //   }
//   //   if (url.contains("mandate-failure") ||
//   //       url.contains("mandate-cancel") ||
//   //       url.contains("EPayeezDebitFailHandler.do")) {
//   //     debugPrint("[WebView] ❌ FAILURE URL detected");
//   //     if (mounted) Get.back(result: 'failed');
//   //     return true;
//   //   }
//   //   return false;
//   // }
//   bool _checkForFinalUrl(String url) {
//     if (url.contains("EPayeezDebitResHandler.do")) {
//       debugPrint("[WebView] ✅ SUCCESS URL detected");
//       _mandateSucceeded = true; // ← mark success
//       if (mounted) Get.back(result: 'success');
//       return true;
//     }
//     if (url.contains("EPayeezDebitFailHandler.do")) {
//       debugPrint("[WebView] ❌ FAILURE URL detected");
//       if (mounted) Get.back(result: 'failed');
//       return true;
//     }
//     return false;
//   }
// }

// class MandateWebView extends StatefulWidget {
//   final String url;

//   const MandateWebView({super.key, required this.url});

//   @override
//   State<MandateWebView> createState() => _MandateWebViewState();
// }

// class _MandateWebViewState extends State<MandateWebView> {
//   bool hasAutoSubmitted = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Approve Mandate")),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(url: WebUri(widget.url)),

//         gestureRecognizers: {
//           Factory<VerticalDragGestureRecognizer>(
//             () => VerticalDragGestureRecognizer(),
//           ),
//           Factory<HorizontalDragGestureRecognizer>(
//             () => HorizontalDragGestureRecognizer(),
//           ),
//           Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()),
//           Factory<TapGestureRecognizer>(() => TapGestureRecognizer()),
//         },

//         // initialSettings: InAppWebViewSettings(
//         //   javaScriptEnabled: true,
//         //   domStorageEnabled: true,
//         //   thirdPartyCookiesEnabled: true,

//         //   // --- THE FIX ---
//         //   // Force BillDesk to use the single-window redirect flow instead of popups
//         //   supportMultipleWindows: false,
//         //   javaScriptCanOpenWindowsAutomatically: false,
//         //   useShouldOverrideUrlLoading: true, // Allows us to catch redirects

//         //   userAgent:
//         //       "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",
//         // ),
//         initialSettings: InAppWebViewSettings(
//           javaScriptEnabled: true,
//           domStorageEnabled:
//               true, // REQUIRED: The form needs this to store session data
//           databaseEnabled: true,
//           supportZoom: true,
//           displayZoomControls: false,

//           safeBrowsingEnabled: false,

//           // High-priority: BillDesk and NPCI often use hidden forms
//           javaScriptCanOpenWindowsAutomatically: true,

//           // IMPORTANT: Some gateways check for 'headless' or 'webview'
//           // and stop the redirect. Use a high-quality User Agent.
//           userAgent:
//               "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36",

//           // Mixed Content is the #1 killer of redirects in India.
//           // If BillDesk tries to move from HTTPS to HTTP, Android will block it without this.
//           mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,

//           // Allow cross-origin requests for the .do redirect
//           allowUniversalAccessFromFileURLs: true,
//           allowFileAccessFromFileURLs: true,
//         ),

//         // onLoadStop: (controller, url) async {
//         //   String currentUrl = url.toString();
//         //   debugPrint("Current Page: $currentUrl");

//         //   // If the page stops on the .do link and stays blank,
//         //   // it means the auto-submit JS failed. We can force it:
//         //   if (currentUrl.contains("callEPayeezzConfirm.do")) {
//         //     await controller.evaluateJavascript(
//         //       source: "document.forms[0].submit();",
//         //     );
//         //   }

//         //   // Check if we finally landed back at BillDesk or your Success page
//         //   if (currentUrl.contains("billdesk.com") ||
//         //       currentUrl.contains("your-success-url")) {
//         //     // Handle success logic
//         //   }
//         // },
//         onCloseWindow: (controller) {
//           debugPrint("Bank tried to close the window. Force returning to app.");
//           // If the bank gives up, return failed so the app doesn't stay stuck
//           Get.back(result: 'failed');
//         },
//         onReceivedError: (controller, request, error) {
//           // If the redirect still fails, this will print exactly which URL is broken
//           debugPrint(
//             "CRITICAL WEBVIEW ERROR: ${error.description} on URL: ${request.url}",
//           );
//         },
//         // onLoadStop: (controller, url) async {
//         //   final String currentUrl = url.toString();
//         //   debugPrint("Page Finished Loading: $currentUrl");

//         //   if (currentUrl.contains("callEPayeezzConfirm.do")) {
//         //     // Only submit if we haven't done it yet!
//         //     if (!hasAutoSubmitted) {
//         //       hasAutoSubmitted = true;
//         //       debugPrint("Attempting JS Auto-Submit...");
//         //       await controller.evaluateJavascript(
//         //         source: """
//         //           try {
//         //             if (document.forms.length > 0) {
//         //               document.forms[0].submit();
//         //             }
//         //           } catch(e) {
//         //             console.log('Submit error: ' + e);
//         //           }
//         //         """,
//         //       );
//         //     } else {
//         //       debugPrint("Already attempted submit. Waiting for redirect...");
//         //     }
//         //   }

//         //   // Catch your success/failure URLs here
//         //   if (currentUrl.contains("your-success-url.com")) {
//         //     Get.back(result: 'success');
//         //   } else if (currentUrl.contains("your-failure-url.com")) {
//         //     Get.back(result: 'failed');
//         //   }
//         // },
//         // onLoadStop: (controller, url) async {
//         //   final String currentUrl = url.toString();
//         //   debugPrint("Page Finished Loading: $currentUrl");

//         //   if (currentUrl.contains("callEPayeezzConfirm.do")) {
//         //     if (!hasAutoSubmitted) {
//         //       hasAutoSubmitted = true;
//         //       debugPrint("Spying on the hidden form...");

//         //       // Inject JS to print the form details before submitting
//         //       await controller.evaluateJavascript(
//         //         source: """
//         //           try {
//         //             if (document.forms.length > 0) {
//         //               var form = document.forms[0];
//         //               console.log('TARGET URL: ' + form.action);
//         //               console.log('TARGET METHOD: ' + form.method);
//         //               form.submit();
//         //             } else {
//         //               console.log('ERROR: No hidden form found on this page!');
//         //             }
//         //           } catch(e) {
//         //             console.log('JS Submit Error: ' + e);
//         //           }
//         //         """,
//         //       );
//         //     }
//         //   }

//         //   if (currentUrl.contains("your-success-url.com")) {
//         //     Get.back(result: 'success');
//         //   } else if (currentUrl.contains("your-failure-url.com")) {
//         //     Get.back(result: 'failed');
//         //   }
//         // },
//         onLoadStop: (controller, url) async {
//           final String currentUrl = url.toString();

//           if (currentUrl.contains("callEPayeezzConfirm.do")) {
//             if (!hasAutoSubmitted) {
//               hasAutoSubmitted = true;
//               debugPrint("Attempting JS Auto-Submit to BillDesk...");

//               // Force the hidden form to submit its giant message to BillDesk
//               await controller.evaluateJavascript(
//                 source: """
//                   try {
//                     if (document.forms.length > 0) {
//                       document.forms[0].submit();
//                     }
//                   } catch(e) {
//                     console.log('JS Submit Error: ' + e);
//                   }
//                 """,
//               );
//             }
//           }

//           // Fallback catch just in case shouldOverrideUrlLoading misses it
//           if (currentUrl.contains("EPayeezDebitResHandler.do")) {
//             Get.back(result: 'success');
//           }
//         },

//         onUpdateVisitedHistory: (controller, url, androidIsReload) {
//           // This is often more reliable than onLoadStop for silent redirects
//           debugPrint("Redirected to: ${url.toString()}");
//         },

//         // --- CATCH THE REDIRECTS HERE ---
//         // shouldOverrideUrlLoading: (controller, navigationAction) async {
//         //   var uri = navigationAction.request.url!;
//         //   var urlString = uri.toString();

//         //   // Print this to your console so you can watch the redirects happen
//         //   debugPrint("WebView Redirecting to: $urlString");

//         //   // 1. Check for external UPI apps (GPay, PhonePe, etc.)
//         //   var scheme = uri.scheme.toLowerCase();
//         //   if (!['http', 'https', 'about', 'data'].contains(scheme)) {
//         //     if (await canLaunchUrl(uri)) {
//         //       await launchUrl(uri, mode: LaunchMode.externalApplication);
//         //       return NavigationActionPolicy.CANCEL;
//         //     }
//         //   }

//         //   // 2. Intercept your final Return URL
//         //   // Change "your-success-url.com" to the actual Return URL (ru) your backend sends to BillDesk
//         //   if (urlString.contains("your-success-url.com")) {
//         //     Get.back(result: 'success');
//         //     return NavigationActionPolicy.CANCEL;
//         //   }
//         //   if (urlString.contains("your-failure-url.com")) {
//         //     Get.back(result: 'failed');
//         //     return NavigationActionPolicy.CANCEL;
//         //   }

//         //   return NavigationActionPolicy.ALLOW;
//         // },
//         // shouldOverrideUrlLoading: (controller, navigationAction) async {
//         //   var urlString = navigationAction.request.url.toString();
//         //   debugPrint("Redirecting to: $urlString");

//         //   // THIS IS THE FINISH LINE!
//         //   if (urlString.contains("EPayeezDebitResHandler.do")) {
//         //     debugPrint("SUCCESS URL DETECTED! Closing WebView.");
//         //     Get.back(result: 'success');
//         //     return NavigationActionPolicy
//         //         .CANCEL; // Stop the webview from loading it
//         //   }

//         //   return NavigationActionPolicy.ALLOW;
//         // },
//         shouldOverrideUrlLoading: (controller, navigationAction) async {
//           var urlString = navigationAction.request.url.toString();
//           debugPrint("Redirecting to: $urlString");

//           // 1. Catch the Finish Line (EPayeezDebitResHandler.do)
//           if (urlString.contains("EPayeezDebitResHandler.do")) {
//             // Check if the URL contains a failure/reject code from BillDesk
//             // (e.g., you might see ?status=reject or ?err=F03 in the console)
//             if (urlString.toLowerCase().contains("reject") ||
//                 urlString.toLowerCase().contains("fail") ||
//                 urlString.toLowerCase().contains("error")) {
//               debugPrint("TRANSACTION REJECTED. Closing WebView.");
//               Get.back(result: 'failed');
//             } else {
//               debugPrint("TRANSACTION SUCCESSFUL. Closing WebView.");
//               Get.back(result: 'success');
//             }

//             return NavigationActionPolicy.CANCEL;
//           }

//           return NavigationActionPolicy.ALLOW;
//         },

//         // Bypass SSL ONLY for your testing IP address
//         // onReceivedServerTrustAuthRequest: (controller, challenge) async {
//         //   return ServerTrustAuthResponse(
//         //     action: ServerTrustAuthResponseAction.PROCEED,
//         //   );
//         // },
//         onReceivedServerTrustAuthRequest: (controller, challenge) async {
//           debugPrint("Bypassing SSL for: ${challenge.protectionSpace.host}");
//           // This forces Android to ignore the net_error -200 on ALL domains during testing
//           return ServerTrustAuthResponse(
//             action: ServerTrustAuthResponseAction.PROCEED,
//           );
//         },
//       ),
//     );
//   }
// }

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
