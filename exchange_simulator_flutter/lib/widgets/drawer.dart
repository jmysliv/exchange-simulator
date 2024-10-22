import 'package:exchange_simulator_flutter/repositories/bet_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exchange_simulator_flutter/bloc/authentication/authentication.dart';

class HomeDrawer extends StatelessWidget{

  HomeDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image:  AssetImage('assets/images/drawer.jpg'))),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.home),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Home'),
                )
              ],
            ),
            onTap: () {
              Navigator.popAndPushNamed(context, "/home");
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.monetization_on),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Waluty'),
                )
              ],
            ),
            onTap: () {
              Navigator.popAndPushNamed(context, "/currencies");
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.score),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Ranking'),
                )
              ],
            ),
            onTap: () {
              Navigator.popAndPushNamed(context, "/ranking");
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.account_balance_wallet),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Moje inwestycje'),
                )
              ],
            ),
            onTap: () {
              Navigator.popAndPushNamed(context, "/bets");
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.perm_identity),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Mój Profil'),
                )
              ],
            ),
            onTap: () {
              Navigator.popAndPushNamed(context, "/my-profile");
            },
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.exit_to_app),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Wyloguj się'),
                )
              ],
            ),
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacementNamed("/login");
            },
          ),
        ],
      ),
    );
  }
}