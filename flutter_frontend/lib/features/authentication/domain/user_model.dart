class UserModel {
  final String id;
  final String name;
  final String email;
  final int age;
  final double height;
  final double weight;
  final String gender;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'],
      name: json['username'],
      email: json['email'],
      age: json['age'],
      height: json['height'],
      gender: json["gender"],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': id,
        'username': name,
        'email': email,
        'age': age,
        'height': height,
        "gender": gender,
        'weight': weight,
      };

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email}';
  }
}
