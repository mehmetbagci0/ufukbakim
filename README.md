# Ufuk Asansör Bakım (MVP)

Bu depo, yalnızca şu akışa odaklanan Flutter MVP içerir:
- Bakım gruplarını yönetme
- Bina/konum kayıtlarını gruplara bağlama
- Grup bazlı filtreleme
- Binayı Google Maps'te açma

## Özellikler

### 1) Bakım Grupları
- Grup ekle / listele / düzenle / sil
- Grup satırında bina sayısı gösterimi
- İçinde bina olan grup silinemez

### 2) Binalar / Konumlar
- Bina ekle / listele / düzenle / sil
- Her bina tam olarak bir gruba bağlıdır
- Zorunlu alanlar: bina adı, adres, il, ilçe, grup
- Opsiyonel alanlar: mahalle, enlem, boylam, telefon, not

### 3) Grup Filtresi
- Binalar ekranında "Grup filtrele" ile yalnızca seçilen gruptaki binalar listelenir
- Filtre seçeneklerinde grup başına bina adedi gösterilir (`Grup Adı (20)`)

### 4) Bina Detayı + Navigasyon
- Bina detay ekranı tüm alanları gösterir
- "Google Maps’te Aç" butonu:
  - Enlem/boylam varsa koordinatla açar
  - Yoksa tam adres sorgusu ile açar

## Kurulum

> Not: Bu ortamda Flutter SDK olmadığı için komutlar çalıştırılamadı. Aşağıdaki adımları Flutter yüklü bir makinede uygulayın.

1. Flutter SDK kurun (stable kanal).
2. Repo kökünde çalıştırın:

```bash
flutter pub get
flutter run
```

Eğer repo yeni ve platform klasörleri (`android/`, `ios/`) eksikse bir kez şu komutu çalıştırın:

```bash
flutter create .
```

## Hızlı Manuel Test Adımları
1. Uygulamayı açın.
2. **Gruplar** sekmesinden `1. Grup` oluşturun.
3. **Binalar** sekmesinde **Bina Ekle** ile bu gruba bir bina ekleyin.
4. Grup filtresinden `1. Grup` seçin, sadece bu grubun binalarının göründüğünü doğrulayın.
5. Binaya girip **Google Maps’te Aç** butonuna tıklayın.
6. Grup ve bina için düzenle/sil işlemlerini test edin.

## Kısıtlar
- Bu MVP sürümünde veri saklama **in-memory** çalışır; uygulama kapanınca veriler sıfırlanır.
- Kimlik doğrulama/rol yönetimi bu kapsam dışında bırakılmıştır.
