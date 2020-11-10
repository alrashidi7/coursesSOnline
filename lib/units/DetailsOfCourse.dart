class DetailsOfCourse{
  final String id;
  final String teacherName;
  final String teacherPhone;
  final String courseName;
  final String courseLevel;
  final String courseSessionDate;
  final String courseUsers;
  final String courseDescription;
  final String courseRate;
  final String sessionDay;
  final String sessionDayDate;
  final String active;

  DetailsOfCourse(
      {this.id,
      this.teacherName,
      this.teacherPhone,
      this.courseName,
      this.courseLevel,
      this.courseSessionDate,
      this.courseUsers,
      this.courseDescription,
      this.courseRate,
      this.sessionDay,
      this.sessionDayDate,
      this.active});

  factory DetailsOfCourse.fromJson(Map<String,dynamic> json){
    return DetailsOfCourse(
      id: json["id"],
      courseName: json['courseName'],
      courseLevel: json['courseLevel'],
      teacherName: json['teacherName'],
      teacherPhone: json['teacherPhone'],
      courseUsers: json['courseUsers'],
      courseDescription: json['courseDescription'],
      courseSessionDate: json['courseSessionDate'],
      courseRate: json['courseRate'],
      sessionDay:json['sessionDay'],
      sessionDayDate:json['sessionDayDate'],
      active:json['active'],
    );
  }
}