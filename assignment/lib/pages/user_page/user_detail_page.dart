
import 'package:assignment/bloc/search_bloc.dart';
import 'package:assignment/configs/constants.dart';
import 'package:assignment/models/search_user_response.dart';
import 'package:assignment/repositories/search_repository.dart';
import 'package:assignment/utils/Utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailPage extends StatelessWidget {
  final User user;
  final SearchRepository provider;
  const UserDetailPage(this.user, this.provider);

  @override
  Widget build(context) {
    return BlocProvider(
      create: (context) => SearchUserBloc(this.provider)..add(SearchUserDetailEvent(user.login)),
      child: UserDetailView(user),
    );
  }
}

class UserDetailView extends StatelessWidget {
  final User user;
  const UserDetailView(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildAppBar(context, "Profile"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Style.padding20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20,),
            ClipOval(
              child: CachedNetworkImage(imageUrl: user.avatarUrl,fit: BoxFit.cover, width: 200,height: 200,),
            ),
            SizedBox(height: 40,),
            buildRow("User name", user.login),
            BlocConsumer<SearchUserBloc, SearchUserState>(
              listener: (context, state) {

              },
              builder: (context, state) {
                if (state is SearchUserDetailSuccess) {
                  return Column(
                    children: <Widget>[
                      buildRow("Public Repos", state.user.publicRepos.toString()),
                      buildRow("Public Gits", state.user.publicGits.toString()),
                      buildRow("Followers", state.user.followers.toString()),
                      buildRow("Followings", state.user.followings.toString()),
                      // buildRow("Name", controller.userDetail.name),
                    ],
                  );
                }
                return Container();
              },
            )

          ],
        ),
      ),
    );

  }
  Widget buildRow(String leftContent, String rightContent) {
    if (rightContent.isNotEmpty) {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(leftContent, style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300)),
            Expanded(
              child: Text(rightContent,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.right,
                maxLines: 1,
              ),
            )
          ],
        ),
      );
    }else {
      return Container();
    }
  }
}
