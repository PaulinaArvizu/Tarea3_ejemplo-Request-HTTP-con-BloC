import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users list"),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc()..add(GetAllUsersEvent()),
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
                  // BlocProvider.of<HomeBloc>(context)
                  //     .add(FilterUsersEvent(filterEven: true));
                },
              );
            } else if (state is LoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: MaterialButton(
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(GetAllUsersEvent());
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
