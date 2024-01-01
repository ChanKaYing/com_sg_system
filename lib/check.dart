/*
  Future<void> showAlertDialog() async{

    String fetchedData = '';
    QuerySnapshot querySnapshot = await _firestore.collection('emergency').get();
    var Emermap = querySnapshot.docs.map((document){
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      showDialog(
        context: context,
        builder: (BuildContext context){

          return AlertDialog(
            title: Text('Emergency Detail'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Name: ${data['ID']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Emergency Type: ${data['emergencyType']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Call the delete function when delete icon is pressed
                              print("OK DELETE");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),

                ],
              ),
            ),
          );
        },
      );
    }).toList();
  }

 */

/*
Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Name: ${data['ID']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Emergency Type: ${data['emergencyType']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Call the delete function when delete icon is pressed
                              print("OK DELETE");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
 */