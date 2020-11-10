class Enrollment{
  final String success;
  final String key;

  Enrollment({this.success,this.key});

  factory Enrollment.fromJson(Map<String,dynamic> json){
    return Enrollment(
      success: json['success'],
      key: json['key'].toString(),
    );
  }
}