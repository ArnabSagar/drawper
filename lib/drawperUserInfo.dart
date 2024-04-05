// ignore: file_names
class DrawperUserInfo {
  String username;
  String email;
  String name;
  String userId;
  String bio;
  String profilePicUrl; 
  int points; 
  List<String> followers; 
  List<String> following; 
  List<Map<String, dynamic>> posts;

  DrawperUserInfo({
    required this.username,
    required this.email,
    required this.name, 
    required this.userId, 
    required this.bio,
    required this.profilePicUrl,
    required this.points,
    required List<dynamic> followers, 
    required List<dynamic> following, 
    required this.posts,
  }) : 
      // Convert followers and following lists to list of strings
      followers = followers.map((follower) => follower.toString()).toList(),
      following = following.map((follow) => follow.toString()).toList();

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