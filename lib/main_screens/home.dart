// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ms_supplier_app/galleries/accessories_gallery.dart';
import 'package:ms_supplier_app/galleries/bags_gallery.dart';
import 'package:ms_supplier_app/galleries/beauty_gallery.dart';
import 'package:ms_supplier_app/galleries/electronics_gallery.dart';
import 'package:ms_supplier_app/galleries/homegarden_gallery.dart';
import 'package:ms_supplier_app/galleries/kids_gallery.dart';
import 'package:ms_supplier_app/galleries/men_gallery.dart';
import 'package:ms_supplier_app/galleries/shoes_gallery.dart';
import 'package:ms_supplier_app/galleries/women_gallery.dart';
import 'package:ms_supplier_app/widgets/fake_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: FakeSeach(),
          bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.yellow,
              indicatorWeight: 4,
              tabs: const [
                RepeatedTab(label: 'Men'),
                RepeatedTab(label: 'Women'),
                RepeatedTab(label: 'Shoes'),
                RepeatedTab(label: 'Bags'),
                RepeatedTab(label: 'Electronics'),
                RepeatedTab(label: 'Accessories'),
                RepeatedTab(label: 'Home & Garden'),
                RepeatedTab(label: 'Kids'),
                RepeatedTab(label: 'Beauty'),
              ]),
        ),
        body: TabBarView(children: const [
          MenGalleryScreen(),
          WomenGalleryScreen(),
          ShoesGalleryScreen(),
          BagsGalleryScreen(),
          ElectronicsGalleryScreen(),
          AccessoriesGalleryScreen(),
          HomegardenGalleryScreen(),
          KidsGalleryScreen(),
          BeautyGalleryScreen(),
        ]),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
