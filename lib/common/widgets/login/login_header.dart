import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key, required this.title, required this.subtitle,
  });

  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: CbSizes.spaceBtwItems / 2,),
    
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
    
        SizedBox(height: CbSizes.spaceBtwSections,),
      ],
    );
  }
}