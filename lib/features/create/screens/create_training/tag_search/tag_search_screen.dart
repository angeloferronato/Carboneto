import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TagSearchScreen extends StatelessWidget {
  const TagSearchScreen({super.key, required this.tag});
  final String tag;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    final controller = Get.put(TagController(), tag: tag);

    return Scaffold(
      appBar: const CbAppBar(
        title: Text(
          'Adicionar Tags',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FocusedTextField(
              controller: controller.queryController,
              hintText: "Pesquisar tag...",
              onChanged: (value) => controller.searchQuery.value = value,
              suffixIcon: IconButton(
                onPressed: () {
                  controller.queryController.clear();
                  controller.searchQuery.value = '';
                }, 
                icon: Icon(Iconsax.trash)
              ),
              contentPadding: const EdgeInsets.all(14),
              prefixIcon: GestureDetector(
                child: Icon(Iconsax.search_normal_1, size: 20,),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Obx(() {
                final results = controller.filteredTags;
                return ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (_, i) {
                    final tag = results[i];

                    // Wrap each tag in its own Obx so each rebuilds independently
                    return Obx(() {
                      final isSelected =
                          controller.selectedTags.contains(tag);

                      return GestureDetector(
                        onTap: () => controller.onTagChanged(tag, !isSelected),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            // 🔹 Blue selection bar (animated)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              width: isSelected ? 5 : 0,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? CbColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: ListTile(
                                tileColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode 
                                    ? (isSelected ? CbColors.primary : Colors.white)
                                    : (isSelected ? const Color.fromARGB(255, 15, 80, 221) : CbColors.dark)
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
