import 'package:qris_analyzer/models/serializable.dart';

class CachedCode extends Serializable implements Comparable<CachedCode> {

  const CachedCode({
    this.merchantName,
    this.customName,
    required this.data,
    required this.createdAt,
  });

  CachedCode.fromMap(Map<String, dynamic> data,): this(
    merchantName: data['merchantName'],
    customName: data['customName'],
    data: data['data'],
    createdAt: DateTime.tryParse('${data['createdAt']}',) ?? DateTime.now(),
  );

  CachedCode.fromJson(String json,): this.fromMap(jsonDecode(json,),);

  CachedCode copyWith({
    String? customName,
  }) {
    return CachedCode(
      merchantName: merchantName,
      customName: customName ?? this.customName,
      data: data,
      createdAt: createdAt,
    );
  }

  @override
  Map<String, dynamic> toMap([Object? args]) => {
    'merchantName': merchantName,
    'customName': customName,
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
  final String? customName;
  final String data;
  final DateTime createdAt;
}