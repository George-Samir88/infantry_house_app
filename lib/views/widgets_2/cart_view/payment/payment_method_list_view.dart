import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets_2/cart_view/payment/payment_method_item.dart';

class PaymentMethodsListView extends StatefulWidget {
  const PaymentMethodsListView({super.key});

  @override
  State<PaymentMethodsListView> createState() => _PaymentMethodsListViewState();
}

class _PaymentMethodsListViewState extends State<PaymentMethodsListView> {
  final List<String> imagesPaths = const [
    'assets/images/paymob.png',
    'assets/images/paypal.svg',
  ];

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 62.0.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // To wrap content width
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // Center items horizontally
        children: List.generate(imagesPaths.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  activeIndex = index;
                });
              },
              child: PaymentMethodItem(
                imagePath: imagesPaths[index],
                isActive: activeIndex == index,
              ),
            ),
          );
        }),
      ),
    );
  }
}
