import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFF0C356A),
      ),
      body: SettingsList(),
    );
  }
}

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.key),
          title: const Text('Akun'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.public),
          title: const Text('Bahasa'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {},
        ),
        // Add more ListTile widgets for other settings
      ],
    );
  }
}
