import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:sterling/models/trip.dart';
import 'package:sterling/view_models/dashboard_view.dart';
import 'package:sterling/views/global_utils/cancel_ride_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestCard extends StatefulWidget {
  RequestCard(
      // this.currentrequest,
      {
    super.key,
  });

  // var currentrequest;

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  TextEditingController pickUpController = TextEditingController();

  TextEditingController destinationController = TextEditingController();
  @override
  // void initState() {
  //   pickUpController.text = widget.currentrequest['pickup_location'];
  //   destinationController.text = widget.currentrequest['destination'];
  //   print(widget.currentrequest);
  //   super.initState();
  // }

  var isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // print('where');
    // print(widget.currentrequest['pilot'] == null);
    Trip? currentrequest = Provider.of<DashboardView>(context).currentRequest;
    pickUpController.text = currentrequest!.pickupLocation;
    destinationController.text = currentrequest!.destination;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Request',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 18,
          ),
          child: currentrequest.pilot == 'null'
              ? Column(
                  children: [
                    Image.asset('assets/images/await.png'),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Awaiting for approval',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Image.asset('assets/images/journey.png'),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //todo
                                    Text(
                                      '${currentrequest.rideDate.toString() + '\n' + currentrequest.rideTime.toString().toUpperCase()}',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    //pickUp
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff4f4f4),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 35,
                                      width: MediaQuery.of(context).size.width *
                                          .47,
                                      child: TextField(
                                        readOnly: true,
                                        controller: pickUpController,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        cursorColor: const Color.fromRGBO(
                                            249, 57, 52, 1),
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                width: 2,
                                                color: Color.fromRGBO(
                                                    249, 57, 52, 1)),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),

                                    //destination
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff4f4f4),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 35,
                                      width: MediaQuery.of(context).size.width *
                                          .47,
                                      child: TextField(
                                        readOnly: true,
                                        controller: destinationController,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLength: null,
                                        cursorColor: const Color.fromRGBO(
                                            249, 57, 52, 1),
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                width: 2,
                                                color: Color.fromRGBO(
                                                    249, 57, 52, 1)),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (ctx) =>
                              CancelRideAlert(trip_id: currentrequest.tripId),
                        );
                      },
                      child: Container(
                        height: 37,
                        width: 119,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel Ride',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 23,
                          backgroundColor: const Color(0xffffedec),
                          child: Image.asset(
                            'assets/images/car_img.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentrequest.pilot.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              currentrequest.vehicleType == "null"
                                  ? ''
                                  : currentrequest.vehicleType.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentrequest.pilotNo.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              currentrequest.vehicleNo.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        PopupMenuButton(
                          child: const Icon(Icons.more_vert),
                          onSelected: (value) async {
                            if (value == 0) {
                              if (currentrequest.pilotNo != null) {
                                // final Uri url = Uri(
                                //   scheme: 'tel',
                                //   // path: currentrequest.pilotNo.toString(),
                                //   path: '8170997368',
                                // );
                                // if (await canLaunchUrl(url)) {
                                //   await launchUrl(url);
                                // } else {
                                //   print('Cannot launch url');
                                // }
                                await FlutterPhoneDirectCaller.callNumber(
                                    '${currentrequest.pilotNo.toString()}');
                              }
                            }
                            if (value == 1) {
                              await showDialog(
                                context: context,
                                builder: (ctx) => CancelRideAlert(
                                  trip_id: currentrequest.tripId,
                                ),
                              );
                            }
                          },
                          itemBuilder: (BuildContext bc) {
                            return const [
                              PopupMenuItem(
                                value: 0,
                                child: Text(
                                  'Call Driver',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  'Cancel Ride',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color(0xfff4f4f4),
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Image.asset('assets/images/journey.png'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 120,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    currentrequest.rideDate.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  //pickUp
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff4f4f4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width * .47,
                                    child: TextField(
                                      readOnly: true,
                                      controller: pickUpController,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      cursorColor:
                                          const Color.fromRGBO(249, 57, 52, 1),
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 2,
                                              color: Color.fromRGBO(
                                                  249, 57, 52, 1)),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 120,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    currentrequest.rideTime.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),

                                  //destination
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff4f4f4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width * .47,
                                    child: TextField(
                                      readOnly: true,
                                      controller: destinationController,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                      cursorColor:
                                          const Color.fromRGBO(249, 57, 52, 1),
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 2,
                                              color: Color.fromRGBO(
                                                  249, 57, 52, 1)),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
