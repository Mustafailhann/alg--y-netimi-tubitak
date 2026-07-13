import os

target_dir = r'c:\Users\mustafa\Desktop\algı yönetimi\RealityLens\apps\client\lib\features'

translation_map = {
    # admin/presentation/assessment_list_page.dart
    "Assessments": "Değerlendirmeler",
    "No assessments found.": "Değerlendirme bulunamadı.",
    "Go to Media to Create Assessment": "Değerlendirme Oluşturmak İçin Medyaya Git",
    "Status: ${a.status}": "Durum: ${a.status}",
    "Mark as Ready": "Hazır Olarak İşaretle",
    "Marked as Ready": "Hazır Olarak İşaretlendi",
    "Failed to mark ready: $e": "Hazır olarak işaretlenemedi: $e",
    "Publish": "Yayınla",
    "Published successfully": "Başarıyla yayınlandı",
    "Failed to publish: $e": "Yayınlanamadı: $e",
    "Create Ground Truth": "Referans Veri Oluştur",
    "Is this media Real or Manipulated?": "Bu medya Gerçek mi yoksa Müdahaleli mi?",
    "Real": "Gerçek",
    "Manipulated": "Müdahaleli",
    "Select Category": "Kategori Seç",
    "Failed to load categories: $e": "Kategoriler yüklenemedi: $e",
    "Initial evaluation": "İlk değerlendirme",
    "Failed to load assessment details: $e": "Değerlendirme detayları yüklenemedi: $e",
    
    # category_list_page.dart
    "Categories": "Kategoriler",

    # media_details_page.dart
    "Create": "Oluştur",
    "Media Details": "Medya Detayları",
    "ID: ${media.id}": "ID: ${media.id}",
    "Question": "Soru",
    "Failed: $e": "Başarısız: $e",
    "Retry Processing": "İşlemi Yeniden Dene",
    "Failed to reprocess: $e": "Yeniden işlenemedi: $e",
    "Create Assessment": "Değerlendirme Oluştur",
    "Cancel": "İptal",
    "Reprocessing started successfully": "Yeniden işleme başarıyla başlatıldı",
    "Assessment created! Go to Assessments menu.": "Değerlendirme oluşturuldu! Değerlendirmeler menüsüne gidin.",
    
    # media_list_page.dart
    "Media": "Medya",
    "${m.mimeType} • ${(m.fileSize / 1024 / 1024).toStringAsFixed(2)} MB • Status: ${m.status}": "${m.mimeType} • ${(m.fileSize / 1024 / 1024).toStringAsFixed(2)} MB • Durum: ${m.status}",
    
    # media_upload_page.dart
    "Upload Media": "Medya Yükle",
    "Upload failed: $e": "Yükleme başarısız: $e",
    "Upload": "Yükle",
    "Select File": "Dosya Seç",
    "Selected: ${_selectedFile!.name}": "Seçilen: ${_selectedFile!.name}",
    "Upload successful!": "Yükleme başarılı!",
    
    # annotation_detail_page.dart
    "Annotation Detail": "İşaretleme Detayı",
    "Error: $error": "Hata: $error",

    # ground_truth_detail_page.dart
    "Failed to load annotations: $error": "İşaretlemeler yüklenemedi: $error",
    "No annotations yet.": "Henüz işaretleme yok.",
    "Ground Truth Detail": "Referans Veri Detayı",
    "Open Canvas": "Çizim Ekranını Aç",

    # ground_truth_list_page.dart
    "Ground Truth List": "Referans Veri Listesi",
    "No ground truths found.": "Referans veri bulunamadı.",
    "Judgment: ${gt.judgment} | Reason: ${gt.reason}": "Karar: ${gt.judgment} | Neden: ${gt.reason}",
    "Ground Truth: ${gt.id}": "Referans Veri: ${gt.id}",

    # annotation_canvas_page.dart
    "Annotation Canvas": "İşaretleme Ekranı",
    "Error loading media list: ${mediaSnapshot.error}": "Medya listesi yüklenirken hata: ${mediaSnapshot.error}",
    "Error loading assessment: ${snapshot.error}": "Değerlendirme yüklenirken hata: ${snapshot.error}",
    "Media not found": "Medya bulunamadı",
    "Ground Truth data missing.": "Referans veri eksik.",

    # floating_context_menu.dart
    "Delete": "Sil",
    "Duplicate": "Çoğalt",

    # canvas_toolbar.dart
    "Rectangle": "Dikdörtgen",
    "Polygon": "Çokgen",
    "Delete Selected": "Seçileni Sil",
    "Pan": "Kaydır",
    "Brush": "Fırça",
    "Select": "Seç",

    # login_page.dart
    "Email": "E-posta",
    "Password": "Şifre",
    "RealityLens Login": "RealityLens Giriş",
    "Login": "Giriş Yap",

    # join_session_screen.dart
    "Join Training Session": "Eğitim Oturumuna Katıl",
    "Join": "Katıl",
    "Student Portal": "Öğrenci Portalı",
    "Join Code": "Katılım Kodu",
    "Nickname": "Kullanıcı Adı",

    # student_mission_hub_screen.dart
    "Level 5 Investigator": "Seviye 5 Araştırmacı",
    "Enter a code from your teacher to start": "Başlamak için öğretmeninizden aldığınız kodu girin",
    "View Mock Results Screen": "Örnek Sonuç Ekranını Gör",
    "Join Live Training": "Canlı Eğitime Katıl",
    "Detective Alex": "Dedektif Alex",
    "Enter Code": "Kodu Gir",
    "Daily Missions": "Günlük Görevler",

    # student_session_screen.dart
    "Leave": "Ayrıl",
    "Leave Session?": "Oturumdan Ayrıl?",
    "Are you sure you want to leave this session? You will lose your current progress.": "Bu oturumdan ayrılmak istediğinize emin misiniz? Mevcut ilerlemenizi kaybedeceksiniz.",

    # session_monitor_page.dart
    "Next Question": "Sonraki Soru",
    "Session Monitor": "Oturum Yöneticisi",
    "End Session": "Oturumu Bitir",
    "Score: ${participant.score} • Progress: ${participant.progressPercentage}%": "Puan: ${participant.score} • İlerleme: %${participant.progressPercentage}",
    "Start Session": "Oturumu Başlat",
    
    # training_session_configuration_page.dart
    "Configure Session": "Oturumu Yapılandır",
    "Random Question Order": "Rastgele Soru Sırası",
    "Show Immediate Feedback": "Anında Geri Bildirim Göster",
    "Allow Retry": "Yeniden Denemeye İzin Ver",
    "Time Limit (Minutes, Optional)": "Süre Sınırı (Dakika, İsteğe Bağlı)",
    "Enable Leaderboard": "Liderlik Tablosunu Etkinleştir",
    "Create Session": "Oturum Oluştur",

    # pagination_bar.dart
    "Page $currentPage": "Sayfa $currentPage",
    "Load More": "Daha Fazla Yükle",

    # search_toolbar.dart
    "Search...": "Ara...",
    "Filter": "Filtrele"
}

def translate_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    new_content = content
    for eng, tr in translation_map.items():
        # Replace using single quotes
        new_content = new_content.replace(f"'{eng}'", f"'{tr}'")
        # Replace using double quotes
        new_content = new_content.replace(f'"{eng}"', f'"{tr}"')
        
    if new_content != content:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Translated: {os.path.basename(path)}")

for root, dirs, files in os.walk(target_dir):
    if 'presentation' in root.split(os.sep):
        for file in files:
            if file.endswith('.dart'):
                translate_file(os.path.join(root, file))

print("Translation completed.")
