import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:samsung_firmware_downloader/models/firmware.dart';
import 'package:samsung_firmware_downloader/models/firmware_info.dart';

class APIService with ChangeNotifier {
  // Check for working API backend
  bool? isWorking;

  List<FirmwareDetail> firmwareList = [];

  //TODO: Convert api service to dio

  static const _host = 'https://samfw.herokuapp.com';

  Future<void> selectAPI({String? input}) async {
    const heroku = '.herokuapp.com/openapi.json';
    final uri = Uri.tryParse('https://samfw$heroku')!;
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['info']['title'] == 'SamFetch') {
        isWorking = true;
      }
    }
  }

  Future<List<FirmwareDetail>> availableFirmware(
      String region, String model) async {
    final uri = Uri.parse('$_host/api/list?region=$region&model=$model');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final availableFirmware = Firmware.fromJson(decoded);
      final _fwList = await _getFirmwareInfo(region, model, availableFirmware);
      notifyListeners();
      return firmwareList = _fwList;
    }
    print(response.body);
    print(response.reasonPhrase);
    print(response.statusCode);
    // TODO: Add exception if no firmware found
    throw response;
  }

  Future<FirmwareDetail> _firmwareInfo(
    String region,
    String model,
    String firmware,
  ) async {
    final uri = Uri.parse(
        '$_host/api/binary?region=$region&model=$model&firmware=$firmware');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      print(decoded);
      final f = FirmwareDetail.fromJson(decoded);
      print('Firmware check ${f.filename}');

      return f;
    }
    throw response;
  }

  Future<List<FirmwareDetail>> _getFirmwareInfo(
    String region,
    String model,
    Firmware firmware,
  ) async {
    return Future.wait([
      _firmwareInfo(region, model, firmware.latest!),
      for (var i in firmware.alternate!) _firmwareInfo(region, model, i),
    ]);
  }
}
