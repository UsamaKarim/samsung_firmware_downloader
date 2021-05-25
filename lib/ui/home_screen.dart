import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samsung_firmware_downloader/providers/firmware.dart';
import 'package:samsung_firmware_downloader/services/api_service.dart';
import 'package:samsung_firmware_downloader/services/cache.dart';
import 'package:samsung_firmware_downloader/services/load_data.dart';
import 'package:samsung_firmware_downloader/ui/device_list.dart';

import 'country_list.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? api;
  late String? initialValue;
  @override
  void initState() {
    super.initState();
    final load = context.read<LoadData>();
    Future.wait([
      load.loadCSC(),
      load.loadDevices(),
    ]);
    initialValue = context.read<Cache>().loadAppName();
    print(initialValue);
  }

  Future<void> addAPI(APIService apiService, Cache cache) async {
    if (api != null) {
      try {
        await apiService.selectAPI(api!);
        if (apiService.isWorking) {
          await cache.saveAppName(api!);
        }
      } on SocketException catch (e) {
        print(e);
      } catch (e) {
        await cache.clearCache();
      }
    }
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
            Consumer2<APIService, Cache>(
              builder: (context, apiService, cache, child) => TextFormField(
                initialValue: initialValue ?? '',
                onChanged: (value) => api = value,
                decoration: InputDecoration(
                  prefixText: 'https://',
                  suffixIcon: IconButton(
                      icon: apiService.isLoading
                          ? CircularProgressIndicator()
                          : Icon(Icons.done),
                      onPressed: () async => await addAPI(apiService, cache)),
                  suffixText: '.herokuapp.com',
                  border: OutlineInputBorder(),
                  hintText: 'samfetch',
                  labelText: 'Hosted app name',
                ),
              ),
            ),
            SizedBox(height: 8),
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
    return Consumer3<APIService, Firmware, Cache>(
      builder: (context, apiService, firmware, cache, child) => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO: Add loading spinner
            OutlinedButton(
              style: ButtonStyle(),
              onPressed: cache.loadAppName() != null
                  ? () async {
                      try {
                        await apiService.availableFirmware(
                          firmware.regionCode!,
                          firmware.deviceModel!,
                        );
                      } catch (e) {
                        // TODO: Add exception if no firmware found
                        print(e);
                      }
                    }
                  : null,
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
                    title: Text(
                      firmware.deviceModel! + ' - ' + firmware.regionCode!,
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
