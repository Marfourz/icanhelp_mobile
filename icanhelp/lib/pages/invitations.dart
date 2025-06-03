import 'package:flutter/material.dart';
import 'package:icanhelp/components/EmptyState.dart';
import 'package:icanhelp/components/IMessageSnackbar.dart';
import 'package:icanhelp/models/Invitation.dart';
import 'package:icanhelp/pages/messagerie.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:icanhelp/services/dio_client.dart';
import 'package:icanhelp/theme.dart';

class InvitationsPage extends StatefulWidget {
  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Invitation> sentInvitations = [ ];

  List<Invitation> receivedInvitations = [];

  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    final dio = DioClient.getInstance();
    apiService = ApiService(dio);
    _fetchReceivedInvitations();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget buildInvitationCard(Invitation invitation, {bool isReceived = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(""),
            radius: 30,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    isReceived ? invitation.createdBy.user.username! : invitation.receiver.user.username!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text(invitation.message, style: TextStyle(color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (isReceived && invitation.state == "PENDING") ...[
            IconButton(
              icon: Icon(Icons.check_circle, color: Colors.green),
              onPressed: () {
                _acceptInvitation(invitation.id);
              },
            ),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.red),
              onPressed: () {
                _rejectInvitation(invitation.id);
              },
            ),
          ] else
            Text(
              invitation.state == "PENDING" ? "En attente" : invitation.state == "ACCEPT" ? "Accepté" :  invitation.state,
              style: TextStyle(color: invitation.state == "PENDING" ? Colors.orange : invitation.state == "ACCEPT" ? Colors.green : Colors.red),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Mes Invitations"),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: "Envoyées"),
            Tab(text: "Reçues"),
          ],
        ),
      ),
      body: FutureBuilder(future: _fetchSendInvitations(), builder: (context, snapshot){
         if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child:CircularProgressIndicator(color: AppColors.primary,)
              ) ;
            }
           
            else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            }
            else {
              return   Padding(
        padding: const EdgeInsets.all(16.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            sentInvitations.isNotEmpty ? ListView(
              children: sentInvitations.map((inv) => buildInvitationCard(inv)).toList(),
            ) : EmptyState (title: 'Invitations envoyés', description: "Aucune invitations envoyées pour l'instant"
            ),
            receivedInvitations.isNotEmpty ? 
            ListView(
              children: 
              receivedInvitations.map((inv) => buildInvitationCard(inv, isReceived: true)).toList()
             ,) : EmptyState(title: 'Invitations recues', description: "Aucune invitations recues pour l'instant",)
            
          ],
        ),
      );
            }

      })
      
     );
  }




  _fetchSendInvitations() async {
    try {
      sentInvitations = await apiService.getSentInvitations();
      return sentInvitations;
  
    } catch (e) {
      print("Erreur lors de la récupération des invitations envoyées : $e");
    }
  }

   _fetchReceivedInvitations() async {
    try {
      receivedInvitations = await apiService.getReceivedInvitations();
      setState(() { });
    } catch (e) {
      print("Erreur lors de la récupération des invitations recues : $e");
    }
  }


    _acceptInvitation(int id) async {
    try {
      final response = await apiService.acceptInvitation(id);
      print(response.toString());
       MessageSnackbar.show(
          context,
          message: "Invitation acceptée !!" ,
          isSuccess: true,
          onTop: true
        );
        setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Messagerie(discussionId: response['id']),
                  ),
            );
        });

      setState(() {
        _fetchSendInvitations();
      });
    } catch (e) {
      print("Erreur lors de l'acceptation : $e");
    }}

    _rejectInvitation(int id) async {
    try {
      await apiService.rejectedInvitation(id);
       MessageSnackbar.show(
          context,
          message: "Invitation rejetée avec succès !!" ,
          isSuccess: true, // ou false pour une erreur
        );
      setState(() {
        _fetchReceivedInvitations();
      });
    } catch (e) {
      print("$e");
    }
  }



}