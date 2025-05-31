import 'package:flutter/material.dart';
import '../../models/event_model.dart';
import 'package:intl/intl.dart';

class EventTile extends StatelessWidget {
  final CalendarEvent event;
  final bool showDay;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EventTile({
    super.key,
    required this.event,
    this.showDay = false,
    this.onEdit,
    this.onDelete,
  });

  // Helper to convert hex string like "#2196F3" to Color
  Color _colorFromHex(String hexColor) {
    final buffer = StringBuffer();
    if (hexColor.length == 6 || hexColor.length == 7) buffer.write('ff'); // add opacity if missing
    buffer.write(hexColor.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dayFormat = DateFormat('dd/MM/yyyy');
    final eventColor = event.color != null ? _colorFromHex(event.color!) : Colors.blue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Color indicator bar
              Container(
                width: 6,
                height: 60,
                decoration: BoxDecoration(
                  color: eventColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),

              if (showDay)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 80,
                    child: Text(
                      dayFormat.format(event.startTime),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    if (event.description != null &&
                        event.description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.description!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (onEdit != null || onDelete != null)
                Column(
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: onEdit,
                        tooltip: 'Edit Event',
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete,
                            size: 20, color: Colors.redAccent),
                        onPressed: onDelete,
                        tooltip: 'Delete Event',
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
