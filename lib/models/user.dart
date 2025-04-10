class User {
  final String name;
  final String email;
  final String password;

  User({required this.name, required this.email, required this.password});

  Map<String, String> toMap() => {
    'name': name,
    'email': email,
    'password': password,
  };

  factory User.fromMap(Map<String, dynamic> map) => User(
    name: map['name'] as String? ?? '',
    email: map['email'] as String? ?? '',
    password: map['password'] as String? ?? '',
  );
}
