import os, re, json
target_dir = r'c:\Users\mustafa\Desktop\algı yönetimi\RealityLens\apps\client\lib\features'
strings = set()
files_dict = {}

def extract(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # regex to find strings in Text('...') or tooltip: '...' or label: '...' etc.
    # very naive extraction just to get a sense
    pattern = r"(?:Text|title|label|tooltip|hintText|labelText|content:\s*Text)\s*\(\s*['\"]([^'\"]*[a-zA-Z]+[^'\"]*)['\"]"
    pattern2 = r"(?:tooltip|label|title|hintText|labelText)\s*:\s*['\"]([^'\"]*[a-zA-Z]+[^'\"]*)['\"]"
    
    matches = re.findall(pattern, content)
    matches += re.findall(pattern2, content)
    
    # Also find simple assignments or string interpolations that are in english
    # like 'Assessments'
    
    if matches:
        files_dict[path] = list(set(matches))
        for m in matches:
            strings.add(m)

for root, dirs, files in os.walk(target_dir):
    if 'presentation' in root.split(os.sep):
        for file in files:
            if file.endswith('.dart'):
                extract(os.path.join(root, file))

for k,v in files_dict.items():
    print(os.path.basename(k), v)
