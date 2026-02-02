// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Agregar a favoritos
  public static let addToFavorites = L10n.tr("Localizable", "addToFavorites", fallback: "Agregar a favoritos")
  /// Razas de gatos
  public static let catBreedsTitle = L10n.tr("Localizable", "catBreedsTitle", fallback: "Razas de gatos")
  /// Explora razas de gatos, guarda favoritos y desbloquea favoritos ilimitados vinculando una tarjeta.
  public static let exploreCatBreedsSubtitle = L10n.tr("Localizable", "exploreCatBreedsSubtitle", fallback: "Explora razas de gatos, guarda favoritos y desbloquea favoritos ilimitados vinculando una tarjeta.")
  /// CatWallet
  public static let helloCatWallet = L10n.tr("Localizable", "helloCatWallet", fallback: "CatWallet")
  /// Sigue desplazándote
  public static let keepScrolling = L10n.tr("Localizable", "keepScrolling", fallback: "Sigue desplazándote")
  /// Esperanza de vida
  public static let lifeSpan = L10n.tr("Localizable", "lifeSpan", fallback: "Esperanza de vida")
  /// Cargando razas...
  public static let loadingBreeds = L10n.tr("Localizable", "loadingBreeds", fallback: "Cargando razas...")
  /// No se encontraron razas
  public static let noBreedsFound = L10n.tr("Localizable", "noBreedsFound", fallback: "No se encontraron razas")
  /// Sin imagen
  public static let noImage = L10n.tr("Localizable", "noImage", fallback: "Sin imagen")
  /// Origen
  public static let origin = L10n.tr("Localizable", "origin", fallback: "Origen")
  /// Quitar de favoritos
  public static let removeFromFavorites = L10n.tr("Localizable", "removeFromFavorites", fallback: "Quitar de favoritos")
  /// Reintentar
  public static let retry = L10n.tr("Localizable", "retry", fallback: "Reintentar")
  /// Ver favoritos
  public static let tapToSeeFavorites = L10n.tr("Localizable", "tapToSeeFavorites", fallback: "Ver favoritos")
  /// Temperamento
  public static let temperament = L10n.tr("Localizable", "temperament", fallback: "Temperamento")
  /// años
  public static let years = L10n.tr("Localizable", "years", fallback: "años")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
