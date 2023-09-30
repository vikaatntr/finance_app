class BalanceDetail {
  int? id;
  int idBalance;
  String type;
  double nominal;
  String desc;
  String date;

  BalanceDetail({
    this.id,
    required this.idBalance,
    required this.type,
    required this.nominal,
    required this.desc,
    required this.date,
  });

  factory BalanceDetail.fromMap(Map<String, dynamic> map) {
    return BalanceDetail(
      id: map['id'],
      idBalance: map['idBalance'],
      type: map['type'],
      nominal: map['nominal'],
      desc: map['desc'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idBalance': idBalance,
      'type': type,
      'nominal': nominal,
      'desc': desc,
      'date': date,
    };
  }
}
