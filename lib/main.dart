import 'package:flutter/material.dart';
import 'package:samsung_firmware_downloader/providers/firmware.dart';
import 'package:samsung_firmware_downloader/services/api_service.dart';
import 'package:samsung_firmware_downloader/services/cache.dart';
import 'package:samsung_firmware_downloader/services/load_data.dart';
import 'package:samsung_firmware_downloader/ui/home_screen.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp(this.sharedPreferences);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => APIService()),
        Provider(create: (context) => LoadData()),
        Provider(create: (context) => Firmware()),
        Provider(create: (context) => Cache(sharedPreferences)),
      ],
      child: MaterialApp(
        title: 'Samsung Firmware DM',
        // theme: ThemeData.dark(),
        home: MainScreen(),
      ),
    );
  }
}
