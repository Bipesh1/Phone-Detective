// Phone Detective - Route Definitions

import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/main_menu_screen.dart';
import '../screens/case_select_screen.dart';
import '../screens/phone_home_screen.dart';
import '../screens/messages_app_screen.dart';
import '../screens/conversation_screen.dart';
import '../screens/gallery_app_screen.dart';
import '../screens/photo_viewer_screen.dart';
import '../screens/contacts_app_screen.dart';
import '../screens/contact_detail_screen.dart';
import '../screens/notes_app_screen.dart';
import '../screens/note_detail_screen.dart';
import '../screens/call_log_screen.dart';
import '../screens/email_app_screen.dart';
import '../screens/settings_app_screen.dart';
import '../screens/detective_journal_screen.dart';
import '../screens/solution_screen.dart';
import '../screens/case_complete_screen.dart';
import '../screens/case_intro_screen.dart';
import '../screens/hacking_simulator_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String mainMenu = '/main-menu';
  static const String caseSelect = '/case-select';
  static const String phoneHome = '/phone-home';
  static const String messages = '/messages';
  static const String conversation = '/conversation';
  static const String gallery = '/gallery';
  static const String photoViewer = '/photo-viewer';
  static const String contacts = '/contacts';
  static const String contactDetail = '/contact-detail';
  static const String notes = '/notes';
  static const String noteDetail = '/note-detail';
  static const String callLog = '/call-log';
  static const String email = '/email';
  static const String settings = '/settings';
  static const String detectiveJournal = '/detective-journal';
  static const String solution = '/solution';
  static const String caseComplete = '/case-complete';
  static const String caseIntro = '/case-intro';
  static const String hackingSimulator = '/hacking-simulator';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildPageRoute(const SplashScreen(), settings);

      case mainMenu:
        return _buildPageRoute(const MainMenuScreen(), settings);

      case caseSelect:
        return _buildPageRoute(const CaseSelectScreen(), settings);

      case phoneHome:
        return _buildPageRoute(const PhoneHomeScreen(), settings);

      case messages:
        return _buildPageRoute(const MessagesAppScreen(), settings);

      case conversation:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildPageRoute(
          ConversationScreen(contactId: args?['contactId'] ?? ''),
          settings,
        );

      case gallery:
        return _buildPageRoute(const GalleryAppScreen(), settings);

      case photoViewer:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildPageRoute(
          PhotoViewerScreen(
            photoIndex: args?['photoIndex'] ?? 0,
            photoId: args?['photoId'] ?? '',
          ),
          settings,
        );

      case contacts:
        return _buildPageRoute(const ContactsAppScreen(), settings);

      case contactDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildPageRoute(
          ContactDetailScreen(contactId: args?['contactId'] ?? ''),
          settings,
        );

      case notes:
        return _buildPageRoute(const NotesAppScreen(), settings);

      case noteDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildPageRoute(
          NoteDetailScreen(noteId: args?['noteId'] ?? ''),
          settings,
        );

      case callLog:
        return _buildPageRoute(const CallLogScreen(), settings);

      case email:
        return _buildPageRoute(const EmailAppScreen(), settings);

      case AppRoutes.settings:
        return _buildPageRoute(const SettingsAppScreen(), settings);

      case detectiveJournal:
        return _buildPageRoute(const DetectiveJournalScreen(), settings);

      case solution:
        return _buildPageRoute(const SolutionScreen(), settings);

      case caseIntro:
        return _buildPageRoute(const CaseIntroScreen(), settings);

      case hackingSimulator:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildPageRoute(
          HackingSimulatorScreen(targetName: args?['targetName'] ?? 'DEVICE'),
          settings,
        );

      case caseComplete:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildPageRoute(
          CaseCompleteScreen(
            isCorrect: args?['isCorrect'] ?? false,
            timeTaken: args?['timeTaken'] ?? Duration.zero,
          ),
          settings,
        );

      default:
        return _buildPageRoute(const MainMenuScreen(), settings);
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.05);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var fadeTween = Tween(begin: 0.0, end: 1.0);

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
