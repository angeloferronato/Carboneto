import 'package:carboneto/common/styles/spacing_styles.dart';
import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen ({super.key, required this.title, required this.subtitle, required this.image, required this.onPressed});

  final String title, subtitle;
  final Widget image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CbAppBar(),
      body: Padding(
        padding: CbSpacingStyle.paddingWithAppBarHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              image,

              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 21),
              ),
              const SizedBox(height: CbSizes.spaceBtwSections,),

              Text(
                subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CbSizes.spaceBtwSections,),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed, 
                  child: Text(CbTexts.cbContinue)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}