class EnsureByPhoneResult {
  final int id;
  final bool existed;
  final Map<String, dynamic> data;  // <-- full customer data

  EnsureByPhoneResult({
    required this.id,
    required this.existed,
    required this.data,
  });

  factory EnsureByPhoneResult.fromJson(Map<String, dynamic> json) {
    final idVal = json['id'];
    return EnsureByPhoneResult(
      id: idVal is int ? idVal : int.parse(idVal.toString()),
      existed: json['existed'] == true || json['existed'] == 1 || json['existed'] == '1',
      data: (json['data'] ?? {}) as Map<String, dynamic>,
    );
  }

  @override
  String toString() => 'EnsureByPhoneResult(id: $id, existed: $existed, data: $data)';
}