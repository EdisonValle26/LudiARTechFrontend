import 'package:LudiArtech/pages/activityCenter/activity_center_screen.dart';
import 'package:LudiArtech/pages/configuration/configuration_screen.dart';
import 'package:LudiArtech/pages/forgetPassword/forget_password_screen.dart';
import 'package:LudiArtech/pages/games/sliding_puzzle/sliding_puzzle_screen.dart';
import 'package:LudiArtech/pages/home/home_screen.dart';
import 'package:LudiArtech/pages/learningPaths/learning_paths_screen.dart';
import 'package:LudiArtech/pages/onboarding/onboarding_screen.dart';
import 'package:LudiArtech/pages/personalInfo/personal_info_screen.dart';
import 'package:LudiArtech/pages/privacyPolicy/privacy_policy_screen.dart';
import 'package:LudiArtech/pages/privacySecutity/privacy_security_screen.dart';
import 'package:LudiArtech/pages/profile/profile_screen.dart';
import 'package:LudiArtech/pages/progress/progress_screen.dart';
import 'package:LudiArtech/pages/ranking/ranking_screen.dart';
import 'package:LudiArtech/pages/recoverPassword/recover_password_screen.dart';
import 'package:LudiArtech/pages/register/register_screen.dart';
import 'package:LudiArtech/pages/support/support_screen.dart';
import 'package:LudiArtech/pages/termsConditions/terms_conditions_screen.dart';
import 'package:LudiArtech/pages/videoLibrary/video_library_screen.dart';
import 'package:flutter/material.dart';

import '../pages/login/login_screen.dart';
import '../pages/welcome/welcome_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String configuration = '/configuration';
  static const String progress = '/progress';
  static const String videoLibrary = '/video_library';
  static const String activityCenter = '/activity_center';
  static const String learningPaths = '/learning_paths';
  static const String ranking = '/ranking';
  static const String personalInfo = '/personalInfo';
  static const String privacySecurity = '/privacySecurity';
  static const String support = '/support';
  static const String termsConditions = '/termsConditions';
  static const String privacyPolicy = '/privacyPolicy';
  static const String forgetPassword = '/forgetPassword';
  static const String recoverPassword = '/recoverPassword';
  static const String slidingPuzzle = '/slidingPuzzle';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case configuration:
        return MaterialPageRoute(builder: (_) => const ConfigurationScreen());
      case progress:
        return MaterialPageRoute(builder: (_) => const ProgressScreen());
      case videoLibrary:
        return MaterialPageRoute(builder: (_) => const VideoLibraryScreen());
      case activityCenter:
        return MaterialPageRoute(builder: (_) => const ActivityCenterScreen());
      case learningPaths:
        return MaterialPageRoute(builder: (_) => const LearnignPathsScreen());
      case ranking:
        return MaterialPageRoute(builder: (_) => const RankingScreen());
      case personalInfo:
        return MaterialPageRoute(builder: (_) => const PersonalInfoScreen());
      case privacySecurity:
        return MaterialPageRoute(builder: (_) => const PrivacySecurityScreen());
      case support:
        return MaterialPageRoute(builder: (_) => const SupportScreen());
      case termsConditions:
        return MaterialPageRoute(builder: (_) => const TermsConditionsScreen());
      case privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordFormScreen());
      case recoverPassword:
        return MaterialPageRoute(builder: (_) => const RecoverPasswordScreen());
      case slidingPuzzle:
        return MaterialPageRoute(builder: (_) => const SlidingPuzzleScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
