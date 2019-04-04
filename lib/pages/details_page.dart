import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';

class DetailPage extends StatelessWidget {
  final String goodsId;

  DetailPage(this.goodsId);
  
  @override
  Widget build(BuildContext context) {
    _getBackInfo(context);
    return Container(
      child: Text('商品ID:${goodsId}'),
    );
  }

  void _getBackInfo(BuildContext context) async{
    await  Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
      print('商品详情获取加载完成............');
  }

}