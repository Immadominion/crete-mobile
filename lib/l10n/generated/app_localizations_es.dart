// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Crete';

  @override
  String get welcome => 'Bienvenido a Crete';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Reintentar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'Aceptar';

  @override
  String get close => 'Cerrar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get add => 'Añadir';

  @override
  String get search => 'Buscar';

  @override
  String get settings => 'Configuración';

  @override
  String get profile => 'Perfil';

  @override
  String get wallet => 'Cartera';

  @override
  String get transactions => 'Transacciones';

  @override
  String get balance => 'Saldo';

  @override
  String get send => 'Enviar';

  @override
  String get receive => 'Recibir';

  @override
  String get amount => 'Cantidad';

  @override
  String get address => 'Dirección';

  @override
  String get confirm => 'Confirmar';

  @override
  String get transaction => 'Transacción';

  @override
  String get pending => 'Pendiente';

  @override
  String get completed => 'Completado';

  @override
  String get failed => 'Fallido';

  @override
  String get networkError =>
      'Error de conexión de red. Verifica tu conexión a internet e inténtalo de nuevo.';

  @override
  String get invalidAddress => 'Formato de dirección inválido';

  @override
  String get insufficientBalance => 'Saldo insuficiente';

  @override
  String get transactionFailed => 'La transacción falló. Inténtalo de nuevo.';

  @override
  String get connectWallet => 'Conectar Cartera';

  @override
  String get disconnectWallet => 'Desconectar Cartera';

  @override
  String get walletConnected => 'Cartera Conectada';

  @override
  String get walletDisconnected => 'Cartera Desconectada';

  @override
  String get noTransactions => 'No se encontraron transacciones';

  @override
  String get refresh => 'Actualizar';

  @override
  String get copy => 'Copiar';

  @override
  String get copied => 'Copiado al portapapeles';

  @override
  String get share => 'Compartir';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get done => 'Hecho';

  @override
  String get skip => 'Omitir';

  @override
  String get continueButton => 'Continuar';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get security => 'Seguridad';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get resetPassword => 'Restablecer Contraseña';

  @override
  String get enterEmail => 'Ingresa tu dirección de correo electrónico';

  @override
  String get enterPassword => 'Ingresa tu contraseña';

  @override
  String get invalidEmail => 'Por favor ingresa una dirección de correo válida';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String get accountCreated => 'Cuenta creada exitosamente';

  @override
  String get welcomeBack => '¡Bienvenido de nuevo!';

  @override
  String get solanaNetwork => 'Red Solana';

  @override
  String get mainnet => 'Red Principal';

  @override
  String get devnet => 'Red de Desarrollo';

  @override
  String get testnet => 'Red de Pruebas';

  @override
  String get blinks => 'Blinks';

  @override
  String get actionRequired => 'Acción Requerida';

  @override
  String get processingTransaction => 'Procesando transacción...';

  @override
  String get transactionSuccess => 'Transacción completada exitosamente';

  @override
  String get configurationError => 'Error de Configuración';

  @override
  String get connectionTimeout =>
      'Tiempo de conexión agotado. Inténtalo de nuevo.';

  @override
  String get unknownError =>
      'Ocurrió un error desconocido. Inténtalo de nuevo.';

  @override
  String get noInternetConnection =>
      'Sin conexión a internet. Verifica tu configuración de red.';

  @override
  String get serverError => 'Error del servidor. Inténtalo más tarde.';

  @override
  String get maintenance =>
      'La aplicación está en mantenimiento. Inténtalo más tarde.';

  @override
  String get updateRequired =>
      'Se requiere actualización de la aplicación. Actualiza para continuar.';

  @override
  String get updateAvailable =>
      'Una nueva versión está disponible. ¿Actualizar ahora?';

  @override
  String get later => 'Más tarde';

  @override
  String get update => 'Actualizar';

  @override
  String get justNow => 'Justo ahora';

  @override
  String minuteAgo(int count) {
    return 'hace $count minuto';
  }

  @override
  String minutesAgo(int count) {
    return 'hace $count minutos';
  }

  @override
  String hourAgo(int count) {
    return 'hace $count hora';
  }

  @override
  String hoursAgo(int count) {
    return 'hace $count horas';
  }

  @override
  String dayAgo(int count) {
    return 'hace $count día';
  }

  @override
  String daysAgo(int count) {
    return 'hace $count días';
  }

  @override
  String weekAgo(int count) {
    return 'hace $count semana';
  }

  @override
  String weeksAgo(int count) {
    return 'hace $count semanas';
  }

  @override
  String monthAgo(int count) {
    return 'hace $count mes';
  }

  @override
  String monthsAgo(int count) {
    return 'hace $count meses';
  }

  @override
  String yearAgo(int count) {
    return 'hace $count año';
  }

  @override
  String yearsAgo(int count) {
    return 'hace $count años';
  }

  @override
  String get yesterday => 'Ayer';

  @override
  String get today => 'Hoy';

  @override
  String get tomorrow => 'Mañana';

  @override
  String get ended => 'Terminado';

  @override
  String get remaining => 'restante';

  @override
  String get lessThanMinute => 'Menos de 1m restante';
}
