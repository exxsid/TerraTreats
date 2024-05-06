import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryScheduleNotifer extends ChangeNotifier {
  String fromSched = "01:00 AM";
  String toSched = "02:00 AM";

  void updateFromSchedule(String sched) {
    fromSched = sched;
    notifyListeners();
  }

  void updateToSchedule(String sched) {
    toSched = sched;
    notifyListeners();
  }

}

final deliveryScheduleNotifierProvider = ChangeNotifierProvider((ref) => DeliveryScheduleNotifer());

class SchedulesNotifier extends ChangeNotifier {
  List<String> schedules = [];

  void addSchedule(String sched) {
    schedules.add(sched);
    notifyListeners();
  }

  void removeSchedule(int index) {
    schedules.removeAt(index);
    notifyListeners();
  }

  void updateSchedule(List<String> sched) {
    this.schedules = sched;
    notifyListeners();
  }
}

final schedulesNotifierProvider = ChangeNotifierProvider((ref) => SchedulesNotifier());