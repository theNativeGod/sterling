class Trip {
  final String? pilot;
  final String? pilotNo;
  final String? vehicleNo;
  final String tripId;
  final String rideDate;
  final String rideTime;
  final String pickupLocation;
  final String destination;
  final String status;
  final String trip_id;
  final String? vehicleType;
  final String rideType;
  final String price;
  final String? invoice;
  final String? isPaid;
  Trip({
    this.isPaid,
    this.price = '0.00',
    required this.pilot,
    required this.pilotNo,
    required this.vehicleNo,
    required this.vehicleType,
    required this.rideDate,
    required this.rideTime,
    required this.rideType,
    required this.destination,
    required this.pickupLocation,
    required this.status,
    required this.tripId,
    required this.trip_id,
    this.invoice,
  });
}
