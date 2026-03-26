import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/personalization/controllers/training/training_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/profile_header.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/profile_tab_bar.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/profile_training_list.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userId});
  final String userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileTab _selectedTab = ProfileTab.treinos;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ProfileBaseController(userId: widget.userId),
      tag: widget.userId,
    );
    Get.put(
      TrainingController(userId: widget.userId),
      tag: widget.userId,
    );

    final isDarkMode = CbHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.refreshUserData,
        color: CbColors.primary,
        displacement: 60,
        backgroundColor: isDarkMode ? CbColors.dark : CbColors.white,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ProfileHeader(
                userId: widget.userId,
                isDarkMode: isDarkMode,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  final isCoach = controller.user.value.position == 'Coach'; 
                  return Column(
                    children: [
                      ProfileTabBar(
                        selectedTab: _selectedTab,
                        onTabChanged: (tab) => setState(() => _selectedTab = tab),
                        isCoach: isCoach,
                      ),
                      Container(
                        height: 1,
                        color: const Color.fromARGB(67, 147, 147, 147),
                      ),
                    ],
                  );
                }),
              ),
            ),
            if (_selectedTab == ProfileTab.treinos)
              ProfileTrainingsList(userId: widget.userId),

            if (_selectedTab == ProfileTab.painel)
              const SliverToBoxAdapter(child: SizedBox()),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}