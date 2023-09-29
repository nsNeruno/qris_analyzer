import 'package:flutter/foundation.dart';
import 'package:qris_analyzer/models/serializable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PrefStorage<T extends Serializable> {

  const PrefStorage(this.key,);

  @protected
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  Future<T?> readValue();

  Future<void> setValue(T value,) async {
    final valueToSave = await value.toJsonStringAsync();
    await (await prefs).setString(key, valueToSave,);
  }

  Future<void> delete() async {
    await (await prefs).remove(key,);
  }

  final String key;
}

abstract class PrefListStorage<T extends Serializable> {

  const PrefListStorage(this.key,);

  Future<List<T>?> readValues();

  Future<void> add(T value,);

  Future<T?> remove(T value,);

  Future<void> delete() async {
    await (await prefs).remove(key,);
  }

  @protected
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  final String key;
}