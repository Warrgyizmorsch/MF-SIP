import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlWebViewPage extends StatefulWidget {
  final String title;
  final String? htmlContent;
  final String? url;
  final String? successUrlTrigger;

  const HtmlWebViewPage({
    super.key,
    this.title = '',
    this.htmlContent,
    this.url,
    this.successUrlTrigger = "signzy",
  }) : assert(
         htmlContent != null || url != null,
         'Either htmlContent or url must be provided',
       );

  @override
  State<HtmlWebViewPage> createState() => _HtmlWebViewPageState();
}

class _HtmlWebViewPageState extends State<HtmlWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true; // Loader state

  @override
  void initState() {
    super.initState();





    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
          NavigationDelegate(
    onPageStarted: (url) {
    setState(() => _isLoading = true);
    },
    onPageFinished: (url) {
    setState(() => _isLoading = false);
    },
            onNavigationRequest: (NavigationRequest request) async {
              final url = request.url;

              // 1. INCORRECT (Causes immediate close):
              // if (url.contains("digilocker-auth-complete")) { ... }
              // ^ This finds the text inside the query parameter of the first URL!

              // 2. CORRECT FIX:
              // Only close if the ACTUAL PAGE is the Signzy redirect page.
              // The starting URL starts with "api.digitallocker.gov.in", so this will be false initially.
              if (url.startsWith("https://digilocker-preproduction.signzy.tech/success")) {
                if (mounted) {
                // final result = await  showDialog(context: context, builder: (context){
                //     return AlertDialog(
                //       title: Text("Verification Complete"),
                //       actions: [
                //         TextButton(onPressed: (){
                //           Get.back(result: true);
                //         }, child: Text("OK"))
                //       ],
                //
                //     );
                //   });
                //
                // if(result == true){
                //   Get.back(result: true);
                // }
                Get.back(result: true);
                }
                return NavigationDecision.prevent;
              }

              // Optional: Handle user clicking "Cancel" or "Deny" inside DigiLocker
              if (url.contains("access_denied") || url.contains("error")) {
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
          )

      );

    if (widget.url != null && widget.url!.isNotEmpty) {
      _controller.loadRequest(Uri.parse(widget.url!));
    } else if (widget.htmlContent != null) {
      final unescape = HtmlUnescape();

      // Decode twice to handle double-escaped HTML
      String decodedHtmlContent = widget.htmlContent!;
      decodedHtmlContent = unescape.convert(decodedHtmlContent);
      decodedHtmlContent = unescape.convert(decodedHtmlContent);

      // Wrap with full HTML for reliable rendering
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: -10.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.title,
          textAlign: TextAlign.start,
          style: AppTextStyles.h3(color: Ucolors.dark),
        ),
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 1000),
            opacity: _isLoading ? 0 : 1,
            child: WebViewWidget(controller: _controller),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
