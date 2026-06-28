// ─── lesson_card.dart ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

class LessonsCard extends StatelessWidget {
  const LessonsCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.time,
    required this.onTap,
    this.isNetworkImage = false,
    this.cardWidth = 160,
  });

  final String imageUrl;
  final String title;
  final String time;
  final VoidCallback onTap;
  final bool isNetworkImage;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final imageHeight = cardWidth * 0.72;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        child: Card(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.08),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image ──────────────────────────────────────────
               ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: SizedBox(
    width: double.infinity,
    height: imageHeight,
    child: isNetworkImage
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, error, ___) {
              print('❌ IMAGE LOAD FAILED: $imageUrl');
              print('❌ ERROR: $error');
              return Image.asset(
                'assets/images/home_figure1.png',
                fit: BoxFit.cover,
              );
            },
          )
        : Image.asset(imageUrl, fit: BoxFit.cover),
  ),
),
                const SizedBox(height: 8),

                // ── Title ───────────────────────────────────────────
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // ── Teacher / time ──────────────────────────────────
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded,
                        color: Color(0xFF3D8FEF), size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        time,
                        style: const TextStyle(
                          color: Color(0xFF3D8FEF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}