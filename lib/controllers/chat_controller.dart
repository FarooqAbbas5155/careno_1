import 'package:get/get.dart';

import '../constant/helpers.dart';
import '../models/last_message.dart';

class ChatController extends GetxController{

  @override
  void onInit() {
  listenToChatRooms();

    super.onInit();
  }
  RxString userId = "".obs;
  RxList<LastMessage> rooms = RxList<LastMessage>([]);
  void listenToChatRooms() {
    usersRef.doc(uid).collection("chats").snapshots().listen((snapshot) {
      List<LastMessage> newRooms = snapshot.docs.map((doc) {
        return LastMessage.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      rooms.value = newRooms;
    });
  }

}