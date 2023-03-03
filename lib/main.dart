import 'package:flutter/material.dart';

void main() {
  runApp(const AnimatedListApp());
}

class AnimatedListApp extends StatelessWidget {
  const AnimatedListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnimatedListView(),
    );
  }
}

class AnimatedListView extends StatelessWidget {
  const AnimatedListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: const Text(
          'Flutter map',
          style: TextStyle(
            fontSize: 60.0,
            color: Color.fromARGB(255, 72, 13, 104),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 192, 127, 233),
        centerTitle: true,
      ),
      body: const CustomAnimatedList(),
    );
  }
}

class CustomAnimatedList extends StatefulWidget {
  const CustomAnimatedList({Key? key}) : super(key: key);

  @override
  State<CustomAnimatedList> createState() => _CustomAnimatedListState();
}

class _CustomAnimatedListState extends State<CustomAnimatedList> {
  final List<String> items = [];

  final GlobalKey<AnimatedListState> key = GlobalKey();

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: insertItem,
          icon: const Icon(Icons.add),
        ),
        Expanded(
          child: AnimatedList(
              key: key,
              controller: scrollController,
              initialItemCount: items.length,
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                    position: animation.drive(Tween<Offset>(
                        begin: const Offset(1, 0), end: const Offset(0, 0))),
                    child: AnimatedListItem(
                        onPressed: () {
                          deleteItem(index);
                        },
                        text: items[index]));
              }),
        ),
      ],
    );
  }

  void insertItem() {
    var index = items.length;
    items.add('item ${index + 1}');
    key.currentState!.insertItem(index);

    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  void deleteItem(int index) {
    items.removeAt(index);

    key.currentState!.removeItem(index, (context, animation) {
      return SizeTransition(
          sizeFactor: animation,
          child: AnimatedListItem(text: items[index], onPressed: () {}));
    });
  }
}

class AnimatedListItem extends StatelessWidget {
  const AnimatedListItem(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 148, 97, 179),
      elevation: 10,
      child: ListTile(
        title: Text(text),
        trailing:
            IconButton(onPressed: onPressed, icon: const Icon(Icons.delete)),
      ),
    );
  }
}
