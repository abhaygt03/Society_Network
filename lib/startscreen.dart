import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:society_network/home_page_widgets/homepage.dart';
import 'package:society_network/provider/userprovider.dart';
import 'package:society_network/screens/chatList.dart';
import 'package:society_network/screens/profile.dart';
import 'package:society_network/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  PageController pageController;
  int _page=0;
  UserProvider userProvider;

  @override
  void initState() {
userProvider=Provider.of<UserProvider>(context,listen:false);
    userProvider.refreshUser();

    super.initState();
    
    SchedulerBinding.instance.addPostFrameCallback((_) async{
    userProvider=Provider.of<UserProvider>(context,listen:false);
    await userProvider.refreshUser();
     });

     WidgetsBinding.instance.addObserver(this);

    pageController=PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void onpagechange(int page){
    setState(() {
      _page=page;
    });
  }

  void navigationTapped(int page)
  {
    pageController.jumpToPage(page);
  }
  
    Color bgBlack = Color(0xFF1a1a1a);
  Color mainBlack = Color(0xFF262626);
  Color mainGrey = Color(0xFF303030);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor:UniversalVariables.blackColor,
        body: PageView(children: <Widget>[
          Container(child: HomePage(),),
          Container(child: ChatListScreen(userProvider.getUser),),
          Center(child: ProfilePage(userProvider.getUser),)
        ],
        
        controller:pageController,
        // onPageChanged: onpagechange
        ),

          bottomNavigationBar: CurvedNavigationBar(
            color: mainGrey,
            height: 50,
            backgroundColor:bgBlack,
    items: <Widget>[
      Icon(Icons.add, size: 30,color: Colors.blueAccent,),
      Icon(Icons.chat, size: 30,color: Colors.blueAccent),
      Icon(Icons.person, size: 30,color: Colors.blueAccent),
    ],
    onTap: (index) {
      _page=index;
      navigationTapped(_page);
    },
  ),
      );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(int pgno,String title,IconData name) {
    return BottomNavigationBarItem(
        icon: Icon(name,
        color:(_page==pgno)
        ?UniversalVariables.lightBlueColor
        :UniversalVariables.greyColor,),
        title: Text(title,
        style: TextStyle(
          fontSize: 10,
          color: (_page==pgno)
        ?UniversalVariables.lightBlueColor
        :UniversalVariables.greyColor
        ),)
        );
  }
}
