import 'package:flutter/material.dart';

import '../../../global_utils/upload_document.dart';

class PilotRideHistoryCard extends StatelessWidget {
  PilotRideHistoryCard(
      {required this.customer_mobile,
      required this.customer_name,
      required this.destination,
      required this.pickupLocation,
      required this.rideDate,
      required this.tripId,
      super.key});
  String? customer_name;
  String? customer_mobile;
  String? rideDate;
  String? pickupLocation;
  String? destination;
  var tripId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer_name.toString() == 'null'
                      ? 'Not Assigned'
                      : customer_name.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  customer_mobile.toString(),
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
                  rideDate.toString(),
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
            SizedBox(
              width: 16,
            ),
            InkWell(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (ctx) => UploadDocument(tripId: tripId),
                );
              },
              child: Icon(
                Icons.drive_folder_upload,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
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
                  pickupLocation.toString(),
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
        const SizedBox(height: 10),
        const Divider(
          thickness: 4,
          color: Color(0xffe8e8e8),
        ),
      ],
    );
  }
}
