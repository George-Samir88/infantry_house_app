import 'package:flutter/material.dart';

import 'home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  String selectedCategory = "Coffee";
  List<String> categories = ["Milk", "Tea", "Coffee", "Juice"];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffF5F5F5),
        drawer: Drawer(
          backgroundColor: Colors.transparent,
          clipBehavior: Clip.none,
          width:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width * 0.16
                  : MediaQuery.of(context).size.width * 0.1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.brown[800],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => _scaffoldKey.currentState!.closeDrawer(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder:
                          (context, index) =>
                              buildDrawerItem(categories[index]),
                      separatorBuilder:
                          (context, index) =>
                              SizedBox(height: 40), // Space between items
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: 40.0,
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  child: Icon(Icons.home, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
        ),
        body: HomeViewBody(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
    );
  }

  Widget buildDrawerItem(String title) {
    bool isActive = selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20), // Increased spacing
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (isActive)
              Positioned(
                right: -15,
                child: Container(
                  clipBehavior: Clip.none,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.brown[800],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isActive ? Colors.white : Colors.grey,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isActive)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(Icons.circle, size: 6, color: Colors.white),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
