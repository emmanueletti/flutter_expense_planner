class Transaction {
  // instance fields
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  // constructor
  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  // custom getters
  get formattedDate {
    return "${date.year}-${date.month}-${date.day}";
  }
}
