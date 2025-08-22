import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../models/todo.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../theme/theme_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  void _showAddTodoDialog( TodoController controller) {
  final TextEditingController textController = TextEditingController();

   Get.dialog(
     AlertDialog(
        title: const Text('Add New Todo'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter todo title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = textController.text.trim();
              if (title.isNotEmpty) {
                controller.addTodo(title);
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
 );
  
}


  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.put(TodoController());
    final themeServices = ThemeService();
    

    return Scaffold (
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:  Center(
        child: 
        Text('To-Do List', 
        style: TextStyle( 
          fontWeight: FontWeight.bold,
        ),),)
        ,
        actions: [
          IconButton(onPressed: () {
            themeServices.switchTheme();
          } 
          , icon: Icon(Icons.brightness_6))
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${controller.errorMessage.value}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.clearError();
                    // TODO: Call loadTodos() to retry loading data

                    controller.loadTodos();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // TODO: Replace this static placeholder list with real data from controller
        // Use controller.todos instead of the static list below
        final List<Todo> placeholderTodos = controller.todos;

        if (placeholderTodos.isEmpty) {
          return const Center(
            child: Text(
              'No todos found',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: placeholderTodos.length,

          itemBuilder: (context, index) {
            final todo = placeholderTodos[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  formatTitle(
                  todo.title),
                  style: TextStyle(
                    decoration: todo.completed 
                        ? TextDecoration.lineThrough 
                        : null,
                    color: todo.completed 
                        ? Colors.grey 
                        : null,
                  ),
                ),
                leading:
                Checkbox(
                  
                  value: todo.completed,
                  onChanged: (bool? value) {
                    // TODO: Call controller.toggleTodoCompletion(todo.id) here
                    controller.toggleTodoCompletion(todo.id);
                  },
                ),
              ),
            );
          },
        );
      }),


     

floatingActionButton: 
 SpeedDial(

 
 icon: Icons.add,
 activeIcon: Icons.close,
 backgroundColor: Colors.blue,
 overlayColor: Colors.black12,
 overlayOpacity: 0.4,
children: [

SpeedDialChild(
  
  onTap: () {
    _showAddTodoDialog(controller);
  },
  label: 'Add Todo',
  child: const Icon(Icons.add),
),

// SizedBox(height: 10,),

  SpeedDialChild(
  
        onTap: () {
          // TODO: Call controller.loadTodos() to refresh the data

          controller.loadTodos();
        },
        label: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
]
 )


    


    );
  }
} 


String formatTitle(String title) {
  if (title.isEmpty) return "";
  return title[0].toUpperCase() + title.substring(1).toLowerCase();
}
