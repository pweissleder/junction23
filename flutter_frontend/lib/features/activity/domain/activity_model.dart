abstract class ActivityModel {
  late String category;

  // Constructor
  ActivityModel(this.category);

  // Convert JSON to ActivityModel
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as String;
    if (category == 'Walking') {
      return WalkingActivityModel.fromJson(json);
    }
    throw ArgumentError('Unsupported ActivityModel category: $category');
  }

  // Convert ActivityModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'category': category,
    };
  }
}

class WalkingActivityModel extends ActivityModel {
  int steps;
  // Constructor
  WalkingActivityModel({required this.steps}) : super('Walking');

  // Override fromJson
  factory WalkingActivityModel.fromJson(Map<String, dynamic> json) {
    if (json['category'] == 'walking') {
      return WalkingActivityModel(steps: json['steps'] as int);
    }
    throw ArgumentError('Invalid JSON for WalkingActivityModel');
  }
}

class SwimmingActivityModel extends ActivityModel {
  double minutes;
  // Constructor
  SwimmingActivityModel({required this.minutes}) : super('Swimming');

  // Override fromJson
  factory SwimmingActivityModel.fromJson(Map<String, dynamic> json) {
    if (json['category'] == 'swimming') {
      var minutes = json["minutes"];
      if (minutes is int) {
        // Convert the int to a double
        final doubleValue = minutes.toDouble();
        minutes = doubleValue;
      } else if (minutes is double) {
        // If it's already a double, just return it
        minutes = minutes;
      } else {
        throw Exception("Field is not a valid number");
      }
      return SwimmingActivityModel(minutes: minutes);
    }
    throw ArgumentError('Invalid JSON for SwimmingActivityModel');
  }
}

class TeamSportsActivityModel extends ActivityModel {
  double minutes;

  // Constructor
  TeamSportsActivityModel({required this.minutes}) : super('Team Sports');

  // Override fromJson
  factory TeamSportsActivityModel.fromJson(Map<String, dynamic> json) {
    var minutes = json["minutes"];
    if (minutes is int) {
      // Convert the int to a double
      final doubleValue = minutes.toDouble();
      minutes = doubleValue;
    } else if (minutes is double) {
      // If it's already a double, just return it
      minutes = minutes;
    } else {
      throw Exception("Field is not a valid number");
    }

    if (json['category'] == 'team_sports') {
      return TeamSportsActivityModel(minutes: minutes);
    }
    throw ArgumentError('Invalid JSON for TeamSportsActivityModel');
  }
}
