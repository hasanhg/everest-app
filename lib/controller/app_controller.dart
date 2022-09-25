import 'package:everest_app/components/currency_card.dart';
import 'package:everest_app/model/app_model.dart';
import 'package:state_extended/state_extended.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart' hide StateSetter;

List<String> _endpoints = ["currency_rates", "metal_rates"];

class AppController extends StateXController {
  factory AppController([StateX? state]) => _this ??= AppController._(state);
  AppController._(StateX? state)
      : _model = AppModel(),
        super(state);
  static AppController? _this;

  final AppModel _model;

  IOWebSocketChannel? _ws;
  Map<String, CurrencyCard>? cards;

  /// Note, the count comes from a separate class, _Model.
  int get bottomNavIndex => _model.bottomNavIndex;

  IOWebSocketChannel? get ws => _ws;

  void onNavbarChanged(int index) {
    if (index == bottomNavIndex) {
      return;
    }

    cards = null;
    _model.setBottomNavIndex(index);
    _changeStream();

    notifyClients();
  }

  void _changeStream() {
    _ws?.sink.close();
    if (_endpoints.length <= bottomNavIndex) {
      return;
    }

    String uri = '${dotenv.env["WS_URL"]}/${_endpoints[bottomNavIndex]}';
    _ws = IOWebSocketChannel.connect(Uri.parse(uri));
  }

  void setCards(Map<String, CurrencyCard>? cards) {
    this.cards = cards;
    notifyClients();
  }

  /// Used for long asynchronous operations that need to be done
  /// before the app can be fully available to the user.
  /// e.g. Opening Databases, accessing Web servers, etc.
  @override
  Future<bool> initAsync() async {
    final init = super.initAsync();
    _changeStream();
    return init;
  }

  /// Supply an 'error handler' routine if something goes wrong
  /// in initAsync() routine above.
  @override
  bool onAsyncError(FlutterErrorDetails details) => false;

  /// Like the State object, the Flutter framework will call this method exactly once.
  /// Only when the [StateX] object is first created.
  @override
  void initState() {
    super.initState();
  }

  /// The framework calls this method whenever it removes this [StateX] object
  /// from the tree.
  @override
  void deactivate() {
    super.deactivate();
  }

  /// Called when this object is reinserted into the tree after having been
  /// removed via [deactivate].
  @override
  void activate() {
    super.activate();
  }

  /// The framework calls this method when this [StateX] object will never
  /// build again.
  /// Note: THERE IS NO GUARANTEE THIS METHOD WILL RUN in the Framework.
  @override
  void dispose() {
    super.dispose();
  }

  /// Called when the corresponding [StatefulWidget] is recreated.
  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    /// The framework always calls build() after calling [didUpdateWidget], which
    /// means any calls to [setState] in [didUpdateWidget] are redundant.
    super.didUpdateWidget(oldWidget);
  }

  /// Called when this [StateX] object is first created immediately after [initState].
  /// Otherwise called only if this [State] object's Widget
  /// is a dependency of [InheritedWidget].
  @override
  void didChangeDependencies() {
    return super.didChangeDependencies();
  }

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  @override
  void reassemble() {
    return super.reassemble();
  }

  /// Called when the system tells the app to pop the current route.
  /// For example, on Android, this is called when the user presses
  /// the back button.
  ///
  /// Observers are notified in registration order until one returns
  /// true. If none return true, the application quits.
  /// This method exposes the `popRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  @override
  Future<bool> didPopRoute() async {
    return super.didPopRoute();
  }

  /// Called when the host tells the app to push a new route onto the
  /// navigator.
  /// This method exposes the `pushRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  @override
  Future<bool> didPushRoute(String route) async {
    return super.didPushRoute(route);
  }

  /// Called when the host tells the application to push a new
  /// [RouteInformation] and a restoration state onto the router.
  /// This method exposes the `popRoute` notification from
  // ignore: comment_references
  /// [SystemChannels.navigation].
  ///
  /// The default implementation is to call the [didPushRoute] directly with the
  /// [RouteInformation.location].
  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    return super.didPushRouteInformation(routeInformation);
  }

  /// Called when the application's dimensions change. For example,
  /// when a phone is rotated.
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
  }

  /// Called when the platform's text scale factor changes.
  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
  }

  /// Brightness changed.
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
  }

  /// Called when the system tells the app that the user's locale has changed.
  @override
  void didChangeLocale(Locale locale) {
    didChangeLocale(locale);
  }

  /// Called when the system puts the app in the background or returns the app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Passing these possible values:
    /// AppLifecycleState.inactive (may be paused at any time)
    /// AppLifecycleState.paused (may enter the suspending state at any time)
    /// AppLifecycleState.detach
    /// AppLifecycleState.resumed
    super.didChangeAppLifecycleState(state);
  }

  /// The application is in an inactive state and is not receiving user input.
  ///
  /// On iOS, this state corresponds to an app or the Flutter host view running
  /// in the foreground inactive state. Apps transition to this state when in
  /// a phone call, responding to a TouchID request, when entering the app
  /// switcher or the control center, or when the UIViewController hosting the
  /// Flutter app is transitioning.
  ///
  /// On Android, this corresponds to an app or the Flutter host view running
  /// in the foreground inactive state.  Apps transition to this state when
  /// another activity is focused, such as a split-screen app, a phone call,
  /// a picture-in-picture app, a system dialog, or another window.
  ///
  /// Apps in this state should assume that they may be [pausedLifecycleState] at any time.
  @override
  void inactiveLifecycleState() {
    super.inactiveLifecycleState();
  }

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  @override
  void pausedLifecycleState() {
    super.pausedLifecycleState();
  }

  /// Either be in the progress of attaching when the engine is first initializing
  /// or after the view being destroyed due to a Navigator pop.
  @override
  void detachedLifecycleState() {
    super.detachedLifecycleState();
  }

  /// The application is visible and responding to user input.
  @override
  void resumedLifecycleState() {
    super.resumedLifecycleState();
  }

  /// Called when the system is running low on memory.
  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
  }

  /// Called when the system changes the set of active accessibility features.
  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
  }
}
