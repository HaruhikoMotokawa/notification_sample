import 'package:app_settings/app_settings.dart';

abstract interface class AppSettingsRepositoryBase {
  /// OSのアプリ設定画面を開く
  void openAppSettings();
}

class AppSettingsRepository implements AppSettingsRepositoryBase {
  const AppSettingsRepository();

  @override
  void openAppSettings() => AppSettings.openAppSettings();
}
