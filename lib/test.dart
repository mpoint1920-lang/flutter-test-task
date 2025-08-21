// Scaffold(
//   appBar: AppBar(
//     title: const Text("Todo App"),
//   ),
//   body: Obx(() {
//     // Your todo list UI here
//     return ListView.builder(
//       itemCount: controller.todos.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(controller.todos[index].title),
//         );
//       },
//     );
//   }),
//   floatingActionButton: Row(
//     mainAxisAlignment: MainAxisAlignment.end, // pushes to bottom-right
//     children: [
//       FloatingActionButton(
//         heroTag: "refreshBtn", // ✅ unique tag
//         onPressed: () {
//           controller.loadTodos(); // or whatever your refresh method is
//         },
//         child: const Icon(Icons.refresh),
//       ),
//       const SizedBox(width: 10), // spacing between buttons
//       FloatingActionButton(
//         heroTag: "addBtn", // ✅ unique tag
//         onPressed: () {
//           _showAddTodoDialog(controller);
//         },
//         child: const Icon(Icons.add),
//       ),
//     ],
//   ),
// );
