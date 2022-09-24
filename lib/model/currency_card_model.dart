class CurrencyCardModel {
  String get name => _name;
  String? get description => _description;
  DateTime get lastUpdatedAt => _lastUpdatedAt;
  double get buyPrice => _buyPrice;
  double get sellPrice => _sellPrice;
  double get difference => _difference;
  String? get buyDir => _buyDir;
  String? get sellDir => _sellDir;

  String _name = "";
  String? _description = "";
  DateTime _lastUpdatedAt = DateTime.now();
  double _buyPrice = 0;
  double _sellPrice = 0;
  double _difference = 0;
  String? _buyDir;
  String? _sellDir;

  CurrencyCardModel();

  CurrencyCardModel.from(
    this._name,
    this._description,
    this._lastUpdatedAt,
    this._buyPrice,
    this._sellPrice,
    this._difference,
    this._buyDir,
    this._sellDir,
  );

  CurrencyCardModel.fromJSON(Map json)
      : _name = json["code"] ?? "",
        _description = json["description"],
        _lastUpdatedAt =
            DateTime.tryParse(json["tarih"] ?? "") ?? DateTime.now(),
        _buyPrice = json["alis"] is num
            ? json["alis"].toDouble()
            : double.tryParse(json["alis"]) ?? 0,
        _sellPrice = json["satis"] is num
            ? json["satis"].toDouble()
            : double.tryParse(json["satis"]) ?? 0,
        _buyDir = json["dir"]["alis_dir"],
        _sellDir = json["dir"]["satis_dir"] {
    _difference =
        (((_buyPrice - json["kapanis"]) * 100 / json["kapanis"]) * 100)
                .roundToDouble() /
            100;
    if (_buyDir?.isEmpty ?? false) _buyDir = null;
    if (_sellDir?.isEmpty ?? false) _sellDir = null;
  }
}
