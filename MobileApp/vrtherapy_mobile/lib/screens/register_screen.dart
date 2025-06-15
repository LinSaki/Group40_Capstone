import 'package:flutter/material.dart';
import 'package:vrtherapy_mobile/screens/welcome_screen.dart';
import '../models/patient_profile.dart';
import '../models/therapist_profile.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'PATIENT';

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();

  // Patient-only
  final _anxietyController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _goalController = TextEditingController();

  // Therapist-only
  final _licenseController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();

  bool _isLoading = false;

  void _submit() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);
  try {
    if (_selectedRole == 'PATIENT') {
      var patient = PatientProfile(
        fullName: _fullNameController.text,
        email: _emailController.text,
        userName: _userNameController.text,
        password: _passwordController.text,
        dateOfBirth: _dobController.text,
        gender: _genderController.text,
        anxietyLevel: double.tryParse(_anxietyController.text),
        heartRate: double.tryParse(_heartRateController.text),
        therapyGoal: _goalController.text,
      );
      await ApiService.registerUser(patient);
    } else {
      var therapist = TherapistProfile(
        fullName: _fullNameController.text,
        email: _emailController.text,
        userName: _userNameController.text,
        password: _passwordController.text,
        dateOfBirth: _dobController.text,
        gender: _genderController.text,
        licenseNumber: _licenseController.text,
        specialization: _specializationController.text,
        experienceYears: int.tryParse(_experienceController.text),
      );
      await ApiService.registerUser(therapist);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful! Please log in.")),
      );

      // Push to WelcomeScreen & remove all previous screens
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (route) => false,
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}


  Widget _buildRoleFields() {
    if (_selectedRole == 'PATIENT') {
      return Column(
        children: [
          TextFormField(controller: _anxietyController, decoration: const InputDecoration(labelText: 'Anxiety Level')),
          TextFormField(controller: _heartRateController, decoration: const InputDecoration(labelText: 'Heart Rate')),
          TextFormField(controller: _goalController, decoration: const InputDecoration(labelText: 'Therapy Goal')),
        ],
      );
    } else {
      return Column(
        children: [
          TextFormField(controller: _licenseController, decoration: const InputDecoration(labelText: 'License Number')),
          TextFormField(controller: _specializationController, decoration: const InputDecoration(labelText: 'Specialization')),
          TextFormField(controller: _experienceController, decoration: const InputDecoration(labelText: 'Years of Experience')),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField(
                  value: _selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'PATIENT', child: Text('Patient')),
                    DropdownMenuItem(value: 'THERAPIST', child: Text('Therapist')),
                  ],
                  onChanged: (value) => setState(() => _selectedRole = value!),
                  decoration: const InputDecoration(labelText: 'Register as'),
                ),
                TextFormField(controller: _fullNameController, decoration: const InputDecoration(labelText: 'Full Name')),
                TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                TextFormField(controller: _userNameController, decoration: const InputDecoration(labelText: 'Username')),
                TextFormField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                TextFormField(controller: _dobController, decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)')),
                TextFormField(controller: _genderController, decoration: const InputDecoration(labelText: 'Gender')),
                const SizedBox(height: 16),
                _buildRoleFields(),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(onPressed: _submit, child: const Text('Register')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
