#!/usr/bin/env bash
# dart 文件目录
DARTPATH="lib/flutter/widget/functionwidget/international/i10n"
# arb 文件目录
ARBPATH="/Users/issmac/FlutterWorkspace/flutterdemo/lib/flutter/widget/functionwidget/international/i10n_arb"

DARTFILE="$DARTPATH/localization_intl.dart"

flutter pub run intl_translation:extract_to_arb --output-dir=$ARBPATH $DARTFILE

flutter pub run intl_translation:generate_from_arb --output-dir=$DARTPATH --no-use-deferred-loading  $DARTFILE $ARBPATH/intl_*.arb

