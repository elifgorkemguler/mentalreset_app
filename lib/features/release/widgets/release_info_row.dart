import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';

class ReleaseInfoRow extends StatelessWidget {
  final int count;

  const ReleaseInfoRow({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$count thoughts ready', style: AppTextStyles.labelMedium),
        Text('Drag → trash to release', style: AppTextStyles.labelMedium),
      ],
    );
  }
}
