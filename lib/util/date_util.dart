import 'package:date_format/date_format.dart';

class DateUtil {
  static String getTimeString(DateTime dateTime) {
    DateTime currentDate = DateTime.now();
    String result = '';
    // 如果dateTime晚于当前时间那么直接返回
    if (!currentDate.isAfter(dateTime)) {
      return result;
    }
    if (currentDate.year == dateTime.year) {
      if (currentDate.month == dateTime.month) {
        // 判断是否是今天
        if (currentDate.day == dateTime.day) {
          // 判断相差小时 如果超过6小时则显示今天xxx 否则判断是否相差一个小时以内
          if (currentDate.hour <= dateTime.hour + 6) {
            if (currentDate.hour == dateTime.hour) {
              if (currentDate.minute - dateTime.minute == 0) {
                return "刚刚";
              }
              return '${currentDate.minute - dateTime.minute}分钟前';
            } else {
              return '${currentDate.hour - dateTime.hour}小时前';
            }
          } else {
            return "今天${extractTime(dateTime)}";
          }
        } else if (currentDate.day == dateTime.day + 1) {
          return "昨天${extractTime(dateTime)}";
        } else if (currentDate.day == dateTime.day + 2) {
          return "前天${extractTime(dateTime)}";
        } else if (currentDate.day <= dateTime.day + 7) {
          return "${currentDate.day - dateTime.day}天前";
        } else {
          return extractTimeWithMonthDay(dateTime);
        }
      } else {
        return extractTimeWithMonthDay(dateTime);
      }
    }
    return extractTimeWithYear(dateTime);
  }

  static String extractTime(DateTime dateTime) {
    return "${dateTime.hour}:${dateTime.minute < 10 ? '0' : ''}${dateTime.minute}";
  }

  static String extractTimeWithMonthDay(DateTime dateTime) {
    return "${dateTime.month}/${dateTime.day} ${extractTime(dateTime)}";
  }

  static String extractTimeWithYear(DateTime dateTime) {
    return "${dateTime.year}/${extractTimeWithMonthDay(dateTime)}";
  }

  static String getBirthdayLabel(DateTime dateTime) {
    var yearString = dateTime.year.toString();
    return yearString[yearString.length - 3] +
        (int.parse(yearString[yearString.length - 1]) >= 5 ? "5后" : "0后");
  }

  static String getFormatTime(int timestamp) {
    return formatDate(DateTime.fromMillisecondsSinceEpoch(timestamp), [
      yyyy,
      '-',
      mm,
      '-',
      dd,
      " ",
      HH,
      ':',
      nn,
    ]);
  }

  static String getFormatDate(int timestamp) {
    return formatDate(DateTime.fromMillisecondsSinceEpoch(timestamp), [
      yyyy,
      '-',
      mm,
      '-',
      dd,
    ]);
  }

  static String getSimpleDate(int timestamp) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // 如果是今天
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return '${dateTime.hour}:${dateTime.minute < 10 ? '0' : ''}${dateTime.minute}';
    }
    if (dateTime.year == now.year) {
      return '${dateTime.month}-${dateTime.day}';
    } else {
      return '${dateTime.year.toString().substring(3, 4)}-${dateTime.month}-${dateTime.day}';
    }
  }

  static String getConstellation(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    int month = dateTime.month;
    int day = dateTime.day;
    switch (month) {
      case 1:
        if (day < 21) {
          return "魔羯座";
        }
        return "水瓶座";
      case 2:
        if (day < 20) {
          return "水瓶座";
        }
        return "双鱼座";
      case 3:
        if (day < 21) {
          return "双鱼座";
        }
        return "白羊座";
      case 4:
        if (day < 21) {
          return "白羊座";
        }
        return "金牛座";
      case 5:
        if (day < 22) {
          return "金牛座";
        }
        return "双子座";
      case 6:
        if (day < 22) {
          return "双子座";
        }
        return "巨蟹座";
      case 7:
        if (day < 24) {
          return "巨蟹座";
        }
        return "狮子座";
      case 8:
        if (day < 24) {
          return "狮子座";
        }
        return "处女座";
      case 9:
        if (day < 24) {
          return "处女座";
        }
        return "天秤座";
      case 10:
        if (day < 24) {
          return "天秤座";
        }
        return "天蝎座";
      case 11:
        if (day < 23) {
          return "天蝎座";
        }
        return "射手座";
      case 12:
        if (day < 23) {
          return "射手座";
        }
        return "摩羯座";
      default:
        return "";
    }
  }
}
