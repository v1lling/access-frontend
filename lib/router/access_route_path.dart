class AccessRoutePath {
  final String? roomId;
  final bool? isUser;

  AccessRoutePath.home()
      : roomId = null,
        isUser = false;
  AccessRoutePath.checkin(this.roomId) : isUser = false;
  AccessRoutePath.user()
      : roomId = null,
        isUser = true;

  bool get isHomePage => roomId == null && isUser == false;
  bool get isCheckinPage => roomId != null;
  bool get isUserPage => roomId == null && isUser == true;
}
