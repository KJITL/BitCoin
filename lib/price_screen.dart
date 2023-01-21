import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:convert';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

const apiKey = '9F412D22-65F1-4449-90F6-42ECE9CACED1';

class _PriceScreenState extends State<PriceScreen> {
  String currentCountry = 'AUD';
  @override
  void initState() {
    super.initState();
    setValue();
  }

  // function to get data
  dynamic theData;
  String coinBTC;
  String coinETH;
  String coinLTC;
  String coinRate = '?';
  Future getApiCoinData(String coin) async {
    Response response = await get(
      Uri.parse(
          'https://rest.coinapi.io/v1/exchangerate/$coin/$currentCountry?apiKey=$apiKey'),
    );
    theData = await jsonDecode(response.body);
    setState(
      () {
        coinRate = theData['rate'].toStringAsFixed(0);
        if (coin == 'BTC') {
          coinBTC = coinRate;
        } else if (coin == 'ETH') {
          coinETH = coinRate;
        } else if (coin == 'LTC') {
          coinLTC = coinRate;
        }
      },
    );
  }

  Future setValue() async {
    for (String coin in cryptoList) {
      await getApiCoinData(coin);
    }
  }

  //Android Picker
  DropdownButton<String> getAndroidPicker() {
    List<DropdownMenuItem<String>> itemOfWidgets = [];
    for (String item in currenciesList) {
      itemOfWidgets.add(
        DropdownMenuItem(child: Text(item), value: item),
      );
    }

    return DropdownButton<String>(
      value: currentCountry,
      items: itemOfWidgets,
      onChanged: (value) {
        setState(
          () {
            currentCountry = value;
            setValue();
          },
        );
      },
    );
  }

  //IOS Picker
  CupertinoPicker getIphonePicker() {
    List<Widget> itemOfWidgets = [];
    for (String item in currenciesList) {
      itemOfWidgets.add(
        Text(item),
      );
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(
          () {
            currentCountry = currenciesList[selectedIndex];
            setValue();
          },
        );
      },
      children: itemOfWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('🤑 Coin Ticker'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/wp.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 4.0, 18.0, 0),
              child: Card(
                color: Colors.yellow[900],
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    '1 BTC = $coinBTC $currentCountry',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 4.0, 18.0, 0),
              child: Card(
                color: Colors.deepPurple,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    '1 ETH = $coinETH $currentCountry',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 4.0, 18.0, 0),
              child: Card(
                color: Colors.blueAccent[200],
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    '1 LTC = $coinLTC $currentCountry',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 100.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 10.0),
              color: Colors.brown,
              child: Platform.isIOS ? getIphonePicker() : getAndroidPicker(),
            ),
          ],
        ),
      ),
    );
  }
}
