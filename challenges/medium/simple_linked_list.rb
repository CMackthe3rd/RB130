=begin

Write a simple linked list implementation. The linked list is a fundamental data structure in computer science, often used in the implementation of other data structures.

The simplest kind of linked list is a singly linked list. Each element in the list contains data and a "next" field pointing to the next element in the list of elements. This variant of linked lists is often used to represent sequences or push-down stacks (also called a LIFO stack; Last In, First Out).

Let's create a singly linked list whose elements may contain a range of data such as the numbers 1-10. Provide methods to reverse the linked list and convert a linked list to and from an array.


# Problem:

# Create two classes, one is a Single Linked List which is used to collect and provide information on data. This data is comprised of the `Element`s of the second class, which can be any type of data provided to this class.

# Examples: See test cases

# Data Structure:
# - Class: Single Linked List ( should it inherit from Array? )
#     - Arrays
#     - Objects of the `Element` class
#   Methods:
#   - `initialize` -> construct an empty array.
#   - do I need `attr_*` for anything??

#   - `#peek` -> returns the `datum` of the element at the top of the stack
#   - `#from_a` -> creates a new simple linked list from a given array argument
#   - `#push` -> basically array unshift.
#   - `#to_a` -> returns the list as a new array object (not a singlelist obj)
#   - `#head` -> returns the element at the top of the stack.
#   - `#pop` -> returns the head and makes head.next the new_head.
#   - `#size` -> returns the integer value of the number of elements from `head` to end of list.
#   - `#empty?` -> returns true if the head of stack is not an `Element`, false otherwise

# - Class: Element
#     - Any object type.
#     - Arrays
#   Methods: 
#     - inititalize -> Takes two arguments. Current element (@datum) and *POSSIBLE* `next` element (@next)
#     - #datum: returns `self` (attr* ?)
#     - `#tail?` -> returns boolean stating True if @next is truthy, otherwise false. 
#     - `#next` -> returns the @next (attr_* ?)

# Algorithm:

# Class: `Element`

# - define constructor with two arguments, assign to ivars @datum and @next.
#     - @next defaults to nil.
# - define attr_reader for @datum and accessor for @next
# - define instance method `#tail?` which returns true if @next is nil.

# Class: `SimpleLinkedList`

# - define constructor which does not take an argument.
#   - constructor initializes the ivar @head to nil 
# - define attr_reader for @head.
# - define `#push` instance method - it takes an argument. Needs to:
#   - check if current @head is nil:
#     - If nil: Assigns the @head to a new Element object with a @datum of given argument. 
#     - If not nil: Assigns the @head to a new Element with @datum of given argument and @next of current @head.
#     returns @head.
# - define `#pop` method. Does not take an arg, does the following:
#   - keeps track of the current @head to be removed. 
#   - assigns the new @head to the current Element's `next` value.
#   - returns the @datum of the old_head.

# - define instance method `#peek`. It needs to do the following:
#   - return the @datum of the @head element object. If no @head element exists, returns nil.

# - define class method `#from_a`. Receives an argument in the form of an array, it needs to:
#   - instantiate a new SimpleLinkedList object. -> new_list
#   - if argument is nil, returns new_list
#   - iterate through each element in the array given in REVERSE ORDER and:
#     - using the instance method `push`, `push` es each element into the new_list instantiated in step 1.
#   - returns the new_list

# - define instance method `#size`:
#   - returns the @list size in integer form.
#   - initialize local method variable -> size = 0
#   - sets a local current_element to the value of @head.
#   - while the current_element is not nil 
#     - adds + 1 to size
#     - sets current_element to the next value
#   - Returns size.

# - define instance method `to_a`:
#   - initialize a new_array.
#   - initialize local current_element to @head
#   - while current_element is not nil:
#     - appends the datum of current element to new_array
#     - sets the current element to the next value
#   returns new_array.

# - define instance method `reverse`:
#   - returns a new SimpleLinkedList from an array, which is the current list to array in reverse.

# - define instance method `#empty?`
#   - returns true if the @list does not contain any `element` objects at the head of the @list.
=end

class Element
  attr_reader :datum
  attr_accessor :next

  def initialize(datum, next_elem = nil)
    @datum = datum
    @next = next_elem
  end

  def tail?
    @next.nil?
  end
end

class SimpleLinkedList
  attr_reader :head

  def initialize
    @head = nil
  end

  def push(value)
    @head = @head.nil? ? Element.new(value) : Element.new(value, head)
    @head
  end

  def pop
    old_head = @head
    @head = @head.next
    old_head.datum
  end

  def peek
    return @head.datum unless @head.nil?

    nil
  end

  def self.from_a(array)
    new_list = SimpleLinkedList.new

    return new_list unless array

    array.reverse.each do |data|
      new_list.push(data)
    end
    new_list
  end

  def to_a
    new_array = []

    current_elem = @head
    while current_elem
      new_array << current_elem.datum
      current_elem = current_elem.next
    end
    new_array
  end

  def size
    size = 0
    current_elem = @head
    while current_elem
      size += 1
      current_elem = current_elem.next
    end
    size
  end

  def empty?
    @head.nil?
  end

  def reverse
    SimpleLinkedList.from_a(to_a.reverse)
  end

end
