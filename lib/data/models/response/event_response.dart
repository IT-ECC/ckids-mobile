import 'package:eccmobile/data/models/response/participant_response.dart';
import 'package:eccmobile/data/models/response/person_event_response.dart';

import 'package:eccmobile/data/models/response/person_event_response.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/util/helper.dart';

class EventResponse {
  EventResponse({
    required this.id,
    required this.branchId,
    required this.title,
    required this.place,
    required this.startDate,
    required this.startDateFormatted,
    required this.endDate,
    required this.endDateFormatted,
    required this.maxVisitor,
    required this.photo,
    required this.isPaid,
    required this.price,
    required this.startRegistrationDate,
    required this.startRegistrationDateFormatted,
    required this.endRegistrationDate,
    required this.endRegistrationDateFormatted,
    required this.bookingRequired,
    required this.membersCount,
    this.listFamilyResponse = const [],
    this.listParticipanResponse = const [],

    required this.minimumAge,
    required this.maximumAge,
    required this.isActive,
  });

  late final String id;
  late final String branchId;
  late final String title;
  late final String place;
  late final String startDate;
  late final String startDateFormatted;
  late final String endDate;
  late final String endDateFormatted;
  late final int maxVisitor;
  late final String photo;
  late final bool isPaid;
  late final String price;
  late final String startRegistrationDate;
  late final String startRegistrationDateFormatted;
  late final String endRegistrationDate;
  late final String endRegistrationDateFormatted;
  late final bool bookingRequired;
  late final int membersCount;
  late final List<FamilyResponse> listFamilyResponse;
  late final List<ParticipantResponse> listParticipanResponse;

  late final int minimumAge;
  late final int maximumAge;
  late final bool isActive;


  bool get isBooked => ((maxVisitor - membersCount == 0) ? true : false);
  String get visitorMember => "${membersCount} / ${maxVisitor} Members";
  double get percentVisitorMember => membersCount / maxVisitor;
  double get amount => double.tryParse(price) ?? 0;
  String get priceEvent => (isPaid) ? Format.money(amount) : "FREE";
  String get maximumAgeEvent => "${minimumAge} - ${maximumAge} year";
  String get eventCardSubtitle => "${eventDate} \n${maximumAgeEvent}";
  String get eventDate => "${startDateFormatted} - ${endDateFormatted}";

  // TODO : Implement Participants
  EventResponse.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      branchId = json['branch_id'];
      title = json['title'];
      place = json['place'];
      startDate = json['start_date'];
      startDateFormatted = json['start_date_formatted'];
      endDate = json['end_date'];
      endDateFormatted = json['end_date_formatted'];
      maxVisitor = json['max_visitor'];
      photo = json['photo'];
      isPaid = json['is_paid'];
      price = json['price'] ?? 0;
      startRegistrationDate = json['start_registration_date'];
      startRegistrationDateFormatted = json['start_registration_date_formatted'];
      endRegistrationDate = json['end_registration_date'];
      endRegistrationDateFormatted = json['end_registration_date_formatted'];
      bookingRequired = json['booking_required'];
      membersCount = json['members_count'] ?? 0;
      listFamilyResponse = (json['families']['data'] != null) ? List.from(json['families']['data']).map((e) => FamilyResponse.fromJson(e)).toList() : [];
      listParticipanResponse = (json['participants']['data'] != null) ? List.from(json['participants']['data']).map((e) => ParticipantResponse.fromJson(e)).toList() : [];

      isActive = json['is_active'];
      minimumAge = json['minimum_age'];
      maximumAge = json['maximum_age'];
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }
}