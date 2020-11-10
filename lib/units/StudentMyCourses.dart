
class StudentMyCourses {
  final String id;
  final String studentName;
  final String studentPhone;
  final String teacherName;
  final String teacherPhone;
  final String courseLevel;
  final String courseName;
  final String money;
  final String rodomKey;
  final String total;

  StudentMyCourses({
      this.id,
      this.studentName,
      this.studentPhone,
      this.teacherName,
      this.teacherPhone,
      this.courseLevel,
      this.courseName,
      this.money,
      this.rodomKey,this.total});

  factory StudentMyCourses.fromJson(Map<String, dynamic> json){
    return StudentMyCourses(
      id: json["id"],
      courseName: json['courseName'],
      courseLevel: json['courseLevel'],
      teacherName: json['teacherName'],
      teacherPhone: json['teacherPhone'],
      studentName: json['studentName'],
      studentPhone: json['studentPhone'],
      money: json['money'],
      rodomKey: json['rodomKey'],
    );
  }
  factory StudentMyCourses.forJson(Map<String, dynamic> json){
    return StudentMyCourses(
      total: json['total']
    );
  }
}