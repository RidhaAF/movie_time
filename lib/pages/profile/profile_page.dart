import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_time/components/default_snack_bar.dart';
import 'package:movie_time/components/poster_card.dart';
import 'package:movie_time/components/shimmer_loading.dart';
import 'package:movie_time/cubit/user/user_cubit.dart';
import 'package:movie_time/services/user_service.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:movie_time/utilities/functions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GetStorage box = GetStorage();
  bool _isDarkMode = false;

  _getUser() {
    context.read<UserCubit>().getUser();
  }

  _signOut() async {
    await UserService().signOut();

    if (context.mounted) {
      context.pushReplacement('/sign-in');
      DefaultSnackBar.show(
        context,
        'Signed out successfully!',
        backgroundColor: Colors.green,
      );
    } else {
      DefaultSnackBar.show(context, 'Sign out failed!');
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      _getUser();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _isDarkMode = isDarkMode(context);
    return Scaffold(
      appBar: appBar(
        title: 'Profile',
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(defaultMargin),
              child: Column(
                children: [
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      if (state is UserInitial) {
                        return Container();
                      } else if (state is UserLoading) {
                        return userProfileShimmer(context);
                      } else if (state is UserLoaded) {
                        User? user = state.user;

                        return _profileList(
                          user.displayName ?? 'John Doe',
                          subtitle: user.email ?? 'johndoe@mail.com',
                          leading: CachedNetworkImage(
                            imageUrl: user.photoURL ?? '',
                            imageBuilder: (context, imageProvider) =>
                                PosterCard(
                              width: 48,
                              height: 48,
                              image: imageProvider,
                              isBorderRadius: false,
                              isShapeCircle: true,
                            ),
                            placeholder: (context, url) => SizedBox(
                              width: 48,
                              height: 48,
                              child: castProfilePhotoShimmer(context),
                            ),
                            errorWidget: (context, url, error) =>
                                const PosterCard(
                              width: 48,
                              height: 48,
                              isBorderRadius: false,
                              isShapeCircle: true,
                            ),
                            useOldImageOnUrlChange: true,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(height: defaultMargin),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode(context) ? bgColorDark3 : bgColorLight2,
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.nights_stay_rounded,
                        color: yellowColor,
                      ),
                      title: Text(
                        'Dark Mode',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: calloutFS,
                        ),
                      ),
                      trailing: Switch.adaptive(
                        value: _isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            _isDarkMode = !_isDarkMode;
                            box.write('isDarkMode', isDarkMode);
                            if (_isDarkMode) {
                              AdaptiveTheme.of(context).setDark();
                            } else {
                              AdaptiveTheme.of(context).setLight();
                            }
                          });
                        },
                        activeColor: Platform.isAndroid ? primaryColor : null,
                      ),
                    ),
                  ),
                  SizedBox(height: defaultMargin * 5),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _signOut(),
                      style: primaryButtonStyle,
                      child: Text(
                        'Sign Out',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: bodyFS,
                          fontWeight: bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileList(
    String title, {
    String? subtitle,
    Widget? leading,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode(context) ? bgColorDark3 : bgColorLight2,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: headlineFS,
            fontWeight: semiBold,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: footnoteFS,
                ),
              )
            : Container(),
        trailing: trailing,
      ),
    );
  }
}
