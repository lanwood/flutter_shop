import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier{
  DetailsModel goodsInfo = null;

// 后台获取商品详细数据
  getGoodsInfo(String id){
    var formData = {'goodId': id};
    request('getGoodDetailById', formData:formData).then((onValue){
      var responseData = json.decode(onValue.toString());
      print(responseData);
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }

}