import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:samsung_firmware_downloader/models/csc_model.dart';
import 'package:samsung_firmware_downloader/providers/firmware.dart';
import 'package:samsung_firmware_downloader/services/load_data.dart';
import 'package:provider/provider.dart';

class RegionCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Firmware>(
      builder: (context, provider, child) => DropdownSearch<CSC>(
        hint: 'Country Code',
        // clearButton: Icon(Icons.cancel_rounded),
        mode: Mode.DIALOG,
        showSearchBox: true,
        items: context.read<LoadData>().regionList,
        showSelectedItem: true,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        showClearButton: true,
        validator: (value) =>
            value == null ? 'Please select country code' : null,
        searchBoxDecoration: InputDecoration(
          labelText: 'Search...',
          border: OutlineInputBorder(),
        ),
        emptyBuilder: (context, searchEntry) =>
            Center(child: Text('No result')),
        onChanged: (value) {
          if (value != null) {
            provider.regionCode = value.regionCode;
          }
        },
        compareFn: (item, selectedItem) => false,
      ),
    );
  }
}
