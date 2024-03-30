import 'package:bytebrahmand_codeshastra/widgets/crops.dart';
import 'package:bytebrahmand_codeshastra/widgets/equipments.dart';
import 'package:bytebrahmand_codeshastra/widgets/my_tab.dart';
import 'package:flutter/material.dart';

class MarketPlacePage extends StatefulWidget {
  const MarketPlacePage({super.key});

  @override
  State<MarketPlacePage> createState() => _MarketPlacePageState();
}

class _MarketPlacePageState extends State<MarketPlacePage>
    with SingleTickerProviderStateMixin {
  // List<MyTab> myTabs = const [
  //   MyTab(
  //     text: 'Buy',
  //   ),
  //   MyTab(
  //     text: 'Sell',
  //   ),
  //   MyTab(text: 'Prices')
  // ];

  // TabController? tabController;

  // @override
  // void initState() {
  //   tabController = TabController(length: 2, vsync: this);
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   tabController!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Equipments',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      // IconButton(
                      //     onPressed: () {}, icon: Icon(Icons.location_on)),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Equipments();
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Crops',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      // IconButton(
                      //     onPressed: () {}, icon: Icon(Icons.location_on)),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return CropWidget();
                      }),
                ],
              ))),
    );
  }
}
