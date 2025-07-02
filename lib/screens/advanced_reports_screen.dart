import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/transaction_service.dart';
import '../models/user.dart';
import '../models/transaction.dart';

class AdvancedReportsScreen extends StatefulWidget {
  const AdvancedReportsScreen({super.key});

  @override
  State<AdvancedReportsScreen> createState() => _AdvancedReportsScreenState();
}

class _AdvancedReportsScreenState extends State<AdvancedReportsScreen> {
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  User? _currentUser;
  String _selectedPeriod = '7'; // 7, 30, 90 days

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await AuthService.getCurrentUser();
    if (user != null) {
      final transactions = await TransactionService.getTransactions(user.username);
      setState(() {
        _currentUser = user;
        _transactions = transactions;
        _isLoading = false;
      });
    }
  }

  List<Transaction> _getFilteredTransactions() {
    final now = DateTime.now();
    final days = int.parse(_selectedPeriod);
    final startDate = now.subtract(Duration(days: days));
    
    return _transactions.where((transaction) => 
      transaction.date.isAfter(startDate)
    ).toList();
  }

  double _getTotalSales() {
    return _getFilteredTransactions()
        .fold(0.0, (sum, transaction) => sum + transaction.totalPrice);
  }

  int _getTotalTransactions() {
    return _getFilteredTransactions().length;
  }

  double _getAverageTransaction() {
    final transactions = _getFilteredTransactions();
    if (transactions.isEmpty) return 0.0;
    return transactions.fold(0.0, (sum, t) => sum + t.totalPrice) / transactions.length;
  }

  Map<String, double> _getDailySalesData() {
    final transactions = _getFilteredTransactions();
    final Map<String, double> dailySales = {};
    
    for (var transaction in transactions) {
      final dateKey = DateFormat('dd/MM').format(transaction.date);
      dailySales[dateKey] = (dailySales[dateKey] ?? 0.0) + transaction.totalPrice;
    }
    
    return dailySales;
  }

  Map<String, int> _getProductSalesData() {
    final transactions = _getFilteredTransactions();
    final Map<String, int> productSales = {};
    
    for (var transaction in transactions) {
      for (var item in transaction.items) {
        productSales[item.productName] = (productSales[item.productName] ?? 0) + item.quantity;
      }
    }
    
    return productSales;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Lanjutan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period Selector
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Periode Laporan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedPeriod,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: const [
                              DropdownMenuItem(value: '7', child: Text('7 Hari Terakhir')),
                              DropdownMenuItem(value: '30', child: Text('30 Hari Terakhir')),
                              DropdownMenuItem(value: '90', child: Text('90 Hari Terakhir')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedPeriod = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Penjualan',
                          'Rp ${NumberFormat('#,###').format(_getTotalSales())}',
                          Icons.attach_money,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSummaryCard(
                          'Jumlah Transaksi',
                          _getTotalTransactions().toString(),
                          Icons.receipt,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Rata-rata Transaksi',
                          'Rp ${NumberFormat('#,###').format(_getAverageTransaction())}',
                          Icons.analytics,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSummaryCard(
                          'Produk Terjual',
                          _getProductSalesData().length.toString(),
                          Icons.inventory,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sales Chart
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Grafik Penjualan Harian',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: _buildSalesChart(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Product Sales Chart
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Penjualan Produk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: _buildProductChart(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Top Products
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Produk Terlaris',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTopProductsList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    final dailySales = _getDailySalesData();
    if (dailySales.isEmpty) {
      return const Center(
        child: Text('Tidak ada data penjualan'),
      );
    }

    final sortedEntries = dailySales.entries.toList()
      ..sort((a, b) => DateFormat('dd/MM').parse(a.key).compareTo(DateFormat('dd/MM').parse(b.key)));

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  'Rp ${(value / 1000).toInt()}k',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < sortedEntries.length) {
                  return Text(
                    sortedEntries[value.toInt()].key,
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(sortedEntries.length, (index) {
              return FlSpot(index.toDouble(), sortedEntries[index].value);
            }),
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildProductChart() {
    final productSales = _getProductSalesData();
    if (productSales.isEmpty) {
      return const Center(
        child: Text('Tidak ada data produk'),
      );
    }

    final sortedEntries = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topProducts = sortedEntries.take(5).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: topProducts.isNotEmpty ? topProducts.first.value.toDouble() * 1.2 : 10,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < topProducts.length) {
                  final productName = topProducts[value.toInt()].key;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      productName.length > 8 ? '${productName.substring(0, 8)}...' : productName,
                      style: const TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        barGroups: List.generate(topProducts.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: topProducts[index].value.toDouble(),
                color: Colors.blue,
                width: 20,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopProductsList() {
    final productSales = _getProductSalesData();
    if (productSales.isEmpty) {
      return const Center(
        child: Text('Tidak ada data produk'),
      );
    }

    final sortedEntries = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topProducts = sortedEntries.take(5).toList();

    return Column(
      children: List.generate(topProducts.length, (index) {
        final product = topProducts[index];
        
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getColorForIndex(index),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(product.key),
          trailing: Text(
            '${product.value} terjual',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        );
      }),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [Colors.amber, Colors.blue, Colors.green, Colors.orange, Colors.purple];
    return colors[index % colors.length];
  }
} 