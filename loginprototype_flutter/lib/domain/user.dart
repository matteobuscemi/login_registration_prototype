class User {
  int userId;
  String name;
  String email;
  String phone;
  String type;
  String token;
  String renewalToken;

  User({this.userId,this.name,this.email,this.phone,this.type,this.token,this.renewalToken});


  factory User.fromJson(Map<String,dynamic> responseData){
    return User(
      userId: responseData['id'],
      name: responseData['Username'],
      email: responseData['Email'],
      phone: responseData['Phone'],
      type: responseData['Type'],
      token: responseData['Token'],
      renewalToken: responseData['Token'],
    );
  }


}