import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final List<String> currencies = ['USD', 'EUR', 'IDR', 'JPY', 'GBP'];
  String fromCurrency = 'USD';
  String toCurrency = 'IDR';
  String result = '';
  TextEditingController amountController = TextEditingController();

  Future<void> _convertCurrency() async {
    final url =
        'https://api.exchangerate-api.com/v4/latest/$fromCurrency';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rate = data['rates'][toCurrency];
      final amount = double.tryParse(amountController.text) ?? 0;
      setState(() {
        result = '${(amount * rate).toStringAsFixed(2)} $toCurrency';
      });
    } else {
      setState(() {
        result = 'Error converting currency';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Currency Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            Row(
              children: [
                DropdownButton<String>(
                  value: fromCurrency,
                  items: currencies
                      .map((currency) =>
                          DropdownMenuItem(value: currency, child: Text(currency)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      fromCurrency = value!;
                    });
                  },
                ),
                Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: toCurrency,
                  items: currencies
                      .map((currency) =>
                          DropdownMenuItem(value: currency, child: Text(currency)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      toCurrency = value!;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: Text('Convert'),
            ),
            SizedBox(height: 16),
            Text(
              result,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
