// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:html_unescape/html_unescape.dart';
// import 'package:my_sip/core/utils/constant/colors.dart';
// import 'package:my_sip/core/utils/constant/text_style.dart';
// import 'package:my_sip/core/utils/helper/helpers.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class HtmlWebViewPage extends StatefulWidget {
//   final String title;
//   final String? htmlContent;
//   final String? url;
//   final String? successUrlTrigger;

//   const HtmlWebViewPage({
//     super.key,
//     this.title = '',
//     this.htmlContent,
//     this.url,
//     this.successUrlTrigger = "signzy",
//   }) : assert(
//          htmlContent != null || url != null,
//          'Either htmlContent or url must be provided',
//        );

//   @override
//   State<HtmlWebViewPage> createState() => _HtmlWebViewPageState();
// }

// class _HtmlWebViewPageState extends State<HtmlWebViewPage> {
//   late final WebViewController _controller;
//   bool _isLoading = true; // Loader state
//   bool result = false;

//   @override
//   void initState() {
//     super.initState();

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (url) {
//             setState(() => _isLoading = true);
//           },
//           onPageFinished: (url) {
//             setState(() => _isLoading = false);
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             final url = request.url;
//             final successBaseUrl =
//                 "https://digilocker-preproduction.signzy.tech/digilocker-auth-complete";
//             final esignSuccessUrl = "https://signzy.com";

//             // 1. SUCCESS CHECK
//             if (url.startsWith(successBaseUrl) ||
//                 url.startsWith(esignSuccessUrl)) {
//               // Set result to true and show the loading spinner
//               setState(() {
//                 result = true;
//                 _isLoading = true;
//               });

//               // Mimic the "Human Delay": Wait 3.5 seconds, then auto-close
//               Future.delayed(const Duration(milliseconds: 3500), () {
//                 if (mounted) {
//                   Get.back(result: true);
//                 }
//               });

//               // CRITICAL: Let the URL load so Signzy gets the code!
//               return NavigationDecision.navigate;
//             }

//             // 2. FAILURE CHECK
//             if (url.contains("error=access_denied") ||
//                 url.contains("user_cancelled")) {
//               if (mounted) {
//                 Get.back(result: false);
//               }
//               return NavigationDecision.prevent;
//             }

//             return NavigationDecision.navigate;
//           },
//           // onNavigationRequest: (NavigationRequest request) {
//           //   final url = request.url;

//           //   // 1. DEFINED SUCCESS URL (The base part)
//           //   // We only care if the actual loaded page is this one.
//           //   final successBaseUrl =
//           //       "https://digilocker-preproduction.signzy.tech/digilocker-auth-complete";
//           //   // 2. CHECK: Does the current navigation START with the success URL?
//           //   // This fails for the initial "api.digitallocker.gov.in" URL (Correct!)
//           //   // This passes ONLY when the flow redirects to "signzy.tech/..." (Correct!)

//           //   // 2. AADHAAR E-SIGN SUCCESS URL (From your KycController payload)
//           //   final esignSuccessUrl = "https://signzy.com";
//           //   if (url.startsWith(successBaseUrl) ||
//           //       url.startsWith(esignSuccessUrl)) {
//           //     setState(() => _isLoading = true);

//           //     // // Success! The user has been redirected.
//           //     // if (mounted) {
//           //     //   Get.back(result: true);
//           //     // }
//           //     setState(() => result = true);
//           //     // createLog("Success caled ${result}");
//           //     createLog("Success called $result for URL: $url");

//           //     // return NavigationDecision.prevent; // Stop loading the JSON/Success page
//           //   }

//           //   // 3. Optional: Check for failures (denied, cancelled)
//           //   if (url.contains("access_denied") || url.contains("error")) {
//           //     if (mounted) {
//           //       Get.back(result: false);
//           //     }
//           //     return NavigationDecision.prevent;
//           //   }

//           //   // Allow normal navigation (clicking buttons, logging in)
//           //   return NavigationDecision.navigate;
//           // },

//           // onNavigationRequest: (NavigationRequest request) {
//           //   final url = request.url;

//           //   // 1. DEFINED SUCCESS URL (The base part)
//           //   // We only care if the actual loaded page is this one.
//           //   final successBaseUrl =
//           //       "https://digilocker-preproduction.signzy.tech/digilocker-auth-complete";
//           //   // 2. CHECK: Does the current navigation START with the success URL?
//           //   // This fails for the initial "api.digitallocker.gov.in" URL (Correct!)
//           //   // This passes ONLY when the flow redirects to "signzy.tech/..." (Correct!)

//           //   // 2. AADHAAR E-SIGN SUCCESS URL (From your KycController payload)
//           //   final esignSuccessUrl = "https://signzy.com";
//           //   if (url.startsWith(successBaseUrl) ||
//           //       url.startsWith(esignSuccessUrl)) {
//           //     setState(() => _isLoading = true);

//           //     // // Success! The user has been redirected.
//           //     // if (mounted) {
//           //     //   Get.back(result: true);
//           //     // }
//           //     setState(() => result = true);
//           //     // createLog("Success caled ${result}");
//           //     createLog("Success called $result for URL: $url");

//           //     // return NavigationDecision.prevent; // Stop loading the JSON/Success page
//           //   }

//           //   // 3. Optional: Check for failures (denied, cancelled)
//           //   if (url.contains("access_denied") || url.contains("error")) {
//           //     if (mounted) {
//           //       Get.back(result: false);
//           //     }
//           //     return NavigationDecision.prevent;
//           //   }

//           //   // Allow normal navigation (clicking buttons, logging in)
//           //   return NavigationDecision.navigate;
//           // },
//           onWebResourceError: (error) {
//             setState(() {
//               _isLoading = false;
//             });
//           },
//         ),
//       );

//     if (widget.url != null && widget.url!.isNotEmpty) {
//       _controller.loadRequest(Uri.parse(widget.url!));
//     } else if (widget.htmlContent != null) {
//       final unescape = HtmlUnescape();

//       // Decode twice to handle double-escaped HTML
//       String decodedHtmlContent = widget.htmlContent!;
//       decodedHtmlContent = unescape.convert(decodedHtmlContent);
//       decodedHtmlContent = unescape.convert(decodedHtmlContent);

//       // Wrap with full HTML for reliable rendering
//       final wrappedHtml =
//           """
//     <!DOCTYPE html>
//     <html lang="en">
//       <head>
//         <meta charset="UTF-8">
//         <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
//         <style>
//           @font-face {
//             font-family: 'PanagramMedium';
//             src: url('file:///android_asset/fonts/PanagramMedium.ttf') format('truetype');
//           }
//           body {
//             margin: 0;
//             padding: 12px;
//             font-size: 14px;
//             color: #333;
//             font-family: 'PanagramMedium', sans-serif;
//             -webkit-tap-highlight-color: transparent;
//           }

//           /* HEADER STYLING */
//           .acc_head {
//             cursor: pointer;
//             padding: 15px 0;
//             font-weight: bold;
//             display: flex;
//             align-items: center;
//             border-bottom: 1px solid #f0f0f0; /* Subtle separator */
//           }

//           /* --- PLUS/MINUS ICON STYLING --- */
//           .acc_icon_expand {
//               width: 20px;
//               height: 20px;
//               position: relative; /* Needed for centering lines */
//               margin-right: 15px;
//               flex-shrink: 0; /* Prevents icon from squishing on small screens */
//           }

//           /* Draw the lines using pseudo-elements */
//           .acc_icon_expand::before, .acc_icon_expand::after {
//               content: '';
//               position: absolute;
//               background-color: #333; /* Color of the Plus sign */
//               top: 50%;
//               left: 50%;
//               transform: translate(-50%, -50%);
//               transition: transform 0.3s ease; /* Smooth animation */
//           }

//           /* Horizontal line */
//           .acc_icon_expand::before {
//               width: 12px;
//               height: 2px;
//           }

//           /* Vertical line */
//           .acc_icon_expand::after {
//               width: 2px;
//               height: 12px;
//           }

//           /* ACTIVE STATE: Turn Plus into Minus */
//           /* We rotate the vertical line 90deg so it lays flat over the horizontal line */
//           .acc_head.active .acc_icon_expand::after {
//               transform: translate(-50%, -50%) rotate(90deg);
//           }
//           /* ----------------------------------- */

//           .acc_content {
//              display: none; /* Hidden by default */
//              padding: 10px 0 20px 35px; /* Indent content to align with text */
//              color: #555;
//              line-height: 1.6;
//           }

//           img { max-width: 100%; height: auto; }
//           ul, li, p { margin: 0 0 10px 0; }
//         </style>
//       </head>
//       <body>
//         $decodedHtmlContent

//         <script>
//           document.addEventListener("DOMContentLoaded", function () {
//             const headers = document.querySelectorAll(".acc_head");

//             headers.forEach(function (head) {
//               head.addEventListener("click", function () {

//                 // 1. Toggle 'active' class to trigger CSS animation (+ to -)
//                 this.classList.toggle("active");

//                 // 2. Find the content div immediately following the header
//                 const content = this.nextElementSibling;

//                 // 3. Toggle visibility
//                 if (content && content.classList.contains("acc_content")) {
//                   if (content.style.display === "block") {
//                     content.style.display = "none";
//                   } else {
//                     content.style.display = "block";
//                   }
//                 }
//               });
//             });
//           });
//         </script>
//       </body>
//     </html>
//     """;

//       // Load as proper UTF-8 encoded data URI
//       _controller.loadRequest(
//         Uri.dataFromString(
//           wrappedHtml,
//           mimeType: 'text/html',
//           parameters: {'charset': 'utf-8'},
//           encoding: utf8,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false, // Intercept the physical back button
//       onPopInvoked: (bool didPop) {
//         if (didPop) return;

//         // Trigger the exact same logic as your AppBar back button
//         createLog("Success Result $result");
//         Get.back(result: result);
//       },

//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               createLog("Success Result ${result}");

//               Get.back(result: result);
//             },
//             icon: Icon(Icons.arrow_back_ios),
//           ),
//           titleSpacing: -10.0,
//           backgroundColor: Colors.white,
//           centerTitle: true,
//           title: Text(
//             widget.title,
//             textAlign: TextAlign.start,
//             style: AppTextStyles.h3(color: Ucolors.dark),
//           ),
//         ),
//         body: SafeArea(
//           bottom: true,
//           child: Stack(
//             children: [
//               AnimatedOpacity(
//                 duration: const Duration(milliseconds: 1000),
//                 opacity: _isLoading ? 0 : 1,
//                 child: WebViewWidget(controller: _controller),
//               ),
//               if (_isLoading) const Center(child: CircularProgressIndicator()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/foundation.dart'; // 🚀 ADDED: for kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/core/utils/helper/helpers.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlWebViewPage extends StatefulWidget {
  final String title;
  final String? htmlContent;
  final String? url;
  final String? successUrlTrigger;
  final bool appBar;

  static Map<String, String>? navData;

  const HtmlWebViewPage({
    super.key,
    this.appBar = true,
    this.title = '',
    this.htmlContent,
    this.url,
    this.successUrlTrigger = "signzy",
    th,
  });
  // : assert(
  //        htmlContent != null || url != null,
  //        'Either htmlContent or url must be provided',
  //      );

  @override
  State<HtmlWebViewPage> createState() => _HtmlWebViewPageState();
}

class _HtmlWebViewPageState extends State<HtmlWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true; // Loader state
  bool result = false;

  late String finalTitle;
  late String? finalUrl;
  late String? finalHtmlContent;

  bool finalAppBar = true;

  @override
  void initState() {
    super.initState();

    if (HtmlWebViewPage.navData != null &&
        HtmlWebViewPage.navData!['appBar'] == 'false') {
      finalAppBar = false;
    } else {
      finalAppBar = widget.appBar;
    }

    finalTitle =
        HtmlWebViewPage.navData?['title'] ??
        (widget.title.isNotEmpty ? widget.title : null) ??
        Get.arguments?['title'] ??
        '';

    finalUrl =
        HtmlWebViewPage.navData?['url'] ?? widget.url ?? Get.arguments?['url'];
    finalHtmlContent = widget.htmlContent ?? Get.arguments?['htmlContent'];

    // 2. Data reset karo
    HtmlWebViewPage.navData = null;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    if (!kIsWeb) {
      _controller.setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
          // onNavigationRequest: (NavigationRequest request) {
          //   final url = request.url.toLowerCase();

          //   // 🔴 1. DIGILOCKER SUCCESS CHECK (Updated for the new Prod URL)
          //   bool isDigiLockerSuccess =
          //       url.contains("digilocker-auth-complete") ||
          //       (url.contains("signzy") && url.endsWith("/success"));

          //   // 🔴 2. E-SIGN SUCCESS CHECK
          //   bool isEsignSuccess =
          //       url.startsWith("https://signzy.com") ||
          //       url.startsWith("http://signzy.com");

          //   if (isDigiLockerSuccess || isEsignSuccess) {
          //     // Set result to true and show the loading spinner
          //     setState(() {
          //       result = true;
          //       _isLoading = true;
          //     });

          //     Future.delayed(const Duration(milliseconds: 3500), () {
          //       if (mounted) {
          //         Get.back(result: true);
          //       }
          //     });

          //     return NavigationDecision.navigate;
          //   }

          //   // 3. FAILURE CHECK
          //   if (url.contains("error=access_denied") ||
          //       url.contains("user_cancelled") ||
          //       url.contains("failure")) {
          //     if (mounted) {
          //       Get.back(result: false);
          //     }
          //     return NavigationDecision.prevent;
          //   }

          //   return NavigationDecision.navigate;
          // },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url.toLowerCase();
            final uri = Uri.parse(request.url);
            // final successBaseUrl =
            //     "https://digilocker-production.signzy.tech/digilocker-auth-complete";
            // final esignSuccessUrl = "https://signzy.com";
            bool isDigiLockerSuccess =
                uri.host.contains("signzy") &&
                (uri.path.contains("digilocker-auth-complete") ||
                    uri.path.endsWith("success"));

            // 2. E-SIGN SUCCESS CHECK
            bool isEsignSuccess =
                url.startsWith("https://signzy.com") ||
                url.startsWith("http://signzy.com");

            // 1. SUCCESS CHECK
            if (isEsignSuccess || isDigiLockerSuccess) {
              // Set result to true and show the loading spinner
              setState(() {
                result = true;
                _isLoading = true;
              });

              Future.delayed(const Duration(milliseconds: 3500), () {
                if (mounted) {
                  Get.back(result: true);
                }
              });

              return NavigationDecision.navigate;
            }

            // 2. FAILURE CHECK
            if (url.contains("error=access_denied") ||
                url.contains("user_cancelled")) {
              if (mounted) {
                Get.back(result: false);
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      );
    } else {
      _isLoading = false;
    }

    // if (widget.url != null && widget.url!.isNotEmpty) {
    //   _controller.loadRequest(Uri.parse(widget.url!));
    // }
    if (finalUrl != null && finalUrl!.isNotEmpty) {
      _controller.loadRequest(Uri.parse(finalUrl!));
    } else if (widget.htmlContent != null) {
      final unescape = HtmlUnescape();

      String decodedHtmlContent = widget.htmlContent!;
      decodedHtmlContent = unescape.convert(decodedHtmlContent);
      decodedHtmlContent = unescape.convert(decodedHtmlContent);

      final wrappedHtml =
          """
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <style>
          @font-face {
            font-family: 'PanagramMedium';
            src: url('file:///android_asset/fonts/PanagramMedium.ttf') format('truetype');
          }
          body {
            margin: 0;
            padding: 12px;
            font-size: 14px;
            color: #333;
            font-family: 'PanagramMedium', sans-serif;
            -webkit-tap-highlight-color: transparent;
          }
          
          /* HEADER STYLING */
          .acc_head {
            cursor: pointer;
            padding: 15px 0;
            font-weight: bold;
            display: flex;
            align-items: center;
            border-bottom: 1px solid #f0f0f0; /* Subtle separator */
          }
          
          /* --- PLUS/MINUS ICON STYLING --- */
          .acc_icon_expand {
              width: 20px;
              height: 20px;
              position: relative; /* Needed for centering lines */
              margin-right: 15px;
              flex-shrink: 0; /* Prevents icon from squishing on small screens */
          }

          /* Draw the lines using pseudo-elements */
          .acc_icon_expand::before, .acc_icon_expand::after {
              content: '';
              position: absolute;
              background-color: #333; /* Color of the Plus sign */
              top: 50%; 
              left: 50%;
              transform: translate(-50%, -50%);
              transition: transform 0.3s ease; /* Smooth animation */
          }

          /* Horizontal line */
          .acc_icon_expand::before { 
              width: 12px; 
              height: 2px; 
          }

          /* Vertical line */
          .acc_icon_expand::after { 
              width: 2px; 
              height: 12px; 
          }

          /* ACTIVE STATE: Turn Plus into Minus */
          /* We rotate the vertical line 90deg so it lays flat over the horizontal line */
          .acc_head.active .acc_icon_expand::after {
              transform: translate(-50%, -50%) rotate(90deg);
          }
          /* ----------------------------------- */

          .acc_content {
             display: none; /* Hidden by default */
             padding: 10px 0 20px 35px; /* Indent content to align with text */
             color: #555;
             line-height: 1.6;
          }

          img { max-width: 100%; height: auto; }
          ul, li, p { margin: 0 0 10px 0; }
        </style>
      </head>
      <body>
        $decodedHtmlContent
        
        <script>
          document.addEventListener("DOMContentLoaded", function () {
            const headers = document.querySelectorAll(".acc_head");
            
            headers.forEach(function (head) {
              head.addEventListener("click", function () {
                
                // 1. Toggle 'active' class to trigger CSS animation (+ to -)
                this.classList.toggle("active");

                // 2. Find the content div immediately following the header
                const content = this.nextElementSibling;

                // 3. Toggle visibility
                if (content && content.classList.contains("acc_content")) {
                  if (content.style.display === "block") {
                    content.style.display = "none";
                  } else {
                    content.style.display = "block";
                  }
                }
              });
            });
          });
        </script>
      </body>
    </html>
    """;

      // Load as proper UTF-8 encoded data URI
      _controller.loadRequest(
        Uri.dataFromString(
          wrappedHtml,
          mimeType: 'text/html',
          parameters: {'charset': 'utf-8'},
          encoding: utf8,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Intercept the physical back button
      onPopInvoked: (bool didPop) {
        if (didPop) return;

        // Trigger the exact same logic as your AppBar back button
        createLog("Success Result $result");
        Get.back(result: result);
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: !finalAppBar
            ? null
            : AppBar(
                leading: IconButton(
                  onPressed: () {
                    createLog("Success Result ${result}");

                    Get.back(result: result);
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
                titleSpacing: -10.0,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  // widget.title,
                  finalTitle,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.h3(color: Ucolors.dark),
                ),
              ),
        body: SafeArea(
          bottom: true,
          child: Stack(
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: _isLoading && !kIsWeb
                    ? 0
                    : 1, // 🚀 FIX: Prevent hiding webview on Web
                child: WebViewWidget(controller: _controller),
              ),
              if (_isLoading && !kIsWeb)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
