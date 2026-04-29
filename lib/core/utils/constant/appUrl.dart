class Appurl {
  static const bool isProduction = true;
  static const baseUrl = "https://sip-backend.londonstreetstore.com";

  static const baseUrl2 = 'https://mfapi.advisorkhoj.com';

  static const advUrl = 'https://mfapi.advisorkhoj.com';

  static const navUrl = 'https://api.mfapi.in/mf';

  // static const kycUrl = 'https://multi-channel-preproduction.signzy.tech';
  static const kycUrl = isProduction
      ? 'https://multi-channel.signzy.tech'
      : 'https://multi-channel-preproduction.signzy.tech';
}
