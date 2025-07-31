import 'package:bloc/bloc.dart';
import 'package:eccmobile/data/models/family_selected.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/data/repository/payment_repository.dart';
import 'package:eccmobile/util/helper.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository paymentRepository;
  PaymentCubit(this.paymentRepository) : super(PaymentState());

  void initialState({required String eventId, required List<FamilySelected> list, required double amount}) {
    emit(state.copyWith(
      eventId: eventId,
      listFamilySelected: list,
      amount: amount
    ));
  }

  /*
  * {
      "message": "Successfully joined this event!",
      "snapToken": "d6edf1a6-4cb6-40d7-bcf7-74412430c65e",
      "url": "https://app.sandbox.midtrans.com/snap/v2/vtweb/d6edf1a6-4cb6-40d7-bcf7-74412430c65e"
    }
  * */
  void createPayment() async {
    final PaymentState paymentState = state;
    emit(paymentState.copyWith(isLoading: true));

    final ApiResponse apiResponse = await paymentRepository.createPayment(familySelected: paymentState.familySelected, eventId: paymentState.eventId, grandTotal: paymentState.calculateAmount);
    try {
      if (apiResponse.response != null) {
        emit(PaymentStateJoinEvent(
          message: apiResponse.response!.data['message'],
          snapToken: apiResponse.response!.data['snapToken'],
          url: apiResponse.response!.data['url'],
          calculateAmount: paymentState.calculateAmount,
          familyParticipant: "${paymentState.familySelected.length.toString()} x ${Format.money(paymentState.amount)}"
        ));
      } else {
        emit(PaymentStateError(apiResponse.error.toString()));
        emit(paymentState.copyWith(isLoading: false));
      }

    } catch (e) {
      emit(PaymentStateError(e.toString()));
      emit(paymentState.copyWith(isLoading: false));
    }

  }

  void selectedListFamily(String familyId, {required bool selected}) {
    emit(state.copyWith(
      listFamilySelected: state.listFamilySelected.map((element) {
        if (element.id == familyId) {
          return element.copyWith(selected: selected);
        } else {
          return element;
        }
      }).toList(),
    ));
  }
}
