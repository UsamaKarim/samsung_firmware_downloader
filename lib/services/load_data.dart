import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:samsung_firmware_downloader/models/csc_model.dart';
import 'package:samsung_firmware_downloader/models/device_model.dart';

class LoadData {
  List<CSC> regionList = [];
  List<Device> deviceList = [];

  Future<void> loadCSC() async {
    final json = await rootBundle.loadString('assets/json/csc_list.json');
    final decoded = jsonDecode(json) as Map<String, dynamic>?;
    decoded?.forEach((key, value) => regionList.add(CSC.fromJson(key, value)));
  }

  Future<void> loadDevices() async {
    final json = await rootBundle.loadString('assets/json/devices.json');
    final decoded = jsonDecode(json) as List<dynamic>?;
    final data = decoded?.map((e) => Device.fromJson(e));
    deviceList.addAll(data!);
  }
}
