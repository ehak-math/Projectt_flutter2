import 'package:flutter/material.dart';

class NavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const NavigationBarWidget({
    required this.selectedIndex,
    required this.onItemSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ), // Add padding on the left
              child: ElevatedButton(
                onPressed: () => onItemSelected(0),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedIndex == 0
                          ? const Color.fromARGB(255, 88, 86, 214)
                          : const Color(0xFFEFF1F5),
                  foregroundColor:
                      selectedIndex == 0
                          ? Colors.white
                          : const Color.fromARGB(255, 88, 86, 214),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  minimumSize: const Size(0, 60), // Ensure consistent height
                ),
                child: selectedIndex == 0
                    ? const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 30,
                      )
                    : const Icon(
                        Icons.emoji_events_outlined,
                        size: 30,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 0), // Add spacing between buttons
          Expanded(
            child: ElevatedButton(
              onPressed: () => onItemSelected(1),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedIndex == 1
                        ? const Color.fromARGB(255, 88, 86, 214)
                        : const Color(0xFFEFF1F5),
                foregroundColor:
                    selectedIndex == 1
                        ? Colors.white
                        : const Color.fromARGB(255, 88, 86, 214),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                minimumSize: const Size(0, 60), // Ensure consistent height
              ),
              child: selectedIndex == 1
                  ? const Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 30,
                    )
                  : const Icon(
                      Icons.people_outline,
                      size: 30,
                    ),
            ),
          ),
          const SizedBox(width: 0), // Add spacing between buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
              ), // Add padding on the left
              child: ElevatedButton(
                onPressed: () => onItemSelected(2),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedIndex == 2
                          ? const Color.fromARGB(255, 88, 86, 214)
                          : const Color(0xFFEFF1F5),
                  foregroundColor:
                      selectedIndex == 2
                          ? Colors.white
                          : const Color.fromARGB(255, 88, 86, 214),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  minimumSize: const Size(0, 60), // Ensure consistent height
                ),
                child:
                    selectedIndex == 2
                        ? const Icon(
                          Icons.segment,
                          color: Colors.white,
                          size: 30,
                        )
                        : const Icon(Icons.segment_outlined, size: 30),
              ),
              // const Icon(Icons.segment, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
