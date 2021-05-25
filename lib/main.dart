import 'package:flutter/material.dart';
import 'package:samsung_firmware_downloader/providers/firmware.dart';
import 'package:samsung_firmware_downloader/services/api_service.dart';
import 'package:samsung_firmware_downloader/services/load_data.dart';
import 'package:samsung_firmware_downloader/ui/home_screen.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => APIService()),
        Provider(create: (context) => LoadData()),
        Provider(create: (context) => Firmware()),
      ],
      child: MaterialApp(
        title: 'Samsung Firmware DM',
        // theme: ThemeData.dark(),
        home: MainScreen(),
      ),
    );
  }
}
