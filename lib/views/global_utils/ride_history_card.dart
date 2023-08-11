import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sterling/views/global_utils/download_invoice_alert.dart';

import '../../models/user.dart';
import '../../view_models/user_view.dart';

class RideHistoryCard extends StatelessWidget {
  RideHistoryCard({
    this.isPaid,
    required this.price,
    required this.status,
    required this.destination,
    required this.pickup_location,
    required this.pilot,
    required this.pilotNo,
    required this.ride_date,
    required this.ride_time,
    this.vehicleNo,
    required this.tripId,
    required this.trip_id,
    required this.vehicle_type,
    required this.ride_type,
    required this.invoice,
    super.key,
  });
  String? isPaid;
  String? price;
  String? status;
  String? pilot;
  String? pilotNo;
  String? vehicleNo;
  String? tripId;
  String? ride_date;
  String? ride_time;
  String? pickup_location;
  String? destination;
  String? trip_id;
  String? vehicle_type;
  String? ride_type;
  String? invoice;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserView>(context);
    return SizedBox(
      child: Column(
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
                    pilot.toString() == 'null'
                        ? 'Not Assigned'
                        : pilot.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'Pilot',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    vehicle_type.toString() == 'null'
                        ? 'Not Assigned'
                        : vehicle_type.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'Vehicle Type',
                    style: TextStyle(
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
              invoice == null
                  ? SizedBox(
                      height: 0,
                      width: 0,
                    )
                  : invoice!.isEmpty || invoice == 'null'
                      ? SizedBox(
                          height: 0,
                          width: 0,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: InkWell(
                              onTap: () {
                                var user = userProvider.user;
                                String customerName = user.name!;
                                String? customerEmail = user.email;
                                String customerPhone = user.mobile!;
                                showDialog(
                                  context: context,
                                  builder: (ctx) => DownloadInvoiceAlert(
                                    isPaid: isPaid!,
                                    invoiceUrl: invoice.toString(),
                                    tripId: tripId,
                                    amount: price,
                                    customerName: customerName,
                                    customerPhone: customerPhone,
                                    customerEmail: customerEmail!,
                                  ),
                                );
                              },
                              child: Image.asset('assets/images/pdf_img.png')),
                        ),
            ],
          ),
          const Divider(
            color: Color(0xfff4f4f4),
            thickness: 2,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicleNo.toString() == 'null'
                        ? 'Not Assigned'
                        : vehicleNo.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'Vehicle no',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ride_date.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'Date',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pickup_location.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'Pick up location',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    destination.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'Destinations',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price!,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Amount',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    status.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'status',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            thickness: 4,
            color: Color(0xffe8e8e8),
          ),
          
        ],
      ),
    );
  }
}
