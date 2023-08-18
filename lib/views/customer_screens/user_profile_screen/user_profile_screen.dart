import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sterling/services/services.dart';
import 'package:sterling/view_models/user_view.dart';
import 'package:sterling/views/common_screens/update_email_screen/update_email_screen.dart';
import 'package:sterling/views/common_screens/update_phone_number/update_phone_number.dart';
import 'package:sterling/views/global_utils/back_button.dart';
import 'package:sterling/views/global_utils/delete_user_dialog.dart';

import '../../common_screens/login_screen/login_screen.dart';
import '../../global_utils/logout_alert.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen(this.cancelTimer,
      // this.user,
      {super.key});

  // final User user;
  var cancelTimer;
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String imageUrl = '';

  pickImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {}
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserView>(context);
    var user = userProvider.user;
    imageUrl = userProvider.imageUrl;
    var email = Provider.of<UserView>(context).email;
    return Scaffold(
        backgroundColor: const Color(0xfff3f3f3),
        body: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/profdeg.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: BackButtonWidget(),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 130,
                  ),
                  InkWell(
                    onTap: () async {
                      var image = await pickImage();
                      userProvider.uploadImage(image);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 62,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundColor: Colors.indigo,
                            radius: 60,
                            backgroundImage: AssetImage(
                              'assets/images/bitmoji.png',
                            ),
                            child: imageUrl == ''
                                ? Container()
                                : Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      image: DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: -7,
                            child: imageUrl == ''
                                ? Icon(Icons.add_circle_rounded,
                                    color: Colors.black)
                                : Container()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email.toString() == 'null' ? '' : email.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => UpdatePhoneNumberScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 250,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.phone_outlined, size: 30),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Update Phone Number',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => UpdateEmailScreen(user.userId),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 250,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.email_outlined, size: 30),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Update Email ID',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return LogoutAlert(widget.cancelTimer);
                          });
                    },
                    child: Container(
                      height: 50,
                      width: 250,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            return DeleteUserAlert(user, widget.cancelTimer);
                          });
                    },
                    child: Container(
                      height: 50,
                      width: 250,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Delete Account',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ));
  }
}
