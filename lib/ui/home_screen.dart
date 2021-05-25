import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:samsung_firmware_downloader/providers/firmware.dart';
import 'package:samsung_firmware_downloader/services/api_service.dart';
import 'package:samsung_firmware_downloader/services/load_data.dart';
import 'package:samsung_firmware_downloader/ui/device_list.dart';

import 'country_list.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    final load = context.read<LoadData>();
    Future.wait([
      load.loadCSC(),
      load.loadDevices(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Samsung Firmware DM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  // suffix: Text(),
                  prefixText: 'https://',
                  suffixText: '.herokuapp.com',
                  // prefix: Text(),
                  border: OutlineInputBorder(),
                  hintText: 'samfetch',
                  labelText: 'Your app name'),
            ),
            SizedBox(height: 8),
            // RegionCode(),
            RegionCode(),
            SizedBox(height: 8),
            DeviceModel(),
            // SizedBox(height: 40),

            AvailableFirmware(),
          ],
        ),
      ),
    );
  }
}

class AvailableFirmware extends StatefulWidget {
  @override
  _AvailableFirmwareState createState() => _AvailableFirmwareState();
}

class _AvailableFirmwareState extends State<AvailableFirmware> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<APIService, Firmware>(
      builder: (context, apiService, firmware, child2) => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO: Add loading spinner
            OutlinedButton(
              style: ButtonStyle(),
              onPressed: () async {
                await apiService.availableFirmware(
                  firmware.regionCode!,
                  firmware.deviceModel!,
                );
              },
              child: Text('Generate'),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: apiService.firmwareList.length,
                itemBuilder: (context, index) {
                  final api = apiService.firmwareList[index];
                  return ExpansionTile(
                    // leading: CircleAvatar(
                    //   child: Text(api.sizeReadable!),
                    // ),
                    title: Text(
                      firmware.deviceModel! + ' - ' + firmware.regionCode!,
                      // softWrap: true,
                    ),
                    subtitle: Text(api.version! + ' - ' + api.sizeReadable!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
