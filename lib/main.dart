import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/productController.dart';
import 'package:todo/productModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final List<String> _tasks = [];
  final TextEditingController _controller = TextEditingController();



  void _addTask() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _tasks.add(_controller.text);
        _controller.clear();
      }
    });
  }

  void editDialog(int index){
_controller.text = _tasks[index];
    showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter Task',
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(onPressed: ()=>_editTask(index), child: Text('Edit Task'))
        ],
      ),
    ));
  }

  void _editTask(int index){
setState(() {
  _tasks[index] = _controller.text;
  _controller.clear();
});
Navigator.pop(context);
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Task',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    onDismissed: (direction) => _removeTask(index),
                    background: Container(color: Colors.red),
                    key:Key( _tasks[index]),
                    child: ListTile(
                      title: Text(_tasks[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: (){
                            editDialog(index);
                          }, icon: Icon(Icons.edit)),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeTask(index),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void showAlertDialog(){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text('Add Product'),
      content: Column(

      ),
    ));
  }

  void productDialog(
      {String? id,
        String? name,
        int? qty,
        String? img,
        int? unitPrice,
        int? totalPrice}) {
    TextEditingController productNameController = TextEditingController();
    TextEditingController productcodeController = TextEditingController();
    TextEditingController productQtyController = TextEditingController();
    TextEditingController productImageController = TextEditingController();
    TextEditingController productUnitPriceController = TextEditingController();
    TextEditingController productTotalPriceController = TextEditingController();

    productNameController.text = name ?? '';
    productQtyController.text = qty != null ? qty.toString() : '0';
    productImageController.text = img ?? '';

    productUnitPriceController.text =unitPrice  != null ?  unitPrice.toString() : '0';
    productTotalPriceController.text =totalPrice !=null ? totalPrice.toString() : '0';

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(id == null ? 'Add product' : 'Update product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productNameController,
                decoration: InputDecoration(labelText: 'Product name'),
              ),
              TextField(
                controller: productImageController,
                decoration: InputDecoration(labelText: 'Product Image'),
              ),
              TextField(
                controller: productQtyController,
                decoration: InputDecoration(labelText: 'Product Qty'),
              ),
              TextField(
                controller: productUnitPriceController,
                decoration:
                InputDecoration(labelText: 'Product unit price'),
              ),
              TextField(
                controller: productTotalPriceController,
                decoration: InputDecoration(labelText: 'Total price'),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close')),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (id == null) {
                          productController.createProduct(
                              productNameController.text,
                              productImageController.text,
                              int.parse(productQtyController.text),
                              int.parse(productUnitPriceController.text),
                              int.parse(productTotalPriceController.text));
                        } else {
                          productController.UpdateProduct(
                              id,
                              productNameController.text,
                              productImageController.text,
                              int.parse(productQtyController.text),
                              int.parse(productUnitPriceController.text),
                              int.parse(productTotalPriceController.text));
                        }


                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text(
                          id == null ? 'Add product' : 'Update product')),
                ],
              )
            ],
          ),
        ));
  }

  ProductController productController = ProductController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await productController.fetchProducts();
    print(productController.products.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://thumbs.dreamstime.com/b/atlanta-georgia-usa-downtown-skyline-atlanta-georgia-usa-110765393.jpg'),
                ),
                  SizedBox(height: 10),
                  Text('John Doe',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Text('jhon@gmail.com',style: TextStyle(fontSize: 16),)

              ],
            )),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: productController.products.length,

        itemBuilder: (BuildContext context, int index) {
          var product = productController.products[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(product.img.toString()),
              ),
              title: Text('${product.productName}'),
            ),
          );

        },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => productDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
