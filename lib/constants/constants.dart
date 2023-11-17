// ignore_for_file: constant_identifier_names
enum ConsignmentStatus {
  PENDING,
  COMPLETED,
  CANCELLED,
  IN_TRANSIT,
  DELIVERED,
  RETURNED,
  LOST,
  DAMAGED,
  ON_HOLD,
}

Map<String, ConsignmentStatus> getStatus = {
  "PENDING": ConsignmentStatus.PENDING,
  "COMPLETED": ConsignmentStatus.COMPLETED,
  "CANCELLED": ConsignmentStatus.CANCELLED,
  "IN_TRANSIT": ConsignmentStatus.IN_TRANSIT,
  "DELIVERED": ConsignmentStatus.DELIVERED,
  "RETURNED": ConsignmentStatus.RETURNED,
  "LOST": ConsignmentStatus.LOST,
  "DAMAGED": ConsignmentStatus.DAMAGED,
  "ON_HOLD": ConsignmentStatus.ON_HOLD,
};
Map<ConsignmentStatus, String> getStringStatus = {
  ConsignmentStatus.PENDING: "PENDING",
  ConsignmentStatus.COMPLETED: "COMPLETED",
  ConsignmentStatus.CANCELLED: "CANCELLED",
  ConsignmentStatus.IN_TRANSIT: "IN_TRANSIT",
  ConsignmentStatus.DELIVERED: "DELIVERED",
  ConsignmentStatus.RETURNED: "RETURNED",
  ConsignmentStatus.LOST: "LOST",
  ConsignmentStatus.DAMAGED: "DAMAGED",
  ConsignmentStatus.ON_HOLD: "ON_HOLD",
};

Map<ConsignmentStatus, int> getCompletionStatus = {
  ConsignmentStatus.PENDING: 0,
  ConsignmentStatus.COMPLETED: 4,
  ConsignmentStatus.CANCELLED: -1,
  ConsignmentStatus.IN_TRANSIT: 3,
  ConsignmentStatus.DELIVERED: 5,
  ConsignmentStatus.RETURNED: 5,
  ConsignmentStatus.LOST: -1,
  ConsignmentStatus.DAMAGED: -1,
  ConsignmentStatus.ON_HOLD: 2,
};
