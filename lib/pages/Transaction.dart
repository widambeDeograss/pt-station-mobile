import 'package:flutter/material.dart';
import 'package:pts/models/transaction_model.dart';
import 'package:pts/pages/profile.dart';
import 'package:pts/request/customer_request.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction"),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 5),
              child: IconButton(
                icon: const Icon(Icons.person_pin_circle),
                tooltip: 'Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
              ))
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: CustomerRequest.getTransaction(context),
          builder: (ctx, AsyncSnapshot<List<TransactionModel>> snapshot) {
            // Error handling
            if (snapshot.hasError) {
              return Center(
                child: Text("An error occurred"),
              );
            }

            // Show loading indicator while waiting for the future
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 10),
                    Text("Please wait..."),
                  ],
                ),
              );
            }

            // Once the future is done, display the ListView
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                var transactions = snapshot.data; // Your data here

                // Check if data is empty
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("No transactions available"),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    TransactionModel transaction = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      child: Card(
                        child: ListTile(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: const Text('Actions'),
                                      content: SizedBox(
                                        height: 100,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: Icon(Icons.print),
                                              title: Text("Reprint Receipt"),
                                              onTap: () async {
                                                final scaffoldMessenger =
                                                    ScaffoldMessenger.of(
                                                        context);
                                                String message =
                                                    await CustomerRequest
                                                        .reprintReceipt(
                                                            context,
                                                            transaction
                                                                .invoiceNumber!);
                                                scaffoldMessenger.showSnackBar(
                                                    SnackBar(
                                                        content:
                                                            Text(message)));
                                                Navigator.pop(context);
                                              },
                                            ),
                                            Divider()
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          leading: Image.asset(
                            "assets/images/cash.png",
                            height: 40,
                            width: 40,
                          ),
                          subtitle: Text(transaction.invoiceNumber.toString()),
                          title: Text(
                            transaction.goodsName!.toString(),
                          ),
                          trailing: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "Amount",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(transaction.grossAmount.toString()),
                              )
                            ],
                          ),

                          // Customize item text
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text("No data found"),
                );
              }
            }

            return Container(); // Default empty container case
          },
        ),
      ),
    );
  }

  void showPopUpMenu(BuildContext context, TransactionModel transaction) async {
    // Get the overlay context
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    // Get the RenderBox of the button (widget that triggers the menu)
    final RenderBox button = context.findRenderObject() as RenderBox;

    if (button == null || overlay == null) {
      return; // Make sure the render objects are not null
    }

    // Calculate the position for the PopupMenu
    final relativeRect = RelativeRect.fromRect(
      button.localToGlobal(Offset.zero) & button.size, // Button position
      Offset.zero & overlay.size, // Overlay size
    );

    // Show the PopupMenu
    await showMenu<String>(
      context: context,
      position: relativeRect,
      items: [
        PopupMenuItem<String>(
          value: 'Reprint',
          child: Text('Action 1'),
        ),
        // Add more menu items here if needed
      ],
    ).then((String? selectedAction) {
      if (selectedAction != null) {
        // Handle the selected action (e.g., 'Reprint' action)
        print('Selected action: $selectedAction');
      }
    });
  }
}
