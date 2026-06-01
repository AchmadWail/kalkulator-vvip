import 'dart:js' as js;

class CyberBgInterop {
  static void start() {
    if (js.context.hasProperty('CyberBg')) {
      js.context['CyberBg'].callMethod('start');
    }
  }

  static void stop() {
    if (js.context.hasProperty('CyberBg')) {
      js.context['CyberBg'].callMethod('stop');
    }
  }
}
