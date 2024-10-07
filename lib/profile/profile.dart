import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Untuk menangani file dari galeri
import 'package:flutter_blue/flutter_blue.dart'; // Untuk menangani Bluetooth

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

  // Bluetooth-related variables
  bool _isBluetoothOn = false;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> _connectedDevices = [];
  List<ScanResult> _availableDevices = [];

  @override
  void initState() {
    super.initState();
    _name = widget.currentName;
    _checkBluetoothStatus();
    _getConnectedDevices(); // Ambil perangkat Bluetooth yang terhubung
  }

  // Fungsi untuk memeriksa status Bluetooth
  Future<void> _checkBluetoothStatus() async {
    bool isOn = await flutterBlue.isOn;
    setState(() {
      _isBluetoothOn = isOn;
      if (_isBluetoothOn) {
        _startScan(); // Mulai scan perangkat Bluetooth saat Bluetooth menyala
      }
    });
  }

  // Fungsi untuk mendapatkan perangkat Bluetooth yang tersambung
  Future<void> _getConnectedDevices() async {
    List<BluetoothDevice> devices = await flutterBlue.connectedDevices;
    setState(() {
      _connectedDevices = devices;
    });
  }

  // Fungsi untuk memulai pemindaian perangkat Bluetooth yang tersedia
  void _startScan() {
    _availableDevices.clear();
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      setState(() {
        _availableDevices = results;
      });
    });
  }

  // Fungsi untuk menangani image picker
  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  // Fungsi untuk membuka dialog edit profil
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

  // Fungsi untuk menampilkan perangkat Bluetooth di sekitar
  void _showBluetoothDevices() {
    if (_isBluetoothOn) {
      _startScan();
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            children: [
              // Daftar Perangkat Terhubung
              ListTile(
                title: Text('Perangkat yang Dipasangkan'),
                subtitle: Text('Perangkat-perangkat yang sudah terhubung'),
              ),
              for (var device in _connectedDevices)
                ListTile(
                  leading: Icon(Icons.devices),
                  title: Text(
                      device.name.isEmpty ? 'Unknown Device' : device.name),
                  subtitle: Text(device.id.toString()),
                  trailing: const Icon(Icons.check),
                  onTap: () {
                    print('Device ${device.name} tapped');
                    Navigator.pop(
                        context); // Tutup dialog setelah memilih perangkat
                  },
                ),
              const Divider(),

              // Daftar Perangkat Tersedia
              ListTile(
                title: Text('Perangkat yang Tersedia'),
                subtitle:
                    Text('Perangkat Bluetooth di sekitar yang belum terhubung'),
              ),
              for (var result in _availableDevices)
                ListTile(
                  leading: Icon(Icons.devices_other),
                  title: Text(result.device.name.isEmpty
                      ? 'Unknown Device'
                      : result.device.name),
                  subtitle: Text(result.device.id.toString()),
                  onTap: () {
                    print('Selected device: ${result.device.name}');
                    // Tambahkan logika untuk menghubungkan perangkat
                    Navigator.pop(context);
                  },
                ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Harap aktifkan Bluetooth terlebih dahulu!')),
      );
    }
  }

  // Fungsi untuk menyalakan atau mematikan Bluetooth
  Future<void> _toggleBluetooth() async {
    bool isOn = await flutterBlue.isOn;
    if (isOn) {
      // Bluetooth tidak bisa dimatikan secara langsung, harus dari pengaturan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Matikan Bluetooth dari pengaturan perangkat.'),
        ),
      );
    } else {
      // Meminta pengguna untuk menghidupkan Bluetooth melalui aplikasi
      flutterBlue.startScan();
      setState(() {
        _isBluetoothOn = true;
      });
      _getConnectedDevices();
    }
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
                    const SizedBox(width: 20),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

              // Bluetooth status dan perangkat
              Row(
                children: [
                  const Text(
                    "Bluetooth Status: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _isBluetoothOn,
                    onChanged: (value) {
                      _toggleBluetooth(); // Menangani aksi menghidupkan/mematikan Bluetooth
                    },
                  ),
                  Text(
                    _isBluetoothOn ? "Aktif" : "Tidak Aktif",
                    style: TextStyle(
                      color: _isBluetoothOn ? Colors.green : Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bagian Perangkat Saya (Smartwatch)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Perangkat saya",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed:
                              _showBluetoothDevices, // Menampilkan perangkat Bluetooth
                        ),
                      ],
                    ),
                    // Tampilkan daftar perangkat Bluetooth yang terhubung
                    Column(
                      children: _connectedDevices.map((device) {
                        return ListTile(
                          title: Text(device.name.isEmpty
                              ? 'Unknown Device'
                              : device.name),
                          subtitle: Text(device.id.toString()),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

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
