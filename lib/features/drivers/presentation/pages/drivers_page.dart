import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdm/core/widgets/empty_widget.dart';
import 'package:vdm/core/widgets/loading_widget.dart';
import 'package:vdm/features/drivers/presentation/widgets/driver_card.dart';

import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/errors_widget.dart';
import '../bloc/drivers_bloc.dart';

class DriversPage extends StatefulWidget {
  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  @override
  void initState() {
    super.initState();

    context.read<DriversBloc>().add(const LoadDriversEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DriversBloc, DriversState>(
        listenWhen: (previous, current) => current is DriversError,
        listener: (context, state) {
          if (state is DriversError) {
            AppUtils.showErrorSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<DriversBloc, DriversState>(
          builder: (context, state) {
            if (state is DriversLoading) {
              return const LoadingWidget(message: 'Loading drivers...');
            } else if (state is DriversError) {
              return ErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<DriversBloc>().add(const LoadDriversEvent());
                },
              );
            } else if (state is DriversLoaded) {
              if (state.drivers.isEmpty) {
                return const EmptyWidget();
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DriversBloc>().add(const LoadDriversEvent());
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: state.drivers.length,
                  itemBuilder: (context, index) {
                    return Text(state.drivers[index].fullName??'--');
                  },
                ),
              );
            }

            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }
}
