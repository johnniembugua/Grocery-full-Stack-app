import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../api/api_service.dart';
import '../config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isAsyncCallProcess = false;

  String? password;

  String? email;
  bool hidePassword = true;
  bool isRemember = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ProgressHUD(
          child: Form(
            key: globalKey,
            child: _loginUi(context),
          ),
          inAsyncCall: isAsyncCallProcess,
          opacity: .3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _loginUi(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/shopping-bag.png',
                fit: BoxFit.contain,
                width: 150,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Grocery App",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.deepOrangeAccent),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FormHelper.inputFieldWidget(
              context,
              "email",
              "E-mail",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "* Required";
                }
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(onValidateVal);
                if (!emailValid) {
                  return "Invalid email Format";
                }
                return null;
              },
              (onSavedVal) {
                email = onSavedVal.toString().trim();
              },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.email_outlined),
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              prefixIconPaddingLeft: 10,
              borderColor: Colors.grey.shade400,
              textColor: Colors.black,
              prefixIconColor: Colors.black,
              hintColor: Colors.black.withOpacity(.6),
              backgroundColor: Colors.grey.shade100,
              borderFocusColor: Colors.grey.shade200,
            ),
            const SizedBox(
              height: 10,
            ),
            FormHelper.inputFieldWidget(
                context,
                "password",
                "Password",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return "* Required";
                  }

                  return null;
                },
                (onSavedVal) {
                  password = onSavedVal.toString().trim();
                },
                showPrefixIcon: true,
                prefixIcon: const Icon(Icons.lock_open),
                borderRadius: 10,
                contentPadding: 15,
                fontSize: 14,
                prefixIconPaddingLeft: 10,
                borderColor: Colors.grey.shade400,
                textColor: Colors.black,
                prefixIconColor: Colors.black,
                hintColor: Colors.black.withOpacity(.6),
                backgroundColor: Colors.grey.shade100,
                borderFocusColor: Colors.grey.shade200,
                obscureText: hidePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  color: Colors.redAccent.withOpacity(.4),
                  icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility),
                ),
                onChange: (val) {
                  password = val;
                }),
            const SizedBox(
              height: 10,
            ),
            FormHelper.submitButton(
              "Sign In",
              () {
                if (validateSave()) {
                  //API Request
                  setState(() {
                    isAsyncCallProcess = true;
                  });
                  APIService.loginUser(email!, password!).then((response) {
                    setState(() {
                      isAsyncCallProcess = false;
                    });
                    if (response) {
                      FormHelper.showSimpleAlertDialog(context, Config.appName,
                          "Login Completed successfully", "OK", () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/home", (route) => false);
                      });
                    } else {
                      FormHelper.showSimpleAlertDialog(
                          context, Config.appName, "Login Failed", "OK", () {
                        Navigator.pop(context);
                      });
                    }
                  });
                }
              },
              btnColor: Colors.deepOrange,
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 20,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              children: <TextSpan>[
                const TextSpan(text: "Dont have an account?"),
                TextSpan(
                    text: "Sign Up",
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/register", (route) => false);
                      }),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  bool validateSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
