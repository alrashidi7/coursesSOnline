class StudentEnroll{
  final String success;
  final String studentName;
  final String key;

  StudentEnroll({this.success,this.studentName,this.key});

  factory StudentEnroll.fromJson(Map<String,dynamic> json){
    return StudentEnroll(
      success: json['success'],
      studentName: json['studentName'].toString(),
      key: json['key'].toString(),
    );
  }
}