# QR Code Reader - Web
Esta biblioteca tem como objetivo ler QR Codes na Web. Com ele, é possível utilizar a câmera do dispositivo para escanear QR codes e realizar diversas ações com os dados obtidos.<br>
A biblioteca também é responsável por pedir permissão para utilizar a câmera e desligá-la após o uso, o que facilita o gerenciamento de recursos do dispositivo.

## 💡 Como utilizar
Para um exemplo mais detalhado, confira no diretório `example`.

```.yaml
dependencies:  
  qrcode_reader_web: ^1.0.0
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
            QRCodeReaderWidget(
              onDetect: (QRCodeCapture capture) => setState(() => list.add(capture)),
              size: 350,
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
