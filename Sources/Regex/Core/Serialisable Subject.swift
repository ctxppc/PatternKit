// PatternKit © 2017 Constantino Tsarouhas

public protocol SerialisableSubject : BidirectionalCollection where Element : Equatable {
	
	associatedtype SymbolCollection : Collection where SymbolCollection.Element : Symbol
	
	// TODO
	
}
