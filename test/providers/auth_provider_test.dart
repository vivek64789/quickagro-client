import 'package:flutter_test/flutter_test.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_provider_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() {
  AuthProvider? authProvider;
  String email = "";
  String name = "";
  String token = "";
  String type = "";
  String profilePic = "";

  setUp(() {
    authProvider = MockAuthProvider();
    email = "vivek@gmail.com";
    name = "Vivek";
    token = "token";
    type = "Admin";
    profilePic = "profilePic";
  });
  test('Change Email is Successful...', () async {
    when(authProvider?.email).thenAnswer((realInvocation) => email);

    final newEmail = authProvider?.email;
    expect(newEmail, email);
  });
  test('Change Name is Successful...', () async {
    when(authProvider?.name).thenAnswer((realInvocation) => name);

    final newName = authProvider?.name;
    expect(newName, name);
  });
  test('Change Token is successful...', () async {
    when(authProvider?.token).thenAnswer((realInvocation) => token);

    final newtoken = authProvider?.token;
    expect(newtoken, token);
  });
  test('Change Type is successful...', () async {
    when(authProvider?.type).thenAnswer((realInvocation) => type);

    final newtype = authProvider?.type;
    expect(newtype, type);
  });
  test('Change Profile Pic is successful...', () async {
    when(authProvider?.profilePic).thenAnswer((realInvocation) => profilePic);

    final newprofilePic = authProvider?.profilePic;
    expect(newprofilePic, profilePic);
  });
}
