import 'package:qris_analyzer/data/src/pref_storage.dart';
import 'package:qris_analyzer/models/cached_code.dart';
import 'package:qris_analyzer/utils/logger.dart';

class FavoriteCodeRepository extends PrefListStorage<CachedCode> {

  FavoriteCodeRepository(): super('x-favorite-codes',);

  @override
  Future<void> add(CachedCode value) async {
    if (_internal.contains(value,)) {
      _internal.remove(value,);
    } else {
      _internal.add(value,);
    }
    _save();
  }

  Future<void> _reload() async {
    final raw = (await prefs).getStringList(key,) ?? [];
    final data = <CachedCode>[];
    for (final rawData in raw) {
      try {
        data.add(CachedCode.fromJson(rawData,),);
      } catch (_) {
        debugErrorLog(_, name: '$runtimeType.readValues',);
      }
    }
    _internal.clear();
    _internal.addAll(data,);
  }

  @override
  Future<List<CachedCode>?> readValues() async {
    if (!_hasFirstLoad) {
      await _reload();
      _hasFirstLoad = true;
    }
    return _internal.toList();
  }

  @override
  Future<CachedCode?> remove(CachedCode value) async {
    final removed = _internal.remove(value,);
    _save();
    return removed ? value : null;
  }

  @override
  Future<bool> removeAll() async {
    _internal.clear();
    return (await prefs).remove(key,);
  }

  Future<void> _save() async {
    final mapped = await Future.wait(
      _internal.map((e) => e.toJsonStringAsync(),),
    );
    await (await prefs).setStringList(
      key,
      mapped,
    );
  }

  final _internal = <CachedCode>{};
  bool _hasFirstLoad = false;
}