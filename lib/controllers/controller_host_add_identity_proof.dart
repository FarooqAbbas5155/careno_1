import 'package:careno/constant/helpers.dart';
import 'package:careno/models/wallet_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Host/Views/Screens/screen_host_account_pending.dart';
import '../constant/firebase_utils.dart';
import '../models/host_identity.dart';

class ControllerHostAddIdentityProof extends GetxController {
  RxString insurancePath = "".obs;
  RxString idFrontPath = "".obs;
  RxString idBackPath = "".obs;
  RxBool loading = false.obs;

  Future<String> updateIdentityProof() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    String response = '';
    loading.value = true;

    String insurancePathUrl = await FirebaseUtils.uploadImage(
            insurancePath.value, "User/Host${id}/IdentityProof/insurancePath")
        .catchError((error) {
      loading.value = false;
      response = error.toString();
    });
    String idFrontPathUrl = await FirebaseUtils.uploadImage(
            idFrontPath.value, "User/Host${id}/IdentityProof/idFrontPath/")
        .catchError((error) {
      loading.value = false;
      response = error.toString();
    });
    String idBackPathUrl = await FirebaseUtils.uploadImage(
            insurancePath.value, "User/Host${id}/IdentityProof/idBackPath/")
        .catchError((error) {
      loading.value = false;
      response = error.toString();
    });

    HostIdentity hostIdentity = HostIdentity(
      insurancePath: insurancePathUrl,
      idFrontPath: idFrontPathUrl,
      idBackPath: idBackPathUrl,
    );

    WalletModel defaultWallet = WalletModel(
      currentBalance: 0.0,
      date: DateTime.now().toString(),
      paymentHistory: []
    );

    await usersRef.doc(uid).update({
      "hostWallet":defaultWallet.toMap(),
      "hostIdentity": hostIdentity.toMap(),
    }).then((value) {
      Get.offAll(ScreenHostAccountPending());
      response = "success";
      loading.value = false;
    }).catchError((error) {
      response = error.toString();
      loading.value = false;
    });
    return response;
  }
}
