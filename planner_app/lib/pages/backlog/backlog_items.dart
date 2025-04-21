import 'package:flutter/material.dart';
import 'package:planner_app/database/database_service.dart';
import 'package:planner_app/database/backlog.dart';
import 'package:planner_app/pages/backlog/add_backlog.dart';
import 'package:planner_app/pages/backlog/backlog_item_info.dart';

class BacklogItems extends StatefulWidget {
  final String timeline; // e.g. "Week" or "Month"
  const BacklogItems({super.key, required this.timeline});

  @override
  State<BacklogItems> createState() => _BacklogItemsState();
}

class _BacklogItemsState extends State<BacklogItems> {
  final DatabaseService _db = DatabaseService.instance;
  late Future<List<Backlog>> _futureBacklogs;

  @override
  void initState() {
    super.initState();
    _loadBacklogs(); // Initially load the backlogs when the widget is created
  }

  void _loadBacklogs() {
    // Re-fetch the backlog items from the database
    _futureBacklogs = _db.getAllBacklogs(widget.timeline);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: timeline label + add button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.timeline,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              AddBacklog(
                timeline: widget.timeline,
                // Re-fetch the data once we've added a new backlog
                onAddTask: () {
                  setState(() {
                    _loadBacklogs(); // Reload the backlogs after adding a new task
                  });
                },
              ),
            ],
          ),
        ),

        // Body: load & display the list
        FutureBuilder<List<Backlog>>(
          future: _futureBacklogs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Nothing to think about this ${widget.timeline}."),
              );
            }

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.adjust, size: 20),
                    title: Text(item.title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BacklogItemInfo(
                            title: item.title,
                            id: item.id,
                          ),
                        ),
                      ).then((_) {
                        // In case the user edited or deleted an item in the detail screen
                        setState(() {
                          _loadBacklogs(); // Reload the backlogs after an edit
                        });
                      });
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
