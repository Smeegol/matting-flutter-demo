import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'matting_plugin_platform_interface.dart';

/// An implementation of [MattingPluginPlatform] that uses method channels.
class MethodChannelMattingPlugin extends MattingPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('matting_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> startMatting(String originPath, String maskPath) async {
    final resultPath = await methodChannel.invokeMethod<String>('startMatting', {
      'originPath': originPath,
      'maskPath': maskPath,
    });
    return resultPath;
  }
}
