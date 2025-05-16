import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/participant_provider.dart';
import '../../../providers/sagment_provider.dart';
import '../../../core/models/participant.dart';

class AddEditParticipantScreen extends StatefulWidget {
  final Participant? participant;
  final int raceId;

  AddEditParticipantScreen({this.participant, required this.raceId});

  @override
  _AddEditParticipantScreenState createState() =>
      _AddEditParticipantScreenState();
}

class _AddEditParticipantScreenState extends State<AddEditParticipantScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bibController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  int? _selectedSegmentId;

  @override
  void initState() {
    super.initState();

    _bibController = TextEditingController(
      text: widget.participant?.bibNumber ?? '',
    );
    _firstNameController = TextEditingController(
      text: widget.participant?.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.participant?.lastName ?? '',
    );
    _selectedSegmentId =
        widget.participant?.segmentId; // 👈 Set initial segment

    // Fetch segments for this race
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SegmentProvider>(
        context,
        listen: false,
      ).fetchSegments(widget.raceId);
    });
  }

  @override
  void dispose() {
    _bibController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final payload = {
        'bib_number': _bibController.text,
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'race_id': widget.raceId,
        'segment_id': _selectedSegmentId,
      };

      final provider = Provider.of<ParticipantProvider>(context, listen: false);

      if (widget.participant == null) {
        await provider.addParticipant(payload, widget.raceId);
      } else {
        await provider.updateParticipant(
          widget.participant!.id,
          payload,
          widget.raceId,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.participant != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 88, 86, 214),
        foregroundColor: Colors.white,
        title: Text(isEditing ? 'Edit Participant' : 'Add Participant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _bibController,
                decoration: const InputDecoration(
                  labelText: 'BIB Number',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter BIB number'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter first name'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter last name'
                            : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Segment',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Consumer<SegmentProvider>(
                builder: (context, segmentProvider, child) {
                  final segments = segmentProvider.segments;
                  if (segments.isEmpty) {
                    return const Text('Loading segments...');
                  }

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        segments.map((segment) {
                          final isSelected = _selectedSegmentId == segment.id;
                          return SizedBox(
                            width: 100,
                            height: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedSegmentId = segment.id;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isSelected
                                        ? const Color.fromARGB(255, 88, 86, 214)
                                        : Colors.white,
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
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color:
                                        isSelected
                                            ? Colors.transparent
                                            : const Color.fromARGB(
                                              255,
                                              88,
                                              86,
                                              214,
                                            ),
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(0),
                              ),
                              child: Center(
                                child: Text(
                                  segment.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 88, 86, 214),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isEditing ? 'Save Changes' : 'Add Participant',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
