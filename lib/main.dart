import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MotosikletApp());
}

class MotosikletApp extends StatelessWidget {
  const MotosikletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RS 200 Pro',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const GarajSayfasi(),
    );
  }
}

class GarajSayfasi extends StatefulWidget {
  const GarajSayfasi({super.key});

  @override
  State<GarajSayfasi> createState() => _GarajSayfasiState();
}

class _GarajSayfasiState extends State<GarajSayfasi> {
  // Veri Tabanında Saklanacak Değişkenler
  int mevcutOdom_ = 0;
  int sonZincirBakim_ = 0;
  int sonYagDegisim_ = 0;
  String muayeneTarihi = "01/01/2026";
  String lastikBasinci = "Ön: 25 / Arka: 32 PSI";
  
  double alinanLitre = 0;
  double gidilenYol = 0;
  double ortalamaTuketim = 0;

  // Giriş Alanları İçin Kontrolcüler (Controllers)
  final TextEditingController _odoController = TextEditingController();
  final TextEditingController _litreController = TextEditingController();
  final TextEditingController _yolController = TextEditingController();
  final TextEditingController _muayeneController = TextEditingController();
  final TextEditingController _lastikController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  _verileriYukle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mevcutOdom_ = prefs.getInt('mevcutOdo') ?? 15000; // Başlangıç varsayılan KM
      sonZincirBakim_ = prefs.getInt('sonZincir') ?? 14800;
      sonYagDegisim_ = prefs.getInt('sonYag') ?? 12000;
      muayeneTarihi = prefs.getString('muayene') ?? "01/01/2026";
      lastikBasinci = prefs.getString('lastik') ?? "Ön: 25 / Arka: 32 PSI";
      
      alinanLitre = prefs.getDouble('litre') ?? 0;
      gidilenYol = prefs.getDouble('yol') ?? 0;

      // Controller'ların içini doldurma
      _odoController.text = mevcutOdom_.toString();
      _muayeneController.text = muayeneTarihi;
      _lastikController.text = lastikBasinci;
      
      if (alinanLitre > 0 && gidilenYol > 0) {
        _litreController.text = alinanLitre.toString();
        _yolController.text = gidilenYol.toString();
        ortalamaTuketim = (alinanLitre / gidilenYol) * 100;
      }
    });
  }

  _verileriKaydet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mevcutOdo', mevcutOdom_);
    await prefs.setInt('sonZincir', sonZincirBakim_);
    await prefs.setInt('sonYag', sonYagDegisim_);
    await prefs.setString('muayene', muayeneTarihi);
    await prefs.setString('lastik', lastikBasinci);
    await prefs.setDouble('litre', alinanLitre);
    await prefs.setDouble('yol', gidilenYol);
  }

  void yakitHesapla() {
    setState(() {
      if (alinanLitre > 0 && gidilenYol > 0) {
        ortalamaTuketim = (alinanLitre / gidilenYol) * 100;
      } else {
        ortalamaTuketim = 0;
      }
      _verileriKaydet();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kalan Bakım Hesaplamaları
    int zincirKalan = 300 - (mevcutOdom_ - sonZincirBakim_);
    int yagKalan = 5000 - (mevcutOdom_ - sonYagDegisim_);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('RS 200 PRO GARAJ', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)), 
        centerTitle: true, 
        backgroundColor: Colors.transparent, 
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1. KATMAN: FOTOĞRAF
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/rs200.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 2. KATMAN: SİYAH FİLTRE
          Container(color: Colors.black.withOpacity(0.35)),
          
          // 3. KATMAN: İÇERİK
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  // --- KİLOMETRE GİRİŞ ALANI ---
                  Card(
                    color: Colors.black.withOpacity(0.65),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.orange, width: 1.5)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _odoController,
                        decoration: const InputDecoration(
                          labelText: 'Motosikletin Güncel Kilometresi (ODO)',
                          prefixIcon: Icon(Icons.speed, color: Colors.orange),
                          border: InputBorder.none
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          setState(() {
                            mevcutOdom_ = int.tryParse(val) ?? 0;
                            _verileriKaydet();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // --- MENZİL KARTLARI ---
                  Row(
                    children: [
                      _kucukKart("Zincir Bakımına", "$zincirKalan KM", Icons.settings_backup_restore, Colors.orange, () {
                        setState(() => sonZincirBakim_ = mevcutOdom_);
                        _verileriKaydet();
                      }, "YAĞLADIM"),
                      const SizedBox(width: 10),
                      _kucukKart("Yağ Değişimine", "$yagKalan KM", Icons.oil_barrel, Colors.deepOrange, () {
                        setState(() => sonYagDegisim_ = mevcutOdom_);
                        _verileriKaydet();
                      }, "DEĞİŞTİRDİM"),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // --- YAKIT HESAPLAYICI ---
                  _bolumBasligi("YAKIT HESAPLAYICI"),
                  Card(
                    color: Colors.black.withOpacity(0.65),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.orange.withOpacity(0.3))),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _litreController,
                            decoration: const InputDecoration(labelText: 'Alınan Yakıt (Litre)', prefixIcon: Icon(Icons.gas_meter, color: Colors.orange)),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              alinanLitre = double.tryParse(val) ?? 0;
                              yakitHesapla();
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _yolController,
                            decoration: const InputDecoration(labelText: 'Gidilen Yol (KM)', prefixIcon: Icon(Icons.route, color: Colors.orange)),
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              gidilenYol = double.tryParse(val) ?? 0;
                              yakitHesapla();
                            },
                          ),
                          const SizedBox(height: 25),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Text("ORTALAMA TÜKETİM", style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
                                Text("${ortalamaTuketim.toStringAsFixed(2)} L / 100 KM", style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- AYARLANABİLİR DETAYLAR ---
                  _bolumBasligi("MOTOSİKLET DETAYLARI (DÜZENLENEBİLİR)"),
                  Card(
                    color: Colors.black.withOpacity(0.65),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.orange.withOpacity(0.2))),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _muayeneController,
                            decoration: const InputDecoration(labelText: 'Muayene Geçerlilik Tarihi', prefixIcon: Icon(Icons.calendar_today, color: Colors.orange)),
                            onChanged: (val) {
                              muayeneTarihi = val;
                              _verileriKaydet();
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _lastikController,
                            decoration: const InputDecoration(labelText: 'İdeal Lastik Basınçları', prefixIcon: Icon(Icons.tire_repair, color: Colors.orange)),
                            onChanged: (val) {
                              lastikBasinci = val;
                              _verileriKaydet();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text("Tekerine taş değmesin Miğraç! 🏍️", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kucukKart(String baslik, String deger, IconData ikon, Color renk, VoidCallback onReset, String butonYazisi) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.65),
          borderRadius: BorderRadius.circular(15), 
          border: Border.all(color: renk.withOpacity(0.4))
        ),
        child: Column(
          children: [
            Icon(ikon, color: renk, size: 28),
            const SizedBox(height: 5),
            Text(baslik, style: const TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
            Text(deger, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: renk)),
            const SizedBox(height: 5),
            TextButton(
              onPressed: onReset, 
              style: TextButton.styleFrom(backgroundColor: renk.withOpacity(0.15)),
              child: Text(butonYazisi, style: TextStyle(fontSize: 10, color: renk, fontWeight: FontWeight.bold))
            ),
          ],
        ),
      ),
    );
  }

  Widget _bolumBasligi(String t) => Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(bottom: 8, left: 5), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, letterSpacing: 1.1, fontSize: 12))));
}