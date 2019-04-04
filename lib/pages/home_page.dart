import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../config/httpHeaders.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  //  页面维持
  //  使用的页面必须是StatefulWidget,如果是StatelessWidget是没办法办法使用的。
  //  其实只有两个前置组件才能保持页面状态：PageView和IndexedStack。
  //  重写wantKeepAlive方法，如果不重写也是实现不了的。


  int page = 1;

  List<Map> hotGoodsList=[];

  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  @override
  bool get wantKeepAlive => true;

  String homePageContent = '正在获取数据';

  @override
  void initState() {
    // TODO: implement initState
//    getHomePageContent().then((val) {
//      setState(() {
//        homePageContent = val.toString();
//      });
//    });
  // 通用接口
    var formData = {'lon':'115.02932','lat':'35.76189'};
    request('homePageContent',formData: formData).then((val){
      homePageContent = val.toString();
    });
//    _getHotGoods();
    super.initState();
    print('测试是否重载页面');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+')),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // 数据处理
            var data = json.decode(snapshot.data.toString());
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> navgatorList = (data['data']['category'] as List).cast();
            String advertesPicture =
            data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            List<Map> recommendList = (data['data']['recommend'] as List)
                .cast(); // 商品推荐

            String floor1Title =data['data']['floor1Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
            String floor2Title =data['data']['floor2Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
            String floor3Title =data['data']['floor3Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
            List<Map> floor1 = (data['data']['floor1'] as List).cast(); //楼层1商品和图片
            List<Map> floor2 = (data['data']['floor2'] as List).cast(); //楼层1商品和图片
            List<Map> floor3 = (data['data']['floor3'] as List).cast(); //楼层1商品和图片

//            return SingleChildScrollView(
//                child: Column(
//                  children: <Widget>[
//                    SwiperDiy(
//                      swiperDateList: swiper,
//                    ),
//                    TopNavigator(
//                      navigatorList: navgatorList,
//                    ),
//                    AdBanner(advertesPicture: advertesPicture), //广告组件
//                    LeaderPhone(
//                      leaderImage: leaderImage,
//                      leaderPhone: leaderPhone,
//                    ),
//                    Recommend(recommendList: recommendList),
//
//                    // 楼层拆分
//                    FloorTitle(pictureAddress:floor1Title),
//                    FloorContent(floorGoodsList:floor1),
//                    FloorTitle(pictureAddress:floor2Title),
//                    FloorContent(floorGoodsList:floor2),
//                    FloorTitle(pictureAddress:floor3Title),
//                    FloorContent(floorGoodsList:floor3),
//
//                  ],
//                ));

          // 下拉加载必须使用ListView
            return EasyRefresh(

              refreshFooter: ClassicsFooter(
                key: _footerKey, // 必需
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                noMoreText: '',
                moreInfo: '加载中',
                loadedText: '准备加载',
              ),

              child: ListView(
                children: <Widget>[
                  SwiperDiy(
                    swiperDateList: swiper,
                  ),
                  TopNavigator(
                    navigatorList: navgatorList,
                  ),
                  AdBanner(advertesPicture: advertesPicture), //广告组件
                  LeaderPhone(
                    leaderImage: leaderImage,
                    leaderPhone: leaderPhone,
                  ),
                  Recommend(recommendList: recommendList),

                  // 楼层拆分
                  FloorTitle(pictureAddress:floor1Title),
                  FloorContent(floorGoodsList:floor1),
                  FloorTitle(pictureAddress:floor2Title),
                  FloorContent(floorGoodsList:floor2),
                  FloorTitle(pictureAddress:floor3Title),
                  FloorContent(floorGoodsList:floor3),
                  _hotGoods(),
                ],
              ),
              loadMore: ()async {
                print('开始加载更多....');
                var formPage = {'page': page};
                await request('homePageBelowConten', formData: formPage).then((val){
                  var data = json.decode(val.toString());
                  List<Map> newGoodList = (data['data'] as List).cast();
                  setState(() {
                    hotGoodsList.addAll(newGoodList);
                    page ++ ;
                  });
                });
              },
            );

          } else {
            return Center(
              child: Text('加载中。。。。。'),
              // fontSize: ScreenUtil().setSp(28, false)
              // setSp设置字体大小，false表示app不随着系统大小改变
            );
          }
        },
        future: getHomePageContent(),
      ),
    );
//    //测试获取数据
//    return Container(
//      child: Scaffold(
//        appBar: AppBar(
//          title: Text('百姓生活+'),
//        ),
//        body: SingleChildScrollView(
//          child: Text(homePageContent),
//        ),
//      ),
//    );
  }
  void _getHotGoods(){
    var formPage = {'page': page};
    request('homePageBelowConten', formData: formPage).then((val){
      var data = json.decode(val.toString());
      List<Map> newGoodList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodList);
        page ++ ;
      });
    });
  }

  Widget hotTile = Container(
    margin: EdgeInsets.only(top: 10),
    alignment: Alignment.center,
    padding: EdgeInsets.all(5),
    color: Colors.transparent,
    child: Text('火爆专区'),
  );

  Widget _wrapList(){
    if (hotGoodsList.length != 0){
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: (){
            Application.router.navigateTo(context, "/detail?id=${val['goodsId']}");
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 3),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(370),),
                Text(val['name'], 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(26)),),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}',
                      style: TextStyle(color: Colors.black26, decoration: TextDecoration.lineThrough),),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,// 2列
        children: listWidget,
      );

    }else {
      return Text('');
    }
  }


  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTile,
          _wrapList(),
        ],
      ),
    );
  }


}

//首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDateList;

  SwiperDiy({this.swiperDateList});

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)
//      ..init(context);
//    print('获取设备的像素密度:${ScreenUtil.pixelRatio}');
//    print('获取设备的高:${ScreenUtil.screenHeight}');
//    print('获取设备的宽:${ScreenUtil.screenWidth}');
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "${swiperDateList[index]['image']}",
            fit: BoxFit.contain,
          );
          // contain 原比例  fill 拉伸充满容器  cover 原比例充满超出裁剪
        },
        itemCount: swiperDateList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// GridView类别导航栏
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }

    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),//禁止滚动，与设置的上拉加载冲突
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map(
              (item) {
            return _gridViewItemUI(context, item);
          },
        ).toList(),
      ),
    );
  }
}

//广告图片
class AdBanner extends StatelessWidget {
  final String advertesPicture;

  AdBanner({Key key, this.advertesPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertesPicture),
    );
  }
}

// 店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

// 功能包括：拨打电话 发短信 email 打开网页
  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
//    String url = 'www.baidu.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问，异常';
    }
  }
}

// 楼层类型
class FloorTitle extends StatelessWidget {

  final String pictureAddress;

  FloorTitle({Key key, this.pictureAddress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.network(pictureAddress),
    );
  }
}

// 商品推荐类
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList});

  // 商品标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
          // 模拟器设置BorderSide 的 width 为0.5可能未显示border
          Border(bottom: BorderSide(width: 1, color: Colors.black54))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }


  // 商品单独项
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              left: BorderSide(width: 0.5, color: Colors.black54)
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['mallPrice']}',
              style: TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // 横向列表
  Widget _recommendList() {
    return Container(
        height: ScreenUtil().setHeight(340),
//      margin: EdgeInsets.only(top:10),
//    child: Column(
//      children: <Widget>[
//
//      ],
//    ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // 横向
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(index);
          },
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _titleWidget(),
            _recommendList()
          ],
        ),
      ),
    );
  }
}

// 楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList});

  Widget _goodsItem(Map goods){
    return Container(
      width:ScreenUtil().setWidth(375),
      child: InkWell(
        onTap:(){print('点击了楼层商品');},
        child: Image.network(goods['image']),
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }
}

class HotGoods extends StatefulWidget {

  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {

  @override
  void initState() {
    // TODO: implement initState
//    getHomePageBeloConten().then((val){
////      print(val);
//    });
    // 通用接口
    request('homePageBelowConten',formData: 1).then((val){
      print(val);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("11111111"),
    );
  }
}





//// 伪造请求头请求
//class HomePage extends StatefulWidget {
//  @override
//  _HomePageState createState() => _HomePageState();
//}
//
//class _HomePageState extends State<HomePage> {
//  String showText = '还没有请求数据';
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Scaffold(
//        appBar: AppBar(title: Text("远程数据"),),
//        body: SingleChildScrollView(
//          child: Column(
//            children: <Widget>[
//              RaisedButton(
//                onPressed: _jike,
//                child: Text("请求数据"),
//              ),
//              Text(showText)
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  void _jike(){
//    print('begin query data');
//    getHttp().then((val){
//      setState(() {
//       showText = val['data'].toString();
//      });
//    });
//  }
//
//  Future getHttp() async{
//    try{
//      Response response;
//      Dio dio = new Dio();
//      dio.options.headers = httpHeaders;
//      response = await dio.get("");
//      print(response);
//      return response.data;
//    } catch(e){
//      return print(e);
//    }
//  }
//
//}

// //getHttp()更新页面示例
//class HomePage extends StatefulWidget {
//  @override
//  _HomePageState createState() => _HomePageState();
//}
//
//class _HomePageState extends State<HomePage> {
//  TextEditingController typeController = TextEditingController();
//  String showText = 'welcome to China';
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('美好人间'),
//      ),
//      body: SingleChildScrollView(
//        child:       Container(
//          child: Column(
//            children: <Widget>[
//              TextField(
//                controller: typeController,
//                decoration: InputDecoration(
//                    contentPadding: EdgeInsets.all(10.0),
//                    labelText: '类型',
//                    helperText: '请输入'),
//                autofocus: true, // 防止手机输入框弹出影响页面
//              ),
//              RaisedButton(
//                onPressed: _choiceAction,
//                child: Text("选择完毕"),
//              ),
//              Text(
//                showText,
//                overflow: TextOverflow.ellipsis,
//                maxLines: 1,
//              )
//            ],
//          ),
//        ),
//      )
//
//    );
//  }
//
//  void _choiceAction() {
//    print('begin');
//    if (typeController.text.toString() == "") {
//      showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//                title: Text('input is null'),
//              ));
//    } else {
//      getHttp(typeController.text.toString()).then((val) {
//        setState(() {
//          showText = val['data']['name'].toString();
//        });
//      });
//    }
//  }
//
//  Future getHttp(String TypeText) async {
//    try {
//      Response response;
//      var data = {'name': TypeText};
//      response = await Dio().get(
//          "https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian",
//          queryParameters: data);
//      return response.data;
//    } catch (e) {
//      return print(e);
//    }
//  }
//}

// //getHttp()示例
//class HomePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    getHttp();
//    return Scaffold(
//      body: Center(
//        child: Text('商城首页'),
//      ),
//    );
//  }
//
//  void getHttp() async{
//    try{
//      Response response;
//      response = await Dio().get("https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=hah");
//      return print(response);
//    }catch(e){
//      return print(e);
//    }
//  }
//
//}
