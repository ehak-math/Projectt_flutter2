import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/core/models/race.dart';
import '../core/models/sagment.dart';
import '../providers/sagment_provider.dart';
import '../screens/manager/segments/add_edit_segment_screen.dart';

class SegmentCard extends StatelessWidget {
  final Segment segment;
  final Race race;
  final int raceId;

  const SegmentCard({
    super.key,
    required this.segment,
    required this.race,
    required this.raceId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Circle Avatar with Distance
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color.fromARGB(255, 88, 86, 214),
              child: Text(
                '${segment.distance}km',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Segment Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    segment.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                     'Race: ${race.name}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Edit & Delete buttons
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditSegmentScreen(
                      raceId: raceId,
                      segment: segment,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                Provider.of<SegmentProvider>(context, listen: false)
                    .deleteSegment(segment.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
