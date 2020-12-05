class User {
  String uid;
  String name;
  String email;
  String username;
  String status;
  String quote;
  String profilePhoto;
  List liked;

  User({
    this.liked,
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.profilePhoto,
    this.quote="",
  });

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['liked']=user.liked;
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data["status"] = user.status;
    data["profile_photo"] = user.profilePhoto;
    data["quote"]=user.quote;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.liked=mapData['liked'];
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.profilePhoto = mapData['profile_photo'];
    this.quote=mapData["quote"];
  }
}