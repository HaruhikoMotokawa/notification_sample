import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_sample/data/repositories/local_notification/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
LocalNotificationsRepositoryBase localNotificationsRepository(Ref ref) =>
    LocalNotificationsRepository(ref);

/// アプリがキルされている状態で送られてきた遷移パスを保持する
@Riverpod(keepAlive: true)
class NotificationLocation extends _$NotificationLocation {
  @override
  String? build() => null;

  set path(String? newPath) => state = newPath;

  String? get path => state;
}
