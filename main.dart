void main(List<String> arguments) {
  //  for the test I used -> https://www.oanda.com/currency-converter/ru/?from=EUR&to=USD&amount=10
  print('Start');

  Currency euro = Euro(30.5358);
  Currency usd = Usd(27.0045);
  Currency uah = Uah();

  Wallet euroWallet = Wallet(currency: euro);
  Wallet usdWallet = Wallet(currency: usd);
  Wallet uahWallet = Wallet(currency: uah);

  euroWallet.addAmount(100);
  usdWallet.addAmount(100);
  uahWallet.addAmount(100);

  printWallets([euroWallet, usdWallet, uahWallet]);

  print("--------- FROM Euro to Ua wallet -----");
  euroWallet.transferTo(uahWallet, 10);
  printWallets([euroWallet, uahWallet]);

  print("--------- FROM USD to Ua wallet -----");
  usdWallet.transferTo(uahWallet, 10);
  printWallets([usdWallet, uahWallet]);

  // print("--------- FROM Euro to USD wallet -----");
  // euroWallet.transferTo(usdWallet, 10);
  // printWallets([euroWallet, usdWallet]);

  // CHANGE

  print("--------- CHANGE WALLET from Eero to uah ----");
  Currency euroToUah = Uah();
  euroWallet.changeWalletCurrency(euroToUah);
  printWallets([euroWallet]);

  print("--------- CHANGE WALLET from Usd to uah ----");
  Currency usdToUah = Uah();
  usdWallet.changeWalletCurrency(usdToUah);
  printWallets([usdWallet]);

  // print("--------- CHANGE WALLET from Eero to usd ----");
  // Currency euroToUsd = Usd(27.0045);
  // euroWallet.changeWalletCurrency(euroToUsd);
  // printWallets([euroWallet]);

  print("\nFINAL WALLETS");
  printWallets([euroWallet, usdWallet, uahWallet]);

}

void printWallets(List<Wallet> wallets) {
  for (var element in wallets) {
    print(element);
  }
}

// MONEY ******
abstract class Currency {
  String name;
  String symbol;
  double rateUah;

  Currency({required this.name, required this.symbol, required this.rateUah});

  @override
  String toString() {
    return "$name ($symbol), rate = $rateUah";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          symbol == other.symbol &&
          rateUah == other.rateUah;

  @override
  int get hashCode => name.hashCode ^ symbol.hashCode;
}

class Euro extends Currency {
  Euro(double rate) : super(name: "EURO", symbol: "eu", rateUah: rate);
}

class Usd extends Currency {
  Usd(double rate) : super(name: "USD", symbol: "\$", rateUah: rate);
}

class Uah extends Currency {
  Uah() : super(name: "UAH", symbol: "ua", rateUah: 1);
}

// WALLET *****
class Wallet {
  double _amount = 0;
  Currency currency;

  Wallet({required this.currency});

  void addAmount(double value) {
    _amount += value;
  }

  double getAmount() {
    return _amount;
  }

  void transferTo(Wallet wallet, double amount) {
    double sum = amount < _amount ? amount : _amount;
    double currSum = sum * currency.rateUah;
    double sendSum = currSum / wallet.currency.rateUah;
    wallet.addAmount(sendSum);
    _amount -= sum;
  }

  void changeWalletCurrency(Currency newCurrency) {
    if (newCurrency == currency) return;

    double currSum = _amount * currency.rateUah;
    double newSum = currSum / newCurrency.rateUah;
    currency = newCurrency;
    _amount = newSum;
  }

  double _getUa() {
    double sum = currency.rateUah * _amount;
    return sum;
  }

  @override
  String toString() {
    return "Wallet ($currency), sum = $_amount, UA = ${_getUa()}";
  }
}
