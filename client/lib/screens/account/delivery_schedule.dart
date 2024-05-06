import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:terratreats/riverpod/deliver_schedule_notifier.dart';
import 'package:terratreats/services/deliver_schedule_service.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/appbar.dart';

class DeliverySchedule extends ConsumerStatefulWidget {
  const DeliverySchedule({super.key});

  @override
  ConsumerState<DeliverySchedule> createState() => _DeliveryScheduleState();
}

class _DeliveryScheduleState extends ConsumerState<DeliverySchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.customAppBar(title: "Delivery Schedule"),
      body: Stack(
        children: [
          RefreshIndicator(
            child: scheduleCards(),
            onRefresh: () async {
              setState(() {});
            },
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              backgroundColor: AppTheme.primary,
              child: Icon(
                Ionicons.add_outline,
                color: Colors.white70,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  builder: (context) {
                    return _MyBottomsheetModel();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget scheduleCards() {
    return FutureBuilder(
      future: getDeliverySchedules(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Container(
            child: Center(
              child: Text(
                "Delivery Schedule is Empty.",
              ),
            ),
          );
        }
        final data = snapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data[index].schedule,
                    style: TextStyle(
                      color: AppTheme.primary,
                    ),
                  ),
                  // delete button
                  IconButton(
                    onPressed: () async {
                      await deleteDeliverySchedule(data[index].id);
                      final snackBar = SnackBar(content: Text("Successfully Deleted."));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {
                        
                      });
                    },
                    icon: Icon(
                      Ionicons.trash_bin_outline,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _MyBottomsheetModel extends ConsumerStatefulWidget {
  const _MyBottomsheetModel({super.key});

  @override
  ConsumerState<_MyBottomsheetModel> createState() =>
      __MyBottomsheetModelState();
}

class __MyBottomsheetModelState extends ConsumerState<_MyBottomsheetModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pick Time",
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // start
              TextButton(
                onPressed: () async {
                  final TimeOfDay? selectedTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (selectedTime != null) {
                    ref
                        .read(deliveryScheduleNotifierProvider.notifier)
                        .updateFromSchedule(selectedTime.format(context));
                    setState(() {});
                  }
                },
                child:
                    Text(ref.watch(deliveryScheduleNotifierProvider).fromSched),
              ),
              Text("-"),
              // end
              TextButton(
                onPressed: () async {
                  final TimeOfDay? selectedTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (selectedTime != null) {
                    ref
                        .read(deliveryScheduleNotifierProvider.notifier)
                        .updateToSchedule(selectedTime.format(context));
                    setState(() {});
                  }
                },
                child:
                    Text(ref.watch(deliveryScheduleNotifierProvider).toSched),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton(
                onPressed: () async {
                  String fromSched =
                      ref.watch(deliveryScheduleNotifierProvider).fromSched;
                  String toSched =
                      ref.watch(deliveryScheduleNotifierProvider).toSched;

                  await addDeliverySchedule("$fromSched - $toSched");
                  Navigator.pop(context);
                  final snackbar =
                      SnackBar(content: Text("Schedule successfully added."));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
