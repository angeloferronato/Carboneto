import 'package:carboneto/common/widgets/welcome/welcome_circle_user.dart';
import 'package:carboneto/common/widgets/welcome/welcome_orbit_circle.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final left = -(460 - MediaQuery.of(context).size.width) / 2;
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: CbSizes.xl),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: left,
            child: Stack(
              alignment: Alignment.center,
              children: [
                WelcomeCircleUser(width: 460, height: 460, opacity: .25,),
                
                Stack(
                  alignment: Alignment.center,
                  children: [
                    WelcomeCircleUser(width: 400, height: 400, opacity: .5,),
                    WelcomeOrbitCircle(size: 12, top: 0, right: 150,),
                  ],
                ),
                
                Stack(
                  alignment: Alignment.center,
                  children: [
                    WelcomeCircleUser(width: 340, height: 340, opacity: .7,),
                    
                    WelcomeOrbitCircle(size: 15, top: 115, left: 0,),
    
                    WelcomeOrbitCircle(size: 25, bottom: 45, left: 30,), 

                    WelcomeOrbitCircle(size: 15, top: 90, right: 10,), 
                  ],
                ),
          
                Stack(
                  alignment: Alignment.center,
                  children: [
                    WelcomeCircleUser(width: 280, height: 280, child: Image(
                      image: AssetImage(CbImages.userExample),
                    )),
                    WelcomeOrbitCircle(size: 15, bottom: 20, right: 50,),
                  ],
                ),
 
              ],
            ),
          ),
        ],
      ),
    );
  }
}
