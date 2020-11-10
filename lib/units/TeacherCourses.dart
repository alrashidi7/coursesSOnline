
class TeacherCourses{
  final String id;
  final String teacherName;
  final String teacherPhone;
  final String courseName;
  final String courseLevel;
  final String CourseUsers;
  final String CourseDescription;
 // final String success;

  TeacherCourses({this.id, this.courseName,this.courseLevel,this.teacherName, this.teacherPhone,
       this.CourseUsers, this.CourseDescription});

  factory  TeacherCourses.fromJson(Map<String,dynamic> json){
    return TeacherCourses(
      id: json["id"],
      courseName: json['courseName'],
      courseLevel: json['courseLevel'],
      teacherName: json['teacherName'],
      teacherPhone: json['teacherPhone'],
      CourseUsers: json['CourseUsers'],
      CourseDescription: json['CourseDescription'],
    );

  }
}