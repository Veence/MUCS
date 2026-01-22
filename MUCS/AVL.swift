//
//  BinarySearchTree.swift
//  MUCS
//
//  Created by Vincent on 18/12/2025.
//

// Range tree for connection points search

protocol TwoD {
    var x: Double { get }
    var y: Double { get }
}

enum Balance: Int {
    case left
    case right
    case balanced
}

indirect enum BSTNode<T: Comparable> {
    case root(value: T, sum: Balance, left: BSTNode<T>?, right: BSTNode<T>?)
    case leaf(parent: BSTNode<T>?, value: T)
    case node(parent: BSTNode<T>, value: T, sum: Balance, left: BSTNode<T>?, right: BSTNode<T>?)
}

class BST<T: Comparable> {
    private var root: BSTNode<T>?
    
    init(_ val: T) {
        self.root = .root(value: val, sum: .balanced, left: nil, right: nil)
    }
    
    func insert(_ value: T) {
        root = insert(root, value)
    }
    
    private func insert(_ node: BSTNode<T>?, _ value: T) -> BSTNode<T> {
        guard let node else {
            return .leaf(parent: nil, value: value)
        }
    }
}
