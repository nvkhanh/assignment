
import 'dart:async';
import 'package:assignment/bloc/search_bloc.dart';
import 'package:assignment/configs/constants.dart';
import 'package:assignment/models/search_user_response.dart';
import 'package:assignment/pages/user_page/user_detail_page.dart';
import 'package:assignment/repositories/search_repository.dart';
import 'package:assignment/utils/Utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
class SearchPage extends StatelessWidget {
  final apiRepository = SearchRepository(http.Client());

  SearchPage({Key key}) : super(key: key);

  @override
  Widget build(context) {
    return BlocProvider(
      create: (context) => SearchUserBloc(apiRepository),
      child: SearchView(apiRepository),
    );
  }
}


class SearchView extends StatelessWidget {

  final SearchRepository apiProvider;
  SearchView(this.apiProvider);

  final TextEditingController searchController = TextEditingController();
  Timer _debounce;
  final int _debounceTime = 1000;
  var lastQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.buildAppBar(context, "Users Search", isShowBackButton: false),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Style.padding20),
        child: Column(
          children: <Widget>[
            SizedBox(height: Style.padding20,),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                  fillColor: Constants.primaryColor,
                  filled: false,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff1d745b), width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  ),
                  hintText: 'Search',
                  prefixIcon: GestureDetector(
                      child: Icon(Icons.search, color: Colors.black,)),
                  contentPadding: EdgeInsets.fromLTRB(5, 5, 5, Style.padding10)
              ),
              onChanged: (newText) {
                onTextChanged(context);
              },
            ),
            Expanded(child: BlocConsumer<SearchUserBloc, SearchUserState>(
              listener: (context, state) {

              },
              builder: (context, state) {
                if (state is SearchUserLoadInProgress) {
                  return buildLoadingWidget();
                }else if (state is SearchUserLoadSuccess) {
                  return state.user.isNotEmpty ? buildUserList(context, state.user) : buildEmptyWidget();
                }else if (state is SearchUserInitial) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, Style.padding20, 0, 0),
                    child: Text("Please enter the username to search"),
                  );
                }else if (state is SearchUserLoadFailure) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, Style.padding20, 0, 0),
                    child: Text("There was an error please try again"),
                  );
                }
                return Container();
              },
            ))
          ],
        )
      ),
    );
  }

  onTextChanged(BuildContext context) {
    SearchUserBloc userBloc = BlocProvider.of<SearchUserBloc>(context);
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debounceTime), () {
      if (searchController.text != "" && searchController.text != lastQuery) {
        userBloc.add(SearchUserRequested(searchController.text));
      }else if (searchController.text.isEmpty) {
        userBloc.add(SearchUserClearText());
      }
    });
  }
  Widget buildLoadingWidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: double.infinity,
      child: Center(child: CircularProgressIndicator(
        color: Colors.green,
      ),),
    );
  }
  Widget buildEmptyWidget() {
    return SizedBox(
      height: 40,
      child: Center(child: Text("There is no result with keyword '${searchController.text}'"),),
    );
  }
  Widget buildUserList(BuildContext context, List<dynamic> items) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, Style.padding20, 0, 0),
      child: ListView.builder (
          itemCount: items.length,
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int index) {
            var item = items[index] as User;
            return buildUserItem(context, item);
          }
      ),
    );
  }
  buildUserItem(BuildContext context, User item) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserDetailPage(item, apiProvider))
        );
      },
      child: SizedBox(
        height: 80,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: Style.padding20,),
                  ClipOval(
                    child: CachedNetworkImage(imageUrl: item.avatarUrl,fit: BoxFit.cover, width: 40,height: 40,),
                  ),
                  SizedBox(width: Style.padding10,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(item.login, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),),
                    ],
                  ),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
