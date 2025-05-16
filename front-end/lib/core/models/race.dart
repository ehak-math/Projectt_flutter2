class Race {
  final int id;
  final String name;
  final String status;
  final DateTime? startTime;
  final DateTime? endTime;


  Race({
    required this.id,
    required this.name,
    required this.status,
    this.startTime,
    this.endTime,
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
       id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      startTime: json['start_time'] != null
          ? DateTime.tryParse(json['start_time'])
          : null,
      endTime: json['end_time'] != null
          ? DateTime.tryParse(json['end_time'])
          : null,
    );
  }
}
