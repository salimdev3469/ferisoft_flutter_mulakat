import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('users').limit(1).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No user data found"));
            }

            final userData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
            final name = userData['name'] ?? "User";
            final balance = userData['balance'] ?? 0;
            final List<dynamic> topMovers =
                userData['top_movers'] ?? [0.0, 0.0];
            final double btcValue = (topMovers.isNotEmpty)
                ? (topMovers[0] as num).toDouble()
                : 0.0;
            final double ctmValue =
            (topMovers.length > 1) ? (topMovers[1] as num).toDouble() : 0.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello $name",
                    style: const TextStyle(
                        fontSize: 21,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // BALANCE CARD
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Your Balance",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "\$$balance",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: -20,
                        bottom: -60,
                        child: Image.asset(
                          "assets/images/4.png",
                          width: 220,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "Actions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 25),

                  // ACTION BUTTONS
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _actionButton("Receive", "assets/images/2.png",
                            Colors.purple.shade100),
                        _actionButton("Send", "assets/images/1.png",
                            Colors.red.shade100),
                        _actionButton("Swap", "assets/images/3.png",
                            Colors.orange.shade100),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // TOP MOVERS
                  const Text(
                    "Top Movers",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _cryptoCard("BTC", 21.58),
                      _cryptoCard("CTM", 35.16),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),


    );
  }

  Widget _actionButton(String title, String img, Color bgColor) {
    return Container(
      margin: const EdgeInsets.only(right: 16), // Kutular arası boşluk
      child: Stack(
        clipBehavior: Clip.none, // Resmin taşmasına izin ver
        children: [
          // Kart kutusu
          Container(
            width: 140,
            height: 160,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.bottomLeft, // Başlığı sol altta göster
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
          ),
          // Taşan resim
          Positioned(
            top: -40, // Üstten taşması
            right: -40, // Sağdan taşması
            child: Image.asset(
              img,
              width: 140, // Resim boyutunu kart boyutuna göre ayarlayabilirsin
            ),
          ),
        ],
      ),
    );
  }



  Widget _cryptoCard(String name, double price) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("\$${price.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.grey, fontSize: 20)),
        ],
      ),
    );
  }
}

