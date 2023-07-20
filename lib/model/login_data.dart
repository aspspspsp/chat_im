class LoginData {
  // 登錄響應的數據類
  final bool success;
  final String? token;
  final String message;

  LoginData({
    required this.success,
    this.token,
    required this.message
  });
}