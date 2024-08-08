import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';

class PieChartTickets extends StatefulWidget {
  const PieChartTickets({super.key});

  @override
  State<StatefulWidget> createState() => PieChartTicketsState();
}

class PieChartTicketsState extends State<PieChartTickets> {
  int touchedIndex = -1;

  // Exemple de données : à adapter selon les besoins
  final double totalTickets = 100;
  final double agentTickets = 40;
  final double otherAgentsTickets = 35;
  final double pendingTickets = 25;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 15),
            Row(
              children: [
                makePieIcon(),
                const SizedBox(
                  width: 38,
                ),
                const Text(
                  'Répartition des Scans',
                  style: TextStyle(
                      color: Color.fromARGB(255, 40, 46, 58), fontSize: 18),
                ),
                const SizedBox(
                  width: 4,
                ),
                /*  const Text(
                  '7 derniers jours',
                  style: TextStyle(color: Color(0xff77839a), fontSize: 14),
                ), */
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 5),
                  legendItem(
                    'Pour vous',
                    Palette.primaryColor,
                  ),
                  SizedBox(width: 5),
                  legendItem('Autres Agents', Colors.orange),
                  SizedBox(width: 5),
                  legendItem('En Attente', Colors.grey),
                  SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container makePieIcon() => Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 5,
            color: Color.fromARGB(255, 80, 88, 105).withOpacity(1),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 5,
              color: Color.fromARGB(255, 140, 148, 164).withOpacity(1),
            ),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 5,
                color: Color.fromARGB(255, 224, 229, 237).withOpacity(1),
              ),
            ),
          ),
        ),
      );

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Palette.primaryColor,
            value: agentTickets,
            title: '${(agentTickets / totalTickets * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.orange,
            value: otherAgentsTickets,
            title:
                '${(otherAgentsTickets / totalTickets * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.grey,
            value: pendingTickets,
            title:
                '${(pendingTickets / totalTickets * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  Widget legendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        const SizedBox(width: 5),
        AppText.medium(
          title,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ],
    );
  }
}
