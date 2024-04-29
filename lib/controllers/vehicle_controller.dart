import 'package:careno/constant/firebase_utils.dart';
import 'package:careno/constant/helpers.dart';
import 'package:careno/models/add_host_vehicle.dart';
import 'package:get/get.dart';

class VehicleController extends GetxController{

  Future<void> checkCondition(AddHostVehicle hostVehicle ) async {
      bool userExists = await checkUser(hostVehicle.vehicleId);
      if (userExists) {

      } else {

       await addVehicleRef.doc(hostVehicle.vehicleId).collection("views").doc(hostVehicle.hostId).set(hostVehicle.toMap());
      }
  }

  Future<bool> checkUser(String vehicleId) async {
    var exist = await addVehicleRef.doc(vehicleId)
        .collection('views')
        .doc(FirebaseUtils.myId)
        .get();
    return exist.exists;
  }

}