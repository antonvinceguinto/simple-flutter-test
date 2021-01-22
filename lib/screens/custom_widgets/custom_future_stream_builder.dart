import 'package:simple_test/utils/imports.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  const CustomStreamBuilder({
    Key key,
    @required this.stream,
    @required this.child,
  }) : super(key: key);

  final Stream stream;
  final AsyncWidgetBuilder<T> child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: AdaptiveActivityIndicator(),
          );
        }

        if (snapshot.data == null) {
          return Center(child: Text('Something went wrong'));
        }

        return child(context, snapshot);
      },
    );
  }
}

class CustomFutureBuilder extends StatelessWidget {
  const CustomFutureBuilder({
    Key key,
    @required this.future,
    @required this.child,
  }) : super(key: key);

  final Future future;
  final AsyncWidgetBuilder child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return _errorBody(
                'Please check your internet connection: ${snapshot.error}',
                context);
          }

          if (snapshot == null) {
            return _errorBody('No data was retrieved', context);
          }

          return child(context, snapshot);
        } else {
          return Center(
            child: AdaptiveActivityIndicator(),
          );
        }
      },
    );
  }

  Widget _errorBody(String errMsg, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(errMsg),
          // FlatButton(
          //   onPressed: onRefresh,
          //   child: Text(
          //     'Refresh',
          //     style: TextStyle(
          //       color: Colors.lightBlueAccent,
          //       fontSize: 14,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
