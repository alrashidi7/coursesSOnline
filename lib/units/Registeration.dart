 class Registeration {
  final String success;
  final int rondomKey;
  final String userPhone;
  final String userName;
  final String type;
  Registeration({this.success, this.rondomKey,this.userName,this.userPhone,this.type});

  factory Registeration.fromJson(Map<String, dynamic> json) {
    return Registeration(
        success: json['success'],
      rondomKey: json['rondomKey'],
      userPhone: json['userPhone'],
      userName: json['userName'],
      type: json['type'],

    );
  }
}