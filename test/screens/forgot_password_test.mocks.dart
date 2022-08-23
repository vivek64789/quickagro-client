// Mocks generated by Mockito 5.1.0 from annotations
// in quickagro/test/screens/forgot_password_test.dart.
// Do not manually edit this file.

import 'dart:ui' as _i5;

import 'package:flutter/foundation.dart' as _i4;
import 'package:flutter/material.dart' as _i3;
import 'package:quickagro/providers/forgot_password_provider.dart' as _i6;
import 'package:quickagro/providers/theme_provider.dart' as _i7;
import 'package:quickagro/screens/forgot_password.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeForgotPasswordState_0 extends _i1.Fake
    implements _i2.ForgotPasswordState {
  @override
  String toString({_i3.DiagnosticLevel? minLevel = _i3.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeStatefulElement_1 extends _i1.Fake implements _i3.StatefulElement {
  @override
  String toString({_i3.DiagnosticLevel? minLevel = _i3.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeDiagnosticsNode_2 extends _i1.Fake implements _i3.DiagnosticsNode {
  @override
  String toString(
          {_i4.TextTreeConfiguration? parentConfiguration,
          _i3.DiagnosticLevel? minLevel = _i3.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeColor_3 extends _i1.Fake implements _i5.Color {}

/// A class which mocks [ForgotPassword].
///
/// See the documentation for Mockito's code generation for more information.
class MockForgotPassword extends _i1.Mock implements _i2.ForgotPassword {
  MockForgotPassword() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ForgotPasswordState createState() => (super.noSuchMethod(
      Invocation.method(#createState, []),
      returnValue: _FakeForgotPasswordState_0()) as _i2.ForgotPasswordState);
  @override
  _i3.StatefulElement createElement() =>
      (super.noSuchMethod(Invocation.method(#createElement, []),
          returnValue: _FakeStatefulElement_1()) as _i3.StatefulElement);
  @override
  String toStringShort() => (super
          .noSuchMethod(Invocation.method(#toStringShort, []), returnValue: '')
      as String);
  @override
  void debugFillProperties(_i4.DiagnosticPropertiesBuilder? properties) =>
      super.noSuchMethod(Invocation.method(#debugFillProperties, [properties]),
          returnValueForMissingStub: null);
  @override
  String toStringShallow(
          {String? joiner = r', ',
          _i3.DiagnosticLevel? minLevel = _i3.DiagnosticLevel.debug}) =>
      (super.noSuchMethod(
          Invocation.method(
              #toStringShallow, [], {#joiner: joiner, #minLevel: minLevel}),
          returnValue: '') as String);
  @override
  String toStringDeep(
          {String? prefixLineOne = r'',
          String? prefixOtherLines,
          _i3.DiagnosticLevel? minLevel = _i3.DiagnosticLevel.debug}) =>
      (super.noSuchMethod(
          Invocation.method(#toStringDeep, [], {
            #prefixLineOne: prefixLineOne,
            #prefixOtherLines: prefixOtherLines,
            #minLevel: minLevel
          }),
          returnValue: '') as String);
  @override
  _i3.DiagnosticsNode toDiagnosticsNode(
          {String? name, _i4.DiagnosticsTreeStyle? style}) =>
      (super.noSuchMethod(
          Invocation.method(
              #toDiagnosticsNode, [], {#name: name, #style: style}),
          returnValue: _FakeDiagnosticsNode_2()) as _i3.DiagnosticsNode);
  @override
  List<_i3.DiagnosticsNode> debugDescribeChildren() =>
      (super.noSuchMethod(Invocation.method(#debugDescribeChildren, []),
          returnValue: <_i3.DiagnosticsNode>[]) as List<_i3.DiagnosticsNode>);
  @override
  String toString({_i3.DiagnosticLevel? minLevel = _i3.DiagnosticLevel.info}) =>
      super.toString();
}

/// A class which mocks [ForgotPasswordProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockForgotPasswordProvider extends _i1.Mock
    implements _i6.ForgotPasswordProvider {
  MockForgotPasswordProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get emailSent =>
      (super.noSuchMethod(Invocation.getter(#emailSent), returnValue: false)
          as bool);
  @override
  set emailSent(bool? _emailSent) =>
      super.noSuchMethod(Invocation.setter(#emailSent, _emailSent),
          returnValueForMissingStub: null);
  @override
  bool get codeValidate =>
      (super.noSuchMethod(Invocation.getter(#codeValidate), returnValue: false)
          as bool);
  @override
  set codeValidate(bool? _codeValidate) =>
      super.noSuchMethod(Invocation.setter(#codeValidate, _codeValidate),
          returnValueForMissingStub: null);
  @override
  String get email =>
      (super.noSuchMethod(Invocation.getter(#email), returnValue: '')
          as String);
  @override
  set email(String? _email) =>
      super.noSuchMethod(Invocation.setter(#email, _email),
          returnValueForMissingStub: null);
  @override
  String get code =>
      (super.noSuchMethod(Invocation.getter(#code), returnValue: '') as String);
  @override
  set code(String? _code) => super.noSuchMethod(Invocation.setter(#code, _code),
      returnValueForMissingStub: null);
  @override
  String get newPassword =>
      (super.noSuchMethod(Invocation.getter(#newPassword), returnValue: '')
          as String);
  @override
  set newPassword(String? _newPassword) =>
      super.noSuchMethod(Invocation.setter(#newPassword, _newPassword),
          returnValueForMissingStub: null);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  dynamic forgotPassword(String? email_) =>
      super.noSuchMethod(Invocation.method(#forgotPassword, [email_]));
  @override
  dynamic verifyCode(String? code_) =>
      super.noSuchMethod(Invocation.method(#verifyCode, [code_]));
  @override
  dynamic changePassword(String? newPassword) =>
      super.noSuchMethod(Invocation.method(#changePassword, [newPassword]));
  @override
  void addListener(_i5.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i5.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [ThemeProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockThemeProvider extends _i1.Mock implements _i7.ThemeProvider {
  MockThemeProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isDarkTheme =>
      (super.noSuchMethod(Invocation.getter(#isDarkTheme), returnValue: false)
          as bool);
  @override
  set isDarkTheme(bool? _isDarkTheme) =>
      super.noSuchMethod(Invocation.setter(#isDarkTheme, _isDarkTheme),
          returnValueForMissingStub: null);
  @override
  bool get isAutoDarkTheme => (super
          .noSuchMethod(Invocation.getter(#isAutoDarkTheme), returnValue: false)
      as bool);
  @override
  set isAutoDarkTheme(bool? _isAutoDarkTheme) =>
      super.noSuchMethod(Invocation.setter(#isAutoDarkTheme, _isAutoDarkTheme),
          returnValueForMissingStub: null);
  @override
  _i5.Color get scaffoldColor =>
      (super.noSuchMethod(Invocation.getter(#scaffoldColor),
          returnValue: _FakeColor_3()) as _i5.Color);
  @override
  set scaffoldColor(_i5.Color? _scaffoldColor) =>
      super.noSuchMethod(Invocation.setter(#scaffoldColor, _scaffoldColor),
          returnValueForMissingStub: null);
  @override
  _i5.Color get textColor => (super.noSuchMethod(Invocation.getter(#textColor),
      returnValue: _FakeColor_3()) as _i5.Color);
  @override
  set textColor(_i5.Color? _textColor) =>
      super.noSuchMethod(Invocation.setter(#textColor, _textColor),
          returnValueForMissingStub: null);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  void changeTheme(bool? isDark) =>
      super.noSuchMethod(Invocation.method(#changeTheme, [isDark]),
          returnValueForMissingStub: null);
  @override
  void changeIsAutoDarkTheme(bool? isAutoDark) => super.noSuchMethod(
      Invocation.method(#changeIsAutoDarkTheme, [isAutoDark]),
      returnValueForMissingStub: null);
  @override
  void enableAutoDarkTheme() =>
      super.noSuchMethod(Invocation.method(#enableAutoDarkTheme, []),
          returnValueForMissingStub: null);
  @override
  void disableAutoDarkTheme() =>
      super.noSuchMethod(Invocation.method(#disableAutoDarkTheme, []),
          returnValueForMissingStub: null);
  @override
  void loadTheme() => super.noSuchMethod(Invocation.method(#loadTheme, []),
      returnValueForMissingStub: null);
  @override
  void addListener(_i5.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i5.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}