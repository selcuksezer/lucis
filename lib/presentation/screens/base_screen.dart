import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucis/presentation/viewmodels/base_viewmodel.dart';
import 'package:lucis/injection.dart';

class BaseScreen<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    T viewModel,
    Widget? child,
  ) builder;

  const BaseScreen({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  _BaseScreenState<T> createState() => _BaseScreenState<T>();
}

class _BaseScreenState<T extends BaseViewModel> extends State<BaseScreen<T>> {
  T viewModel = locator<T>();

  @override
  void initState() {
    viewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: viewModel,
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
