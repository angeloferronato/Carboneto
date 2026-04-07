import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_text.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/primary_text.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/mappers/position_mapper.dart';
import 'package:flutter/material.dart';

class FollowersAndFollowing extends StatelessWidget {
  const FollowersAndFollowing(
      {super.key,
      required this.following,
      required this.followers,
      required this.position,
      required this.followersOnTap,
      required this.followingOnTap,
      this.positionOnTap});

  final int following, followers;
  final String position;
  final VoidCallback followersOnTap;
  final VoidCallback followingOnTap;
  final VoidCallback? positionOnTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 350),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: InkWell(
              onTap: followersOnTap,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HighlightText(
                    textValue:
                        CbHelperFunctions.formatCountFollowType(followers),
                    textSize: MediaQuery.of(context).size.width * 0.06,
                  ),
                  PrimaryText(
                    textValue: 'seguidores',
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: InkWell(
              onTap: followingOnTap,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HighlightText(
                    textValue:
                        CbHelperFunctions.formatCountFollowType(following),
                    textSize: MediaQuery.of(context).size.width * 0.06,
                  ),
                  PrimaryText(
                    textValue: 'seguindo',
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: InkWell(
              onTap: positionOnTap,
              child: Column(
                children: [
                  position == "Treinador"
                      ? Icon(Icons.sports, color: CbColors.primary, size: MediaQuery.of(context).size.width * 0.08,)
                      : HighlightText(
                          textValue: PositionMapper()
                              .toAbreviatte(position.toLowerCase())
                              .toUpperCase(),
                          textSize: MediaQuery.of(context).size.width * 0.06,
                        ),
                  PrimaryText(
                    textValue: position,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
