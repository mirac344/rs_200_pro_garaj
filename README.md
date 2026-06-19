# 🏍️ RS 200 PRO GARAJ

Pulsar RS 200 motosiklet kullanıcıları için özel olarak tasarlanmış, bakım periyotlarını ve yakıt tüketimini anlık olarak takip eden dinamik bir mobil/masaüstü garaj yönetim uygulamasıdır. 

Bu proje, bir **Bilgisayar Mühendisliği** çalışması olarak veri kalıcılığı ve dinamik arayüz yönetimi prensipleri doğrultusunda geliştirilmiştir.

---

## 🚀 Öne Çıkan Özellikler

* **Dinamik Kilometre (ODO) Takibi:** Motosikletin güncel kilometresini girdiğinizde, bakım periyotları (zincir, yağ) otomatik olarak hesaplanır.
* **Anlık Yakıt Hesaplayıcı:** Alınan yakıt ve gidilen yol bilgisi girildiği an, 100 KM'deki ortalama tüketim saliseler içinde arayüzde güncellenir.
* **Veri Kalıcılığı (Data Persistence):** Girilen güncel kilometre, bakım durumları, muayene tarihi ve lastik basıncı gibi kritik veriler uygulama kapatılsa dahi hafızada saklanır.
* **Düzenlenebilir Detaylar Paneli:** Muayene geçerlilik tarihi ve ideal lastik basınçları uygulama içerisinden dinamik olarak klavyeyle güncellenebilir.
* **Özel Gece Sürüşü Teması:** Motosiklet ruhuna uygun, şeffaf kart katmanları ve turuncu detaylarla optimize edilmiş karanlık arayüz tasarımı.

---

## 🛠️ Kullanılan Teknolojiler

* **Framework:** [Flutter](https://flutter.dev) (Dart)
* **Veri Tabanı / Kalıcılık:** `SharedPreferences` (Lokal Key-Value Storage)
* **State Management:** `setState` (Dinamik Arayüz Yönetimi)
* **Varlık Yönetimi:** Yerel Asset Yönetimi (AssetImage)

---

## 📦 Kurulum ve Çalıştırma

Projeyi yerel bilgisayarınızda çalıştırmak için aşağıdaki adımları takip edebilirsiniz:

1. Bu depoyu klonlayın:
   ```bash
   git clone [https://github.com/mirac344/rs_200_pro_garaj.git](https://github.com/mirac344/rs_200_pro_garaj.git)