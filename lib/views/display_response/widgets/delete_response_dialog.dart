import '../../../services/database_response_helper.dart';
import '../../home/home_page_screen.dart';
import '../response_screen.dart';
import 'package:flutter/material.dart';

class DeleteResponseDialog extends StatelessWidget {
  const DeleteResponseDialog({
    super.key,
    required DatabaseResponseHelper databaseResponseHelper,
    required this.widget,
  }) : _databaseResponseHelper = databaseResponseHelper;

  final DatabaseResponseHelper _databaseResponseHelper;
  final ResponseScreen widget;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Response'),
      content: const Text(
        'This action cannot be undone. '
        'Are you sure you want to delete this response?',
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.deepPurple,
          ),
          child: const Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            await _databaseResponseHelper.deleteResponse(widget.id);

            if (context.mounted) {
              Navigator.of(context).pop();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const HomePageScreen(),
                ),
                (route) => false,
              );
            }
          },
        ),
      ],
    );
  }
}
