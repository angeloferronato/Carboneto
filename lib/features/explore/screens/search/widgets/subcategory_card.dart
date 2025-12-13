import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class SubcategoryCard extends StatelessWidget {
  final String title;
  final String imagePath; // Agora esta string é uma URL
  final VoidCallback? onTap;

  const SubcategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 175,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        // ClipRRect é necessário para o CachedNetworkImage respeitar o borderRadius
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: imagePath,
            fit: BoxFit.cover,
            // Placeholder enquanto carrega
            placeholder: (context, url) => Container(
              color: Colors.grey[300], // Um placeholder cinza
            ),
            // Widget em caso de erro
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[100],
              child: Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
