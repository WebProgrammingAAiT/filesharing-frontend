import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/screens/constants.dart';
import 'package:resourcify/screens/login_screen.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/screens/screens.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _passwordVisible;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is AuthLoaded) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        }
      },
      builder: (context, state) {
        if (state is AuthNotLoggedIn || state is AuthJwtRemoved) {
          return _buildInitialState();
        } else if (state is AuthLoading) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 1,
            ),
          );
        } else if (state is AuthError) {
          return _buildInitialState();
        } else
          return SizedBox.shrink();
      },
    ));
  }

  Widget _buildInitialState() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xff3967D6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(500, 300),
                  bottomRight: Radius.elliptical(520, 300),
                ),
              ),
              height: 200,
            ),
            SizedBox(
              height: 80,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: Color(0xff3967D6),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            _buildName('first name'),
            SizedBox(height: 20),
            _buildName('last name'),
            SizedBox(height: 20),
            _buildEmailTF(),
            SizedBox(height: 20),
            _buildPasswordTF('Enter'),
            SizedBox(height: 20),
            _buildPasswordTF('Confirm'),
            SizedBox(
              height: 40,
            ),
            _buildSignupBtn(),
            _buildLoginBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildName(String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: kBoxDecorationStyle,
      child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.person, color: Color(0xff3967D6)),
            hintText: 'Enter your $label',
            hintStyle: kHintTextStyle,
          ),
          controller: label == 'first name'
              ? _firstNameController
              : _lastNameController),
    );
  }

  Widget _buildEmailTF() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: kBoxDecorationStyle,
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(Icons.email, color: Color(0xff3967D6)),
          hintText: 'Enter your email',
          hintStyle: kHintTextStyle,
        ),
        controller: _emailController,
      ),
    );
  }

  Widget _buildPasswordTF(String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: kBoxDecorationStyle,
      child: TextField(
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(Icons.lock, color: Color(0xff3967D6)),
          hintText: '$label your password',
          hintStyle: kHintTextStyle,
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        controller:
            label == 'Enter' ? _passwordController : _confirmPasswordController,
      ),
    );
  }

  Widget _buildSignupBtn() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 25),
      child: RaisedButton(
        elevation: 5,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            30,
          ),
        ),
        color: Color(0xff3967D6),
        onPressed: () {
          BlocProvider.of<AuthBloc>(context).add(SignUp(
              _firstNameController.text,
              _lastNameController.text,
              _emailController.text,
              _passwordController.text,
              _confirmPasswordController.text));
        },
        child: Text(
          'SIGNUP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Already have an Account?',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'Signin from here',
            style: TextStyle(
              color: Color(0xff3967D6),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
