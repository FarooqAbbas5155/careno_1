import 'dart:async';
import 'dart:developer';

import 'package:careno/controllers/home_controller.dart';
import 'package:careno/models/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../../../Host/Views/Screens/screen_host_notification.dart';
import '../../../constant/colors.dart';
import '../../../constant/helpers.dart';
import '../../../constant/location_utils.dart';
import '../../../widgets/custom_button.dart';
import '../screens/screen_car_details.dart';
import '../screens/screen_filter.dart';
import '../screens/screen_search_result.dart';
import '../screens/screen_user_chat.dart';

class LayoutVehicleGoogleMap extends StatefulWidget {
    HomeController controllerHome;
  @override
  State<LayoutVehicleGoogleMap> createState() => _LayoutVehicleGoogleMapState();

    LayoutVehicleGoogleMap({
    required this.controllerHome,
  });
}

class _LayoutVehicleGoogleMapState extends State<LayoutVehicleGoogleMap> {
  HomeController controller = Get.put(HomeController());
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  String? setLocationOnMap;
  BitmapDescriptor? customIcon;
  GoogleMapController? mapController;
RxDouble latitude = 0.0.obs;
RxDouble longitude = 0.0.obs;
RxString address = ''.obs;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // initializeComponent();
    });
    setCustomIcon();
  }

  // Custom icon
  Future<void> setCustomIcon() async {
    final ByteData byteData = await rootBundle.load('assets/images/marker.png');
    final Uint8List markerIcon = byteData.buffer.asUint8List();
    final BitmapDescriptor bitmapDescriptor =
        BitmapDescriptor.fromBytes(markerIcon,size: Size(10, 10));
    setState(() {
      customIcon = bitmapDescriptor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 156.h,
          width: Get.width,
          color: primaryColor,
          padding: EdgeInsets.symmetric(
            horizontal: 15.w,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CARENO HOME",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Urbanist",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(ScreenHostNotification());
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.notifications_none_outlined,
                                  color: primaryColor,
                                  size: 30.sp,
                                ),
                              ),
                              Positioned(
                                top: 8.h,
                                right: 0,
                                left: 10.w,
                                child: Container(
                                  height: 8.h,
                                  width: 8.w,
                                  padding: EdgeInsets.all(1.sp),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    // Set the color to red
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).marginSymmetric(horizontal: 10.w),
                      ),
                      Container(
                        height: 40.h,
                        width: 40.w,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r)),
                        child: GestureDetector(
                          onTap: () {
                            controller.changeHomeLayout.value=0;
                          },
                          child: SvgPicture.asset(
                            "assets/images/export.svg",
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ).marginSymmetric(vertical: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45.h,
                    width: 294.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r)),
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(text: address.value),
                      decoration: InputDecoration(

                        hintText: "Search for City, airport, or a hotel...",
                        hintStyle: TextStyle(
                            color: Color(0xffABABAB),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Urbanist"),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xffABABAB),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        border: InputBorder.none,
                      ),
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

                      } ,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                      Get.to(ScreenFilter());
                    },
                    child: Container(
                      height: 42.h,
                      width: 42.w,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r)),
                      child: SvgPicture.asset(
                        "assets/images/Group.svg",
                      ),
                    ),
                  ),
                ],
              ).marginSymmetric(vertical: 16.h)
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<bool>(
              future: checkPermissionStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(
                    ),
                  );
                }
                if (snapshot.data == false) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Location Access Is Not Granted",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "UrbanistBold",
                            fontSize: 18.sp,
                          ),
                        ).marginSymmetric(vertical: 20.h),
                        CustomButton(
                          width: 200.w,
                          title: 'Retry',
                          onPressed: () {
                            setState(() {

                            });
                          },
                        )
                      ],
                    ),
                  );
                }
                return FutureBuilder<Position>(
                    future: Geolocator.getCurrentPosition(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                          ),
                        );
                      }
                      var position = snapshot.data!;
                      if (longitude.value==0.0) {
                       latitude.value = position.latitude;
                       longitude.value = position.longitude;
                      }
                  return GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(latitude.value, longitude.value),
                      zoom: 7.0,
                    ),
                    markers: createMarkers(),
                  );
                }
              );
            }
          ),
        ),
      ],
    );
  }

  Set<Marker> createMarkers() {
    Set<Marker> markers = {};

    if (customIcon == null) {
      // Handle case where customIcon is not yet initialized
      return markers; // Return empty set
    }

    for (int i = 0; i < controller.addhostvehicle.value.length; i++) {
      var event = controller.addhostvehicle.value[i];
      log(event.toString());
      double lat = event.latitude;
      double lng = event.longitude;
      LatLng position = LatLng(lat, lng);

      markers.add(
        Marker(
          infoWindow: InfoWindow(
            title: event.vehicleModel,
            snippet: "Active",
          ),
          markerId: MarkerId('marker$i'),
          position: position,
          icon: customIcon!,
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 220.h,
                  child: FutureBuilder(
                      future: getUser(event.hostId),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.appPrimaryColor,
                              ));
                        }
                        var user = snapshot.data!;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 100.h,
                                width: 83.w,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(5.r),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          event.vehicleImageComplete
                                        ),
                                        fit: BoxFit.fill)),
                              ).marginOnly(left: 12.w, top: 20.h),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.vehicleModel,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontFamily: "Urbanist",
                                          fontWeight: FontWeight.w700),
                                    ),
                                    FutureBuilder<Category?>(
                                        future: getCategory(event!.vehicleCategory),
                                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(
                                                child: CircularProgressIndicator(
                                                  color: AppColors.appPrimaryColor,
                                                ));
                                          }
                                          Category category = snapshot.data!;
                                          return Text(
                                          category.name,
                                          style: TextStyle(
                                              color: Color(0xffAAAAAA),
                                              fontSize: 11.sp,
                                              fontFamily: "Urbanist",
                                              fontWeight: FontWeight.w500),
                                        ).marginOnly(bottom: 2.h);
                                      }
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Color(0xffFBC017),
                                        ),
                                        Text(
                                          event.rating.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.sp,
                                              fontFamily: "Urbanist",
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "(${Get.find<HomeController>().getReviewCount(Get.find<HomeController>().ratedVehicleList.value, event.vehicleId).toString()})",
                                          style: TextStyle(
                                              color: Color(0xffAAAAAA),
                                              fontSize: 11.sp,
                                              fontFamily: "Urbanist",
                                              fontWeight: FontWeight.w500),
                                        ).marginOnly(left: 4.w),
                                      ],
                                    ).marginOnly(bottom: 8.h),
                                    Text(
                                      event.address,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 11.sp,
                                        fontFamily: "Urbanist",
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ).marginOnly(left: 8.w, top: 22.h),
                              ),
                              Container(
                                height: 36.h,
                                width: 40.w,
                                margin: EdgeInsets.only(right: 12.w),
                                decoration: BoxDecoration(
                                    color: Color(0xffAAAAAA).withOpacity(.2),
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Color(0xff949494),
                                ),
                              ).marginOnly(bottom: 40.h),
                            ],
                          ),
                          Center(
                            child: Row(
                              children: [
                                CustomButton(
                                  width: 180.w,
                                  title: 'View Details',
                                  onPressed: () {
                                    Get.back();
                                    Get.to(ScreenCarDetails(addHostVehicle: event,));

                                  },
                                ).marginOnly(left: 10.w),
                                CustomButton(
                                  width: 160.w,
                                  title: 'Message',
                                  onPressed: () {
                                    Get.back();
                                    Get.to(ScreenUserChat(user: user,));

                                  },
                                ).marginOnly(left: 10.w),
                              ],
                            ).marginOnly(top: 20.h),
                          )
                        ],
                      );
                    }
                  ),
                );
              },
            );
          },
        ),
      );
    }

    return markers;
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

      if (!mounted) return; // Check if the widget is still mounted

      setState(() {
       latitude.value = detail.result.geometry!.location.lat;
        longitude.value = detail.result.geometry!.location.lng;
        var _address = detail.result.formattedAddress;
        address.value = _address!;
      });

      await add(latitude.value, longitude.value, address.value);
      mapNavigateOnPoints(latitude.value, longitude.value);
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
