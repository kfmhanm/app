import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pride/features/ad_details/cubit/ad_details_states.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../cubit/ad_details_cubit.dart';
import '../../domain/model/ad_details_model.dart';
import '../widgets/comment_section.dart';

class AdCommentsScreen extends StatefulWidget {
  const AdCommentsScreen({super.key, required this.adId});
  final int adId;
  @override
  State<AdCommentsScreen> createState() => _AdCommentsScreenState();
}

class _AdCommentsScreenState extends State<AdCommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleAppBar: LocaleKeys.my_ads_keys_comments.tr(),
      ),
      body: BlocProvider(
        create: (context) =>
            AdDetailsCubit()..addPageoffersLisnterComment(widget.adId),
        child: BlocConsumer<AdDetailsCubit, AdDetailsStates>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            final cubit = AdDetailsCubit.get(context);
            return PagedListView(
                padding: EdgeInsets.all(16),
                pagingController: cubit.commentscontroller,
                builderDelegate: PagedChildBuilderDelegate<CommentModel>(
                  itemBuilder: (context, item, index) {
                    return CommentWidget(item: item);
                  },
                  firstPageErrorIndicatorBuilder: (context) {
                    return Center(
                      child: Text('Error'),
                    );
                  },
                  noItemsFoundIndicatorBuilder: (context) {
                    return Center(
                      child: Text('no_items'),
                    );
                  },
                  newPageErrorIndicatorBuilder: (context) {
                    return Center(
                      child: Text('Error'),
                    );
                  },
                  firstPageProgressIndicatorBuilder: (context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  newPageProgressIndicatorBuilder: (context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ));
          },
        ),
      ),
    );
  }
}
