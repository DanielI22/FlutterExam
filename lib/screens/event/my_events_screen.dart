import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_exam/services/notifications_service.dart';
import 'package:flutter_exam/widgets/event_tile.dart';
import '../../services/event_service.dart';
import '../../models/event_model.dart';
import '../event/event_form.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  void _showDeleteConfirmation(BuildContext outerContext, CalendarEvent event) {
    showDialog(
      context: outerContext,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text("Delete Event"),
            content: Text('Are you sure you want to delete "${event.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await Future.delayed(Duration.zero);
                  await EventService().deleteEvent(event.id);
                  await NotificationService().cancelNotification(
                    int.parse(event.id.hashCode.toString()),
                  );
                  if (outerContext.mounted) {
                    ScaffoldMessenger.of(outerContext).showSnackBar(
                      const SnackBar(content: Text("Event deleted")),
                    );
                  }
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("Login to see your events."));
    }

    final eventService = EventService();

    return StreamBuilder<List<CalendarEvent>>(
      stream: eventService.getUserEvents(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final events = snapshot.data ?? [];

        if (events.isEmpty) {
          return const Center(child: Text("No events yet."));
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return EventTile(
              event: event,
              showDay: true,
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventFormScreen(existingEvent: event),
                  ),
                );
              },
              onDelete: () => _showDeleteConfirmation(context, event),
            );
          },
        );
      },
    );
  }
}
