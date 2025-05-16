class SegmentTime {
  final int id;
  final int raceId;
  final int participantId;
  final int segmentId;
  final DateTime timeRecordedAt;
  final String? participantName;
  final String? segmentName;

  SegmentTime({
    required this.id,
    required this.raceId,
    required this.participantId,
    required this.segmentId,
    required this.timeRecordedAt,
    this.participantName,
    this.segmentName,
  });

  factory SegmentTime.fromJson(Map<String, dynamic> json) {
    return SegmentTime(
      id: int.tryParse(json['id'].toString()) ?? 0,
      raceId: int.tryParse(json['race_id'].toString()) ?? 0,
      participantId: int.tryParse(json['participant_id'].toString()) ?? 0,
      segmentId: json['segment_id'] ?? '',
      timeRecordedAt: DateTime.tryParse(json['time_recorded_at'].toString()) ?? DateTime.now(),
      participantName: json['participant']['name'] ?? 'Unknown',
      segmentName: json['segment']['name'] ?? 'Unknown',
    );
  }
}
