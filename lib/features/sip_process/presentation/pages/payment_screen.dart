import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';
import 'package:my_sip/common/widget/button/elevated_button.dart';
import 'package:my_sip/common/widget/text/small_heading.dart';
import 'package:my_sip/common/widget/text_form/text_form_field.dart';
import 'package:my_sip/config/routes/app_routes.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/authentication/presentation/widgets/term_policy.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';
import 'package:my_sip/features/cart/presentation/pages/cart_page.dart';
import 'package:my_sip/features/fund_details/presentation/pages/fund_deatails.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});

  CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments as Map<String, dynamic>?;
    final amount = arg?['amount'] ?? 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBarNormal(title: 'Payment'),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: UTextStyles.small.copyWith(color: Color(0xff333333)),
            ),
            Gap(25),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Ucolors.light,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardMethod(
                    title: 'HDFC Bank',
                    icon: Icons.credit_card,
                    subtitle: '501008305749560',
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Choose App'),
                      Row(
                        children: [
                          paymentMethod(icon: UImages.gpat),
                          paymentMethod(icon: UImages.paytm),
                          paymentMethod(icon: UImages.phonepe),
                          paymentMethod(icon: UImages.amazon),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DashedLine(
                              color: Colors.black,
                              dashSpace: 0,
                            ),
                          ),
                          Gap(5),
                          Text('Or'),
                          Gap(5),
                          Expanded(
                            child: DashedLine(
                              color: Colors.black,
                              dashSpace: 0,
                            ),
                          ),
                        ],
                      ),
                      Gap(10),

                      const SmallHeading(
                        smallheading: 'Enter UPI ID',
                        color: Ucolors.dark,
                        fontWeight: FontWeight.w600,
                      ),
                      Gap(10),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: UTextFormField(
                              prefixIcon: null,
                              hintText: 'Name',
                            ),
                          ),
                          Gap(10),
                          Expanded(
                            child: UElevatedBUtton(
                              color: Ucolors.darkgrey,
                              width: 40,
                              height: 52,
                              child: Center(
                                child: Text(
                                  'Verify',
                                  style: UTextStyles.buttonText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(10),
                    ],
                  ),
                ],
              ),
            ),
            Gap(16),
            Card(
              color: Colors.white,
              child: CardMethod(
                title: 'Debit / Credit Card',
                icon: Icons.credit_card,
              ),
            ),
            Gap(5),
            Card(
              color: Colors.white,
              child: CardMethod(title: 'Net Banking', icon: Icons.home),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        TermAndPolicy(term: 'By Proceeding, I accept the '),
      ],
      persistentFooterDecoration: BoxDecoration(color: Colors.transparent),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CartBottomBar(
          amount: cartController.totalAmount.toString(),
          title: 'Amount Payable',
          ontap: () {},
          // ontap: () => Get.toNamed(
          //   AppRoutes.successfullcreategoal,
          //   arguments: {
          //     'title': 'Congratulations',
          //     'subtitle':
          //         'Lorem Ipsum is simply dummy text of the printing and',
          //     'textButton': 'Go to Goal section',
          //     'nextroute': AppRoutes.goalviewcard,
          //   },
          // ),
        ),
      ),
    );
  }
}

class CardMethod extends StatelessWidget {
  const CardMethod({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,

      // isThreeLine: true,
      leading: Icon(icon, size: 30),
      title: Text(
        title,
        style: UTextStyles.medium.copyWith(
          fontWeight: FontWeight.w600,
          color: Ucolors.dark,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: UTextStyles.small)
          : null,
      // subtitle: ,
      trailing: CircleAvatar(
        backgroundColor: Ucolors.primary.withOpacity(0.1),
        maxRadius: 15,
        child: Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}

class paymentMethod extends StatelessWidget {
  const paymentMethod({super.key, required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),

      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Ucolors.borderColor),
      ),
      child: SizedBox(height: 40, width: 40, child: Image.asset(icon)),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_sip/features/cart/presentation/controllers/cart_controller.dart';

/// ─────────────────────────────────────────────
///  Modern Payment Screen  –  Drop-in replacement
///  No external dependencies beyond Flutter SDK.
///  Replace asset paths (UImages.*) with your own.
/// ─────────────────────────────────────────────

// ─── Palette ──────────────────────────────────
class _C {
  static const bg = Color(0xFFF4F6FB);
  static const card = Colors.white;
  static const primary = Color(0xFF1A3C6E); // deep navy
  static const accent = Color(0xFF2563EB); // vivid blue
  static const accentLight = Color(0xFFEFF4FF);
  static const success = Color(0xFF16A34A);
  static const text = Color(0xFF111827);
  static const muted = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const gradA = Color(0xFF1E3A8A);
  static const gradB = Color(0xFF2563EB);
}

// ─── Payment Screen ───────────────────────────
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  // Which top-level method is selected: 'upi' | 'card' | 'netbanking'
  String _selectedMethod = 'upi';

  // Which UPI app icon is highlighted
  String? _selectedApp;

  // UPI text field controller
  final _upiCtrl = TextEditingController();
  bool _upiVerified = false;
  bool _upiVerifying = false;

  // Card fields
  final _cardNum = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  final _cardName = TextEditingController();

  // Netbanking
  String? _selectedBank;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _upiCtrl.dispose();
    _cardNum.dispose();
    _expiry.dispose();
    _cvv.dispose();
    _cardName.dispose();
    super.dispose();
  }

  void _onMethodTap(String method) {
    if (_selectedMethod == method) return;
    setState(() => _selectedMethod = method);
    _fadeCtrl
      ..reset()
      ..forward();
  }

  Future<void> _verifyUpi() async {
    if (_upiCtrl.text.isEmpty) return;
    setState(() {
      _upiVerifying = true;
      _upiVerified = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _upiVerifying = false;
      _upiVerified = true;
    });
  }

  void _onPurchase() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _C.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Payment initiated!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments as Map<String, dynamic>?;
    final amount1 = arg?['amount'] ?? 0;
    final controller = Get.find<CartController>();
    final amount = controller.totalAmount;
    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(
        children: [
          _Header(amount: amount),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                children: [
                  _MethodSelector(
                    selected: _selectedMethod,
                    onTap: _onMethodTap,
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(opacity: _fadeAnim, child: _buildPanel()),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _BottomBar(amount: amount, onPurchase: _onPurchase),
    );
  }

  Widget _buildPanel() {
    switch (_selectedMethod) {
      case 'upi':
        return _UpiPanel(
          selectedApp: _selectedApp,
          onAppTap: (app) => setState(() => _selectedApp = app),
          upiCtrl: _upiCtrl,
          verifying: _upiVerifying,
          verified: _upiVerified,
          onVerify: _verifyUpi,
        );
      case 'card':
        return _CardPanel(
          cardNum: _cardNum,
          expiry: _expiry,
          cvv: _cvv,
          cardName: _cardName,
        );
      case 'netbanking':
        return _NetBankingPanel(
          selected: _selectedBank,
          onSelect: (b) => setState(() => _selectedBank = b),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── Gradient Header ──────────────────────────
class _Header extends StatelessWidget {
  final int amount;
  const _Header({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_C.gradA, _C.gradB],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Payment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Amount to Pay',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${_fmt(amount)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.white70,
                            size: 14,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Secure',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(int n) {
    final s = n.toString();
    if (s.length <= 3) return s;
    final last3 = s.substring(s.length - 3);
    final rest = s.substring(0, s.length - 3);
    return '${rest.replaceAllMapped(RegExp(r'(\d{2})(?=\d)'), (m) => '${m[1]},')},$last3';
  }
}

// ─── Method Selector Tabs ─────────────────────
class _MethodSelector extends StatelessWidget {
  final String selected;
  final void Function(String) onTap;
  const _MethodSelector({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const methods = [
      ('upi', Icons.phone_android_rounded, 'UPI'),
      ('card', Icons.credit_card_rounded, 'Card'),
      ('netbanking', Icons.account_balance_rounded, 'Net Banking'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: methods.map((m) {
          final isSelected = selected == m.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(m.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? _C.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      m.$2,
                      color: isSelected ? Colors.white : _C.muted,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m.$3,
                      style: TextStyle(
                        color: isSelected ? Colors.white : _C.muted,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── UPI Panel ────────────────────────────────
class _UpiPanel extends StatelessWidget {
  final String? selectedApp;
  final void Function(String) onAppTap;
  final TextEditingController upiCtrl;
  final bool verifying;
  final bool verified;
  final VoidCallback onVerify;

  const _UpiPanel({
    required this.selectedApp,
    required this.onAppTap,
    required this.upiCtrl,
    required this.verifying,
    required this.verified,
    required this.onVerify,
  });

  // Replace these with your actual asset paths
  static const _apps = [
    ('gpay', 'G', Color(0xFF4285F4), 'Google Pay'),
    ('paytm', 'P', Color(0xFF00BAF2), 'Paytm'),
    ('phonepe', 'φ', Color(0xFF5F259F), 'PhonePe'),
    ('amazon', 'a', Color(0xFFFF9900), 'Amazon Pay'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Saved bank account
        _SectionCard(
          child: Column(
            children: [
              _BankTile(
                bankName: 'HDFC Bank',
                accountNumber: '501008305749560',
                isDefault: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // UPI Apps
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionLabel(label: 'Pay via UPI App'),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _apps.map((app) {
                  final isSelected = selectedApp == app.$1;
                  return GestureDetector(
                    onTap: () => onAppTap(app.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 72,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _C.accentLight
                            : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? _C.accent : _C.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: app.$3,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              app.$2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            app.$4,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? _C.accent : _C.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: _C.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or enter UPI ID',
                      style: TextStyle(
                        color: _C.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: _C.border)),
                ],
              ),
              const SizedBox(height: 16),

              // UPI ID field
              Row(
                children: [
                  Expanded(
                    child: _StyledTextField(
                      controller: upiCtrl,
                      hint: 'yourname@upi',
                      suffix: verified
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: _C.success,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _PrimaryButton(
                    label: 'Verify',
                    loading: verifying,
                    width: 90,
                    height: 52,
                    onTap: onVerify,
                  ),
                ],
              ),
              if (verified)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: _C.success,
                        size: 14,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'UPI ID verified successfully',
                        style: TextStyle(
                          color: _C.success,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Card Panel ───────────────────────────────
class _CardPanel extends StatelessWidget {
  final TextEditingController cardNum, expiry, cvv, cardName;
  const _CardPanel({
    required this.cardNum,
    required this.expiry,
    required this.cvv,
    required this.cardName,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(label: 'Debit / Credit Card'),
          const SizedBox(height: 16),

          // Mini card preview
          Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_C.gradA, _C.gradB],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.credit_card_rounded,
                      color: Colors.white70,
                      size: 28,
                    ),
                    ValueListenableBuilder(
                      valueListenable: cardNum,
                      builder: (_, val, __) {
                        final raw = val.text.replaceAll(' ', '');
                        final masked = raw.isEmpty
                            ? '•••• •••• •••• ••••'
                            : _formatCard(raw);
                        return Text(
                          masked,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.blur_circular_rounded,
                      color: Colors.white54,
                      size: 36,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _StyledTextField(
            controller: cardName,
            hint: 'Name on Card',
            label: 'Cardholder Name',
            prefixIcon: Icons.person_outline_rounded,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          _StyledTextField(
            controller: cardNum,
            hint: '0000 0000 0000 0000',
            label: 'Card Number',
            prefixIcon: Icons.credit_card_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberFormatter(),
            ],
            maxLength: 19,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StyledTextField(
                  controller: expiry,
                  hint: 'MM / YY',
                  label: 'Expiry',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ExpiryFormatter(),
                  ],
                  maxLength: 5,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StyledTextField(
                  controller: cvv,
                  hint: '•••',
                  label: 'CVV',
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  static String _formatCard(String raw) {
    final parts = <String>[];
    for (var i = 0; i < raw.length && i < 16; i += 4) {
      parts.add(raw.substring(i, (i + 4).clamp(0, raw.length)));
    }
    final display = parts.join(' ');
    if (raw.length < 16) {
      return display + ' ' + '•' * (16 - raw.length);
    }
    return display;
  }
}

// ─── Net Banking Panel ────────────────────────
class _NetBankingPanel extends StatelessWidget {
  final String? selected;
  final void Function(String) onSelect;
  const _NetBankingPanel({required this.selected, required this.onSelect});

  static const _banks = [
    ('hdfc', 'HDFC Bank', Color(0xFF004C97)),
    ('sbi', 'SBI', Color(0xFF2C4FA3)),
    ('icici', 'ICICI Bank', Color(0xFFB5200D)),
    ('axis', 'Axis Bank', Color(0xFF97144D)),
    ('kotak', 'Kotak Bank', Color(0xFFEA2127)),
    ('pnb', 'PNB', Color(0xFF00529B)),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(label: 'Net Banking'),
          const SizedBox(height: 4),
          Text(
            'Select your bank to continue',
            style: TextStyle(
              color: _C.muted,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 14),
          ..._banks.map((bank) {
            final isSelected = selected == bank.$1;
            return GestureDetector(
              onTap: () => onSelect(bank.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? _C.accentLight : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? _C.accent : _C.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: bank.$3,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        bank.$2[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        bank.$2,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isSelected ? _C.accent : _C.text,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? _C.accent : _C.border,
                          width: isSelected ? 5 : 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: _C.text,
        letterSpacing: 0.1,
      ),
    );
  }
}

class _BankTile extends StatelessWidget {
  final String bankName, accountNumber;
  final bool isDefault;
  const _BankTile({
    required this.bankName,
    required this.accountNumber,
    this.isDefault = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.accentLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _C.accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: _C.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '•••• •••• ${accountNumber.substring(accountNumber.length - 4)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: _C.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _C.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Default',
                style: TextStyle(
                  color: _C.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextCapitalization textCapitalization;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.label,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _C.muted,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          style: const TextStyle(
            fontSize: 14,
            color: _C.text,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 14),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: _C.muted, size: 18)
                : null,
            suffixIcon: suffix,
            counterText: '',
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _C.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _C.accent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;
  final double width, height;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.loading = false,
    this.width = double.infinity,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: loading
              ? null
              : const LinearGradient(
                  colors: [_C.gradA, _C.gradB],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: loading ? _C.border : null,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

// ─── Bottom Bar ───────────────────────────────
class _BottomBar extends StatelessWidget {
  final int amount;
  final VoidCallback onPurchase;
  const _BottomBar({required this.amount, required this.onPurchase});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // T&C
          Text.rich(
            TextSpan(
              text: 'By proceeding, I accept the ',
              style: const TextStyle(
                color: _C.muted,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: 'Terms of Use',
                  style: const TextStyle(
                    color: _C.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(
                    color: _C.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amount Payable',
                    style: TextStyle(
                      color: _C.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹$amount',
                    style: const TextStyle(
                      color: _C.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: GestureDetector(
                  onTap: onPurchase,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_C.gradA, _C.gradB],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _C.accent.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Pay Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Input Formatters ─────────────────────────
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return TextEditingValue(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    if (digits.length >= 3) {
      final str = '${digits.substring(0, 2)}/${digits.substring(2)}';
      return TextEditingValue(
        text: str,
        selection: TextSelection.collapsed(offset: str.length),
      );
    }
    return newValue;
  }
}
*/