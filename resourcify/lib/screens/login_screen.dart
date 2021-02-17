import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/admin/admin_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/repository/admin_repository.dart';
import 'package:resourcify/screens/screens.dart';
import 'package:resourcify/screens/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
            } else if (state is AuthAdminLoaded) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => AdminHomeScreen()));
            }
          },
          builder: (context, state) {
            if (state is AuthNotLoggedIn || state is AuthJwtRemoved) {
              return _buildInitialState();
            } else if (state is AuthLoading) {
              return Center(
                child: CircularProgressIndicator(),
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
                'Sign in Now',
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
            _buildEmailTF(),
            SizedBox(height: 30),
            _buildPasswordTF(),
            _buildForgotPasswordBtn(),
            SizedBox(
              height: 10,
            ),
            _buildLoginBtn(),
            _buildSignUpBtn(),
          ],
        ),
      ),
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

  Widget _buildPasswordTF() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: kBoxDecorationStyle,
      child: TextField(
        obscureText: !_passwordVisible,
        controller: _passwordController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(Icons.lock, color: Color(0xff3967D6)),
          hintText: 'Enter your password',
          hintStyle: kHintTextStyle,
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      alignment: Alignment.centerRight,
      child: FlatButton(
        padding: EdgeInsets.only(right: 0),
        onPressed: () {},
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
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
          BlocProvider.of<AuthBloc>(context)
              .add(SignIn(_emailController.text, _passwordController.text));
        },
        child: Text(
          'LOGIN',
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

  Widget _buildSignUpBtn() {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Don\'t have an Account?',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'Sign Up',
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
