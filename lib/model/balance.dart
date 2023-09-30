class Balance {
  int? id;
  int idUser;
  double nominal;

  Balance({
    this.id,
    required this.idUser,
    required this.nominal,
  });

  factory Balance.fromMap(Map<String, dynamic> map) {
    return Balance(
      id: map['id'],
      idUser: map['idUser'],
      nominal: map['nominal'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': idUser,
      'nominal': nominal,
    };
  }
}
