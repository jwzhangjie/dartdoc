// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:io';

import 'package:dartdoc/dartdoc.dart';
import 'package:grinder/grinder.dart';

final Directory DOC_DIR = new Directory(DEFAULT_OUTPUT_DIRECTORY);

void main([List<String> args]) {
  task('init', init);
  task('test', testDartdoc, ['init']);
  startGrinder(args);
}

/**
 * Do any necessary build set up.
 */
void init(GrinderContext context) {
  // Verify we're running in the project root.
  if (!getDir('lib').existsSync() || !getFile('pubspec.yaml').existsSync()) {
    context.fail('This script must be run from the project root.');
  }
}

/**
 * Run dartdoc and check that the docs are generated.
 */
void testDartdoc(GrinderContext context) {
  if (DOC_DIR.existsSync()) DOC_DIR.deleteSync(recursive: true);

  try {
      context.log('running ');
      runDartScript(context, '../bin/dartdoc.dart');

      File indexHtml = joinFile(DOC_DIR, ['index.html']);
      if(!indexHtml.existsSync()) context.fail('docs not generated');
      File docFile = joinFile(DOC_DIR, ['dartdoc.html']);
      if(!docFile.existsSync()) context.fail('docs not generated');

  } catch (e) {
    try { DOC_DIR.deleteSync(recursive: true); }
    catch (_) { }

    rethrow;
  }
}
