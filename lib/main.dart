import 'package:flutter/material.dart';
import 'auth.dart';
import 'cnh.dart'; // IMPORTE O CNH.DART AQUI

// Cores do gov.br
const Color corHeader = Color(0xFF021F59);
const Color corVerdeBanco = Color(0xFF008C32);
const Color corAzulBotao = Color(0xFF1351B4);
const Color corFundo = Color(0xFFf0f0f0);
const Color corTextoPrincipal = Color(0xFF333333);
const Color corTextoSecundario = Color(0xFF555555);
const Color corBorda = Color(0xFFcccccc);
const Color corLink = Color(0xFF1351B4);
const Color corErro = Color(0xFFd93025);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CNH Digital',
      theme: ThemeData(
        primaryColor: corHeader,
        scaffoldBackgroundColor: corFundo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GovBrCpfScreen(),
    );
  }
}

// TELA 1: DIGITAR CPF
class GovBrCpfScreen extends StatefulWidget {
  @override
  _GovBrCpfScreenState createState() => _GovBrCpfScreenState();
}

class _GovBrCpfScreenState extends State<GovBrCpfScreen> {
  final TextEditingController _cpfController = TextEditingController();
  bool _isLoading = false;

  void _formatarCPF(String value) {
    String cpf = value.replaceAll(RegExp(r'[^0-9]'), '');
    cpf = cpf.substring(0, 11);
    
    if (cpf.length >= 10) {
      cpf = "${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}";
    } else if (cpf.length >= 7) {
      cpf = "${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6)}";
    } else if (cpf.length >= 4) {
      cpf = "${cpf.substring(0, 3)}.${cpf.substring(3)}";
    }
    
    _cpfController.value = TextEditingValue(
      text: cpf,
      selection: TextSelection.collapsed(offset: cpf.length),
    );
  }

  void _continuar() {
    String cpfFormatado = _cpfController.text;
    String cpfSemFormato = cpfFormatado.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cpfSemFormato.length == 11) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GovBrSenhaScreen(cpf: cpfFormatado),
        ),
      );
    } else {
      _mostrarErro("CPF inválido! Por favor, insira um CPF com 11 dígitos.");
    }
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("CPF Inválido"),
        content: Text(mensagem),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: corAzulBotao)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
            _buildHeader(),
            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      color: corHeader,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          SizedBox(width: 16),
          Text(
            'Entrar com GOV.BR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 450),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Image.asset(
              'assets/govbr.png',
              width: 96,
              height: 96,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 96,
                  height: 96,
                  color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      'GOV.BR',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: corHeader,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Card de login
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identifique-se no gov.br com:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 24),
                
                // Seção CPF
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: corBorda),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            color: corLink,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Número do CPF',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Digite seu CPF para criar ou acessar sua conta gov.br',
                        style: TextStyle(
                          fontSize: 14,
                          color: corTextoSecundario,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Input CPF
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CPF',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _cpfController,
                            keyboardType: TextInputType.number,
                            onChanged: _formatarCPF,
                            decoration: InputDecoration(
                              hintText: 'Digite seu CPF',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: corBorda),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: corLink),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      
                      // Botão Continuar
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: RaisedButton(
                          color: corAzulBotao,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: _continuar,
                          child: Text(
                            'Continuar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                
                // Outras opções
                Text(
                  'Outras opções de Identificação:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 16),
                
                // Lista de opções
                Column(
                  children: [
                    _buildOpcao(
                      icon: Icons.account_balance,
                      texto: 'Login com seu banco',
                      temTag: true,
                      corTexto: corVerdeBanco,
                    ),
                    SizedBox(height: 20),
                    _buildOpcao(
                      icon: Icons.qr_code,
                      texto: 'Login com QR code',
                      temTag: false,
                    ),
                    SizedBox(height: 20),
                    _buildOpcao(
                      icon: Icons.credit_card,
                      texto: 'Seu certificado digital',
                      temTag: false,
                    ),
                    SizedBox(height: 20),
                    _buildOpcao(
                      icon: Icons.cloud,
                      texto: 'Seu certificado digital em nuvem',
                      temTag: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Links de ajuda
          SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help,
                        color: corLink,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Está com dúvidas e precisa de ajuda?',
                        style: TextStyle(
                          color: corLink,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Termo de Uso e Aviso de Privacidade',
                    style: TextStyle(
                      color: corLink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcao({IconData icon, String texto, bool temTag, Color corTexto = Colors.black}) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(
            icon,
            color: corTexto,
            size: 22,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(
                color: corTexto,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          if (temTag)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: corVerdeBanco,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Sua conta será prata',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// TELA 2: DIGITAR SENHA
class GovBrSenhaScreen extends StatefulWidget {
  final String cpf;
  
  GovBrSenhaScreen({Key key, this.cpf}) : super(key: key);

  @override
  _GovBrSenhaScreenState createState() => _GovBrSenhaScreenState();
}

class _GovBrSenhaScreenState extends State<GovBrSenhaScreen> {
  final TextEditingController _senhaController = TextEditingController();
  bool _mostrarSenha = false;
  bool _isLoading = false;
  bool _erroSenha = false;

  void _toggleSenha() {
    setState(() {
      _mostrarSenha = !_mostrarSenha;
    });
  }

  Future<void> _entrar() async {
    if (_senhaController.text.isEmpty) {
      setState(() {
        _erroSenha = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _erroSenha = false;
    });

    final result = await AuthService.login(
      widget.cpf,
      _senhaController.text,
    );

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      String nomeCompleto = result['nome_completo'] ?? 'Usuário';
      String primeiroNome = _extractFirstName(nomeCompleto);
      String cpfLimpo = widget.cpf.replaceAll(RegExp(r'[^0-9]'), '');
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userName: primeiroNome,
            userFullName: nomeCompleto,
            userCpf: cpfLimpo,
          ),
        ),
        (route) => false,
      );
    } else {
      setState(() {
        _erroSenha = true;
      });
    }
  }

  String _extractFirstName(String fullName) {
    if (fullName.isEmpty) return 'Usuário';
    List<String> names = fullName.trim().split(' ');
    String firstName = names[0];
    if (firstName.isNotEmpty) {
      return firstName[0].toUpperCase() + firstName.substring(1).toLowerCase();
    }
    return 'Usuário';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
            _buildHeader(),
            // Conteúdo principal
            Expanded(
              child: SingleChildScrollView(
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      color: corHeader,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          SizedBox(width: 16),
          Text(
            'Entrar com GOV.BR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 450),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Image.asset(
              'assets/govbr.png',
              width: 96,
              height: 96,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 96,
                  height: 96,
                  color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      'GOV.BR',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: corHeader,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Card de login
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Digite sua senha',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 24),
                
                // CPF exibido
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CPF',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.cpf ?? 'Não informado',
                      style: TextStyle(
                        fontSize: 16,
                        color: corTextoSecundario,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Input Senha
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Senha',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _erroSenha ? corErro : corBorda,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Stack(
                        children: [
                          TextField(
                            controller: _senhaController,
                            obscureText: !_mostrarSenha,
                            onChanged: (_) {
                              if (_erroSenha) {
                                setState(() {
                                  _erroSenha = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 12,
                            top: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: _toggleSenha,
                              child: Icon(
                                _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                                color: _erroSenha ? corErro : corTextoSecundario,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_erroSenha)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Erro ao autenticar. Verifique os dados e tente novamente.',
                          style: TextStyle(
                            color: corErro,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16),
                
                // Esqueci minha senha
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Esqueci minha senha',
                    style: TextStyle(
                      color: corLink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                
                // Botões Cancelar/Entrar
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlineButton(
                          borderSide: BorderSide(color: corAzulBotao),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: corAzulBotao,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: RaisedButton(
                          color: corAzulBotao,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: _isLoading ? null : _entrar,
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 2,
                                )
                              : Text(
                                  'Entrar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Link de ajuda
          SizedBox(height: 32),
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Ficou com dúvidas?',
                style: TextStyle(
                  color: corLink,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Home Screen (após login bem-sucedido)
class HomeScreen extends StatefulWidget {
  final String userName;
  final String userFullName;
  final String userCpf;

  const HomeScreen({
    Key key,
    this.userName,
    this.userFullName,
    this.userCpf,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => GovBrCpfScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      body: Container(
        child: Column(
          children: [
            _header(),
            _content(),
          ],
        ),
      ),
    );
  }

  Widget _content() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                'Olá ${widget.userName ?? "Usuário"},',
                style: TextStyle(
                  color: corHeader,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                'O que gostaria de fazer hoje?',
                style: TextStyle(color: Colors.grey, fontSize: 17),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(
                  image: 'habilitação.png',
                  text: 'Habilitação',
                  onPress: () {
                    // AGORA VAI PARA O CNH.DART REAL!
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CNH(userCpf: widget.userCpf),
                      ),
                    );
                  }),
              _item(image: 'veículos.png', text: 'Veículos', onPress: () {}),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(image: 'infrações.png', text: 'Infrações', onPress: () {}),
              _item(image: 'educação.png', text: 'Educação', onPress: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item({String image, String text, VoidCallback onPress}) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset(
              'assets/icons/' + image,
              width: MediaQuery.of(context).size.width / 3,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 100,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(color: corHeader, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Stack(
      children: [
        Container(
          color: corHeader,
          height: MediaQuery.of(context).size.height / 5,
          width: double.infinity,
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: _logout,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height / 5) - 75),
          alignment: Alignment.center,
          child: PhysicalModel(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            elevation: 10,
            child: CircleAvatar(
              radius: 52,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: corHeader,
                child: Text(
                  (widget.userName != null && widget.userName.isNotEmpty)
                      ? widget.userName[0].toUpperCase()
                      : 'U',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: (MediaQuery.of(context).size.height / 5) - 10,
            left: 100,
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}