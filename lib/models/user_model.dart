import 'package:hive/hive.dart';

class User {
  final String name;
  final int age;

  User({required this.name, required this.age});
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final fields = reader.readMap() as Map<dynamic, dynamic>;
    return User(name: fields['name'] as String, age: fields['age'] as int);
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeMap({'name': obj.name, 'age': obj.age});
  }
}