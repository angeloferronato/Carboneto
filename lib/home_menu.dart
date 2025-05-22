import 'package:carboneto/common/custom_shapes/curved_edges/home/curved_edges_widget.dart';
import 'package:carboneto/common/custom_shapes/curved_edges/home/custom_curved_edges.dart';
import 'package:carboneto/common/widgets/navigation_bar/navigation_destination.dart';
import 'package:carboneto/features/training/screens/home/home.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu ({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeMenuController());
    final bool isDarkTheme = CbHelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: isDarkTheme ? CbColors.dark : CbColors.light,
      bottomNavigationBar: Obx(
        () => CurvedEdgesWidget(
          shadow: Shadow(
            blurRadius: 15,
            color: isDarkTheme ? Colors.black.withValues(alpha: 0.3) : CbColors.dark.withValues(alpha: 0.3),
          ),
          clipper: CbCustomCurvedEdges(),
          child: Container(
            color: Colors.transparent,
              child: NavigationBar(  
                onDestinationSelected: (value) => controller.selectedIndex.value = value,
                selectedIndex: controller.selectedIndex.value,
                indicatorColor: Colors.transparent,
                destinations: [
                  CbCustomNavigationDestination(image: CbImages.homeIcon, showIndicator: controller.selectedIndex.value == 0,),
                  CbCustomNavigationDestination(image: CbImages.searchIcon, showIndicator: controller.selectedIndex.value == 1,),
              
                  NavigationDestination(
                    icon: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: CbColors.primary,
                        borderRadius: BorderRadius.circular(100)
                      ),
                      padding: EdgeInsets.all(CbSizes.sm),
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage(CbImages.addIcon),
                        color: CbColors.lightGrey,
                      )
                    ),
                    label: ''
                  ),
              
                  CbCustomNavigationDestination(image: CbImages.libraryIcon, showIndicator: controller.selectedIndex.value == 3,),
                  CbCustomNavigationDestination(image: CbImages.userIcon, showIndicator: controller.selectedIndex.value == 4,),  
                ],
              ),

                
              
            
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}



class HomeMenuController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = [
    HomeScreen(),
    Container(color: Colors.pink,),
    Container(color: Colors.green,),
    Container(color: Colors.yellow,),
    Container(color: Colors.purple,),
  ];
}