import 'package:flutter/material.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage({Key? key}) : super(key: key);

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('グループ作成・修正')),
      body: Container(),
    );
  }
}
