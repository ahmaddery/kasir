import 'package:flutter/material.dart';
import 'package:kasir/Api/service_api.dart'; // Import service API
import 'package:kasir/screens/home_screen.dart'; // Import HomeScreen
import 'package:kasir/screens/auth/register_screen.dart'; // Import RegisterScreen
import 'package:kasir/screens/auth/reset_password.dart'; // Import ResetPasswordScreen
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _message = '';
  double _formOpacity = 0.0;
  double _buttonScale = 1.0;

  // Animation controller for form animation
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeIn,
    );

    // Start the form fade-in animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _formOpacity = 1.0;
      });
      _controller!.forward();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final data = await _apiService.login(
          _emailController.text, _passwordController.text);

      // Show AlertDialog on successful login
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Berhasil', style: GoogleFonts.roboto()),
            content: Text('Selamat Datang, ${data['user']['name']}!',
                style: GoogleFonts.roboto()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  // Navigate to HomeScreen after successful login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text('OK', style: GoogleFonts.roboto()),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _message = 'Login Gagal. Silahkan coba lagi.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: 'background-image',
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/people.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation!,
              child: AnimatedOpacity(
                opacity: _formOpacity,
                duration: Duration(seconds: 2),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 12,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 500),
                          style: GoogleFonts.roboto(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          child: Text('Welcome Back!'),
                        ),
                        SizedBox(height: 20),
                        BounceInAnimation(
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.blue),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        BounceInAnimation(
                          child: TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock, color: Colors.blue),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            obscureText: true,
                          ),
                        ),
                        SizedBox(height: 20),
                        _isLoading
                            ? CircularProgressIndicator()
                            : GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _buttonScale = 0.9;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _buttonScale = 1.0;
                                  });
                                },
                                onTap: _login,
                                child: AnimatedScale(
                                  scale: _buttonScale,
                                  duration: Duration(milliseconds: 200),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue,
                                          Colors.lightBlueAccent
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    child: Center(
                                      child: Text(
                                        'Login',
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(height: 10), // Space for Forgot Password button
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPasswordScreen()),
                            );
                          },
                          child: Text(
                            'Lupa Password?',
                            style: GoogleFonts.roboto(color: Colors.blue),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text(
                            'Belum mempunyai Akun? Register ',
                            style: GoogleFonts.roboto(color: Colors.blue),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(_message,
                            style: GoogleFonts.roboto(color: Colors.red)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BounceInAnimation extends StatefulWidget {
  final Widget child;

  const BounceInAnimation({Key? key, required this.child}) : super(key: key);

  @override
  _BounceInAnimationState createState() => _BounceInAnimationState();
}

class _BounceInAnimationState extends State<BounceInAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.elasticOut,
    );

    _controller!.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _bounceAnimation!,
      child: widget.child,
    );
  }
}
