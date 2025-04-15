// import 'dart:async';

// abstract class UseCase<T> {
//   final _controller = StreamController<T>();
//   Stream<T> get stream => _controller.stream;

//   void add(T obj) {
//     if (_controller.isClosed) return;
//     _controller.sink.add(obj);
//   }

//   void addError(CustomErrorModel error) {
//     _controller.sink.addError(error);
//   }

//   void close() {
//     _controller.close();
//   }
// }

// class CustomErrorModel {
//   final String message;
//   final int code;

//   CustomErrorModel({required this.message, required this.code});

//   @override
//   String toString() => 'Error $code: $message';
// }
