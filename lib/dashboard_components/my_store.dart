import 'package:flutter/material.dart';
import 'package:ms_supplier_app/widgets/appbar_widgets.dart';

class MyStore extends StatelessWidget {
  const MyStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'MyStore',
        ),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
