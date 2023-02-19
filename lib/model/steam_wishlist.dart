import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:steam_wishlist_spy/model/game_info.dart';

class SteamWishlist {
  static const _authority = "store.steampowered.com";
  final String _path;
  final String? _steamId;

  SteamWishlist(this._steamId)
      : _path = "/wishlist/profiles/$_steamId/wishlistdata";

  Future<List<GameInfo>> loadWishlist() async {
    List<GameInfo> gameInfoList = [];
    try {
      final response = await http.get(Uri.https(_authority, _path));
      var responseData = json.decode(response.body);

      // If the SteamID is wrong or the account is not public
      if (responseData['success'] != null) {
        return Future(() => gameInfoList);
      }

      for (var singleInfo in responseData.values) {
        if (singleInfo['subs'].length != 0) {
          GameInfo singleGameInfo = GameInfo(
              name: singleInfo['name'],
              price: singleInfo['subs'][0]['price'],
              discountPct: singleInfo['subs'][0]['discount_pct']);

          gameInfoList.add(singleGameInfo);
        }
      }
      return gameInfoList;
    } catch (e) {
      // If there are problems with your Internet connection
      return Future(() => gameInfoList);
    }
  }
}
