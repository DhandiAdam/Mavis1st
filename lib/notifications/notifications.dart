import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  NotificationsState createState() => NotificationsState();
}

class NotificationsState extends State<Notifications> {
  // Daftar notifikasi contoh
  final List<Map<String, String>> notifications = [
    {
      'title': 'Jangan lupa minum obat anda.',
      'time': '1 menit yang lalu',
      'icon': 'assets/icons/minumobat.png',
    },
    {
      'title': 'Kamu meraih 2000 langkah!',
      'time': '3 jam yang lalu',
      'icon': 'assets/icons/workout.png',
    },
    {
      'title': 'Kalori hari ini sudah terpenuhi.',
      'time': '3 jam yang lalu',
      'icon': 'assets/icons/kalorihari.png',
    },
  ];

  // Fungsi saat notifikasi diklik
  void onNotificationClick(int index) {
    print('Notification $index clicked');
    // Lakukan aksi yang diinginkan saat notifikasi diklik
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return GestureDetector(
            onTap: () => onNotificationClick(index),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 28, // Ukuran CircleAvatar lebih besar
                child: Padding(
                  padding: const EdgeInsets.all(4.0), // Menambahkan padding
                  child: Image.asset(
                    notification['icon']!,
                    width: 40, // Ukuran gambar
                    height: 40,
                    fit: BoxFit.contain, // Agar gambar sesuai dengan oval
                  ),
                ),
              ),
              title: Text(
                notification['title']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                notification['time']!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              trailing: const Icon(Icons.more_vert, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
