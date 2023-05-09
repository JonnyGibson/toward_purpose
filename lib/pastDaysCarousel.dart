import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:toward_purpose/dataModel.dart';
import 'package:toward_purpose/extensions.dart';
import 'package:toward_purpose/styles.dart';

import 'dataProvider.dart';

class PastDaysCarousel extends StatefulWidget {
  @override
  _PastDaysCarouselState createState() => _PastDaysCarouselState();
}

class _PastDaysCarouselState extends State<PastDaysCarousel> {
  List<DateTime> days = [];
  Day day = new Day(date: DateTime.now());
  late DataProvider dataProvider;
  @override
  void initState() {
    super.initState();
  }

  Day getDay(DataProvider dataProvider, DateTime displayDate) {
    var data = dataProvider.data;
    var day = data.getToday(displayDate);
    if (day == null) {
      day = data.newDay(displayDate);
      if (data.days == null) data.days = [];
      data.days?.add(day);
      dataProvider.saveData();
    }
    return day;
  }

  Future showAddDayDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final dataProvider = context.read<DataProvider>();
        if (dataProvider.data.days == null) dataProvider.data.days = [];

        var originalText = day.qualitativeComment;
        var originalScore = day.dailyScore;

        return StatefulBuilder(
          builder: (context, setState) {
            int _selectedValue = day.dailyScore ?? 0;
            List<int> _values = [-2, -1, 0, 1, 2];
            TextEditingController controller =
                TextEditingController(text: day.qualitativeComment ?? "");

            return AlertDialog(
              title: Text("How was your day?"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextField(
                      maxLines: 3,
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                      onChanged: (value) {
                        day.qualitativeComment = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "How did it feel?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _values.map((value) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedValue = value;
                                });
                                _selectedValue = value;
                                day.dailyScore = value;
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                  color: _selectedValue == value
                                      ? secondaryColor
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    value.toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ).paddingAll(3),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if ((day.dailyScore == 0) &&
                        (day.qualitativeComment == "")) {
                      dataProvider.data.days
                          ?.removeWhere((element) => element.id == day.id);
                      dataProvider.saveData();
                    }
                    day.dailyScore = originalScore;
                    day.qualitativeComment = originalText;
                    Navigator.of(context).pop(false);
                    //  Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    //  setState(() {
                    day.dailyScore = _selectedValue;
                    dataProvider.saveData();
                    //  });
                    Navigator.of(context).pop(true);
                    // Navigator.pop(context);
                  },
                  child: Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<DateTime> getPastDays(int numDays, DateTime currentDate) {
    List<DateTime> days = [];
    for (int i = 0; i < numDays; i++) {
      days.add(currentDate.subtract(Duration(days: i)));
    }
    return days.reversed.toList();
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      day = getDay(dataProvider, days[index]);
    });
  }

  List<Container>? getActivities(BuildContext context, Day? day) {
    final dataProvider = context.watch<DataProvider>();
    List<int> _values = [1, 2, 3, 4, 5];
    return day?.measurables?.map((element) {
      return Container(
        child: Card(
          child: ListTile(
                  title: Text(
                    element.name ?? "Not Set",
                    style: GruppoSmall(),
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          children: List.generate(
                            _values.length,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    element.engagement = index + 1;

                                    dataProvider.saveData();
                                  });
                                },
                                child: Icon(
                                  Icons.star,
                                  color: element.engagement > index
                                      ? Colors.amber
                                      : Colors.grey,
                                ).paddingAll(3),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ).paddingLTRB(0, 10, 0, 0))
              .paddingLTRB(0, 5, 0, 5),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    dataProvider = context.watch<DataProvider>();

    DateTime currentDate = DateTime.now();
    days = getPastDays(28, currentDate);
    var _day = getDay(dataProvider, days.last);
    List<int> _dayValues = [-2, -1, 0, 1, 2];
    return CarouselSlider(
      items: days.map((element) {
        _day = getDay(dataProvider, element);
        return Container(
            decoration: BoxDecoration(
              color: Colors.amber[50],
              border: Border.all(
                color: secondaryColor,
                width: 1,
              ),
            ),
            child: ListView(children: [
              ListTile(
                  title: Align(
                alignment: Alignment.center,
                child: Text(formatDate(_day.date)),
              )),
              ...?getActivities(context, _day),
              ListTile(
                  title: Align(
                      alignment: Alignment.center,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showAddDayDialog(context)
                              .then((value) => setState(() {}));
                        },
                        icon: Icon(Icons.calendar_month),
                        label: Text("Daily check in"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: redyColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          side: BorderSide(color: secondaryColor, width: 2),
                        ),
                      )).paddingLTRB(0, 0, 0, 10),
                  subtitle: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _dayValues.map((value) {
                        final opacity = {
                              -2: 0.4,
                              -1: 0.5,
                              0: 0.6,
                              1: 0.8,
                              2: 1.0,
                            }[value] ??
                            1.0;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _day.dailyScore = value;
                              dataProvider.saveData();
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey),
                              color: day.dailyScore == value
                                  ? secondaryColor.withOpacity(opacity)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                value.toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ).paddingAll(3),
                        );
                      }).toList(),
                    ),
                    Text(day.qualitativeComment ?? "").paddingAll(10)
                  ]))
            ])).paddingLTRB(0, 0, 0, 20);
      }).toList(),
      options: CarouselOptions(
          height: double.infinity,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          onPageChanged: onPageChanged,
          initialPage: days.length - 1),
    );
  }
}
