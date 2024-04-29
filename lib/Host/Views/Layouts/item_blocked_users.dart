import 'package:careno/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemBlockedUsers extends StatelessWidget {
  const ItemBlockedUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage("assets/images/block.png"),
      ),
      title: Text("Sahin Ozdemir",style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 15.sp
      ),),
      trailing: CustomButton(
        height: 31.h,
        width: 100.w,
        title: 'Unblock',textStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white

      ), onPressed: () {  },),
    );
  }
}
