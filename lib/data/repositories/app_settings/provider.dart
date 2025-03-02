import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_sample/data/repositories/app_settings/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
AppSettingsRepositoryBase appSettingsRepository(Ref ref) =>
    const AppSettingsRepository();
