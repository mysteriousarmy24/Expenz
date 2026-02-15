import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/constants.dart';
import 'package:flutter/material.dart';

class BankSelectionScreen extends StatefulWidget {
  final Function(String) onBankSelected;

  const BankSelectionScreen({
    super.key,
    required this.onBankSelected,
  });

  @override
  State<BankSelectionScreen> createState() => _BankSelectionScreenState();
}

class _BankSelectionScreenState extends State<BankSelectionScreen> {
  String? selectedBank;

  // List of popular banks
  final List<Map<String, String>> bankList = [
    {'name': 'State Bank of India', 'icon': '🏦'},
    {'name': 'HDFC Bank', 'icon': '🏧'},
    {'name': 'ICICI Bank', 'icon': '💳'},
    {'name': 'Axis Bank', 'icon': '🪙'},
    {'name': 'Kotak Mahindra Bank', 'icon': '💰'},
    {'name': 'IndusInd Bank', 'icon': '🏛'},
    {'name': 'Yes Bank', 'icon': '✅'},
    {'name': 'Bank of Baroda', 'icon': '🏪'},
    {'name': 'Punjab National Bank', 'icon': '🏢'},
    {'name': 'Canon Bank', 'icon': '🏛️'},
    {'name': 'Other Bank', 'icon': '📍'},
    {'name': 'Digital Wallet', 'icon': '📱'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kDefalutPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Select Your Primary Bank Account",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Choose your daily driver account",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: bankList.length,
              itemBuilder: (context, index) {
                final bank = bankList[index];
                final isSelected = selectedBank == bank['name'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedBank = bank['name'];
                    });
                    // Call the callback to update parent
                    widget.onBankSelected(bank['name'] ?? '');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? kMainColor : kLightGrey,
                        width: isSelected ? 3 : 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected ? kMainColor.withOpacity(0.1) : Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          bank['icon'] ?? '🏦',
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bank['name'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? kMainColor : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            // Custom bank input option
            if (selectedBank != 'Other Bank')
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kLightGrey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ExpansionTile(
                  title: const Text("Or Enter Custom Bank Name"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter your bank name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              selectedBank = value;
                            });
                            // Call the callback to update parent
                            widget.onBankSelected(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
