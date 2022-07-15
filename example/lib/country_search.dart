import 'package:example/country_model.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CountrySearch extends StatefulWidget {
  CountrySearch({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CountrySearchState createState() => _CountrySearchState();
}

class _CountrySearchState extends State<CountrySearch> {
  int get count => 40;
  late List<_TextBoxMetaData<Country>> metaData;
  Country? _selectedCountry;
  ScrollController scrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    metaData.forEach((m) => m.dispose());
  }

  @override
  void initState() {
    super.initState();

    metaData = List.generate(
      count,
      (index) => _TextBoxMetaData(
        data: data.map((e) => Country.fromMap(e)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    itemCount: metaData.length,

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 4.00,
                    ),

                    itemBuilder: (BuildContext context, int index) {
                      return SearchField(
                        suggestions: metaData[index]
                            .data
                            .map((country) => SearchFieldListItem(
                                  country.name,
                                  item: country,
                                ))
                            .toList(),
                        onSubmit: (value) {},
                        suggestionState: Suggestion.expand,
                        controller: metaData[index].controller
                          ..addListener(() {}),
                        suggestionAction: SuggestionAction.unfocus,
                        hint: 'Select Country',
                        maxSuggestionsInViewPort: 7,
                        itemHeight: 55,
                        inputType: TextInputType.text,
                        onSuggestionTap: (SearchFieldListItem<Country> x) {
                          setState(() {
                            if (x.item != null) {
                              _selectedCountry = x.item;
                            }
                            metaData[index].focus.unfocus();
                          });
                        },
                      );
                    },

                    shrinkWrap: true,
                    // childAspectRatio: 3.00,
                    // crossAxisSpacing: 20,
                    // mainAxisSpacing: 20,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    // Generate 100 widgets that display their index in the List.

                    // children: metaData
                    //     .map(
                    //       (md) => SearchField(
                    //         suggestions: md.data
                    //             .map((country) => SearchFieldListItem(
                    //                   country.name,
                    //                   item: country,
                    //                 ))
                    //             .toList(),
                    //         onSubmit: (value) {},
                    //         suggestionState: Suggestion.expand,
                    //         controller: md.controller..addListener(() {}),
                    //         suggestionAction: SuggestionAction.unfocus,
                    //         hint: 'Select Country',
                    //         maxSuggestionsInViewPort: 6,
                    //         itemHeight: 55,
                    //         inputType: TextInputType.text,
                    //         onSuggestionTap: (SearchFieldListItem<Country> x) {
                    //           setState(() {
                    //             if (x.item != null) {
                    //               _selectedCountry = x.item;
                    //             }
                    //             md.focus.unfocus();
                    //           });
                    //         },
                    //       ),
                    //     )
                    //     .toList(growable: false),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class CountryDetail extends StatefulWidget {
  final Country? country;

  CountryDetail({Key? key, required this.country}) : super(key: key);
  @override
  _CountryDetailState createState() => _CountryDetailState();
}

class _CountryDetailState extends State<CountryDetail> {
  Widget dataWidget(String key, int value) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$key:'),
          SizedBox(
            width: 16,
          ),
          Flexible(
            child: Text(
              '$value',
              style: TextStyle(fontSize: 30),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.country!.name,
            style: TextStyle(fontSize: 40),
          ),
          SizedBox(
            height: 20,
          ),
          dataWidget('Population:', widget.country!.population),
          dataWidget('Density', widget.country!.density),
          dataWidget('Land Area (in Km\'s)', widget.country!.landArea)
        ],
      ),
    );
  }
}

class _TextBoxMetaData<T> {
  _TextBoxMetaData({
    required this.data,
  }) {
    controller = TextEditingController();
    focus = FocusNode();
  }

  late final TextEditingController controller;
  late final FocusNode focus;
  final List<T> data;

  void dispose() {
    controller.dispose();
    focus.dispose();
  }
}
