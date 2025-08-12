import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'Card';

  @override
  Widget build(BuildContext context) {
     final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
  final totalAmount = args["totalAmount"] as double? ?? 0.0;
  final deliveryMethod = args["deliveryMethod"] as String? ?? "Door delivery";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Payment", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Payment Method"),
            _buildOptionCard(Icons.credit_card, "Card"),
            _buildOptionCard(Icons.account_balance, "Bank account"),
            const SizedBox(height: 24),
            _buildSectionTitle("Delivery Method"),
            _buildStaticOption(deliveryMethod),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total", style: TextStyle(fontSize: 16)),
                Text(
                  "${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Payment processing logic here
                },
                child: const Text(
                  "Proceed to Payment",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildOptionCard(IconData icon, String title) {
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = title),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                _selectedPaymentMethod == title
                    ? const Color(0xFFFF6B35)
                    : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  _selectedPaymentMethod == title
                      ? const Color(0xFFFF6B35)
                      : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
            Radio<String>(
              value: title,
              groupValue: _selectedPaymentMethod,
              onChanged: (_) => setState(() => _selectedPaymentMethod = title),
              activeColor: const Color(0xFFFF6B35),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticOption(String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.local_shipping, color: const Color(0xFFFF6B35)),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
        ],
      ),
    );
  }
}
