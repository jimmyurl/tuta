import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> initiateMobilePayment(String paymentMethod, double amount) async {
  final response = await http.post(
    Uri.parse('https://api.paymentgateway.com/payments'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer YOUR_API_KEY',
    },
    body: jsonEncode({
      'method': paymentMethod,
      'amount': amount,
      'currency': 'TZS',
    }),
  );

  if (response.statusCode == 200) {
    // Handle successful payment
  } else {
    // Handle payment error
  }
}
