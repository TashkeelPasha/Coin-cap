import 'dart:convert';

import 'package:coincap/pages/Details.dart';
import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _device_height, _device_width;
  String? _selectedCoin = "bitcoin";

  HTTPSService? _http;
  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPSService>();
  }

  @override
  Widget build(BuildContext context) {
    _device_height = MediaQuery.of(context).size.height;
    _device_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [_selectedCoinDropDown(), _dataWidgets()],
        ),
      )),
    );
  }

  Widget _selectedCoinDropDown() {
    List<String> _coins = [
      "bitcoin",
      "ethereum",
      "tether",
      "cardano",
      "ripple"
    ];
    List<DropdownMenuItem<String>> _items = _coins
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ))
        .toList();
    return DropdownButton(
      value: _selectedCoin,
      items: _items,
      onChanged: (dynamic _value) {
        setState(() {
          _selectedCoin = _value;
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      iconSize: 30,
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
      future: _http!.get("/coins/$_selectedCoin"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          Map _data = jsonDecode(_snapshot.data.toString());
          num _usd = _data["market_data"]["current_price"]["usd"];
          num _change = _data["market_data"]["price_change_percentage_24h"];
          Map _exchangeRates = _data["market_data"]["current_price"];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsPage(
                              rates: _exchangeRates,
                            )),
                  );
                },
                child: _coinImage(_data["image"]["large"]),
              ),
              _currentPriceWidget(_usd),
              percentageChange(_change),
              _description(_data["description"]["en"]),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num rate) {
    return Text(
      "${rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget percentageChange(num _change) {
    return Text(
      "${_change.toString()} % ",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _coinImage(String _url) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _device_height! * 0.05,
      ),
      height: _device_height! * 0.15,
      width: _device_width! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(_url)),
      ),
    );
  }

  Widget _description(String _description) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: _device_height! * 0.45,
        width: _device_width! * 0.90,
        margin: EdgeInsets.symmetric(
          vertical: _device_height! * 0.05,
        ),
        padding: EdgeInsets.symmetric(
          vertical: _device_height! * 0.01,
          horizontal: _device_height! * 0.01,
        ),
        child: Text(
          _description,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
