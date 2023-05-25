import 'package:app2/shared/history/domain/conv_history.dart';
import 'package:app2/shared/history/interfaces/history_provider.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryDrawer extends StatefulWidget {
  final String parentId;

  const HistoryDrawer({
    super.key,
    required this.parentId,
  });

  @override
  State<HistoryDrawer> createState() => _HistoryDrawerState();
}

class _HistoryDrawerState extends State<HistoryDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryProvider>().loadHistory(widget.parentId);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<HistoryProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              itemCount: provider.history.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildListItem(provider.history[index], index);
              },
            );
          },
        ),
      ),
    );
  }


  Widget _buildListItem(ConvHistory item, int index) {
    return GestureDetector(
      onLongPress: () {
        context.read<HistoryProvider>().delete(index);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 1,
                offset: const Offset(-3, 3),
              )
            ],
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      item.title ?? 'New chat srat',
                      style: const TextStyle(
                          color: DarkTheme.textColor, fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
