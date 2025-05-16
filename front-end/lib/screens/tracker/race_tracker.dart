import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/screens/tracker/time_tracking_screen.dart';
import '../../providers/race_provider.dart';

class RaceTracker extends StatefulWidget {
  const RaceTracker({super.key});

  @override
  State<RaceTracker> createState() => _RaceTrackerState();
}

class _RaceTrackerState extends State<RaceTracker> {
  @override
  void initState() {
    super.initState();
    Provider.of<RaceProvider>(context, listen: false).fetchRacesTracker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Race"),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 88, 86, 214),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<RaceProvider>(
          builder: (context, raceProvider, child) {
            if (raceProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (raceProvider.races.isEmpty) {
              return Center(child: Text("No races available."));
            }

            return ListView.builder(
              itemCount: raceProvider.races.length,
              itemBuilder: (context, index) {
                final race = raceProvider.races[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrackSegmentScreen(raceId: race.id),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    color: Color.fromARGB(255, 242, 242, 255),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.flag,
                            color: Color.fromARGB(255, 88, 86, 214),
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              race.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
