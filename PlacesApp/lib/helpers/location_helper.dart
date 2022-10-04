import 'dart:convert';
import 'package:http/http.dart' as http;
const GOOGLE_API_KEY = 'AIzaSyBg9yn5JtQgKRFbg6FCTy4ewbF24kRuAYI';

class LocationHelper {
  static String generateLocationPreviewImage({double latitude, double longitude,}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }
  static Future<String> getPlaceAddress(double lat, double lng) async {
    //This method will return the address readable format for the provided lat long pair in the geoencoding api URL below
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(url);//sending the request to this URL and waiting for its response.
    return json.decode(response.body)['results'][0]['formatted_address'];
    //['results' tag contains the list of many relevant encoded addresses for the provided LatLng][0] means choose the most
    //relevant one,['formatted address'] part of the most relevant address contains address in the human readable form.
  }
}