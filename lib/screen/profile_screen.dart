import 'package:flutter/material.dart';
import 'package:my_project/data/local_user_repository.dart';
import 'package:my_project/models/user.dart';
import 'package:my_project/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _userRepository = LocalUserRepository();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _userRepository.getUser();
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    final updatedUser = User(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: (await _userRepository.getUser())?.password ?? '',
    );

    await _userRepository.saveUser(updatedUser);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  Future<void> _logout() async {
    await _userRepository.clearUser();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final double width =
        MediaQuery.of(context).size.width > 600 ? 400 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF73E9EB),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                            'assets/profile_placeholder.jpg',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Save Changes',
                          onPressed: _saveChanges,
                        ),
                        const SizedBox(height: 10),
                        CustomButton(text: 'Logout', onPressed: _logout),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
