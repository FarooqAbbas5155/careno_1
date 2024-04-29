import 'package:careno/User/views/screens/screen_search_result.dart';
import 'package:careno/widgets/custom_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemSearch extends StatelessWidget {
  const ItemSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Color(0xffF6F6F6),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              Get.to(ScreenSearchResult());
            },
            child: ListTile(
              leading: Icon(Icons.history),
              title: Text("Tesla Model 3",style: TextStyle(fontWeight: FontWeight.w500,fontFamily: "UrbanistBold",fontSize: 13.sp)),
              trailing: Image.asset("assets/images/arrow_upward.png",width: 35.w,),
            ),
          ),
          Divider(
            color: Color(0xffEDEEEE).withOpacity(.5),
            thickness: 2,
            indent: 1,
            endIndent: 1,
          )

        ],
      ),
    );
  }
}
