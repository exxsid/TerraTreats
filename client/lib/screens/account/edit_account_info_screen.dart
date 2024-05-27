import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/riverpod/edit_account_info_notifier.dart';
import 'package:terratreats/services/edit_account_info_service.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/appbar.dart';
import 'package:terratreats/services/authentication/auth_service.dart';
import 'package:terratreats/utils/preferences.dart';

class EditAccountInfoScreen extends ConsumerStatefulWidget {
  const EditAccountInfoScreen({super.key});

  @override
  ConsumerState<EditAccountInfoScreen> createState() =>
      _EditAccountInfoScreenState();
}

class _EditAccountInfoScreenState extends ConsumerState<EditAccountInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _formValidator(String? value) {
    if (value == null) {
      return "This field is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final infoFormStateReader = ref.read(_infoFormNotifierProvider.notifier);
    final editAccInfoWatcher = ref.watch(editAccountInfoNotifierProvider);
    final nameFormReader = ref.read(_nameFormNotifierProvider.notifier);

    return Scaffold(
      appBar: MyAppBar.customAppBar(title: editAccInfoWatcher.info),
      body: SizedBox(
        height: double.infinity,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (editAccInfoWatcher.info == "Name"
                          ? nameFormField(nameFormReader)
                          : majorityFormField(
                              editAccInfoWatcher, infoFormStateReader)),
                    ],
                  ),
                ),
                // save and cancel
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (editAccInfoWatcher.info == "Name") {
                          saveName();
                        } else {
                          saveAccInfo();
                        }
                        AuthService().login(
                          Token.getEmailToken()!,
                          Token.getPasswordToken()!,
                        );
                        setState(() {});
                      },
                      style: OutlinedButton.styleFrom(
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
          ),
        ),
      ),
    );
  }

  Future<void> saveName() async {
    final watcher = ref.watch(_nameFormNotifierProvider);
    try {
      if (watcher.newFirstname != watcher.confirmFirstname ||
          watcher.newLastname != watcher.confirmLastname) {
        final snackBar = SnackBar(content: Text("Input mismatch"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      await editName(watcher.confirmFirstname, watcher.confirmFirstname);
      final snackBar = SnackBar(content: Text("Success"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } on Exception catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> saveAccInfo() async {
    final watcher = ref.watch(_infoFormNotifierProvider);
    try {
      if (watcher.newInfo != watcher.confirmInfo) {
        final snackBar = SnackBar(content: Text("Input mismatch"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      switch (ref.watch(editAccountInfoNotifierProvider).info) {
        case "Password":
          await editPassword(watcher.confirmInfo);
          break;
        case "Phonenumber":
          await editPhonenumber(watcher.confirmInfo);
          break;
        case "Email":
          await editEmail(watcher.confirmInfo);
          break;
      }
      final snackBar = SnackBar(content: Text("Success"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } on Exception catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Column nameFormField(_NameFormNotifier stateReader) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "New Firstname",
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter here",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          onChanged: (value) {
            stateReader.updateNewFirstname(value);
          },
          validator: _formValidator,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "New Lastname",
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter here",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          onChanged: (value) {
            stateReader.updateNewLastname(value);
          },
          validator: _formValidator,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "Confirm Firstname",
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter here",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          onChanged: (value) {
            stateReader.updateConfirmFirstname(value);
          },
          validator: _formValidator,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "Confirm Lastname",
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter here",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          onChanged: (value) {
            stateReader.updateConfirmLastname(value);
          },
          validator: _formValidator,
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Column majorityFormField(EditAccountInfoNotifier editAccountInfoWatcher,
      _InfoFormNotifier infoFormStateReader) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "New ${editAccountInfoWatcher.info}",
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter here",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          onChanged: (value) {
            infoFormStateReader.updateNewInfo(value);
          },
          validator: _formValidator,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "Confirm ${editAccountInfoWatcher.info}",
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter here",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          onChanged: (value) {
            infoFormStateReader.updateConfirmInfo(value);
          },
          validator: _formValidator,
        ),
      ],
    );
  }
}

class _InfoFormNotifier extends ChangeNotifier {
  String newInfo = "";
  String confirmInfo = "";

  void updateNewInfo(String n) {
    newInfo = n;
    notifyListeners();
  }

  void updateConfirmInfo(String c) {
    confirmInfo = c;
    notifyListeners();
  }
}

final _infoFormNotifierProvider =
    ChangeNotifierProvider((ref) => _InfoFormNotifier());

class _NameFormNotifier extends ChangeNotifier {
  String newFirstname = "";
  String newLastname = "";
  String confirmFirstname = "";
  String confirmLastname = "";

  void updateNewFirstname(String f) {
    newFirstname = f;
    notifyListeners();
  }

  void updateNewLastname(String l) {
    newLastname = l;
    notifyListeners();
  }

  void updateConfirmFirstname(String f) {
    confirmFirstname = f;
    notifyListeners();
  }

  void updateConfirmLastname(String l) {
    confirmLastname = l;
    notifyListeners();
  }
}

final _nameFormNotifierProvider =
    ChangeNotifierProvider((ref) => _NameFormNotifier());
