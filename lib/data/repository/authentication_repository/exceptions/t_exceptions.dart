class TExceptions implements Exception {
  /// The associated error message.
  final String message;

  /// {@macro log_in_with_email_and_password_failure}
  const TExceptions([this.message = 'An unknown exception occurred.']);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory TExceptions.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const TExceptions('Email already exists.');
      case 'invalid-email':
        return const TExceptions('Email is not valid or badly formatted.');
      case 'weak-password':
        return const TExceptions('Please enter a stronger password.');
      case 'user-disabled':
        return const TExceptions('This user has been disabled. Please contact support for help.');
      case 'user-not-found':
        return const TExceptions('Invalid Details, please create an account.');
      case 'wrong-password':
        return const TExceptions('Incorrect password, please try again.');
      case 'too-many-requests':
        return const TExceptions('Too many requests, Service Temporarily blocked.');
      case 'invalid-argument':
        return const TExceptions('An invalid argument was provided to an Authentication method.');
      case 'invalid-password':
        return const TExceptions('Incorrect password, please try again.');
      case 'invalid-phone-number':
        return const TExceptions('The provided Phone Number is invalid.');
      case 'operation-not-allowed':
        return const TExceptions(
            'The provided sign-in provider is disabled for your Firebase project.');
      case 'session-cookie-expired':
        return const TExceptions('The provided Firebase session cookie is expired.');
      case 'uid-already-exists':
        return const TExceptions('The provided uid is already in use by an existing user.');
      default:
        return const TExceptions();
    }
  }
}
