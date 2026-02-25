#!/usr/bin/env python3
"""Auto-fix common null safety issues in Dart files"""
import re
import os

DIRS = ['lib/views', 'lib/components']

def fix_key_params(content):
    """Fix {Key key, ...} -> {Key? key, ...}"""
    content = re.sub(r'\{Key key,', '{Key? key,', content)
    content = re.sub(r'\{Key key\}', '{Key? key}', content)
    return content

def fix_constructor_params_simple(content):
    """Fix common patterns like this.xxx where xxx is optional and non-nullable"""
    # Fix Key key -> Key? key in named params
    content = re.sub(r'(\{[^}]*?)Key key([,\}])', r'\1Key? key\2', content)
    return content

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    original = content
    
    content = fix_key_params(content)
    
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
