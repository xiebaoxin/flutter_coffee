#!/usr/bin/env python3
"""Fix widget replacements and common patterns across all Dart files"""
import os
import re

DIRS = ['lib/views', 'lib/components']

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    original = content

    # Fix accentColor -> colorScheme.secondary
    content = content.replace(
        "Theme.of(context).accentColor",
        "Theme.of(context).colorScheme.secondary"
    )
    
    # Fix List() -> [] (bare constructor calls, not List<Type>() or List.xxx())
    # Match List() but not List<...>() or List.from() etc
    content = re.sub(r'\bList\(\)', '[]', content)

    # Fix autovalidate: true -> autovalidateMode: AutovalidateMode.always
    content = content.replace(
        'autovalidate: true',
        'autovalidateMode: AutovalidateMode.always'
    )

    # Fix canLaunch -> canLaunchUrl, launch -> launchUrl (url_launcher v6)
    # Only in specific patterns
    content = content.replace('canLaunch(_downurl)', 'canLaunchUrl(Uri.parse(_downurl))')
    content = content.replace('await launch(_downurl)', 'await launchUrl(Uri.parse(_downurl))')
    content = content.replace('launch(widget.updateUrl)', 'launchUrl(Uri.parse(widget.updateUrl))')
    content = content.replace('canLaunch(url)', 'canLaunchUrl(Uri.parse(url))')
    content = content.replace('await launch(url)', 'await launchUrl(Uri.parse(url))')
    
    # Fix _location.latLng.latitude -> _location.latLng_latitude (for amap stub)
    # This needs careful handling - only for AmapLocation stub's Location object
    # We'll handle this in individual files

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"  Fixed widgets: {filepath}")

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
    print(f"Found {len(files)} dart files")
    for f in files:
        process_file(f)
    print("Done with widget replacements")
