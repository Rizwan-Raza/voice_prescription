import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:voice_prescription/modals/disease.dart';

class PrescriptionScreen extends StatefulWidget {
  final DiseaseModal disease;
  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();

  PrescriptionScreen({this.disease});
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  File pdf;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prescription"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Text(
                      widget.disease.user.name ?? "Patient Name",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Age",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Text(
                      widget.disease.user.age ?? "NA",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Text(
                      widget.disease.diagnoseDate ?? "NA",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Disease",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Text(
                      ": ${widget.disease.disease}",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                Row(
                  children: [
                    Text("Suffering since",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Text(
                      ": ${widget.disease.kabSeH}",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              // color: Colors.grey[300],
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Drugs Name",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      child: ListView(
                        shrinkWrap: true,
                        children: widget.disease.prescription
                            .split(" \\n\\n")
                            .map((element) => ListTile(
                                  leading: Icon(Icons.check),
                                  title: Text(element),
                                ))
                            .toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) async {
          switch (value) {
            case 0:
              await getPDF();
              break;
            case 1:
              File pdf = await getPDF();
              FlutterShare.shareFile(
                  title: widget.disease.disease, filePath: pdf.path);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.download), label: "Download"),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: "Share")
        ],
      ),
    );
  }

  Future<File> getPDF() async {
    if (this.pdf == null) {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Text('Hello World!'),
          ),
        ),
      );

      final file =
          File('${widget.disease.disease}_${widget.disease.kabSeH}.pdf');
      await file.writeAsBytes(await pdf.save());
      this.pdf = file;
    }
    return this.pdf;
  }
}
