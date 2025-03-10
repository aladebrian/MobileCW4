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
  TextEditingController nameTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();

  Draggable draggableListTile(index) {
    return Draggable<GestureDetector>(
      feedback: listTilePlan(index),
      child: GestureDetector(
        onDoubleTap: () => changeName(index),
        child: listTilePlan(index),
      ),
    );
  }

  Material listTilePlan(index) {
    return Material(
      child: ListTile(
        title: Text(plans[index].name),
        subtitle: Text(plans[index].description),
        tileColor: plans[index].completed ? Colors.green : Colors.red,
      ),
    );
  }

  void changeName(index) {
    setState(() {
      plans[index].name = "bartholemew";
    });
  }

  void addPlan() {
    setState(() {
      plans.add(
        Plan(
          name: nameTextController.text,
          description: descriptionTextController.text,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Row(
        children: [
          Column(
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
          Column(
            children: [
              TextButton(onPressed: addPlan, child: Text("Add Plan")),
              SizedBox(
                width: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    return draggableListTile(index);
                  },
                ),
              ),
            ],
          ),
          // SizedBox(
          //   child: GridView.builder(
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 4,
          //     ),
          //     itemBuilder: (context, index) {
          //       return SizedBox();
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
