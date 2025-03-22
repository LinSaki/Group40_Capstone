import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/session.dart';
import '../../services/session_service.dart';
import '../../providers/auth_provider.dart';
import 'create_session_page.dart';

class MySessionsPage extends StatefulWidget {
  const MySessionsPage({Key? key}) : super(key: key);

  @override
  State<MySessionsPage> createState() => _MySessionsPageState();
}

class _MySessionsPageState extends State<MySessionsPage> {
  late Future<List<Session>> _futureSessions;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  void _loadSessions() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final rawRole = auth.role?.toLowerCase();
    final apiRole = rawRole == 'patient' ? 'patients' : 'therapists';

    print('Fetching sessions for: $apiRole');
    _futureSessions = SessionService().fetchMySessions(apiRole, auth.token!);
  }

  void _navigateToCreateSession() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateSessionPage()),
    );
    _loadSessions(); 
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sessions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToCreateSession,
          )
        ],
      ),
      body: FutureBuilder<List<Session>>(
        future: _futureSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sessions booked.'));
          }

          final sessions = snapshot.data!;
          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(session.scenarioUsed),
                  subtitle: Text(
                    'Date: ${session.sessionDate}\n'
                    'Duration: ${session.sessionDuration} mins\n'
                    'Feedback: ${session.feedback}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
