import os
import re

lib_dir = r"c:\Users\MY ASUS\kalkulator_vvip\lib"

# regex to find const ... AppColors
# actually we want to find any `const` keyword on the same line or previous line of AppColors.
# or better, just find all files using AppColors and print them with context.
errors = []

for root, _, files in os.walk(lib_dir):
    for f in files:
        if f.endswith(".dart"):
            path = os.path.join(root, f)
            with open(path, "r", encoding="utf-8") as file:
                lines = file.readlines()
                for i, line in enumerate(lines):
                    if "AppColors" in line:
                        # check if there is a 'const ' in this line
                        if "const " in line:
                            errors.append(f"{path}:{i+1}: {line.strip()}")
                        # check if the previous line has 'const '
                        elif i > 0 and "const " in lines[i-1] and not ";" in lines[i-1]:
                            errors.append(f"{path}:{i+1} (prev const): {line.strip()}")

for e in errors:
    print(e)
