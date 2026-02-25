#!/usr/bin/env python3
"""Fix remaining null safety issues - @required -> required, non-nullable params"""
import os
import re

DIRS = ['lib/views', 'lib/components']

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    original = content
    
    # Fix @required -> required
    content = content.replace('@required ', 'required ')
    
    # Fix form.save() -> form?.save()
    content = content.replace('form.save()', 'form?.save()')
    
    # Fix form.validate() -> form?.validate() ?? false
    content = re.sub(r'form\.validate\(\)', 'form?.validate() ?? false', content)
    
    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"  Fixed: {filepath}")

def find_dart_files():
    files = []
    for d in DIRS:
        for root, dirs, filenames in os.walk(d):
            for fn in filenames:
                if fn.endswith('.dart'):
                    files.append(os.path.join(root, fn))
    return files

if __name__ == '__main__':
    files = find_dart_files()
    for f in files:
        process_file(f)
    print("Done")
