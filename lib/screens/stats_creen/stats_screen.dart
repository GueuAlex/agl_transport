import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../config/app_text.dart';
import '../../config/palette.dart';
import '../../draggable_menu.dart';
import '../../widgets/copy_rigtht.dart';
import '../../widgets/gate_keeper_tag.dart';
import '../side_bar/open_side_dar.dart';
import 'widgets/bar_chart.dart';
import 'widgets/linear_chart2.dart';
import 'widgets/pie_chart.dart';

class StatsScreen extends StatefulWidget {
  static const routeName = '/stats';
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: OpenSideBar(),
        title: AppText.medium('Stats'),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // profile details

          // stats
          LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                  //itemExtent: 100.0,
                  itemCount: 1,
                  itemBuilder: (c, i) {
                    return Column(
                      children: [
                        // profile details
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(maxHeight: 130),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Palette.separatorColor,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 90,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/security.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _nameContainer(),
                                        Row(
                                          children: [
                                            topStats(),
                                            const SizedBox(width: 10),
                                            topStats(
                                              text: '2456',
                                              icon:
                                                  'assets/icons/fleche-tendance-vers-le-bas.svg',
                                              color: Color.fromARGB(
                                                  255, 157, 3, 121),
                                              subText: 'ENTRÉES',
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: AppText.small(
                                        'matricule - 123456789',
                                        textAlign: TextAlign.left,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      child: Row(
                                        children: [
                                          tagContainer(isWhiteBg: true),
                                          tagContainer(
                                              icon: CupertinoIcons.arrow_up,
                                              text: 'Entrée G',
                                              color: Color.fromARGB(
                                                  255, 157, 3, 121),
                                              isWhiteBg: true),
                                          tagContainer(
                                              icon: CupertinoIcons.arrow_up,
                                              text: 'Team Leader',
                                              color: Color.fromARGB(
                                                  255, 2, 110, 149),
                                              withIcon: false,
                                              isWhiteBg: true),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // stats
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(color: Colors.white),
                          child: AppText.medium('Vos statistiques'),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              _statsContainer(context: context),
                              const SizedBox(width: 10),
                              _statsContainer(
                                  context: context,
                                  stat: '487',
                                  asset: 'assets/icons/menu/shipping-fast.svg',
                                  color: Color(0xFF1f306e),
                                  title: 'Livraisons',
                                  subTitle:
                                      'Nombre de livraisons que vous avez créez'),
                              const SizedBox(width: 10),
                              _statsContainer(
                                  context: context,
                                  stat: '12094',
                                  asset: 'assets/icons/menu/qr-scan.svg',
                                  color: Color.fromARGB(255, 31, 168, 152),
                                  title: 'Scans',
                                  subTitle:
                                      'Nombre de scans que vous avez faits'),
                              const SizedBox(width: 15),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Palette.separatorColor,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: BarChartSample2(),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            right: 15,
                            left: 15,
                            bottom: 10,
                          ),
                          width: double.infinity,
                          height: 320,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Palette.separatorColor,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: PieChartTickets(),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Palette.separatorColor,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: BarChartSample3(),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 25,
                          ),
                          child: CopyRight(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }),
          DraggableMenu()
        ],
      ),
    );
  }

  ClipRRect _statsContainer({
    required BuildContext context,
    String stat = '56787',
    String title = 'Visites',
    String subTitle = 'Nombre de visites que vous créez',
    Color color = const Color.fromARGB(255, 74, 0, 108),
    String asset = 'assets/icons/menu/ticket.svg',
  }) {
    return ClipRRect(
      child: Container(
        width: MediaQuery.of(context).size.width - 150,
        height: 90,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6.5),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Transform.rotate(
                angle: 0.8,
                child: SvgPicture.asset(
                  asset,
                  width: 100,
                  colorFilter: ColorFilter.mode(
                    color.withOpacity(0.2),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned(
              child: FittedBox(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppText.large(
                        stat,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: color,
                      ),
                      AppText.medium(
                        title,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      AppText.small(
                        subTitle,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column topStats(
      {String text = '1567',
      String icon = 'assets/icons/fleche-vers-le-haut.svg',
      Color color = const Color.fromARGB(255, 50, 146, 85),
      String subText = 'SORTIES'}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.small(
              text,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            SvgPicture.asset(
              icon,
              width: 16,
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn,
              ),
            )
          ],
        ),
        AppText.small(subText, fontSize: 9)
      ],
    );
  }

  Expanded _nameContainer() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              AppText.small(
                '#5',
                color: Color.fromARGB(255, 50, 146, 85),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              SvgPicture.asset(
                'assets/icons/fleche-vers-le-haut.svg',
                width: 12,
                colorFilter: ColorFilter.mode(
                  Color.fromARGB(255, 50, 146, 85),
                  BlendMode.srcIn,
                ),
              )
            ],
          ),
          AppText.large(
            'Emma Green',
            textAlign: TextAlign.start,
            fontSize: 20,
            maxLine: 1,
            color: const Color.fromARGB(255, 37, 37, 37),
          ),
        ],
      ),
    );
  }
}

/* Widget _lineChart() {
  return LineChart(
    LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          //gradient: LinearGradient(colors: [Colors.blue]),
          aboveBarData: BarAreaData(),
          spots: [
            FlSpot(0, 3),
            FlSpot(1, 4),
            FlSpot(2, 2),
            FlSpot(3, 5),
            FlSpot(4, 4),
            FlSpot(5, 3),
          ],
          isCurved: true,
          //colors: [Colors.blue],
          color: Colors.blue,
          belowBarData: BarAreaData(show: false),
        ),
        LineChartBarData(
          spots: [
            FlSpot(0, 2),
            FlSpot(1, 3),
            FlSpot(2, 4),
            FlSpot(3, 3),
            FlSpot(4, 2),
            FlSpot(5, 4),
          ],
          isCurved: true,
          color: Colors.red,
          belowBarData: BarAreaData(show: false),
        ),
      ],
    ),
  );
} */
