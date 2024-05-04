import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/riverpod/user_feedback_notifier.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/primary_button.dart';

class UserFeedback extends ConsumerStatefulWidget {
  const UserFeedback({super.key});

  @override
  ConsumerState<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends ConsumerState<UserFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(8),
          color: AppTheme.highlight,
          child: Wrap(
            children: [
              Text(
                "Your feedback helps us make TerraTreats even better! Let us know what you think to improve your experience.",
                style: TextStyle(
                  color: AppTheme.secondary,
                ),
              ),
              SizedBox(height: 8,),
              Container(
                height: 200,
                child: TextField(
                  keyboardType:
                      TextInputType.multiline, 
                  maxLines: null, 
                  minLines: 5, 
                  textInputAction:
                      TextInputAction.newline, 
                  decoration: InputDecoration(
                    hintText: "Enter your text here...", 
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    ref.read(userFeedbackProvider.notifier).state = value;
                  },
                ),
              ),
              PrimaryButton(text: "Submit", onPressed: () {
                print(ref.watch(userFeedbackProvider.notifier).state);
              },),
            ],
          )),
    );
  }
}
