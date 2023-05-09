import 'dart:html';
import 'dart:js';

class JsLibrary {
  /// The name of global variable where library is stored.
  /// Used to properly import the library if [usesRequireJs] flag is true
  final String contextName;
  final String url;

  const JsLibrary({
    required this.contextName,
    required this.url,
  });

  static Future<void> injectLibraries(List<JsLibrary> libraries) {
    final List<Future<void>> futures = [];

    for (final library in libraries) {
      final future = _loadScript(library);
      futures.add(future);
    }

    return Future.wait(futures);
  }

  static Future<void> _appendScript(String url) async {
    final script = ScriptElement()
      ..async = true
      ..defer = false
      ..crossOrigin = 'anonymous'
      ..type = 'text/javascript'
      ..src = url;

    document.head!.append(script);
    await script.onLoad.first;
  }

  static Future<void> _loadScript(JsLibrary library) async {
    dynamic amd;
    dynamic define;

    if (context['define']?['amd'] != null) {
      // In dev, requireJs is loaded in. Disable it here.
      // see https://github.com/dart-lang/sdk/issues/33979
      define = JsObject.fromBrowserObject(context['define'] as Object);

      amd = define['amd'];
      define['amd'] = false;
    }

    try {
      await _appendScript(library.url);
    } finally {
      if (amd != null) {
        // Re-enable requireJs
        define['amd'] = amd;
      }
    }
  }
}
