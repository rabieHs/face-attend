import 'package:attendence/services/authentication.dart';
import 'package:flutter/material.dart';
import 'student.dart';
import 'invigilator.dart';
import 'camera.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          //constraints: const BoxConstraints(maxWidth: 360),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 0.557,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    BackgroundImage(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 275, 30, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          LoginForm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _universityId = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('University ID', 'Type here ID', false, (value) {
            _universityId = value ?? '';
          }, (value) {
            return value == null || value.isEmpty
                ? 'Please enter your University ID'
                : null;
          }),
          const SizedBox(height: 16),
          _buildTextField('Password', 'Type here password', true, (value) {
            _password = value ?? '';
          }, (value) {
            return value == null || value.isEmpty
                ? 'Please enter your password'
                : null;
          }),
          const SizedBox(height: 22),
          Center(
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E8E93),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 9),
                minimumSize: const Size(240, 0),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, bool isPassword,
      Function(String?) onSaved, String? Function(String?)? validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black)),
        const SizedBox(height: 10),
        TextFormField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF8B8888)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          ),
          onSaved: onSaved,
          validator: validator,
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_universityId == 'camera' && _password == 'admin12345') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CameraPage()),
        );
      }
      // Navigate to the appropriate interface based on the input
      bool result =
          await AuthenticationServices().loginUser(_universityId, _password);
      if (result) {
        if (_universityId.startsWith('2')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (_universityId.startsWith('0')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyComponent()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid University ID or Password')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid University ID or Password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://cdn.builder.io/api/v1/image/assets/TEMP/c8f696a5e510ad14f18c3879b9de41934863129a37c26aaa8b41b147634e42ed?placeholderIfAbsent=true&apiKey=d8f66a03e3a84a08a7b48b30dfb4cd0b',
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.error, color: Colors.red),
          ),
        );
      },
    );
  }
}
