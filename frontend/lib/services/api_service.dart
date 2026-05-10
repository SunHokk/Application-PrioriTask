import 'package:dio/dio.dart';

class ApiService {
  // Gunakan 10.0.2.2 untuk Emulator Android, atau IP asli laptop jika pakai HP fisik
  static const String baseUrl = "http://10.0.2.2:3000"; 
  final Dio _dio = Dio();

  Future<List<dynamic>> getTasks() async {
    final response = await _dio.get("$baseUrl/tasks");
    return response.data;
  }

  Future<void> addTask(Map<String, dynamic> data) async {
    await _dio.post("$baseUrl/tasks", data: data);
  }

  Future<void> markAsDone(int id) async {
    await _dio.patch("$baseUrl/tasks/$id/done");
  }
}