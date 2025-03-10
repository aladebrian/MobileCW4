import 'dart:collection';

import 'package:flutter/material.dart';
import 'plan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const PlanManagerScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({super.key, required this.title});

  final String title;

  @override
  State<PlanManagerScreen> createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [Plan(name: "Plan 1", description: "This is plan 1")];
  Map<int, List<Plan>> orderedPlans = {};
  TextEditingController nameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  List<String> days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  String currentView = "month";
  int currentDay = -1;
  Draggable draggableListTile(index) {
    return Draggable<Plan>(
      feedback: unorderedListTilePlan(index),
      data: plans[index],
      child: GestureDetector(
        onDoubleTap: () => changeName(index),
        child: SizedBox(
          width: 250,
          height: 300,
          child: unorderedListTilePlan(index),
        ),
      ),
    );
  }

  Material unorderedListTilePlan(index) {
    return Material(
      child: SizedBox(
        width: 250,
        height: 50,
        child: ListTile(
          title: Text(plans[index].name),
          tileColor: plans[index].completed ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  ListTile orderedListTilePlan(index) {
    return ListTile(
      title: Text(orderedPlans[currentDay]![index].name),
      subtitle: Text(orderedPlans[currentDay]![index].description),
      tileColor: plans[index].completed ? Colors.green : Colors.red,
    );
  }

  void changeName(index) {
    setState(() {
      plans[index].name = "bartholemew";
    });
  }

  void addUnorderedPlan() {
    setState(() {
      plans.add(
        Plan(
          name: nameTextController.text,
          description: descriptionTextController.text,
        ),
      );
    });
  }

  void addOrderedPlan(int date, Plan plan) {
    setState(() {
      if (orderedPlans.containsKey(date)) {
        orderedPlans[date]!.add(plan);
      } else {
        orderedPlans[date] = [plan];
      }
    });
  }

  void seeDay(index) {
    setState(() {
      currentView = 'day';
      currentDay = index - 6;
    });
  }

  void back() {
    setState(() {
      currentView = 'month';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Row(
        children: [
          // Text Fields
          SizedBox(
            width: 300,
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  height: 200,
                  child: TextField(
                    controller: nameTextController,
                    decoration: InputDecoration(hintText: "name"),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 200,
                  child: TextField(
                    controller: descriptionTextController,
                    decoration: InputDecoration(hintText: "description"),
                  ),
                ),
              ],
            ),
          ),
          // Unordered Plans
          SizedBox(
            width: 300,
            child: Column(
              children: [
                TextButton(
                  onPressed: addUnorderedPlan,
                  child: Text("Add Plan"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: plans.length,
                    itemBuilder: (context, unorderedPlanIndex) {
                      return draggableListTile(unorderedPlanIndex);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Calendar
          if (currentView == 'month')
            SizedBox(
              width: 300,
              child: GridView.builder(
                itemCount: 37,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemBuilder: (context, dayIndex) {
                  if (dayIndex < 7) {
                    return Text(days[dayIndex]);
                  } else {
                    return TextButton(
                      onPressed: () => seeDay(dayIndex),
                      child: Text("${dayIndex - 6}"),
                    );
                  }
                },
              ),
            ), 
          // Ordered Plans fron day
          if (currentView == 'day')
            Container(
              width: 300,
              color: Colors.orange,
              child: Column(
                children: [
                  Text("Day: $currentDay"),
                  TextButton(onPressed: back, child: Text("Back")),
                  Expanded(
                    child: DragTarget<Plan>(
                      builder: (context, candidateDAta, rejectedData) {
                        return ListView.builder(
                          itemCount:
                              orderedPlans[currentDay]?.length == null
                                  ? 0
                                  : orderedPlans[currentDay]!.length,
                          itemBuilder: (context, orderedPlanIndex) {
                            return orderedListTilePlan(orderedPlanIndex);
                          },
                        );
                      },

                      onWillAcceptWithDetails: (details) => true,
                      onAcceptWithDetails:
                          (details) => addOrderedPlan(currentDay, details.data),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
