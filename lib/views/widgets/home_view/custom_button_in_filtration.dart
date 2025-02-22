import 'package:flutter/material.dart';

import 'custom_popular_item.dart';

class CustomButtonInfiltrationAndPopularItems extends StatefulWidget {
  const CustomButtonInfiltrationAndPopularItems({super.key});

  @override
  State<CustomButtonInfiltrationAndPopularItems> createState() =>
      _CustomButtonInfiltrationAndPopularItemsState();
}

final List<String> buttonTitle = const [
  'Salads',
  'Dishes',
  'Meals',
  'Drinks',
  'Desserts',
];

class _CustomButtonInfiltrationAndPopularItemsState
    extends State<CustomButtonInfiltrationAndPopularItems> {
  int selectedIndex = 0; // Track selected button index
  final List<Widget> latteList = const [
    CustomPopularItem(
      title: 'Cappuccino Latte',
      price: '25.00',
      photoPath: 'assets/images/coffee.jpg', rating: 1,
    ),
    CustomPopularItem(
      title: 'Cappuccino Latte',
      price: '25.00',
      photoPath: 'assets/images/coffee.jpg',
      rating: 2,
    ),
    CustomPopularItem(
      title: 'Cappuccino Latte',
      price: '25.00',
      photoPath: 'assets/images/coffee.jpg',
      rating: 3,
    ),
    CustomPopularItem(
      title: 'Cappuccino Latte',
      price: '25.00',
      photoPath: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    CustomPopularItem(
      title: 'Cappuccino Latte',
      price: '25.00',
      photoPath: 'assets/images/coffee.jpg',
      rating: 5,
    ),
  ];
  final List<Widget> coffeeList = const [
    CustomPopularItem(
      title: 'Coffee',
      price: '20.00',
      photoPath: 'assets/images/coffee2.jpg',
      rating: 1,
    ),
    CustomPopularItem(
      title: 'Coffee',
      price: '20.00',
      photoPath: 'assets/images/coffee2.jpg',
      rating: 2,
    ),
    CustomPopularItem(
      title: 'Coffee',
      price: '20.00',
      photoPath: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
    CustomPopularItem(
      title: 'Coffee',
      price: '20.00',
      photoPath: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    CustomPopularItem(
      title: 'Coffee',
      price: '20.00',
      photoPath: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
  ];

  List<Widget> listToBeShow = [];

  void updateSelectedList(int selectedIndex) {
    setState(() {
      switch (selectedIndex) {
        case 0:
          listToBeShow = latteList;
          break;
        case 1:
          listToBeShow = coffeeList;
          break;
        case 2:
          listToBeShow = latteList;
          break;
        case 3:
          listToBeShow = coffeeList;
          break;
        case 4:
          listToBeShow = latteList;
          break;
        default:
          listToBeShow = coffeeList; // Default list
      }
    });
  }

  @override
  void initState() {
    super.initState();
    listToBeShow = latteList; // Default list at start
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 16),
          height: 50, // Adjust height as needed
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: buttonTitle.length, // Number of buttons
            itemBuilder: (context, index) {
              bool isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    updateSelectedList(index);
                  });
                },
                child: Container(
                  margin:
                      index == buttonTitle.length - 1
                          ? EdgeInsets.only(right: 16)
                          : null,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.brown[800] : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      buttonTitle[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSelected ? 16 : null,
                        fontWeight: isSelected ? FontWeight.w500 : null,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 8);
            },
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(left: 16, right: 30),
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: listToBeShow.length,
            itemBuilder: (context, index) {
              return listToBeShow[index];
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 20);
            },
          ),
        ),
      ],
    );
  }
}
