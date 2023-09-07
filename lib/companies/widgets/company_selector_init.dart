// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:todavenda/auth/auth.dart';
// import 'package:todavenda/commons/widgets/widgets.dart';
// import 'package:todavenda/companies/companies.dart';

// class CompanySelectorInit extends StatelessWidget {
//   const CompanySelectorInit({
//     super.key,
//     required this.child,
//   });

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       bloc: BlocProvider.of<AuthBloc>(context)..add(const AuthStarted()),
//       listener: (context, state) {
//         if (state is AuthSuccess) {
//           context
//               .read<CompanySelectorBloc>()
//               .add(CompanySelectorStarted(user: state.user));
//         }
//       },
//       child: BlocBuilder<CompanySelectorBloc, CompanySelectorState>(
//         builder: (context, state) {
//           if (state is CompanySelectorInitial) {
//             return const Scaffold(body: LoadingWidget());
//           }
//           if (state is CompanySelectorException) {
//             return Scaffold(body: ExceptionWidget(exception: state.ex));
//           }
//           return child;
//         },
//       ),
//     );
//   }
// }
