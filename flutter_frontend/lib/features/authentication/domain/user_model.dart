class UserModel {
  final String id;
  final String name;
  final String email;
  final int age;
  final double height;
  final double weight;
  final String gender;
  int coins;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.coins,
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
      coins: json['coins'],
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
        'coins': coins,
      };

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email}';
  }
}
