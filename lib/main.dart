import 'package:attandance_simple/core/cubit/cubit_bracket/bracket_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_input_team/input_team_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_individu_participants/individu_participants_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_individu_status/individu_status_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_lomba/lomba_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_reset_password/reset_password_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_classroom/classroom_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_forgot_password/forgot_password_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_login/login_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_logout/logout_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_register/register_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_student/student_import_cubit.dart';
import 'package:attandance_simple/core/cubit/cubit_studi/studi_cubit.dart';
import 'package:attandance_simple/core/model/Champion_model.dart';
import 'package:attandance_simple/core/model/Date_ekskul_model.dart';
import 'package:attandance_simple/core/model/Race_ekskul_model.dart';
import 'package:attandance_simple/core/model/Siswa_studi_model.dart';
import 'package:attandance_simple/core/model/Solo_round_model.dart';
import 'package:attandance_simple/core/model/Team_round_model.dart';
import 'package:attandance_simple/core/model/Trofi_model.dart';
import 'package:attandance_simple/core/model/attandence_ekskul_model.dart';
import 'package:attandance_simple/core/model/info_studi_model.dart';
import 'package:attandance_simple/core/model/lomba_model.dart';
import 'package:attandance_simple/core/model/round_model.dart';
import 'package:attandance_simple/core/model/study_model.dart';
import 'package:attandance_simple/core/presentation/screen/achievement_screen.dart';
import 'package:attandance_simple/core/presentation/screen/edit_profile_screen.dart';
import 'package:attandance_simple/core/presentation/screen/forgot_password_screen.dart';
import 'package:attandance_simple/core/presentation/screen/home_screen.dart';
import 'package:attandance_simple/core/presentation/screen/login_screen.dart';
import 'package:attandance_simple/core/presentation/screen/race_screen.dart';
import 'package:attandance_simple/core/presentation/screen/register_screen.dart';
import 'package:attandance_simple/core/presentation/screen/reset_password_screen.dart';
import 'package:attandance_simple/core/presentation/screen/studi_ekskul_screen.dart';
import 'package:attandance_simple/core/presentation/screen/studi_screen.dart';
import 'package:attandance_simple/core/service/Individu_race_service.dart';
import 'package:attandance_simple/core/service/Team_service_input.dart';
import 'package:attandance_simple/core/service/bracket_service.dart';
import 'package:attandance_simple/core/service/individu_status_service.dart';
import 'package:attandance_simple/core/storange/Ekskul_data_storange.dart';
import 'package:attandance_simple/local_storange/local_storange.dart';
import 'package:attandance_simple/core/service/Auth_service.dart';
import 'package:attandance_simple/core/service/Classroom_service.dart';
import 'package:attandance_simple/core/service/Lomba_service.dart';
import 'package:attandance_simple/core/service/Students_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  Intl.defaultLocale = 'id_ID';

  await LocalStorage().init();

  Hive.registerAdapter(LombaModelAdapter());
  Hive.registerAdapter(DateEkskulModelAdapter());
  Hive.registerAdapter(AttandenceEkskulModelAdapter());
  Hive.registerAdapter(RaceEkskulModelAdapter());
  Hive.registerAdapter(RoundModelAdapter());
  Hive.registerAdapter(StudyModelAdapter());
  Hive.registerAdapter(TeamRoundModelAdapter());
  Hive.registerAdapter(SoloRoundModelAdapter());
  Hive.registerAdapter(ChampionModelAdapter());
  Hive.registerAdapter(TrofiModelAdapter());
  Hive.registerAdapter(EkskulDataStorangeAdapter());
  Hive.registerAdapter(SiswaStudiModelAdapter());

  await Hive.openBox<LombaModel>('lomba_model');
  await Hive.openBox<DateEkskulModel>('date_ekskul_model');
  await Hive.openBox<AttandenceEkskulModel>('attandence_ekskul_model');
  await Hive.openBox<RaceEkskulModel>('Race_ekskul_model');
  await Hive.openBox<RoundModel>('round_model');
  await Hive.openBox<InfoStudiModel>('info_studi_model');
  await Hive.openBox<StudyModel>('study_model');
  await Hive.openBox<TeamRoundModel>('Team_round_model');
  await Hive.openBox<SoloRoundModel>('Solo_round_model');
  await Hive.openBox<ChampionModel>('Champion_model');
  await Hive.openBox<TrofiModel>('Trofi_model');
  await Hive.openBox<EkskulDataStorange>('Ekskul_data_storange');
  await Hive.openBox<SiswaStudiModel>('Siswa_studi_model');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
        BlocProvider<LogoutCubit>(create: (_) => LogoutCubit()),
        BlocProvider<RegisterCubit>(create: (_) => RegisterCubit()),
        BlocProvider<StudiCubit>(create: (_) => StudiCubit()),
        BlocProvider<ClassroomCubit>(
          create: (_) => ClassroomCubit(ClassroomService()),
        ),
        BlocProvider<StudentImportCubit>(
          create: (_) => StudentImportCubit(StudentService()),
        ),
        BlocProvider<ForgotPasswordCubit>(
          create: (_) => ForgotPasswordCubit(AuthService()),
        ),
        BlocProvider<ResetPasswordCubit>(
          create: (_) => ResetPasswordCubit(AuthService()),
        ),
        BlocProvider<LombaCubit>(
          create: (_) => LombaCubit(LombaService()),
        ),
        BlocProvider<IndividuStatusCubit>(
          create: (_) => IndividuStatusCubit(IndividuStatusService()),
        ),
        BlocProvider<IndividuParticipantsCubit>(
          create: (_) => IndividuParticipantsCubit(IndividuParticipantsService()),
        ),
        BlocProvider<TeamInputCubit>(
          create: (_) => TeamInputCubit(TeamInputService()),
        ),
        BlocProvider<BracketCubit>(
          create: (_) => BracketCubit(BracketService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // ⬇️ Set locale & delegates
        locale: const Locale('id', 'ID'),
        supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/forgotPassword': (context) => ForgotPasswordScreen(),
          '/resetPassword': (context) => ResetPasswordScreen(),
          '/home': (context) => HomeScreen(),
          '/ekskul': (context) => const StudiEkskulScreen(),
          '/editProfile': (context) => const EditProfileScreen(),
          '/eksport': (context) => const RaceScreen(),
          '/achievement': (context) => const AchievementScreen(),
          '/siswa': (context) => const StudiScreen(),
        },
      ),
    );
  }
}
