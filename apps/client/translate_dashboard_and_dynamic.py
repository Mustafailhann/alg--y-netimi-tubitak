import os

# 1. Translate Dashboard Page
dashboard_path = r'c:\Users\mustafa\Desktop\algı yönetimi\RealityLens\apps\client\lib\features\dashboard\dashboard_page.dart'
with open(dashboard_path, 'r', encoding='utf-8') as f:
    content = f.read()

dashboard_map = {
    'Teacher Analytics Dashboard': 'Öğretmen Analiz Paneli',
    'Overview': 'Genel Bakış',
    'Active Sessions': 'Aktif Oturumlar',
    'Total Students': 'Toplam Öğrenci',
    'Average Score': 'Ortalama Puan',
    'Hardest Assessment': 'En Zor Değerlendirme',
    'Recent Activity': 'Son Aktiviteler',
    'Student #': 'Öğrenci #',
    ' completed "Deepfake Identification"': ' "Deepfake Tespiti" görevini tamamladı',
    ' minutes ago': ' dakika önce',
    'Score: ': 'Puan: ',
    'Quick Actions': 'Hızlı İşlemler',
    'Create Training Pack': 'Eğitim Paketi Oluştur',
    'Review Assessments': 'Değerlendirmeleri İncele'
}

for eng, tr in dashboard_map.items():
    content = content.replace(f"'{eng}'", f"'{tr}'")
    content = content.replace(f'"{eng}"', f'"{tr}"')

with open(dashboard_path, 'w', encoding='utf-8') as f:
    f.write(content)


# 2. Translate Categories in category_list_page.dart
category_path = r'c:\Users\mustafa\Desktop\algı yönetimi\RealityLens\apps\client\lib\features\admin\presentation\category_list_page.dart'
with open(category_path, 'r', encoding='utf-8') as f:
    cat_content = f.read()

# Replace:
# final c = categories[index];
# return ListTile(
#   title: Text(c.name),
#   subtitle: Text(c.description),
# );
# With:
# final c = categories[index];
# String nameTr = c.name == 'FaceSwap' ? 'Yüz Değiştirme (FaceSwap)' : c.name;
# String descTr = c.description == 'Replacing one person\\'s face with another (deepfake)' 
#     ? 'Bir kişinin yüzünü başka bir yüzle değiştirme (deepfake)' : c.description;
# return ListTile(
#   title: Text(nameTr),
#   subtitle: Text(descTr),
# );

cat_target = """            final c = categories[index];
            return ListTile(
              title: Text(c.name),
              subtitle: Text(c.description),
            );"""

cat_replacement = """            final c = categories[index];
            String nameTr = c.name == 'FaceSwap' ? 'Yüz Değiştirme (FaceSwap)' : c.name;
            String descTr = c.description == 'Replacing one person\\'s face with another (deepfake)' 
                ? 'Bir kişinin yüzünü başka bir yüzle değiştirme (deepfake)' : c.description;
            return ListTile(
              title: Text(nameTr),
              subtitle: Text(descTr),
            );"""

if cat_target in cat_content:
    cat_content = cat_content.replace(cat_target, cat_replacement)
    with open(category_path, 'w', encoding='utf-8') as f:
        f.write(cat_content)


# 3. Translate Ground Truth dynamic data in ground_truth_list_page.dart
gt_path = r'c:\Users\mustafa\Desktop\algı yönetimi\RealityLens\apps\client\lib\features\annotation\presentation\ground_truth_list_page.dart'
with open(gt_path, 'r', encoding='utf-8') as f:
    gt_content = f.read()

# Replace:
# subtitle: Text('Karar: ${gt.judgment} | Neden: ${gt.reason}'),
# With:
# String judgmentTr = gt.judgment == 'Manipulated' ? 'Müdahaleli' : (gt.judgment == 'Real' ? 'Gerçek' : gt.judgment);
# String reasonTr = gt.reason == 'Initial evaluation' ? 'İlk değerlendirme' : gt.reason;
# subtitle: Text('Karar: $judgmentTr | Neden: $reasonTr'),

gt_target = """                subtitle: Text('Karar: ${gt.judgment} | Neden: ${gt.reason}'),"""
gt_replacement = """                String judgmentTr = gt.judgment == 'Manipulated' ? 'Müdahaleli' : (gt.judgment == 'Real' ? 'Gerçek' : gt.judgment);
                String reasonTr = gt.reason == 'Initial evaluation' ? 'İlk değerlendirme' : gt.reason;
                subtitle: Text('Karar: $judgmentTr | Neden: $reasonTr'),"""

if gt_target in gt_content:
    gt_content = gt_content.replace(gt_target, gt_replacement)
    with open(gt_path, 'w', encoding='utf-8') as f:
        f.write(gt_content)

print("Dashboard and dynamic strings translated.")
