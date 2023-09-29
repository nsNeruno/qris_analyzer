import 'package:qris_analyzer/data/src/pref_storage.dart';
import 'package:qris_analyzer/models/cached_code.dart';
import 'package:qris_analyzer/utils/app_constants.dart';
import 'package:qris_analyzer/utils/logger.dart';

class CachedCodeRepository extends PrefListStorage<CachedCode> {

  CachedCodeRepository({
    this.maxCodes = AppConstants.maxRecentCodeLength,
  }): super('x-cached-codes',);

  @override
  Future<void> add(CachedCode value) async {
    _internal.insert(0, value,);
    if (_internal.length > maxCodes) {
      _internal.removeLast();
    }
    _save();
  }

  Future<void> _reload() async {
    final raw = (await prefs).getStringList(key,) ?? [];
    final data = <CachedCode>[];
    debugLog('Data count: ${raw.length}', name: '$runtimeType._reload',);
    for (final rawData in raw) {
      try {
        data.add(CachedCode.fromJson(rawData,),);
      } catch (_) {
        debugErrorLog(_, name: '$runtimeType.readValues',);
      }
    }
    data.sort();
    _internal.clear();
    _internal.addAll(
      data.length > maxCodes ? data.take(maxCodes,) : data,
    );
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

  Future<void> _save() async {
    final mapped = await Future.wait(
      _internal.map((e) => e.toJsonStringAsync(),),
    );
    await (await prefs).setStringList(
      key,
      mapped,
    );
  }

  final _internal = <CachedCode>[];
  final int maxCodes;

  bool _hasFirstLoad = false;
}