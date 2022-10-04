import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:places_app/helpers/db_helper.dart';
import 'package:places_app/helpers/location_helper.dart';

import '../models/place.dart';

//This manages the file system SQLite query run calling DBHelper and manages local aplication memory management.
class GreatPlaces with ChangeNotifier {
  List<Place> _items = []; //local app memory.

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id){
    return _items.firstWhere((element) => element.id==id);
  }

  Future<void> addPlace(
    String pickedTitle,
    File pickedImage,
    PlaceLocation pickedLocation,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: pickedImage,
      title: pickedTitle,
      location: updatedLocation,
    );
    _items.add(newPlace);//App memory loaded/updated.//now update the device memory
    notifyListeners();//notify all listeners
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item[
                'image']), //though in database the image File is saved as a string determining path of the file
// we need to add this here in _items (in this provider) as an Actual file...so we just use new File Cunstructor and pass path to it that was
// there in database (SQLite).
            location: PlaceLocation(
                  latitude: item['loc_lat'],
                  longitude: item['loc_lng'],
                  address: item['address'],
                ),
          ),
        )
        .toList(); //fetch from mobile database + update the app local memory, and notify
    notifyListeners();
  }
}
