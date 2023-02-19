import 'dart:io';
import 'package:flutter/material.dart';
import 'package:steam_wishlist_spy/model/local_storage.dart';
import 'package:steam_wishlist_spy/model/steam_wishlist.dart';
import 'package:desktop_window/desktop_window.dart';

void main() async {
  runApp(const MyApp());
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    DesktopWindow.setWindowSize(const Size(600, 800));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steam Wishlist Spy',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Steam Wishlist Spy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _steamIdFieldController = TextEditingController();
  final _localStorage = LocalStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.update),
              tooltip: 'Update Wishlist',
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Container(
              padding: const EdgeInsets.all(16.0),
              child: getWishlistWidget(),
            ))),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _localStorage.clearSteamId();
            });
          },
          child: const Icon(Icons.account_circle),
        ));
  }

  Widget? getWishlistWidget() {
    return FutureBuilder(
        future: _localStorage.loadSteamId(),
        builder: (BuildContext ctx, AsyncSnapshot<String?> steamId) {
          if (steamId.hasData) {
            return FutureBuilder(
                future: SteamWishlist(steamId.data).loadWishlist(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data.length == 0) {
                      return const Text(
                        '1. Check your internet connection\n' "2. Maybe you entered the wrong SteamID\n or didn't make your account public.\n" +
                            '\nClick "Account" floating button\n and try to change your SteamID',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctx, index) => ListTile(
                          title: Text(snapshot.data[index].name),
                          subtitle: Text(snapshot.data[index].getPrice() +
                              ' ' +
                              snapshot.data[index].getDiscountPct()),
                          contentPadding: const EdgeInsets.only(bottom: 20.0),
                        ),
                      );
                    }
                  }
                });
          } else {
            return enterSteamIdWidget();
          }
        });
  }

  Widget enterSteamIdWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: _steamIdFieldController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter your Steam ID',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  setState(() {
                    _localStorage
                        .saveSteamId(_steamIdFieldController.text.toString());
                  });
                },
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Text(
            "Enter your SteamID\n*Don't forget that your account\nmust be public",
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
