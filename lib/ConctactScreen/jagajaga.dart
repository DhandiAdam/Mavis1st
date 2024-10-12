import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk TextInputFormatter
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mavis/constants/colors.dart';

class ContactSettingsScreen extends StatefulWidget {
  const ContactSettingsScreen({Key? key}) : super(key: key);

  @override
  _ContactSettingsScreenState createState() => _ContactSettingsScreenState();
}

class _ContactSettingsScreenState extends State<ContactSettingsScreen> {
  List<Map<String, dynamic>> contacts = [];

  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  bool _isNameValid = true;
  bool _isNumberValid = true;
  List<Map<String, dynamic>> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts(); // Load contacts from local storage
  }

  Future<void> _saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('contacts', jsonEncode(contacts));
  }

  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsData = prefs.getString('contacts');

    if (contactsData != null) {
      setState(() {
        contacts = List<Map<String, dynamic>>.from(jsonDecode(contactsData))
            .map((contact) {
          return {
            'name': contact['name'] ?? 'Unknown Name',
            'number': contact['number'] ?? 'Unknown Number',
          };
        }).toList();
        filteredContacts = contacts;
      });
    } else {
      print("No contacts found.");
    }
  }

  void addContact(String name, String number) {
    if (name.isEmpty || number.isEmpty) {
      print("Name or number cannot be empty");
      return;
    }

    setState(() {
      contacts.add({'name': name, 'number': number});
      filteredContacts = contacts;
      _saveContacts();
    });
    nameController.clear();
    numberController.clear();
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
      filteredContacts = contacts;
      _saveContacts();
    });
  }

  void editContact(int index, String newName, String newNumber) {
    setState(() {
      contacts[index]['name'] = newName;
      contacts[index]['number'] = newNumber;
      filteredContacts = contacts;
      _saveContacts();
    });
  }

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus',
            style: TextStyle(color: Colors.white)),
        content: const Text('Apakah Anda yakin ingin menghapus kontak ini?',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red.shade400,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Batalkan penghapusan
            },
            child: const Text('Batal', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              deleteContact(index);
              Navigator.pop(context); // Hapus dan tutup dialog
            },
            child: const Text('Hapus'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red.shade400,
            ),
          ),
        ],
      ),
    );
  }

  void searchContacts(String query) {
    final results = contacts.where((contact) {
      final nameLower = contact['name'].toLowerCase();
      final numberLower = contact['number'].toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower) ||
          numberLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredContacts = results;
    });
  }

  void showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Kontak'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama',
                errorText: _isNameValid ? null : 'Nama tidak boleh kosong',
              ),
            ),
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                errorText: _isNumberValid ? null : 'Nomor tidak valid',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  numberController.text.length >= 10) {
                addContact(nameController.text, numberController.text);
                Navigator.pop(context);
              } else {
                setState(() {
                  _isNameValid = nameController.text.isNotEmpty;
                  _isNumberValid = numberController.text.length >= 10;
                });
              }
            },
            child: const Text('Tambah'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void showEditContactDialog(BuildContext context, int index) {
    final nameController = TextEditingController(text: contacts[index]['name']);
    final numberController =
        TextEditingController(text: contacts[index]['number']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Kontak'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama',
                errorText: _isNameValid ? null : 'Nama tidak boleh kosong',
              ),
            ),
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                errorText: _isNumberValid ? null : 'Nomor tidak valid',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isNameValid = nameController.text.isNotEmpty;
                _isNumberValid = numberController.text.length >= 10;

                if (_isNameValid && _isNumberValid) {
                  editContact(
                      index, nameController.text, numberController.text);
                  Navigator.pop(context);
                }
              });
            },
            child: const Text('Simpan'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void showEditContactList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: filteredContacts.length,
          itemBuilder: (context, index) {
            final contact = filteredContacts[index];
            return ListTile(
              title: Text(contact['name']),
              subtitle: Text(contact['number']),
              onTap: () {
                Navigator.pop(context);
                showEditContactDialog(context, index);
              },
            );
          },
        );
      },
    );
  }

  void showInfoPrompt(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lihat Detail Kontak?'),
        content:
            const Text('Apakah Anda ingin melihat detail dari kontak ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog tanpa melihat detail
            },
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup prompt dialog
              showContactDetails(context, index); // Tampilkan detail kontak
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  void showContactDetails(BuildContext context, int index) {
    if (contacts.isNotEmpty && index < contacts.length) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Detail Kontak'),
          content: Text(
            'Nama: ${contacts[index]['name']}\nNomor Telepon: ${contacts[index]['number']}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text('SOS', style: TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengaturan Kontak',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      searchContacts('');
                    },
                  ),
                ),
                onChanged: (value) => searchContacts(value),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showAddContactDialog(context);
                    },
                    icon: const Icon(Icons.add, color: AppColors.baseColor2),
                    label: const Text('Tambah Kontak',
                        style: TextStyle(color: AppColors.baseColor2)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.baseColor2),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                      showEditContactList(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = filteredContacts[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Konfirmasi Hapus',
                              style: TextStyle(color: Colors.white)),
                          content: const Text(
                              'Apakah Anda yakin ingin menghapus kontak ini?',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.red.shade400,
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                deleteContact(index);
                                Navigator.pop(context, true);
                              },
                              child: const Text('Hapus'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          onTap: () {
                            showInfoPrompt(context, index);
                          },
                          leading: const Icon(Icons.person,
                              size: 40, color: AppColors.gray600),
                          title: Text(
                            contact['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  contact['number'],
                                  style: const TextStyle(
                                      color: AppColors.gray700, fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.call,
                                    color: AppColors.baseColor2),
                                onPressed: () {
                                  // Call functionality
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.message,
                                    color: AppColors.baseColor2),
                                onPressed: () {
                                  // Message functionality
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  confirmDelete(index);
                                },
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
