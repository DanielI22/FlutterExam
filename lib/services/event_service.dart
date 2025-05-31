import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_exam/constants/app_constants.dart';
import '../models/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new event
  Future<void> createEvent(CalendarEvent event) async {
    final docRef = _firestore
        .collection(FirestoreCollections.events)
        .doc(event.id);
    await docRef.set(event.toMap());
  }

  // Update an event
  Future<void> updateEvent(CalendarEvent event) async {
    await _firestore
        .collection(FirestoreCollections.events)
        .doc(event.id)
        .update(event.toMap());
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    await _firestore
        .collection(FirestoreCollections.events)
        .doc(eventId)
        .delete();
  }

  // Get all events for a given day
  Stream<List<CalendarEvent>> getAllDayEvents(DateTime day) {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore.collection(FirestoreCollections.events).snapshots().map((
      snapshot,
    ) {
      final events =
          snapshot.docs
              .map((doc) {
                final data = doc.data();
                final startStr =
                    data[CalendarEventConstants.startTime] as String? ?? '';
                final startTime = DateTime.tryParse(startStr);
                if (startTime == null) return null;

                if (startTime.isAfter(
                      startOfDay.subtract(const Duration(seconds: 1)),
                    ) &&
                    startTime.isBefore(endOfDay)) {
                  return CalendarEvent.fromMap(data, doc.id);
                }
                return null;
              })
              .whereType<CalendarEvent>()
              .toList();

      events.sort((a, b) => a.startTime.compareTo(b.startTime));
      return events;
    });
  }

  // Get events created by the current user
  Stream<List<CalendarEvent>> getUserEvents(String userId) {
    return _firestore
        .collection(FirestoreCollections.events)
        .where(CalendarEventConstants.createdBy, isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final events =
              snapshot.docs.map((doc) {
                final data = doc.data();
                return CalendarEvent.fromMap(data, doc.id);
              }).toList();

          events.sort((a, b) => a.startTime.compareTo(b.startTime));
          return events;
        });
  }
}
