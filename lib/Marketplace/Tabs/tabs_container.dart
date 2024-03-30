import 'package:bytebrahmand_codeshastra/Marketplace/Tabs/buy.dart';
import 'package:bytebrahmand_codeshastra/Marketplace/Tabs/prices.dart';
import 'package:bytebrahmand_codeshastra/Marketplace/Tabs/sell.dart';
import 'package:bytebrahmand_codeshastra/constants/colors.dart';
import 'package:bytebrahmand_codeshastra/widgets/my_tab.dart';
import 'package:flutter/material.dart';

Container tabsContainer(
    BuildContext context, TabController tabController, List<MyTab> myTabs) {
  return Container(
    height: 300, // MediaQuery.of(context).size.height,
    // color: pink,
    child: Column(
      children: [
        // SizedBox(height: 50),
        Container(
          // height: 50,
          width: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: lightGrey, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: TabBar(
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.black,
                  indicatorColor: Colors.white,
                  indicatorWeight: 2,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  controller: tabController,
                  tabs: myTabs,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [BuyPage(), SellPage(), PricesPage()],
          ),
        )
      ],
    ),
  );
}
