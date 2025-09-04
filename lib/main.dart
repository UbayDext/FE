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
import 'package:attandance_simple/core/presentation/screen/about_app_screen.dart';
import 'package:attandance_simple/core/presentation/screen/achievement_screen.dart';
import 'package:attandance_simple/core/presentation/screen/edit_profile_screen.dart';
import 'package:attandance_simple/core/presentation/screen/forgot_password_screen.dart';
import 'package:attandance_simple/core/presentation/screen/home_screen.dart';
import 'package:attandance_simple/core/presentation/screen/login_screen.dart';
import 'package:attandance_simple/core/presentation/screen/navbar_screen.dart';
import 'package:attandance_simple/core/presentation/screen/profile_screen.dart';
import 'package:attandance_simple/core/presentation/screen/race_screen.dart';
import 'package:attandance_simple/core/presentation/screen/register_screen.dart';
import 'package:attandance_simple/core/presentation/screen/reset_password_screen.dart';
import 'package:attandance_simple/core/presentation/screen/studi_ekskul_screen.dart';
import 'package:attandance_simple/core/presentation/screen/studi_screen.dart';
import 'package:attandance_simple/core/presentation/view/login_view.dart';
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
        BlocProvider<LombaCubit>(create: (_) => LombaCubit(LombaService())),
        BlocProvider<IndividuStatusCubit>(
          create: (_) => IndividuStatusCubit(IndividuStatusService()),
        ),
        BlocProvider<IndividuParticipantsCubit>(
          create: (_) =>
              IndividuParticipantsCubit(IndividuParticipantsService()),
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
          '/navbar': (context) => NavbarScreen(),
          '/loginview': (context) => const LoginView(),
          '/register': (context) => RegisterScreen(),
          '/forgotPassword': (context) => ForgotPasswordScreen(),
          '/resetPassword': (context) => ResetPasswordScreen(),
          '/home': (context) => HomeScreen(),
          '/ekskul': (context) => const StudiEkskulScreen(),
          '/editProfile': (context) => const EditProfileScreen(),
          '/eksport': (context) => const RaceScreen(),
          '/siswa': (context) => const StudiScreen(),
          '/about': (context) => const AboutAppScreen(),
          // '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
