import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';

class UpdateUserDialog extends StatefulWidget {
  final index;
  final User user;

  UpdateUserDialog(this.index, this.user);

  @override
  _UpdateUserDialogState createState() => _UpdateUserDialogState();
}

class _UpdateUserDialogState extends State<UpdateUserDialog> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _ageController = TextEditingController(text: widget.user.age.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final age = int.tryParse(_ageController.text.trim()) ?? 0;
            if (name.isNotEmpty && age > 0) {
              Box<User> bb = Hive.box<User>('users');
              bb.putAt(widget.index, User(name: name, age: age));
              Navigator.pop(context);
            }
          },
          child: Text('Update'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}