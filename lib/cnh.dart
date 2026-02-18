import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'auth.dart';

class CNH extends StatefulWidget {
  final String userCpf;
  
  CNH({Key key, this.userCpf}) : super(key: key);
  
  @override
  _CNHState createState() => _CNHState();
}

class _CNHState extends State<CNH> with TickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  
  List<String> _imageUrls = [];
  bool _loadingImages = true;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
    
    _loadCNHImages();
  }
  
  Future<void> _loadCNHImages() async {
    setState(() => _loadingImages = true);
    
    try {
      final urls = await AuthService.getCNHImages(widget.userCpf);
      setState(() {
        _imageUrls = urls;
        _loadingImages = false;
      });
    } catch (e) {
      print('Erro ao carregar imagens: $e');
      setState(() => _loadingImages = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      appBar: AppBar(
        backgroundColor: Color(0xFF021F59),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habilitação',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            Text(
              'Atualizada em: ' +
                  DateFormat('dd/MM/yyyy - HH:mm:ss').format(DateTime.now()),
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
            ),
          ],
        ),
      ),
      body: _loadingImages ? _loadingWidget() : _body(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF021F59),
        child: Icon(
          MdiIcons.dotsVertical,
          size: 32,
        ),
        onPressed: () {},
      ),
    );
  }
  
  Widget _loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF021F59)),
          ),
          SizedBox(height: 20),
          Text(
            'Carregando CNH...',
            style: TextStyle(
              color: Color(0xFF021F59),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _QRInfo(),
        Divider(thickness: 2),
        _Screens(),
        _Steps(),
        _Options(),
      ],
    );
  }

  Widget _QRInfo() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(color: Color(0xFF021F59), fontSize: 15),
          children: [
            TextSpan(text: 'Verifique autenticidade do QR Code com o app '),
            TextSpan(
              text: 'Vio',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Screens() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _Front(),
          _Back(),
          _QRCode(),
          _Final(),
        ],
      ),
    );
  }

  Widget _Front() {
    return _imageUrls.length > 0
        ? Container(
            margin: EdgeInsets.only(bottom: 40),
            alignment: Alignment.center,
            child: Image.network(
              _imageUrls[0], // img1.png
              width: double.infinity,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF021F59)),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Erro ao carregar frente da CNH',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      color: Color(0xFF021F59),
                      child: Text(
                        'Tentar novamente',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _loadCNHImages,
                    ),
                  ],
                );
              },
            ),
          )
        : _errorWidget('Frente da CNH não disponível');
  }

  Widget _Back() {
    return _imageUrls.length > 1
        ? Container(
            margin: EdgeInsets.only(bottom: 40),
            alignment: Alignment.center,
            child: Image.network(
              _imageUrls[1], // img2.png
              width: double.infinity,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF021F59)),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _errorWidget('Verso da CNH não disponível');
              },
            ),
          )
        : _errorWidget('Verso da CNH não disponível');
  }

  Widget _QRCode() {
    return _imageUrls.length > 2
        ? Container(
            margin: EdgeInsets.only(bottom: 40),
            alignment: Alignment.center,
            child: Image.network(
              _imageUrls[2], // qrimg5.png
              width: double.infinity,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF021F59)),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _errorWidget('QR Code não disponível');
              },
            ),
          )
        : _errorWidget('QR Code não disponível');
  }

  Widget _Final() {
    return _imageUrls.length > 3
        ? Container(
            margin: EdgeInsets.only(bottom: 40),
            alignment: Alignment.center,
            child: Image.network(
              _imageUrls[3], // img3.png
              width: double.infinity,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF021F59)),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _errorWidget('Documento adicional não disponível');
              },
            ),
          )
        : _errorWidget('Documento adicional não disponível');
  }
  
  Widget _errorWidget(String message) {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            color: Colors.grey,
            size: 60,
          ),
          SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 10),
          RaisedButton(
            color: Color(0xFF021F59),
            child: Text(
              'Recarregar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _loadCNHImages,
          ),
        ],
      ),
    );
  }

  Widget _Steps() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Container(
            margin: EdgeInsets.all(4),
            width: _currentIndex == index ? 10 : 6,
            height: _currentIndex == index ? 10 : 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: _currentIndex == index ? Colors.blue : Colors.black,
            ),
          );
        }),
      ),
    );
  }

  Widget _Options() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Button(
            icon: MdiIcons.cardAccountDetails,
            text: 'Histórico da CNH',
            onPressed: () {},
          ),
          _Button(
            icon: MdiIcons.delete,
            text: 'Remover',
            onPressed: () {},
          ),
          _Button(
            icon: MdiIcons.fileExport,
            text: 'Exportar',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _Button({IconData icon, String text, VoidCallback onPressed}) {
    return Container(
      margin: EdgeInsets.only(left: 7, bottom: 7),
      width: MediaQuery.of(context).size.width * .35,
      height: 70,
      child: RaisedButton(
        color: Color(0xFF1351B4),
        textColor: Colors.white,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
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