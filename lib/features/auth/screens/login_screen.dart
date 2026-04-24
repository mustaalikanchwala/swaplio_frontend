import 'package:flutter/material.dart';
import 'package:swaplio_frontend/features/auth/screens/home_screen.dart';
import 'package:swaplio_frontend/features/auth/services/auth_service.dart';
import 'package:swaplio_frontend/features/auth/services/storage_service.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
   State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  bool isLoading = false;
  final authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding:const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                fillColor: Colors.orange,
                filled: true,
                hintText: "Enter Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                fillColor: Colors.pink,
                filled: true,
                hintText: "Enter Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  if(isLoading) return;
                  print(passwordController.text);
                  print(emailController.text);
                  setState(() {
                    isLoading = true;
                  });

                  try{
                    final response = await authService.login(emailController.text, passwordController.text);
                    final token = response["token"];
                    if(token != null){
                      print(token);
                      await StorageService.saveToken(token);
                      if(!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen() )
                      );
                    }
                  }catch(e){
                    print(e.toString());
                  }finally{
                    setState(() {
                      isLoading= false;
                    });
                }

                },
                child: isLoading ? CircularProgressIndicator() : const Text("Login"),

            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}