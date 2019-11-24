import 'dart:math';

import 'package:calculator_app/domain/calculator/calculator.dart';
import 'package:calculator_app/domain/calculator/local_calculator.dart';
import 'package:calculator_app/presentation/widgets/chart/chart_widget.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<Point<double>> pointList = [];
  TextEditingController expressionController;
  static const ALLOWED_EXPRESSION_CHARS = '0123456789()+-/*.^x sqrt';

  @override
  void initState() {
    super.initState();

    expressionController =
        TextEditingController(text: 'x^2 + sqrt( - 1 + 2 / 2 + 4 * (8 - 4))');
  }

  String _checkExpressionTextField(String text) {
    for (var value in text.split('')) {
      if (!ALLOWED_EXPRESSION_CHARS.contains(value)) {
        return 'unallowed charatcer $value';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: expressionController,
              decoration: InputDecoration(labelText: 'expression'),
              validator: _checkExpressionTextField,
            ),
            RaisedButton(
                child: Text('Calculate'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  _calculate(expressionController.text);
                }),
            Container(
              height: 400,
              width: 400,
              child: ChartWidget(
                pointList,
              ),
            ),
            SizedBox(height: 5,),
            Container(
              height: 5,
              width: 420,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }

  void _calculate(String expression) async {
    Calculator calculator = LocalCalculator();

    pointList = await calculator.calculate(expression, -10, 10);
    setState(() {});
  }
}
