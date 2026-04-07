import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final box = Hive.box('diaryBox');

  final TextEditingController cropController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void addEntry() {
    if (cropController.text.isEmpty || noteController.text.isEmpty) return;

    box.add({
      'crop': cropController.text,
      'note': noteController.text,
      'date': DateTime.now().toString(),
    });

    cropController.clear();
    noteController.clear();
    Navigator.pop(context);
    setState(() {});
  }

  void deleteEntry(int index) {
    box.deleteAt(index);
    setState(() {});
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Entry"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: cropController,
              decoration: const InputDecoration(labelText: "Crop"),
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: "Note"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: addEntry,
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = box.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Farm Diary")),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: data.isEmpty
          ? const Center(child: Text("No entries yet"))
          : ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, i) {
          final item = data[i];

          return ListTile(
            title: Text(item['crop']),
            subtitle: Text(item['note']),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteEntry(i),
            ),
          );
        },
      ),
    );
  }
}