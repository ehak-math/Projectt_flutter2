import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/participant_provider.dart';
import '../../providers/sagment_provider.dart';
import '../../providers/segment_time_provider.dart';

class TrackSegmentScreen extends StatefulWidget {
  final int raceId;

  const TrackSegmentScreen({super.key, required this.raceId});

  @override
  State<TrackSegmentScreen> createState() => _TrackSegmentScreenState();
}

class _TrackSegmentScreenState extends State<TrackSegmentScreen> {
  int? selectedSegmentId;
  Map<int, DateTime> recordedTimes = {}; // participantId -> time

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await Provider.of<SegmentProvider>(
      context,
      listen: false,
    ).fetchSegmentsTracker(widget.raceId);
    await Provider.of<ParticipantProvider>(
      context,
      listen: false,
    ).fetchParticipantsTracker(widget.raceId);
  }

  void _trackTime({
    required BuildContext context,
    required int participantId,
    required int segmentId,
  }) async {
    final segmentTimeProvider = Provider.of<SegmentTimeProvider>(
      context,
      listen: false,
    );
    final now = DateTime.now();

    try {
      await segmentTimeProvider.trackSegmentTime(
        participantId: participantId,
        segmentId: segmentId,
        timeRecordedAt: now,
      );

      setState(() {
        recordedTimes[participantId] = now; // save time
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Segment time tracked successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Failed to track time')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final segmentProvider = Provider.of<SegmentProvider>(context);
    final participantProvider = Provider.of<ParticipantProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Segment Time"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body:
          segmentProvider.isLoading || participantProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:
                            segmentProvider.segments.map((segment) {
                              final isSelected =
                                  selectedSegmentId == segment.id;
                              final isFirst =
                                  segmentProvider.segments.first == segment;
                              final isLast =
                                  segmentProvider.segments.last == segment;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedSegmentId = segment.id;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(150, 50),
                                    backgroundColor:
                                        isSelected
                                            ? const Color.fromARGB(
                                              255,
                                              88,
                                              86,
                                              214,
                                            )
                                            : const Color(0xFFEFF1F5),
                                    foregroundColor:
                                        isSelected
                                            ? Colors.white
                                            : const Color.fromARGB(
                                              255,
                                              88,
                                              86,
                                              214,
                                            ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.horizontal(
                                        left:
                                            isFirst
                                                ? const Radius.circular(8)
                                                : Radius.zero,
                                        right:
                                            isLast
                                                ? const Radius.circular(8)
                                                : Radius.zero,
                                      ),
                                    ),
                                  ),
                                  child: Text(segment.name),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),
                    selectedSegmentId == null
                        ? const Text(
                          "Please select a segment to begin tracking",
                        )
                        : Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 1.2,
                                ),
                            itemCount: participantProvider.participants.length,
                            itemBuilder: (context, index) {
                              final participant =
                                  participantProvider.participants[index];
                              final timeRecorded =
                                  recordedTimes[participant.id];

                              if (timeRecorded != null) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        participant.bibNumber.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${timeRecorded.hour.toString().padLeft(2, '0')}:${timeRecorded.minute.toString().padLeft(2, '0')}:${timeRecorded.second.toString().padLeft(2, '0')}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return ElevatedButton(
                                  onPressed: () {
                                    _trackTime(
                                      context: context,
                                      participantId: participant.id,
                                      segmentId: selectedSegmentId!,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    participant.bibNumber.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                  ],
                ),
              ),
    );
  }
}
