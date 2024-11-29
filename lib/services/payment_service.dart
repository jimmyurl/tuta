import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentResult {
  final bool success;
  final String message;

  PaymentResult({
    required this.success,
    required this.message,
  });
}

class PaymentService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<PaymentResult> processPayment({
    required double amount,
    required String paymentMethod,
    required String userId,
    required String planType,
  }) async {
    try {
      // Record the payment attempt in the database
      await _supabaseClient.from('payments').insert({
        'user_id': userId,
        'amount': amount,
        'payment_method': paymentMethod,
        'plan_type': planType,
        'status': 'pending',
      });

      // Here you would typically integrate with your actual payment provider
      // This is a placeholder that simulates a successful payment

      // Update payment status to success
      await _supabaseClient
          .from('payments')
          .update({
            'status': 'completed',
          })
          .eq('user_id', userId)
          .eq('status', 'pending');

      return PaymentResult(
        success: true,
        message: 'Payment processed successfully',
      );
    } catch (error) {
      return PaymentResult(
        success: false,
        message: error.toString(),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getPaymentHistory(String userId) async {
    try {
      final response = await _supabaseClient
          .from('payments')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch payment history: $error');
    }
  }
}
