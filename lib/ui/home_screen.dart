import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:samsung_firmware_downloader/models/firmware_info.dart';
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
            SizedBox(height: 40),
            OutlinedButton(
              onPressed: () async {
                final firm = context.read<Firmware>();
                final api = context.read<APIService>();

                await api.availableFirmware(
                    firm.regionCode!, firm.deviceModel!);
              },
              child: Text('Generate'),
            ),
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
    return FutureBuilder(
      builder: (context, snapshot) {
        return Consumer<APIService>(
          builder: (context, value, child) => Expanded(
            child: ListView.builder(
              itemCount: value.firmwareList.length,
              itemBuilder: (context, index) => ListTile(
                title: SingleChildScrollView(
                  child: Text(
                    value.firmwareList[index].filename!,
                    maxLines: 3,
                    // style: TextStyle(),

                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: Text(value.firmwareList[index].sizeReadable!),
                subtitle: Text(value.firmwareList[index].version!),
              ),
            ),
          ),
        );
      },
    );
  }
}
