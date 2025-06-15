import 'package:flutter/material.dart';
import '../../models/session.dart';
import '../../services/session_service.dart';

class EditSessionPage extends StatefulWidget {
  final Session session;
  final String role;
  final String token;

  const EditSessionPage({required this.session, required this.role, required this.token});

  @override
  State<EditSessionPage> createState() => _EditSessionPageState();
}

class _EditSessionPageState extends State<EditSessionPage> {
  late TextEditingController _scenarioController;
  late TextEditingController _durationController;
  late TextEditingController _feedbackController;

  @override
  void initState() {
    super.initState();
    _scenarioController = TextEditingController(text: widget.session.scenarioUsed);
    _durationController = TextEditingController(text: widget.session.sessionDuration.toString());
    _feedbackController = TextEditingController(text: widget.session.feedback);
  }

  Future<void> _submit() async {
    final payload = {
      'sessionDate': widget.session.sessionDate.toIso8601String(),
      'sessionDuration': int.parse(_durationController.text),
      'scenarioUsed': _scenarioController.text,
      'feedback': _feedbackController.text,
    };

    await SessionService().updateSession(widget.role, widget.session.sessionId, payload, widget.token);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Session')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _scenarioController, decoration: InputDecoration(labelText: 'Scenario Used')),
            TextField(controller: _durationController, decoration: InputDecoration(labelText: 'Duration (min)'), keyboardType: TextInputType.number),
            TextField(controller: _feedbackController, decoration: InputDecoration(labelText: 'Feedback')),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _submit, child: Text('Save Changes')),
          ],
        ),
      ),
    );
  }
}
