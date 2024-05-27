import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:terratreats/services/sell_in_terratreats_service.dart';
import 'package:terratreats/utils/app_theme.dart';
import 'package:terratreats/widgets/primary_button.dart';

class SellInTerraTreatsScreen extends ConsumerStatefulWidget {
  const SellInTerraTreatsScreen({super.key});

  @override
  ConsumerState<SellInTerraTreatsScreen> createState() =>
      _SellInTerraTreatsScreenState();
}

class _SellInTerraTreatsScreenState
    extends ConsumerState<SellInTerraTreatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Seller Verification",
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.width / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Upload any ID"),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Browse",
                      style: TextStyle(color: AppTheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: PrimaryButton(
                text: "Verify",
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Verification Sent"),
                        content: Text(
                            "Please be informed that our seller account verification process typically takes up to 3 business days to complete. During this time, you may experience limited access to certain features."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                  await sellInTerratreats();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
