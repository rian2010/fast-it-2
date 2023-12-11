import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Notifikasi',
          ),
          backgroundColor: const Color(0xFF0C356A)),
      body: Container(
          color: Color.fromARGB(255, 239, 237, 237), child: NotificationList()),
    );
  }
}

class NotificationList extends StatelessWidget {
  // Sample list of notifications with associated images
  final List<Map<String, String>> notifications = [
    {
      'message': 'Laporan masuk silahkan Verifikasi terlebih dahulu.',
      'image': 'lib/images/school.jpg',
      'time': '2 menit yang lalu',
    },
    {
      'message': 'Laporan masuk silahkan Verifikasi terlebih dahulu.',
      'image': 'lib/images/school.jpg',
      'time': '9 jam yang lalu',
    },
    {
      'message': 'Laporan telah di perbaiki, Lihat detail laporan',
      'image': 'lib/images/school.jpg',
      'time': '12 jam yang lalu',
    },
    {
      'message': 'Laporan telah di diperbaiki, Lihat detail laporan',
      'image': 'lib/images/school.jpg',
      'time': '1 minggu yang lalu',
    },
    {
      'message': 'Laporan telah di diperbaiki, Lihat detail laporan',
      'image': 'lib/images/school.jpg',
      'time': '1 hari yang lalu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> terbaruNotifications = notifications
        .where((notification) =>
            parseTimeDifference(notification['time']!) <
            const Duration(hours: 24))
        .toList();

    final List<Map<String, String>> terdahuluNotifications = notifications
        .where((notification) =>
            parseTimeDifference(notification['time']!) >=
            const Duration(hours: 24))
        .toList();

    return ListView(
      children: [
        if (terbaruNotifications.isNotEmpty)
          const ListTile(
            title: Text(
              'Terbaru ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        for (var notification in terbaruNotifications)
          buildNotificationItem(context, notification),
        if (terdahuluNotifications.isNotEmpty)
          const ListTile(
            title: Text(
              'Terdahulu ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        for (var notification in terdahuluNotifications)
          buildNotificationItem(context, notification),
      ],
    );
  }

  Duration parseTimeDifference(String timeString) {
    final timeParts = timeString.split(' ');
    final timeValue = int.parse(timeParts[0]);
    final timeUnit = timeParts[1];
    if (timeUnit == 'menit') {
      return Duration(minutes: timeValue);
    } else if (timeUnit == 'jam') {
      return Duration(hours: timeValue);
    } else if (timeUnit == 'minggu') {
      return Duration(days: timeValue * 7);
    }
    return Duration.zero;
  }

  Widget buildNotificationItem(
      BuildContext context, Map<String, String> notification) {
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage(notification['image']!),
            radius: 35,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['message']!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              'Sent ${notification['time']}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Notification Details'),
                content: Text(notification['message']!),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
