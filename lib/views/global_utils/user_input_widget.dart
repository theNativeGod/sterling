import 'package:flutter/material.dart';

import '../../services/services.dart';

class UserInputWidget extends StatefulWidget {
  UserInputWidget(
      {required this.inputController,
      required this.hintText,
      required this.validator,
      super.key});
  TextEditingController inputController = TextEditingController();
  var validator;
  var hintText;
  @override
  State<UserInputWidget> createState() => _UserInputWidgetState();
}

class _UserInputWidgetState extends State<UserInputWidget> {
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * .72,
            child: CompositedTransformTarget(
              link: _layerLink,
              child: TextFormField(
                focusNode: _focusNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: widget.validator,
                controller: widget.inputController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 1,
                    ),
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    suffixIcon:
                        const Icon(Icons.location_pin, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor))),
              ),
            )),
        _overlay(),
      ],
    );
  }

  _overlay() {
    // RenderBox _renderBox = context.findRenderObject() as RenderBox;
    // var size = _renderBox.size;
    var height = 50;
    var width = MediaQuery.of(context).size.width * .72;
    return Positioned(
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0.0, height + 5.0),
        child: SizedBox(
          width: width,
          child: Card(
            elevation: 5.0,
            child: Container(
              height: _focusNode.hasFocus ? 30.0 * _places.length : 0,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: _places.length,
                  itemBuilder: (ctx, i) {
                    return InkWell(
                      onTap: () {
                        widget.inputController.text = _places[i];
                        setState(() {});
                        _focusNode.unfocus();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
          ),
        ),
      ),
    );
  }
}
