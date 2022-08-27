import 'package:flutter/cupertino.dart';

import '../components/received_message_screen.dart';
import 'link_card.dart';

class DetailInfo{
  List<Widget> info;
  DetailInfo.mjt(){
    info = [
      ReceivedMessageScreen(message: "👋你好呀～"),
      ReceivedMessageScreen(message: '😁我是负责客户端开发与UI设计的牟金腾，你也可以叫我"阿腾木"～'),
      ReceivedMessageScreen(message: "🎉2020年的10月7日，矿小助诞生。历时数年，迭代数百次，虽有不足，但已尽心尽力。2022年，即将本科毕业的我，希望有更多技术爱好者能够参与建设矿小助，将其延续下去。于是，矿小助开源了。（欢迎Star✨～）",linkModel: AboutLinkModel("https://github.com/cnatom/FlyingKxz","FlyingKxz-矿小助源代码","矿小助——矿大人自己的APP｜iOS&Android跨平台应用"),),
      ReceivedMessageScreen(message: "☘️矿小助是用Flutter技术开发的，如果你对这门技术很感兴趣，欢迎加入本校最强的互联网团队——翔工作室参与学习！",linkModel: AboutLinkModel("https://flyingstudio.feishu.cn/docs/doccnuWFYfcbHUZ65FmKB3iA6pf","关于翔工作室","矿大最强互联网团队，"),),
      ReceivedMessageScreen(message: "🧑🏻‍💻这是我的Github，保存了我做过的部分项目。如果你也同样热爱移动客户端技术，欢迎关注我，一起交流学习！",linkModel: AboutLinkModel("https://github.com/cnatom","CUMT-Atom的Github主页","移动开发热爱者"),),
      ReceivedMessageScreen(message: "📒我的技术博客，记录了学习历程（有大一编程课的答案哦）～",linkModel: AboutLinkModel("https://blog.csdn.net/qq_15989473?type=blog","阿腾木的小世界","Android、iOS、Flutter、爬虫、后端、大数据"),),
      ReceivedMessageScreen(message: "🐧我的QQ",linkModel: AboutLinkModel("https://qm.qq.com/cgi-bin/qm/qr?k=Io1xjbyMFhZIFoZzdR2aAdjLjvGI5E9f&noverify=0","阿腾木","喜欢就坚持吧！"),),
    ];
  }
  DetailInfo.lyz(){
    info = [

    ];
  }

}