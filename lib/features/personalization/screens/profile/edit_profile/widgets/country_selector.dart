import 'package:carboneto/features/personalization/controllers/edit_profile/edit_profile_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/popups/loaders.dart';
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.showLabel ? Text(
          'Localização/País',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800),
        ) : SizedBox(),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
              foregroundColor: WidgetStatePropertyAll(CbColors.darkGrey),
              padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20, vertical: 17)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide.none,
                ),
              ),
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              shadowColor: WidgetStatePropertyAll(Colors.transparent),
              elevation: WidgetStatePropertyAll(0),
              side: WidgetStateBorderSide.resolveWith((states) => BorderSide(color: CbColors.darkGrey)),
            ),
            onPressed: () {
              showCountryPicker(
                context: context,
                onSelect: (Country country) {
                  setState(() {
                    _selectedCountry = country;
                  });
                  editProfileController.changeCode(country.countryCode);
                }
              );
            },
            child: Text(_selectedCountry == null ? 'País' : "${_selectedCountry!.name}  ${_selectedCountry!.flagEmoji}", style: Theme.of(context).textTheme.bodyMedium,),
          ),
        ),
      ]
    );
  }
}