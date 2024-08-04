import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'matting_plugin_method_channel.dart';

abstract class MattingPluginPlatform extends PlatformInterface {
  /// Constructs a MattingPluginPlatform.
  MattingPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static MattingPluginPlatform _instance = MethodChannelMattingPlugin();

  /// The default instance of [MattingPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelMattingPlugin].
  static MattingPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MattingPluginPlatform] when
  /// they register themselves.
  static set instance(MattingPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> startMatting(String originPath, String maskPath) {
    throw UnimplementedError('startMatting() has not been implemented.');
  }
}
