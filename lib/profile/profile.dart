import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // To handle file from gallery

class Profile extends StatefulWidget {
  final String currentName;
  final Function(String) updateName;

  Profile({required this.currentName, required this.updateName});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isNotificationOn = false;
  late String _name;
  String _height = '180cm';
  String _weight = '60kg';
  String _age = '20 Tahun';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _name = widget.currentName;
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  void _editProfile() {
    TextEditingController nameController = TextEditingController(text: _name);
    TextEditingController heightController =
        TextEditingController(text: _height);
    TextEditingController weightController =
        TextEditingController(text: _weight);
    TextEditingController ageController = TextEditingController(text: _age);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: heightController,
                decoration: const InputDecoration(labelText: 'Tinggi'),
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Berat'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Usia'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _name = nameController.text;
                  _height = heightController.text;
                  _weight = weightController.text;
                  _age = ageController.text;
                });
                widget.updateName(_name);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _name);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Row for Profile Picture, Name, and Edit Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture (Oval)
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green.withOpacity(0.2),
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/icons/profile_image.png')
                                as ImageProvider,
                      ),
                    ),
                    const SizedBox(
                        width: 20), // Adjust spacing between avatar and name
                    // Name and Edit Button in one Row
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Align items properly
                        children: [
                          Text(
                            _name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _editProfile,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats (Height, Weight, Age)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(_height, "Tinggi"),
                  _buildStatCard(_weight, "Berat"),
                  _buildStatCard(_age, "Usia"),
                ],
              ),
              const SizedBox(height: 32),

              // Account Section
              _buildSection("Akun", [
                _buildListTile(
                    'assets/icons/Icon-Profile.png', "Data Pribadi", () {}),
                _buildListTile(
                    'assets/icons/Icon-Achievement.png', "Pencapaian", () {}),
                _buildListTile('assets/icons/Icon-Activity.png',
                    "Riwayat Aktivitas", () {}),
                _buildListTile(
                    'assets/icons/Icon-Workout.png', "Kemajuan Latihan", () {}),
              ]),
              const SizedBox(height: 32),

              // Notification Section
              _buildSection("Notifikasi", [
                _buildSwitchTile(Icons.notifications, "Notifikasi Pop-up"),
              ]),
              const SizedBox(height: 32),

              // Others Section
              _buildSection("Lainnya", [
                _buildListTile(
                    'assets/icons/Icon-Message.png', "Hubungi Kami", () {}),
                _buildListTile('assets/icons/Icon-Privacy.png',
                    "Kebijakan Privasi", () {}),
                _buildListTile(
                    'assets/icons/Icon-Setting.png', "Pengaturan", () {}),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Column(children: children),
      ],
    );
  }

  Widget _buildListTile(String imagePath, String title, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 30,
        height: 30,
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(IconData icon, String title) {
    return SwitchListTile(
      value: _isNotificationOn,
      onChanged: (value) {
        setState(() {
          _isNotificationOn = value;
        });
      },
      title: Text(title),
    );
  }
}
