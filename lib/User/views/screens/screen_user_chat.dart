
import 'package:careno/Host/Views/Screens/screen_host_home_page.dart';
import 'package:careno/User/views/layouts/layout_user_messages.dart';
import 'package:careno/User/views/screens/screen_user_home.dart';
import 'package:careno/constant/colors.dart';
import 'package:careno/constant/database_utils.dart';
import 'package:careno/controllers/chat_controller.dart';
import 'package:careno/controllers/home_controller.dart';
import 'package:careno/widgets/custom_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../constant/fcm.dart';
import '../../../constant/firebase_utils.dart';
import '../../../constant/helpers.dart';
import '../../../models/last_message.dart';
import '../../../models/message.dart';
import 'package:careno/models/user.dart' as model;

import '../../../widgets/custom_button.dart';
import '../../../widgets/not_found.dart';
import '../layouts/item_user_chat.dart';
class ScreenUserChat extends StatefulWidget {
  model.User? user;
  int? counter;
  String? chatRoomId;
  int? timeStamp;
  // bool? userblock;
  @override
  State<ScreenUserChat> createState() => _ScreenUserChatState();

  ScreenUserChat({
    this.user,
    this.counter,
    this.chatRoomId,
    this.timeStamp,
    // this.userblock,
  });
}

class _ScreenUserChatState extends State<ScreenUserChat> {
// ChatController controller = Get.put(ChatController());
HomeController homeController = Get.put(HomeController());
  TextEditingController messageController = TextEditingController();
  final _scrollController = ScrollController();
  var chatRoomId = "";
  // late Stream<DatabaseEvent> stream;
  bool isActive=false;
  bool isBlocked = false;
  String message = "";
  Stream<DatabaseEvent> stream = Stream.empty();
RxList<LastMessage> rooms = RxList<LastMessage>([]);
void listenToChatRooms() {
  usersRef.doc(uid).collection("chats").snapshots().listen((snapshot) {
    List<LastMessage> newRooms = snapshot.docs.map((doc) {
      return LastMessage.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    rooms.value = newRooms;
  });
}
  @override
  void initState() {
    checkConditionBlockUser();
    print("Blocked ${isBlocked}");
    print("Blocked ${message}");
    listenToChatRooms();
    checkCondition().then((value) {
      stream = chatref
          .child(chatRoomId).child(FirebaseUtils.myId)
          .onValue;
      // _subscription = stream?.listen((event) {});

      print("chatRoom: $chatRoomId");
      setState(() {});

    });
    super.initState();

    // if (widget.chatRoomId == null) {
    //   roomId().then((value) => {chatRoomId = value});
    //   stream = chatref.child(chatRoomId).onValue;
    //   // clearCounter();
    // } else {
    //   chatRoomId = widget.chatRoomId!;
    //   stream = chatref.child(chatRoomId).onValue;
    //   // clearCounter();
    // }
    clearCounter();
  }
  Future<bool> checkUser() async {
    var exist = await usersRef.doc(FirebaseUtils.myId)
        .collection('chats')
        .doc("${widget.user!.uid}_${FirebaseUtils.myId}")
        .get();
    return exist.exists;
  }
  Future<bool> checkUser2() async {
    var exist = await usersRef.doc(FirebaseUtils.myId)
        .collection('chats')
        .doc("${FirebaseUtils.myId}_${widget.user!.uid}")
        .get();
    return exist.exists;
  }
Future<void> checkConditionBlockUser() async {
  bool userExists = await checkUser();
  bool userExists2 = await checkUser2();

  print("UserExists 1: $userExists");
  print("UserExists 2: $userExists2");

  if (userExists) {
    // Case 1: User exists with chat document using "${widget.user!.uid}_${FirebaseUtils.myId}"
    var userDoc = await usersRef
        .doc(FirebaseUtils.myId)
        .collection('chats')
        .doc("${widget.user!.uid}_${FirebaseUtils.myId}")
        .get();

    if (userDoc.exists) {
      setState(() {
        isBlocked = userDoc.data()?['isBlocked'] ?? false;
        message = userDoc.data()?['chatRoomId'] ?? "ggg";
      });
    }
  } else if (userExists2) {
    // Case 2: User exists with chat document using "${FirebaseUtils.myId}_${widget.user!.uid}"
    var userDoc = await usersRef
        .doc(FirebaseUtils.myId)
        .collection('chats')
        .doc("${FirebaseUtils.myId}_${widget.user!.uid}")
        .get();

    if (userDoc.exists) {
      setState(() {
        isBlocked = userDoc.data()?['isBlocked'] ?? false;
        message = userDoc.data()?['chatRoomId'] ?? "ggg";
      });
    }
  } else {
    // Handle case where neither userExists nor userExists2 is true
    // You can add specific logic here if needed
    print('User does not exist in either case');
  }
}

  Future<void> checkCondition() async {
    if (chatRoomId == '') {
      bool userExists = await checkUser();
      if (userExists) {
        chatRoomId = "${widget.user!.uid}_${FirebaseUtils.myId}";
        // clearCounter();

      } else {
        chatRoomId = "${FirebaseUtils.myId}_${widget.user!.uid}";
      }
    } else {
      chatRoomId = widget.chatRoomId!;
    }
  }
  //
  // Future<String> roomId() async {
  //   String _roomId = '';
  //   bool check = await checkRoomId();
  //   if (check) {
  //     _roomId = "${widget.user.uid}_${FirebaseUtils.myId}";
  //   } else {
  //     _roomId = "${FirebaseUtils.myId}_${widget.user.uid}";
  //   }
  //   return _roomId;
  // }
  //
  // Future<bool> checkRoomId() async {
  //   DocumentSnapshot userSnapshot=await usersRef
  //       .doc(FirebaseUtils.myId)
  //       .collection("chats")
  //       .doc("${widget.user.uid}_${FirebaseUtils.myId}")
  //       .get();
  //   DocumentSnapshot mySnapshot=await usersRef
  //       .doc(FirebaseUtils.myId)
  //       .collection("chats")
  //       .doc("${FirebaseUtils.myId}_${widget.user.uid}")
  //       .get();
  //   if (userSnapshot.exists) {
  //     return userSnapshot.exists;
  //   }
  //
  //   return mySnapshot.exists;
  // }

  Future<void> clearCounter() async {
    try {
      DocumentReference chatRef = usersRef
          .doc(FirebaseUtils.myId)
          .collection("chats")
          .doc(chatRoomId);

      DocumentSnapshot chatSnapshot = await chatRef.get();

      if (chatSnapshot.exists) {
        await chatRef.update({"counter": 0});
      } else {
        // Handle case when document is not found
        print("Document not found: $chatRoomId");
      }
    } catch (error) {
      // Handle error
      print("Error clearing counter: $error");
    }
  }
void clearChat() {
  chatref
      .child(chatRoomId)
      .child(FirebaseUtils.myId)
      .remove()
      .then((_) {
    setState(() {

    });
    print("Chat cleared successfully");
  })
      .catchError((error) {
    print("Error clearing chat: $error");
  });
}


  @override
  Widget build(BuildContext context) {

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(widget.user!.timeStamp);
    String formattedDateTime = DateFormat('hh:mm a').format(dateTime);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        elevation: 1,
        leadingWidth: 75.w,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 10.w,),
              CustomSvg(name: "arrow",),

              Expanded(
                child: CircleAvatar(
                    radius: 20.r,
                    backgroundImage: NetworkImage(widget.user!.imageUrl)
                ),
              ),

            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.user!.name,style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.sp
            ),),
            Text("Last Seen ${formattedDateTime}",style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(.4)
            ),),
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: CustomSvg(name: "more"),
            color: Colors.white,
            itemBuilder: (BuildContext context) {
              return ['Block User', 'Clear Chat'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(
                      color: Color(0xFF272727),
                      fontFamily: "Urbanist",
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList();
            },
            onSelected: (String choice)async {
              if (choice == 'Block User') {
            await    usersRef.doc(FirebaseUtils.myId).collection("chats").doc(chatRoomId).update({""
                    "isBlocked":true}).then((value) {
                      if (homeController.user.value!.userType == "user") {
                        Get.back();
                        Get.offAll(ScreenUserHome);
                      }
                      else{
                        Get.back();
                        Get.offAll(ScreenHostHomePage());

                      }
            });

              } else if (choice == 'Clear Chat') {
                clearChat();
              }
            },
          )

        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: StreamBuilder<DatabaseEvent>(
                stream: stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: AppColors.appPrimaryColor,
                        strokeWidth: 1,
                      ),
                    );
                  }

                  var data = snapshot.data!.snapshot.value;
                  if (data == null) {
                    return Center(
                      child: NotFound(
                        message: "No Messages",
                        color: AppColors.appPrimaryColor,
                      ),
                    );
                  }
                  clearCounter();
                  List<Message> messages = snapshot.data!.snapshot.children
                      .map((e) => Message.fromMap(
                    Map<String, dynamic>.from(e.value as dynamic),
                  ))
                      .toList();
                  messages.sort((b, a) => a.timestamp.compareTo(b.timestamp));
                  return (messages.isNotEmpty)
                      ? Builder(
                    builder: (context) {
                      // Group messages by date
                      Map<String, List<Message>> groupedMessages =
                      groupMessagesByDate(messages);

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: groupedMessages.length + 1,
                        reverse: true,
                        itemBuilder: (context, index) {
                          if (index == groupedMessages.length) {
                            return SizedBox(
                              height: 10,
                            );
                          }

                          // Get messages for the current date group
                          String currentDate = groupedMessages.keys.elementAt(index);
                          List<Message> currentMessages = groupedMessages[currentDate]!;
                          var message = currentMessages.last; // Get the last message in the group

                          // Determine the display date based on the last message
                          String displayDate = getDisplayDate(DateTime.fromMillisecondsSinceEpoch(message.timestamp));

                          return  Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  displayDate,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: currentMessages.length,
                                itemBuilder: (context, messageIndex) {
                                  var message = currentMessages.reversed.toList()[messageIndex];
                                  return GestureDetector(
                                    onTap: () {
                                      // Handle tap on chat message
                                    },
                                    child: ItemUserChat(message: message, displayDate: displayDate),
                                  );
                                },
                              ),
                            ],
                          );

                        },
                      );

                    },
                  )
                      : Center(
                    child: Text(
                      "No Messages",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ),

          isBlocked == false?Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: TextField(
                maxLines: 6,
                minLines: 1,
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Write something...",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: Color(0xFFC6C4CC)
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xFFF2F2F2),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),

                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  errorText: isMessageValid ? null :"Sharing contact not allowed",

                ),

              )),
              InkWell(
                onTap: () async{

                  if (isMessageValid) {
                    setState((){
                      if (widget.counter==null) {
                        widget.counter=1;
                      }
                      else{
                        widget.counter=widget.counter!+ 1;

                      }
                    });

                  }
                  String text = messageController.text.trim();
                  int timestamp = DateTime.now().millisecondsSinceEpoch;
                  if (text.isNotEmpty) {
                    var message = Message(
                      id: timestamp.toString(),
                      timestamp: timestamp,
                      text: text,
                      sender_id: FirebaseUtils.myId,
                      receiver_id: widget.user!.uid,
                      message_type: "text",
                      counter: widget.counter ?? 0,
                    );
                    messageController.clear();
                    // controller.update();
                    sendMessage(message, chatRoomId)
                        .catchError((error) {
                      Get.snackbar("Message", error.toString());
                      print(error.toString());
                    }).then((value) {
                      animateToLastMessage(300);
                      if (widget.user!.notification == true) {

                        FCM.sendMessageSingle(
                            "New Message",
                            message.text,
                            widget.user!.notificationToken.toString(),
                            {});

                      }
                    }).then((value) {
                      print(value);
                    });
                  }
                },
                child: Container(
                    height: 48.h,
                    margin: EdgeInsets.only(left: 10.w
                    ),
                    width: 48.w,
                    // padding: EdgeInsets.all(10.r),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.appPrimaryColor,
                        borderRadius: BorderRadius.circular(8.r)
                    ),
                    child: CustomSvg(name: "ic_Send",)),
              ),
            ],
          ).marginOnly(bottom: 16.h,left: 16.w,right: 16.w):Center(
            child: GestureDetector(
              onTap: (){
                Get.defaultDialog(
                    title: '',
                    content: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            padding: EdgeInsets.all(12.sp),
                            margin: EdgeInsets.symmetric(
                                horizontal: 12.sp),
                            decoration: BoxDecoration(
                                color: Color(0xFFF0F0F0),
                                shape: BoxShape.circle
                            ),
                            child: Icon(
                              Icons.clear, color: Colors.black,)),
                      ),
                    ),
                    actions: [
                      Column(
                        children: [
                          Container(
                            height: 55.h,
                            width: 55.w,
                            padding: EdgeInsets.all(12.sp),
                            decoration: BoxDecoration(
                                color: Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(
                                    20.r)),
                            child: CustomSvg(
                              name: "logout2",
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 10.sp,
                          ),
                          Text(
                            "UnBlock User",
                            style: TextStyle(color: Colors.black,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: "UrbanistBold",),
                          ),
                          SizedBox(
                            height: 13.sp,
                          ),
                          SizedBox(
                            height: 36.h,
                            width: 230.w,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Are you sure you want to UnBlock User?",
                              style: TextStyle(color: Colors.black,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "UrbanistBold",),
                            ),
                          ),
                          CustomButton(
                              width: 193.w,
                              title: "Yes",
                              onPressed: () async{
                                await usersRef.doc(FirebaseUtils.myId).collection("chats").doc(chatRoomId).update({""
                                    "isBlocked":false}).then((value) {
                                  setState(() {
                                    if (homeController.user.value!.userType == "user") {
                                      Get.back();
                                      Get.offAll(ScreenUserHome);
                                    }
                                    else{
                                      Get.back();
                                      Get.offAll(ScreenHostHomePage());
                                    }
                                  });
                                });
                              }).marginSymmetric(vertical: 20.h)
                        ],
                      )
                    ]);

              },
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15.h),
                  width: Get.width,
                  margin: EdgeInsets.symmetric(vertical: 8.h,horizontal: 14.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.appPrimaryColor)
                  ),
                  child: Text("User Block",style: TextStyle(color: Colors.red,fontSize: 20.sp,fontWeight: FontWeight.bold,fontFamily: "Nunito"),)),
            ),
          ),

        ],
      ),
    ));
  }
  bool isMessageValid = true;

  void validateMessage(String message) {
    setState(() {
      isMessageValid = ChatValidator.isMessageValid(message);
    });
  }

  void animateToLastMessage(int animateMillis) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final lastMessageOffset = _scrollController.position.minScrollExtent;
        _scrollController.animateTo(
          lastMessageOffset,
          duration: Duration(milliseconds: animateMillis),
          curve: Curves.easeInOut,
        );
      }
    });
  }
  Map<String, List<Message>> groupMessagesByDate(List<Message> messages) {
    Map<String, List<Message>> groupedMessages = {};

    for (var message in messages) {
      // Convert timestamp to DateTime object
      DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(message.timestamp);

      // Format the date (e.g., "2023-07-12")
      String formattedDate = "${dateTime.year}-${dateTime.month}-${dateTime.day}";

      // Add the message to the corresponding date group
      if (groupedMessages.containsKey(formattedDate)) {
        groupedMessages[formattedDate]!.add(message);
      } else {
        groupedMessages[formattedDate] = [message];
      }
    }

    return groupedMessages;
  }

  String getDisplayDate(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    if (dateTime.isAfter(today)) {
      return "Today";
    } else if (dateTime.isAfter(yesterday)) {
      return "Yesterday";
    } else {
      return DateFormat('MMM dd, yyyy').format(dateTime);
    }
  }

}
class ChatValidator {
  static final List<RegExp> blockPatterns = [
    RegExp(
        r'\b(Facebook|Instagram|Twitter|LinkedIn|Snapchat|whatsApp|Telegram|Discord|WeChat|Skype|Zoom|TikTok|Pinterest|Reddit|Tumblr|Viber|LINE|Kik|Signal|Google Hangouts|Email|Phone|Phone Number|Contact Number|Cell Phone|Cell Phone Number)\b',
        caseSensitive: false),
    RegExp(r'\b(call|phone)\b', caseSensitive: false),
    RegExp(r'\b(\d{4})\b'),
    // Matches 4-digit numbers
    RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b'),
    // Email pattern
    // Add more regex patterns as needed
  ];

  static bool isMessageValid(String message) {
    for (RegExp pattern in blockPatterns) {
      if (pattern.hasMatch(message)) {
        return false;
      }
    }
    return true;
  }

}
