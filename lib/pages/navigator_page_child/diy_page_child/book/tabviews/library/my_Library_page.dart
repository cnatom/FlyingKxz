import 'package:flutter/cupertino.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/book/tabviews/library/model.dart';

class MyLibraryPage extends StatefulWidget {
  const MyLibraryPage({Key? key}) : super(key: key);

  @override
  State<MyLibraryPage> createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage> {
  MyLibraryModel model = MyLibraryModel();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
