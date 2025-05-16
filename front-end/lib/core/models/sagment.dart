class Segment {
  final int id;
  final String name;
  final double distance;
  final int raceId;

  Segment({
    required this.id,
    required this.name,
    required this.distance,
    required this.raceId,
  });

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      id: json['id'],
      name: json['name'],
      distance: json['distance'].toDouble(),
      raceId: json['race_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'distance': distance,
      'race_id': raceId,
    };
  }
}
