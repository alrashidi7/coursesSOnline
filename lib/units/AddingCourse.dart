class AddingCourse {
  final String success;

  AddingCourse({this.success});

  factory AddingCourse.fromJson(Map<String, dynamic> json) {
    return AddingCourse(
      success: json['success'],
    );
  }
}