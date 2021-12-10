import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:whenmeet/service/auth_service.dart';
import 'package:whenmeet/service/camera_flow.dart';
import 'package:whenmeet/view/login_page.dart';
import 'package:whenmeet/view/sign_up_page.dart';
import 'package:whenmeet/view/verification_page.dart';
import 'package:whenmeet/amplifyconfiguration.dart';




void main() {
  runApp(MyApp());
}

// 1
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.showLogin();
    _configureAmplify();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery App',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      // 2
      home: StreamBuilder<AuthState>(
        // 2
          stream: _authService.authStateController.stream,
          builder: (context, snapshot) {
            // 3
            if (snapshot.hasData) {
              return Navigator(
                pages: [
                  // 4
                  // Show Login Page
                  if (snapshot.data?.authFlowStatus == AuthFlowStatus.login)
                    MaterialPage(child: LoginPage(
                        didProvideCredentials: _authService.loginWithCredentials,
                        shouldShowSignUp: _authService.showSignUp
                    )),
                  // 5
                  // Show Sign Up Page
                  if (snapshot.data?.authFlowStatus == AuthFlowStatus.signUp)
                    MaterialPage(child: SignUpPage(
                        didProvideCredentials: _authService.signUpWithCredentials,
                        shouldShowLogin: _authService.showLogin
                    )),
                  if (snapshot.data?.authFlowStatus == AuthFlowStatus.verification)
                    MaterialPage(child: VerificationPage(
                        didProvideVerificationCode: _authService.verifyCode)),
                  if (snapshot.data?.authFlowStatus == AuthFlowStatus.session)
                    MaterialPage(
                        child: CameraFlow(shouldLogOut: _authService.logOut))
                ],
                onPopPage: (route, result) => route.didPop(result),
              );
            } else {
              // 6
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
          }),
      );
  }

  void _configureAmplify() async {
    try {
      await Amplify.configure(amplifyconfig);
      print('Successfully configured Amplify 🎉');
    } catch (e) {
      print('Could not configure Amplify ☠️');
    }
  }
}