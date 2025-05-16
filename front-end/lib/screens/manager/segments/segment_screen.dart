import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/providers/race_provider.dart';
import 'package:time_tracking/widgets/sagment_card.dart';
import '../../../providers/sagment_provider.dart';
import 'add_edit_segment_screen.dart';

class SegmentScreen extends StatefulWidget {
  final int raceId;
  const SegmentScreen({super.key, required this.raceId});

  @override
  State<SegmentScreen> createState() => _SegmentScreenState();
}


class _SegmentScreenState extends State<SegmentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final segmentProvider = Provider.of<SegmentProvider>(context, listen: false);
      final raceProvider = Provider.of<RaceProvider>(context, listen: false);

      segmentProvider.fetchSegments(widget.raceId);
      raceProvider.fetchRaces(); // or fetchRaceById(widget.raceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SegmentProvider, RaceProvider>(
     builder: (context, segmentProvider, raceProvider, _) {
     final race = raceProvider.getRaceById(widget.raceId);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Segments', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, size: 28,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => AddEditSegmentScreen(raceId: widget.raceId),
                    ),
                  );
                },
              ),
            ],
          ),
          body:
              segmentProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : segmentProvider.segments.isEmpty
                  ? const Center(child: Text('No segments found'))
                  : ListView.builder(
                    itemCount: segmentProvider.segments.length,
                    itemBuilder: (context, index) {
                      final segment = segmentProvider.segments[index];
                      return SegmentCard(segment: segment, raceId: widget.raceId, race: race!,);
                    },
                  ),
        );
      },
    );
  }
  
}

