import 'package:bitcoin_ticker/network_helper.dart';
import 'package:flutter/material.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const String coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const String apiKey = '2E965885-9950-4B77-8FEA-CAE39309BACA';

class CoinData {
  final String cryptoCurrency;
  final String normalCurrency;

  CoinData({
    @required this.cryptoCurrency,
    @required this.normalCurrency,
  });

  Future getCoinDataRate() async {
    String url = '$coinAPIURL/$cryptoCurrency/$normalCurrency?apikey=$apiKey';
    print(url);

    NetworkHelper networkHelper = NetworkHelper(url: url);
    var coinData = await networkHelper.getCoinDataFromURL();
    return coinData['rate'];
  }
}
