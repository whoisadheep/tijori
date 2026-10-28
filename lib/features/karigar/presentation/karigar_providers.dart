import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tijori/core/database/app_database.dart';

/// Stream of all registered parties with groupType == karigar.
final allKarigarsProvider = StreamProvider.autoDispose<List<Party>>((ref) {
  final partiesDao = ref.watch(partiesDaoProvider);
  return partiesDao.watchPartiesByGroup(PartyGroupType.karigar);
});

/// Stream of all Karigar job transactions.
final allKarigarTransactionsProvider =
    StreamProvider.autoDispose<List<KarigarTransaction>>((ref) {
  final dao = ref.watch(karigarTransactionsDaoProvider);
  return dao.watchAllTransactions();
});

/// Stream of transactions for a specific Karigar.
final karigarTransactionsProvider =
    StreamProvider.family.autoDispose<List<KarigarTransaction>, int>((ref, karigarId) {
  final dao = ref.watch(karigarTransactionsDaoProvider);
  return dao.watchTransactionsForKarigar(karigarId);
});

/// Immutable summary of an artisan's metal account.
class KarigarMetalSummary {
  final int karigarId;
  final double totalIssuedGross;
  final double totalIssuedPure;
  final double totalReceivedGross;
  final double totalReceivedPure;
  final double pendingPureBalance;
  final int transactionCount;

  const KarigarMetalSummary({
    required this.karigarId,
    required this.totalIssuedGross,
    required this.totalIssuedPure,
    required this.totalReceivedGross,
    required this.totalReceivedPure,
    required this.pendingPureBalance,
    required this.transactionCount,
  });

  factory KarigarMetalSummary.fromTransactions(int karigarId, List<KarigarTransaction> txns) {
    double issuedGross = 0;
    double issuedPure = 0;
    double receivedGross = 0;
    double receivedPure = 0;

    for (final t in txns) {
      if (t.type == KarigarTxnType.issue) {
        issuedGross += t.grossWeight;
        issuedPure += t.netWeight; // Pure metal
      } else {
        receivedGross += t.grossWeight;
        receivedPure += t.netWeight;
      }
    }

    return KarigarMetalSummary(
      karigarId: karigarId,
      totalIssuedGross: issuedGross,
      totalIssuedPure: issuedPure,
      totalReceivedGross: receivedGross,
      totalReceivedPure: receivedPure,
      pendingPureBalance: issuedPure - receivedPure,
      transactionCount: txns.length,
    );
  }
}

/// Reactive summary for a specific Karigar.
final karigarSummaryProvider =
    Provider.family.autoDispose<KarigarMetalSummary, int>((ref, karigarId) {
  final txns = ref.watch(karigarTransactionsProvider(karigarId)).valueOrNull ?? [];
  return KarigarMetalSummary.fromTransactions(karigarId, txns);
});

/// Shop-wide Karigar workshop statistics.
class KarigarWorkshopStats {
  final int totalKarigars;
  final double totalOutstandingPureGold;
  final double totalIssuedPureGold;
  final double totalReceivedPureGold;
  final int artisansHoldingGold;

  const KarigarWorkshopStats({
    required this.totalKarigars,
    required this.totalOutstandingPureGold,
    required this.totalIssuedPureGold,
    required this.totalReceivedPureGold,
    required this.artisansHoldingGold,
  });
}

final karigarWorkshopStatsProvider =
    Provider.autoDispose<KarigarWorkshopStats>((ref) {
  final karigars = ref.watch(allKarigarsProvider).valueOrNull ?? [];
  final allTxns = ref.watch(allKarigarTransactionsProvider).valueOrNull ?? [];

  double totalIssued = 0;
  double totalReceived = 0;

  final karigarBalanceMap = <int, double>{};

  for (final t in allTxns) {
    final prev = karigarBalanceMap[t.karigarId] ?? 0.0;
    if (t.type == KarigarTxnType.issue) {
      totalIssued += t.netWeight;
      karigarBalanceMap[t.karigarId] = prev + t.netWeight;
    } else {
      totalReceived += t.netWeight;
      karigarBalanceMap[t.karigarId] = prev - t.netWeight;
    }
  }

  int holdingCount = 0;
  for (final bal in karigarBalanceMap.values) {
    if (bal > 0.001) {
      holdingCount++;
    }
  }

  return KarigarWorkshopStats(
    totalKarigars: karigars.length,
    totalOutstandingPureGold: (totalIssued - totalReceived) > 0 ? (totalIssued - totalReceived) : 0,
    totalIssuedPureGold: totalIssued,
    totalReceivedPureGold: totalReceived,
    artisansHoldingGold: holdingCount,
  );
});
