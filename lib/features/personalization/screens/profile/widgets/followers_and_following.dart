import 'package:carboneto/features/personalization/screens/profile/profile.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FollowersAndFollowing extends StatelessWidget {
  const FollowersAndFollowing({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 350),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Column(
              children: [
                HighlightText(
                  textValue: '122',
                  textSize: MediaQuery.of(context).size.width * 0.06,
                ),
                PrimaryText(
                  textValue: 'seguidores',
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              children: [
                HighlightText(
                  textValue: '67',
                  textSize: MediaQuery.of(context).size.width * 0.06,
                ),
                PrimaryText(
                  textValue: 'seguindo',
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              children: [
                HighlightText(
                  textValue: 'PG',
                  textSize: MediaQuery.of(context).size.width * 0.06,
                ),
                PrimaryText(
                  textValue: 'armador',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}