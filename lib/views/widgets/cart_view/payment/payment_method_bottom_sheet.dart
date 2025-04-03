import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:infantry_house_app/global_variables.dart';
import 'package:infantry_house_app/utils/custom_elevated_button.dart';
import 'package:infantry_house_app/views/widgets/cart_view/payment/payment_method_list_view.dart';

import '../../../../generated/l10n.dart';

class PaymentMethodsBottomSheet extends StatelessWidget {
  const PaymentMethodsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          PaymentMethodsListView(),
          SizedBox(height: 32),
          CustomElevatedButton(
            width: MediaQuery.sizeOf(context).width,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (BuildContext context) => PaypalCheckoutView(
                        sandboxMode: true,
                        clientId: "YOUR CLIENT ID",
                        secretKey: "YOUR SECRET KEY",
                        transactions: const [
                          {
                            "amount": {
                              "total": '100',
                              "currency": "USD",
                              "details": {
                                "subtotal": '100',
                                "shipping": '0',
                                "shipping_discount": 0,
                              },
                            },
                            "description":
                                "The payment transaction description.",
                            // "payment_options": {
                            //   "allowed_payment_method":
                            //       "INSTANT_FUNDING_SOURCE"
                            // },
                            "item_list": {
                              "items": [
                                {
                                  "name": "Apple",
                                  "quantity": 4,
                                  "price": '10',
                                  "currency": "USD",
                                },
                                {
                                  "name": "Pineapple",
                                  "quantity": 5,
                                  "price": '12',
                                  "currency": "USD",
                                },
                              ],

                              // Optional
                              //   "shipping_address": {
                              //     "recipient_name": "Tharwat samy",
                              //     "line1": "tharwat",
                              //     "line2": "",
                              //     "city": "tharwat",
                              //     "country_code": "EG",
                              //     "postal_code": "25025",
                              //     "phone": "+00000000",
                              //     "state": "ALex"
                              //  },
                            },
                          },
                        ],
                        note: "Contact us for any questions on your order.",
                        onSuccess: (Map params) async {
                          Navigator.pop(context);
                        },
                        onError: (error) {
                          Navigator.pop(context);
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      ),
                ),
              );
            },
            text: S.of(context).Checkout,
            tabletLayout: GlobalData().isTabletLayout,
          ),
        ],
      ),
    );
  }
}
