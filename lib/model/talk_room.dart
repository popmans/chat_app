class TalkRoom {
  String roomId;
  // joinedUsersでは、uid, userName, image_pathを管理します
  Map<String, int> joinedUsers;
  List<String> members;
  String groupName;
  int password;

  TalkRoom(
      {required this.roomId,
      required this.joinedUsers,
      required this.members,
      required this.groupName,
      required this.password});
}
