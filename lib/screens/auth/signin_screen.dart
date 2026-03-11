import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home_screen.dart';
import '../employee_screen.dart';
import '../contacts_screen.dart';
import '../employee_profile_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedRole = "admin";
  bool isPasswordVisible = false;
  bool isLoginLoading = false;
  bool isRegisterLoading = false;

  final supabase = Supabase.instance.client;

  // 🔐 LOGIN FUNCTION
  Future<void> login() async {
    setState(() => isLoginLoading = true);

    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = response.user;

      if (user == null) {
        showError("User not found");
        return;
      }

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) {
        showError("Role not assigned");
        return;
      }

      String role = data['role'];

      showSuccess("Login successful 🎉");

      // 🚀 ROLE BASED NAVIGATION
      if (role == "admin") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else if (role == "hr") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const EmployeeProfileScreen()));
      } else if (role == "employee") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const EmployeeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ContactsScreen()));
      }
    } catch (e) {
      showError("Invalid email or password");
    }

    setState(() => isLoginLoading = false);
  }

  // 🔥 SIGNUP FUNCTION
  Future<void> signUpUser() async {
    setState(() => isRegisterLoading = true);

    try {
      final res = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = res.user;

      if (user != null) {
        await supabase.from('profiles').insert({
          'id': user.id,
          'role': selectedRole,
        });

        showSuccess("Account created successfully ✅");
      } else {
        showError("Signup failed");
      }
    } catch (e) {
      showError(e.toString());
    }

    setState(() => isRegisterLoading = false);
  }

  // ❌ ERROR
  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ✅ SUCCESS
  void showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
      ),
    );
  }

  // 🔘 ROLE BUTTON
  Widget roleBtn(String text, String role, Color color) {
    bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() => selectedRole = role);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 🔵 FORM SECTION
  Widget formSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sign in",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("Enter your credentials to log in"),
        const SizedBox(height: 20),

        Wrap(
          children: [
            roleBtn("Admin", "admin", Colors.green),
            roleBtn("HR", "hr", Colors.purple),
            roleBtn("Employee", "employee", Colors.orange),
            roleBtn("Client", "client", Colors.blue),
          ],
        ),

        const SizedBox(height: 20),

        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),

        const SizedBox(height: 15),

        TextField(
          controller: passwordController,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: "Password",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: Icon(isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 15),

        /// 🔐 LOGIN BUTTON
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
              onPressed: isLoginLoading ? null : login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
              child: isLoginLoading
                ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
        ),

        const SizedBox(height: 10),

        /// 🔥 REGISTER BUTTON
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
              onPressed: isRegisterLoading ? null : signUpUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
              child: isRegisterLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
              "Register",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
        ),
      ],
    );
  }

  // 🔵 IMAGE SECTION
  Widget imageSection() {
    return Center(
      child: Image.network(
        "https://cdn-icons-png.flaticon.com/512/4140/4140048.png",
        height: 220,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFDCE9F1),
      body: Center(
        child: Container(
          width: isMobile ? double.infinity : 900,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: isMobile
              ? SingleChildScrollView(
            child: Column(
              children: [
                formSection(),
                const SizedBox(height: 20),
                imageSection(),
              ],
            ),
          )
              : Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: formSection(),
                ),
              ),
              Expanded(child: imageSection()),
            ],
          ),
        ),
      ),
    );
  }
}