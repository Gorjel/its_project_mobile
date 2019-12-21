import 'location.dart';

class Place{
  String name;
  String category;
  double rating;
  int duration_from_previous;
  Location location;
  Place({this.name, this.category, this.rating, this.duration_from_previous, this.location});

  factory Place.fromJson(Map<String, dynamic> json){
    return Place(
      name: json["name"],
      category: json['category'] == null ? "other" : json['category'],
      rating : json['rating'] == null ? 0 : json['rating'],
      duration_from_previous: json['duration'],
      location: Location(lat : json['location']['lat'], lng :json['location']['lng']),
    );
  }
}
