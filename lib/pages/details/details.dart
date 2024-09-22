import 'package:flutter/material.dart';
import 'package:movie_app/common/utils.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/pages/home/widgets/movies_horizontal_list.dart';
import 'package:movie_app/pages/home/widgets/nowplaying_list.dart';
import 'package:movie_app/services/api_services.dart';

class Details extends StatefulWidget {
  final int movieId;
  const Details({super.key, required this.movieId});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  var apiServices = ApiServices();
  late Future<Movie> movie;
  late Future<Result> reviewsFuture;
  late Future<Result> similarFuture;
  @override
  void initState() {
    movie = apiServices.getMovieDetails(widget.movieId);
    reviewsFuture = apiServices.getMovieReviews(widget.movieId);
    similarFuture = apiServices.getSimilarMovies(widget.movieId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: kBackgoundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: kBackgoundColor,
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: kBackgoundColor,
          )),
      home: Scaffold(
        body: ListView(
          children: [
          FutureBuilder(
              future: movie,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Image(
                          image: NetworkImage(
                              '$imageUrl${snapshot.data!.backdropPath}')),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 15,
                            ),
                            Text(
                              '${snapshot.data!.voteAverage.toStringAsFixed(1)}/10',
                            ),
                            Expanded(
                                child: Container(
                              height: 20,
                            )),
                            Text(snapshot.data!.releaseDate!.year.toString())
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              getGeneros(snapshot.data!.genres!),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: Text(
                            '${snapshot.data!.overview}'),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: Text('No data found'),
                );
              }),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Text(
                  'Similar',
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
                ),
              ),
              FutureBuilder(
                  future: similarFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    return MoviesHorizontalList(
                      movies: snapshot.data!.movies!,
                    );
                  }),
          Container(
            margin: EdgeInsets.all(15),
            child: Text(
              'Reviews',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 20,
              ),
            ),
          ),
          FutureBuilder(
              future: reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.hasData) {
                  final reviews = snapshot.data!.reviews!;
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [Container( 
                            color: rBackgroundColor,
                            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            padding: EdgeInsets.all(8),
                            child: Text(reviews[index].content),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 15, 15),
                                  child: Text('by ${reviews[index].author}')
                                  )
                              ],
                            )
                            ]
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text('No data found'),
                );
              })
        ]),
      ),
    );
  }

  String getGeneros(List<Genre> generos) {
    String retorno = '';
    for (var genero in generos) {
      retorno += '${genero.name}, ';
    }
    if (retorno.length >= 2) {
      retorno = retorno.substring(0, retorno.length - 2);
    }
    return retorno;
  }
}
