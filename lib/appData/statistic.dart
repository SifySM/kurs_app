import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

void main() {
  final app = App();
  runApp(app);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UsageStatsScreen(),
    );
  }
}

class UsageStatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика использования'),
      ),
      body: FutureBuilder<List<UsageInfo>>(
        future: UsageStats.queryUsageStats(DateTime.now().subtract(const Duration(days: 5)), DateTime.now()),
        builder: (context, snapshot) {
          print(snapshot.hasData);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<UsageInfo>? usageStats = snapshot.data;
            print(usageStats);
            return ListView.builder(
              itemCount: usageStats!.length,
              itemBuilder: (context, index) {
                UsageInfo usageInfo = usageStats[index];
                return ListTile(
                  leading: CircleAvatar(
                    // Здесь можно использовать иконку приложения или другую идентификацию
                    child: Text(usageInfo.packageName?[0] ?? ''),
                  ),
                  title: Text(usageInfo.packageName ?? ''),
                  subtitle: Text('Использовано: ${usageInfo.totalTimeInForeground} мс'),
                );
              },
            );
          } else {
            return Center(child: Text('Нет данных статистики использования'));
          }
        },
      ),
    );
  }
}