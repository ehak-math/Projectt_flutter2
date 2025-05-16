import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/participant_provider.dart';
import '../../../providers/sagment_provider.dart';
import '../../../widgets/participant_list_widget.dart';
import 'add_edit_participant_screen.dart';

class ParticipantsScreen extends StatefulWidget {
  final int raceId;

  const ParticipantsScreen({super.key, required this.raceId});

  @override
  State<ParticipantsScreen> createState() => _ParticipantsScreenState();
}

class _ParticipantsScreenState extends State<ParticipantsScreen> {
  @override
  void initState() {
    super.initState();

    final participantProvider = Provider.of<ParticipantProvider>(
      context,
      listen: false,
    );
    final segmentProvider = Provider.of<SegmentProvider>(
      context,
      listen: false,
    );

    participantProvider.fetchParticipants(widget.raceId);
    segmentProvider.fetchSegments(widget.raceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Participant List',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    tooltip: 'Add Participant',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => AddEditParticipantScreen(
                                raceId: widget.raceId,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Consumer2<ParticipantProvider, SegmentProvider>(
              builder: (context, participantProvider, segmentProvider, child) {
                if (participantProvider.isLoading ||
                    segmentProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (participantProvider.participants.isEmpty) {
                  return Center(child: Text('No participants found.'));
                }

                return ParticipantListTable(
                  participants: participantProvider.participants,
                  segments: segmentProvider.segments,
                  onEdit: (participant) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => AddEditParticipantScreen(
                              raceId: widget.raceId,
                              participant: participant,
                            ),
                      ),
                    );
                  },
                  onDelete: (participant) async {
                    await participantProvider.deleteParticipant(
                      participant.id,
                      widget.raceId,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
