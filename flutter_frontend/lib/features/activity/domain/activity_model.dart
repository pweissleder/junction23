class ActivityModel {
  String assoc_skill;
  String name;
  String description;
  int xpReward;
  int coinReward;
  String status;
  int sensorStartValue;
  double progress;
  int targetValue;

  // Constructor
  ActivityModel(
      {required this.assoc_skill,
      required this.name,
      required this.description,
      required this.xpReward,
      required this.coinReward,
      required this.status,
      required this.sensorStartValue,
      required this.progress,
      required this.targetValue});

  // Convert JSON to ActivityModel
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
        assoc_skill: json['assoc_skill'],
        name: json['name'],
        description: json['description'],
        xpReward: json['xp_reward'],
        coinReward: json['coin_reward'],
        status: json['status'],
        sensorStartValue: json['sensor_start_value'],
        progress: json['progress'],
        targetValue: json['target_value']);
  }

  // Convert ActivityModel to JSON
  Map<String, dynamic> toJson() => {
        'assoc_skill': assoc_skill,
        'name': name,
        'description': description,
        'xp_reward': xpReward,
        'coin_reward': coinReward,
        'status': status,
        'progress': progress,
        'sensor_start_value': sensorStartValue,
        'target_value': targetValue
      };
}
