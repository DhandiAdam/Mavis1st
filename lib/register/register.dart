import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegisterScreen> createState() => _Register();
}

class _Register extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 40.0),
              const Text(
                'Halo,',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Buat Akun',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40.0),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Nama Depan',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama depan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Nama Belakang',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama belakang';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email';
                  }
                  if (!value.contains('@')) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Kata Sandi',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan kata sandi';
                  }
                  if (value.length < 6) {
                    return 'Kata sandi harus minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              CheckboxListTile(
                title: const Text(
                    'Dengan melanjutkan, Anda menerima Kebijakan Privasi dan Ketentuan Penggunaan Kami'),
                value: false,
                onChanged: (value) {},
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Proses registrasi
                    print('Nama Depan: ${_firstNameController.text}');
                    print('Nama Belakang: ${_lastNameController.text}');
                    print('Email: ${_emailController.text}');
                    print('Kata Sandi: ${_passwordController.text}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 15.0),
                  textStyle: const TextStyle(fontSize: 18.0),
                ),
                child: const Text('Berikutnya'),
              ),
              const SizedBox(height: 40.0),
              const Center(
                child: Text(
                  'Atau',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      textStyle: const TextStyle(fontSize: 18.0),
                    ),
                    icon: Image.asset(
                      'assets/google_logo.png',
                      height: 24.0,
                    ),
                    label: const Text(
                      'Google',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      textStyle: const TextStyle(fontSize: 18.0),
                    ),
                    icon: const Icon(
                      Icons.facebook,
                      color: Color.fromARGB(255, 2, 199, 28),
                      size: 24.0,
                    ),
                    label: const Text(
                      'Facebook',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Sudah memiliki akun?',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'Masuk',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
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
