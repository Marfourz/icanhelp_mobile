import 'package:flutter/material.dart';
import 'package:icanhelp/theme.dart';

class StepIndicator extends StatelessWidget {
  final String text;
  final bool isActive;
  final page;

  const StepIndicator({
    super.key,
    required this.text,
    required this.isActive,
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child : GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'page');
      },
        child: Column(
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? AppColors.primary : Colors.grey,
                fontSize: 16
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 3,
              width: 50,
              color: isActive ? Colors.orange : Colors.grey,
            ),
          ],
        ),
    
    ));
  }
}
