import 'dart:async';
import 'dart:io';
import 'package:basketapp/database/DataCollection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfGenerator {
  Future<void> generateInvoice(var itemData, FirebaseUser firebaseUser) async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(0, 170, 219, 255)));
    //Generate PDF grid.
    final PdfGrid grid = await getGrid(itemData);
    final user = await DataCollection().getUserDetails();
    String userName = user['displayName'];
    //Draw the header section by creating text element
    String date = DateTime.parse(itemData['orderDate'].toDate().toString())
        .toLocal()
        .toString();
    final String invoiceNumber =
        'Invoice Number: ${itemData['orderId']} \r\n\r\n Date: ${date}';

    String address =
        "Bill To: \r\n\r\n ${user['displayName']}, \r\n\r\n${user['street']}, ${user['city']}, ${user['district']}, "
        '\r\n\r\n${user['pincode']} ${user['state']}, \r\n\r\n${user['mobileNumber']}';

    final PdfLayoutResult result =
        drawHeader(page, pageSize, grid, invoiceNumber, address);
    //Draw grid
    drawGrid(page, grid, result);
    //Add invoice footer
    drawFooter(page, pageSize);
    //Save and launch the document
    final List<int> bytes = document.save();
    //Dispose the document.
    document.dispose();
    //Get the storage folder location using path_provider package.
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    var orderId = itemData['orderId'];
    final File file = File('$path/order_${orderId}.pdf');
    file.writeAsBytes(bytes);
    //Launch the file (used open_file package)
    OpenFile.open('$path/order_${orderId}.pdf');
    print(path);
  }

  PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid,
      String invoiceNumber, String address) {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString(
        'Go Mudi Invoice', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(65, 104, 205)));

    page.graphics.drawString('INR' + getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Draw string
    page.graphics.drawString('Amount', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');

    final Size contentSize = contentFont.measureString(invoiceNumber);

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120));
  }

  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect totalPriceCellBounds;
    Rect quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));

    //Draw grand total.
    page.graphics.drawString('Grand Total',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds.left,
            result.bounds.bottom + 10,
            quantityCellBounds.width,
            quantityCellBounds.height));
    page.graphics.drawString(getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds.width,
            totalPriceCellBounds.height));
  }

  //Draw the invoice footer data.
  void drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
    PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));

    const String footerContent =
        'wwww.gomudi.com \r\n\r\n Lenin Sarani, Santipur, Nadia,'
        ' Pin-741404 \r\n\r\nAny Questions? support@gomudi.com or call '
        ' + 91 7063530676';

    //Added 30 as a margin for the layout
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //Create PDF grid and return
  Future<PdfGrid> getGrid(var itemData) async {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Product Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Product Name';
    headerRow.cells[2].value = 'Price';
    headerRow.cells[3].value = 'Quantity';
    headerRow.cells[4].value = 'Total';
    QuerySnapshot itemList = await DataCollection()
        .getSubCollectionOfOrder(itemData['orderId']);


    itemList.documents.forEach((element) {
      double price = double.parse(element.data['price']);
      int quan = int.parse(element.data['quantity']);
      addProducts(element.data['itemId'], element.data['itemName'], price, quan,
          price * quan, grid);
      print(element.data['itemName']);
    });


    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void addProducts(String productId, String productName, double price,
      int quantity, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = total.toString();
  }

  //Get the total amount.
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value = grid.rows[i].cells[grid.columns.count - 1].value;
      total += double.parse(value);
    }
    return total;
  }

}