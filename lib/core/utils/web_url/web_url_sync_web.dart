// // // ignore: avoid_web_libraries_in_flutter
// // import 'dart:html' as html;

// // void pushWebPath(String path) {
// //   final normalizedPath = path.startsWith('/') ? path : '/$path';

// //   if ((html.window.location.pathname ?? '') +
// //       (html.window.location.search ?? '') !=
// //       normalizedPath) {
// //     html.window.history.pushState(null, '', normalizedPath);
// //   }
// // }

// // String currentWebPath() {
// //   return '${html.window.location.pathname}${html.window.location.search}';
// // }

// // void listenWebBack(void Function(String path) onChanged) {
// //   html.window.onPopState.listen((event) {
// //     onChanged('${html.window.location.pathname}${html.window.location.search}');
// //   });
// // }

// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;

// String _normalizePath(String path) {
//   return path.startsWith('/') ? path : '/$path';
// }

// void pushWebPath(String path) {
//   final normalizedPath = _normalizePath(path);

//   final currentPath =
//       '${html.window.location.pathname}${html.window.location.search}';

//   if (currentPath != normalizedPath) {
//     html.window.history.pushState(null, '', normalizedPath);
//   }
// }

// void replaceWebPath(String path) {
//   final normalizedPath = _normalizePath(path);

//   final currentPath =
//       '${html.window.location.pathname}${html.window.location.search}';

//   if (currentPath != normalizedPath) {
//     html.window.history.replaceState(null, '', normalizedPath);
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

// void browserHistoryBack() {
//   html.window.history.back();
// }
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

const String flutterBasePath = '/flutter';

String _normalizeFlutterPath(String path) {
  final cleanPath = path.startsWith('/') ? path : '/$path';

  if (cleanPath == flutterBasePath ||
      cleanPath.startsWith('$flutterBasePath/')) {
    return cleanPath;
  }

  return '$flutterBasePath$cleanPath';
}

String _cleanRouteForNext(String path) {
  final cleanPath = path.startsWith('/') ? path : '/$path';

  if (cleanPath == flutterBasePath) {
    return '/home';
  }

  if (cleanPath.startsWith('$flutterBasePath/')) {
    final withoutBase = cleanPath.substring(flutterBasePath.length);
    return withoutBase.isEmpty ? '/home' : withoutBase;
  }

  return cleanPath;
}

void _notifyNextParent(String path, {bool replace = false}) {
  final route = _cleanRouteForNext(path);

  html.window.parent?.postMessage({
    'type': 'FLUTTER_ROUTE_CHANGED',
    'route': route,
    'replace': replace,
  }, html.window.location.origin);
}

void pushWebPath(String path) {
  final normalizedPath = _normalizeFlutterPath(path);

  final currentPath =
      '${html.window.location.pathname}${html.window.location.search}';

  if (currentPath != normalizedPath) {
    html.window.history.pushState(null, '', normalizedPath);
  }

  _notifyNextParent(path);
}

void replaceWebPath(String path) {
  final normalizedPath = _normalizeFlutterPath(path);

  final currentPath =
      '${html.window.location.pathname}${html.window.location.search}';

  if (currentPath != normalizedPath) {
    html.window.history.replaceState(null, '', normalizedPath);
  }

  _notifyNextParent(path, replace: true);
}

String currentWebPath() {
  final fullPath =
      '${html.window.location.pathname}${html.window.location.search}';

  if (fullPath.startsWith(flutterBasePath)) {
    final withoutBase = fullPath.substring(flutterBasePath.length);
    return withoutBase.isEmpty ? '/home' : withoutBase;
  }

  return fullPath;
}

void listenWebBack(void Function(String path) onChanged) {
  html.window.onPopState.listen((event) {
    onChanged(currentWebPath());
  });

  html.window.onMessage.listen((event) {
    if (event.origin != html.window.location.origin) return;

    final data = event.data;

    if (data is Map && data['type'] == 'NEXT_ROUTE_CHANGED') {
      final route = data['route']?.toString() ?? '/home';
      onChanged(route);
    }
  });
}

void browserHistoryBack() {
  html.window.history.back();
}
