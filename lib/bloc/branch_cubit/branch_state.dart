part of 'branch_cubit.dart';

class BranchState extends Equatable {
  final List<BranchResponse> listBranch;
  final bool isLoading;

  BranchState({this.listBranch = const [], this.isLoading = false});

  BranchState copyWith({
    bool? isLoading,
    List<BranchResponse>? listBranch
  }) {
     return BranchState(
        isLoading: isLoading ?? this.isLoading,
        listBranch: listBranch ?? this.listBranch
     );
  }

  bool get showList => (listBranch.isNotEmpty && (isLoading == false));

  @override
  List<Object?> get props => [
    listBranch,
    isLoading
  ];
}

class BranchStateCreate extends BranchState {
  final String message;

  BranchStateCreate(this.message);
}

class BranchStateError extends BranchState {
  final String message;

  BranchStateError(this.message);
}