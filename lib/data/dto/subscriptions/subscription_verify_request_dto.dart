class SubscriptionVerifyRequestDto {
  final int platform;              // 0 = Apple, 1 = Google (muhtemelen)
  final int plan;                  // backend enum karşılığı
  final String providerProductId;  
  final String purchaseToken;      
  final String receipt;            // Apple için receipt, Google için boş olabilir

  SubscriptionVerifyRequestDto({
    required this.platform,
    required this.plan,
    required this.providerProductId,
    required this.purchaseToken,
    required this.receipt,
  });

  Map<String, dynamic> toJson() {
    return {
      "platform": platform,
      "plan": plan,
      "providerProductId": providerProductId,
      "purchaseToken": purchaseToken,
      "receipt": receipt,
    };
  }
}
