import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../../models/database_response_model.dart';
import '../../services/database_response_helper.dart';
import 'widgets/delete_response_dialog.dart';
import 'widgets/response_data.dart';
import 'widgets/response_image.dart';

class ResponseScreen extends StatefulWidget {
  final int id;
  final DateTime createdAt;

  const ResponseScreen({
    super.key,
    required this.id,
    required this.createdAt,
  });

  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  late Future<DatabaseResponseModel?> _responseFuture;

  final _databaseResponseHelper = DatabaseResponseHelper();

  @override
  void initState() {
    super.initState();
    _responseFuture = _databaseResponseHelper.fetchResponseById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('yyyy/MM/dd').format(widget.createdAt);
    String time = DateFormat('HH:mm:ss').format(widget.createdAt);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteResponseDialog(
                    databaseResponseHelper: _databaseResponseHelper,
                    widget: widget,
                  );
                },
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _responseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data found.'));
          }

          final response = snapshot.data!;
          final modelType = response.modelType;
          final responseData = response.responseData;
          final imagePath = response.imagePath;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  ResponseImage(
                    imagePath: imagePath ?? '',
                  ),
                  const SizedBox(height: 4.0),
                  ResponseData(
                    modelType: modelType,
                    date: date,
                    time: time,
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      Expanded(
                        child: SelectionArea(
                          child: MarkdownBody(
                            styleSheet: MarkdownStyleSheet(
                              blockquotePadding: const EdgeInsets.only(
                                top: 8.0,
                                right: 0,
                                bottom: 8.0,
                                left: 14.0,
                              ),
                              blockquoteDecoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                      width: 5, color: Colors.deepPurple),
                                ),
                              ),
                            ),
                            data: responseData,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
