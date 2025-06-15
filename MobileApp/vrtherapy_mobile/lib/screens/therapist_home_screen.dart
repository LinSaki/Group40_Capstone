import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class TherapistHomeScreen extends StatelessWidget {
  const TherapistHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final email = auth.email ?? 'Unknown Email';

    return Scaffold(
      appBar: AppBar(
        title: const Text('therapīa', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, $email 👋', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _homeButton(context, 'My Patients', Icons.group),
                  _homeButton(context, 'My Sessions', Icons.calendar_today),
                  _homeButton(context, 'VR Mode', Icons.vrpano),
                  _homeButton(context, 'Scenarios', Icons.view_in_ar),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeButton(BuildContext context, String title, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(title, textAlign: TextAlign.center),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        textStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}
