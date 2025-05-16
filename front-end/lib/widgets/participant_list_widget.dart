import 'package:flutter/material.dart';
import '../../core/models/participant.dart';
import '../../core/models/sagment.dart';

class ParticipantListTable extends StatelessWidget {
  final List<Participant> participants;
  final List<Segment> segments;
  final Function(Participant) onEdit;
  final Function(Participant) onDelete;

  const ParticipantListTable({
    super.key,
    required this.participants,
    required this.segments,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Participants',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                },
                children: [
                  // Table header
                  const TableRow(
                    decoration: BoxDecoration(color: Color.fromARGB(255, 88, 86, 214)),
                    children: [
                      _HeaderCell('BIB'),
                      _HeaderCell('Name'),
                      _HeaderCell('Segment'),
                      _HeaderCell('Actions'),
                    ],
                  ),
                  // Rows
                  ...participants.map((p) {
                    final segment = segments.firstWhere(
                      (s) => s.id == p.segmentId,
                      orElse: () => Segment(id: 0, name: 'Unknown', distance: 0, raceId: 0),
                    );
          
                    return TableRow(
                      children: [
                        _BodyCell(p.bibNumber,),
                        _BodyCell('${p.firstName} ${p.lastName}'),
                        _BodyCell('${segment.name} (${segment.distance}km)'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => onEdit(p),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => onDelete(p),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _BodyCell extends StatelessWidget {
  final String text;
  const _BodyCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
