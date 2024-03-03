import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes_config.dart';
import '../../../auth_page/presentation/cubit/auth_page_cubit.dart';
import '../../../user_detail_page/presentation/cubit/user_page_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<AuthPageCubit>(),
      child: BlocListener<AuthPageCubit, AuthPageState>(
        listener: (context, state) {
          state.maybeWhen(
              initial: () => context.go(RoutesConfig.login), orElse: () {});
        },
        child: Scaffold(
          appBar: AppBar(
              title: const Text('Bikin Ticket'),
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              actions: [
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: GetIt.I<UserPageCubit>().userStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                          backgroundColor: Colors.grey[400],
                        );
                      }
                      Map<String, dynamic>? data = snapshot.data!.data();
                      // print(data!['name']);
                      return GestureDetector(
                        onTap: () => context.go(RoutesConfig.userProfile),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[400],
                          backgroundImage: NetworkImage(data?['profile'] != null
                              ? data!['profile']
                              : "https://ui-avatars.com/api/?name=${data!['name']}"),
                        ),
                      );
                    }),
                IconButton(
                  icon: const Icon(Icons.logout_outlined),
                  onPressed: () {
                    GetIt.I<AuthPageCubit>().logout();
                  },
                ),
              ]),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipOval(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: const Offset(0,
                                              4), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/profile.jpg',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello,',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Rizki',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              width: 150,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(25)),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.card_membership,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 50,
                                  ),
                                  Text(
                                    'My Ticket',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                width: double.infinity,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.home,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onTap: () => Navigator.pushNamed(context, '/home'),
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.card_membership,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onTap: () => Navigator.pushNamed(context, '/home'),
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onTap: () => context.go(RoutesConfig.userProfile),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
