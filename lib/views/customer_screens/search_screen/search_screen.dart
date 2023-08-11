import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../services/services.dart';
import '../../global_utils/close_button.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({required this.inputController, super.key});
  TextEditingController inputController = TextEditingController();
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  LayerLink _layerLink = LayerLink();
  FocusNode _focusNode = FocusNode();
  List<String> _places = [];
  bool keyReceived = false;
  bool isInit = true;
  String APIKEY = '';
  Services services = Services();

  @override
  void didChangeDependencies() {
    if (isInit) {
      getApiKey();
      _focusNode.requestFocus();
      addPlacesListener();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  getApiKey() async {
    APIKEY = await services.getApiKey();
    keyReceived = true;
  }

  getAutocompleteSuggestions(inputPlace) async {
    _places = await services.getPlacesAutocompleteData(APIKEY, inputPlace);
    print(_places);

    setState(() {});
  }

  addPlacesListener() {
    widget.inputController.addListener(() {
      if (widget.inputController.text.isEmpty ||
          widget.inputController.text == '') {
        _places = [];
        setState(() {});
      }
      if (keyReceived) {
        getAutocompleteSuggestions(widget.inputController.text);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var decoration = InputDecoration(
      hintText: 'Search any place',
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
      ),
      contentPadding: const EdgeInsets.all(16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xfff4f4f4),
          width: 1,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xfff4f4f4),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .95,
              color: Colors.transparent,
              child: SafeArea(
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .95 - 32,
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        const CloseButtonWidget(),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          focusNode: _focusNode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          controller: widget.inputController,
                          decoration: decoration,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          color: const Color(0xffF4F4F4),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: _places.length,
                              itemBuilder: (ctx, i) {
                                return InkWell(
                                  onTap: () {
                                    widget.inputController.text = _places[i];
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      i > 0
                                          ? const Divider(
                                              color: Colors.grey,
                                              thickness: .5,
                                            )
                                          : Container(),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        height: 30,
                                        child: Text(
                                          softWrap: false,
                                          _places[i],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .2,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
