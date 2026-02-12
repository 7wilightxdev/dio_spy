import 'package:flutter/material.dart';

import '../../models/http_call.dart';
import '../../utils/clipboard_helper.dart';
import '../../utils/curl_builder.dart';
import '../theme.dart';
import '../widgets/toast_overlay.dart';
import 'request_tab.dart';
import 'response_tab.dart';

class CallDetailScreen extends StatelessWidget {
  const CallDetailScreen({super.key, required this.call});

  final DioSpyHttpCall call;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DioSpyTheme.themeData(context),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '${call.method} ${call.endpoint}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.copy_rounded),
                tooltip: 'Copy as cURL',
                onPressed: () {
                  final curl = CurlBuilder.build(call);
                  ClipboardHelper.copy(curl);
                  DioSpyToast.show(context, 'cURL copied');
                },
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Request'),
                Tab(text: 'Response'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              RequestTab(call: call),
              ResponseTab(call: call),
            ],
          ),
        ),
      ),
    );
  }
}
