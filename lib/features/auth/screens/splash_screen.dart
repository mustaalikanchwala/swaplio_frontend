import 'package:flutter/material.dart';
import 'package:swaplio_frontend/features/auth/screens/home_screen.dart';
import 'package:swaplio_frontend/features/auth/screens/login_screen.dart';
import 'package:swaplio_frontend/features/auth/services/storage_service.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});
  @override
  State<SplashScreen>  createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>{

  @override
  void initState(){
    super.initState();
    _checkToken();
  }
  Future<void> _checkToken() async {
    final String? token = await StorageService.getToken();
    if(!mounted) return;
    if(token != null){
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => HomeScreen())
      );
    }else{
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
  }

}