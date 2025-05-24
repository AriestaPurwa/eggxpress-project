import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String label;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.label,
          semanticsLabel: label,
        ),
        const SizedBox(height: 9),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: AppColors.lightBlue,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item.toUpperCase(),
                    style: AppTextStyles.label,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              style: AppTextStyles.label,
              dropdownColor: AppColors.lightBlue,
            ),
          ),
        ),
      ],
    );
  }
}
