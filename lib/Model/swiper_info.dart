/// status : 200
/// msg : "ok"
/// data : [{"image-url":"http://www.cumt.edu.cn/_upload/article/images/6e/9b/40047ff14838aea1355117147eb6/b4175c83-919c-487a-be25-e485a873c18c.jpeg"},{"image-url":"http://www.cumt.edu.cn/_upload/article/images/65/a7/748a3f114d2bbb8fe1dd038d088d/6d3d93c2-fde9-41e3-a825-65241378ca57.jpg"},{"image-url":"http://www.cumt.edu.cn/_upload/article/images/c8/ee/26b7e17d4840b6f378b31531751e/2777b695-68de-42dc-8ae3-463527d8d13b.jpg"},{"image-url":"http://www.cumt.edu.cn/_upload/article/images/e9/47/292d616c41ac8cfbf058095f8627/a7aac6cc-f76f-4415-a7b6-37fd10ebacb5.jpg"},{"image-url":"http://www.cumt.edu.cn/_upload/article/images/88/57/b5af5bb2487a87cc87a8e8565735/54fd901c-24de-441f-a16f-d59ea83db6a4.jpg"},{"image-url":"http://www.cumt.edu.cn/_upload/article/images/77/36/8e002d744efa988e4e71b6a03a17/4c5fb7e0-9ac1-4c44-9d02-849a71e45f7b.jpg"}]

class SwiperInfo {
  int status;
  String msg;
  List<Data> data;

  SwiperInfo({
      this.status, 
      this.msg, 
      this.data});

  SwiperInfo.fromJson(dynamic json) {
    status = json["status"];
    msg = json["msg"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = status;
    map["msg"] = msg;
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// image-url : "http://www.cumt.edu.cn/_upload/article/images/6e/9b/40047ff14838aea1355117147eb6/b4175c83-919c-487a-be25-e485a873c18c.jpeg"

class Data {
  String image;

  Data({
      this.image});

  Data.fromJson(dynamic json) {
    image = json["image-url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["image-url"] = image;
    return map;
  }

}