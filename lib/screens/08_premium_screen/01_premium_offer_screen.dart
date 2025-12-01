import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Wetieko/managers/subscription_manager.dart';
import 'package:Wetieko/core/theme/colors.dart';
import 'package:Wetieko/widgets/premium/premium_intro_section.dart';
import 'package:Wetieko/widgets/premium/premium_plan_options.dart';
import 'package:Wetieko/widgets/premium/premium_cta_section.dart';
import 'package:Wetieko/widgets/premium/premium_background_banner.dart';
import 'package:Wetieko/widgets/common/custom_alerts.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/10_privacy_policy_screen.dart';
import 'package:Wetieko/screens/05_profile_settings_screen/11_terms_use_screen.dart';

class PremiumOfferScreen extends StatefulWidget {
  const PremiumOfferScreen({super.key});

  @override
  State<PremiumOfferScreen> createState() => _PremiumOfferScreenState();
}

class _PremiumOfferScreenState extends State<PremiumOfferScreen> {
  final SubscriptionManager _manager = SubscriptionManager();

  String selectedPlan = 'yearly';
  bool showCloseButton = false;
  bool isProcessing = false;
  List<ProductDetails> _products = [];
  Timer? _closeTimer;

  @override
  void initState() {
    super.initState();
    _loadProductPrices();

    _closeTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => showCloseButton = true);
    });
  }

  Future<void> _loadProductPrices() async {
    try {
      final prods = await _manager.loadProducts();
      if (!mounted) return;
      setState(() => _products = prods);
    } catch (_) {}
  }

  void _onSubscriptionSuccess() {
    if (!mounted) return;
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    final locale = AppLocalizations.of(rootContext)!;

    Navigator.of(context, rootNavigator: true).pop();

    Future.delayed(const Duration(milliseconds: 400), () {
      CustomAlert.show(
        rootContext,
        title: "🎉 ${locale.premiumActivated}",
        description: locale.premiumEnjoy,
        icon: Icons.verified_rounded,
        confirmText: locale.ok,
        onConfirm: () {},
        forceRootOverlay: true,
      );
    });
  }

  ProductDetails? _getProduct(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _onSubscribePressed() async {
    if (!mounted) return;
    setState(() => isProcessing = true);

    try {
      await _manager.init(
        context: context,
        onProcessingStart: () {
          if (!mounted) return;
          setState(() => isProcessing = true);
        },
        onProcessingEnd: () {
          if (!mounted) return;
          setState(() => isProcessing = false);
        },
        onSuccess: _onSubscriptionSuccess,
      );

      final productId = selectedPlan == "yearly"
          ? "com.wetieko.premium.yearly"
          : "com.wetieko.premium.monthly";

      final product = _getProduct(productId);
      if (product == null) {
        if (mounted) setState(() => isProcessing = false);
        return;
      }

      await _manager.buySubscription(context: context, product: product);
    } catch (_) {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottomNavBackground,
      body: Stack(
        children: [
          const PremiumBackgroundBanner(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const PremiumIntroSection(),
                  const SizedBox(height: 20),
                  PremiumPlanOptions(
                    selectedValue: selectedPlan,
                    onChanged: (value) {
                      if (!mounted) return;
                      setState(() => selectedPlan = value);
                    },
                    yearlyProduct: _getProduct("com.wetieko.premium.yearly"),
                    monthlyProduct: _getProduct("com.wetieko.premium.monthly"),
                  ),
                  const SizedBox(height: 30),
                  PremiumCtaSection(
                    onSubscribe: isProcessing ? null : _onSubscribePressed,
                    onTerms: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TermsUseScreen(),
                        ),
                      );
                    },
                    onPrivacy: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                  onRestore: () async {
  if (!mounted) return;
  setState(() => isProcessing = true);

  final locale = AppLocalizations.of(context)!;
  final restored = await _manager.restorePurchases();

  if (!mounted) return;
  setState(() => isProcessing = false);

  if (restored) {
    Navigator.of(context, rootNavigator: true).pop();
    CustomAlert.show(
      context,
      title: locale.restoreSuccessTitle,
      description: locale.restoreSuccessDesc,
      icon: Icons.verified_rounded,
      confirmText: locale.ok,
      onConfirm: () {},
      forceRootOverlay: true,
    );
  } else {
    CustomAlert.show(
      context,
      title: locale.restoreNoPurchaseTitle,
      description: locale.restoreNoPurchaseDesc,
      icon: Icons.info_outline_rounded,
      confirmText: locale.ok,
      onConfirm: () {},
      forceRootOverlay: true,
    );
  }
},

                  ),
                  const SizedBox(height: 20),
                  if (isProcessing)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (showCloseButton)
            Positioned(
              top: 42,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context, rootNavigator: true).pop(),
                child: AnimatedOpacity(
                  opacity: showCloseButton ? 1 : 0,
                  duration: const Duration(milliseconds: 350),
                  child: const Icon(Icons.close, color: Colors.white70, size: 26),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
