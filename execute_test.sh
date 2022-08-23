
GREEN='\033[0;32m'
NC='\033[0m'
LINE_BREAK="${GREEN} --- ${NC}"

echo "$LINE_BREAK"
echo "${GREEN}Registration Test begin ${NC}"
echo "$LINE_BREAK"

# Test the Registration process
flutter drive \
  --driver=test/test_driver/integration_test_driver.dart \
  --target=test/integration_test/register_test.dart

echo "$LINE_BREAK"
echo "${GREEN}Login test begin ${NC}"
echo "$LINE_BREAK"


# Test the Login process
flutter drive \
  --driver=test/test_driver/integration_test_driver.dart \
  --target=test/integration_test/login_test.dart
