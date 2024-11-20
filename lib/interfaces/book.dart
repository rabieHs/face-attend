import 'package:attendence/services/athkar_services.dart';
import 'package:flutter/material.dart';

import '../models/athkar.dart';

class BookInterface extends StatefulWidget {
  const BookInterface({super.key});

  @override
  _BookInterfaceState createState() => _BookInterfaceState();
}

class _BookInterfaceState extends State<BookInterface> {
  final ScrollController _scrollController = ScrollController();

  void _goBack() {
    Navigator.pop(
        context); // Replace with the actual route to the invigilator page if necessary
  }

  void _scrollUp() {
    _scrollController.animateTo(
      _scrollController.offset - 100, // Scroll up by 100 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.offset + 100, // Scroll down by 100 pixels
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showAthkarDescription(Athkar athkar) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(athkar.name),
          content: Text(athkar.description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Athkar>>(
          future: AthkarServices.fetchAthkars(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);

              return const Center(child: Text('An error occurred'));
            }
            if (snapshot.hasData && snapshot.data != null) {
              final athkar = snapshot.data!;
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/book.webp'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                          height:
                              230), // Increased space to push the table further down
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                                height: 7), // Space between header and table
                            const Text(
                              'أذكار',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 7),
                            SizedBox(
                              height: 150, // Set a fixed height for the table
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: athkar.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _showAthkarDescription(athkar[index]),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: const Color(0xFFEAECF0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            athkar[index].name,
                                            style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_upward),
                                  onPressed: _scrollUp,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_downward),
                                  onPressed: _scrollDown,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _goBack,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8E8E93),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
