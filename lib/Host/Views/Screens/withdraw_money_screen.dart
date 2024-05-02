import 'package:careno/constant/helpers.dart';
import 'package:careno/models/user.dart';
import 'package:careno/models/withdraw_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../constant/colors.dart';
import '../../../constant/my_helper_by_callofcoding.dart';

// this screen is developed by @callofcoding


class WithdrawMoneyScreen extends StatefulWidget {
  final User userObject;
   WithdrawMoneyScreen({super.key,required this.userObject});


  @override
  State<WithdrawMoneyScreen> createState() => _WithdrawMoneyScreenState();
}

class _WithdrawMoneyScreenState extends State<WithdrawMoneyScreen> {
  bool isNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final numericRegex = RegExp(r'^\d+$');
    return numericRegex.hasMatch(value);
  }


  ValueNotifier<double> amount = ValueNotifier<double>(0.0);

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  bool isSubmitted = false;
  bool isError = false;
  final _formKey = GlobalKey<FormState>();
  String? selectedOperator;

  String withdrawStatus = 'idle';

  WithdrawRequestModel withdrawRequest = WithdrawRequestModel();

  //
  // init(){
  //   if (widget.riderObject.riderWithdraw?.isRequest == true) {
  //     isSubmitted = true;
  //   }
  //   if (widget.riderObject.riderWithdraw?.isError == true) {
  //     isError = true;
  //   }
  //   setState(() {
  //
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    // init();

    getWithdrawStream().listen((event) {
      setState(() {
        withdrawStatus = event.data()?['requestStatus'] ?? 'idle';

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appPrimaryColor,
        foregroundColor: Colors.white,
        title: Text('Withdraw Money Request',style: TextStyle(color: Colors.white),),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: withdrawStatus == 'reject'
            ? Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              height: 300,
              width: size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/rejected.png'),
                      scale: 2)),
            ),
            Text(
              'Your request has been rejected!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                        // TODO: GET ERROR MESSAGE FROM DB
                        'error message',
                        style: TextStyle(fontSize: 16),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: Size(125, 40)),
                onPressed: () async {

                  //TODO: CREATE A LOGIC TO RESET THE WITHDRAW STATUS

                  await dbInstance.collection('withdrawRequests').doc(uid).update(
                      {"requestStatus" : 'idle'});

                  // WithdrawObject withdrawObject =
                  //     WithdrawObject(riderId: riderObject!.id);
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                  // await firestore
                  //     .collection('IndRiders')
                  //     .doc(userId)
                  //     .update({'riderWithdraw': withdrawObject.toMap()});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Got It!',
                      style: TextStyle(fontSize: 17),
                    ),
                    Icon(Icons.check_circle_outline),
                  ],
                )),
          ],
        )
            : withdrawStatus == 'pending'
            ? Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                height: 130,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/time-left.png'))),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      'Congrats! your request has been submitted. Please wait 1-2 hours while we process your payments',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(125, 40)),
                  onPressed: () {
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back_outlined),
                      Text(
                        'Go back',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  )),
            ],
          ),
        )
            : ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, value, child) {
            return value
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator())
              ],
            )
                : Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Amount',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 70,
                            width: 240,
                            child: TextFormField(
                              onChanged: (value) {
                                amount.value = double.parse(value);
                              },
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Amount Required';
                                }
                                if (!isNumeric(value)) {
                                  return 'Please enter values between 0-9';
                                }
                                if (int.parse(value) <= 0 ||
                                    int.parse(value) >
                                        widget.userObject
                                            .hostWallet!
                                            .currentBalance!) {
                                  return 'Enter amount between 1-${widget.userObject
                                      .hostWallet!.currentBalance?.round()}';
                                }
                                return null;
                              },
                              onTapOutside: (event) {
                                FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus();
                              },
                              onSaved: (newValue) {
                                withdrawRequest.amount =
                                    double.tryParse(newValue!);
                              },
                              keyboardType: TextInputType
                                  .numberWithOptions(
                                  decimal: false,
                                  signed: false),
                              decoration: InputDecoration(
                                  constraints: BoxConstraints(
                                      minHeight: 50),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      vertical: 13,
                                      horizontal: 18),
                                  prefixText: 'Rs. ',
                                  hintText:
                                  'From 1 To ${widget.userObject
                                      .hostWallet!.currentBalance?.round()}',
                                  border: inputBorder(
                                      enableBorder: true),
                                  focusedBorder:inputBorder(
                                      enableBorder: true),
                                  enabledBorder:inputBorder(
                                      enableBorder: true),
                                  errorBorder:
                                  inputBorder(
                                    enableBorder: true,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          Text('Select Method',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: selectedOperator == 'Bank Transfer' ? 0:5,
                              child: InkWell(
                                borderRadius:
                                BorderRadius.circular(8),
                                onTap: () {
                                  if (selectedOperator ==
                                      'M-pesa' ||
                                      selectedOperator ==
                                          null) {
                                    setState(() {
                                      selectedOperator =
                                      'Bank Transfer';
                                    });
                                  }
                                },
                                child: Container(
                                  height: 90,
                                  width: Get.width * 0.7,
                                  decoration: BoxDecoration(
                                      color: selectedOperator =="Bank Transfer" ?AppColors.appPrimaryColor :Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(
                                          8),
                                      border: Border.all(
                                        width: 0.9,
                                        color: AppColors.appPrimaryColor.withOpacity(0.6),
                                      ),
                                      // image: DecorationImage(
                                      //     image: AssetImage(
                                      //         'assets/images/bank_transfer.png'),
                                      //     scale: 10),
                                      // boxShadow:
                                      // selectedOperator ==
                                      //     'Bank Transfer'
                                      //     ? [
                                      //   BoxShadow(
                                      //     color: AppColors.appPrimaryColor,
                                      //     blurRadius:
                                      //     12.0,
                                      //     // Adjust the blur radius
                                      //     spreadRadius:
                                      //     1.0,
                                      //   )
                                      // ]
                                      //     : []
                                  ),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.account_balance,size: 50,color: selectedOperator =="Bank Transfer" ?Colors.white :Colors.black,),
                                      SizedBox(width: 10,),
                                      Text('Bank Transfer',style: TextStyle(fontSize: 27,color: selectedOperator =="Bank Transfer" ?Colors.white :Colors.black,fontWeight: FontWeight.w900),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 40,),
                            Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: selectedOperator == 'M-pesa' ? 0:5,
                              child: InkWell(
                                borderRadius:
                                BorderRadius.circular(8),
                                onTap: () {
                                  if (selectedOperator ==
                                      'Bank Transfer' ||
                                      selectedOperator ==
                                          null) {
                                    setState(() {
                                      selectedOperator =
                                      'M-pesa';
                                    });
                                  }
                                },
                                child: Container(
                                  height: 90,
                                  width: Get.width * 0.7,
                                  decoration: BoxDecoration(
                                      color: selectedOperator == 'M-pesa' ?AppColors.appPrimaryColor:Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(
                                          8),
                                      border: Border.all(
                                        width: 0.9,
                                        color: AppColors.appPrimaryColor.withOpacity(0.6),
                                      ),
                                      // image: DecorationImage(
                                      //     image: AssetImage(
                                      //         'assets/images/Mpesa.png'),
                                      //     scale: 10),
                                      // boxShadow:
                                      // selectedOperator ==
                                      //     'M-pesa'
                                      //     ? [
                                      //   BoxShadow(
                                      //     color: AppColors.appPrimaryColor,
                                      //     blurRadius:
                                      //     12.0,
                                      //     // Adjust the blur radius
                                      //     spreadRadius:
                                      //     1.0,
                                      //   )
                                      // ]
                                      //     : []

                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/Mpesa.png',width: 50,),
                                      SizedBox(width: 10,),
                                      Text('Mpesa Transfer',style: TextStyle(fontSize: 25,color: selectedOperator =="M-pesa" ?Colors.white :Colors.black,fontWeight: FontWeight.w900),)

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      selectedOperator != null
                          ? Column(
                        children: [

                          selectedOperator == 'M-pesa'? Column(children: [
                            SizedBox(
                              height: 30,
                            ),

                            customTextFieldWithHeading(heading: 'Account Number', errorMsg: 'Account Number Required', iconData: Icons.account_balance_sharp,addValidationForNumber: true,keyboardType:  TextInputType.numberWithOptions(decimal: false, signed: false),hintText: '254XXXXXXXX',
                                onSaved: (newValue) {
                              withdrawRequest.accountNumber =
                                  newValue ?? '';
                            }),
                            SizedBox(
                              height: 20,
                            ),
                          ],):Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              customTextFieldWithHeading(
                                  heading: 'Bank Name',
                                  errorMsg: 'Bank Name Required',
                                  iconData: Icons.account_balance_sharp,
                                  keyboardType:  TextInputType.text,
                                  hintText: 'e.g Chase Bank',
                                  onSaved: (newValue) {

                                  }),
                              SizedBox(
                                height: 20,
                              ),
                              customTextFieldWithHeading(
                                  heading: 'Account Holder Name',
                                  errorMsg: 'Account Holder Name Required',
                                  iconData: Icons.account_balance_sharp,
                                  keyboardType:  TextInputType.text,
                                  hintText: 'e.g James',
                                  onSaved: (newValue) {

                                  }),
                              SizedBox(
                                height: 20,
                              ),
                              customTextFieldWithHeading(
                                  heading: 'Account Number',
                                  errorMsg: 'Account Number Required',
                                  iconData: Icons.account_balance_sharp,
                                  addValidationForNumber: true,
                                  keyboardType:  TextInputType.numberWithOptions(decimal: false, signed: false),
                                  hintText: 'XXXXXXXXXXXXX',
                                  onSaved: (newValue) {
                                    withdrawRequest.accountNumber =
                                        newValue ?? '';
                                  }),

                              SizedBox(
                                height: 20,
                              ),
                              customTextFieldWithHeading(
                                  heading: 'Bank Address',
                                  errorMsg: 'Bank Address Required',
                                  iconData: Icons.account_balance_sharp,
                                  keyboardType: TextInputType.streetAddress,
                                  hintText:
                                  """270 Park Avenue
New York, NY 10017
United States""",
                                  maxLine: 3,
                                  onSaved: (newValue) {

                                  }),
                              SizedBox(height: 20,)
                            ],
                          ),

                          ValueListenableBuilder(valueListenable: amount, builder: (context, value, child) {
                            return Column(
                              children: [
                                Text('Summary',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                                SizedBox(height: 14,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total amount',style: TextStyle(fontSize: 16),),
                                    Text('$value',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600))
                                  ],
                                ),
                                SizedBox(height: 4,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Tax + Service charges',style: TextStyle(fontSize: 16)),
                                    Text("${(value * adminPercentage!) / 100}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600))
                                  ],
                                ),
                                SizedBox(height: 4,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Received Amount',style: TextStyle(fontSize: 16)),
                                    Text('${calculateAmountForHost(value)}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ],
                            );

                          },),

                          SizedBox(
                            height: 50,
                          ),
                          ElevatedButton(
                              style: ElevatedButton
                                  .styleFrom(
                                  fixedSize:
                                  Size(200, 50)),
                              onPressed: () async {
                                if (_formKey.currentState!
                                    .validate()) {
                                  if (selectedOperator !=
                                      null) {
                                    _formKey.currentState!
                                        .save();
                                    withdrawRequest.paymentMethod= selectedOperator!;
                                    withdrawRequest.hostId =widget.userObject.uid;
                                    withdrawRequest.dateTime =DateTime.now().toString();
                                    withdrawRequest.requestStatus = 'pending';
                                    withdrawRequest.email = widget.userObject.email;
                                    withdrawRequest.hostName = widget.userObject.name;
                                    withdrawRequest.profilePic = widget.userObject.imageUrl;
                                    withdrawRequest.hostPhoneNumber = widget.userObject.phoneNumber;
                                    isLoading.value = true;

                                    await makeWithdrawRequest(userObject: widget.userObject, withdrawRequest: withdrawRequest).then((value) {
                                      isLoading.value = false;
                                    });

                                    // print(withdrawObject
                                    //     .accountHolderName);
                                    // await firestore
                                    //     .collection(
                                    //         'IndRiders')
                                    //     .doc(userId)
                                    //     .update({
                                    //   'riderWithdraw':
                                    //       withdrawObject
                                    //           .toMap()
                                    // }).then((value) {

                                    // });
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight
                                            .bold),
                                  ),
                                  Icon(
                                    Icons
                                        .check_circle_outline,
                                    size: 28,
                                  )
                                ],
                              ))
                        ],
                      )
                          : SizedBox()
                    ],
                  ),
                ),
              ),
            );
          },
        ),),

    );
  }
}
