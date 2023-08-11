import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/services.dart';
import '../../../view_models/dashboard_view.dart';
import '../search_screen/search_screen.dart';
import 'utils/close_button.dart';

class QuickRequestModal extends StatefulWidget {
  QuickRequestModal({
    required this.rideType,
    super.key,
  });
  String rideType;
  @override
  State<QuickRequestModal> createState() => _QuickRequestModalState();
}

class _QuickRequestModalState extends State<QuickRequestModal> {
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
      daysController.text = '1';
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

  validator(value) {
    if (value == null || value.isEmpty) {
      return 'This field is mandatory';
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    pickDateController.dispose();
    pickUpController.dispose();
    daysController.dispose();
    destinationController.dispose();
    timePickController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var decoration = InputDecoration(
      hintText: '00/00/0000',
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
      ),
      prefixIcon:
          Icon(Icons.calendar_month_rounded, color: Colors.grey.shade600),
      contentPadding: const EdgeInsets.all(16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: height,
          color: Colors.transparent,
          child: Center(
            child: Container(
              height: height * .89,
              width: width * .95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white.withOpacity(.7),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 66,
                        ),
                        //form widget
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //date time row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              text: 'Pick up date',
                                              children: [
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(height: 8),
                                          //PickUpDateController
                                          SizedBox(
                                            width: (width * .95 - 32) / 2 - 5,
                                            child: TextFormField(
                                              validator: (value) {
                                                return validator(value);
                                              },
                                              controller: pickDateController,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade600,
                                              ),
                                              readOnly: true,
                                              onTap: () async {
                                                var date = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2024),
                                                  builder: (context, child) {
                                                    return Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme:
                                                            ColorScheme.light(
                                                          primary:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          onPrimary:
                                                              Colors.white,
                                                          onSurface:
                                                              Colors.black,
                                                        ),
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor: Theme
                                                                    .of(context)
                                                                .primaryColor, // button text color
                                                          ),
                                                        ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                );
                                                if (date != null) {
                                                  pickDateController.text =
                                                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().padLeft(2, '0')}';
                                                }
                                              },
                                              decoration: InputDecoration(
                                                hintText: '00/00/0000',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey.shade400,
                                                ),
                                                prefixIcon: Icon(
                                                    Icons
                                                        .calendar_month_rounded,
                                                    color:
                                                        Colors.grey.shade600),
                                                contentPadding:
                                                    const EdgeInsets.all(16.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      //pickup time section
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // pickuptime header
                                          Text.rich(
                                            TextSpan(
                                              text: 'Pick up time',
                                              children: [
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(height: 8),
                                          //pickuptime textformfield
                                          SizedBox(
                                            width: (width * .95 - 32) / 2 - 5,
                                            child: TextFormField(
                                              validator: (value) {
                                                return validator(value);
                                              },
                                              controller: timePickController,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade600,
                                              ),
                                              readOnly: true,
                                              onTap: () async {
                                                TimeOfDay? time =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                  builder: ((context, child) {
                                                    return MediaQuery(
                                                      data:
                                                          MediaQuery.of(context)
                                                              .copyWith(
                                                        alwaysUse24HourFormat:
                                                            false,
                                                      ),
                                                      child: Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          colorScheme:
                                                              ColorScheme.light(
                                                            primary: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            onPrimary:
                                                                Colors.white,
                                                            onSurface:
                                                                Colors.black,
                                                          ),
                                                          textButtonTheme:
                                                              TextButtonThemeData(
                                                            style: TextButton
                                                                .styleFrom(
                                                              foregroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .primaryColor, // button text color
                                                            ),
                                                          ),
                                                        ),
                                                        child: child!,
                                                      ),
                                                    );
                                                  }),
                                                  initialEntryMode:
                                                      TimePickerEntryMode.dial,
                                                );
                                                if (time != null) {
                                                  timePickController.text =
                                                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}';
                                                }
                                              },
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                    Icons.watch_later_outlined,
                                                    color:
                                                        Colors.grey.shade600),
                                                hintText: '00:00',
                                                hintStyle: TextStyle(
                                                  color: Colors.grey.shade400,
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(16.0),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .dividerColor,
                                                      width: 1),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Pick up location',
                                      children: [
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    validator: (value) {
                                      return validator(value);
                                    },
                                    readOnly: false,
                                    controller: pickUpController,
                                    decoration: decoration.copyWith(
                                      prefixIcon: const SizedBox(
                                        width: 0,
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 16.0,
                                        minHeight: 0,
                                      ),
                                      suffixIcon: Icon(
                                        Icons.location_pin,
                                        color: Colors.grey.shade600,
                                      ),
                                      hintText: 'Choose location',
                                    ),
                                    onChanged: (value) {
                                      showGeneralDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        transitionDuration:
                                            Duration(milliseconds: 500),
                                        barrierLabel:
                                            MaterialLocalizations.of(context)
                                                .dialogLabel,
                                        barrierColor:
                                            Colors.black.withOpacity(0.5),
                                        pageBuilder: (context, _, __) {
                                          return SearchScreen(
                                              inputController:
                                                  pickUpController);
                                        },
                                        transitionBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return SlideTransition(
                                            position: CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeOut,
                                            ).drive(Tween<Offset>(
                                              begin: Offset(0, -1.0),
                                              end: Offset.zero,
                                            )),
                                            child: child,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Destination',
                                      children: [
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    readOnly: false,
                                    validator: (value) {
                                      return validator(value);
                                    },
                                    controller: destinationController,
                                    decoration: decoration.copyWith(
                                      prefixIcon: const SizedBox(
                                        width: 0,
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 16.0,
                                        minHeight: 0,
                                      ),
                                      suffixIcon: Icon(
                                        Icons.location_pin,
                                        color: Colors.grey.shade600,
                                      ),
                                      hintText: 'Choose location',
                                    ),
                                    onChanged: (value) {
                                      showGeneralDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        transitionDuration:
                                            Duration(milliseconds: 500),
                                        barrierLabel:
                                            MaterialLocalizations.of(context)
                                                .dialogLabel,
                                        barrierColor:
                                            Colors.black.withOpacity(0.5),
                                        pageBuilder: (context, _, __) {
                                          return SearchScreen(
                                              inputController:
                                                  destinationController);
                                        },
                                        transitionBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return SlideTransition(
                                            position: CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeOut,
                                            ).drive(Tween<Offset>(
                                              begin: Offset(0, -1.0),
                                              end: Offset.zero,
                                            )),
                                            child: child,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  //ride category
                                  Text.rich(
                                    TextSpan(
                                      text: 'Ride Category',
                                      children: [
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  DropdownButtonFormField(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(16),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).dividerColor,
                                            width: 1),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).dividerColor,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    isExpanded: true,
                                    validator: (value) {
                                      if (selectedRideCategory == null) {
                                        rideError = true;
                                        setState(() {});
                                        return 'Choose a ride category';
                                      }
                                    },
                                    items: [...rideCategoryItem],
                                    hint: Text(
                                      'Ride Category',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: rideError == false
                                          ? Colors.grey.shade600
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
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  //no of days required
                                  const Text(
                                    'No of days required',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  TextFormField(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value != null &&
                                          value.contains('-')) {
                                        return 'Invalid number of days';
                                      }
                                    },
                                    controller: daysController,
                                    keyboardType: TextInputType.number,
                                    decoration: decoration.copyWith(
                                      hintText: '1 day',
                                      prefixIcon: const SizedBox(
                                        width: 0,
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 16.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  //no of days required
                                  Text.rich(
                                    TextSpan(
                                      text: 'Vehicle Type',
                                      children: [
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  IgnorePointer(
                                    ignoring: selectedRideCategory == 102
                                        ? true
                                        : false,
                                    child: DropdownButtonFormField(
                                      validator: (value) {
                                        if (selectedVehicleType == null) {
                                          vehicleError = true;
                                          setState(() {});
                                          return 'Choose a vehicle type';
                                        }
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: selectedRideCategory == 102
                                                  ? Theme.of(context)
                                                      .dividerColor
                                                  : vehicleError == false
                                                      ? Theme.of(context)
                                                          .dividerColor
                                                      : Colors.red,
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: selectedRideCategory == 102
                                                  ? Theme.of(context)
                                                      .dividerColor
                                                  : vehicleError == false
                                                      ? Theme.of(context)
                                                          .dividerColor
                                                      : Colors.red,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1,
                                          ),
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
                                          color: selectedRideCategory == 102
                                              ? Theme.of(context).dividerColor
                                              : Colors.grey.shade400,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: selectedRideCategory == 102
                                            ? Colors.grey.shade400
                                            : rideError == false
                                                ? Colors.grey.shade600
                                                : Colors.red,
                                      ),
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      onChanged: (value) {
                                        selectedVehicleType = value as int;

                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 180,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY: 5.0,
                        ),
                        child: const Header(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Footer(
                      formKey: _formKey,
                      requestTrip: requestTrip,
                    ),
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

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Quick Request',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                CloseButtonWidget(),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 1,
            endIndent: 0.0,
            indent: 0.0,
            height: 1,
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  Footer({
    required this.formKey,
    required this.requestTrip,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  var requestTrip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .95,
      height: 88.0,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Divider(
              endIndent: 0.0,
              indent: 0.0,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () async {
                      print(formKey.currentState!.validate());
                      if (formKey.currentState != null) {
                        if (formKey.currentState!.validate()) {
                          await requestTrip();
                          Navigator.pop(context);
                        } else {}
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: const Center(
                        child: Text(
                          'Send Request',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
