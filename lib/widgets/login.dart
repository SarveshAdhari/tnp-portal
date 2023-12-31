// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tnp_portal/providers/user_provider.dart';

import 'package:tnp_portal/widgets/custom_text_field.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key, required this.onToggle, required this.onLogin});

  final void Function() onToggle;
  final void Function(String email) onLogin;

  @override
  ConsumerState<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends ConsumerState<Login> {
  final url =
      Uri.https('tnp-portal-2023-default-rtdb.firebaseio.com', 'register.json');
  final emailHandler = TextEditingController();
  final passHandler = TextEditingController();

  void _setuserDetails() async {
    Map<dynamic, dynamic> user = ref.watch(userProvider);

    final url = Uri.https(
        'tnp-portal-2023-default-rtdb.firebaseio.com', 'register.json');
    final getResponse = await http.get(url);
    final Map allData = json.decode(getResponse.body);

    for (final i in allData.entries) {
      if (user['email'] == i.value['email'] && i.value['isRestricted']=='false') {
        user['name'] = i.value['name'];
        user['dob'] = i.value['dob'];
        user['gender'] = i.value['gender'];
        user['ssc'] = i.value['ssc'];
        user['ssc_year'] = i.value['ssc_year'];
        user['hsc'] = i.value['hsc'];
        user['hsc_year'] = i.value['hsc_year'];
        user['grad'] = i.value['grad'];
        user['grad_year'] = i.value['grad_year'];
        user['sem1'] = i.value['sem1'];
        user['sem2'] = i.value['sem2'];
        user['sem3'] = i.value['sem3'];
        user['sem4'] = i.value['sem4'];
        user['isRestricted'] = i.value['isRestricted'];
        break;
      }
    }
  }

  Future<void> handleSubmit(String text) async {
    var userEmail = emailHandler.text.trim();
    var userPass = passHandler.text.trim();
    var checkpass = '';
    final getResponse = await http.get(url);
    var flag = 0;
    var restrict = 'false';
    final Map allData = json.decode(getResponse.body);
    for (final i in allData.entries) {
      if (userEmail == i.value['email']) {
        flag = 1;
        checkpass = i.value['password'];
        restrict=i.value['isRestricted'];
        break;
      }
    }

    if (flag == 0) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Email'),
          content: const Text('Email does not exist'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else if (userEmail.isEmpty || userPass.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Enter All Credentials!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else if (userPass.length < 6) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Password Too Short!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else if (userPass != checkpass) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Invalid credentials!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } 
    else if(restrict == 'true'){
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login Error'),
          content: const Text('Your Account Has Been Restricted! Contact Admin For Further Details.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
    else if (checkpass == userPass) {
      final email = userEmail;

      _setuserDetails();

      widget.onLogin(email);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(
            //   height: 225,
            // ),
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(5, 5),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage('assets/images/latestlogopccoe.png'),
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  repeat: ImageRepeat.noRepeat,
                  opacity: 0.5,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              width: 400,
              // height: 350,
              margin: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0XFFA4243B),
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Divider(
                    color: Color(0XFF0E6BA8),
                    thickness: 2,
                  ),
                  CustomTextField(
                    'Email',
                    obscure: false,
                    cont: emailHandler,
                    keyboard: TextInputType.emailAddress,
                  ), // Using custom textfield widgets
                  CustomTextField(
                    'Password',
                    obscure: true,
                    cont: passHandler,
                    keyboard: TextInputType.text,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 20, 50, 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(30),
                      ),
                      onPressed: () => handleSubmit('LoggedIn'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not A User ?',
                          style: TextStyle(fontSize: 18),
                        ),
                        TextButton(
                          onPressed: widget.onToggle,
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 18),
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
      ),
    );
  }
}
