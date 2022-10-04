import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:places_app/helpers/location_helper.dart';
import 'package:places_app/screens/maps_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput(this.onSelectPlace);
  @override
  LocationInputState createState() {
    return LocationInputState();
  }
}

class LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> getCurrentLocation() async {
    final locData = await Location()
        .getLocation(); //first we need to instantiate the Location object and the we call
    //the getlocation member function to access user device location.
    _showPreview(locData.latitude, locData.longitude);
    widget.onSelectPlace(locData.latitude, locData.longitude);
  }

  Future<void> _selectOnMap() async {
    //method to handle stuff regarding manual location pick via user.
    final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(
      //Mentioning the return type in <> after thr puch operation is successful shows that <LatLng> type
//will be returned after pop() from the pushed page.
      MaterialPageRoute(
        fullscreenDialog:
            true, //OPTIONAL....NO USE .JUST TO PROVIDE DIFFERENT ANIMATION AND X BUTTON TO GO BACK ON APP BAR.
        builder: (ctx) => MapScreen(
          isSelecting: true, //user is now selecting
        ),
      ),
    );
    if (selectedLocation == null) {
      return; //if nothing is selected on the map screen
    }
    // print()
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          child: _previewImageUrl == null
              ? Text("No Location Chosen!", textAlign: TextAlign.center)
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )),
      Row(children: <Widget>[
        TextButton.icon(
          icon: Icon(Icons.location_on),
          label: Text('Get Current Location'),
          onPressed: getCurrentLocation,
          //textColor: Theme.of(context).primaryColor,
        ),
        TextButton.icon(
          icon: Icon(Icons.map),
          label: Text('Select on Map'),
          onPressed: _selectOnMap,
          //textColor: Theme.of(context).primaryColor,
        )
      ])
    ]);
  }
}
