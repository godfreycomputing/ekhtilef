class OrderDeliveryDate {
  String? timeStamp;
  String? dateString;
  DateTime? dateTime;

  OrderDeliveryDate(this.dateTime);

  OrderDeliveryDate.fromJson(json) {
    timeStamp = json['timestamp'].toString();
    dateString = json['date'];
    if (json['dateTime'] == null) {
      dateTime = DateTime(
          int.parse(dateString!.split('-')[2]),
          int.parse(dateString!.split('-')[1]),
          int.parse(dateString!.split('-')[0]));
    } else {
      dateTime = DateTime.parse(json['dateTime']);
    }
  }

  Map toJson() {
    return {
      'timestamp': timeStamp,
      'datetime': dateTime.toString(),
      'date': dateString,
    };
  }
}
