import 'package:flutter/material.dart';
import 'package:icanhelp/theme.dart';

class IButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String text;
  final Color bgColor;
  final Color textColor;
  final bool loading;

  const IButton({super.key, 
    this.bgColor = AppColors.primary, 
    this.textColor = Colors.white,
    this.loading = false,
    required this.onPressed, 
    required this.text, 
    });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
                      
                      onPressed: loading ?  null : onPressed,
                      style: ElevatedButton.styleFrom(
                        
                        backgroundColor: bgColor,
                        foregroundColor: textColor,
                        padding: EdgeInsets.symmetric(vertical: 20)
                      ),

                      child: loading ? 
                      Text("En cours ...") :  Text(text)
                    );
  }
}