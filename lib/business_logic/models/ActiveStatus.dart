class ActiveStatus {
  static final List<ActiveStatus> statusOptions = [
    ActiveStatus("Active"),
    ActiveStatus("Pending")
  ];

  String activeStatus;

  ActiveStatus(this.activeStatus);
}
