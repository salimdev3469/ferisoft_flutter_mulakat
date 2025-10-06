import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

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
                return const Center(child: Text("No user data found"));
              }


              final userData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
              final profilePic = userData['profile_pic_url'] ?? '';
              final monthlySalary = userData['monthly_salary'] ?? 0;
              final yearlySalary = userData['yearly_salary'] ?? 0;
              final recentTransfers = userData['recent_transfers'] != null
                  ? List<String>.from(userData['recent_transfers'])
                  : <String>[];
              final String subscriptionProfile = userData['monthly_subscriptions_profile'] ?? '';
              final String monthlySubscriptionsName = userData['monthly_subscriptions_name'] ?? '';
              // Eğer monthly_subscriptions Timestamp ise:
              final monthlySubscriptionsTimestamp = userData['monthly_subscriptions'];
              final String monthlySubscriptions = monthlySubscriptionsTimestamp != null
                  ? monthlySubscriptionsTimestamp.toDate().toString()
                  : '';

              final String monthlySubscriptionsPrice = userData['monthly_subscriptions_price']?.toString() ?? '';



              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // WELCOME + PROFILE ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Sol taraf: Hoş geldin mesajı
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome, Valentino Morose 👋",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // Sağ taraf: Profil resmi
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: (profilePic.isNotEmpty)
                              ? NetworkImage(profilePic)
                              : null,
                          child: (profilePic.isEmpty)
                              ? const Icon(Icons.person, color: Colors.white, size: 30)
                              : null,
                        ),
                      ],
                    ),


                    const SizedBox(height: 16),

                    // BALANCE CARD
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B46F1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Your Wallet",
                                style: TextStyle(color: Colors.white, fontSize: 24),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "BALANCE",
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "\$36,850.00",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Activities",style: TextStyle(fontSize: 18),)
                    ],
                  ),
                    const SizedBox(height: 20),


                    // Monthly Salary Row
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dolar işareti ikonu (profil resmi yerine)
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.attach_money,
                              color: Colors.green,
                              size: 36,
                            ),
                          ),

                          // Monthly Salary
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "MONTHLY SALARY",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\$$monthlySalary",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),

                          // Yearly Salary
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "\$$yearlySalary",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " /year",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )

                    ,

                    const SizedBox(height: 25),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white, // İstersen farklı bir renk
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "RECENT TRANSFERS",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              // Firestore'dan gelen transfer resimleri
                              ...recentTransfers.map<Widget>((transferUrl) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage: transferUrl.isNotEmpty
                                        ? NetworkImage(transferUrl)
                                        : null,
                                    child: transferUrl.isEmpty
                                        ? const Icon(Icons.person, size: 24, color: Colors.grey)
                                        : null,
                                  ),
                                );
                              }).toList(),

                              // En sağa eklenen + işaretli CircleAvatar
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey.shade200,
                                  child: const Icon(Icons.add, size: 24, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ),

                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "MONTHLY SUBSCRIPTIONS",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Soldaki kısım: profil resmi
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage: subscriptionProfile.isNotEmpty
                                        ? NetworkImage(subscriptionProfile)
                                        : null,
                                    child: subscriptionProfile.isEmpty
                                        ? const Icon(Icons.person, size: 24, color: Colors.grey)
                                        : null,
                                  ),
                                ],
                              ),

                              // Ortadaki kısım: isim ve abonelik bilgisi
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    monthlySubscriptionsName,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    monthlySubscriptions,
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),

                              // En sağdaki kısım: fiyat
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "\$$monthlySubscriptionsPrice",
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold,color: Colors.blue),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              );
            },
          ),
        )

    );
  }
}
