import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import '../core/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PrioriTask',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _apiService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Gagal memuat data: ${snapshot.error}"),
              ),
            );
          } 
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Belum ada tugas. Klik + untuk menambah."),
            );
          }

          // Mapping data JSON ke List of Task Models
          List<Task> allTasks = snapshot.data!.map((e) => Task.fromJson(e)).toList();
          
          // Memisahkan list berdasarkan status penyelesaian
          List<Task> activeTasks = allTasks.where((t) => !t.isCompleted).toList();
          List<Task> completedTasks = allTasks.where((t) => t.isCompleted).toList();

          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tugas Sedang Berjalan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...activeTasks.map((task) => TaskCard(
                        task: task,
                        color: Colors.orange.shade50,
                        onDone: () async {
                          await _apiService.markAsDone(task.id!);
                          setState(() {}); // Refresh UI
                        },
                      )),
                  
                  if (completedTasks.isNotEmpty) ...[
                    const SizedBox(height: 30),
                    const Divider(),
                    const Text(
                      'Tugas Selesai',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.grey
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...completedTasks.map((task) => TaskCard(
                          task: task,
                          color: Colors.grey.shade200,
                        )),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi menggunakan Named Route
          final result = await Navigator.pushNamed(context, AppRoutes.addTask);
          if (result == true) {
            setState(() {}); // Refresh data jika data baru berhasil disimpan
          }
        },
        tooltip: 'Tambah Tugas',
        child: const Icon(Icons.add),
      ),
    );
  }
}