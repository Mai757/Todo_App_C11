bool isValidEmail(String email){
  return  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

}
bool isValidPassword(String password){
  if(password.length<6){
    return false;

  }
  return true;
}