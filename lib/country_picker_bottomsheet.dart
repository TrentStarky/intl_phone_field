import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/helpers.dart';

class PickerBottomSheetStyle {
  final Color? backgroundColor;

  final TextStyle? countryCodeStyle;

  final TextStyle? countryNameStyle;

  final Widget? listTileDivider;

  final EdgeInsets? listTilePadding;

  final EdgeInsets? padding;

  final Color? searchFieldCursorColor;

  final InputDecoration? searchFieldInputDecoration;

  final EdgeInsets? searchFieldPadding;

  final double? width;

  final PreferredSizeWidget? appBar;

  PickerBottomSheetStyle({
    this.backgroundColor,
    this.countryCodeStyle,
    this.countryNameStyle,
    this.listTileDivider,
    this.listTilePadding,
    this.padding,
    this.searchFieldCursorColor,
    this.searchFieldInputDecoration,
    this.searchFieldPadding,
    this.width,
    this.appBar,
  });
}

class CountryPickerBottomSheet extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String searchText;
  final List<Country> filteredCountries;
  final PickerBottomSheetStyle? style;

  final bool showFlagAsEmoji;

  CountryPickerBottomSheet({
    Key? key,
    required this.searchText,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.style,
    this.showFlagAsEmoji = false,
  }) : super(key: key);

  @override
  _CountryPickerBottomSheetState createState() =>
      _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.style?.backgroundColor,
      appBar: widget.style?.appBar,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: widget.style?.padding ?? EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: widget.style?.searchFieldPadding ?? EdgeInsets.all(0),
              child: TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                cursorColor: widget.style?.searchFieldCursorColor,
                decoration: widget.style?.searchFieldInputDecoration ??
                    InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      labelText: widget.searchText,
                    ),
                onChanged: (value) {
                  _filteredCountries = isNumeric(value)
                      ? widget.countryList
                          .where((country) => country.dialCode.contains(value))
                          .toList()
                      : widget.countryList
                          .where((country) => country.name
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                  if (this.mounted) setState(() {});
                },
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredCountries.length,
                itemBuilder: (ctx, index) => ListTile(
                  minLeadingWidth: 0,
                  leading: widget.showFlagAsEmoji
                      ? Text(
                          _filteredCountries[index].flag,
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      : Image.asset(
                          'assets/flags/${_filteredCountries[index].code.toLowerCase()}.png',
                          package: 'intl_phone_field',
                          width: 32,
                        ),
                  // contentPadding: widget.style?.listTilePadding,
                  title: Text(
                    _filteredCountries[index].name,
                    style: widget.style?.countryNameStyle ??
                        TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: Text(
                    '+${_filteredCountries[index].dialCode}',
                    style: widget.style?.countryCodeStyle ??
                        TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onTap: () {
                    _selectedCountry = _filteredCountries[index];
                    widget.onCountryChanged(_selectedCountry);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
