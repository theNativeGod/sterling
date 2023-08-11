class PilotTrip {
  String customerName;
  String customerMobile;
  String customerEmail;
  String tripId;
  String rideDate;
  String rideTime;
  String pickupLocation;
  String destination;
  String status;
  String trip_id;
  String vehicleType;
  String rideType;
  String price;
  String invoice;
  PilotTrip({
    required this.customerEmail,
    required this.customerMobile,
    required this.customerName,
    required this.destination,
    required this.invoice,
    required this.pickupLocation,
    required this.price,
    required this.rideDate,
    required this.rideTime,
    required this.rideType,
    required this.status,
    required this.tripId,
    required this.trip_id,
    required this.vehicleType,
  });
}
