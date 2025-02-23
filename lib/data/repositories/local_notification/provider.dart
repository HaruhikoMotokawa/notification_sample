import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_sample/data/repositories/local_notification/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
LocalNotificationsRepositoryBase localNotificationsRepository(Ref ref) =>
    LocalNotificationsRepository(ref);
