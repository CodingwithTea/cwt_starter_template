
class SignUpWithEmailAndPasswordFailure implements Exception{
  final String message;

  const SignUpWithEmailAndPasswordFailure([this.message = "An Unknown error occurred."]);

  factory SignUpWithEmailAndPasswordFailure.code(String code){
    switch(code){
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure('Please enter a stronger password.');
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure('Email is not valid or badly formatted.');
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure('An account already exists for that email.');
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure('This user has been disabled. Please contact support for help.');
      case 'too-many-requests':
        return const SignUpWithEmailAndPasswordFailure('Too many requests, Service Temporarily blocked.');
      case 'invalid-argument':
        return const SignUpWithEmailAndPasswordFailure('An invalid argument was provided to an Authentication method.');
      case 'invalid-password':
        return const SignUpWithEmailAndPasswordFailure('Incorrect password, please try again.');
      case 'invalid-phone-number':
        return const SignUpWithEmailAndPasswordFailure('The provided Phone Number is invalid.');
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure('The provided sign-in provider is disabled for your Firebase project.');
      case 'session-cookie-expired':
        return const SignUpWithEmailAndPasswordFailure('The provided Firebase session cookie is expired.');
      case 'uid-already-exists':
        return const SignUpWithEmailAndPasswordFailure('The provided uid is already in use by an existing user.');
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}
