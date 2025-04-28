import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:planner_app/database/backlog.dart';
import 'package:planner_app/database/database_service.dart';
import 'package:planner_app/pages/backlog/add_backlog_desc.dart';

class BacklogItemInfo extends StatefulWidget {
  final String title;
  final int id;

  const BacklogItemInfo({
    super.key,
    required this.title,
    required this.id,
  });

  @override
  State<BacklogItemInfo> createState() => _BacklogItemInfoState();
}

class _BacklogItemInfoState extends State<BacklogItemInfo> {
  // Fetch backlog data by id
  Future<Backlog> getBacklogById() async {
    DatabaseService db = DatabaseService.instance;

    final backlog = await db.getBacklogById(widget.id);
    if (backlog == null) {
      throw Exception('Backlog item not found');
    }
    return backlog;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          FutureBuilder<Backlog>(
            future: getBacklogById(), // Fetch the backlog asynchronously
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No backlog item found!'));
              } else {
                final backlog = snapshot.data!;
                return AddBacklogDesc(
                  onAddTask: () {
                    Navigator.pop(context);
                  },
                  description: backlog.description,
                  id: widget.id,
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Backlog>(
        future: getBacklogById(), // Fetch the backlog asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Show loading indicator while waiting
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error}')); // Show error if something goes wrong
          } else if (!snapshot.hasData) {
            return Center(
                child: Text(
                    'No backlog item found!')); // Handle the case if no backlog data is found
          } else {
            final backlog = snapshot.data!;

            List<String> descriptionItems; // Split description into list items

            try {
              descriptionItems = jsonDecode(backlog.description)
                  .cast<String>(); // Ensure correct type.
            } catch (e) {
              descriptionItems =
                  []; // In case the description is not valid JSON.
            }

            return ListView.builder(
              itemCount: descriptionItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(descriptionItems[
                      index]), // Display each item in a ListTile
                );
              },
            );
          }
        },
      ),
    );
  }
}
