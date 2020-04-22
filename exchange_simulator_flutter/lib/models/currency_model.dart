class Timestamp{
  DateTime date;
  double exchangeRate;

  Timestamp(this.date, this.exchangeRate);

  Timestamp.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    exchangeRate = json['exchangeRate'];
  }

  @override
  String toString() => '{ date: $date, exchangeRate: $exchangeRate}';

}

class Currency{
  String id;
  String name;
  String symbol;
  List<Timestamp> timestamps;

  Currency(this.id, this.name, this.symbol, this.timestamps);

  Currency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
    if (json['timestamps'] != null) {
      timestamps = new List<Timestamp>();
      json['timestamps'].forEach((v) {
        timestamps.add(new Timestamp.fromJson(v));
      });
    }
  }

  double getCurrentExchangeRate(){
    this.timestamps.sort((Timestamp a, Timestamp b) => b.date.compareTo(a.date));
    return this.timestamps[0].exchangeRate;
  }

  @override
  String toString() => '{ id: $id, name: $name, symbol: $symbol, timestamps: $timestamps}';
}