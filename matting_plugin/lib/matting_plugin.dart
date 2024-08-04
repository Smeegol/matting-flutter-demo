import 'matting_plugin_platform_interface.dart';

class MattingPlugin {
  Future<String?> getPlatformVersion() {
    return MattingPluginPlatform.instance.getPlatformVersion();
  }

  Future<String?> startMatting(String originPath, String maskPath) {
    return MattingPluginPlatform.instance.startMatting(originPath, maskPath);
  }
}
