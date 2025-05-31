import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_exam/screens/home/calendar_screen.dart';
import '../event/event_form.dart';
import '../profile/profile_screen.dart';
import '../event/my_events_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String? _userName;
  final user = FirebaseAuth.instance.currentUser;

  final List<Widget> _screens = [
    const CalendarScreen(),
    const MyEventsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        _userName = doc.data()?['name'] ?? user!.email;
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onFabPressed() {
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login to add events")));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EventFormScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = user == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isGuest
              ? "Guest Mode"
              : (_userName != null ? "Welcome, $_userName" : "Welcome..."),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calendar",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "My Events"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'calendarFab',
        onPressed: _onFabPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
