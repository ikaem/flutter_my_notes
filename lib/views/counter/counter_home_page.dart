import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterHomePage extends StatefulWidget {
  const CounterHomePage({Key? key}) : super(key: key);

  @override
  State<CounterHomePage> createState() => _CounterHomePageState();
}

class _CounterHomePageState extends State<CounterHomePage> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterBloc>(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Testing Bloc"),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: ((context, state) {
            // this will trigger on any state change
            _textController.clear();
          }),
          builder: ((context, state) {
            final invalidValue =
                (state is CounterStateInvalid) ? state.invalidValue : "";

            return Column(
              children: <Widget>[
                Text("Current value => ${state.value}"),
                Visibility(
                  child: Text("Invalid input: $invalidValue"),
                  visible: state is CounterStateInvalid,
                ),
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(hintText: "Enter number"),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(IncrementEvent(_textController.text));
                      },
                      child: Text("Increment"),
                    ),
                    TextButton(
                      onPressed: () {
                        onPressed:
                        () {
                          context
                              .read<CounterBloc>()
                              .add(DecrementEvent(_textController.text));
                        };
                      },
                      child: Text("Decrement"),
                    )
                  ],
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalid extends CounterState {
  final String invalidValue;

  const CounterStateInvalid({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>(((event, emit) {
      // checking event
      // event value is a string, because this is how we defined it
      final integer = int.tryParse(event.value);

      // integer will be null if tryParse fails
      if (integer == null) {
        emit(CounterStateInvalid(
            invalidValue: event.value, previousValue: state.value));
        return;
      }

      emit(CounterStateValid(state.value + integer));
    }));
    on<DecrementEvent>(((event, emit) {
      // checking event
      // event value is a string, because this is how we defined it
      final integer = int.tryParse(event.value);

      // integer will be null if tryParse fails
      if (integer == null) {
        emit(CounterStateInvalid(
            invalidValue: event.value, previousValue: state.value));
        return;
      }

      emit(CounterStateValid(state.value - integer));
    }));
  }
}
