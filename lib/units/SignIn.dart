class SignIn{
  final String success;
  final String userName;
  final String imageUrl;
  final String userPhone;
  final String type;

  SignIn({this.success, this.userName, this.imageUrl, this.userPhone,this.type});

  factory SignIn.fromJson(Map<String,dynamic> json){
    return SignIn(
      success: json['success'],
      userName: json['userName'],
      imageUrl: json['imageUrl'],
      userPhone: json['userPhone'],
      type: json['type'],
    );
  }
}