# Authenticating Google OAuth2 for use with Flutter

To use Google OAuth2 authentication with Flutter, a few steps must be taken to properly authenticate the service outside the code.

Specifically, Google OAuth2 needs a signed certificate in order to generate an OAuth2 client the SHA-1 of the signing certificate must be provided. Until the app is pushed into production, this signing certificate must be generated in debug mode, specifically in the form of a `debug.keystore` file.

