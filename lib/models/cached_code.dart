import 'package:qris_analyzer/models/serializable.dart';

class CachedCode extends Serializable implements Comparable<CachedCode> {

  const CachedCode({
    this.merchantName,
    required this.data,
    required this.createdAt,
  });

  CachedCode.fromMap(Map<String, dynamic> data,): this(
    merchantName: data['merchantName'],
    data: data['data'],
    createdAt: DateTime.tryParse('${data['createdAt']}',) ?? DateTime.now(),
  );

  CachedCode.fromJson(String json,): this.fromMap(jsonDecode(json,),);

  @override
  Map<String, dynamic> toMap([Object? args]) => {
    'merchantName': merchantName,
    'data': data,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) {
    if (other is CachedCode) {
      return merchantName == other.merchantName
          && data == other.data
          && createdAt.toIso8601String() == other.createdAt.toIso8601String();
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(
    merchantName, data, createdAt.toIso8601String(),
  );

  @override
  int compareTo(CachedCode other) => createdAt.compareTo(other.createdAt,) * -1;

  final String? merchantName;
  final String data;
  final DateTime createdAt;
}