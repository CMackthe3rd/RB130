# Blocks

  - Closures, binding, and scope
  - How blocks work, and when we want to use them.
  - Write methods that use blocks and procs
  - Blocks and variable scope
  - Understand that methods and blocks can return chunks of code (closures)
  - Methods with an explicit block parameter
  - Arguments and return values with blocks
  - When can you pass a block to a method
  - &:symbol
  - Arity of blocks and methods

# Testing With Minitest

  - Testing terminology
  - Minitest vs. RSpec
  - SEAT approach
  - Assertions

# Core Tools/Packaging Code

  - Purpose of core tools
  - Gemfiles


# Closures, binding, and scope

## Closures

A closure in Ruby can be defined as a "chunk of code" which can be saved to be executed at a later time. This code is capable of binding variables and methods to form an "enclosure" (hence the name) around them so that they can be referenced when the code is executed later. 

Ruby deals with closures in the form of `blocks`, `procs` and `lambdas`. Unlike `procs` and `lambdas`, `blocks` cannot be saved to variables and passed around, however, we can still think of them as a closure since they can "enclose" variables and methods within their scope and mutate any data (depending on our method's implementation).

## Binding

Let's use a simple example of a closure we should all be familiar with:

```ruby
results = []

10.times do |int|
  results << int
end
```

In the example above, the `block`, referring to the "chunk of code" written between the `do` and `end` keywords, allow the user to make changes to the local variable `results` initialized on line `1` by virtue of its **binding**. In this simple example, the **binding** is established when the `block` is passed as an argument to the `Integer#times` method and the `results` local variable is referenced in the `block`'s definition. This action forms a closure by binding the local variable `results` to the `block` passed as the argument to `10`. 

## Scope

Since we are familiar with local variable scope, let's look at an example that seemingly defies this scoping rule:

```ruby
def simple_counter
  counter = 0

  Proc.new { counter += 1 }
end
```

In this example, we have defined a custom method, `#simple_counter` in which we initialize a method local variable `counter` and instantiate a new `Proc` object and pass it a `block` as its argumetn where we increase the value of `counter` by `1`. 

Since, unlike standard `blocks`, `Procs` are objects, we can expect that our custom method's return value is the `Proc` object instantiated in the last line of code in our custom `#simple_counter` method. 

Now, let's see how we can defy the scoping rules we're used to:

```ruby
test1 = simple_counter
p test1.call # => 1
p test1.call # => 2
p test1.call # => 3
```

Since the return of our `#simple_method` is a `Proc` object, we can invoke methods of this object's class, as is the case with the `Proc#call` method. So what happened here? Why is `1`, then `2`, then `3` the return value of subsequent calls to this method?

This is answered by looking at how our custom method works. When we instantiate the `Proc` object on our method, this allows us to reference the "chunk of code" in the `block` passed as argument to the `Proc` by assigning it to a local variable, which we did when we initialized `test1` to the return value of the `#simple_counter` method.

So, let's look back at the body of our method and the `call`s to `Proc` and do a full breakdown:

```ruby
def simple_counter
  counter = 0

  Proc.new { counter += 1 }
end

test1 = simple_counter
p test1.call      # => 1
p test1.call      # => 2
p test1.call      # => 3
```
- We initialize a local variable `test1` to the return value of a method `#simple_counter`
- In the method definition of `#simple_counter`:
  - We initialize a method local variable `counter`
  - We instantiate a new `Proc` object and pass a `block` as its argument.
    - In the `block` argument to `Proc`, we increment the value of `counter` by `1`
- We invoke the `#call` method (An instance method of the `Proc` class) on the object referenced by local variable `test1`. This invocation returns `1`, and subsequent calls continue to increment the value.

This, seemingly, circumvents our notion of local variable and method variable scope. We are able to access and reassign the value of method local variable `counter` with every subsequent call to the `Proc#call` method. The `Proc` object has formed a **closure** by binding the value referenced by `counter` when it was referenced in the `block` passed to the `Proc`. This **closure** has allowed us to reference a variable which would have been out of scope otherwise.

```ruby
def simple_counter
# --------CLOSURE------------+
  counter = 0  #+-> binding  |
               #v            |
  Proc.new { counter += 1 } #|
# ---------------------------+
end
```
**A very rudumentary representation of the closure and bindings**

# How blocks work, and when we want to use them.

Let's look at a familiar method first. `Array#each` as an example:

```ruby
[1, 2, 3].each do |num|
  puts num
end

# or

[1, 2, 3].each { |num| puts num }
```
Where the object which receives the method is the array:
```ruby
[1, 2, 3]
```
The method being invoked is the `Array#each` method:
```ruby
.each
```
The block is:
```ruby
do |num|
  puts num
end
#or
{ |num| puts num }
```

As illustrated in our example, blocks are passed to methods as their arguments. Basically, our `Array#each` method is receiving the `block` `{ |num| puts num }` as its argument.

All methods in Ruby are capable of receiving a `block` as an argument implicitly. But not all methods execute the block. For example:

```ruby
a = 'some string'

puts a
#=> 'some string'

puts a do
  puts 'other string'
end
#=> 'some string'
```
As we can see in the example above, we're able to pass a `block` as an argument to the `String#puts` method, but the `block` is completely ignored. 

This is due to the fact that the `puts` method does not implement a way to execute a `block` that is passed on as an argument.

Defining methods to receive a `block` as an argument allows flexibility to the user as it leaves a part of the decision making on what we want the method to return at the time of method invocation. Take, for example, the `min_by` method. `min_by`, which takes a block, returns the minimum value in a collection, but the minimum value is dictated by the code defined inside the `block`. It could be the length of a string in a collection, or the number of times a specific letter is present in a string. The important part is that it doesn't matter what the *minimum value* is when the method is defined. The *minimum value* is only important at the time the method is invoked.

**An example of the `min_by` method:**
```ruby
collection = %w[aaa abcc abbcd abbbc]

p collection.min_by { |word| word.count('ab') } #=> 'abcc'

p collection.min_by { |word| word.length } #=> 'aaa'
```
Armed with this knowledge, we can have fun constructing our own methods which take an implicit `block`. But, how do we ensure that the methods we define are able to recognize and execute the given `block`?

# Write methods that use blocks and procs

There are several ways in which we can define methods which can take a block. As we've discussed, in Ruby, all methods (custom or built-in) are able to take a block as an implicit argument which is not tied to the number of arguments which are required by the method. For example:

```ruby
def some_method
  puts "hello!"
end

def some_other_method(str)
  puts str
end

some_method { 'some other string' }
# => 'hello!'
some_other_method('hi!') { 'some other string' }
# => 'hi!'

```
As we know, the custom methods defined above are able to take an implicit block as an argument. This block does not count as an argument *required* by the method. If we'd tried to call the `#some_other_method` method without passing an argument, we'd still get an `ArgumentError` even though we passed a block.

```ruby
some_other_method { 'take this as an argument please?' }
# => ArgumentError: wrong number of arguments (given 0, expected 1)
```
However, as we learned before, our methods do not implement a way to execute the blocks passed to it. So, how do we acomplish that?

## Using `Yield`

In order for any method to take into account a block passed as an argument, the method's implementation must include a call to `yield`. `yield` is a keyword which allows our methods to pass on the execution of code to a block which has been provided as an argument. For example, let us redefine our `#some_method` method from earlier:
```ruby
def some_method
  puts "hello from the method!"
  yield
end

some_method { puts 'hello from the block!' }
#=> 'hello from the method!'
#=> 'hello from the block!'
#=> nil
```
Yay! Our method is able to `yield` code execution to the block that was passed on implicitly! Now, what would happen if we *didn't* pass on the block? 
```ruby
some_method
#=> LocalJumpError: no block given (yield)
```
Uh-oh... Now our implicit `block` is no longer optional. How can we then define a method which still maintains the ability to leave the use of a `block` at the user's discretion? Well, Ruby has an answer for that as well:

## `Kernel#block_given?`

Ruby provides a `Kernel` class instance method called `block_given?` which checks for the existence of a block and returns a `boolean`. We can use the return value of the `block_given?` method by making use of a conditional statement which `yield`s execution to the block should there be one.

Now, let's further modify our `#some_method` so that we can still leave the use of a block up to the user:
```ruby
def some_method
  puts "Hello from the method!"
  yield if block_given?
end

some_method 
#=> "Hello from the method!"
#=> nil
some_method {puts "Now, we yield to the block!"}
#=> "Hello from the method!"
#=> "Now, we yield to the block!"
#=> nil
```
Now we're talking! Our method is capable of taking an optional block as an argument, and `yield`s execution of that block when the `#block_given?` method evaluates to true. 

One important thing to understand is that when we use the `yield` keyword, our code's execution jumps from the line where the `yield` is encountered *to* the position in the code where the `block` is defined.

**Example of code execution**:
```ruby
def yield_execution_order
  puts "Hello from the method! I come first!"
  puts "Then I come second!"
  yield if block_given?
  puts "Then I come last!"
end

yield_execution_order do 
  puts "I come third if there's a block!"
  puts "And I come fourth if there's a block!"
end
#=> Hello from the method! I come first!
#=> Then I come second!
#=> I come third if there's a block!
#=> And I come fourth if there's a block!
#=> Then I come last!
#=> nil
```
So, as we see from this example. Execution of the code jumps to the `block` once the `yield` keyword is encountered. Once the `block` execution ends, the code continues to run where it left off in the `#yield_execution_order` method. 

