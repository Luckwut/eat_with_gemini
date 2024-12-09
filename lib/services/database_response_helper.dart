import 'dart:io';

import 'package:sqflite/sqflite.dart';

import '../models/database_response_model.dart';
import 'database_config.dart';

class DatabaseResponseHelper {
  Future<int> insertResponse(DatabaseResponseModel response) async {
    final db = await DatabaseConfig().database;
    return await db.insert('responses', response.toMap());
  }

  Future<DatabaseResponseModel?> fetchResponseById(int id) async {
    final db = await DatabaseConfig().database;
    final maps = await db.query(
      'responses',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return DatabaseResponseModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DatabaseResponseModel>> fetchAllResponse() async {
    final db = await DatabaseConfig().database;
    final maps = await db.query('responses');
    return maps.map((map) => DatabaseResponseModel.fromMap(map)).toList();
  }

  Future<int> deleteResponse(int id) async {
    final db = await DatabaseConfig().database;

    final response = await fetchResponseById(id);
    await _checkImageExist(response, db, id);

    return await db.delete(
      'responses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> _checkImageExist(
      DatabaseResponseModel? response, Database db, int id) async {
    if (response?.imagePath != null) {
      final file = File(response!.imagePath!);

      final otherResponses = await db.query(
        'responses',
        where: 'image_path = ? AND id != ?',
        whereArgs: [response.imagePath, id],
      );

      if (otherResponses.isEmpty && await file.exists()) {
        await file.delete();
      }
    }
  }
}
