import 'package:flutter/material.dart';
import 'package:planner_app/database/database_service.dart';
import 'package:planner_app/database/event.dart'; // Make sure this path is correct

class PastEvents extends StatefulWidget {
  const PastEvents({super.key});

  @override
  State<PastEvents> createState() => _PastEventsState();
}

class _PastEventsState extends State<PastEvents> {
  final DatabaseService _databaseService = DatabaseService.instance;

  List<Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await _databaseService.getAllEvents(isFuture: false);
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading events: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEvent(int eventId, int index) async {
    try {
      await _databaseService.deleteEvent(eventId);
      setState(() {
        _events.removeAt(index);
      });
    } catch (e) {
      debugPrint("Error deleting event: $e");
    }
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex"; // Add full opacity if not specified
    }
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_events.isEmpty) {
      return const Center(child: Text("No upcoming events"));
    }

    return ListView.builder(
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        final daysUntil = event.dueDate.difference(DateTime.now()).inDays;

        return Container(
          color: hexToColor(event.backgroundColor),
          child: ListTile(
            key: ValueKey(event.id),
            leading: const Icon(Icons.event, size: 30),
            title: Text(event.title),
            subtitle: Text(
              event.description,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 11),
            ),
            trailing: Text("$daysUntil days"),
            onLongPress: () async {
              if (event.id != null) {
                await _deleteEvent(event.id!, index);
              }
            },
          ),
        );
      },
    );
  }
}
