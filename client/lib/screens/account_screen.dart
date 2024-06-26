import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:ionicons/ionicons.dart";
import "package:terratreats/riverpod/navigation_notifier.dart";
import "package:terratreats/screens/account/delivery_schedule.dart";
import "package:terratreats/screens/account/my_orders_screen.dart";
import "package:terratreats/screens/account/my_products_screen.dart";
import "package:terratreats/screens/account_information_screen.dart";
import "package:terratreats/screens/feedback_screen.dart";

import "package:terratreats/screens/login.dart";
import "package:terratreats/screens/my_parcel_screen.dart";
import "package:terratreats/screens/account/edit_my_products_screen.dart";
import "package:terratreats/screens/sell_in_terratreats_screen.dart";
import "package:terratreats/services/authentication/auth_service.dart";
import "package:terratreats/services/order_service.dart";
import "package:terratreats/utils/app_theme.dart";
import "package:terratreats/utils/preferences.dart";

class Account extends ConsumerStatefulWidget {
  const Account({super.key});

  @override
  ConsumerState<Account> createState() => _AccountState();
}

class _AccountState extends ConsumerState<Account> {
  @override
  Widget build(BuildContext context) {
    bool isSeller = Token.getIsSellerToken()!;
    return Container(
      height: double.infinity,
      color: AppTheme.highlight,
      padding: EdgeInsets.all(8),
      child: RefreshIndicator(
        onRefresh: () async {
          await AuthService()
              .login(Token.getEmailToken()!, Token.getPasswordToken()!);
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileCard(),
              const SizedBox(height: 16),
              myParcelCard(),
              const SizedBox(height: 16),
              accountButton(
                title: const Text("Account Information"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountInformation(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              accountButton(
                title: const Text("Feedback"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return UserFeedback();
                    }),
                  );
                },
              ),
              (isSeller ? sellerAccountButtons() : notSellerAccountButtons()),
              const SizedBox(height: 16),
              logoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Column sellerAccountButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        accountButton(
          title: const Text("My Products"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyProducstScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        accountButton(
          title: const Text("My Orders"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyOrders(),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        accountButton(
          title: const Text("Delivery Schedule"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeliverySchedule(),
              ),
            );
          },
        ),
      ],
    );
  }

  Column notSellerAccountButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        accountButton(
          title: const Text("Sell in TerraTreats"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SellInTerraTreatsScreen();
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Container logoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.highlight,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            spreadRadius: 1,
          )
        ],
      ),
      child: InkWell(
        child: Center(
          child: Text(
            "Logout",
            style: TextStyle(color: Colors.red[700]),
          ),
        ),
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return Consumer(builder: (context, ref, child) {
                return AlertDialog(
                  title: const Text("Logout"),
                  content: const SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text('Are you sure you want to logout?'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Yes"),
                      onPressed: () {
                        ref
                            .read(navigationNotifierProvider.notifier)
                            .updateNavigationIndex(0);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const Login();
                          }),
                          (Route<dynamic> route) => route is Login,
                        );
                      },
                    ),
                    TextButton(
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
            }),
      ),
    );
  }

  Container accountButton({required Text title, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.highlight,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            spreadRadius: 1,
          )
        ],
      ),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: title,
        ),
        onTap: onTap,
      ),
    );
  }

  Column myParcelCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "My Parcels",
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // To Pay
            myParcelButton(
              onPressed: () async {
                final parcels = await getToPayParcel(Token.getUserToken()!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MyParcel(
                        parcels: parcels,
                        title: "To Pay",
                      );
                    },
                  ),
                );
              },
              title: "To Pay",
              buttonIcon: Icon(
                FeatherIcons.creditCard,
                color: AppTheme.primary,
              ),
            ),
            // To Ship
            myParcelButton(
              onPressed: () async {
                final parcels = await getToShipParcel(Token.getUserToken()!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MyParcel(
                        parcels: parcels,
                        title: "To Ship",
                      );
                    },
                  ),
                );
              },
              title: "To Ship",
              buttonIcon: Icon(
                FeatherIcons.package,
                color: AppTheme.primary,
              ),
            ),
            // To Recieve
            myParcelButton(
              onPressed: () async {
                final parcels = await getToDeliverParcel(Token.getUserToken()!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MyParcel(
                        parcels: parcels,
                        title: "To Recieve",
                      );
                    },
                  ),
                );
              },
              title: "To Recieve",
              buttonIcon: Icon(
                FeatherIcons.truck,
                color: AppTheme.primary,
              ),
            ),
            // To Review
            myParcelButton(
              onPressed: () async {
                final parcels = await getToReviewParcel(Token.getUserToken()!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MyParcel(
                        parcels: parcels,
                        title: "To Review",
                      );
                    },
                  ),
                );
              },
              title: "To Review",
              buttonIcon: Icon(
                FeatherIcons.messageSquare,
                color: AppTheme.primary,
              ),
            ),
          ],
        )
      ],
    );
  }

  Column myParcelButton({
    required VoidCallback onPressed,
    required String title,
    required Icon buttonIcon,
  }) {
    return Column(
      children: <Widget>[
        IconButton(
          onPressed: onPressed,
          icon: buttonIcon,
        ),
        Text(
          title,
          style: TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Container profileCard() {
    return Container(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blueAccent,
            ),
            child: Icon(
              Ionicons.person_outline,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${Token.getFirstNameToken()} ${Token.getLastNameToken()}",
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "${Token.getBarangayToken()}, ${Token.getCityToken()}, ${Token.getProvinceToken()}",
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
