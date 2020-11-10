
class StudentCourses {
  final String id;
  final String teacherName;
  final String teacherPhone;
  final String courseName;
  final String courseLevel;
  final String courseUsers;
  final String courseDescription;

  // final String success;

  StudentCourses(
      {this.id, this.courseName, this.courseLevel, this.teacherName, this.teacherPhone,
        this.courseUsers, this.courseDescription});

  factory StudentCourses.fromJson(Map<String, dynamic> json){
    return StudentCourses(
      id: json["id"],
      courseName: json['courseName'],
      courseLevel: json['courseLevel'],
      teacherName: json['teacherName'],
      teacherPhone: json['teacherPhone'],
      courseUsers: json['CourseUsers'],
      courseDescription: json['CourseDescription'],
    );
  }
}