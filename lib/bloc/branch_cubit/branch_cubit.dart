import 'package:bloc/bloc.dart';
import 'package:eccmobile/data/models/response/branch_response.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/data/repository/branch_repository.dart';
import 'package:equatable/equatable.dart';

part 'branch_state.dart';

class BranchCubit extends Cubit<BranchState> {
  final BranchRepository branchRepository;

  BranchCubit(this.branchRepository) : super(BranchState());

  void getList() async {
    emit(state.copyWith(isLoading: true));

    final ApiResponse apiResponse = await branchRepository.getList();
    try {
      if (apiResponse.response != null) {
        List<BranchResponse> listBranchResponse = List.from(apiResponse.response!.data['data']).map((e) {
          return BranchResponse.fromJson(e);
        }).toList();

        emit(state.copyWith(listBranch: listBranchResponse, isLoading: false));
      } else {
        emit(BranchStateError(apiResponse.error.toString()));
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(BranchStateError(e.toString()));
      emit(state.copyWith(isLoading: false));
    }
  }
}
