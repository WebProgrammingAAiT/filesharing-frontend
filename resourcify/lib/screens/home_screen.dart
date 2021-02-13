import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:resourcify/bloc/add_resource/add_resource_bloc.dart';
import 'package:resourcify/bloc/auth_bloc.dart';
import 'package:resourcify/bloc/resource/resource_bloc.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/screens/screens.dart';
import 'package:resourcify/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories;
  @override
  void initState() {
    BlocProvider.of<ResourceBloc>(context).add(FetchResources(""));
    super.initState();
  }

  Future<void> onRefresh() async {
    return context.read<ResourceBloc>().add(FetchResources(''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        leading: SizedBox.shrink(),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(RemoveJwt());
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              })
        ],
      ),
      body: BlocListener<AddResourceBloc, AddResourceState>(
        listener: (context, state) {
          if (state is ResourceCreated) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Resource uploaded succesfully'),
              ),
            );
            context.read<ResourceBloc>().add(FetchResources(''));
          }
        },
        child: BlocConsumer<ResourceBloc, ResourceState>(
          listener: (context, state) {
            print(state);
            if (state is ResourceError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ResourceInitial || state is ResourceLoading) {
              return _buildCircularProgressIndicator();
            } else if (state is ResourcesLoaded) {
              categories = state.categories;
              return RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView(children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Text("All",
                                    style: TextStyle(
                                      fontSize: 20,
                                    )),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(".",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xff3967D6),
                                        )),
                                    SizedBox(height: 8)
                                  ],
                                ),
                                SizedBox(width: 2),
                                Text("${state.resources.length}" + " results",
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
                    itemCount: state.resources.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ResourceWidget(
                        resource: state.resources[index],
                      );
                    },
                  )
                ]),
              );
            } else {
              return Center(
                child: Text('Resource state is =>> $state'),
              );
            }
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        marginEnd: 18,
        marginBottom: 20,

        icon: Icons.add,
        activeIcon: Icons.remove,

        buttonSize: 56.0,
        visible: true,

        /// If true user is forced to close dial manually
        /// by tapping main button and overlay is not rendered.
        closeManually: false,

        /// If true overlay will render no matter what.
        renderOverlay: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,

        tooltip: 'Add resource',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.image),
            backgroundColor: Colors.red,
            label: 'Image',
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddResourceScreen(
                  type: 'image',
                  categories: categories,
                ),
              ),
            ),
          ),
          SpeedDialChild(
            child: Icon(Icons.description),
            backgroundColor: Colors.blue,
            label: 'Pdf',
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddResourceScreen(
                  type: 'pdf',
                  categories: categories,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // BlocConsumer<AuthBloc, AuthState>(
    //   listener: (context, state) {
    //     if (state is AuthJwtRemoved) {
    //       Navigator.pushReplacement(
    //           context, MaterialPageRoute(builder: (_) => LoginScreen()));
    //     }
    //   },
    //   builder: (context, state) {
    //     if (state is AuthLoaded || state is AuthJwtLoaded) {
    //       return Scaffold(
    //         appBar: AppBar(
    //           title: Text("This is user's home screen"),
    //           actions: [
    //             IconButton(
    //                 icon: Icon(Icons.logout),
    //                 onPressed: () {
    //                   BlocProvider.of<AuthBloc>(context).add(RemoveJwt());
    //                 })
    //           ],
    //         ),
    //         body: ResourceList(),
    //         floatingActionButton: FloatingActionButton(
    //           backgroundColor: Color(0xff3967D6),
    //           child: Icon(Icons.add),
    //           onPressed: () {},
    //         ),
    //       );
    //     } else {
    //       return Scaffold(
    //         body: Center(
    //           child: Text('Auth state isin homescreen =>> $state'),
    //         ),
    //       );
    //     }
    //   },
    // );
  }

  Widget _buildCircularProgressIndicator() {
    return Center(child: CircularProgressIndicator());
  }
}
