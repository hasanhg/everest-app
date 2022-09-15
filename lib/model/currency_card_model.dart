class CurrencyCardModel {
  String get name => _name;
  String get description => _description;
  DateTime get lastUpdatedAt => _lastUpdatedAt;
  double get buyPrice => _buyPrice;
  double get sellPrice => _sellPrice;
  double get difference => _difference;

  String _name = "";
  String _description = "";
  DateTime _lastUpdatedAt = DateTime.now();
  double _buyPrice = 0;
  double _sellPrice = 0;
  double _difference = 0;

  CurrencyCardModel();

  CurrencyCardModel.from(
    this._name,
    this._description,
    this._lastUpdatedAt,
    this._buyPrice,
    this._sellPrice,
    this._difference,
  );

  CurrencyCardModel.fromJSON(Map json)
      : _name = json["name"] ?? "",
        _description = json["description"] ?? "",
        _lastUpdatedAt =
            DateTime.tryParse(json["last_updated_at"] ?? "") ?? DateTime.now(),
        _buyPrice = json["buy_price"] ?? 0,
        _sellPrice = json["sell_price"] ?? 0,
        _difference = json["difference"] ?? 0;
}
