import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/models/segment_time.dart';

abstract class SegmentTimeRepository {
  Future<List<SegmentTime>> getSegmentTimes(String raceId);
}

class FirebaseReposity extends SegmentTimeRepository {
  static const String baseUrl = 'https://time-tracking-2b8b9-default-rtdb.asia-southeast1.firebasedatabase.app';
  static const String segmentTimesPath = '$baseUrl/segment_times.json';

  @override
  Future<List<SegmentTime>> getSegmentTimes(String raceId) async {
    Uri url = Uri.parse('$segmentTimesPath?raceId=$raceId');
    final http.Response response = await http.get(url);

    // Handle errors
    if(response.statusCode != HttpStatus.ok && response.statusCode != HttpStatus.created) {
      throw Exception('Failed to load segment times: ${response.statusCode}');
    }

    // Return all users
    // return []; // Return an empty list if no data is available
    return (response.body as List).map((segmentTime) {
      return SegmentTime.fromJson(segmentTime);
    }).toList();

  }
}
