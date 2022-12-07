import 'package:flutter/material.dart';
import 'package:mvvm_flutter/model/apis/api_responses.dart';
import 'package:mvvm_flutter/model/model.dart';
import 'package:mvvm_flutter/view/widgets/player_list_widget.dart';
import 'package:mvvm_flutter/view/widgets/player_widget.dart';
import 'package:mvvm_flutter/view_model/media_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final inputController = TextEditingController();

    ApiResponse apiResponse = Provider.of<MediaViewModel>(context).response;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Media Player')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.secondary.withAlpha(50),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                        // autofocus: true,
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                        controller: inputController,
                        onChanged: (value) {},
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            context
                                .read<MediaViewModel>()
                                .fetchMediaData(value);
                          }
                        },
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: 'Enter Artist Name',
                        )),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: getMediaWidget(context, apiResponse)),
        ],
      ),
    );
  }

  Widget getMediaWidget(BuildContext context, ApiResponse apiResponse) {
    List<Media>? mediaList = apiResponse.data as List<Media>?;

    switch (apiResponse.status) {
      case Status.LOADING:
        return const Center(child: CircularProgressIndicator.adaptive());

      case Status.COMPLETED:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            mediaList != null && mediaList.isNotEmpty
                ? Expanded(
                    flex: 8,
                    child: PlayerListWidget(mediaList),
                  )
                : const Expanded(
                    child: Center(
                      child: Text('Search the song by Artist'),
                    ),
                  ),
            if (context.watch<MediaViewModel>().media != null)
              const Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: PlayerWidget(),
                ),
              ),
          ],
        );
      case Status.ERROR:
        return const Center(
          child: Text('Please try again latter!!!'),
        );
      case Status.INITIAL:
      default:
        return const Center(
          child: Text('Search the song by Artist Name'),
        );
    }
  }
}
