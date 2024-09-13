import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isNotificationOn = false;
  int _selectedIndex = 3; // Index for 'Profile' tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Add navigation logic here based on index if necessary
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              const Text(
                "Admin!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard("180cm", "Tinggi"),
                  _buildStatCard("60kg", "Berat"),
                  _buildStatCard("20yo", "Usia"),
                ],
              ),
              const SizedBox(height: 32),

              // Account Section
              _buildSection("Akun", [
                _buildListTile('assets/icons/Icon-Profile.png', "Data Pribadi"),
                _buildListTile(
                    'assets/icons/Icon-Achievement.png', "Pencapaian"),
                _buildListTile(
                    'assets/icons/Icon-Activity.png', "Riwayat Aktivitas"),
                _buildListTile(
                    'assets/icons/Icon-Workout.png', "Kemajuan Latihan"),
              ]),
              const SizedBox(height: 32),

              // Notification Section
              _buildSection("Notifikasi", [
                _buildSwitchTile(Icons.notifications, "Notifikasi Pop-up"),
              ]),
              const SizedBox(height: 32),

              // Lainnya Section
              _buildSection("Lainnya", [
                _buildListTile('assets/icons/Icon-Message.png', "Hubungi Kami"),
                _buildListTile(
                    'assets/icons/Icon-Privacy.png', "Kebijakan Privasi"),
                _buildListTile('assets/icons/Icon-Setting.png', "Pengaturan"),
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
        borderRadius: BorderRadius.circular(8),
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

  Widget _buildListTile(String imagePath, String title) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 30,
        height: 30,
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
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
