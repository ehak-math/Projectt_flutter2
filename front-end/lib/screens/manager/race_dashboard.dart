import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/race_provider.dart';

class RaceDashboard extends StatefulWidget {
  final int raceId;

  const RaceDashboard({super.key, required this.raceId});

  @override
  State<RaceDashboard> createState() => _RaceDashboardState();
}

class _RaceDashboardState extends State<RaceDashboard> {
  @override
  void initState() {
    super.initState();

    final raceProvider = Provider.of<RaceProvider>(context, listen: false);
    raceProvider.fetchRaces(); // Fetch race details
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
                    'Race Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Consumer<RaceProvider>(
              builder: (context, raceProvider, child) {
                if (raceProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final race = raceProvider.getRaceById(widget.raceId);
                if (race == null) {
                  return const Center(child: Text('Race not found.'));
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Race Status: ${race.status.toUpperCase()}"),
                        const SizedBox(height: 20),
                        Text('Start Date: ${race.startTime}'),
                        const SizedBox(height: 10),
                        const SizedBox(height: 20),
                        if (race.status == 'Not Started') ...[
                          ElevatedButton(
                            onPressed: () => _handleAction(
                              context,
                              action: raceProvider.startRace,
                              raceId: race.id,
                              label: 'Starting',
                            ),
                            child: const Text('Start Race'),
                          ),
                        ] else if (race.status == 'Started') ...[
                          ElevatedButton(
                            onPressed: () => _handleAction(
                              context,
                              action: raceProvider.finishRace,
                              raceId: race.id,
                              label: 'Finishing',
                            ),
                            child: const Text('Finish Race'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => _handleAction(
                              context,
                              action: raceProvider.resetRace,
                              raceId: race.id,
                              label: 'Resetting',
                            ),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Reset Race'),
                          ),
                        ] else if (race.status == 'Finished') ...[
                          ElevatedButton(
                            onPressed: () => _handleAction(
                              context,
                              action: raceProvider.resetRace,
                              raceId: race.id,
                              label: 'Resetting',
                            ),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('Reset Race'),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context, {
    required Future<void> Function(int) action,
    required int raceId,
    required String label,
  }) async {
    final scaffold = ScaffoldMessenger.of(context);
    try {
      scaffold.showSnackBar(SnackBar(content: Text('$label...')));
      await action(raceId);
      scaffold.showSnackBar(SnackBar(content: Text('$label successful!')));
    } catch (e) {
      scaffold.showSnackBar(SnackBar(content: Text('Error $label: $e')));
    }
  }
}
