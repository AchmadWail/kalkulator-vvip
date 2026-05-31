import os

empty_files = []
for dp, dn, filenames in os.walk('lib'):
    for f in filenames:
        if f.endswith('.dart'):
            full_path = os.path.join(dp, f)
            if os.path.getsize(full_path) == 0:
                empty_files.append(full_path)

with open('empty_files.txt', 'w') as fh:
    for ef in empty_files:
        fh.write(ef + '\n')
