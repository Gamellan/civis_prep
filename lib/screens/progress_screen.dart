import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/progress_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late final Future<ProgressDashboard> _dashboardFuture;
  final ProgressService _progressService = ProgressService();

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _progressService.getDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(strings.translate('yourProgress'))),
      body: FutureBuilder<ProgressDashboard>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final dashboard = snapshot.data!;
          final sortedTopics = [...dashboard.topicStats]
            ..sort((a, b) => b.accuracy.compareTo(a.accuracy));

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(strings.translate('overallPerformance'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text('${strings.translate('recordedAnswers')}: ${dashboard.totalAnswers}'),
                        Text('${strings.translate('correct')}: ${dashboard.correctAnswers}'),
                        Text('${strings.translate('incorrect')}: ${dashboard.incorrectAnswers}'),
                        Text('${strings.translate('accuracy')}: ${dashboard.overallAccuracy.toStringAsFixed(1)}%'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(strings.translate('weakestTopic'), style: const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Text(dashboard.weakestTopic.topic),
                              Text('${dashboard.weakestTopic.accuracy.toStringAsFixed(1)}% ${strings.translate('accuracy')}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(strings.translate('masteredTopics'), style: const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Text('${dashboard.masteredTopics}'),
                              if (dashboard.bestTopic != null)
                                Text('${strings.translate('best')}: ${dashboard.bestTopic!.topic}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(strings.translate('byTopic'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedTopics.length,
                    itemBuilder: (context, index) {
                      final topic = sortedTopics[index];
                      return Card(
                        child: ListTile(
                          title: Text(topic.topic),
                          subtitle: Text('${topic.questionsSeen} ${strings.translate('questions')} • ${topic.accuracy.toStringAsFixed(1)}% ${strings.translate('accuracy')}'),
                          trailing: Chip(
                            label: Text(topic.correctAnswers.toString()),
                            backgroundColor: topic.accuracy >= 80 ? Colors.green.shade100 : Colors.orange.shade100,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
