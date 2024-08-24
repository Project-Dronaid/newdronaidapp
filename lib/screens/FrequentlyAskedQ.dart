
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class FrequentlyAskedQ extends StatelessWidget {

  final List<Map<String, String>> faqData = [
    {
      "question": "How can I request a drone?",
      "answer": "You can request a drone by navigating to the request page and filling out the required details."
    },
    {
      "question": "How do I see my request history?",
      "answer": "You can track your request in the 'Request History' in the Profile Page section of the app."
    },
    {
      "question": "What are the operating hours for drone deliveries?",
      "answer": "Our drones operate 24/7, ensuring that your requests are fulfilled at any time."
    },
    {
      "question": "How can I update my hospital delivery location?",
      "answer": "You can update your hospital location by going to the Home page."
    },
    {
      "question": "Further Questions?",
      "answer": "Contact us on our E-mail ID."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: faqData.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      faqData[index]['question']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor, // Set question color to kPrimaryColor
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      faqData[index]['answer']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black, // Set answer color to black
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
