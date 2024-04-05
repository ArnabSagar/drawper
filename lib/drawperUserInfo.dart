// ignore: file_names
class DrawperUserInfo {
  String username;
  String email;
  String name;
  String userId;
  String bio;
  String profilePicUrl; 
  int points; 
  List<dynamic> followers;
  List<dynamic> following;
  List<Map<String, dynamic>> posts;

  DrawperUserInfo({
    required this.username,
    required this.email,
    required this.name, 
    required this.userId, 
    required this.bio,
    required this.profilePicUrl,
    required this.points,
    required this.followers, 
    required this.following, 
    required this.posts,
  });

  factory DrawperUserInfo.fromMap(Map<String,dynamic> userInfo, String userId){
    return DrawperUserInfo(
      username: userInfo["username"], 
      email: userInfo["email"], 
      name: userInfo["name"],
      userId: userId, 
      bio: userInfo["bio"], 
      profilePicUrl: userInfo['profilePicUrl'], 
      points: userInfo['points'], 
      followers: userInfo['followers'], 
      following: userInfo['following'], 
      posts: userInfo['posts'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "username": username, 
      "name": name, 
      "email": email, 
      "profilePicUrl": profilePicUrl,
      "bio": bio,
      "points": points,
      "followers": followers,
      "following": following,
      "posts": posts,
    };
  }

}