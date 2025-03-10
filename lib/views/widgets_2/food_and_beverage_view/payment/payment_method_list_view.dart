import 'package:flutter/cupertino.dart';
import 'package:infantry_house_app/views/widgets_2/food_and_beverage_view/payment/payment_method_item.dart';

class PaymentMethodsListView extends StatefulWidget {
  const PaymentMethodsListView({super.key});

  @override
  State<PaymentMethodsListView> createState() => _PaymentMethodsListViewState();
}

class _PaymentMethodsListViewState extends State<PaymentMethodsListView> {
  final List<String> imagesPaths = const [
    'assets/images/credit.svg',
    'assets/images/paypal.svg',
  ];

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62.0,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                activeIndex = index;
                setState(() {});
              },
              child: PaymentMethodItem(
                imagePath: imagesPaths[index],
                isActive: activeIndex == index,
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: imagesPaths.length,
      ),
    );
  }
}
