// import 'package:flutter/material.dart';
//
// class CustomCardPopularListView extends StatelessWidget {
//   final List<Map<String, String>> coffeeList = [
//     {
//       "name": "Coffee Vietnam",
//       "price": r"$17.00",
//       "image": "assets/images/coffee.jpg",
//     },
//     {
//       "name": "Coffee Latte",
//       "price": r"$27.00",
//       "image": "assets/images/coffee2.jpg",
//     },
//     {
//       "name": "Coffee Cappuccino",
//       "price": r"$20.00",
//       "image": "assets/images/coffee.jpg",
//     },
//     {
//       "name": "Coffee Cappuccino",
//       "price": r"$22.00",
//       "image": "assets/images/coffee2.jpg",
//     },
//     {
//       "name": "Coffee Latte",
//       "price": r"$27.00",
//       "image": "assets/images/coffee2.jpg",
//     },
//   ];
//
//   CustomCardPopularListView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16.0, right: 16.0),
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: coffeeList.length,
//         itemBuilder: (context, index) {
//           return Card(
//             color: Color(0xffADA095),
//             child: ListTile(
//               contentPadding: EdgeInsets.all(5),
//               leading: Container(
//                 margin: EdgeInsets.only(left: 8),
//                 height: 60,
//                 width: 60,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: AssetImage(coffeeList[index]["image"]!),
//                   ),
//                 ),
//               ),
//               title: Text(
//                 coffeeList[index]["name"]!,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               subtitle: Text(
//                 coffeeList[index]["price"]!,
//                 style: TextStyle(color: Colors.yellow),
//               ),
//               trailing: Container(
//                 margin: EdgeInsets.only(right: 8),
//                 width: 35,
//                 height: 35,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.yellow,
//                 ),
//                 child: Icon(Icons.add, color: Colors.white, size: 28),
//               ),
//             ),
//           );
//         },
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox(height: 15);
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

//---------------------merged with custom button in filtration--------------------
class CustomPopularItemsListView extends StatelessWidget {
  // const CustomPopularItemsListView({super.key});
  const CustomPopularItemsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 16, right: 30),
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: 5,
        itemBuilder: (context, index) {
          return null;
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 20);
        },
      ),
    );
  }
}
