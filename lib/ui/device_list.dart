import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:samsung_firmware_downloader/models/device_model.dart';
import 'package:samsung_firmware_downloader/providers/firmware.dart';
import 'package:samsung_firmware_downloader/services/load_data.dart';
import 'package:provider/provider.dart';

class DeviceModel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Firmware>(
      builder: (context, provider, child) => DropdownSearch<Device>(
        hint: 'Select Device',
        // clearButton: Icon(Icons.cancel_rounded),
        mode: Mode.DIALOG,
        showSearchBox: true,
        items: context.read<LoadData>().deviceList,
        showSelectedItem: true,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        showClearButton: true,
        validator: (value) =>
            value == null ? 'Please select your device' : null,
        searchBoxDecoration: InputDecoration(
          labelText: 'Search...',
          border: OutlineInputBorder(),
        ),
        emptyBuilder: (context, searchEntry) =>
            Center(child: Text('No result')),
        onChanged: (value) {
          if (value != null) {
            provider.deviceModel = value.model;
          }
        },
        compareFn: (item, selectedItem) => false,
      ),
    );
  }
}
