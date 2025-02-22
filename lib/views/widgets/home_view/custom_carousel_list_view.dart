//----------------------old design-------------------
// import 'package:flutter/material.dart';
//
// import 'custom_popular_item.dart';
//
// class CustomCarouselListView extends StatelessWidget {
//   const CustomCarouselListView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(left: 16, right: 30),
//       height: 250,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         clipBehavior: Clip.none,
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return CustomCarouselCardItem();
//         },
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox(width: 40);
//         },
//       ),
//     );
//   }
// }

//------------------------------------------------------

