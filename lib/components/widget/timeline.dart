import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
      ),
      body: ListView(
        children: [
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: true,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Colors.green,
              padding: EdgeInsets.all(8),
            ),
            endChild: Container(
              constraints: const BoxConstraints(
                minHeight: 120,
              ),
              color: Colors.amber,
              child: Center(
                child: Text('Event 1\nDescription 1\n9:00 AM'),
              ),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              color: Colors.red,
              padding: EdgeInsets.all(8),
            ),
            endChild: Container(
              constraints: const BoxConstraints(
                minHeight: 120,
              ),
              color: Colors.lightBlue,
              child: Center(
                child: Text('Event 2\nDescription 2\n10:30 AM'),
              ),
            ),
          ),
          // Add more events as needed
        ],
      ),
    );
  }
}
