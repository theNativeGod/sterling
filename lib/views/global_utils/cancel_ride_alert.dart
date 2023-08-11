import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sterling/services/services.dart';
import 'package:sterling/view_models/dashboard_view.dart';

import 'global_export.dart';

class CancelRideAlert extends StatefulWidget {
  CancelRideAlert({
    required this.trip_id,
    super.key,
  });

  var trip_id;

  @override
  State<CancelRideAlert> createState() => _CancelRideAlertState();
}

class _CancelRideAlertState extends State<CancelRideAlert> {
  Services services = Services();
  var _selectedReason;
  String reason = '';
  List<String> _reasonList = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int i = 0;
  List<DropdownMenuItem> _reasonDropdown = [];
  setDropdownMenu() {
    _reasonList.map((e) {
      _reasonDropdown.add(DropdownMenuItem(
        value: i,
        child: Text(e),
      ));
      i++;
    }).toList();
    i = 0;
    print(_reasonDropdown);
  }

  @override
  void initState() {
    super.initState();

    getReasonsList();
  }

  getReasonsList() {
    _reasonList =
        Provider.of<DashboardView>(context, listen: false).cancelReasons;
    setState(() {
      setDropdownMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                CloseButtonWidget(),
              ],
            ),
          ),
          Image.asset('assets/images/cancel_ride_img.png'),
          const SizedBox(height: 30),
          const Text(
            textAlign: TextAlign.center,
            'Cancel Ride?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason for cancel',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                //form
                Form(
                  key: _formKey,
                  // height: 40,

                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Color(0xfff4f4f4), width: 2),
                  //   borderRadius: BorderRadius.circular(5),
                  //),
                  child: DropdownButtonFormField(
                      isExpanded: true,
                      items: [..._reasonDropdown],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Color(0xfff4f4f4), width: 2),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      validator: (value) {
                        if (value == null) {
                          return 'Select a reason';
                        }
                      },
                      value: _selectedReason,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                      hint: Text(
                        'Reason for cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onChanged: (value) {
                        _selectedReason = value;
                        setState(() {});
                      }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 100,
            alignment: Alignment.center,
            color: Color(0xfff4f4f4),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ThemeButton(
                  buttonText: 'Cancel Ride',
                  width: 150,
                  onTap: () async {
                    try {
                      if (_formKey.currentState!.validate()) {
                        var responseData = await services.cancelRide(
                          widget.trip_id,
                          _reasonList[_selectedReason],
                        );

                        Provider.of<DashboardView>(context, listen: false)
                            .cancelRide();
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
                                responseData['message'].toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
