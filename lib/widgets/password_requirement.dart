import 'package:flutter/material.dart';

class PasswordRequirement extends StatelessWidget {
  final String requirement;
  final bool isValid;

  const PasswordRequirement({
    super.key,
    required this.requirement,
    required this.isValid
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      spacing: 8.0,
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          size: 14.0,
          color: isValid ? Colors.green : colorScheme.error,
        ),
        Text(
          requirement,
          style: textTheme.labelMedium?.copyWith(
            color: isValid ? colorScheme.onSurfaceVariant : colorScheme.error,
          ),
        ),
      ],
    );
  }
}