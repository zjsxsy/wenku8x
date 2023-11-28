import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wenku8x/screen/reader/core/background.dart';
import 'package:wenku8x/screen/reader/core/provider.dart';
import 'package:wenku8x/utils/log.dart';

part 'provider.freezed.dart';

@freezed
class CoverReader with _$CoverReader {
  const CoverReader._();

  const factory CoverReader(
      {required String name,
      required String aid,
      required List<Widget> pages,
      ReaderCore? readerCore}) = _CoverReader;
}

class CoverReaderNotifier
    extends FamilyNotifier<CoverReader, (BuildContext, String, String)> {
  @override
  CoverReader build(arg) {
    // var core = ref.watch(readerCoreProvider(arg));
    ref.listen<ReaderCore>(readerCoreProvider(arg), onCoreChange);
    return CoverReader(name: arg.$2, aid: arg.$3, pages: [
      const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      )
    ]);
  }

  Widget getPaintedPage(CustomPainter painter) {
    return SizedBox.expand(
      child: CustomPaint(
        foregroundPainter: painter,
        painter: BackgroundPainter(),
      ),
    );
  }

  onCoreChange(ReaderCore? c1, ReaderCore c2) {
    var pagePaintersMap = c1?.pagesScheduler.pagePaintersMap ?? {};
    if (pagePaintersMap.isEmpty) return;
    var pages = pagePaintersMap[0]!.map((e) => getPaintedPage(e)).toList();
    if (pagePaintersMap.isNotEmpty) {
      state = state.copyWith(pages: pages);
    }
  }
}

final coverReaderProvider = NotifierProvider.family<CoverReaderNotifier,
    CoverReader, (BuildContext, String, String)>(CoverReaderNotifier.new);
