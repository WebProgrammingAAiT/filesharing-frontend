import 'package:flutter/material.dart';
import 'resource_card_widget.dart';
import '../bloc/resource/resource_bloc.dart';
import '../repository/resource_repository.dart';

class ResourceList extends StatefulWidget {
  ResourceList({this.scrollController});
  final ScrollController scrollController;
  @override
  ResourceListState createState() => ResourceListState(this.scrollController);
}

class ResourceListState extends State<ResourceList> {
  ResourceListState(this.scrollController);

  //User user;
  final ScrollController scrollController;
  ResourceBloc resourceBloc = ResourceBloc(repo: ResourceRepository());
  bool loading = false;

  @override
  void initState() {
    super.initState();
    populateData();

  }

  populateData() async {

    resourceBloc.actionSink.add(FetchResources("prefs.getString('UserId')"));
  }

  @override
  void dispose() {
    // TODO: impleme nt dispose
    super.dispose();
    resourceBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return   Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: <Widget>[
                        mainList(context),
                      ],
                    ));
  }

  Future<void> refresh() async {
    resourceBloc.actionSink.add(ReloadResources("prefs.getString('UserId')"));
    resourceBloc.actionSink.add(FetchResources("prefs.getString('UserId')"));
  }

  mainList(BuildContext context) {
    return Expanded(
        child: RefreshIndicator(
            onRefresh: refresh,
            child: StreamBuilder(
              stream: resourceBloc.resourceStream,
              builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasData) {
                            int length=snapshot.data.length;
                  return ListView(
                          children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child:
                                          Row(
                                            children: [
                                      Text("All",
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                          SizedBox(width: 5),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(".",style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: Color(0xff3967D6),
                                                  )),
                                                  SizedBox(height:8)
                                                ],
                                              ),
                                          SizedBox(width: 2),

                                              Text("$length"+" results",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff3967D6),
                                                  )),
                                            ],
                                          ),
                                        
                                      ),
                                    ],
                                  )),
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ResourceWidget(resource: snapshot.data[index],);
                                },
                              )
                            ]);
                }
                },
            )));
  }

}
