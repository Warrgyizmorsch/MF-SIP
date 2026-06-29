// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void pushWebPath(String path) {
  final normalizedPath = path.startsWith('/') ? path : '/$path';

  if ((html.window.location.pathname ?? '') +
      (html.window.location.search ?? '') !=
      normalizedPath) {
    html.window.history.pushState(null, '', normalizedPath);
  }
}

String currentWebPath() {
  return '${html.window.location.pathname}${html.window.location.search}';
}

void listenWebBack(void Function(String path) onChanged) {
  html.window.onPopState.listen((event) {
    onChanged('${html.window.location.pathname}${html.window.location.search}');
  });
}