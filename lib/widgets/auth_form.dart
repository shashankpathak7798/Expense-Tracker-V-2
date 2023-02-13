import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/home_screen.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String userName, String password, bool isLogin, BuildContext ctx) submitFn;

  AuthForm(this.submitFn);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() async  {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail, _userName, _userPassword, _isLogin, context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  key: ValueKey('email'),
                  validator: (val) {
                    if(val!.isEmpty || !val.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                SizedBox(height: 4,),
                TextFormField(
                  key: ValueKey('username'),
                  validator: (val) {
                    if(val!.isEmpty || val.length < 4) {
                      return 'Please enter at least 4 characters!';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  onSaved: (value) {
                    _userName = value!;
                  },
                ),
                SizedBox(height: 4,),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (val) {
                    if(val!.isEmpty || val.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    }, child: Text(_isLogin ? 'Don\'t have an account?' : 'Already have an account!')),
                    CircleAvatar(
                      child: IconButton(icon: Icon(Icons.keyboard_arrow_right_sharp,), onPressed: _trySubmit,),
                      radius: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
