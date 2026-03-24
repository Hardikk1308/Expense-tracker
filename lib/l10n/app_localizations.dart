import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const _localizedValues = {
    'en': {
      'app_title': 'Expense Tracker',
      'dashboard': 'Dashboard',
      'analytics': 'Analytics',
      'settings': 'Settings',
      'add_expense': 'Add Expense',
      'total_budget': 'TOTAL BUDGET',
      'spent': 'SPENT',
      'balance': 'BALANCE',
      'recent_transactions': 'RECENT TRANSACTIONS',
      'set_budget': 'Set Monthly Budget',
      'update_budget': 'Update Budget',
      'amount': 'AMOUNT',
      'category': 'CATEGORY',
      'description': 'DESCRIPTION',
      'date': 'DATE',
      'confirm': 'Confirm Transaction',
      'empty_dashboard': 'Your dashboard is empty.',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'system_default': 'System Default',
      'theme': 'Appearance',
      'logout': 'Sign Out',
      'finance': 'FINANCE & ACCOUNT',
      'app_prefs': 'APP PREFERENCES',
      'support': 'SUPPORT',
    },
    'hi': {
      'app_title': 'व्यय ट्रैकर',
      'dashboard': 'डैशबोर्ड',
      'analytics': 'एनालिटिक्स',
      'settings': 'सेटिंग्स',
      'add_expense': 'खर्च जोड़ें',
      'total_budget': 'कुल बजट',
      'spent': 'खर्च किया',
      'balance': 'शेष राशि',
      'recent_transactions': 'हाल के लेन-देन',
      'set_budget': 'मासिक बजट सेट करें',
      'update_budget': 'बजट अपडेट करें',
      'amount': 'राशि',
      'category': 'श्रेणी',
      'description': 'विवरण',
      'date': 'तारीख',
      'confirm': 'लेन-देन की पुष्टि करें',
      'empty_dashboard': 'आपका डैशबोर्ड खाली है।',
      'language': 'भाषा',
      'dark_mode': 'डार्क मोड',
      'system_default': 'सिस्टम डिफॉल्ट',
      'theme': 'दिखावट',
      'logout': 'साइन आउट',
      'finance': 'वित्त और खाता',
      'app_prefs': 'ऐप प्राथमिकताएं',
      'support': 'सहायता',
    },
    'mr': {
      'app_title': 'खर्च मागोवा',
      'dashboard': 'डॅशबोर्ड',
      'analytics': 'विश्लेषण',
      'settings': 'सेटिंग्ज',
      'add_expense': 'खर्च जोडा',
      'total_budget': 'एकूण बजेट',
      'spent': 'खर्च केले',
      'balance': 'शिल्लक',
      'recent_transactions': 'अलीकडील व्यवहार',
      'set_budget': 'मासिक बजेट सेट करा',
      'update_budget': 'बजेट अपडेट करा',
      'amount': 'रक्कम',
      'category': 'वर्ग',
      'description': 'वर्णन',
      'date': 'तारीख',
      'confirm': 'व्यवहाराची खात्री करा',
      'empty_dashboard': 'तुमचा डॅशबोर्ड रिकामा आहे.',
      'language': 'भाषा',
      'dark_mode': 'डार्क मोड',
      'system_default': 'सिस्टम डीफॉल्ट',
      'theme': 'स्वरूप',
      'logout': 'बाहेर पडा',
      'finance': 'वित्त आणि खाते',
      'app_prefs': 'अ‍ॅप प्राधान्ये',
      'support': 'आधार',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
