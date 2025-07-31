import 'package:dio/dio.dart';
import 'package:eccmobile/bloc/auth_bloc/auth_bloc.dart';
import 'package:eccmobile/bloc/branch_cubit/branch_cubit.dart';
import 'package:eccmobile/bloc/config/config_cubit.dart';
import 'package:eccmobile/bloc/event_bloc/event_bloc.dart';
import 'package:eccmobile/bloc/event_bloc/event_bloc.dart';
import 'package:eccmobile/bloc/family_bloc/family_bloc.dart';
import 'package:eccmobile/bloc/payment_cubit/payment_cubit.dart';
import 'package:eccmobile/data/client/dio/dio_client.dart';
import 'package:eccmobile/data/repository/auth_repository.dart';
import 'package:eccmobile/data/repository/branch_repository.dart';
import 'package:eccmobile/data/repository/config_repository.dart';
import 'package:eccmobile/data/repository/event_repository.dart';
import 'package:eccmobile/data/repository/family_repository.dart';
import 'package:eccmobile/data/repository/payment_repository.dart';
import 'package:eccmobile/data/shared_pref.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initialize() async {
  final sl = GetIt.instance;

  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerFactory<SharedPref>(() => SharedPref(sharedPreferences));
  sl.registerFactory<DioClient>(() => DioClient(sharedPreferences: sharedPreferences));

  sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepository>(), sl<SharedPref>()));
  sl.registerFactory<AuthRepository>(() => AuthRepository(dioClient: sl<DioClient>()));

  sl.registerFactory<EventBloc>(() => EventBloc(sl<EventRepository>()));
  sl.registerFactory<EventRepository>(() => EventRepository(dioClient: sl<DioClient>()));

  sl.registerFactory<FamilyBloc>(() => FamilyBloc(sl<FamilyRepository>()));
  sl.registerFactory<FamilyRepository>(() => FamilyRepository(dioClient: sl<DioClient>()));

  sl.registerFactory<BranchCubit>(() => BranchCubit(sl<BranchRepository>()));
  sl.registerFactory<BranchRepository>(() => BranchRepository(dioClient: sl<DioClient>()));

  sl.registerFactory<ConfigCubit>(() => ConfigCubit(sl<ConfigRepository>()));
  sl.registerFactory<ConfigRepository>(() => ConfigRepository());

  sl.registerFactory<PaymentCubit>(() => PaymentCubit(sl<PaymentRepository>()));
  sl.registerFactory<PaymentRepository>(() => PaymentRepository(dioClient: sl<DioClient>()));

  sl.registerLazySingleton<Dio>(() => Dio());
}