import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/components/default_snack_bar.dart';
import 'package:movie_time/services/user_service.dart';
import 'package:movie_time/utilities/constants.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;

  _signIn() async {
    setState(() => isLoading = true);
    final response = await UserService().signIn();

    if (context.mounted) {
      if (response != null) {
        context.pushReplacement('/');
        DefaultSnackBar.show(
          context,
          'Signed in successfully!',
          backgroundColor: Colors.green,
        );
      } else {
        DefaultSnackBar.show(context, 'Sign in failed!');
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to\nMovie Time🍿',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: largeTitleFS,
                    fontWeight: bold,
                  ),
                ),
                Text(
                  'We give you the best recommendation movie and series.',
                  style: GoogleFonts.plusJakartaSans(
                    color: mutedColor,
                    fontSize: caption2FS,
                  ),
                ),
                SizedBox(height: defaultMargin * 10),
                Center(
                  child: Image.asset(
                    'assets/images/il_sign_in.png',
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: defaultMargin * 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _signIn(),
                    style: darkGreyButtonStyle,
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/ic_google.png',
                                width: 32,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: defaultMargin / 2),
                              Text(
                                'Sign In with Google',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: bodyFS,
                                  fontWeight: bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
