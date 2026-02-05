import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_text.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/primary_text.dart';
import 'package:carboneto/utils/mappers/position_mapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FollowersAndFollowing extends StatelessWidget {
  const FollowersAndFollowing({super.key, required this.following, required this.followers, required this.position});

  final int following, followers;
  final String position;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 350),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HighlightText(
                  textValue: followers.toString(),
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
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HighlightText(
                  textValue: following.toString(),
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
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HighlightText(
                  textValue: PositionMapper().toAbreviatte(position.toLowerCase()).toUpperCase(),
                  textSize: MediaQuery.of(context).size.width * 0.06,
                ),
                PrimaryText(
                  textValue: position,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

