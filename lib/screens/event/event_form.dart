import 'package:flutter/material.dart';
import 'package:flutter_exam/services/notifications_service.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/event_model.dart';
import '../../services/event_service.dart';

class EventFormScreen extends StatefulWidget {
  final CalendarEvent? existingEvent;

  const EventFormScreen({super.key, this.existingEvent});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;

  final _eventService = EventService();
  final _notificationsService = NotificationService();
  final _auth = FirebaseAuth.instance;

  // Add selected color state
  String _selectedColor = "#2196F3";

  // Predefined color choices for the picker (hex strings)
  final List<String> _colorOptions = [
    "#2196F3", // Blue
    "#F44336", // Red
    "#4CAF50", // Green
    "#FF9800", // Orange
    "#9C27B0", // Purple
    "#009688", // Teal
    "#E91E63", // Pink
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingEvent != null) {
      final e = widget.existingEvent!;
      _titleController.text = e.title;
      _descController.text = e.description ?? '';
      _startTime = e.startTime;
      _endTime = e.endTime;
      _selectedColor = e.color ?? "#2196F3";
    }
  }

  void _pickStartTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startTime ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (!mounted) return;
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime:
            _startTime != null
                ? TimeOfDay(hour: _startTime!.hour, minute: _startTime!.minute)
                : TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _startTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (_endTime == null || _endTime!.isBefore(_startTime!)) {
            _endTime = _startTime!.add(const Duration(hours: 1));
          }
        });
      }
    }
  }

  void _pickEndTime() async {
    if (_startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a start time first")),
      );
      return;
    }
    final pickedTime = await showTimePicker(
      context: context,
      initialTime:
          _endTime != null
              ? TimeOfDay(hour: _endTime!.hour, minute: _endTime!.minute)
              : TimeOfDay(
                hour: _startTime!.hour + 1 > 23 ? 23 : _startTime!.hour + 1,
                minute: _startTime!.minute,
              ),
    );
    if (pickedTime != null) {
      setState(() {
        _endTime = DateTime(
          _startTime!.year,
          _startTime!.month,
          _startTime!.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _saveEvent() async {
    if (_titleController.text.isEmpty ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final forcedEndTime = DateTime(
      _startTime!.year,
      _startTime!.month,
      _startTime!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    if (!forcedEndTime.isAfter(_startTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("End time must be after start time")),
      );
      return;
    }

    final user = _auth.currentUser;
    if (user == null) return;

    final newEvent = CalendarEvent(
      id: widget.existingEvent?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      startTime: _startTime!,
      endTime: forcedEndTime,
      createdBy: user.uid,
      color: _selectedColor,
      createdAt: DateTime.now(),
    );

    if (widget.existingEvent != null) {
      await _eventService.updateEvent(newEvent);
    } else {
      await _eventService.createEvent(newEvent);
    }

    await _notificationsService.scheduleNotification(
      id: int.parse(newEvent.id.hashCode.toString()),
      title: newEvent.title,
      eventStartTime: newEvent.startTime,
      body: newEvent.description,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  // Helper to convert hex string to Color
  Color _colorFromHex(String hexColor) {
    final buffer = StringBuffer();
    if (hexColor.length == 6 || hexColor.length == 7) buffer.write('ff');
    buffer.write(hexColor.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingEvent != null ? "Edit Event" : "Add Event"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description (optional)",
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                textStyle: const TextStyle(fontSize: 14),
                minimumSize: const Size(0, 42),
              ),
              onPressed: _pickStartTime,
              child: Text(
                _startTime != null
                    ? "Start: ${_startTime!.toLocal().toString().substring(0, 16)}"
                    : "Pick Start Time",
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                textStyle: const TextStyle(fontSize: 14),
                minimumSize: const Size(0, 42),
              ),
              onPressed: _pickEndTime,
              child: Text(
                _endTime != null
                    ? "End: ${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}"
                    : "Pick End Time",
              ),
            ),

            const SizedBox(height: 24),

            // Color picker UI
            Text(
              "Select Event Color",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: _colorOptions.map((colorHex) {
                final color = _colorFromHex(colorHex);
                final isSelected = colorHex == _selectedColor;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = colorHex;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: Colors.black,
                              width: 2,
                            )
                          : null,
                    ),
                    child: CircleAvatar(
                      backgroundColor: color,
                      radius: 18,
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                minimumSize: const Size(0, 44),
              ),
              onPressed: _saveEvent,
              child: const Text("Save Event"),
            ),
          ],
        ),
      ),
    );
  }
}
