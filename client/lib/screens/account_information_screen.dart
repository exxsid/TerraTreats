import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/utils/preferences.dart';

class AccountInformation extends ConsumerStatefulWidget {
  const AccountInformation({super.key});

  @override
  ConsumerState<AccountInformation> createState() => _AccountInformationState();
}

// TODO account information edit
class _AccountInformationState extends ConsumerState<AccountInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Information"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.highlight,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            accountInfoButton(
                title: "Name",
                value:
                    "${Token.getFirstNameToken()} ${Token.getFirstNameToken()}"),
            accountInfoButton(
                title: "Password",
                value:
                    ""),
            accountInfoButton(
                title: "Phonenumber",
                value:
                    "${Token.getPhonenumberToken()}"),
            accountInfoButton(
                title: "Email",
                value:
                    "${Token.getEmailToken()}"),
            accountInfoButton(title: "Virified", value: (Token.getIsVerifiedToken()! ? "Verified": "Not Verified")),
          ],
        ),
      ),
    );
  }

  InkWell accountInfoButton({
    required String title,
    required String value,
  }) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              spreadRadius: 0.5,
            )
          ],
          color: AppTheme.highlight,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Icon(
                  FeatherIcons.chevronRight,
                  color: AppTheme.secondary,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
