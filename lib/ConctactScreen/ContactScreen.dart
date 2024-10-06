import 'package:flutter/material.dart';
import 'package:mavis/constants/colors.dart';

class ContactSettingsScreen extends StatefulWidget {
  const ContactSettingsScreen({Key? key}) : super(key: key);

  @override
  _ContactSettingsScreenState createState() => _ContactSettingsScreenState();
}

class _ContactSettingsScreenState extends State<ContactSettingsScreen> {
  final List<Map<String, dynamic>> contacts = [
    {'name': 'Bokap', 'number': '08123456789'},
    {'name': 'Kakak', 'number': '08123456780'},
    {'name': 'Abang', 'number': '08123456781'},
    {'name': 'Adek', 'number': '08123456782'},
    {'name': 'Nyokap', 'number': '08123456783'},
  ];

  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  List<Map<String, dynamic>> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = contacts;
  }

  void addContact(String name, String number) {
    setState(() {
      contacts.add({'name': name, 'number': number});
      filteredContacts = contacts;
    });
    nameController.clear();
    numberController.clear();
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
      filteredContacts = contacts;
    });
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
        title: const Text(
          'SOS',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {
              // Add functionality here
            },
          ),
        ],
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
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Tambah Kontak'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(labelText: 'Nama'),
                          ),
                          TextField(
                            controller: numberController,
                            decoration: const InputDecoration(
                                labelText: 'Nomor Telepon'),
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isNotEmpty &&
                                numberController.text.isNotEmpty) {
                              addContact(
                                  nameController.text, numberController.text);
                              Navigator.pop(context);
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
                },
                icon: const Icon(Icons.add, color: AppColors.baseColor2),
                label: const Text('Tambah Kontak',
                    style: TextStyle(color: AppColors.baseColor2)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.baseColor2),
                ),
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
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = filteredContacts[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.person,
                            size: 40, color: AppColors.gray600),
                        title: Text(contact['name']),
                        subtitle: Text(contact['number']),
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
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteContact(index),
                            ),
                          ],
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
