import os
import json

empty_files = []
for dp, dn, filenames in os.walk('lib'):
    for f in filenames:
        if f.endswith('.dart'):
            full_path = os.path.join(dp, f)
            if os.path.getsize(full_path) == 0:
                empty_files.append(full_path)

with open('empty_files.json', 'w') as fh:
    json.dump(empty_files, fh)
