class GenderConst {
  static const int secret = 0;

  static const int male = 1;

  static const int female = 2;

  static final Map<int, String> descriptionMap = {
    0: "保密",
    1: "男",
    2: "女",
  };
}

class EmotionStatusConst {

  static const int secret = 0;

  static const int alwaysSolo = 1;

  static const int waiting = 2;

  static const int freedom = 3;

  static const int loving = 4;

  static const int hardToSay = 5;

  static final Map<int, String> descriptionMap = {
    0: "保密",
    1: "母胎solo",
    2: "等TA出现",
    3: "自由可撩",
    4: "恋爱中",
    5: "一言难尽",
  };
}
