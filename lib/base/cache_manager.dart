import 'package:gis_disaster_flutter/data/model/user.dart';
import 'package:hive_flutter/adapters.dart';

mixin CacheManager {
  Future<void> saveUser(User user) async {
    await Hive.box<User>('user').put('user', user);
  }

  User? getUser() {
    return Hive.box<User>('user').get('user');
  }

  Future<void> deleteUser() async {
    await Hive.box<User>('user').delete('user');
  }
}
