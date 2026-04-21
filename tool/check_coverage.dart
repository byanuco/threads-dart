import 'dart:io';

const _defaultLcovPath = 'coverage/lcov.info';
const _defaultThreshold = 90.0;
const _defaultExcludePatterns = <String>[r'\.g\.dart$'];

void main(List<String> arguments) {
  var lcovPath = _defaultLcovPath;
  var threshold = _defaultThreshold;
  final excludePatterns = <String>[..._defaultExcludePatterns];
  var excludesOverridden = false;

  for (var i = 0; i < arguments.length; i++) {
    final arg = arguments[i];
    if (arg == '--lcov' && i + 1 < arguments.length) {
      lcovPath = arguments[++i];
    } else if (arg == '--min-coverage' && i + 1 < arguments.length) {
      threshold = double.parse(arguments[++i]);
    } else if (arg == '--exclude' && i + 1 < arguments.length) {
      if (!excludesOverridden) {
        excludePatterns.clear();
        excludesOverridden = true;
      }
      excludePatterns.add(arguments[++i]);
    } else {
      stderr.writeln('Unknown argument: $arg');
      exit(64);
    }
  }

  final file = File(lcovPath);
  if (!file.existsSync()) {
    stderr.writeln('Coverage report not found at $lcovPath.');
    stderr.writeln(
      'Run `dart run coverage:test_with_coverage` before this check.',
    );
    exit(1);
  }

  final excludeRegexes = excludePatterns.map(RegExp.new).toList();
  final summary = _parseLcov(file.readAsLinesSync(), excludeRegexes);

  if (summary.totalLines == 0) {
    stderr.writeln('No lines found in $lcovPath after applying excludes.');
    exit(1);
  }

  final coverage = summary.hitLines * 100 / summary.totalLines;
  stdout.writeln('Files considered:  ${summary.fileCount}');
  stdout.writeln('Files excluded:    ${summary.excludedFileCount}');
  stdout.writeln('Lines:             ${summary.totalLines}');
  stdout.writeln('Hit:               ${summary.hitLines}');
  stdout.writeln('Missed:            ${summary.totalLines - summary.hitLines}');
  stdout.writeln('Coverage:          ${coverage.toStringAsFixed(2)}%');
  stdout.writeln('Threshold:         ${threshold.toStringAsFixed(2)}%');

  if (coverage + 1e-9 < threshold) {
    stderr.writeln(
      'FAIL: coverage ${coverage.toStringAsFixed(2)}% '
      'is below the ${threshold.toStringAsFixed(2)}% threshold.',
    );
    exit(1);
  }

  stdout.writeln('OK: coverage meets the threshold.');
}

class _Summary {
  _Summary({
    required this.fileCount,
    required this.excludedFileCount,
    required this.totalLines,
    required this.hitLines,
  });

  final int fileCount;
  final int excludedFileCount;
  final int totalLines;
  final int hitLines;
}

_Summary _parseLcov(List<String> lines, List<RegExp> excludeRegexes) {
  var fileCount = 0;
  var excludedFileCount = 0;
  var totalLines = 0;
  var hitLines = 0;
  var skipCurrent = false;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      final path = line.substring(3);
      skipCurrent = excludeRegexes.any((re) => re.hasMatch(path));
      if (skipCurrent) {
        excludedFileCount++;
      } else {
        fileCount++;
      }
    } else if (!skipCurrent && line.startsWith('DA:')) {
      final comma = line.indexOf(',');
      if (comma == -1) continue;
      final hits = int.tryParse(line.substring(comma + 1)) ?? 0;
      totalLines++;
      if (hits > 0) hitLines++;
    } else if (line.startsWith('end_of_record')) {
      skipCurrent = false;
    }
  }

  return _Summary(
    fileCount: fileCount,
    excludedFileCount: excludedFileCount,
    totalLines: totalLines,
    hitLines: hitLines,
  );
}
