import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc _homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text(
                  'Filtrar usuarios',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.all_inclusive),
              title: Text('Todos'),
              onTap: () {
                _homeBloc..add(GetAllUsersEvent());
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Pares'),
              onTap: () {
                _homeBloc..add(FilterUsersEvent(filterEven: true));
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Impares'),
              onTap: () {
                _homeBloc..add(FilterUsersEvent(filterEven: false));
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Users list"),
      ),
      body: BlocProvider(
        create: (context) => _homeBloc..add(GetAllUsersEvent()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            // para mostrar dialogos o snackbars
            if (state is ErrorState) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text("Error: ${state.error}")),
                );
            }
          },
          builder: (context, state) {
            if (state is ShowUsersState) {
              return RefreshIndicator(
                child: ListView.separated(
                  itemCount: state.usersList.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: (state.usersList[index].id % 2 == 0)
                          ? Icon(Icons.add)
                          : Icon(Icons.remove),
                      title: Text(state.usersList[index].name),
                      subtitle: Text(
                          'Company: ${state.usersList[index].company.name}'
                          '\nStreet: ${state.usersList[index].address.street}'
                          '\nPhone: ${state.usersList[index].phone}'),
                      isThreeLine: true,
                    );
                  },
                ),
                onRefresh: () async {
                  BlocProvider.of<HomeBloc>(context).add(GetAllUsersEvent());
                },
              );
            } else if (state is LoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: MaterialButton(
                onPressed: () {
                  _homeBloc.add(GetAllUsersEvent());
                },
                child: Text("Cargar de nuevo"),
              ),
            );
          },
        ),
      ),
    );
  }
}
