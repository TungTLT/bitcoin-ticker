import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int coinBTCRate = 0;
  int coinETHRate = 0;
  int coinLTCRate = 0;

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItemList = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      dropDownItemList.add(newItem);
    }

    return DropdownButton(
      value: selectedCurrency,
      items: dropDownItemList,
      onChanged: (value) async {
        print(value);
        getCoinRateForAllCryptoCurrencyAndUpdateUI(value);
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> itemPicker = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      itemPicker.add(newItem);
    }

    return CupertinoPicker(
      itemExtent: 31.0,
      onSelectedItemChanged: (selectedIndex) async {
        getCoinRateForAllCryptoCurrencyAndUpdateUI(
            currenciesList[selectedIndex]);
      },
      children: itemPicker,
    );
  }

  void updateAndroidUI(String currency, List<double> rateList) {
    setState(() {
      selectedCurrency = currency;
      coinBTCRate = rateList[0].toInt();
      coinETHRate = rateList[1].toInt();
      coinLTCRate = rateList[2].toInt();
    });
  }

  void updateiOSUI(String currency, List<double> rateList) {
    setState(() {
      selectedCurrency = currency;
      coinBTCRate = rateList[0].toInt();
      coinETHRate = rateList[1].toInt();
      coinLTCRate = rateList[2].toInt();
    });
  }

  Future<double> getCoinDataRate(
      {String cryptoCurrency, String normalCurrency}) async {
    CoinData coinData = CoinData(
      cryptoCurrency: cryptoCurrency,
      normalCurrency: normalCurrency,
    );
    return await coinData.getCoinDataRate();
  }

  void getCoinRateForAllCryptoCurrencyAndUpdateUI(String currency) async {
    List<double> rateList = [];
    for (String crypto in cryptoList) {
      var tempt = await getCoinDataRate(
          cryptoCurrency: crypto, normalCurrency: selectedCurrency);
      rateList.add(tempt);
    }
    Platform.isAndroid
        ? updateAndroidUI(currency, rateList)
        : updateiOSUI(currency, rateList);
  }

  @override
  void initState() {
    super.initState();
    getCoinRateForAllCryptoCurrencyAndUpdateUI('USD');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CoinTickerCard(
              cryptoCurrency: 'BTC',
              coinRate: coinBTCRate,
              selectedCurrency: selectedCurrency),
          CoinTickerCard(
              cryptoCurrency: 'ETH',
              coinRate: coinETHRate,
              selectedCurrency: selectedCurrency),
          CoinTickerCard(
              cryptoCurrency: 'LTC',
              coinRate: coinLTCRate,
              selectedCurrency: selectedCurrency),
          Spacer(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? androidDropDown() : iOSPicker(),
          ),
        ],
      ),
    );
  }
}

class CoinTickerCard extends StatelessWidget {
  const CoinTickerCard({
    Key key,
    @required this.coinRate,
    @required this.selectedCurrency,
    @required this.cryptoCurrency,
  }) : super(key: key);

  final int coinRate;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $coinRate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
