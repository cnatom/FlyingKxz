import 'package:flutter/cupertino.dart';

import '../components/received_message_screen.dart';
import 'link_card.dart';

class DetailInfo{
  late List<Widget> info;
  DetailInfo.mjt(){
    info = [
      ReceivedMessageScreen(message: "👋你好呀～"),
      ReceivedMessageScreen(message: '😁我是负责客户端开发与UI设计的牟金腾，你也可以叫我"阿腾木"！'),
      ReceivedMessageScreen(message: '🎉2020年的10月7日，矿小助诞生。历时数年，迭代数百次，更新至今。'),
      ReceivedMessageScreen(message: "2022年，希望有更多技术爱好者能够参与建设矿小助。于是，矿小助开源啦！（欢迎Star✨～）",linkModel: AboutLinkModel("https://github.com/cnatom/FlyingKxz","FlyingKxz-矿小助源代码","矿小助——矿大人自己的APP｜iOS&Android跨平台应用"),),
      ReceivedMessageScreen(message: "☘️矿小助是用Flutter技术开发的，如果你对这门技术很感兴趣，欢迎加入本校最强的互联网团队——翔工作室参与学习！",linkModel: AboutLinkModel("https://flyingstudio.feishu.cn/docs/doccnuWFYfcbHUZ65FmKB3iA6pf","关于翔工作室","矿大最强互联网团队，"),),
      ReceivedMessageScreen(message: "🧑🏻‍💻这是我的Github，保存了我做过的部分项目。如果你也同样热爱移动客户端技术，欢迎关注我，一起交流学习！",linkModel: AboutLinkModel("https://github.com/cnatom","CUMT-Atom的Github主页","移动开发热爱者"),),
      ReceivedMessageScreen(message: "📒我的技术博客，记录了学习历程（有大一编程课的答案哦）～",linkModel: AboutLinkModel("https://blog.csdn.net/qq_15989473?type=blog","阿腾木的小世界","Android、iOS、Flutter、爬虫、后端、大数据、AI"),),
      ReceivedMessageScreen(message: "🐧我的QQ，如果你有设计天赋以及极强的强迫症，欢迎Q我！",linkModel: AboutLinkModel("https://qm.qq.com/cgi-bin/qm/qr?k=Io1xjbyMFhZIFoZzdR2aAdjLjvGI5E9f&noverify=0","阿腾木","喜欢就坚持吧！"),),
    ];
  }
  DetailInfo.lyz(){
    info = [
      ReceivedMessageScreen(message: "🥰 Ciallo～"),
      ReceivedMessageScreen(message: "😀 我是负责后端系统设计的吕迎朝，你也可以叫我 boopo 或者 出梦"),
      ReceivedMessageScreen(message: "🤔 多年以后，面对SQLite, 我还会想起矿小助1.0发布的下午。那时的我刚学会增删改查，服务因为并发写入而阻塞。。。"),
      ReceivedMessageScreen(message: "😋 如果你对后端技术感兴趣，欢迎加入翔工作室"),
      ReceivedMessageScreen(message: "🥳 我会在这里更新一些文章",linkModel: AboutLinkModel("https://www.yuque.com/boopo","出梦的数字花园","Not Invented Here Syndrome"),),
      ReceivedMessageScreen(message: "😊 这是我的github",linkModel: AboutLinkModel("https://github.com/boopo","boopo·Github","服务端开发"),),
      ReceivedMessageScreen(message: "🐧",linkModel: AboutLinkModel("https://qm.qq.com/cgi-bin/qm/qr?k=8GF1c-Xz8LjAupERFAkskIoJwt8C7U8M&noverify=0&personal_qrcode_source=3","boopo","西郊有密林，助君出重围"),),
    ];
  }
  DetailInfo.gyf(){
    info = [
      ReceivedMessageScreen(message: '🌸很高兴在这里和你相遇，我是"花学长"！'),
      ReceivedMessageScreen(message: "☘️矿小助的成长历程贯穿了我的大学生活，创作宣传视频，设计新版LOGO，开发下载官网，编写运营推文。用不长不短的四年，做几件值得骄傲一生的事情，真的很有意义！",linkModel: AboutLinkModel("https://kxz.atcumt.com/","矿小助官网","矿大人都在用的宝藏App"),),
      ReceivedMessageScreen(message: "🤩你绝对想不到，我最初加入的是视频组。但是四年时间里，我学习了设计，运营，开发，产品等各种互联网知识，翔工作室是互联网爱好者的乐园，加入我们，我们一起飞翔！",linkModel: AboutLinkModel("https://flyingstudio.feishu.cn/wiki/wikcnx2KKhcZ7Eza3gJq1x0Y4Yg","关于翔工作室","中国矿业大学最早的，由学生自主管理的校园互联网工作室"),),
      ReceivedMessageScreen(message: "🎉我的Blog",linkModel: AboutLinkModel("https://abiscuit.net","abiscuit's dream","喜欢做梦，想变成光"),),
      ReceivedMessageScreen(message: "🐧我的QQ",linkModel: AboutLinkModel("https://qm.qq.com/cgi-bin/qm/qr?k=9aggfWj5RMDqYhoUXPJc_RvP3IWmcUY2","花","我要相信光！"),),
    ];
  }
  DetailInfo.wym(){
    info = [
      ReceivedMessageScreen(message: "🎉欢迎！~"),
      ReceivedMessageScreen(message: "😌我是给矿小助写过后台管理系统的王逸鸣"),
      ReceivedMessageScreen(message: "🐵刚加入翔工作室的时候，我还懵懂无知。大学四年，我在这里学习了很多开发知识，了解了各种领域信息，也结识了许多志同道合的朋友。"),
      ReceivedMessageScreen(message: "🐮我们翔工作室里藏龙卧虎，这里群英荟萃，各方大佬各显神通。如果你对软件开发充满了兴趣和热情，欢迎加入我们，让我们一起发光发亮！"),
      ReceivedMessageScreen(message: "💻这是我的Github，如果你对制作新奇有趣的软件或游戏有想法，欢迎一起交流讨论",linkModel: AboutLinkModel("https://github.com/Kousaka-Mayuri","Kousaka-Mayuri","前端开发热爱者"),),
      ReceivedMessageScreen(message: "📒我的csdn博客，记录过部分编程和开发知识，希望能对你有点帮助。",linkModel: AboutLinkModel("https://blog.csdn.net/qq_35424155?type=blog","Kousaka-Mayuri","React、Flutter、JavaScript"),),
      ReceivedMessageScreen(message: "🐧我的QQ",linkModel: AboutLinkModel("https://qm.qq.com/cgi-bin/qm/qr?k=g95UGdDTWH6v6QW_raDmpruRQo41dAKD&noverify=0","突然之间","承行于地，如于天焉"),),
    ];
  }
  DetailInfo.ljx(){
    info = [
      ReceivedMessageScreen(message: '🤩Hi！Hi！Hi！！！！'),
      ReceivedMessageScreen(message: "🥳我是负责运营岗，为矿小助做运营宣讲的李家鑫er～"),
      ReceivedMessageScreen(message: "🥺从大一入学面试工作室时被要求“做一个矿小助的竞品分析”开始，到大三时真的能有机会参与其中和大家一起完善并让更多的人知道、了解甚至喜欢上矿小助！在工作室能遇到这些性格超棒、能力出众的矿小助开发者们并且一起努力过，是我大学生活里非常宝贵的一段经历呜呜呜"),
      ReceivedMessageScreen(message: "💃如果你喜欢运营、开发、设计、交好朋友就来来来！！和志同道合的人在一起才能享受到真正的happy！！"),
      ReceivedMessageScreen(message: "🐧我的QQ",linkModel: AboutLinkModel("https://qm.qq.com/cgi-bin/qm/qr?k=0gMMg5HdT7h84lRr0FdJ6XsfviWPrjZO&noverify=0&personal_qrcode_source=3","小啵","北海虽赊，扶摇可接"),),
    ];
  }
  DetailInfo.lcy(){
    info = [
    ReceivedMessageScreen(message: '👋Hi~'),
    ReceivedMessageScreen(message: '😌我是矿小助的UI设计罗纯颖。'),
    ReceivedMessageScreen(message: "😀很高兴能为矿小助的成长出一份力。",linkModel: AboutLinkModel("https://kxz.atcumt.com/","矿小助官网","矿大人都在用的宝藏App"),),
    ReceivedMessageScreen(message: "🤩在工作室学到了很多东西，认识了很多很厉害的人。工作室聚会也很好玩，东西很好吃。",linkModel: AboutLinkModel("https://flyingstudio.feishu.cn/wiki/wikcnx2KKhcZ7Eza3gJq1x0Y4Yg","关于翔工作室","中国矿业大学最早的，由学生自主管理的校园互联网工作室"),),
    ReceivedMessageScreen(message: "🐧我的QQ",linkModel: AboutLinkModel("https://qm.qq.com/cgi-bin/qm/qr?k=EQurywQsQw_Nnui-a-ctn3hjuTTil_4S&noverify=0&personal_qrcode_source=4","很多","很多饭没吃"),),
    ];
  }
}