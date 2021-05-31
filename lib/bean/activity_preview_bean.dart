class ActivityPreviewBean {
  String pictureList;
  String title;
  String content;
  int hot;

  ActivityPreviewBean({this.pictureList, this.title, this.content, this.hot});

  ActivityPreviewBean.fromJson(Map<String, dynamic> json) {
    pictureList = json['pictureList'];
    title = json['title'];
    content = json['content'];
    hot = json['hot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pictureList'] = this.pictureList;
    data['title'] = this.title;
    data['content'] = this.content;
    data['hot'] = this.hot;
    return data;
  }

  static List<ActivityPreviewBean> data = [
    ActivityPreviewBean(
        title: "甘肃陇南支教",
        content: '''说起大西北，我们想到的可能是原始粗旷又浪漫温情的大漠草场。但这片令无数人心向往之的地方，却也有着不为人知的真实一面——山大沟深、人多地少、贫困面大是这里地理人文写照。
    这次我们想带大家走进的是甘肃陇南，这里是秦文化的真正发祥地，拥有闻名世界的文化瑰宝。以前这里也是秦巴山集中连片特困地区。我们将来到甘肃礼县永坪镇小学，开展支教活动，并通过共同参与孩子们的日程生活（一起放牧、农耕、进行家访等），陪伴乡村的孩子们度过一个难忘的假期，共同谱写“山海情”。''',
        hot: 425,
        pictureList:
            "https://www.gappernet.org/upload/travel/104/scheduling/509/20210519123338_748.png,https://www.gappernet.org/upload/travel/104/scheduling/510/20210519123518_244.png,https://www.gappernet.org/upload/travel/104/scheduling/511/20210519123629_654.png"),
    ActivityPreviewBean(
        title: "内蒙锡林郭勒草原保护",
        content: '''说到内蒙古，你想到了什么？
是风吹草低见牛羊的大草原，还是广袤原始的静谧森林，亦或是自由奔放驰骋在草原上的蒙古族牧民。
无论如何，内蒙都逃不开“草原”两字。草原仿佛有一种魔力，让人初见它，便泛起了大地千百万年来亘古的记忆：原始，质朴，宁静，温暖……
这一次我们的内蒙之行，没有选择人满为患的大型景区草场，而是选择了锡林浩特盟下面的哈夏图嘎查。这里远离游客，是真正蒙古族的夏季牧场。
在这里我们将和当地蒙古族的环保公益青年一起，开展草场植被调研，探寻关于畜牧环境维护及改善的途径。探访传统的游牧部落，感受完整保留的草原文化，切身为草原保护贡献一份力量。在浩瀚苍穹之下，重新体悟人与自然的关系。''',
        hot: 256,
        pictureList:
            "https://www.gappernet.org/upload/travel/102/scheduling/490/20210430172337_284.png,https://www.gappernet.org/upload/travel/102/scheduling/493/20210430173651_894.png,https://www.gappernet.org/upload/travel/102/scheduling/494/20210430174246_504.png,https://www.gappernet.org/upload/travel/102/tj/20210430170000_914.png"),
    ActivityPreviewBean(
        title: "西双版纳边境守护计划",
        content: '''这里被誉为国门第一村，是中国最南端的陆地边塞小镇；这里是中老两国交界，也是我国唯一一条通往老挝的陆路通道。
独特的地理位置让这里拥有丰富的民族资源，傣族、哈尼族、基诺族、布朗族、拉枯族的村寨在这里共同生活和谐共处。这里是西双版纳的最南端，地球北回归线沙漠带上唯一的一片绿洲，这里拥有丰富的热带雨林资源。

特殊的地理环境让磨憨的教育资源变得有限，这次我们来到脱贫攻坚后的边境村，走入国门第一小学及少数民族社区，跟当地的孩子们一起分享知识，开展阅读活动；跟着边防民兵一起徒步热带雨林学习户外生存技巧，围坐篝火倾听英雄儿女保卫边境线的故事；探访茶山，了解贫困村赖以生存的茶贸易制作过程，跟着茶农一起品尝一顿风味独特的农家饭。''',
        hot: 847,
        pictureList:
            "https://www.gappernet.org/upload/travel/98/scheduling/472/20210414222608_741.png,https://www.gappernet.org/upload/travel/98/scheduling/473/20210418200014_865.png,https://www.gappernet.org/upload/travel/98/scheduling/20210414181806_213.png"),
    ActivityPreviewBean(
        title: "海南西岛环保实践",
        content:
            '''坐标祖国版图的南端的海南，永远不缺极致的海滨风光。和煦的阳光、清新的空气、湛蓝的大海……关于夏日海岛的一切想象都能在这里找到。

这是一个在中国还未被完全开发的外岛，居住着4000多的原住岛民，世世代代以捕鱼为生。这里拥有可以媲美泰国越南巴厘岛的“斐济蓝”海水，有最新鲜又便宜的海鲜，有环保艺术家的探访驻足，也有一路向南的渔村。
这里就是被誉为中国最南艺术之岛的——海南西岛。''',
        hot: 847,
        pictureList:
            "https://www.gappernet.org/upload/travel/94/tj/20210304220342_492.jpg,https://www.gappernet.org/upload/travel/94/scheduling/441/20210304221017_766.jpg,https://www.gappernet.org/upload/travel/94/scheduling/443/20210304221940_491.jpg,https://www.gappernet.org/upload/travel/94/scheduling/20210304220342_878.jpg"),
    ActivityPreviewBean(
        title: "大理学校教学",
        content:
            '''凤羽镇从唐代开始就有人居住，之前是茶马古道中转站，所以不仅保留有白族的文化，也有汉族和国外的文化。凤羽镇凤翔村坐落在罗坪山东麓，北连振兴，南接源胜，东临江登，该地人口集中，是大理第二大的纯白族聚居的村落，民风淳朴勤劳，居民收入主要以农业生产和乳牛饲养以及外出经商、务工为主。村落人口约8000人，凤羽90%以上都是白族，当地有名的文化包括：甲马、木雕、壁画、砚台等。

凤翔中心完小位于云南省大理州洱源镇凤羽镇凤翔村，共有260多名学生，其中一半为留守儿童。全校分为6个年级，其中二年级和四年只有一个班级，其余年级都有两个班级。每个班级平均30名学生左右，全校有约20名老师。
''',
        hot: 1024,
        pictureList:
            "https://www.gappernet.org/upload/travel/96/tj/20210406225957_174.png,https://www.gappernet.org/upload/travel/96/scheduling/20210406225958_987.png,https://www.gappernet.org/upload/travel/96/scheduling/458/20210406230024_246.png,https://www.gappernet.org/upload/travel/96/scheduling/459/20210406230033_711.png,https://www.gappernet.org/upload/travel/96/scheduling/461/20210406230100_323.png"),
  ];
}
