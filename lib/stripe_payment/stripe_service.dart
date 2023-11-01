import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService {
  static String secretKey =
      "sk_test_51NrQZXJC30b6QnikqSNLbFmb81gjgBbzlxkXECIFukcoS2aHSRuq3sHaY8t7ZMCve8fXaCIIgjla8ZufHteYthYU00L84nFQ2A";
  static String publishableKey =
      "pk_test_51NrQZXJC30b6QnikDY7KAAvslnPvW9nL4RxZcby26ByrjxDsdl6qQZAMOiI6baDh9n0DOX6zAQiVaw7UKLOKMVUT00XYmz514n";

  static Future<dynamic> createCheckoutSession(
    List<dynamic> productItems,
    totalAmount,
  ) async {
    final url = Uri.parse('https://api.stripe.com/v1/checkout/sessions');

    String lineItems = "";
    int index = 0;
    productItems.forEach(
      (val) {
        var productPrice = (val["productPrice"] * 100).round().toString();
        lineItems +=
            "&line_items[$index][price_data][product_data][name] = ${val['productName']}";
        lineItems +=
            "&line_items[$index][price_data][unit_amount]=$productPrice";
        lineItems += "&line_items[$index][price_data][currency]=EUR";
        lineItems += "&line_items[$index][quantity]=${val['qty'].toString()}";
        index++;
      },
    );

    final response = await http.post(
      url,
      body:
          'success_url=https://checkout.stripe.dev.success&mode=payment$lineItems',
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );
    print('*************************************cancelde***');
    print(json.decode(response.body));
    return json.decode(response.body)["id"];
  }

  static Future<dynamic> stripePaymentCheckout(
    productItems,
    subTotal,
    context,
    mounted, {
    onSuccess,
    onCancel,
    onError,
  }) async {
    final String sessionId = await createCheckoutSession(
      productItems,
      subTotal,
    );
    final result = await redirectToCheckout(
      context: context,
      sessionId: sessionId,
      publishableKey: publishableKey,
      successUrl: "https://checkout.stripe.dev/success",
      canceledUrl: "https://checkout.stripe.dev/cancel",
    );
    if (mounted) {
      final text = result.when(
        redirected: () => 'Rederected successfuly',
        success: () => onSuccess(),
        canceled: () => onCancel(print('nikinasiny *****####')),
        error: (e) => onError(e),
      );

      return text;
    }
  }
}
