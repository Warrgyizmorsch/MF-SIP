// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;

// void pushWebPath(String path) {
//   final normalizedPath = path.startsWith('/') ? path : '/$path';

//   if ((html.window.location.pathname ?? '') +
//       (html.window.location.search ?? '') !=
//       normalizedPath) {
//     html.window.history.pushState(null, '', normalizedPath);
//   }
// }

// String currentWebPath() {
//   return '${html.window.location.pathname}${html.window.location.search}';
// }

// void listenWebBack(void Function(String path) onChanged) {
//   html.window.onPopState.listen((event) {
//     onChanged('${html.window.location.pathname}${html.window.location.search}');
//   });
// }

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

String _normalizePath(String path) {
  return path.startsWith('/') ? path : '/$path';
}

void pushWebPath(String path) {
  final normalizedPath = _normalizePath(path);

  final currentPath =
      '${html.window.location.pathname}${html.window.location.search}';

  if (currentPath != normalizedPath) {
    html.window.history.pushState(null, '', normalizedPath);
  }
}

void replaceWebPath(String path) {
  final normalizedPath = _normalizePath(path);

  final currentPath =
      '${html.window.location.pathname}${html.window.location.search}';

  if (currentPath != normalizedPath) {
    html.window.history.replaceState(null, '', normalizedPath);
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

void browserHistoryBack() {
  html.window.history.back();
}
