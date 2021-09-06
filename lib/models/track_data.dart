class TrackData {
  int _id;
  int get id => _id;
  String uuid;
  DateTime trackDT;

  TrackData(
    this._id, {
    this.uuid,
    this.trackDT,
  });
}
