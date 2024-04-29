import 'dart:async';

import 'package:careno/AuthSection/screen_complete_profile.dart';
import 'package:careno/controllers/controller_update_profile.dart';
import 'package:careno/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/phone_controller.dart';
import '../widgets/custom_button.dart';
import '../constant/helpers.dart';
import '../constant/location_utils.dart';


class ScreenLocation extends StatefulWidget {

  @override
  State<ScreenLocation> createState() => _ScreenLocationState();
}

class _ScreenLocationState extends State<ScreenLocation> {
  ControllerUpdateProfile controller = Get.put(ControllerUpdateProfile());
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  String? setLocationOnMap;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GoogleMapController? mapController;



  // var address = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // initializeComponent();
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: Get.height,
          width: Get.width,
          child: Stack(
            children: [
              GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition:  CameraPosition(
                    target: LatLng(controller.latitude.value, controller.longitude.value),
                    zoom: 14),

                // onCameraIdle: () async {
                //
                //   LatLngBounds? bounds = await mapController?.getVisibleRegion();
                //   final lon = (bounds!.northeast.longitude + bounds.southwest.longitude) / 2;
                //   final lat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
                //   print("LatLngBounds: $lat $lon");
                //   String? address= await getAddressFromLatLng(lat,lon);
                //   print("address is: $address");
                //   if(setLocationOnMap!=null){
                //
                //     setState(() {});
                //   }
                // },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  mapController=controller;

                },
                markers: Set<Marker>.of(markers.values),

              ),

              Positioned(
                top: 10.h,
                left: 10,
                right: 10,
                child:  Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                              Icons.arrow_back, color: Colors.black),
                        ),
                        Text(
                          "Location Map",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: "UrbanistBold",
                          ),
                        ),
                       SizedBox()

                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                          onTap:() async {
                            print("kddk");
                            Prediction? p = await PlacesAutocomplete.show(
                              context: context,
                              apiKey: googleApiKey,
                              hint: "Search Address",
                              mode: Mode.overlay, // Mode.fullscreen
                              language: "en",
                              types: [], components: [new Component(Component.country, "pak")],
                              strictbounds: false,
                            );
                            if(p!=null){
                              displayPrediction(p);
                            }
                            print("destination location select is: ${p?.description}");

                          },
                          child: Container(
                            height: 48.h,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  25.r),

                            ),
                            child: Text(controller.address.value!=''?'${controller.address.value}': 'search your location here',maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                                        ),
                        ),
                        GestureDetector(
                          onTap:() async {
                            print("kddk");
                            Prediction? p = await PlacesAutocomplete.show(
                              context: context,
                              apiKey: googleApiKey,
                              hint: "Search Address",
                              mode: Mode.overlay, // Mode.fullscreen
                              language: "en",
                              types: [], components: [new Component(Component.country, "pak")],
                              strictbounds: false,
                            );
                            if(p!=null){
                              displayPrediction(p);
                            }
                            print("destination location select is: ${p?.description}");

                          },
                          child: Container(
                            height: 45.h,
                            width: 48.w,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(6.sp),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle
                            ),
                            child: Icon(
                              Icons.search, color: Colors.white,),
                          ).marginSymmetric(horizontal: 8.w),
                        )
                      ],
                    ).marginSymmetric(horizontal: 20.w),
                  ],
                ),),

              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: CustomButton(title: "Save", onPressed: () async {
                  Get.back(result: true);
                }, isLoading: false),
              )
            ],
          ),
        ),
      ),
    );
  }
  mapNavigateOnPoints(double lat,double long) async {
    CameraPosition _kLake = CameraPosition(
      // bearing: 192.8334901395799,
        target: LatLng(lat,long),
        // tilt: 59.440717697143555,
        zoom: 6);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
  displayPrediction(Prediction? p,) async {

    if (p != null) {
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: googleApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );

      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId??"");

      var placeId = p.placeId;
      controller.latitude.value = detail.result.geometry!.location.lat;
      controller.longitude.value  = detail.result.geometry!.location.lng;
      var addres  =detail.result.formattedAddress;
      controller.address.value = addres!;
      // if(pickUpLocation){
      //   pickupAddress=LocationModel(location: address,lat: lat,long: long);
      //
      // }else{
      //   destinationAddress=LocationModel(location: address,lat: lat,long: long);

      // }

      print("lat is: $controller.longitude.value");
      print("long is: $controller.longitude.value");
      if(controller.latitude.value!=null && controller.longitude.value!=null){
        await add(controller.latitude.value,controller.longitude.value,controller.address.value);

        mapNavigateOnPoints(controller.latitude.value,controller.longitude.value);
      }
      setState(() {});
    }
  }
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  add(double lat, double long,String? address) async {
    int markerIdVal = 123;
    final MarkerId markerId = MarkerId(markerIdVal.toString());

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        lat,
        long,
      ),
      infoWindow: InfoWindow(title: "Searched Location", snippet: address),
      onTap: () {
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }
}
