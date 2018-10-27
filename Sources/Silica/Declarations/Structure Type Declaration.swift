// Silica © 2018 Constantino Tsarouhas

import DepthKit
import SourceKittenFramework

/// A declaration of a structure type, introduced by the `struct` keyword.
final class StructureTypeDeclaration : TypeDeclaration {
	
	// See protocol.
	static let kind = SwiftDeclarationKind.struct
	
	// See protocol.
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: DeclarationCodingKey.self)
		name = try container.decode(key: .name)
		accessibility = try container.decode(key: .accessibility)
		conformances = try container.decode(key: .inheritedTypes)
		members = try container.decode([AnyDeclaration].self, forKey: .substructure).compactMap { $0.base }
		members.bind(toParent: self)
	}
	
	// See protocol.
	let name: String
	
	// See protocol.
	let accessibility: DeclarationAccessibility
	
	// See protocol.
	let conformances: [Conformance]
	
	// See protocol.
	weak var parent: Declaration?
	
	// See protocol.
	let members: [Declaration]
	
}

extension StructureTypeDeclaration : LocalisableStringEntryProvider {
	var localisableEntries: [LocalisableEntry] {
		guard accessibility >= .internal else { return [] }
		return members.flatMap { ($0 as? LocalisableStringEntryProvider)?.localisableEntries ?? [] }
	}
}
