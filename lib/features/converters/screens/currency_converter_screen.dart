import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../core/theme/app_colors.dart';

class CurrencyConverterScreen extends StatefulWidget {
  CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController(text: "1");
  String _result = "";
  String _fromUnit = "USD";
  String _toUnit = "IDR";
  late AnimationController _animController;
  late Animation<double> _resultAnim;

  Map<String, double> _rates = {};
  List<String> _units = [];
  bool _isLoading = true;
  String _lastUpdated = "";

  // Currency flag emoji map
  final Map<String, String> _flagEmoji = {
    'USD': '🇺🇸', 'EUR': '🇪🇺', 'GBP': '🇬🇧', 'JPY': '🇯🇵', 'IDR': '🇮🇩',
    'MYR': '🇲🇾', 'SGD': '🇸🇬', 'AUD': '🇦🇺', 'CAD': '🇨🇦', 'CHF': '🇨🇭',
    'CNY': '🇨🇳', 'HKD': '🇭🇰', 'INR': '🇮🇳', 'KRW': '🇰🇷', 'THB': '🇹🇭',
    'PHP': '🇵🇭', 'NZD': '🇳🇿', 'BRL': '🇧🇷', 'SEK': '🇸🇪', 'NOK': '🇳🇴',
    'DKK': '🇩🇰', 'ZAR': '🇿🇦', 'TRY': '🇹🇷', 'RUB': '🇷🇺', 'MXN': '🇲🇽',
    'PLN': '🇵🇱', 'CZK': '🇨🇿', 'HUF': '🇭🇺', 'ILS': '🇮🇱', 'ISK': '🇮🇸',
    'BGN': '🇧🇬', 'RON': '🇷🇴', 'HRK': '🇭🇷',
  };

  final Map<String, String> _currencyNames = {
    'USD': 'Amerika Serikat (USD)', 'AED': 'Uni Emirat Arab (AED)', 'AFN': 'Afganistan (AFN)', 'ALL': 'Albania (ALL)', 'AMD': 'Armenia (AMD)', 'ANG': 'Antilla Belanda (ANG)', 'AOA': 'Angola (AOA)', 'ARS': 'Argentina (ARS)', 'AUD': 'Australia (AUD)', 'AWG': 'Aruba (AWG)', 'AZN': 'Azerbaijan (AZN)', 'BAM': 'Bosnia-Herzegovina (BAM)', 'BBD': 'Barbados (BBD)', 'BDT': 'Bangladesh (BDT)', 'BGN': 'Bulgaria (BGN)', 'BHD': 'Bahrain (BHD)', 'BIF': 'Burundi (BIF)', 'BMD': 'Bermuda (BMD)', 'BND': 'Brunei (BND)', 'BOB': 'Bolivia (BOB)', 'BRL': 'Brasil (BRL)', 'BSD': 'Bahama (BSD)', 'BTN': 'Bhutan (BTN)', 'BWP': 'Botswana (BWP)', 'BYN': 'Belarus (BYN)', 'BZD': 'Belize (BZD)', 'CAD': 'Kanada (CAD)', 'CDF': 'Kongo (CDF)', 'CHF': 'Swiss (CHF)', 'CLF': 'Chile (CLF)', 'CLP': 'Cile (CLP)', 'CNH': 'China (CNH)', 'CNY': 'China (CNY)', 'COP': 'Kolombia (COP)', 'CRC': 'Kosta Rika (CRC)', 'CUP': 'Kuba (CUP)', 'CVE': 'Tanjung Verde (CVE)', 'CZK': 'Ceko (CZK)', 'DJF': 'Djibouti (DJF)', 'DKK': 'Denmark (DKK)', 'DOP': 'Dominika (DOP)', 'DZD': 'Aljazair (DZD)', 'EGP': 'Mesir (EGP)', 'ERN': 'Eritrea (ERN)', 'ETB': 'Etiopia (ETB)', 'EUR': 'Eropa (EUR)', 'FJD': 'Fiji (FJD)', 'FKP': 'Kep. Falkland (FKP)', 'FOK': 'Kep. Faroe (FOK)', 'GBP': 'Inggris (GBP)', 'GEL': 'Georgia (GEL)', 'GGP': 'Guernsey (GGP)', 'GHS': 'Ghana (GHS)', 'GIP': 'Gibraltar (GIP)', 'GMD': 'Gambia (GMD)', 'GNF': 'Guinea (GNF)', 'GTQ': 'Guatemala (GTQ)', 'GYD': 'Guyana (GYD)', 'HKD': 'Hong Kong (HKD)', 'HNL': 'Honduras (HNL)', 'HRK': 'Kroasia (HRK)', 'HTG': 'Haiti (HTG)', 'HUF': 'Hungaria (HUF)', 'IDR': 'Indonesia (IDR)', 'ILS': 'Israel (ILS)', 'IMP': 'Isle of Man (IMP)', 'INR': 'India (INR)', 'IQD': 'Irak (IQD)', 'IRR': 'Iran (IRR)', 'ISK': 'Islandia (ISK)', 'JEP': 'Jersey (JEP)', 'JMD': 'Jamaika (JMD)', 'JOD': 'Yordania (JOD)', 'JPY': 'Jepang (JPY)', 'KES': 'Kenya (KES)', 'KGS': 'Kirgizstan (KGS)', 'KHR': 'Kamboja (KHR)', 'KID': 'Kiribati (KID)', 'KMF': 'Komoro (KMF)', 'KRW': 'Korea Selatan (KRW)', 'KWD': 'Kuwait (KWD)', 'KYD': 'Kep. Cayman (KYD)', 'KZT': 'Kazakhstan (KZT)', 'LAK': 'Laos (LAK)', 'LBP': 'Lebanon (LBP)', 'LKR': 'Sri Lanka (LKR)', 'LRD': 'Liberia (LRD)', 'LSL': 'Lesotho (LSL)', 'LYD': 'Libya (LYD)', 'MAD': 'Maroko (MAD)', 'MDL': 'Moldova (MDL)', 'MGA': 'Madagaskar (MGA)', 'MKD': 'Makedonia (MKD)', 'MMK': 'Myanmar (MMK)', 'MNT': 'Mongolia (MNT)', 'MOP': 'Makau (MOP)', 'MRU': 'Mauritania (MRU)', 'MUR': 'Mauritius (MUR)', 'MVR': 'Maladewa (MVR)', 'MWK': 'Malawi (MWK)', 'MXN': 'Meksiko (MXN)', 'MYR': 'Malaysia (MYR)', 'MZN': 'Mozambik (MZN)', 'NAD': 'Namibia (NAD)', 'NGN': 'Nigeria (NGN)', 'NIO': 'Nikaragua (NIO)', 'NOK': 'Norwegia (NOK)', 'NPR': 'Nepal (NPR)', 'NZD': 'Selandia Baru (NZD)', 'OMR': 'Oman (OMR)', 'PAB': 'Panama (PAB)', 'PEN': 'Peru (PEN)', 'PGK': 'Papua Nugini (PGK)', 'PHP': 'Filipina (PHP)', 'PKR': 'Pakistan (PKR)', 'PLN': 'Polandia (PLN)', 'PYG': 'Paraguay (PYG)', 'QAR': 'Qatar (QAR)', 'RON': 'Rumania (RON)', 'RSD': 'Serbia (RSD)', 'RUB': 'Rusia (RUB)', 'RWF': 'Rwanda (RWF)', 'SAR': 'Arab Saudi (SAR)', 'SBD': 'Kep. Solomon (SBD)', 'SCR': 'Seychelles (SCR)', 'SDG': 'Sudan (SDG)', 'SEK': 'Swedia (SEK)', 'SGD': 'Singapura (SGD)', 'SHP': 'Saint Helena (SHP)', 'SLE': 'Sierra Leone (SLE)', 'SLL': 'Sierra Leone (SLL)', 'SOS': 'Somalia (SOS)', 'SRD': 'Suriname (SRD)', 'SSP': 'Sudan Selatan (SSP)', 'STN': 'Sao Tome & Principe (STN)', 'SYP': 'Suriah (SYP)', 'SZL': 'Eswatini (SZL)', 'THB': 'Thailand (THB)', 'TJS': 'Tajikistan (TJS)', 'TMT': 'Turkmenistan (TMT)', 'TND': 'Tunisia (TND)', 'TOP': 'Tonga (TOP)', 'TRY': 'Turki (TRY)', 'TTD': 'Trinidad & Tobago (TTD)', 'TVD': 'Tuvalu (TVD)', 'TWD': 'Taiwan (TWD)', 'TZS': 'Tanzania (TZS)', 'UAH': 'Ukraina (UAH)', 'UGX': 'Uganda (UGX)', 'UYU': 'Uruguay (UYU)', 'UZS': 'Uzbekistan (UZS)', 'VES': 'Venezuela (VES)', 'VND': 'Vietnam (VND)', 'VUV': 'Vanuatu (VUV)', 'WST': 'Samoa (WST)', 'XAF': 'CFA Franc Afrika Tengah (XAF)', 'XCD': 'Dolar Karibia Timur (XCD)', 'XCG': 'Caribbean Guilder (XCG)', 'XDR': 'Special Drawing Rights (XDR)', 'XOF': 'CFA Franc Afrika Barat (XOF)', 'XPF': 'CFP Franc (XPF)', 'YER': 'Yaman (YER)', 'ZAR': 'Afrika Selatan (ZAR)', 'ZMW': 'Zambia (ZMW)', 'ZWG': 'Zimbabwe (ZWG)', 'ZWL': 'Zimbabwe (ZWL)'
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _resultAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _fetchRates();
    _inputController.addListener(_calculate);
  }

  @override
  void dispose() {
    _animController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _fetchRates() async {
    try {
      final res = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
      if (res.statusCode == 200) {
        _parseData(res.body);
        _lastUpdated = "Live";
      } else {
        await _loadFallback();
      }
    } catch (_) {
      await _loadFallback();
    }
  }

  Future<void> _loadFallback() async {
    final Map<String, double> fallbackRates = {"USD":1,"AED":3.67,"AFN":63.64,"ALL":82.12,"AMD":368.26,"ANG":1.79,"AOA":921.69,"ARS":1430.81,"AUD":1.42,"AWG":1.79,"AZN":1.7,"BAM":1.69,"BBD":2,"BDT":122.84,"BGN":1.69,"BHD":0.376,"BIF":2983.4,"BMD":1,"BND":1.28,"BOB":6.91,"BRL":5.08,"BSD":1,"BTN":95.18,"BWP":13.49,"BYN":2.77,"BZD":2,"CAD":1.4,"CDF":2300.32,"CHF":0.795,"CLF":0.0229,"CLP":904.15,"CNH":6.77,"CNY":6.77,"COP":3503.09,"CRC":457,"CUP":24,"CVE":95.18,"CZK":20.85,"DJF":177.72,"DKK":6.44,"DOP":58.63,"DZD":133.35,"EGP":51.62,"ERN":15,"ETB":158.68,"EUR":0.863,"FJD":2.22,"FKP":0.745,"FOK":6.44,"GBP":0.745,"GEL":2.66,"GGP":0.745,"GHS":11.14,"GIP":0.745,"GMD":74.17,"GNF":8770.43,"GTQ":7.63,"GYD":209.18,"HKD":7.84,"HNL":26.76,"HRK":6.5,"HTG":130.62,"HUF":303.8,"IDR":18095.70,"ILS":2.92,"IMP":0.745,"INR":95.18,"IQD":1312.08,"IRR":1134320.63,"ISK":124.49,"JEP":0.745,"JMD":158.12,"JOD":0.709,"JPY":160.14,"KES":129.45,"KGS":87.46,"KHR":4039.05,"KID":1.42,"KMF":424.65,"KRW":1516.97,"KWD":0.308,"KYD":0.833,"KZT":488.75,"LAK":21936.52,"LBP":89500,"LKR":334.67,"LRD":182.5,"LSL":16.23,"LYD":6.37,"MAD":9.26,"MDL":17.38,"MGA":4205.81,"MKD":53.27,"MMK":2103.29,"MNT":3601.21,"MOP":8.07,"MRU":40.05,"MUR":47.41,"MVR":15.45,"MWK":1737.1,"MXN":17.19,"MYR":4.06,"MZN":63.6,"NAD":16.23,"NGN":1360.33,"NIO":36.79,"NOK":9.51,"NPR":152.28,"NZD":1.71,"OMR":0.384,"PAB":1,"PEN":3.4,"PGK":4.38,"PHP":60.75,"PKR":278.36,"PLN":3.67,"PYG":6147.87,"QAR":3.64,"RON":4.53,"RSD":101.42,"RUB":72.53,"RWF":1464.72,"SAR":3.75,"SBD":7.96,"SCR":14.56,"SDG":458.45,"SEK":9.42,"SGD":1.28,"SHP":0.745,"SLE":24.56,"SLL":24562.24,"SOS":571.8,"SRD":37.44,"SSP":4712.03,"STN":21.15,"SYP":112.51,"SZL":16.23,"THB":32.66,"TJS":9.31,"TMT":3.5,"TND":2.92,"TOP":2.38,"TRY":46.31,"TTD":6.79,"TVD":1.42,"TWD":31.6,"TZS":2619.18,"UAH":44.87,"UGX":3738.37,"UYU":40.46,"UZS":11867.22,"VES":587.41,"VND":26184.79,"VUV":119.14,"WST":2.71,"XAF":566.2,"XCD":2.7,"XCG":1.79,"XDR":0.732,"XOF":566.2,"XPF":103,"YER":238.85,"ZAR":16.23,"ZMW":17.54,"ZWG":26.77,"ZWL":26.77};

    setState(() {
      _rates = fallbackRates;
      _units = fallbackRates.keys.toList()..sort();
      _isLoading = false;
      _lastUpdated = "Offline";
    });
    _calculate();
  }

  void _parseData(String jsonStr) {
    final data = jsonDecode(jsonStr);
    final ratesMap = data['rates'] as Map<String, dynamic>;

    Map<String, double> parsedRates = {};
    parsedRates['USD'] = 1.0;

    ratesMap.forEach((key, value) {
      parsedRates[key] = (value as num).toDouble();
    });

    // Enforce custom IDR rate
    parsedRates['IDR'] = 18095.70;

    setState(() {
      _rates = parsedRates;
      _units = parsedRates.keys.toList()..sort();
      _isLoading = false;
    });
    _calculate();
  }

  void _calculate() {
    if (_rates.isEmpty) return;

    String cleanText = _inputController.text.replaceAll('.', '').replaceAll(',', '.');
    double value = double.tryParse(cleanText) ?? 0.0;
    double inUsd = value / (_rates[_fromUnit] ?? 1.0);
    double outValue = inUsd * (_rates[_toUnit] ?? 1.0);

    setState(() {
      _result = _formatCurrency(outValue);
    });
    _animController.reset();
    _animController.forward();
  }

  String _formatCurrency(double v) {
    if (v == 0) return "0";
    String str = v.toStringAsFixed(2);
    List<String> parts = str.split('.');
    String intPart = parts[0];
    String decPart = parts.length > 1 ? parts[1] : '';

    while (decPart.endsWith('0')) {
      decPart = decPart.substring(0, decPart.length - 1);
    }

    intPart = intPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    if (decPart.isEmpty) {
      return intPart;
    } else {
      return '$intPart,$decPart';
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });
    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Konverter Valuta"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.numberText),
        actions: [
          if (_lastUpdated.isNotEmpty)
            Center(
              child: Container(
                margin: EdgeInsets.only(right: 16),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _lastUpdated == "Live"
                    ? AppColors.accentGreen.withOpacity(0.15)
                    : AppColors.accentOrange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _lastUpdated == "Live" ? AppColors.accentGreen : AppColors.accentOrange,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      _lastUpdated,
                      style: TextStyle(
                        color: _lastUpdated == "Live" ? AppColors.accentGreen : AppColors.accentOrange,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.accentCyan),
                    strokeWidth: 2,
                  ),
                  SizedBox(height: 16),
                  Text("Memuat kurs...", style: TextStyle(color: AppColors.previewText)),
                ],
              ),
            )
          : Stack(
              children: [
                Positioned(
                  top: -80, left: -60,
                  child: Container(
                    width: 200, height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        AppColors.accentGreen.withOpacity(0.08),
                        Colors.transparent,
                      ]),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Input
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.accentGreen.withOpacity(0.2)),
                          ),
                          child: TextField(
                            controller: _inputController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(color: AppColors.numberText, fontSize: 28, fontWeight: FontWeight.w500, height: 1.2),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              hintText: "Jumlah",
                              hintStyle: TextStyle(color: AppColors.previewText.withOpacity(0.5), fontSize: 20, height: 1.2),
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                        // Currency selectors
                        Row(
                          children: [
                            Expanded(child: _buildCurrencySelector(context, _fromUnit, (v) {
                              setState(() => _fromUnit = v!);
                              _calculate();
                            })),
                            GestureDetector(
                              onTap: _swapCurrencies,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.accentGreen.withOpacity(0.2), AppColors.accentCyan.withOpacity(0.2)],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.swap_horiz_rounded, color: AppColors.accentGreen, size: 24),
                              ),
                            ),
                            Expanded(child: _buildCurrencySelector(context, _toUnit, (v) {
                              setState(() => _toUnit = v!);
                              _calculate();
                            })),
                          ],
                        ),
                        SizedBox(height: 50),
                        // Result
                        FadeTransition(
                          opacity: _resultAnim,
                          child: ScaleTransition(
                            scale: _resultAnim,
                          child: Column(
                            children: [
                              Text("Hasil Konversi", style: TextStyle(color: AppColors.previewText, fontSize: 14, letterSpacing: 1)),
                              SizedBox(height: 10),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      _flagEmoji[_toUnit] ?? '💱',
                                      style: TextStyle(fontSize: 32),
                                    ),
                                    SizedBox(width: 10),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [AppColors.accentGreen, AppColors.accentCyan],
                                        ).createShader(bounds),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            _result,
                                            style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: 1.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      _toUnit,
                                      style: TextStyle(color: AppColors.previewText, fontSize: 18, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              // Exchange rate info
                              if (_rates.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "1 $_fromUnit = ${(_rates[_toUnit]! / _rates[_fromUnit]!).toStringAsFixed(4)} $_toUnit",
                                    style: TextStyle(color: AppColors.previewText, fontSize: 13),
                                  ),
                                ),
                            ],
                          ),
                        ),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCurrencySelector(BuildContext context, String value, ValueChanged<String?> onChanged) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          isScrollControlled: true,
          builder: (ctx) => _CurrencyPickerModal(
            units: _units,
            currentValue: value,
            flagEmoji: _flagEmoji,
            currencyNames: _currencyNames,
            onChanged: onChanged,
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.numberText.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(_flagEmoji[value] ?? '💱', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currencyNames[value] ?? value,
                      style: TextStyle(color: AppColors.numberText, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.previewText),
          ],
        ),
      ),
    );
  }
}

class _CurrencyPickerModal extends StatefulWidget {
  final List<String> units;
  final String currentValue;
  final Map<String, String> flagEmoji;
  final Map<String, String> currencyNames;
  final ValueChanged<String?> onChanged;

  const _CurrencyPickerModal({
    Key? key,
    required this.units,
    required this.currentValue,
    required this.flagEmoji,
    required this.currencyNames,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<_CurrencyPickerModal> createState() => _CurrencyPickerModalState();
}

class _CurrencyPickerModalState extends State<_CurrencyPickerModal> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredUnits = widget.units.where((u) {
      final name = widget.currencyNames[u] ?? u;
      return name.toLowerCase().contains(_searchQuery.toLowerCase()) || u.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          Container(width: 40, height: 5, decoration: BoxDecoration(color: AppColors.previewText.withOpacity(0.3), borderRadius: BorderRadius.circular(4))),
          SizedBox(height: 16),
          Text("Pilih Mata Uang", style: TextStyle(color: AppColors.numberText, fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TextField(
            style: TextStyle(color: AppColors.numberText),
            decoration: InputDecoration(
              hintText: "Cari negara atau kode (USD, EUR...)",
              hintStyle: TextStyle(color: AppColors.previewText),
              prefixIcon: Icon(Icons.search, color: AppColors.previewText),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUnits.length,
              itemBuilder: (ctx, index) {
                final u = filteredUnits[index];
                final isSelected = u == widget.currentValue;
                return ListTile(
                  onTap: () {
                    Navigator.pop(ctx);
                    widget.onChanged(u);
                  },
                  leading: Text(widget.flagEmoji[u] ?? '💱', style: TextStyle(fontSize: 28)),
                  title: Text(widget.currencyNames[u] ?? u, style: TextStyle(color: AppColors.numberText, fontSize: 16)),
                  trailing: isSelected ? Icon(Icons.check_circle, color: AppColors.accentGreen) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: isSelected ? AppColors.accentGreen.withOpacity(0.1) : Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
