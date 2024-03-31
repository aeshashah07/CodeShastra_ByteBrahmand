import 'package:bytebrahmand_codeshastra/Chat/chat_bot.dart';
import 'package:bytebrahmand_codeshastra/Marketplace/marketplace_page.dart';
import 'package:bytebrahmand_codeshastra/More/more_page.dart';
import 'package:bytebrahmand_codeshastra/New%20Chat/new.dart';
import 'package:bytebrahmand_codeshastra/Weather%20Forecasting/weather_forecast.dart';
import 'package:bytebrahmand_codeshastra/constants/colors.dart';
import 'package:bytebrahmand_codeshastra/profile/profile_page.dart';
import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              icon: Icon(Icons.person),
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryColorDark,
        //backgroundColor: secondaryColorDark,
        currentIndex: _selectedIndex,
        // unselectedFontSize: 25,
        // selectedFontSize: 30,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        // enableLineIndicator: true,
        // lineIndicatorWidth: 3,
        // indicatorType: IndicatorType.Top,
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.homePage,
            icon: Icon(Icons.home_rounded),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.weather,
            icon: Icon(Icons.cloud),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.chat,
            icon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            label: 'More',
            icon: Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }
}
