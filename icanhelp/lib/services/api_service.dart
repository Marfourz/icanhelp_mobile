import 'package:icanhelp/models/ApiResponse.dart';
import 'package:icanhelp/models/Discussion.dart';
import 'package:icanhelp/models/Invitation.dart';
import 'package:icanhelp/models/Message.dart';
import 'package:icanhelp/models/SendInvitation.dart';
import 'package:icanhelp/models/SendMessage.dart';
import 'package:icanhelp/models/Skill.dart';
import 'package:icanhelp/models/User.dart';
import 'package:icanhelp/models/UserProfile.dart';
import 'package:icanhelp/models/login_request.dart';
import 'package:icanhelp/models/signup_request.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'api_service.g.dart';




//@RestApi(baseUrl: 'http://localhost:8000/')
@RestApi(baseUrl: 'https://5040-46-193-67-60.ngrok-free.app/')
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @GET('users_profil/')
  Future<List<User>> getUsers();

  @POST("api/signup")
  Future<HttpResponse> signup(@Body() SignupRequest signupRequest);

  @POST("api/token")
  Future<HttpResponse> login(@Body() LoginRequest loginRequest);

  @GET('user_profil/competences/desired')
  Future<List<Skill>> getUserDesiredSkills();

  @POST('user_profil/competences/desired')
  Future<List<Skill>>addUserDesiredSkills(
    @Body() Map<String, dynamic> body,
  );

  @DELETE('user_profil/competences/desired')
  Future<void> removeDesiredSkill(@Body() Map<String, dynamic> body);

  @GET('user_profil/competences/personal')
  Future<List<Skill>> getUserPersonalSkills();

  @POST('user_profil/competences/personal')
  Future<List<Skill>> addUserPersonalSkills(
    @Body() Map<String, dynamic> body,
  );

  @DELETE('user_profil/competences/personal')
  Future<void> removeSkill(@Body() Map<String, dynamic> body);

  @GET('competences')
  Future<ApiResponse<Skill>> getPopularSkills(@Query("limit") int limit,@Query("type") String type,);

  @GET('users_profil/my_profil')
  Future<UserProfile> getMyProfil();

  @GET('users_profil/')
  Future<ApiResponse<UserProfile>> getUsersProfil();

  @GET('users_profil/{id}')
  Future<UserProfile> getUserProfil(
    @Path('id') int id
  );

  @POST('invitations/')
  Future<dynamic> sendInvitation(
    @Body() SendInvitation body,
  );

  @POST('invitations/{id}/accept/')
  Future<dynamic> acceptInvitation(
    @Path('id') int id
  );

    @POST('invitations/{id}/reject/')
  Future<dynamic> rejectedInvitation(
    @Path('id') int id
  );

  @GET('invitations/sent')
  Future<List<Invitation>> getSentInvitations();

  @GET('invitations/received')
  Future<List<Invitation>> getReceivedInvitations();

  @GET('discussions')
  Future<ApiResponse<Discussion>> getDiscussions();

  @GET('discussions/{id}/messages')
  Future<List<Message>> getDiscussionMessages(
    @Path() int id,
  );

  @POST('discussions/{id}/send_message/')
  Future<dynamic> sendMessage(
    @Path('id') int id,
    @Body() SendMessage body,
  );

}

