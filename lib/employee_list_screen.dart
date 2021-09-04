import 'package:flutter/material.dart';
import 'package:flutterhivesample/DownloadTask.dart';
import 'package:flutterhivesample/applicant.dart';
import 'package:hive/hive.dart';
import 'add_applicant_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class EmployeesListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EmployeesListState();
  }
}

class EmployeesListState extends State<EmployeesListScreen> {
  List<Applicant> listApplicants = [];

  void getApplicants() async {
    final box = await Hive.openBox<Applicant>('Applicant');
    setState(() {
      listApplicants = box.values.toList();
    });
  }

  @override
  void initState() {
    getApplicants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Personal Details"),
          backgroundColor: Colors.deepPurple,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => AddOrEditEmployeeScreen()));
          },
        ),
        body: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          itemCount: listApplicants.length,
          itemBuilder: (context, position) {
            Applicant getApplicant = listApplicants[position];
            var mobile = getApplicant.mobile;
            var gender = getApplicant.Gender;
            print(getApplicant.image_url);
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DownloadTaskWidget(
                              title: "Download resume",
                              url: getApplicant.resume_url,
                              applicant: getApplicant,
                            )));
              },
              onLongPress: () {
                final box = Hive.box<Applicant>('Applicant');
                box.deleteAt(position);
                setState(() => {listApplicants.removeAt(position)});
              },
              child: Material(
                elevation: 2,
                child: Container(
                  height: 100,
                  width: 40,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(listApplicants[position].image_url),
                        minRadius: 50,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          getApplicant.firstname.toUpperCase() +
                              " " +
                              getApplicant.lastname.toUpperCase(),
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (int index) {
            return StaggeredTile.count(1, index.isEven ? 1 : 1);
          },
        ),
      ),
    );
  }
}
