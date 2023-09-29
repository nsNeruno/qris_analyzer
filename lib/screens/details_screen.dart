import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qris/qris.dart';
import 'package:qris_analyzer/blocs/analyzer_bloc.dart';
import 'package:qris_analyzer/models/cached_code.dart';
import 'package:qris_analyzer/utils/app_constants.dart';
import 'package:qris_analyzer/utils/logger.dart';
import 'package:qris_analyzer/utils/num_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'details/basic_details_screen.dart';
part 'details/technical_details_screen.dart';

class DetailsScreen extends StatelessWidget {

  const DetailsScreen({super.key,});

  @override
  Widget build(BuildContext context) {

    CachedCode? codeArg;
    final args = ModalRoute.of(context,)?.settings.arguments;
    if (args is CachedCode) {
      codeArg = args;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details',),
      ),
      body: DefaultTabController(
        length: 2,
        child: Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context,);
            return Column(
              children: [
                TabBar(
                  controller: tabController,
                  labelColor: Colors.red,
                  tabs: const [
                    Tab(text: 'Basic',),
                    Tab(text: 'Technical',),
                  ],
                ),
                Expanded(
                  child: BlocSelector<AnalyzerBloc, AnalyzerState, QRIS?>(
                    selector: (state,) => state.data,
                    builder: (context, qris,) {

                      if (codeArg != null) {
                        try {
                          qris = QRIS(codeArg.data,);
                        } catch (_) {
                          return const Center(
                            child: Text('Invalid QRIS data',),
                          );
                        }
                      }

                      if (qris == null) {
                        return const Center(
                          child: Text(
                            'No scanned data',
                          ),
                        );
                      }
                      return TabBarView(
                        controller: tabController,
                        children: [
                          _BasicDetailsScreen(qris: qris,),
                          _TechnicalDetailsScreen(qris: qris,),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}