import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/sagment.dart';
import '../../../providers/sagment_provider.dart';

class AddEditSegmentScreen extends StatefulWidget {
  final Segment? segment;
  final int raceId;

  const AddEditSegmentScreen({
    super.key,
    this.segment,
    required this.raceId,
  });

  @override
  State<AddEditSegmentScreen> createState() => _AddEditSegmentScreenState();
}

class _AddEditSegmentScreenState extends State<AddEditSegmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _distanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.segment?.name ?? '');
    _distanceController = TextEditingController(
      text: widget.segment?.distance.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final distance = double.tryParse(_distanceController.text.trim()) ?? 0;

      final provider = Provider.of<SegmentProvider>(context, listen: false);

      if (widget.segment == null) {
        // Add
        provider.addSegment({
          'name': name,
          'distance': distance,
          'race_id': widget.raceId,
        });
      } else {
        // Update
        provider.updateSegment(widget.segment!.id, {
          'name': name,
          'distance': distance,
          'race_id': widget.raceId
        });
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.segment != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 88, 86, 214),
        foregroundColor: Colors.white,
        title: Text(isEditing ? 'Edit Segment' : 'Add Segment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter segment name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: 'Distance (km)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter distance';
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) return 'Invalid distance';
                  return null;
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
                    isEditing ? 'Save Changes' : 'Add Segment',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
