import 'package:ecommerce_int2/api_service.dart';
import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/screens/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import '../cache_storage.dart' ;
import '../dbmain.dart';
import 'dart:math';
   String generateOtp4() {
      final rnd = Random();
      // ensures a number from 0000 to 9999, pads with leading zeros if needed
      return rnd.nextInt(10000).toString().padLeft(4, '0');
    }

class ConfirmOtpPage extends StatefulWidget {
  @override
  final String phoneNumber;
 
  // require the phone number in the constructor
  const ConfirmOtpPage({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);
  _ConfirmOtpPageState createState() => _ConfirmOtpPageState();
}

class _ConfirmOtpPageState extends State<ConfirmOtpPage> {
    String get phone => widget.phoneNumber;
    late String _currentOtp;
      final TextEditingController _pinController = TextEditingController();
@override
void dispose() {
  _pinController.dispose();
  super.dispose();
}

    @override
    void initState() {
      super.initState();
      _currentOtp = generateOtp4();
      print('Sending OTP: $_currentOtp to ${widget.phoneNumber}');
        _initData(); // no await here

      // call your API with _currentOtp…
    }



Future<void> _initData() async {
  _currentOtp = generateOtp4();
  print('Sending OTP: $_currentOtp to ${widget.phoneNumber}');

  // final api = ApiService(baseUrl: 'http://127.0.0.1:8000'); 
  // Android emulator? use http://10.0.2.2:8000 instead
final api = ApiService(baseUrl: 'https://metrolabs.com.np:8000');
  try {
    await api.login(email: 'admin@example.com', password: 'password');
    final res = await api.ensureCustomerByPhone(widget.phoneNumber);
    final localId = await Dbmain.insertOrReplaceCustomerFromServer(res);

print('Saved local customer with id = $localId');
    print(res); // EnsureByPhoneResult(id: ..., existed: ...)
  } catch (e) {
    print('API error: $e');
  }
}


  TextEditingController otp1 = TextEditingController(text: '1');
  TextEditingController otp2 = TextEditingController(text: '2');
  TextEditingController otp3 = TextEditingController(text: '3');
  TextEditingController otp4 = TextEditingController(text: '4');
  TextEditingController otp5 = TextEditingController(text: '5');


  Widget otpBox(TextEditingController otpController) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.8),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: SizedBox(
          width: 9,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: otpController,
              decoration: InputDecoration(
                  border: InputBorder.none, contentPadding: EdgeInsets.zero),
              style: TextStyle(fontSize: 16.0),
              keyboardType: TextInputType.phone,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      final height = MediaQuery.of(context).size.height * 0.42;

   Widget upperlogo =  
   
  Center(child:Container(
    height: height/2,
    width: MediaQuery.of(context).size.width * 0.6,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/MHN-ICON.png'),
        fit: BoxFit.contain,
      ),
    ),
    
  ),);
   Widget lowerlogo =  Center(
   child:Container(
    height: height/5,
    width: MediaQuery.of(context).size.width * 0.4,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/logobottom.png'),
        fit: BoxFit.contain,
      ),
    ),
    
  ),);
    Widget title = Text(
      'Verify your account',
      style: TextStyle(
          color: const Color.fromARGB(255, 73, 66, 66),
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Enter OTP sent to  '+phone +'  '+ _currentOtp,
          style: TextStyle(
            color: const Color.fromARGB(255, 31, 30, 30),
            fontSize: 16.0,
          ),
        ));

    Widget verifyButton = Center(
      child: InkWell(
        onTap: () {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (_) => IntroPage()));
          final entered = _pinController.text.trim();
        // if (entered == _currentOtp) {
        //             CacheStorage.login();
        //             Navigator.of(context).push(
        //               MaterialPageRoute(builder: (_) => IntroPage()),
        //             );
        //           }
        if (entered == _currentOtp) {
            CacheStorage.login();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => IntroPage()),
            );
          }

         else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Wrong OTP, try again " +entered +" --- " +_currentOtp)),
                    );
                  }

        },
        child: Container(
          width: MediaQuery.of(context).size.width / 1,
          height: 60,
          child: Center(
              child: new Text("Verify",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  // colors: [
                  //   Color.fromRGBO(236, 60, 3, 1),
                  //   Color.fromRGBO(234, 60, 3, 1),
                  //   Color.fromRGBO(216, 78, 16, 1),
                  // ],
                   colors: [Color.fromARGB(255,  55, 120, 83), Color.fromARGB(255, 55, 120, 83), Color.fromARGB(255, 55, 90, 4)],

                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget otpCode = Container(
      padding: const EdgeInsets.only(right: 28.0),
      height: 190,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          otpBox(otp1),
          otpBox(otp2),
          otpBox(otp3),
          otpBox(otp4),
          otpBox(otp5)
        ],
      ),
    );

    Widget resendText = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Didn't receive code ?   ",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Color.fromRGBO(25, 24, 24, 0.494),
            fontSize: 14.0,
          ),
        ),
        InkWell(
          onTap: () {  Navigator.pop(context);
},
          child: Text(
            'Resend OTP ',
            style: TextStyle(
              color: const Color.fromARGB(255, 17, 16, 16),
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
    child: Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/bgmain.png'),
      fit: BoxFit.cover,
    ),
  ),
  child: Scaffold(
    backgroundColor: Colors.transparent, // Make scaffold transparent to see background
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    ),
    body: Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              upperlogo,
              // Spacer(flex: 3),
              title,
              Spacer(),
              subTitle,
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(right: 28.0),
                child: Center(
                  child: PinCodeTextField(
                    controller: _pinController,
                    highlightColor: Colors.white,
                    highlightAnimation: true,
                    highlightAnimationBeginColor: Colors.white,
                    highlightAnimationEndColor: Theme.of(context).primaryColor,
                    pinTextAnimatedSwitcherDuration: Duration(milliseconds: 500),
                    wrapAlignment: WrapAlignment.center,
                    hasTextBorderColor: Colors.transparent,
                    highlightPinBoxColor: Colors.white,
                    autofocus: true,
                    pinBoxHeight: 60,
                    pinBoxWidth: 60,
                    pinBoxRadius: 5,
                    defaultBorderColor: Colors.transparent,
                    pinBoxColor: Color.fromRGBO(255, 255, 255, 0.8),
                    maxLength: 4,
                  ),
                ),
              ),
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(right: 28.0),
                child: verifyButton,
              ),
              Spacer(flex: 2),
                resendText,
              
              lowerlogo,
            
              Spacer()
            ],
          ),
        )
      ],
    ),
  ),
),  );
  }
}
