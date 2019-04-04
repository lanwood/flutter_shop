import 'package:flutter/material.dart';
import './pages/index_page.dart';
import './provide/child_category.dart';
import 'package:provide/provide.dart';
import './provide/category_goods_list.dart';
import './provide/details_info.dart';
import 'package:fluro/fluro.dart';
import './routers/routers.dart';
import './routers/application.dart';

// void main()=>runApp(MyApp());

// 添加状态管理
void main(){
    var childCategory=ChildCategory();
    var categoryGoodsListProvide = CategoryGoodsListProvide();
    var detailsInfoProvide = DetailsInfoProvide();
    var providers=Providers();
    // final router = Router();

    providers
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide));
    runApp(ProviderNode(child:MyApp(),providers:providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final router = Router();
    Routers.configureRouters(router);
    Application.router=router;

    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Application.router.generator,
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
      ),
    );
  }
}
