import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/home_controller/home_controller.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, homeController, _) {
        return Scaffold(
          body: homeController.screens[homeController.selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[300]!,
                color: Colors.black,
                tabs: [
                  GButton(
                    icon: LineIcons.pen,
                    text: 'Notes',
                    iconColor: Colors.white,
                  ),
                  GButton(
                    icon: LineIcons.search,
                    iconColor: Colors.white,
                    text: 'search',
                  ),
                ],
                selectedIndex: homeController.selectedIndex,
                onTabChange: (index) {
                  homeController.ontap(index);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
