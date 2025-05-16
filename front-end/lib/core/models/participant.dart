import 'segment_time.dart';

class Participant {
  final int id;
  final String bibNumber;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final int raceId;
  final int segmentId;
  final List<SegmentTime> segmentTimes;

  Participant({
    required this.id,
    required this.bibNumber,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.segmentTimes,
    required this.raceId,
    required this.segmentId,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: int.tryParse(json['id'].toString()) ?? 0,
      raceId: int.tryParse(json['race_id'].toString()) ?? 0,
      segmentId: int.tryParse(json['segment_id'].toString()) ?? 0,
      bibNumber: json['bib_number']?.toString() ?? 'N/A',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      age: int.tryParse(json['age'].toString()) ?? 0,
      gender: json['gender'] ?? '',
      segmentTimes: (json['segment_times'] as List? ?? [])
          .map((t) => SegmentTime.fromJson(t))
          .toList(),
    );
  }
}
