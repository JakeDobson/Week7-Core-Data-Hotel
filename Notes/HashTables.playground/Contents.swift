
import UIKit


                    /////// HASH TABLES \\\\\\
                    //////   12/02/16    \\\\\\



/*
 #NOTES:
 
 
 *** Hash Tables ***
 --> data structure that can map keys to values(think dictionary)
 
 - key component -- hash function
    -- when given a key, it computes an index to store the values in a backing array
 - on average, hash tables have an O(1) constant time look up
 - hash func will assign each key to unique index
    -- usually in practice you have collisions
    -- we use our good friend linked list to help us out
 
 ** Workflow **
    - when you add a value to a hash table/dictionary
        1) key passed in w/ the value to add is run through the hash function
        2) hash table creates a new bucket w/ values and keys
        3) hash table goes to the index of its backing array which matches the index returned from the hash function, and inserts the bcuket at the head of the linked list of buckets
 
 ** Collisions **
 --> whenever more than one bucket in the linked list at each index of the backing array
 
 - collisions are bad, b/c it takes the lookup time of a hash table from O(1) constant time to 
 
 ** Modulus Operator **
 --> finds remainder of division of 1 value by another
 
 - we will use the mod operator in our simple hash func
 - 10 % 3 = 1
 
 
 
 
 
 */




// implementation of hash tables


//create node using generics


class Node {
    var key: String
    var value: String
    
    var next: Node? //optional because last of linked list points to nil
    
    init(with key: String, value: String) {
        self.key = key
        self.value = value
    }
}

//create hash table

class HashTable {
    var buckets: [Node?]
    
    init(capacity: Int) {
        self.buckets = Array(repeating: nil, count: capacity)
    }
    //stringify hash table for description
    func description() -> String {
        var description = ""
        
        for (index, node) in self.buckets.enumerated() {
            description += "\(index) | Key: \(node?.key), Value: \(node?.value)"
            //get reference to head, so don't lose linked list
            var current = node
            
            while current?.next != nil { //traverse the linked list when you have collisions
                current = current?.next
                description += "|Key: \(current?.key), Value: \(current?.value)|"
            }
        }
        return description
    }
    private func indexFor(_ key: String) -> Int { //using "_" makes the parameter(key:) not required, just the value is needed
        return abs(key.hashValue) % self.buckets.count
    }
    func insert(value: String, forKey key: String) { //forKey is only for the signature when called upon later(key is used in the func
        let node = Node(with: key, value: value)
        
        let index = indexFor(key)

        
        if self.buckets[index] == nil {
            self.buckets[index] = node
            return
        }
        var currentNode = self.buckets[index] //set currentNode as the head of linked list
        
            
            while currentNode?.next != nil {
                if currentNode?.key == key {
                    node.next = currentNode?.next
                    break
                }
                currentNode = currentNode?.next //value on right goes into value on left
            }
            currentNode?.next = node //node is now the last node of the linked list
        }
        self.buckets[index] = node //inserting at index 0, because there was no collision
    }
}


var hashTable = HashTable(capacity: 5)

hashTable.insert(value: "Person", forKey: "Virginia")

hashTable.description()


//






