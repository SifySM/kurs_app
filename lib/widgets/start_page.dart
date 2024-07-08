import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kurs_app/utils/date_utils.dart';
import 'package:kurs_app/widgets/menu_bar.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:usage_stats/usage_stats.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BasicStyle.mainBackground(),
        child: const Column(
          children: [
            SizedBox(
              height: 40.0,
            ),
            Expanded(child: AppsScroll()),
            Expanded(child: CustomMenuBar()),
          ],
        ),
      ),
    );
  }
}

class BasicStyle {
  static Future<void> _loadFonts() async {
    final fontLoader = FontLoader('Age');
    await fontLoader.load();
  }

  static List<DataOfButton> get firstMenuRow => [
        DataOfButton(
            pathToIcon: 'assets/images/menuBarIcon/Chats.png',
            isSelected: false),
        DataOfButton(
            pathToIcon: 'assets/images/menuBarIcon/Main.png',
            isSelected: false),
        DataOfButton(
            pathToIcon: 'assets/images/menuBarIcon/News.png',
            isSelected: false),
        DataOfButton(
            pathToIcon: 'assets/images/menuBarIcon/Statictic.png',
            isSelected: false),
      ];

  static BoxDecoration mainBackground() {
    _loadFonts();
    return const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF9EA3F7),
            Colors.white, //Colors.transparent Прозрачный цвет внизу
          ],
          stops: [
            0.2,
            0.99
          ]),
      //child: ,
    );
  }
}

class AppsScroll extends StatefulWidget {
  const AppsScroll({super.key});

  @override
  State<AppsScroll> createState() => _AppsScrollState();
}

class _AppsScrollState extends State<AppsScroll> {
  List<Application> apps = [];
  int currentPageIndex = 0;
  List<UsageInfo> usageStats = [];
  double totalUsageTime = 0;
  UsageInfo? appStats;

  @override
  void initState() {
    super.initState();
    getApp();
    getAppUsageStats().then((stats) {
      setState(() {
        usageStats = stats;
      });
    });
  }

  Future<List<UsageInfo>> getAppUsageStats() async {
    try {
      // Получаем статистику использования приложений за последние 5 дней
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(days: 5));

      List<UsageInfo>? usageStats = await UsageStats.queryUsageStats(
          DateTime.now().subtract(const Duration(days: 5)), DateTime.now());

      for (UsageInfo usage in usageStats) {
        totalUsageTime += int.parse(usage.totalTimeInForeground ?? '0');
      }

      return usageStats;
    } on PlatformException catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> getApp() async {
    List<Application> _apps = await DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeAppIcons: true,
      includeSystemApps: true,
    );
    setState(() {
      apps = _apps;
    });
  }

  int selectedIndex = 0;
  final pageController = PageController(viewportFraction: 0.33);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: apps.length,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              final item = apps[index];
              appStats = usageStats.firstWhere(
                (stats) => stats.packageName == item.packageName,
              );
              return AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (pageController.position.haveDimensions) {
                    value = pageController.page! - index;
                    value = (1 - (value.abs() * 0.5)).clamp(0.5, 1.0);
                  }
                  final heightIcon = MediaQuery.of(context).size.width <
                          MediaQuery.of(context).size.height
                      ? MediaQuery.of(context).size.width * 0.4
                      : MediaQuery.of(context).size.width * 0.1;

                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: index == selectedIndex ? 0 : 20.0,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              SignatureWidget(
                                item: item,
                                selectedIndex: selectedIndex,
                                currentIndex: index,
                              ),
                              const SizedBox(height: 25),
                              IconAppWidget(heightIcon: heightIcon, item: item),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        // Expanded(
        //   child: AppStatsWidget(
        //     appStats: appStats ?? UsageInfo(),
        //   ),
        // ),
      ],
    );
  }
}

class SignatureWidget extends StatelessWidget {
  const SignatureWidget({
    super.key,
    required this.item,
    required this.selectedIndex,
    required this.currentIndex,
  });

  final Application item;
  final int selectedIndex;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Text(
      item.appName.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.fade,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: currentIndex == selectedIndex
            ? const Color(0xFF352B73)
            : const Color(0xFF352B73).withOpacity(0.5),
        fontFamily: 'Age',
        decoration: TextDecoration.none,
      ),
    );
  }
}

class IconAppWidget extends StatelessWidget {
  const IconAppWidget({
    super.key,
    required this.heightIcon,
    required this.item,
  });

  final double heightIcon;
  final Application item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightIcon,
      width: heightIcon,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(25, 25)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD7D0FF),
            blurRadius: 49,
          ),
        ],
      ),
      child: Image.memory(
        (item as ApplicationWithIcon).icon,
        height: 140,
        width: 140,
      ),
    );
  }
}

class AppStatsWidget extends StatelessWidget {
  final UsageInfo appStats;
  final totalUsageTime;

  const AppStatsWidget({
    super.key,
    required this.appStats,
    this.totalUsageTime,
  });

  @override
  Widget build(BuildContext context) {
    final totalTimeInForeground = appStats.totalTimeInForeground != null
        ? convertToDouble(appStats.totalTimeInForeground)
        : 0;

    print('totalUsageTime: ${totalUsageTime}');
    final currentTotalUsageTime = 500000000;
    final centerText = "${Random().nextInt(21)}%";
    final lastUsage = (appStats.lastTimeUsed == "1717400931388") ? 'Использовалось давно' : convertMillisecondsToTimeString(appStats.lastTimeUsed ?? '0');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Expanded(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 26.0),
                  const Text(
                    'Ваша статистика',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF352B73),
                      fontFamily: 'Age',
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: buildStatItem('Последнее использование', lastUsage),
                  ),
                  const SizedBox(height: 1.0),
                  Expanded(
                    child: buildStatItem('Время использования:',
                        '${formatTimeInMinutes(appStats.totalTimeInForeground ?? '0')} мин'),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: PieChart(
                dataMap: {
                  'Foreground':
                  convertToDouble(centerText),
                  'Background':
                  convertToDouble((100.0 - double.parse(centerText)) as String?),
                },
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32.0,
                chartRadius: 100 * 0.5,
                colorList: const [
                  Colors.green,
                  Colors.grey,
                ],
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                centerText: centerText,
                legendOptions: const LegendOptions(
                  showLegends: false,
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: false,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF352B73),
              fontFamily: 'Age',
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF352B73),
              fontFamily: 'Age',
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
