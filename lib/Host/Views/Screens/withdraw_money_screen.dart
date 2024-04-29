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
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Card(
                                  elevation: 2,
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          12)),
                                  color: Colors.white,
                                  child: InkWell(
                                    borderRadius:
                                    BorderRadius.circular(12),
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
                                      height: 75,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              12),
                                          border: Border.all(
                                            width: 3,
                                            color: AppColors.appPrimaryColor.withOpacity(0.6),
                                          ),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/bank_transfer.png'),
                                              scale: 10),
                                          boxShadow:
                                          selectedOperator ==
                                              'Bank Transfer'
                                              ? [
                                            BoxShadow(
                                              color: AppColors.appPrimaryColor,
                                              blurRadius:
                                              12.0,
                                              // Adjust the blur radius
                                              spreadRadius:
                                              1.0,
                                            )
                                          ]
                                              : []),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Text('Bank Transfer',style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                            Column(
                              children: [
                                Card(
                                  elevation: 2,
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          12)),
                                  color: Colors.white,
                                  child: InkWell(
                                    borderRadius:
                                    BorderRadius.circular(12),
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
                                      height: 75,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              12),
                                          border: Border.all(
                                            width: 3,
                                            color: AppColors.appPrimaryColor.withOpacity(0.6),
                                          ),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/Mpesa.png'),
                                              scale: 10),
                                          boxShadow:
                                          selectedOperator ==
                                              'M-pesa'
                                              ? [
                                            BoxShadow(
                                              color: AppColors.appPrimaryColor,
                                              blurRadius:
                                              12.0,
                                              // Adjust the blur radius
                                              spreadRadius:
                                              1.0,
                                            )
                                          ]
                                              : []),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Text('M-pesa',style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ],
                        ),
                      ),
                      selectedOperator != null
                          ? Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Text(' Account Number',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight
                                          .bold))
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
                                  autovalidateMode:
                                  AutovalidateMode
                                      .onUserInteraction,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Account Number Required';
                                    }
                                    if (!isNumeric(
                                        value)) {
                                      return 'Please enter values between 0-9';
                                    }
                                    if (value.length <
                                        11) {
                                      return 'Incorrect Account Number';
                                    }
                                    return null;
                                  },
                                  onTapOutside: (event) {
                                    FocusManager.instance
                                        .primaryFocus
                                        ?.unfocus();
                                  },
                                  onSaved: (newValue) {
                                    withdrawRequest.accountNumber =
                                        newValue ?? '';
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        11)
                                  ],
                                  keyboardType: TextInputType
                                      .numberWithOptions(
                                      decimal: false,
                                      signed: false),
                                  decoration:
                                  InputDecoration(
                                      prefixIcon:
                                      Icon(
                                        Icons
                                            .account_balance_sharp,
                                        color: AppColors.appPrimaryColor,
                                      ),
                                      constraints:
                                      BoxConstraints(
                                          minHeight:
                                          50),
                                      contentPadding:
                                      EdgeInsets.symmetric(
                                          vertical:
                                          13,
                                          horizontal:
                                          18),
                                      hintText:
                                      '03XXXXXXXXX',
                                      border: inputBorder(
                                          enableBorder:
                                          true),
                                      focusedBorder: inputBorder(
                                          enableBorder:
                                          true),
                                      enabledBorder: inputBorder(
                                          enableBorder:
                                          true),
                                      errorBorder: inputBorder(
                                        enableBorder:
                                        true,
                                        color: Colors
                                            .red,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // Row(
                          //   mainAxisAlignment:
                          //       MainAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //         '${selectedOperator ?? ''} Account Holder',
                          //         style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight:
                          //                 FontWeight
                          //                     .bold))
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 4,
                          // ),
                          // Row(
                          //   mainAxisAlignment:
                          //       MainAxisAlignment.start,
                          //   children: [
                          //     SizedBox(
                          //       height: 100,
                          //       width: 240,
                          //       child: TextFormField(
                          //         autovalidateMode:
                          //             AutovalidateMode
                          //                 .onUserInteraction,
                          //         validator: (value) {
                          //           if (value == null ||
                          //               value.isEmpty) {
                          //             return 'Name Required';
                          //           }
                          //           return null;
                          //         },
                          //         onTapOutside: (event) {
                          //           FocusManager.instance
                          //               .primaryFocus
                          //               ?.unfocus();
                          //         },
                          //         onSaved:
                          //             (String? newValue) {
                          //           // setState(() {
                          //           //   withdrawObject
                          //           //           .accountHolderName =
                          //           //       newValue ?? '';
                          //           //   print(
                          //           //       'value is : $newValue\nobject value ${withdrawObject.accountHolderName}');
                          //           // });
                          //         },
                          //         keyboardType:
                          //             TextInputType.text,
                          //         decoration:
                          //             InputDecoration(
                          //                 prefixIcon:
                          //                     Icon(
                          //                   Icons
                          //                       .person_outline,
                          //                   color: AppColors.appPrimaryColor,
                          //                 ),
                          //                 constraints:
                          //                     BoxConstraints(
                          //                         minHeight:
                          //                             50),
                          //                 contentPadding:
                          //                     EdgeInsets.symmetric(
                          //                         vertical:
                          //                             13,
                          //                         horizontal:
                          //                             18),
                          //                 hintText:
                          //                     'Name',
                          //                 helperMaxLines:
                          //                     2,
                          //                 helperStyle:
                          //                     TextStyle(
                          //                         fontSize:
                          //                             15),
                          //                 helperText:
                          //                     'This name is same as it appears on ${selectedOperator ?? ''} app.',
                          //                 border: inputBorder(
                          //                         enableBorder:
                          //                             true),
                          //                 focusedBorder: inputBorder(
                          //                         enableBorder:
                          //                             true),
                          //                 enabledBorder: inputBorder(
                          //                         enableBorder:
                          //                             true),
                          //                 errorBorder: inputBorder(
                          //                   enableBorder:
                          //                       true,
                          //                   color: Colors
                          //                       .red,
                          //                 )),
                          //       ),
                          //     ),
                          //   ],
                          // ),

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
