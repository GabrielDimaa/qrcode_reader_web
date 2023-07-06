En-US
# QR Code Reader - Web
This library aims to read QR Codes on the web. With it, you can use the device's camera to scan QR codes and perform various actions with the obtained data. The library is also responsible for requesting permission to use the camera and turning it off after use, which facilitates device resource management.

## 💡 How to use
For a more detailed example, please check the `example` directory.

```.yaml
dependencies:  
  qrcode_reader_web: <latest_version>
```

```.html
// Add it to your project's index.html inside the "web" folder.
<script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js"></script>
```

```.dart
import 'package:qrcode_reader_web/qrcode_reader_web.dart';
```

```.dart
class _MyHomePageState extends State<MyHomePage> {
  final List<QRCodeCapture> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example App"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            QRCodeReaderSquareWidget(
              onDetect: (QRCodeCapture capture) => setState(() => list.add(capture)),
              size: 250,
            ),
            QRCodeReaderTransparentWidget(
              onDetect: (QRCodeCapture capture) => setState(() => list.add(capture)),
              targetSize: 250,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return ListTile(title: Text(list[index].raw));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Contributing
This project is open-source and we welcome contributions from all skill levels. 

## 📝 License
This project is licensed under the MIT License.

---
Pt-BR

# QR Code Reader - Web
Esta biblioteca tem como objetivo ler QR Codes na Web. Com ele, é possível utilizar a câmera do dispositivo para escanear QR codes e realizar diversas ações com os dados obtidos.<br>
A biblioteca também é responsável por pedir permissão para utilizar a câmera e desligá-la após o uso, o que facilita o gerenciamento de recursos do dispositivo.

## 💡 Como utilizar
Para um exemplo mais detalhado, confira no diretório `example`.

```.yaml
dependencies:  
  qrcode_reader_web: <latest_version>
```

````.html
// Adicione no index.html do seu projeto dentro da pasta "web".
<script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js"></script>
````

```.dart
import 'package:qrcode_reader_web/qrcode_reader_web.dart';
```

```.dart
class _MyHomePageState extends State<MyHomePage> {
  final List<QRCodeCapture> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example App"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            QRCodeReaderSquareWidget(
              onDetect: (QRCodeCapture capture) => setState(() => list.add(capture)),
              size: 250,
            ),
            QRCodeReaderTransparentWidget(
              onDetect: (QRCodeCapture capture) => setState(() => list.add(capture)),
              targetSize: 250,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return ListTile(title: Text(list[index].raw));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Contribuindo
Este projeto é de código aberto e aceitamos contribuições de todos os níveis de habilidade. 

## 📝 Licença
Este projeto esta sob a licença [MIT](./LICENSE).
