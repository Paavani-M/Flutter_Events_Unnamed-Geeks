import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:login_singup/config/palette.dart';
import 'package:email_auth/email_auth.dart';
import 'package:login_singup/form.dart';
import 'package:login_singup/scanner.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;

  TextEditingController email_text = TextEditingController();
  TextEditingController name_text = TextEditingController();
  TextEditingController pass_text = TextEditingController();
  TextEditingController user_email = TextEditingController();
  TextEditingController user_pass = TextEditingController();
  TextEditingController OTP_text = TextEditingController();
  TextEditingController linkedin_text = TextEditingController();

  void sendOTP()async{
    var session = EmailAuth(sessionName: "OTP Verification");
    var res = await session.sendOtp(recipientMail: email_text.text);
    if (res) {
      print("OTP sent succesfully!");
    }else{
      print("Problem while sending OTP!!");
    }
  }

  void verifyOTP(){
    var session = EmailAuth(sessionName: "OTP VErification");
    var res = session.validateOtp(recipientMail: email_text.text, userOtp: OTP_text.text);
    if (res) {
      print("OTP Verified succesfully");
      buildSigninSection();
    }else{
      print("Invalid OTP");
      buildSignupSection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/background.jpg"),
                      fit: BoxFit.fill)),
              child: Container(
                padding: EdgeInsets.only(top: 90, left: 20),
                color: Color(0xFF3b5999).withOpacity(.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: "Welcome ",
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 2,
                            color: Colors.yellow[700],
                          ),
                          children: [
                            TextSpan(
                              text: isSignupScreen ? " To UNNAMED GEEKS!!!!" : " Back, our UNNAMED GEEK",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[700],
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      isSignupScreen
                          ? "Signup to Continue"
                          : "Signin to Continue",
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the shadow for the submit button
          buildBottomHalfContainer(true),
          //Main Contianer for Login and Signup
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: isSignupScreen ? 200 : 230,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              height: isSignupScreen ? 380 : 250,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Colors.orange,
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SIGNUP",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Colors.orange,
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (isSignupScreen) buildSignupSection(),
                    if (!isSignupScreen) buildSigninSection()
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the submit button
          buildBottomHalfContainer(false),
          // Bottom buttons
          Positioned(
            top: MediaQuery.of(context).size.height - 100,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text(isSignupScreen ? "Or Signup with" : "Or Signin with"),
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildTextButton(MaterialCommunityIcons.linkedin_box,
                          "LinkedIn", Palette.facebookColor),
                      buildTextButton(MaterialCommunityIcons.gmail,
                          "Google", Palette.googleColor),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildSigninSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          TextField(
            controller: user_email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
              hintText: "Enter your Email",
            ),
          ),
          SizedBox(
              height: 20
          ),
          TextField(
            controller: user_pass,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              hintText: "Enter your Password",
            ),
          ),
          SizedBox(
              height: 20
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isRememberMe,
                    activeColor: Palette.textColor2,
                    onChanged: (value) {
                      setState(() {
                        isRememberMe = !isRememberMe;
                      });
                    },
                  ),
                  Text("Remember me",
                      style: TextStyle(fontSize: 12, color: Palette.textColor1))
                ],
              ),

              TextButton(
                onPressed: () {
                  var user_entered_email = user_email.text;
                  var user_entered_password  = user_pass.text;
                  var email = email_text.text;
                  var password = pass_text.text;
                  var user_name = name_text.text;
                  var linkedIn = linkedin_text.text;

                  if((user_entered_email == email) && (user_entered_password == password)){
                    print("Login credentials matched");
                    print("User entered email is " + user_entered_email);
                    print("Registered email is " + email);
                    print("User entered password is "+user_entered_password);
                    print("Registered password is " + password);
                  }

                  //MyHome(name: user_name , email: email, linkedid:linkedIn );

                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome(name: user_name, email: email, linkedid: linkedIn)),);

                  //Navigator.push(context, MaterialPageRoute(builder: (context) => QRViewExample(email : '${email}')),);

                  //QRViewExample(email);
                },

                child: Text("LOGIN",
                    style: TextStyle(fontSize: 12, color: Palette.textColor1)),
              ),



              //TextButton(
               // onPressed: () {},
               // child: Text("Forgot Password?",
                //    style: TextStyle(fontSize: 12, color: Palette.textColor1)),
              //),





            ],
          )
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          TextField(
            controller: name_text,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_rounded),
              border: OutlineInputBorder(),
              hintText: "User Name",
            ),
          ),
          SizedBox(
              height: 20
          ),
          TextField(
            controller: email_text,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
              hintText: "Email",
            ),
          ),
          SizedBox(
              height: 20
          ),
          TextField(
            controller: linkedin_text ,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              prefixIcon: Icon(MaterialCommunityIcons.linkedin_box),
              border: OutlineInputBorder(),
              hintText: "Linked In URL",
            ),
          ),
          SizedBox(
              height: 20
          ),
          TextField(
            controller: pass_text,
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              hintText: "Password",
            ),
          ),
          SizedBox(
              height: 20
          ),
          TextButton(
              onPressed: () {
                var email = email_text.text;
                var name = name_text.text;
                var password = pass_text.text;
                var linkedin = linkedin_text.text;

                print("User name is "+name);
                print("user email is "+email);
                print("user password is " + password);
                print("Linkedin URL is " + linkedin);

                sendOTP();
              },
              child: Text("Verify Email")
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = true;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMale
                                ? Palette.textColor2
                                : Colors.transparent,
                            border: Border.all(
                                width: 1,
                                color: isMale
                                    ? Colors.transparent
                                    : Palette.textColor1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMale ? Colors.white : Palette.iconColor,
                        ),
                      ),
                      Text(
                        "Male",
                        style: TextStyle(color: Palette.textColor1),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = false;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMale
                                ? Colors.transparent
                                : Palette.textColor2,
                            border: Border.all(
                                width: 1,
                                color: isMale
                                    ? Palette.textColor1
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMale ? Palette.iconColor : Colors.white,
                        ),
                      ),
                      Text(
                        "Female",
                        style: TextStyle(color: Palette.textColor1),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: OTP_text,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.security),
              border: OutlineInputBorder(),
              hintText: "Enter the OTP sent to the registered mail id " + email_text.text,
            ),
          ),
          SizedBox(
              height: 20
          ),

          TextButton(
              onPressed: () {
                verifyOTP();

              },
              child: Text("SIGNUP")
          ),
          Container(
            width: 200,
            margin: EdgeInsets.only(top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "By pressing 'Submit' you agree to our ",
                  style: TextStyle(color: Palette.textColor2),
                  children: [
                    TextSpan(
                      //recognizer: ,
                      text: "term & conditions",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {

      },
      style: TextButton.styleFrom(
          side: BorderSide(width: 1, color: Colors.grey),
          minimumSize: Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 535 : 430,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ]),
          child: !showShadow
              ? Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.orange, Colors.red],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1))
                      ]),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                )
              : Center(),
        ),
      ),
    );
  }

  Widget buildTextField(
      IconData icon, String hintText, bool isPassword, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
      ),
    );
  }
}
