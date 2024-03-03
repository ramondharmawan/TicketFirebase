import 'package:equatable/equatable.dart';

/// Extending Equatable to compare objects, this will us
/// to compare objects and to know if they are the same
class User extends Equatable {
  final String id;
  final String name;
  final String lastName;
  final int age;
  final String? imageUrl;

  const User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.age,
    this.imageUrl,
  });

  /// when comparing two instances of user class, we want to check that all the
  /// properties are the same, then we can say that the two instances are equals

  @override
  List<Object?> get props => [id, name, lastName, age, imageUrl];

  // Helper function to convert this User to a Map
  Map<String, dynamic> toFirebaseMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'age': age,
      'imageUrl': imageUrl,
    };
  }

  // helper function to convert a map to a user instance
  User.fromFirebaseMap(Map<String, Object?> data)
      : id = data['id'] as String,
        name = data['name'] as String,
        lastName = data['lastName'] as String,
        age = data['age'] as int,
        imageUrl = data['imageUrl'] as String?;

  // Helper function that updates some properties of this instance,
  // and returns a new updated instance of User

  User copyWith({
    String? id,
    String? name,
    String? lastName,
    int? age,
    String? imageUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
