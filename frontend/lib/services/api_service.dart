import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  static const String _baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:3000');

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ─── Tasks ────────────────────────────────────────────────────────────────

  Future<List<Task>> getTasks() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/tasks'), headers: _headers)
        .timeout(const Duration(seconds: 10));
    _checkStatus(response);
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Task> createTask(Map<String, dynamic> taskData) async {
    // Pastikan hanya field yang dikenali backend yang dikirim
    final body = {
      'subject_name': taskData['subject_name'],
      'task_name': taskData['task_name'],
      'description': taskData['description'] ?? '',
      'difficulty': taskData['difficulty'],
      'deadline': taskData['deadline'],
    };

    debugPrint('Creating task: ${jsonEncode(body)}');

    final response = await http
        .post(
          Uri.parse('$_baseUrl/tasks'),
          headers: _headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));

    debugPrint('Create task response: ${response.statusCode} ${response.body}');
    _checkStatus(response);
    return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Task> updateTask(String id, Map<String, dynamic> taskData) async {
    final response = await http
        .patch(
          Uri.parse('$_baseUrl/tasks/$id'),
          headers: _headers,
          body: jsonEncode(taskData),
        )
        .timeout(const Duration(seconds: 10));
    _checkStatus(response);
    return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deleteTask(String id) async {
    final response = await http
        .delete(Uri.parse('$_baseUrl/tasks/$id'), headers: _headers)
        .timeout(const Duration(seconds: 10));
    _checkStatus(response);
  }

  // ─── Progress Updates ─────────────────────────────────────────────────────

  Future<List<ProgressUpdate>> getProgressUpdates(String taskId) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/tasks/$taskId/progress'), headers: _headers)
        .timeout(const Duration(seconds: 10));
    _checkStatus(response);
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => ProgressUpdate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProgressUpdate> addProgressUpdate(
      String taskId, Map<String, dynamic> updateData) async {
    final body = {
      'progress_percent': updateData['progress_percent'],
      'note': updateData['note'] ?? '',
    };

    final response = await http
        .post(
          Uri.parse('$_baseUrl/tasks/$taskId/progress'),
          headers: _headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));
    _checkStatus(response);
    return ProgressUpdate.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/notifications'), headers: _headers)
        .timeout(const Duration(seconds: 10));
    _checkStatus(response);
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'API Error ${response.statusCode}: ${response.body}');
    }
  }
}