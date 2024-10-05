import 'package:flutter/material.dart';
import 'package:kasir/Api/service_api.dart'; // Adjust this import according to your project structure
import 'package:kasir/screens/auth/auth_screen.dart'; // Import AuthScreen for login navigation
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  String _message = '';
  bool _isLoading = false;

  double _formOpacity = 0.0;
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

  Future<void> _sendResetLink() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      await ApiService().resetPassword(_emailController.text);
      setState(() {
        _message = 'Password reset link berhasil dikirim cek email !';
      });
    } catch (e) {
      setState(() {
        _message = 'Gagal Mengirim password reset link: $e';
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
                          child: Text('Reset Your Password'),
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
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        SizedBox(height: 20),
                        _isLoading
                            ? CircularProgressIndicator()
                            : GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _formOpacity = 0.9;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _formOpacity = 1.0;
                                  });
                                },
                                onTap: _sendResetLink,
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
                                      'Send Reset Link',
                                      style: GoogleFonts.roboto(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(height: 20),
                        Text(
                          _message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _message.startsWith('Failed')
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Added "Sudah ingat password? Login" button
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthScreen()),
                            );
                          },
                          child: Text(
                            'Sudah ingat password? Login',
                            style: GoogleFonts.roboto(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
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
