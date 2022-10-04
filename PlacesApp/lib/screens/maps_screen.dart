import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen({
    this.initialLocation = const PlaceLocation(
        latitude: 37.422,
        longitude:
            -122.084), //by default it is google plex location. Must be a constant
    this.isSelecting = false, //user isn't selecting the location.
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng pickedLocation;
  void selectPlace(LatLng g) {
    setState(() {
      pickedLocation = g;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: pickedLocation == null
                  ? null
                  : () => Navigator.of(context).pop(pickedLocation)),
          //we need to pass the picked location as the argument to the LocationInput when we pop of the screen.
        ],
      ),
      body: GoogleMap(
        //provided by google_maps_flutter package.
        //The initial position of the map's camera.
        initialCameraPosition: CameraPosition(
          //one thing to configure. Creates a immutable representation of the [GoogleMap] camera.
          target: LatLng(
            //Creates a geographical location specified in degrees [latitude] and [longitude].
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelecting
            ? selectPlace
            : null, //Maps API will automatically transfer theLatLang argument to our method
        markers: (pickedLocation == null && widget.isSelecting)
            ? null
            : {
                //set of markers...unique values
                Marker(
                    markerId: MarkerId('m1'),
                    position: pickedLocation ??
                        LatLng(widget.initialLocation.latitude,
                            widget.initialLocation.longitude)),
                            //This means if isSelecting is false or pickedLocation is null we need a marker
                            //when we select a location on the map picked location isn't null but isSelectio is true.
//when we tap the screen Maps Service automatically transfer the lat and longs in selectPlace method and marker is setup 
//for position picked position. Where as when we open maps screen via details screen we just override initialLocation
// and set isSelecting to false. then we need a marker. for that we will check is pickedLocation is null...which it would be
// and hence we will pass LatLng() as positional parameters to form a mrker for passed coordinates.                            
              },
      ),
    );
  }
}
