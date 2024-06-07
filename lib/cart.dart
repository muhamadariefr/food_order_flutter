import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as myhttp;
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:pesan_makanan/models/menu_models.dart';
import 'package:pesan_makanan/providers/cart_providers.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  final String urlMenu =
      'https://script.google.com/macros/s/AKfycbyngoW4XFEoo2gDOQ9wT08FpZiPFPg-L-AiRGHGDWjPzeYOnr6upXpvU6hrGbm5M15_/exec';

  Future<List<MenuModel>> getAllData() async {
    List<MenuModel> listMenu = [];
    var response = await myhttp.get(Uri.parse(urlMenu));
    List data = json.decode(response.body);

    data.forEach((element) {
      listMenu.add(MenuModel.fromJson(element));
    });

    return listMenu;
  }

  String _selectedDeliveryOption = "Diantar Kerumah";

  void openDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 400,
              child: Column(
                children: [
                  Text(
                    "Nama",
                    style: GoogleFonts.montserrat(),
                  ),
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Alamat",
                    style: GoogleFonts.montserrat(),
                  ),
                  TextFormField(
                    controller: alamatController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Pilihan Pengiriman",
                    style: GoogleFonts.montserrat(),
                  ),
                  ListTile(
                    title: const Text('Diantar Kerumah'),
                    leading: Radio<String>(
                      value: "Diantar Kerumah",
                      groupValue: _selectedDeliveryOption,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedDeliveryOption = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Ambil Ditempat'),
                    leading: Radio<String>(
                      value: "Ambil Ditempat",
                      groupValue: _selectedDeliveryOption,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedDeliveryOption = value!;
                        });
                      },
                    ),
                  ),
                  Consumer<CartProvider>(
                    builder: (context, value, _) {
                      String strPesanan = "";
                      value.cart.forEach((element) {
                        strPesanan = strPesanan +
                            "\n" +
                            element.name +
                            " {" +
                            element.quantity.toString() +
                            "}";
                      });
                      return ElevatedButton(
                          onPressed: () async {
                            String phone = "6281322751816";
                            String pesanan = "Nama : " +
                                namaController.text +
                                "\nAlamat : " +
                                alamatController.text +
                                "\nPilihan Pengiriman : " +
                                _selectedDeliveryOption +
                                "\nPesanan : " +
                                strPesanan;
                            String url =
                                "https://wa.me/$phone?text=${Uri.encodeComponent(pesanan)}";

                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Text("Pesan Sekarang"));
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        child: badges.Badge(
          badgeContent: Consumer<CartProvider>(
            builder: (context, value, _) {
              return Text(
                (value.total > 0) ? value.total.toString() : "",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                ),
              );
            },
          ),
          child: Icon(Icons.shopping_bag),
        ),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: getAllData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            MenuModel menu = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(menu.image))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16),
                                          child: Text(
                                            menu.name,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          menu.description,
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.montserrat(
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Rp. " + menu.price.toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Provider.of<CartProvider>(
                                                              context,
                                                              listen: false)
                                                          .addRemove(menu.name,
                                                              menu.id, false);
                                                    },
                                                    icon: Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Consumer<CartProvider>(
                                                  builder: (context, value, _) {
                                                    var id = value.cart
                                                        .indexWhere((element) =>
                                                            element.menuId ==
                                                            snapshot
                                                                .data![index]
                                                                .id);
                                                    return Text(
                                                      (id == -1)
                                                          ? "0"
                                                          : value
                                                              .cart[id].quantity
                                                              .toString(),
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    );
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      Provider.of<CartProvider>(
                                                              context,
                                                              listen: false)
                                                          .addRemove(menu.name,
                                                              menu.id, true);
                                                    },
                                                    icon: Icon(
                                                      Icons.add_circle,
                                                      color: Colors.green,
                                                    )),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  } else {
                    return Center(
                      child: Text('Tidak ada Data'),
                    );
                  }
                }
              }),
        ],
      )),
    );
  }
}
