import 'package:flutter/material.dart';
import 'package:virtual_home_demo/models/scene.dart';
import 'package:virtual_home_demo/theme/app_theme.dart';

class SceneCard extends StatelessWidget {
  const SceneCard({
    super.key,
    required this.scene,
    required this.selected,
    required this.onTap,
  });

  final SmartScene scene;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 119,
      child: Material(
        color: selected ? scene.color.withValues(alpha: 0.2) : AppTheme.paper,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  scene.icon,
                  color: selected ? AppTheme.ink : scene.color,
                  size: 21,
                ),
                const SizedBox(height: 9),
                Text(
                  scene.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  scene.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.mutedInk,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
