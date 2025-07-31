import 'package:equatable/equatable.dart';

class AddEventBody extends Equatable {
  late final String? title;
  late final String? description;
  late final String? place;
  late final String? branchId;
  late final String? startDate;
  late final String? endDate;
  late final bool? isVisitorUnlimited;
  late final int? maxVisitor;
  late final bool? isPaid;
  late final int? price;
  late final int? minimumAge;
  late final int? maximumAge;
  late final String? startRegistrationDate;
  late final String? endRegistrationDate;
  late final bool? bookingRequired;
  late final String? photo;

  AddEventBody({
    this.title,
    this.description,
    this.branchId,
    this.startDate,
    this.endDate,
    this.isVisitorUnlimited,
    this.maxVisitor,
    this.isPaid,
    this.price,
    this.place,
    this.minimumAge,
    this.maximumAge,
    this.startRegistrationDate,
    this.endRegistrationDate,
    this.bookingRequired,
    this.photo,
  });

  // TODO : not working
  AddEventBody copyWith({
    String? title,
    String? description,
    String? place,
    String? branchId,
    String? startDate,
    String? endDate,
    bool? isVisitorUnlimited,
    int? maxVisitor,
    bool? isPaid,
    int? price,
    int? minimumAge,
    int? maximumAge,
    String? startRegistrationDate,
    String? endRegistrationDate,
    bool? bookingRequired,
    String? photo,
  }) {
    return AddEventBody(
      title: title ?? this.title,
      description: description ?? this.description,
      branchId: branchId ?? this.branchId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isVisitorUnlimited: isVisitorUnlimited ?? this.isVisitorUnlimited,
      maxVisitor: maxVisitor ?? this.maxVisitor,
      isPaid: isPaid ?? this.isPaid,
      price: price ?? this.price,
      place: place ?? this.place,
      minimumAge: minimumAge ?? this.minimumAge,
      maximumAge: maximumAge ?? this.maximumAge,
      startRegistrationDate: startRegistrationDate ?? this.startRegistrationDate,
      endRegistrationDate: endRegistrationDate ?? this.endRegistrationDate,
      bookingRequired: bookingRequired ?? this.bookingRequired,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['description'] = description;
    _data['branch_id'] = branchId;
    _data['is_visitor_capacity_unlimited'] = isVisitorUnlimited;
    _data['max_visitor'] = maxVisitor;
    _data['is_paid'] = isPaid;
    _data['price'] = price;
    _data['place'] = place;
    _data['minimum_age'] = minimumAge;
    _data['maximum_age'] = maximumAge;
    _data['start_date'] = startDate;
    _data['end_date'] = endDate;
    _data['start_registration_date'] = startRegistrationDate;
    _data['end_registration_date'] = endRegistrationDate;
    _data['booking_required'] = bookingRequired;

    return _data;
  }

  @override
  List<Object?> get props => [
    title,
    description,
    place,
    branchId,
    startDate,
    endDate,
    isVisitorUnlimited,
    maxVisitor,
    isPaid,
    price,
    minimumAge,
    maximumAge,
    startRegistrationDate,
    endRegistrationDate,
    bookingRequired,
    photo
  ];
}