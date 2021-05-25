import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:samsung_firmware_downloader/models/firmware.dart';
import 'package:samsung_firmware_downloader/models/firmware_info.dart';

class APIService with ChangeNotifier {
  // Check for working API backend
  bool isWorking = false;
  bool isLoading = false;

  set _isLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  set _isWorking(bool value) {
    isWorking = value;
    notifyListeners();
  }

  List<FirmwareDetail> firmwareList = [];

  //TODO: Convert api service to dio

  static const _host = 'https://samfw.herokuapp.com';

  Future<void> selectAPI(String input) async {
    _isLoading = true;
    const heroku = '.herokuapp.com/openapi.json';
    final uri = Uri.tryParse('https://$input$heroku')!;
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      _isWorking = body['info']['title'] == 'SamFetch';
      print('isWorking $isWorking');
      _isLoading = false;
      notifyListeners();
      return;
    }
    print(response.body);
    _isWorking = false;
    _isLoading = false;
    throw response;
  }

  Future<List<FirmwareDetail>> availableFirmware(
      String region, String model) async {
    final uri = Uri.parse('$_host/api/list?region=$region&model=$model');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final availableFirmware = Firmware.fromJson(decoded);
      final _firmwareList =
          await _getFirmwareInfo(region, model, availableFirmware);
      notifyListeners();
      return firmwareList = _firmwareList;
    }
    print(response.body);
    print(response.reasonPhrase);
    print(response.statusCode);

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
      final data = FirmwareDetail.fromJson(decoded);
      return data;
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
