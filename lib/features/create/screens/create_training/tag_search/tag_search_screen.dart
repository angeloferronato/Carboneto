import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/custom_shapes/containers/focused_text_field.dart';
import 'package:carboneto/features/create/controllers/tag_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TagSearchScreen extends StatelessWidget {
  const TagSearchScreen({super.key, required this.tag});
  final String tag;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TagController(), tag: tag);
    final TextEditingController textCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: CbColors.dark,
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
              controller: textCtrl,
              hintText: "Pesquisar ou criar nova tag...",
              onChanged: (value) => controller.searchQuery.value = value,
              onSubmitted: (value) {
                controller.addNewTag(value);
                textCtrl.clear();
                controller.searchQuery.value = '';
              },
              contentPadding: const EdgeInsets.all(14),
              prefixIcon: GestureDetector(
                child: Icon(Iconsax.search_normal_1, size: 20,),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Reactive list of tags
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

                            // 🔹 Tag tile
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
                                    color: isSelected
                                        ? CbColors.primary
                                        : Colors.white,
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
