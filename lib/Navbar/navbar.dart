import 'package:bytebrahmand_codeshastra/Chat/chat_bot.dart';
import 'package:bytebrahmand_codeshastra/Marketplace/marketplace_page.dart';
import 'package:bytebrahmand_codeshastra/More/more_page.dart';
import 'package:bytebrahmand_codeshastra/Weather%20Forecasting/weather_forecast.dart';
import 'package:bytebrahmand_codeshastra/constants/colors.dart';
import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 2;
  List<Widget> _pages = [
    MarketPlacePage(),
    WeatherForecastPage(),
    ChatBotWidget(),
    MorePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FarmSaathi'),
        //centerTitle: true,
        backgroundColor: Colors.grey[100],
        actions: [
          CircleAvatar(
            backgroundColor: secondaryColorDark,
            child: IconButton(
              color: Colors.white,
              onPressed: () {},
              icon: Icon(Icons.person),
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: CustomLineIndicatorBottomNavbar(
        selectedColor: secondaryColorDark,
        unSelectedColor: primaryColor,
        //backgroundColor: secondaryColorDark,
        currentIndex: _selectedIndex,
        unselectedIconSize: 25,
        selectedIconSize: 30,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        enableLineIndicator: true,
        lineIndicatorWidth: 3,
        indicatorType: IndicatorType.Top,
        customBottomBarItems: [
          CustomBottomBarItems(icon: Icons.home_rounded, label: 'Home'),
          CustomBottomBarItems(icon: Icons.cloud, label: 'Weather'),
          CustomBottomBarItems(icon: Icons.chat, label: 'Chat'),
          CustomBottomBarItems(icon: Icons.more_horiz, label: 'More'),
        ],
      ),
    );
  }
}
