import 'package:carboneto/features/personalization/controllers/edit_profile/edit_profile_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CbCountrySelector extends StatefulWidget {
  const CbCountrySelector({super.key, this.showLabel = true});

  final bool showLabel;

  @override
  State<CbCountrySelector> createState() => _CbCountrySelectorState();
}

class _CbCountrySelectorState extends State<CbCountrySelector> {
  Country? _selectedCountry = Country.tryParse(UserController.instance.user.value.countryCode);

  @override
  Widget build(BuildContext context) {
    final editProfileController = Get.put(EditProfileController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel)
          const Text(
            'Localização/País',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              countryListTheme: CountryListThemeData(
                backgroundColor: CbColors.dark,
                bottomSheetHeight: 600,
              ),
              showSearch: false,
              favorite: ['BR', 'US', 'PT'],
              onSelect: (Country country) {
                setState(() => _selectedCountry = country);
                editProfileController.changeCode(country.countryCode);
              },
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0x31467CB8),
                  Color(0x61152E42),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: const Color(0xFF223142),
                width: 1,
              ),
            ),
            child: Text(
              _selectedCountry == null
                  ? 'País'
                  : '${_selectedCountry!.name}  ${_selectedCountry!.flagEmoji}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}