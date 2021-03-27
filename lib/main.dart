import 'package:async/async.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hackeridiot/AppLocalizations.dart';
import 'package:hackeridiot/AppTheme.dart';
import 'package:hackeridiot/models/FontSizeModel.dart';
import 'package:hackeridiot/screens/SplashScreen.dart';
import 'package:hackeridiot/store/AppStore.dart';
import 'package:hackeridiot/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'models/LanguageModel.dart';
import 'models/WeatherResponse.dart';

AppStore appStore = AppStore();

int mAdShowCount = 0;

Language language;
List<Language> languages = Language.getLanguages();

FontSizeModel fontSize;
List<FontSizeModel> fontSizes = FontSizeModel.fontSizes();

Language ttsLang;
List<Language> ttsLanguage = Language.getLanguagesForTTS();

var weatherMemoizer = AsyncMemoizer<WeatherResponse>();

RemoteConfig remoteConfig;
int retryCount = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  defaultRadius = 20;
  defaultAppButtonRadius = 30;
  defaultBlurRadius = 4.0;

  await initialize();

  appStore.setLanguage(getStringAsync(LANGUAGE, defaultValue: defaultLanguage));
  appStore.setNotification(getBoolAsync(IS_NOTIFICATION_ON, defaultValue: true));
  appStore.setTTSLanguage(getStringAsync(TEXT_TO_SPEECH_LANG, defaultValue: defaultTTSLanguage));
  appStore.setCurrencyStoreModel();

  fontSize = fontSizes.firstWhere((element) => element.fontSize == getIntAsync(FONT_SIZE_PREF, defaultValue: 16));
  ttsLang = ttsLanguage.firstWhere((element) => element.fullLanguageCode == getStringAsync(TEXT_TO_SPEECH_LANG, defaultValue: defaultTTSLanguage));

  if (isMobile) {
    Firebase.initializeApp().then((value) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      MobileAds.instance.initialize();
    });

    await OneSignal.shared.init(
      mOneSignalAPPKey,
      iOSSettings: {OSiOSSettings.autoPrompt: false, OSiOSSettings.promptBeforeOpeningPushUrl: true, OSiOSSettings.inAppAlerts: false},
    );

    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setOrientationPortrait();

    return Observer(
      builder: (_) => MaterialApp(
        title: mAppName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        supportedLocales: Language.languagesLocale(),
        localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        locale: Locale(appStore.selectedLanguageCode),
        // locale: Locale(appStore.selectedLanguageCode),
        home: SplashScreen(),
        builder: scrollBehaviour(),
      ),
    );
  }
}