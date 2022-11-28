import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ms_supplier_app/minor_screens/full_screen_view.dart';
import 'package:ms_supplier_app/models/product_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:expandable/expandable.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailsScreen({super.key, required this.proList});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: widget.proList['maincateg'])
      .where('subcateg', isEqualTo: widget.proList['subcateg'])
      .snapshots();

  late final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
      .collection('products')
      .doc(widget.proList['proid'])
      .collection('reviews')
      .snapshots();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.proList['proimages'];
  @override
  Widget build(BuildContext context) {
    var onSale = widget.proList['discount'];
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullscreenView(
                            imagesList: imagesList,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                            pagination: const SwiperPagination(
                                builder: SwiperPagination.fraction),
                            itemBuilder: (context, index) {
                              return Image(
                                image: NetworkImage(
                                  imagesList[index],
                                ),
                              );
                            },
                            itemCount: imagesList.length,
                          ),
                        ),
                        Positioned(
                          left: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              icon: const Icon(
                                Icons.share,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.proList['proname'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'USD ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.proList['price'].toStringAsFixed(2),
                                  style: onSale != 0
                                      ? const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w600,
                                        )
                                      : const TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                onSale != 0
                                    ? Text(
                                        ((1 -
                                                    (widget.proList[
                                                            'discount'] /
                                                        100)) *
                                                widget.proList['price'])
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : const Text(''),
                              ],
                            ),
                          ],
                        ),
                        widget.proList['instock'] == 0
                            ? const Text(
                                'this item is out of stock',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              )
                            : Text(
                                (widget.proList['instock'].toString()) +
                                    (' pieces available in stock'),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                        const ProDetailsHeader(
                          label: '    Item Description    ',
                        ),
                        Text(
                          widget.proList['prodesc'],
                          textScaleFactor: 1.1,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Stack(
                          children: [
                            const Positioned(
                              right: 50,
                              top: 15,
                              child: Text('total'),
                            ),
                            ExpandableTheme(
                              data: const ExpandableThemeData(
                                iconColor: Colors.blue,
                                iconSize: 30,
                              ),
                              child: reviews(reviewsStream),
                            ),
                          ],
                        ),
                        const ProDetailsHeader(
                          label: '   Similar  Items   ',
                        ),
                        SizedBox(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _productsStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    'This category \n\n has no items yet!',
                                    style: GoogleFonts.acme(
                                      fontSize: 26,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }

                              return SingleChildScrollView(
                                child: StaggeredGridView.countBuilder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  crossAxisCount: 2,
                                  itemBuilder: (context, index) {
                                    return ProductModel(
                                      products: snapshot.data!.docs[index],
                                    );
                                  },
                                  staggeredTileBuilder: (context) =>
                                      const StaggeredTile.fit(1),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProDetailsHeader extends StatelessWidget {
  final String label;
  const ProDetailsHeader({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.yellow.shade900,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

Widget reviews(var reviewsStream) {
  return ExpandablePanel(
    header: const Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        'Reviews',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    ),
    collapsed: SizedBox(
      height: 230,
      child: reviewsAll(reviewsStream),
    ),
    expanded: reviewsAll(reviewsStream),
  );
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.hasError) {
        return const Text('Something went wrong');
      }

      if (snapshot2.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot2.data!.docs.isEmpty) {
        return Center(
          child: Text(
            'This Item \n\n has no Reviews yet!',
            style: GoogleFonts.acme(
              fontSize: 26,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: snapshot2.data!.docs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(snapshot2.data!.docs[index]['profileimage']),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(snapshot2.data!.docs[index]['name']),
                Row(
                  children: [
                    Text(snapshot2.data!.docs[index]['rate'].toString()),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Text(snapshot2.data!.docs[index]['comment']),
          );
        },
      );
    },
  );
}
