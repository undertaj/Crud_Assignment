

import 'package:crud_assignment/dialogs/update_user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  late final Box<User> users;

  @override
  void initState() {
    // TODO: implement initState
    users = Hive.box<User>('users');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          centerTitle: true,
          surfaceTintColor: Colors.pink[50],
          title: Text('CRUD Demo'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide:  const BorderSide(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: 'Age',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _addUser(_nameController.text, _ageController.text),
              child: Text('Add User'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _readUsers();
                });
              },
              child: Text('Read Users'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  users.clear();
                });
              },
              child: Text('Clear Db'),
            ),
            Text('Users in Hive Db: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 150,
              width: double.infinity,
              child:
              users.isEmpty ? Center(child: Text('No users found')) :
              ListView.builder(
                  itemCount: Hive.box<User>('users').length,
                  itemBuilder: (context, index) {
                    final userBox = Hive.box<User>('users');
                    final user = userBox.getAt(index);
                    return InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => UpdateUserDialog(index, user!),
                        );
                        setState(() {

                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.pink[50],
                          borderRadius: BorderRadius.circular(5),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(user!.name),
                            Text(user.age.toString()),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                userBox.deleteAt(index);
                                setState(() {});
                              },

                            ),
                          ],
                        ),

                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      );
  }

  void _addUser(String name, String age) async {
    final userBox = Hive.box<User>('users');

    final newUser = User(name: name, age: int.tryParse(age) ?? 0);
    userBox.add(newUser);

    print('User added: $newUser');
    setState(() {});
  }



  void _readUsers() async {
    final userBox = Hive.box<User>('users');
    final users = userBox.values.toList();
    print('Users: $users');
  }


}
