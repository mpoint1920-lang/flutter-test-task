import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_test_task/common/enums.dart';
import 'package:todo_test_task/controllers/todo_controller.dart';
import 'package:todo_test_task/models/todo.dart';
import 'package:todo_test_task/views/todos/todo_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TodoController controller = Get.find<TodoController>();

  final TextEditingController searchController = TextEditingController();
  RxString selectedCollection = ''.obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  RxList<Todo> filteredTodos = <Todo>[].obs;

  @override
  void initState() {
    super.initState();
    filteredTodos.value = controller.todos;
    searchController.addListener(_applyFilters);
  }

  void _applyFilters() {
    String query = searchController.text.toLowerCase();
    List<Todo> temp = controller.todos;

    // Filter by text
    if (query.isNotEmpty) {
      temp = temp
          .where((todo) => todo.title.toLowerCase().contains(query))
          .toList();
    }

    // Filter by collection
    if (selectedCollection.value.isNotEmpty) {
      temp = temp
          .where((todo) => todo.collectionName == selectedCollection.value)
          .toList();
    }

    // Filter by date range
    if (startDate.value != null) {
      temp = temp
          .where((todo) =>
              todo.deadline != null && todo.deadline!.isAfter(startDate.value!))
          .toList();
    }
    if (endDate.value != null) {
      temp = temp
          .where((todo) =>
              todo.deadline != null && todo.deadline!.isBefore(endDate.value!))
          .toList();
    }

    filteredTodos.value = temp;
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: startDate.value != null && endDate.value != null
          ? DateTimeRange(start: startDate.value!, end: endDate.value!)
          : null,
    );

    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;
      _applyFilters();
    }
  }

  void _clearFilters() {
    searchController.clear();
    selectedCollection.value = '';
    startDate.value = null;
    endDate.value = null;
    filteredTodos.value = controller.todos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
            tooltip: 'Filters',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearFilters,
            tooltip: 'Clear Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by title...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (filteredTodos.isEmpty) {
                return const Center(
                  child: Text('No Todos match your filters.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = filteredTodos[index];
                  return TodoCard(todo: todo, type: TodoType.inbox);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Collection dropdown
              Obx(() {
                final collections = controller.collections;
                return DropdownButtonFormField<String>(
                  value: selectedCollection.value.isEmpty
                      ? null
                      : selectedCollection.value,
                  hint: const Text('Filter by Collection'),
                  items: collections
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    selectedCollection.value = val ?? '';
                    _applyFilters();
                  },
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                );
              }),
              const SizedBox(height: 12),

              // Date range picker
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      String text =
                          'Start: ${startDate.value != null ? DateFormat.yMd().format(startDate.value!) : 'Any'}';
                      return Text(text);
                    }),
                  ),
                  Expanded(
                    child: Obx(() {
                      String text =
                          'End: ${endDate.value != null ? DateFormat.yMd().format(endDate.value!) : 'Any'}';
                      return Text(text);
                    }),
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: _pickDateRange,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Apply / clear buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _applyFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () {
                      _clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
