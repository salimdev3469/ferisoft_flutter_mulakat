import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController _balanceController = TextEditingController();
  
  Future<void> _addBalance(String userId, int currentBalance) async {
    final value = _balanceController.text.trim();
    if (value.isEmpty) return;

    final int addedBalance = int.tryParse(value) ?? 0;
    final int newBalance = currentBalance + addedBalance;

    // Users koleksiyonundaki balance alanını güncelle
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'balance': newBalance});

    _balanceController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Balance updated: \$${newBalance} ✅")),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('users').limit(1).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("User not found"));
              }

              final userData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
              final salaryNumber = userData['chose_card_salary_number']?.toString() ?? '';
              final salaryPrice = userData['chose_card_salary_price']?.toString() ?? '';
              final familyNumber = userData['chose_card_famaily_number']?.toString() ?? '';
              final familyPrice = userData['chose_card_family_price']?.toString() ?? '';


              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Money Transfer",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Money Transfer Statistics",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "You sent 14% more money this month than last month",
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "SELECT PERSON",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black45),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _balanceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter balance amount",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              final userId = snapshot.data!.docs.first.id;
                              final currentBalance = userData['balance'] ?? 0;
                              _addBalance(userId, currentBalance);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    )
,


                    const SizedBox(height: 30),

                    const Text(
                      "Choose Card",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // Salary kartı
                    _card("Salary", salaryNumber, salaryPrice, Colors.deepPurpleAccent),
                    const SizedBox(height: 16),

                    // Family kartı
                    _card("Family", familyNumber, familyPrice, Colors.deepPurple.shade900),
                  ],
                ),
              );
            },
          ),
        )


    );
  }

  Widget _card(String type, String number, String price, Color color) {
    // Kart numarasını 4'erli parçala ve ilk 8 hanesini maskele
    String maskedNumber = '';
    if (number.length >= 8) {
      maskedNumber = '**** **** ${number.substring(8)}';
    } else {
      maskedNumber = number; // kısa numara varsa direkt göster
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        height: 120,
        child: Stack(
          children: [
            // Sol alt numara
            Positioned(
              left: 0,
              bottom: 16,
              child: Text(
                maskedNumber,
                style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),

            // Price ve kart tipi
            Positioned(
              left: 0,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.toUpperCase(), // SALARY veya FAMILY
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$$price', // başına dolar işareti
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Sağ alttaki manuel textbox
            const Positioned(
              right: 0,
              bottom: 3,
              child: Text(
                "10/28",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
