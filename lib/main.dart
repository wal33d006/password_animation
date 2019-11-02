import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Animation',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Interactive password'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String specialCharacters = '!@#\$%^&*()_+}{":?><~,./;\[]=-\'';
  static String upperCaseAnimationString = 'upper';
  static String lowerCaseAnimationString = 'lower';
  static String textCountAnimationString = 'count';
  static String numberAnimationString = 'number';
  static String specialCharAnimationString = 'special';
  String animateUpperCase = '';
  String animateLowerCase = '';
  String animateSpecialCase = '';
  String animateNumberCase = '';
  String animateCountCase = '';
  String erasedLetter = '';

  int oldLength = 0;
  int newLength = 0;
  int upperCaseCount = 0;
  int lowerCaseCount = 0;
  int specialCharCount = 0;
  int numberCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: TextFormField(
                obscureText: true,
                onChanged: _handleTextChanged,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter password',
                  labelText: 'Password',
                ),
              ),
            ),
            _buildFlareWidgets(),
          ],
        ),
      ),
    );
  }

  Row _buildFlareWidgets() {
    return Row(
      children: <Widget>[
        _buildFlareActor(
          'assets/Upper.flr',
          animateUpperCase,
          'UpperCase',
        ),
        _buildFlareActor(
          'assets/Count.flr',
          animateCountCase,
          'MinCount',
        ),
        _buildFlareActor(
          'assets/Lower.flr',
          animateLowerCase,
          'LowerCase',
        ),
        _buildFlareActor(
          'assets/Number.flr',
          animateNumberCase,
          'Number',
        ),
        _buildFlareActor(
          'assets/Special.flr',
          animateSpecialCase,
          'Special',
        ),
      ],
    );
  }

  void _handleTextChanged(value) {
    if (value.isEmpty) {
      // reset everything
      _reset();
      return;
    }
    var typedLetter = value[value.length - 1];
    if (value.length < oldLength) {
      // Text has been erased
      newLength = oldLength = value.length;
      if (isUppercase(erasedLetter)) {
        setState(() {
          upperCaseCount--;
        });
      }
      if (isLowercase(erasedLetter)) {
        setState(() {
          lowerCaseCount--;
        });
      }
      if (isNumeric(erasedLetter)) {
        setState(() {
          numberCount--;
        });
      }
      if (specialCharacters.contains(erasedLetter)) {
        setState(() {
          specialCharCount--;
        });
      }
      if (value.length < 8) {
        setState(() {
          animateCountCase = '';
        });
      }
      print(value[value.length - 1]);
      if (upperCaseCount == 0) {
        setState(() {
          animateUpperCase = '';
        });
      }
      if (lowerCaseCount == 0) {
        setState(() {
          animateLowerCase = '';
        });
      }
      if (numberCount == 0) {
        setState(() {
          animateNumberCase = '';
        });
      }
      if (specialCharCount == 0) {
        setState(() {
          animateSpecialCase = '';
        });
      }
    } else {
      // Text has been typed
      newLength = oldLength = value.length;
      if (value.length > 8) {
        setState(() {
          animateCountCase = textCountAnimationString;
        });
      }
      print(value[value.length - 1]);
      if (isUppercase(typedLetter)) {
        setState(() {
          animateUpperCase = upperCaseAnimationString;
          upperCaseCount++;
        });
      }
      if (isLowercase(typedLetter)) {
        setState(() {
          animateLowerCase = lowerCaseAnimationString;
          lowerCaseCount++;
        });
      }
      if (isNumeric(typedLetter)) {
        setState(() {
          animateNumberCase = numberAnimationString;
          numberCount++;
        });
      }
      if (specialCharacters.contains(typedLetter)) {
        setState(() {
          animateSpecialCase = specialCharAnimationString;
          specialCharCount++;
        });
      }
    }
    erasedLetter = typedLetter;
  }

  void _reset() {
    setState(() {
      oldLength = newLength =
          specialCharCount = numberCount = upperCaseCount = lowerCaseCount = 0;
      animateSpecialCase = animateNumberCase =
          animateLowerCase = animateUpperCase = animateCountCase = '';
    });
  }

  Expanded _buildFlareActor(String asset, String animation, String title) {
    return Expanded(
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 70.0,
                child: FlareActor(
                  asset,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: animation,
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      color: animation.isEmpty ? Colors.grey : Colors.green,
                    ),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Padding(
              padding: const EdgeInsets.only(
                right: 12.0,
                top: 12.0,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 14.0,
              ),
            ),
            duration: Duration(milliseconds: 500),
            crossFadeState: animation.isEmpty
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          )
        ],
      ),
    );
  }
}
