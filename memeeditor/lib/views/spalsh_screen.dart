import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:memeeditor/views/home.dart';

class SplashHome extends StatefulWidget {
  SplashHome({Key? key}) : super(key: key);

  @override
  State<SplashHome> createState() => _SplashHomeState();
}

class _SplashHomeState extends State<SplashHome> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light)),
      body: Container(
        child: Column(
          children: [
            Lottie.asset('assets/images/splash_home.json'),
            Text(
              'Memer',
              style: TextStyle(
                  color: Colors.red.shade200,
                  fontWeight: FontWeight.bold,
                  fontSize: 35),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(
              color: Colors.red.shade200,
            )
          ],
        ),
      ),
    );
  }
}
