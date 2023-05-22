import 'package:app2/shared/history/domain/conv_history.dart';
import 'package:app2/theme.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';

class HistoryDrawer extends StatefulWidget {
  final ConvHistoryRepoInterface _repo =
      KiwiContainer().resolve<ConvHistoryRepoInterface>();
  final String parentId;

  final Function(ConvHistory history) loadHistory;

  HistoryDrawer({
    super.key,
    required this.loadHistory,
    required this.parentId,
  });

  @override
  State<HistoryDrawer> createState() => _HistoryDrawerState();
}

class _HistoryDrawerState extends State<HistoryDrawer> {
  final List<ConvHistory> _history = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<ConvHistory>>(
          future: widget._repo.getAllForParent(widget.parentId), // assuming this is your Future
          builder: (BuildContext context, AsyncSnapshot<List<ConvHistory>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildListItem(snapshot.data![index], index);
                },
              );
            }
          },
        ),
      ),
    );
  }


  Widget _buildListItem(ConvHistory item, int index) {
    return GestureDetector(
      onLongPress: () {
        widget._repo.deleteHistory(item);
        setState(() {
          print(1);
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 1,
                offset: Offset(-3, 3),
              )
            ],
            borderRadius: BorderRadius.circular(8.0),
            color: Theme
                .of(context)
                .colorScheme
                .primary,
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.loadHistory(item);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      item.title ?? 'Conversation: $index' ,
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
