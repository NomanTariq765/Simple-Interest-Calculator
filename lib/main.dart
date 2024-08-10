import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Interest Calculator App',
      home: HomePage(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.cyan,
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  final double _minimumPadding = 5.0;
  var _currentItemSelected = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  var displayResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(child: Text('Simple Interest Calculator',style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 0.3),)),
      ),
      body: Container(
        margin: EdgeInsets.all(_minimumPadding * 2),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              getImageAsset(),
              Padding(
                padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: principalController,
                  decoration: InputDecoration(
                    labelText: 'Principal',
                    hintText: 'Enter Principal e.g. 12000',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the principal amount';
                    } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: roiController,
                  decoration: InputDecoration(
                    labelText: 'Rate of Interest',
                    hintText: 'In percent',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the rate of interest';
                    } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: termController,
                        decoration: InputDecoration(
                          labelText: 'Term',
                          hintText: 'Time in years',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the term in years';
                          } else if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(width: _minimumPadding * 5),
                    Expanded(
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(5),
                        items: _currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: _currentItemSelected,
                        onChanged: (String? newValueSelected) {
                          _onDropDownItemSelected(newValueSelected);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: _minimumPadding, top: _minimumPadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.teal, // Text color
                        ),
                        child: Text('Calculate', style: TextStyle(color: Colors.white, fontSize: 18)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              displayResult = _calculateTotalReturn();
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.grey, // Text color
                        ),
                        child: Text('Reset', style: TextStyle(color: Colors.white, fontSize: 18)),
                        onPressed: () {
                          _reset();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(_minimumPadding * 2),
                child: Center(child: Text(displayResult)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(image: assetImage, width: 125.0, height: 125.0);
    return Container(child: image, margin: EdgeInsets.all(_minimumPadding * 10));
  }

  void _onDropDownItemSelected(String? newValueSelected) {
    setState(() {
      _currentItemSelected = newValueSelected!;
    });
  }

  String _calculateTotalReturn() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;
    String result = 'After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected';
    return result;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
  }
}
