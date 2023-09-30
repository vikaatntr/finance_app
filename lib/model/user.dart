class User {
  int? id;
  String nama;
  String email;
  String password;
  String nim;

  User(
      {this.id,
      required this.nama,
      required this.email,
      required this.password,
      required this.nim});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      'nim': nim,
    };
  }
}
