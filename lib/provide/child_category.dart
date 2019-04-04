import 'package:flutter/material.dart';

import '../model/category.dart';

//ChangeNotifier的混入是不用管理听众

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0 ; // 子类高亮索引
  String categoryId = '4'; // 大类ID
  String subId = '';//小类
  int page = 1; //列表页数
  String noMoreText = ''; // 显示没有数据的文字

  getChildCategory(List<BxMallSubDto> list, String id) {
    childIndex = 0 ; // 点击大类清零
    page = 1;
    noMoreText = '';
    categoryId=id;
    BxMallSubDto all = BxMallSubDto();
    all.mallCategoryId='00';
    all.mallSubName="全部";
    all.mallSubId="";
    all.comments="null";
    childCategoryList=[all];
    childCategoryList.addAll(list);
    // childCategoryList = list;

    notifyListeners(); // 数值改变时的监听器
  }

  // 改变子类索引
  changeChildIndex(index, String id){
    childIndex = index;
    page = 1;
    noMoreText = '';
    subId = id;
    notifyListeners();
  }

  // 增加Page方法
  addpage(){
    page++;
  }

  changeNoMore(String text){
    noMoreText = text;
    notifyListeners();
  }

}
