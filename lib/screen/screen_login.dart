import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mandiri/colors/colors.dart';
import 'package:flutter_mandiri/style_and_transition/style/style_font_size.dart';
import 'package:flutter_mandiri/firebase_options.dart';
import 'package:flutter_mandiri/screen/screen_main_menu.dart';
import 'package:flutter_mandiri/screen/screen_signup.dart';
import 'package:flutter_mandiri/style_and_transition/transition_navigator/transition_UpDown.dart';
import 'package:flutter_mandiri/widget/widget_snack_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: ScreenLogin(), debugShowCheckedModeBanner: false));
}

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _MainAppState();
}

class _MainAppState extends State<ScreenLogin> {
  bool _obscurePassword = false;
  double? _logoTopPosition;
  bool showForm = false;
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    passcontroller.dispose();
    super.dispose();
  }

  Future<void> loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login Berhasil')));
      });
    } on FirebaseAuthException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login Gagal: ${e.message ?? 'Koneksi tidak Stabil!'}',
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _logoTopPosition = 0;

        Future.delayed(Duration(milliseconds: 2000), () {
          setState(() {
            _logoTopPosition = -150;
          });
        });

        Future.delayed(Duration(milliseconds: 2800), () {
          setState(() {
            showForm = true;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return
    // StreamBuilder<User?>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       WidgetsBinding.instance.addPostFrameCallback((_) {
    //         Nav_slide_up_down_transition(context, MainMenu(), true);
    //       }
    //       );
    //       return SizedBox();
    //     } else {
    return _login();
    //     }
    //   },
    // );
  }

  Widget _login() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (_logoTopPosition != null)
            Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 800),
                transform: Matrix4.translationValues(0, _logoTopPosition!, 0),
                curve: Curves.easeOut,
                child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: showForm ? 1.0 : 0.0,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 35,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 220),
                                Text('Aplikasi Biji', style: titleTextStyle),
                                const SizedBox(height: 10),
                                Material(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  elevation: 2,
                                  shadowColor: Colors.black,
                                  child: TextField(
                                    controller: emailcontroller,
                                    decoration: InputDecoration(
                                      labelText: 'Username:',
                                      labelStyle: labelTextStyle,
                                      hintText: 'Username...',
                                      hintStyle: hintTextStyle,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Material(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      elevation: 2,
                                      shadowColor: Colors.black,
                                      child: TextField(
                                        controller: passcontroller,
                                        obscureText: _obscurePassword,
                                        decoration: InputDecoration(
                                          labelText: 'Password:',
                                          labelStyle: labelTextStyle,
                                          hintText: 'Password...',
                                          hintStyle: hintTextStyle,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(100),
                                            ),
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primary,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 10,
                                    ),
                                    shadowColor: Colors.black,
                                    elevation: 10,
                                  ),
                                  onPressed: () {
                                    FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                          email: "demo@gmail.com",
                                          password: "12345678",
                                        )
                                        .then((userCredential) async {
                                          String uid = userCredential.user!.uid;
                                          SharedPreferences pref =
                                              await SharedPreferences.getInstance();
                                          await pref.setString('uid_user', uid);
                                          if (!mounted) return;
                                          navUpDownTransition(
                                            context,
                                            ScreenMainMenu(),
                                            true,
                                          );
                                        })
                                        .catchError((error) {
                                          if (!mounted) return;
                                          customSnackBar(
                                            context,
                                            "Login Gagal: $error",
                                          );
                                        });
                                  },
                                  child: Text('Login', style: buttonTextStyle),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primary,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 10,
                                    ),
                                    shadowColor: Colors.black,
                                    elevation: 10,
                                  ),
                                  onPressed: () {
                                    navUpDownTransition(
                                      context,
                                      ScreenSignup(),
                                      false,
                                    );
                                  },
                                  child: Text(
                                    'Sign-Up',
                                    style: buttonTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
