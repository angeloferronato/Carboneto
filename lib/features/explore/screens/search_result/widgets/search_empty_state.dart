import 'package:carboneto/common/widgets/result/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 80),
            EmptyData(
              icon: Iconsax.search_normal_1,
              iconSize: 60,
              mainLabel: 'Nenhum resultado encontrado',
              secondaryLabel: 'Tente outro termo ou remova os filtros.',
            ),
          ],
        ),
      ),
    );
  }
}
