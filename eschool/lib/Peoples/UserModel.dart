
class UserModel{
  final String uid;
  final String userName;
  final String userProfile;
  final String job;
  final String schoolDocId;
  final String token;

  UserModel({this.uid,this.userName,this.userProfile,this.job,this.schoolDocId,this.token});

Map<String,dynamic> toMap()=>{
  "uid":uid,
  "userName":userName,
  "userProfile":userProfile,
  "job":job,
  "sId":schoolDocId,
  "win":0,
  "loose":0,
  "uniform":0,

};
}