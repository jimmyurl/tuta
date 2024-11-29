import 'package:flutter/material.dart';
import 'package:tutor/ui/base_scaffold.dart';
import 'package:tutor/services/payment_service.dart';
import 'package:tutor/services/auth_service.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final PaymentService _paymentService = PaymentService();
  final AuthService _authService = AuthService();
  String _selectedPlan = 'monthly';
  String _selectedPaymentMethod = 'mpesa';

  final Map<String, double> _prices = {
    'monthly': 10000, // 10,000 TZS per month
    'annual': 100000, // 100,000 TZS per year
  };

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Subscribe to Become a Tutor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose your subscription plan:',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Updated from headline6
            ),
            const SizedBox(height: 16),
            _buildPlanSelection(),
            const SizedBox(height: 24),
            Text(
              'Select payment method:',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge, // Updated from headline6
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodSelection(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _processPayment,
              child: const Text('Subscribe Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSelection() {
    return Column(
      children: [
        _buildPlanOption('monthly', 'Monthly Plan', '10,000 TZS/month'),
        const SizedBox(height: 16),
        _buildPlanOption('annual', 'Annual Plan', '100,000 TZS/year'),
      ],
    );
  }

  Widget _buildPlanOption(String plan, String title, String price) {
    return ListTile(
      title: Text(title),
      subtitle: Text(price),
      leading: Radio<String>(
        value: plan,
        groupValue: _selectedPlan,
        onChanged: (String? value) {
          setState(() {
            _selectedPlan = value!;
          });
        },
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Column(
      children: [
        _buildPaymentMethodOption('mpesa', 'M-Pesa'),
        _buildPaymentMethodOption('tigopesa', 'TigoPesa'),
        _buildPaymentMethodOption('airtelmoney', 'Airtel Money'),
        _buildPaymentMethodOption('nmb', 'NMB Bank'),
        _buildPaymentMethodOption('crdb', 'CRDB Bank'),
      ],
    );
  }

  Widget _buildPaymentMethodOption(String method, String name) {
    return ListTile(
      title: Text(name),
      leading: Radio<String>(
        value: method,
        groupValue: _selectedPaymentMethod,
        onChanged: (String? value) {
          setState(() {
            _selectedPaymentMethod = value!;
          });
        },
      ),
    );
  }

  void _processPayment() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to subscribe')),
        );
        return;
      }

      final amount = _prices[_selectedPlan]!;
      final paymentResult = await _paymentService.processPayment(
        amount: amount,
        paymentMethod: _selectedPaymentMethod,
        userId: user.id,
        planType: _selectedPlan,
      );

      if (paymentResult.success) {
        await _authService.updateUserRole(user.id, 'tutor');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Subscription successful! You are now a tutor.')),
        );
        Navigator.of(context).pushReplacementNamed('/upload');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${paymentResult.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}
