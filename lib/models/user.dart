class User {
  int? userId;

  String? name;
  String? mobile;
  String? email;
  String? userType;
  String? company;
  String? employeeId;

  User({
    required this.userId,
    required this.name,
    required this.mobile,
    this.email,
    this.userType,
    this.company,
    this.employeeId,
  });

  User.fromJson(snapshotData) {
    userId = snapshotData['user_id'];
    name = snapshotData['name'];
    mobile = snapshotData['mobile'];
    email = snapshotData['email'];
    userType = snapshotData['userType'];
    company = snapshotData['company'];
    employeeId = snapshotData['employeeId'];
  }
}
