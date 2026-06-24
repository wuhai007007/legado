import 'package:flutter/material.dart';

class BookInfoPage extends StatelessWidget {
  const BookInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('书籍详情')),
      body: const Center(child: Text('书籍详情页')),
    );
  }
}
