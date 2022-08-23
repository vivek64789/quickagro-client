import 'package:flutter_test/flutter_test.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_profile_provider_test.mocks.dart';

@GenerateMocks([UserProfileProvider])
void main() {
  UserProfileProvider? userProfileProvider;
  setUp(() {
    userProfileProvider = MockUserProfileProvider();
  });

  test("Get all the address of the user", () {
    when(userProfileProvider?.getAllAddress()).thenAnswer(
      (_) async => [
        {
          "id": 1,
          "user_id": 1,
          "address": "Rua das flores",
          "number": "123",
          "complement": "casa",
          "neighborhood": "centro",
          "city": "São Paulo",
          "state": "SP",
          "zip_code": "01234-000",
          "created_at": "2020-06-20T18:00:00.000Z",
          "updated_at": "2020-06-20T18:00:00.000Z"
        },
        {
          "id": 2,
          "user_id": 1,
          "address": "Rua das flores",
          "number": "123",
          "complement": "casa",
          "neighborhood": "centro",
          "city": "São Paulo",
          "state": "SP",
          "zip_code": "01234-000",
          "created_at": "2020-06-20T18:00:00.000Z",
          "updated_at": "2020-06-20T18:00:00.000Z"
        }
      ],
    );
    final result = userProfileProvider?.getAllAddress();
    verify(userProfileProvider?.getAllAddress());
    expect(result, isInstanceOf<Future<List<Map<String, Object>>>>());
  });
}
