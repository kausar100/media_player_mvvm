import 'package:flutter/material.dart';
import 'package:mvvm_flutter/model/model.dart';
import 'package:mvvm_flutter/view_model/media_view_model.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class PlayerListWidget extends StatefulWidget {
  final List<Media> _mediaList;

  PlayerListWidget(this._mediaList);

  @override
  State<PlayerListWidget> createState() => _PlayerListWidgetState();
}

class _PlayerListWidgetState extends State<PlayerListWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 25,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          Media data = widget._mediaList[index];
          return InkWell(
            onTap: () {
              if (data.artistName != null) {
                context.read<MediaViewModel>().setSelectedMedia(data);
              }
            },
            child: _buildSongItem(data),
          );
        },
      ),
    );
  }

  Widget _buildSongItem(Media data) {
    Media? selectedMedia = Provider.of<MediaViewModel>(context).media;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: SizedBox(
              width: 50,
              height: 50,
              child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      const CircularProgressIndicator.adaptive(),
                  imageUrl: data.artworkUrl ?? ''),
              // child: Image.network(data.artworkUrl ?? ''),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.trackName ?? '',
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                data.artistName ?? '',
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                data.collectionName ?? '',
                style: const TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )),
          if (selectedMedia != null &&
              selectedMedia.trackName == data.trackName)
            Icon(
              Icons.play_circle_outline,
              color: Theme.of(context).primaryColor,
            ),
        ],
      ),
    );
  }
}
