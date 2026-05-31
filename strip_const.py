import os
import re

lib_dir = r"c:\Users\MY ASUS\kalkulator_vvip\lib"

for root, _, files in os.walk(lib_dir):
    for f in files:
        if f.endswith(".dart"):
            path = os.path.join(root, f)
            with open(path, "r", encoding="utf-8") as file:
                content = file.read()
            
            # Strip const before Class names
            new_content = re.sub(r'\bconst\s+([A-Z]\w*)', r'\1', content)
            
            # Strip const before arrays/maps
            new_content = re.sub(r'\bconst\s+\[', r'[', new_content)
            new_content = re.sub(r'\bconst\s+\{', r'{', new_content)
            
            # Strip const from standard variables
            new_content = re.sub(r'\bconst\s+Color\b', r'Color', new_content)
            new_content = re.sub(r'\bconst\s+double\b', r'double', new_content)
            new_content = re.sub(r'\bconst\s+int\b', r'int', new_content)
            new_content = re.sub(r'\bconst\s+String\b', r'String', new_content)
            
            if new_content != content:
                with open(path, "w", encoding="utf-8") as file:
                    file.write(new_content)
