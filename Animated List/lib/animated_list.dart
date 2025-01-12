import 'package:flutter/material.dart';

class AnimatedListWidget extends StatefulWidget {
  const AnimatedListWidget({super.key});

  @override
  State<AnimatedListWidget> createState() => _AnimatedListWidgetState();
}

class _AnimatedListWidgetState extends State<AnimatedListWidget> {
  final List<String> _items = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animated List',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _items.length,
                itemBuilder: (context, index, animation) {
                  return _buildItem(_items[index], animation, index);
                },
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String item, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          title: Text(item),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeItem(index),
          ),
        ),
      ),
    );
  }

  // Widget _buildItem(String item, Animation<double> animation, int index) {
  //   return FadeTransition(
  //     opacity: animation,
  //     child: SizeTransition(
  //       sizeFactor: animation,
  //       child: Card(
  //         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //         child: ListTile(
  //           title: Text(item),
  //           trailing: IconButton(
  //             icon: const Icon(Icons.delete),
  //             onPressed: () => _removeItem(index),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildInputBar() {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Enter Item',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final newItem = controller.text;
              if (newItem.isNotEmpty) {
                _addItem(newItem);
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  void _addItem(String item) {
    _items.insert(0, item);
    _listKey.currentState?.insertItem(0);
  }

  void _removeItem(int index) {
    final removedItem = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, animation, index),
      duration: const Duration(milliseconds: 300),
    );
  }
}
