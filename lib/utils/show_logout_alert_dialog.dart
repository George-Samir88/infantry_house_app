// 🚪 Logout Confirmation
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

void showLogoutDialog({
  required BuildContext context,
  required void Function() onLogoutPressed,
}) {
  final loc = S.of(context); // ✅ Localization instance

  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: Text(
            loc.ConfirmLogoutTitle, // ✅ localized key
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.brown[700],
            ),
          ),
          content: Text(loc.ConfirmLogoutMessage), // ✅ localized key
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                loc.Cancel, // ✅ localized key
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            TextButton(
              onPressed: onLogoutPressed,
              child: Text(
                loc.LogOut, // ✅ localized key
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
  );
}
