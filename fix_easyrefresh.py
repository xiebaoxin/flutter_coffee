#!/usr/bin/env python3
"""Fix easy_refresh v3 API changes"""
import os
import re

DIRS = ['lib/views', 'lib/components']

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    original = content
    
    # Replace ClassicalHeader with ClassicHeader and fix params
    # easy_refresh v3 uses different parameter names
    content = re.sub(
        r'ClassicalHeader\(\s*'
        r'refreshedText:\s*"[^"]*",?\s*'
        r'refreshReadyText:\s*"[^"]*",?\s*'
        r'bgColor:\s*([^,]+),?\s*'
        r'textColor:\s*([^)]+)\)',
        r'ClassicHeader()',
        content
    )
    
    # Also fix ClassicalFooter if any
    content = content.replace('ClassicalFooter(', 'ClassicFooter(')
    
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
