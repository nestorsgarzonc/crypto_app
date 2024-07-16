class UserModel {
  const UserModel({
    required this.email,
    required this.name,
    required this.id,
    required this.birthday,
  });

  final String email;
  final String name;
  final int id;
  final DateTime birthday;

  UserModel copyWith({
    String? email,
    String? name,
    int? id,
    DateTime? birthday,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      id: id ?? this.id,
      birthday: birthday ?? this.birthday,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'id': id,
      'birthday': birthday.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      id: map['id'] as int,
      birthday: DateTime.fromMillisecondsSinceEpoch(map['birthday'] as int),
    );
  }

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, id: $id, birthday: $birthday)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        other.id == id &&
        other.birthday == birthday;
  }

  @override
  int get hashCode {
    return email.hashCode ^ name.hashCode ^ id.hashCode ^ birthday.hashCode;
  }
}

class RegisterModel extends UserModel {
  const RegisterModel({
    required this.password,
    required this.confirmPassword,
    required super.email,
    required super.name,
    required super.id,
    required super.birthday,
  });

  final String password;
  final String confirmPassword;

  @override
  bool operator ==(covariant RegisterModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.password == password &&
        other.confirmPassword == confirmPassword &&
        other.name == name &&
        other.id == id &&
        other.birthday == birthday;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        password.hashCode ^
        confirmPassword.hashCode ^
        name.hashCode ^
        id.hashCode ^
        birthday.hashCode;
  }

  @override
  String toString() {
    return 'RegisterModel(email: $email, password: $password, confirmPassword: $confirmPassword, name: $name, id: $id, birthday: $birthday)';
  }

  @override
  RegisterModel copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? name,
    int? id,
    DateTime? birthday,
  }) {
    return RegisterModel(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
      id: id ?? this.id,
      birthday: birthday ?? this.birthday,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'name': name,
      'id': id,
      'birthday': birthday.millisecondsSinceEpoch,
    };
  }

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      email: map['email'] as String,
      password: map['password'] as String,
      confirmPassword: map['confirmPassword'] as String,
      name: map['name'] as String,
      id: map['id'] as int,
      birthday: DateTime.fromMillisecondsSinceEpoch(map['birthday'] as int),
    );
  }
}

class UpdateUser extends UserModel {
  UpdateUser({
    required super.email,
    required super.name,
    required super.id,
    required super.birthday,
    required this.password,
  });

  factory UpdateUser.fromUserModel(UserModel user, String? password) {
    return UpdateUser(
      email: user.email,
      name: user.name,
      id: user.id,
      birthday: user.birthday,
      password: password,
    );
  }

  final String? password;

  @override
  bool operator ==(covariant UpdateUser other) {
    if (identical(this, other)) return true;
    return other.email == email &&
        other.name == name &&
        other.id == id &&
        other.birthday == birthday &&
        other.password == password;
  }

  @override
  int get hashCode {
    return email.hashCode ^ name.hashCode ^ id.hashCode ^ birthday.hashCode ^ password.hashCode;
  }

  @override
  String toString() {
    return 'UpdateUser(email: $email, name: $name, id: $id, birthday: $birthday, password: $password)';
  }
}
