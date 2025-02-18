class TradeResult {
  final int totalProfit;
  final int longestWinStreak;
  final int winStreakProfit;
  final int longestLoseStreak;
  final int loseStreakLoss;

  TradeResult({
    required this.totalProfit,
    required this.longestWinStreak,
    required this.winStreakProfit,
    required this.longestLoseStreak,
    required this.loseStreakLoss,
  });
}
