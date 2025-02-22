import 'package:flutter/material.dart';

customAppBar({required void Function() onPressed , required context}) {
  return Container(
    color: Color(0xffF5F5F5),
    child: Padding(
      padding: EdgeInsets.only(
        top: 5
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: IconButton(onPressed: onPressed, icon: Icon(Icons.menu) ,),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff64432A),
                ),
              ),
              const Text(
                "Good Morning",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff64432A),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
