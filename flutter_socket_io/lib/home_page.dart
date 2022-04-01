import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IO.Socket socket;
  double? latitude;
  double? longitude;

  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    initSoscket();
  }

  Future<void> initSoscket() async {
    try {
      socket = IO.io('http://192.168.100.243:3700', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });
      socket.connect();
      socket.onConnect((data) {
        print('connected:${socket.id}');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
              key: globalKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  FormHelper.inputFieldWidget(
                    context,
                    "Latitude",
                    "latitude",
                    (onValidate) {
                      if (onValidate.isEmpty) {
                        return "Latitude is required";
                      }
                      return null;
                    },
                    (onSaved) {
                      latitude = double.parse(onSaved);
                    },
                    borderRadius: 10,
                  ),
                  const SizedBox(height: 10),
                  FormHelper.inputFieldWidget(
                    context,
                    "Longitude",
                    "longitude",
                    (onValidate) {
                      if (onValidate.isEmpty) {
                        return "Longitude is required";
                      }
                      return null;
                    },
                    (onSaved) {
                      longitude = double.parse(onSaved);
                    },
                    borderRadius: 10,
                  ),
                  const SizedBox(height: 10),
                  FormHelper.submitButton("Send Location", () {
                    if (validateAndSave()) {
                      var coords = {"lat": latitude, "lng": longitude};
                      socket.emit("position-change", jsonEncode(coords));
                    } else {}
                  })
                ],
              ))),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
