import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracking/screens/manager/segments/segment_screen.dart';
import '../../../providers/race_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/navigation_bar_widget.dart';
import '../login_screen.dart';
import 'Participants/participants_screen.dart';
import 'race_dashboard.dart';

class HomeScreen extends StatefulWidget {
  final int raceId;
  const HomeScreen({super.key, required this.raceId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<RaceProvider>(
      context,
      listen: false,
    ).fetchRaceName(widget.raceId);
  }

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final raceName = Provider.of<RaceProvider>(context).raceName;

    final List<Widget> screens = [
      RaceDashboard(raceId: widget.raceId),
      ParticipantsScreen(raceId: widget.raceId),
      SegmentScreen(raceId: widget.raceId),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(raceName),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          NavigationBarWidget(
            selectedIndex: _selectedIndex,
            onItemSelected: _onTap,
          ),
          Expanded(child: screens[_selectedIndex]),
        ],
      ),
    );
  }
}
