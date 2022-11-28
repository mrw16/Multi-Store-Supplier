import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ms_supplier_app/dashboard_components/edit_business.dart';
import 'package:ms_supplier_app/dashboard_components/manage_products.dart';
import 'package:ms_supplier_app/dashboard_components/supp_balance.dart';
import 'package:ms_supplier_app/dashboard_components/supp_orders.dart';
import 'package:ms_supplier_app/dashboard_components/supp_statics.dart';
import 'package:ms_supplier_app/main_screens/visit_store.dart';
import 'package:ms_supplier_app/providers/auth_repo.dart';
import 'package:ms_supplier_app/widgets/appbar_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> label = [
  'My Store',
  'orders',
  'edit profile',
  'manage products',
  'balance',
  'statics',
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];

List<Widget> pages = [
  VisitStore(suppId: FirebaseAuth.instance.currentUser!.uid),
  const SupplierOrders(),
  const EditBusiness(),
  const ManageProducts(),
  const Balance(),
  const Statics(),
];

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Dashboard',
        ),
        actions: [
          IconButton(
            onPressed: () {
              showCupertinoModalPopup<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text('Alert'),
                  content: const Text('Are you sure to logout ?'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () async {
                        // Navigator.pop(context);
                        await AuthRepo.logOut();
                        final SharedPreferences pref = await _prefs;
                        pref.setString('supplierid', '');
                        await Future.delayed(const Duration(microseconds: 100))
                            .whenComplete(() {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(
                              context, '/onboarding_screen');
                        });
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          crossAxisCount: 2,
          children: List.generate(6, (index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => pages[index],
                  ),
                );
              },
              child: Card(
                elevation: 20,
                shadowColor: Colors.purpleAccent.shade200,
                color: Colors.blueGrey.withOpacity(0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      icons[index],
                      size: 50,
                      color: Colors.yellowAccent,
                    ),
                    Text(
                      label[index].toUpperCase(),
                      style: GoogleFonts.acme(
                        color: Colors.yellowAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
