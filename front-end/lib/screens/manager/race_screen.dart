import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/race_provider.dart';
import 'home_screen.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<RaceProvider>(context, listen: false).fetchRaces();
  }

void showAddRaceBottomSheet(BuildContext context) {
  final TextEditingController _nameController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add Race",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Race Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final name = _nameController.text.trim();
              if (name.isNotEmpty) {
                try {
                  await Provider.of<RaceProvider>(context, listen: false)
                      .createRace({'name': name});
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add race: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 88, 86, 214),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Save"),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Race"),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 88, 86, 214),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showAddRaceBottomSheet(context);
            },
          )
        ],
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
                        builder: (_) => HomeScreen(raceId: race.id),
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
