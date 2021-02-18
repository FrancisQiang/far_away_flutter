class CalculateUtil {

  static String simplifyCount(int commentCount) {
    if (commentCount > 0 && commentCount <= 999) {
      return commentCount.toString();
    } else if (commentCount == 0) {
      return '';
    } else if (commentCount >= 1000 && commentCount <= 9999) {
      return '${(commentCount / 1000.0).toStringAsFixed(1)}k';
    } else if (commentCount >= 10000 && commentCount <= 99999) {
      return '${(commentCount / 10000.0).toStringAsFixed(1)}w';
    } else if (commentCount >= 100000 && commentCount <= 999999) {
      return '${commentCount / 10000}w';
    } else {
      return '99+w';
    }
  }

  static int calculateWrapElementWidth(int count) {
    if (count == 1) {
      return 690;
    } else if (count >= 5 || count == 3) {
      return 225;
    } else {
      return 340;
    }
  }

  static int calculateCommentWrapElementWidth(int count) {
    if (count == 1) {
      return 220;
    } else if (count >= 5 || count == 3) {
      return 180;
    } else {
      return 250;
    }
  }


}