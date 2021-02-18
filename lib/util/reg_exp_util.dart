
class RegExpUtil {

  /// 验证手机号
  static bool isPhone(String input) {
    RegExp mobile = RegExp(r"^1\d{10}$");
    return mobile.hasMatch(input);
  }

  /// 验证手机验证码
  static bool isValidateCaptcha(String input) {
    RegExp mobile = RegExp(r"^\d{6}$");
    return mobile.hasMatch(input);
  }


}