import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/session_service.dart';
import '../../providers/auth_provider.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({Key? key}) : super(key: key);

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  final _scenarioController = TextEditingController();
  final _durationController = TextEditingController();
  final _feedbackController = TextEditingController();
  DateTime? _selectedDateTime;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submit() async {
    if (_selectedDateTime == null ||
        _scenarioController.text.isEmpty ||
        _durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final payload = {
      'sessionDate': _selectedDateTime!.toIso8601String(),
      'sessionDuration': int.tryParse(_durationController.text) ?? 0,
      'scenarioUsed': _scenarioController.text,
      'feedback': _feedbackController.text,
    };

    try {
      await SessionService().createSession('patients', payload, authProvider.token!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session created successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create session')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Session')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickDateTime,
              child: Text(_selectedDateTime == null
                  ? 'Select Date & Time'
                  : _selectedDateTime.toString()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Session Duration (min)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _scenarioController,
              decoration: InputDecoration(labelText: 'Scenario Used'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(labelText: 'Feedback (optional)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Create Session'),
            ),
          ],
        ),
      ),
    );
  }
}
