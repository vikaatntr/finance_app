// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:my_finance/helper/balance_detail.dart';
import 'package:my_finance/model/balance_detail.dart';
import 'package:my_finance/screen/cashflow/cashflow.dart';
import 'package:my_finance/screen/home/setting/setting.dart';
import 'package:my_finance/screen/income/income.dart';
import 'package:my_finance/screen/outcome/outcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String totalIncome = "";
  String totalOutcome = "";
  String totalSummary = "";

  List<BalanceDetail> income = [];
  List<BalanceDetail> outcome = [];

  @override
  void initState() {
    fetchTotalIncomeOutcome();
    super.initState();
  }

  fetchTotalIncomeOutcome() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int idBalance = prefs.getInt('idBalance') ?? 0;

    double inc = await getTotalBalanceByType("in", idBalance);
    double outc = await getTotalBalanceByType("out", idBalance);
    double total = inc - outc;

    String formattedIncome = NumberFormat.currency(
      locale: 'id_ID', // Sesuaikan dengan preferensi Anda
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(inc.toInt());

    String formattedOutcome = NumberFormat.currency(
      locale: 'id_ID', // Sesuaikan dengan preferensi Anda
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(outc.toInt());

    String formattedTotal = NumberFormat.currency(
      locale: 'id_ID', // Sesuaikan dengan preferensi Anda
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(total.toInt());

    var incomeResuts = await getBalanceByType("in", idBalance);
    var outcomeResuts = await getBalanceByType("out", idBalance);

    setState(() {
      totalIncome = formattedIncome;
      totalOutcome = formattedOutcome;
      totalSummary = formattedTotal;
      income = incomeResuts;
      outcome = outcomeResuts;
    });
  }

  Future<void> _refreshData() async {
    await fetchTotalIncomeOutcome();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Map> categories = [
      {
        'icon': 'https://cdn-icons-png.flaticon.com/512/6213/6213490.png',
        'title': 'Income',
      },
      {
        'icon': 'https://cdn-icons-png.flaticon.com/512/2720/2720876.png',
        'title': 'Outcome',
      },
      {
        'icon': 'https://cdn-icons-png.flaticon.com/512/10842/10842365.png',
        'title': 'Cash Flow',
      },
      {
        'icon': 'https://cdn-icons-png.flaticon.com/512/4562/4562939.png',
        'title': 'Setting',
      },
    ];

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Container(),
        leadingWidth: 0.0,
        title: SizedBox(
            child: const Text(
          'My-Finance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        )),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipperOne(),
              child: Container(
                height: 240,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    // image: NetworkImage('https://capekngoding.com/uploads/62f5f123a60ae_15.png'),
                    image: NetworkImage(
                      "https://wallpaperaccess.com/full/1601031.jpg",
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.purple[900]!.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        totalSummary,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        totalIncome,
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'OUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        totalOutcome,
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          // Chart title
                          title: ChartTitle(text: 'Summary Balance'),
                          // Enable legend
                          // legend: Legend(isVisible: true),
                          // Enable tooltip
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ChartSeries<BalanceDetail, String>>[
                            LineSeries<BalanceDetail, String>(
                              dataSource: income,
                              xValueMapper: (BalanceDetail sales, _) =>
                                  sales.date,
                              yValueMapper: (BalanceDetail sales, _) =>
                                  sales.nominal,
                              name: 'Sales',
                              // Enable data label
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                            ),
                            LineSeries<BalanceDetail, String>(
                                dataSource: outcome,
                                xValueMapper: (BalanceDetail sales, _) =>
                                    sales.date,
                                yValueMapper: (BalanceDetail sales, _) =>
                                    sales.nominal,
                                name: 'Sales',
                                // Enable data label
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true))
                          ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: List.generate(
                        categories.length,
                        (index) {
                          var item = categories[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                Widget page = Container();
                                switch (item['title']) {
                                  case 'Income':
                                    page = IncomeScreen();
                                    break;
                                  case 'Outcome':
                                    page = OutcomeScreen();
                                    break;
                                  case 'Cash Flow':
                                    page = CashflowScreen();
                                    break;
                                  case 'Setting':
                                    page = SettingScreen();
                                    break;
                                  default:
                                    break;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => page),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],
                                    ),
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  '${item['icon']}'))),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      '${item['title']}',
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
