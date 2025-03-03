import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:theinstallers/views/agent/agent_home_view.dart';
import 'package:theinstallers/views/home/home_view.dart';
import 'package:upgrader/upgrader.dart';
import 'controller/database/database_controller_provider.dart';
import 'utils/exports.dart';
import 'views/onboarding/onboard_view.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
    String roleId = '';
  
    @override
    void initState() {
      super.initState();
      _fetchRoleId();
    }

    Future<void> _fetchRoleId() async {
    String roleId = await DatabaseControllerProvider().getRoleId();
    setState(() {
      this.roleId = roleId;
    });
    }

  @override
  Widget build(BuildContext context) {
    
    final token = DatabaseControllerProvider().getToken();
      return FutureBuilder<String>(
        future: token,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Check if the token has expired
            final tokenExpireTime = JwtDecoder.getExpirationDate(snapshot.data!);
            final currentTime = DateTime.now();
            if (currentTime.isAfter(tokenExpireTime)) {
              // Token has expired, logout and clear token
              DatabaseControllerProvider().logOut();
              return const OnboardView();
              
            } else if (roleId == '3'){
               return const AgentHomeView();
            }
            
            else {
              // Token is valid, show HomeView
              return const HomeView();
              
            }
          } else {
            return const OnboardView();
          }
        },
          );
  }
}