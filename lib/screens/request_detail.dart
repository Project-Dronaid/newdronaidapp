import 'package:flutter/material.dart';

class CreateNewPage extends StatefulWidget {
  const CreateNewPage({super.key});

  @override
  State<CreateNewPage> createState() => _CreateNewPageState();
}

class _CreateNewPageState extends State<CreateNewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          surfaceTintColor:
           Colors.transparent,
          centerTitle: true,
          backgroundColor: Colors.grey[100],
          title: const Text(
            "Before you proceed",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway'
            ),
          ),
        
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0,0,0,0),
                child: const Text(
                  "Enter Product Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Raleway', color: Color.fromARGB(255, 38, 26, 60)),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color:Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration:
                                const InputDecoration(labelText: 'Request Product',
                                    suffixStyle: TextStyle(fontFamily: 'Raleway')
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the product name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(labelText: 'Quantity',suffixStyle: TextStyle(fontFamily: 'Raleway')),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the price';
                              }
                              // Add additional validation logic if needed
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _stockController,
                            decoration: const InputDecoration(labelText: 'Weight',suffixStyle: TextStyle(fontFamily: 'Raleway')),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the stock';
                              }
                              // Add additional validation logic if needed
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Add an ImagePicker or Image selection widget for the product photo
                          // Example: ImagePickerWidget(),
                          

                          // Selected Image Preview
                                                       


                          // Centered Submit Button with custom width and styling
                          Container(
                            width: double.infinity, // Full width
                            margin: const EdgeInsets.symmetric(
                                vertical: 16.0), // Adjust margin as needed
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the submit button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        // const Color.fromRGBO(10, 106, 157, 1), // Background color
                        const Color(0xFF6F35A5),
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 12.0), // Adjust padding as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust border radius as needed
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style:
                        TextStyle(fontSize: 18.0, fontFamily: 'Raleway'), // Adjust font size as needed
                  ),
                ),
              ),
              
              
              
            ],
          ),
        ),
      ),
    );
  }
}
