import 'package:flutter/material.dart';

class MessageSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    bool isSuccess = true,
    bool onTop = false,
    Duration duration = const Duration(seconds: 5),
  }) {
    final backgroundColor = isSuccess ? Colors.green.shade600 : Colors.red.shade600;
    final icon = isSuccess ? Icons.check_circle : Icons.error;

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: duration,
      margin: onTop ?EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 150,
      ) : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 6, // Légère ombre pour un effet plus clean
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

    /// Fonction pour afficher une erreur à partir d'un JSON d'erreurs backend
  static void showBackendErrors(
    BuildContext context,
    Map<String, dynamic> errors,
  ) {
    String errorMessage = errors.entries
        .map((entry) => "${entry.key}: ${entry.value.join(", ")}")
        .join("\n");

    show(context, message: errorMessage, isSuccess: false);
  }

}
