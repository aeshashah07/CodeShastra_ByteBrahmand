import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YoutubeWidget extends StatefulWidget {
  final String ytThumbnail;
  final String ytTitle;
  final String ytChannel;
  final String ytLink;
  const YoutubeWidget(
      {super.key,
      required this.ytThumbnail,
      required this.ytTitle,
      required this.ytChannel,
      required this.ytLink});

  @override
  State<YoutubeWidget> createState() => _YoutubeWidgetState();
}

class _YoutubeWidgetState extends State<YoutubeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: Container(
        width: 330,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Color(0x230F1113),
              offset: Offset(
                0.0,
                4,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFFF1F4F8),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: () async {
                if (!await launchUrl(Uri.parse(widget.ytLink))) {
                  throw Exception('Could not launch');
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  widget.ytThumbnail,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.ytTitle,
                          style: TextStyle(
                            color: Color(0xFF14181B),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // RatingBarIndicator(
                              //   itemBuilder: (context, index) => Icon(
                              //     Icons.radio_button_checked_rounded,
                              //     color: Color(0xFF14181B),
                              //   ),
                              //   direction: Axis.horizontal,
                              //   rating: 4,
                              //   unratedColor: Color(0xFF57636C),
                              //   itemCount: 5,
                              //   itemSize: 16,
                              // ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                child: Text(
                                  widget.ytChannel,
                                  style: TextStyle(
                                      color: Color(0xFF14181B), fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   height: 32,
                  //   decoration: BoxDecoration(
                  //     color: Color(0xFF14181B),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   alignment: AlignmentDirectional(0, 0),
                  //   child: Padding(
                  //     padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                  //     child: Text(
                  //       '\$220 USD',
                  //       style: FlutterFlowTheme.of(context).bodyMedium.override(
                  //             fontFamily: 'Plus Jakarta Sans',
                  //             color: Colors.white,
                  //             fontSize: 14,
                  //             letterSpacing: 0,
                  //             fontWeight: FontWeight.normal,
                  //           ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
