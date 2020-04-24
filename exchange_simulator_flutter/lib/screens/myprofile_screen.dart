import 'package:exchange_simulator_flutter/bloc/myProfile/myProfile.dart';
import 'package:exchange_simulator_flutter/models/user_model.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/loading_screen.dart';
import 'package:exchange_simulator_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileScreen extends StatelessWidget{

  MyProfileScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyProfileBloc>(
      create: (context) => MyProfileBloc(UserRepository.getInstance())..add(InitMyProfile()),
      child: BlocBuilder<MyProfileBloc, MyProfileState>(
        builder: (context, state) {
          if (state is MyProfileInitial)
            return LoadingScreen("Ładowanie pieniędzy na serwer...");
          else if (state is MyProfileError)
            return ErrorScreen(state.message);
          else {
            return buildMyProfile(context, (state as MyProfileFetched).user);
          }
        },
      ),
    );
  }

  Widget buildMyProfile(BuildContext context, User user){
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: Text( 'Mój Profil' ),
      ),
      body: ListView(
        children: <Widget>[
          _buildNameAndStatus(user.name, "Początkujący inwestor"),
          _buildItem("Stan konta:", "${user.amountOfPLN}", Icons.account_balance_wallet),
          SizedBox(height: 15,),
          _buildItem("Email:", "${user.email}", Icons.email),
          SizedBox(height: 15,),
          _buildItem("liczba inwestycji:", "2", Icons.show_chart),
          SizedBox(height: 15,),
        ],
      ),
    );
  }


  Widget _buildNameAndStatus(String name, String status) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Text(name, style: TextStyle(fontSize: 28, foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = Colors.cyanAccent), textAlign: TextAlign.center,),
              SizedBox(height: 5,),
              Text(status, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10),)
            ],
          )
    );
  }

  Widget _buildItem(String label, String count, IconData icon) {
    TextStyle _statStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.white,
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
    );
    return  Container(
        decoration: BoxDecoration(
          color: Colors.black12,),
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: ListTile(
            leading: Text(
              label,
              style: _statStyle,
            ),
            title: Row(
              children: <Widget>[
                Icon(icon),
                SizedBox(width: 10,),
                Text(
                  count,
                  style: _statStyle,
                ),
              ],
            ),
          ),
        )
    );
  }





}