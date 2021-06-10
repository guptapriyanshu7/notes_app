import 'package:auto_route/annotations.dart';
import 'package:notes_app/presentation/auth/sign_in_page.dart';
import 'package:notes_app/presentation/splash/splash_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: SignInPage),
  ],
)
class $Router {}
