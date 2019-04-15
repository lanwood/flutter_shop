import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier{
  DetailsModel goodsInfo = null;

  bool isLeft = true;
  bool isRight = true;

  // tabbar 的切换方法
  changeLeftAndRight(String changeState){
    if(changeState=='left'){
      isLeft=true;
      isRight=false;
    }else{
      isLeft=false;
      isRight=true;
    }
     notifyListeners();
  }

// 后台获取商品详细数据
  getGoodsInfo(String id) async{
    var formData = {'goodId': id};
    await request('getGoodDetailById', formData:formData).then((onValue){
      var responseData = json.decode(onValue.toString());
      print(responseData);
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }

}