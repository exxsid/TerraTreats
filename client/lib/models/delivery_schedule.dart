class DeliveryScheduleModel {
  final int id;
  final String schedule;

  DeliveryScheduleModel({
    required this.id,
    required this.schedule,
  });

  factory DeliveryScheduleModel.fromJson(Map<String, dynamic> json) {
    return DeliveryScheduleModel(
      id: json['deliver_id'],
      schedule: json['schedule'],
    );
  }
}
