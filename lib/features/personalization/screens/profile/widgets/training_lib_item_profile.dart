import 'package:flutter/material.dart';

class TrainingLibItemProfile extends StatelessWidget {
  const TrainingLibItemProfile({
    super.key, required this.title, required this.description,
  });

  final String title, description;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
      
          Text(
            description,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}