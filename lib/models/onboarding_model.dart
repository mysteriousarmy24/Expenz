class Onboarding {
  final String imagePath;
  final String description;
  final String title;

  Onboarding({required this.imagePath, required this.description, required this.title});
}

class OnboardingData {
  final String? primaryBankAccount;
  final double? startingBalance;
  final DateTime? onboardingDate;

  OnboardingData({
    this.primaryBankAccount,
    this.startingBalance,
    this.onboardingDate,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'primaryBankAccount': primaryBankAccount,
      'startingBalance': startingBalance,
      'onboardingDate': onboardingDate?.toIso8601String(),
    };
  }

  // Create from JSON
  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      primaryBankAccount: json['primaryBankAccount'] as String?,
      startingBalance: json['startingBalance'] as double?,
      onboardingDate: json['onboardingDate'] != null
          ? DateTime.parse(json['onboardingDate'] as String)
          : null,
    );
  }
}