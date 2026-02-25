#!/usr/bin/env python3
"""Batch fix Flutter migration issues across lib/views/ and lib/components/"""
import os
import re

DIRS = ['lib/views', 'lib/components']

# Simple import replacements
IMPORT_REPLACEMENTS = {
    "import 'package:color_dart/color_dart.dart';": "import 'package:flutter_coffee/stubs/color_dart.dart';",
    "import 'package:decorated_flutter/decorated_flutter.dart';": "import 'package:flutter_coffee/stubs/decorated_flutter_stub.dart';",
    "import 'package:amap_map_fluttify/amap_map_fluttify.dart';": "import 'package:flutter_coffee/stubs/amap_stub.dart';",
    "import 'package:amap_location_fluttify/amap_location_fluttify.dart';": "import 'package:flutter_coffee/stubs/amap_stub.dart';",
    "import 'package:amap_core_fluttify/amap_core_fluttify.dart';": "import 'package:flutter_coffee/stubs/amap_stub.dart';",
    "import 'package:fluwx/fluwx.dart'": "import 'package:flutter_coffee/stubs/fluwx_stub.dart'",
    "import 'package:tobias/tobias.dart';": "import 'package:flutter_coffee/stubs/tobias_stub.dart';",
    "import 'package:flutter_easyrefresh/easy_refresh.dart';": "import 'package:easy_refresh/easy_refresh.dart';",
    "import 'package:flutter_swiper/flutter_swiper.dart';": "import 'package:card_swiper/card_swiper.dart';",
    "import 'package:install_plugin/install_plugin.dart';": "import 'package:flutter_coffee/stubs/install_plugin_stub.dart';",
    "import 'package:package_info/package_info.dart';": "import 'package:package_info_plus/package_info_plus.dart';",
    "import 'package:connectivity/connectivity.dart';": "import 'package:connectivity_plus/connectivity_plus.dart';",
    "import 'package:device_info/device_info.dart';": "import 'package:device_info_plus/device_info_plus.dart';",
}

# Lines to remove entirely
REMOVE_LINES = [
    "import 'package:r_upgrade/r_upgrade.dart';",
    "import 'package:flutter_pagewise/flutter_pagewise.dart';",
    "import 'package:flutter_drag_scale/flutter_drag_scale.dart';",
    "import 'package:image_crop/image_crop.dart';",
    "import 'package:flutter_native_image/flutter_native_image.dart';",
    "import 'package:flutter_picker/flutter_picker.dart';",
    "import 'package:share_extend/share_extend.dart';",
]

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    original = content
    
    # Apply import replacements
    for old, new in IMPORT_REPLACEMENTS.items():
        content = content.replace(old, new)
    
    # Remove lines
    for line in REMOVE_LINES:
        content = content.replace(line + '\n', '')
        content = content.replace(line, '')
    
    # Fix duplicate amap imports (when both amap_map and amap_location were imported)
    lines = content.split('\n')
    seen_amap = False
    new_lines = []
    for line in lines:
        stripped = line.strip()
        if stripped == "import 'package:flutter_coffee/stubs/amap_stub.dart';":
            if not seen_amap:
                seen_amap = True
                new_lines.append(line)
            # skip duplicate
        else:
            new_lines.append(line)
    content = '\n'.join(new_lines)
    
    # Fix duplicate fluwx imports  
    lines = content.split('\n')
    seen_fluwx = set()
    new_lines = []
    for line in lines:
        stripped = line.strip()
        if 'flutter_coffee/stubs/fluwx_stub.dart' in stripped:
            if stripped not in seen_fluwx:
                seen_fluwx.add(stripped)
                new_lines.append(line)
        else:
            new_lines.append(line)
    content = '\n'.join(new_lines)
    
    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"  Fixed imports: {filepath}")

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
    print("Done with import replacements")
