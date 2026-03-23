import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final supabase = Supabase.instance.client;

  bool isLoading = false;
  String? emailError;

  Future<void> resetPassword() async {
    setState(() {
      emailError = null;
    });

    if (!emailController.text.contains("@")) {
      setState(() => emailError = "Enter valid email");
      return;
    }

    setState(() => isLoading = true);

    try {
      await supabase.auth.resetPasswordForEmail(
        emailController.text.trim(),
      );

      showSnack("Reset link sent to email 📩", true);
    } catch (e) {
      showSnack("Error: $e", false);
    }

    setState(() => isLoading = false);
  }

  void showSnack(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE9F1),
      body: Center(
        child: Container(
          width: 900,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [

              /// 🟣 LEFT IMAGE
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/3064/3064197.png",
                      height: 200,
                    ),
                  ),
                ),
              ),

              /// 🔵 RIGHT FORM
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Let us help you recover your account",
                      ),

                      const SizedBox(height: 30),

                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          errorText: emailError,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔥 BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: InkWell(
                          onTap: isLoading ? null : resetPassword,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFB49B86),
                                  Color(0xFF8E7AAE),
                                ],
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                color: Colors.white)
                                : const Text(
                              "Reset My Password",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔙 BACK BUTTON
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Back to Login"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}