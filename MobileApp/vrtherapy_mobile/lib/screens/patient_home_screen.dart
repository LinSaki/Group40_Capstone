import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final email = auth.email ?? 'Unknown Email';

    return Scaffold(
      appBar: AppBar(
        title: const Text('therapīa', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xFFB8C1EC), 
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, $email 👋', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _homeButton(context, 'My Profile', Icons.person, Color(0xFFFAE1DD)),
                  _homeButton(context, 'My Sessions', Icons.calendar_today, Color(0xFFF8EDEB)),
                  _homeButton(context, 'My Records', Icons.insert_chart, Color(0xFFD8E2DC)),
                  _homeButton(context, 'VR Mode', Icons.vrpano, Color(0xFFB8C1EC)),
                  _homeButton(context, 'Chatbot', Icons.chat_bubble, Color(0xFFFFE5D9)),
                  _homeButton(context, 'Meditation', Icons.self_improvement, Color(0xFFCCD5AE)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeButton(BuildContext context, String title, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
