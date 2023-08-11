import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sterling/services/services.dart';
import 'package:sterling/view_models/dashboard_view.dart';
import 'package:sterling/views/global_utils/user_input_widget.dart';

class QuickRequestDialog extends StatefulWidget {
  QuickRequestDialog(
      //this.userId, this.getDashboardData,
      this.rideType,
      {super.key});
  // var getDashboardData;
  // final int? userId;
  String rideType;

  @override
  State<QuickRequestDialog> createState() => _QuickRequestDialogState();
}

class _QuickRequestDialogState extends State<QuickRequestDialog> {
  TextEditingController pickDateController = TextEditingController();
  TextEditingController timePickController = TextEditingController();
  TextEditingController pickUpController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? selectedVehicleType;
  int? selectedRideCategory;
  LayerLink _layerLinkPickup = LayerLink();
  LayerLink _layerLinkDestination = LayerLink();
  bool isInit = true;
  List<String> vehicleType = [];
  List<DropdownMenuItem> vehicleTypeItem = [];
  List<String> rideCategory = [];
  List<DropdownMenuItem> rideCategoryItem = [];
  double spacePickup = 0.0;
  double spaceDestination = 0.0;
  bool rideError = false;
  bool vehicleError = false;

  Services services = Services();
  @override
  void didChangeDependencies() {
    if (isInit) {
      getSettings();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  int i = 0;

  getSettings() async {
    await services.settingsAPI();
    vehicleType = await services.getSettings('vehicleType');
    rideCategory = await services.getSettings('rideCategory');

    vehicleType.map((e) {
      vehicleTypeItem.add(
        DropdownMenuItem(
          value: i,
          child: Text(e),
        ),
      );
      i++;
    }).toList();
    i = 0;

    rideCategory.map((e) {
      rideCategoryItem.add(
        DropdownMenuItem(
          value: i + 100,
          child: Text(e),
        ),
      );
      print('$e $i');
      i++;
    }).toList();

    setState(() {});
  }

  requestTrip() async {
    var responseData =
        await Provider.of<DashboardView>(context, listen: false).newRequest(
      pickDateController.text,
      timePickController.text,
      pickUpController.text,
      destinationController.text,
      selectedVehicleType,
      widget.rideType,
      selectedRideCategory,
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        content: Center(
          child: Text(
            textAlign: TextAlign.center,
            responseData['message'].toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: AlertDialog(
          backgroundColor: const Color(0xffffffff),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
          titlePadding: EdgeInsets.zero,
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  top: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Quick Request',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    CloseButton(),
                  ],
                ),
              ),
              const Divider(
                color: Color(0xfff4f4f4),
                thickness: 3,
              ),
            ],
          ),
          scrollable: true,
          content: Container(
            height: MediaQuery.of(context).size.height * .9,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 15,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * .9 - 220,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Pick up date*',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                            // height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .9,
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Which date do you want to be picked up?';
                                                } else if (value.isEmpty) {
                                                  return 'Which date do you want to be picked up?';
                                                }
                                              },
                                              controller: pickDateController,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              readOnly: true,
                                              onTap: () async {
                                                var date = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2024),
                                                );
                                                if (date != null) {
                                                  pickDateController.text = date
                                                          .day
                                                          .toString()
                                                          .padLeft(2, '0') +
                                                      '/' +
                                                      date.month
                                                          .toString()
                                                          .padLeft(2, '0') +
                                                      '/' +
                                                      date.year
                                                          .toString()
                                                          .padLeft(4, '0');
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 1,
                                                  ),
                                                  hintText: '00/00/00',
                                                  hintStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  prefixIcon: InkWell(
                                                    onTap: () async {
                                                      var date =
                                                          await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate:
                                                            DateTime(2024),
                                                      );
                                                      if (date != null) {
                                                        pickDateController
                                                            .text = date.day
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0') +
                                                            '/' +
                                                            date.month
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0') +
                                                            '/' +
                                                            date.year
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0');
                                                      }
                                                    },
                                                    child: const Icon(
                                                        Icons
                                                            .calendar_month_rounded,
                                                        color: Colors.black),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor))),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Pick up time*',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                            //height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .9,
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'What time do you want the pick up to be?';
                                                } else if (value.isEmpty) {
                                                  return 'What time do you want the pick up to be?';
                                                }
                                              },
                                              readOnly: true,
                                              onTap: () async {
                                                TimeOfDay? time =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                  initialEntryMode:
                                                      TimePickerEntryMode.dial,
                                                );

                                                if (time != null) {
                                                  if (time.hour != null) {
                                                    if (time.minute != null) {
                                                      timePickController
                                                          .text = time.hour
                                                                  .toString()
                                                                  .padLeft(
                                                                      2, '0') ==
                                                              '0'
                                                          ? '00'
                                                          : time.hour
                                                                  .toString()
                                                                  .padLeft(
                                                                      2, '0') +
                                                              ':' +
                                                              time.minute
                                                                  .toString()
                                                                  .padLeft(
                                                                      2, '0');
                                                    } else {
                                                      timePickController
                                                          .text = time.hour
                                                                  .toString()
                                                                  .padLeft(
                                                                      2, '0') ==
                                                              '0'
                                                          ? '00'
                                                          : time!.hour
                                                                  .toString()
                                                                  .padLeft(
                                                                      2, '0') +
                                                              ':' +
                                                              TimeOfDay.now()
                                                                  .minute
                                                                  .toString()
                                                                  .padLeft(
                                                                      2, '0');
                                                    }
                                                  } else {
                                                    timePickController.text =
                                                        TimeOfDay.now()
                                                            .toString();
                                                  }
                                                } else {
                                                  timePickController.text =
                                                      TimeOfDay.now()
                                                          .toString();
                                                }
                                              },
                                              controller: timePickController,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 1,
                                                ),
                                                hintText: '00:00',
                                                hintStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                prefixIcon: InkWell(
                                                  onTap: () async {
                                                    TimeOfDay? time =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                      initialEntryMode:
                                                          TimePickerEntryMode
                                                              .dial,
                                                    );

                                                    if (time != null) {
                                                      if (time.hour != null) {
                                                        if (time.minute !=
                                                            null) {
                                                          timePickController
                                                              .text = time!.hour
                                                                      .toString()
                                                                      .padLeft(
                                                                          2,
                                                                          '0') ==
                                                                  '0'
                                                              ? '00'
                                                              : time!.hour
                                                                      .toString()
                                                                      .padLeft(
                                                                          2,
                                                                          '0') +
                                                                  ':' +
                                                                  time!.minute
                                                                      .toString()
                                                                      .padLeft(
                                                                          2,
                                                                          '0');
                                                        } else {
                                                          timePickController
                                                              .text = time!.hour
                                                                      .toString()
                                                                      .padLeft(
                                                                          2,
                                                                          '0') ==
                                                                  '0'
                                                              ? '00'
                                                              : time!.hour
                                                                      .toString()
                                                                      .padLeft(
                                                                          2,
                                                                          '0') +
                                                                  ':' +
                                                                  TimeOfDay
                                                                          .now()
                                                                      .minute
                                                                      .toString()
                                                                      .padLeft(
                                                                          2,
                                                                          '0');
                                                        }
                                                      } else {
                                                        timePickController
                                                                .text =
                                                            TimeOfDay.now()
                                                                .toString();
                                                      }
                                                    } else {
                                                      timePickController.text =
                                                          TimeOfDay.now()
                                                              .toString();
                                                    }
                                                  },
                                                  child: const Icon(
                                                      Icons
                                                          .watch_later_outlined,
                                                      color: Colors.black),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //targets
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CompositedTransformTarget(
                                        link: _layerLinkPickup,
                                        child: const Text(
                                          'Pick up location*',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 60 + spacePickup,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CompositedTransformTarget(
                                        link: _layerLinkDestination,
                                        child: const Text(
                                          'Destinations*',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 60 + spaceDestination,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Ride Category*',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                          // height: 40,
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .9),
                                          child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color:
                                                        selectedRideCategory ==
                                                                102
                                                            ? Colors.grey
                                                            : vehicleError ==
                                                                    false
                                                                ? Colors.black
                                                                : Colors.red,
                                                    width: .6),
                                              ),
                                            ),
                                            isExpanded: true,
                                            validator: (value) {
                                              if (selectedRideCategory ==
                                                  null) {
                                                rideError = true;
                                                setState(() {});
                                                return 'Choose a ride category';
                                              }
                                            },
                                            items: [...rideCategoryItem],
                                            hint: const Text(
                                              'Ride Category',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: rideError == false
                                                  ? Colors.black
                                                  : Colors.red,
                                            ),
                                            value: selectedRideCategory,
                                            onChanged: (value) {
                                              selectedRideCategory = value;
                                              if (selectedRideCategory == 102) {
                                                selectedVehicleType = 0;
                                              }

                                              setState(() {});
                                            },
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'No of days required',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      SizedBox(
                                        // height: 40,
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                .9),
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value != null &&
                                                value.contains('-')) {
                                              return 'Invalid number of days';
                                            }
                                          },
                                          controller: daysController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 1,
                                              ),
                                              hintText: '1 day',
                                              hintStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Vehicle Type*',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                          // height: 40,
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .9),
                                          // decoration: BoxDecoration(
                                          //   borderRadius:
                                          //       BorderRadius.circular(10),
                                          //   border: Border.all(
                                          //       color:
                                          //           selectedRideCategory == 102
                                          //               ? Colors.grey
                                          //               : vehicleError == false
                                          //                   ? Colors.black
                                          //                   : Colors.red,
                                          //       width: .6),
                                          // ),
                                          // padding: const EdgeInsets.symmetric(
                                          //     horizontal: 10),
                                          child: IgnorePointer(
                                            ignoring:
                                                selectedRideCategory == 102
                                                    ? true
                                                    : false,
                                            child: DropdownButtonFormField(
                                              validator: (value) {
                                                if (selectedVehicleType ==
                                                    null) {
                                                  vehicleError = true;
                                                  setState(() {});
                                                  return 'Choose a vehicle type';
                                                }
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color:
                                                          selectedRideCategory ==
                                                                  102
                                                              ? Colors.grey
                                                              : vehicleError ==
                                                                      false
                                                                  ? Colors.black
                                                                  : Colors.red,
                                                      width: .6),
                                                ),
                                              ),
                                              isExpanded: true,
                                              items: [...vehicleTypeItem],
                                              value: selectedRideCategory == 102
                                                  ? 0
                                                  : selectedVehicleType,
                                              hint: Text(
                                                'Vehicle Type',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: selectedRideCategory ==
                                                          102
                                                      ? Colors.grey
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color:
                                                    selectedRideCategory == 102
                                                        ? Colors.grey
                                                        : rideError == false
                                                            ? Colors.black
                                                            : Colors.red,
                                              ),
                                              onChanged: (value) {
                                                selectedVehicleType =
                                                    value as int;
                                                print(selectedVehicleType);
                                                setState(() {});
                                              },
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        color: const Color(0xfff4f4f4),
                        height: 70,
                        width: MediaQuery.of(context).size.width * .9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            InkWell(
                              onTap: () async {
                                if (_formKey.currentState != null) {
                                  if (_formKey.currentState!.validate()) {
                                    await requestTrip();
                                    // await widget.getDashboardData();
                                    Navigator.pop(context);
                                  } else {}
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: const Text(
                                  'Send Request',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //followers
                  CompositedTransformFollower(
                    link: _layerLinkDestination,
                    showWhenUnlinked: false,
                    offset: Offset(0.0, 29.0),
                    child: UserInputWidget(
                        validator: (value) {
                          if (value == null) {
                            spaceDestination = 20;
                            Future.delayed(
                              Duration(milliseconds: 100),
                            ).then((value) => setState(() {}));
                            return 'Where do you want to be dropped?';
                          } else if (value.isEmpty) {
                            spaceDestination = 20;
                            Future.delayed(
                              Duration(milliseconds: 100),
                            ).then((value) => setState(() {}));
                            return 'Where do you want to be dropped?';
                          }
                        },
                        inputController: destinationController,
                        hintText: 'Choose destination'),
                  ),
                  CompositedTransformFollower(
                    link: _layerLinkPickup,
                    showWhenUnlinked: false,
                    offset: Offset(0.0, 29.0),
                    child: UserInputWidget(
                        validator: (value) {
                          if (value == null) {
                            spacePickup = 20;
                            Future.delayed(
                              Duration(milliseconds: 100),
                            ).then((value) => setState(() {}));

                            return 'Where do you want to be picked up?';
                          } else if (value.isEmpty) {
                            spacePickup = 20;
                            Future.delayed(
                              Duration(milliseconds: 100),
                            ).then((value) => setState(() {}));
                            return 'Where do you want to be picked up?';
                          }
                        },
                        inputController: pickUpController,
                        hintText: 'Choose location'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
