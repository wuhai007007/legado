import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ReaderMenu extends StatelessWidget {
  final String currentTheme;
  final double fontSize;
  final void Function(String) onThemeChanged;
  final void Function(double) onFontSizeChanged;

  const ReaderMenu({
    super.key,
    required this.currentTheme,
    required this.fontSize,
    required this.onThemeChanged,
    required this.onFontSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.text_fields, size: 16),
              Expanded(
                child: Slider(
                  value: fontSize, min: 12, max: 32,
                  onChanged: onFontSizeChanged,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: AppTheme.readerThemes.entries.map((entry) {
              final isActive = currentTheme == entry.key;
              return GestureDetector(
                onTap: () => onThemeChanged(entry.key),
                child: Column(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: entry.value.bgColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isActive ? AppTheme.primaryColor : Colors.grey.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: isActive ? Icon(Icons.check, size: 16, color: entry.value.textColor) : null,
                    ),
                    const SizedBox(height: 4),
                    Text(entry.value.name, style: const TextStyle(fontSize: 10)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
