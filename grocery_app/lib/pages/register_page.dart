import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/api/api_service.dart';
import 'package:grocery_app/config.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isAsyncCallProcess = false;
  String? fullName;
  String? password;
  String? confirmPassword;
  String? email;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ProgressHUD(
          child: Form(
            key: globalKey,
            child: _registerUi(context),
          ),
          inAsyncCall: isAsyncCallProcess,
          opacity: .3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _registerUi(BuildContext context) {
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
                "Register",
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
              "FullName",
              "Full Name",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "* Required";
                }
                return null;
              },
              (onSavedVal) {
                fullName = onSavedVal.toString().trim();
              },
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.face),
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
            FormHelper.inputFieldWidget(
              context,
              "confirmPassword",
              "Confirm Password",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "* Required";
                }
                if (onValidateVal != password) {
                  return "Confirm Password not matched";
                }

                return null;
              },
              (onSavedVal) {
                confirmPassword = onSavedVal.toString().trim();
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
              obscureText: hideConfirmPassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hideConfirmPassword = !hideConfirmPassword;
                  });
                },
                color: Colors.redAccent.withOpacity(.4),
                icon: Icon(hideConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FormHelper.submitButton("Sign Up", () {
              if (validateSave()) {
                //API Request
                setState(() {
                  isAsyncCallProcess = true;
                });
                APIService.registerUser(fullName!, email!, password!)
                    .then((response) {
                  setState(() {
                    isAsyncCallProcess = false;
                  });
                  if (response) {
                    FormHelper.showSimpleAlertDialog(context, Config.appName,
                        "Registration Conmpleted successfully", "OK", () {
                      Navigator.pop(context);
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/login", (route) => false);
                    });
                  } else {
                    FormHelper.showSimpleAlertDialog(
                        context, Config.appName, "Registration Failed", "OK",
                        () {
                      Navigator.pop(context);
                    });
                  }
                });
              }
            },
                btnColor: Colors.deepOrange,
                borderColor: Colors.white,
                txtColor: Colors.white,
                borderRadius: 20)
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
                const TextSpan(text: "Already have an account?"),
                TextSpan(
                    text: "Sign In",
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/login", (route) => false);
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
