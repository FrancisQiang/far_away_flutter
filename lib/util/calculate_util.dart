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

  static int getJiugonggePercentage(int size) {
    if (size == 1) {
      return 1;
    } if (size >= 5 || size == 3) {
      return 3;
    } else {
      return 2;
    }
  }


}