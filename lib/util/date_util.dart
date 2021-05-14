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
    return yearString[yearString.length - 3] + (int.parse(yearString[yearString.length - 1]) >= 5 ? "5后" : "0后");
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
    print('time: $timestamp');
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // 如果是今天
    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day) {
      return '${dateTime.hour}:${dateTime.minute}';
    }
    if (dateTime.year == now.year) {
      return '${dateTime.month}-${dateTime.day}';
    } else {
      return '${dateTime.year.toString().substring(3,4)}-${dateTime.month}-${dateTime.day}';
    }
  }

}