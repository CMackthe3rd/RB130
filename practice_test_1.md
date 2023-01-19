# PRACTICE TEST #1

1. What are closures?
  Closures are an abstract programming concept that describes the process in which a "chunk of code" can be saved, invoked, reassigned and passed around whilst still being able to access any artifacts (variables, method calls, etc.) that were in its scope at the time the closure was created. 
2. What is binding?
  Closures keep track of the environment around them via *binding*. Binding consists of the environment surrounding a closure after its creation. In esence, the closure will *bind* and drag around all artifacts in its scope as needed to function properly.
- 3. How does binding affect the scope of closures?
  Binding can seem to circumnavigate the concept of local variable scope in Ruby. We can bind a variable to a closure and allow this variable to be accessed at a scope which it wouldn't be able to be accessed in otherwise. For example:
```ruby
def a_method(some_proc)
  some_proc.call
end

value = 5
block_saved = proc { "the current value is #{value}" }

puts a_method(block_saved)
# => "the current value is 5"
```
Even though, the local variable `value` was initialized outside of the `#a_method` method, the `Proc` object referenced by `some_proc` is able to access the value of `value` by virtue of its binding. The value was binded by the `Proc` (closure) and `#a_method` is able to resolve this reference since the value of `value` is in the surrounding context/environment of the `Proc`. This means that `Proc`s bind to and drag around all of the artifacts (variables, methods, constants, etc) they need to function properly. 
An important thing to mention is that any local variables we wish to bind to a closure *must be* initialized prior to the closure being instantiated.
4. How do blocks work?
  Blocks work by defining code within curly braces "{...}" or the keywords `do` ... `end`. The `block`s themselves are passed to methods as an argument (implicitly, or explicitly) and what they do is up to the method's implementation.
5. Describe the two reasons we use blocks, use examples.
  The two main cases are:
  - To defer partial implementation of our methods to the time the methods are invoked. A simple example is the `max_by` method, which takes a block. It determines the element in a collection which has the *maximum value* but, it is up to the user to determine what they consider the *maximum value* to be. It can be the most number of vowels in a string, or the length of a string, or most appearances of a specific character. The *max* doesn't matter to the method's implementation, only to the method's user at the time of invocation.
  - To perform some sort of "before" and "after" code, known as sandwich code. Again, it is at the time of method invocation that the "before" and "after" take place. We want to run some code that takes place between two actions predetermined in the method's implementation but the *action* itself is left up to the user at the time the method is invoked.
6. When can you pass a block to a method? Why?
All methods in Ruby are capable of receiving an implicit block as an argument. The block may be ignored if the method's implementation does not `yield` to the execution of the `block` at any point in its definition. 
7. How do methods access both implicit and explicit blocks passed in?
  Implicit blocks are accessed in a method when the method's implementation includes a call to `yield` execution to the block. Explicit methods require the last argument in the list of parameters to be prepended with a unary `&` and called in the method's implementation by the `Proc#call` method. Prepending a `&` to the parameter will turn the `block` to a `proc` which can be executed when called via the `Proc#call` method.
8. What does & do when in a the method parameter?
  It attempts to turn the parameter into a `proc`. It will be ignored if the last argument passed to the method is not a `block`.
9. What is happening in the code below?
```ruby
arr = [1, 2, 3, 4, 5]

p arr.map(&:to_s) # specifically `&:to_s`
```
The argument passed to the `Array#map` method contains a symbol for the `Integer#to_s` method and is prepended by unary `&`. This tells the Ruby interperter that the symbol provided references a method which can be invoked in every element in the Array `arr` and we wish for this to happen. Ruby attempts to transform the object into a `block`. Since the method in question (`Integer#to_s`) is a method and not a `block`, Ruby then attempts to transform the method to a `proc` and then to a `block` to be executed. This only works with methods take arguments.

10. What concept does the following code demonstrate?
```ruby
def time_it
  time_before = Time.now
  yield
  time_after= Time.now
  puts "It took #{time_after - time_before} seconds."
end
```
This demonstrates one of the two popular uses for `block`s. Sandwhich code. The method `yield`s execution on line `3` to a `block` provided as an argument when the method is invoked and it outputs the time it took for the code to execute, then returns `nil`. 

11. What will be outputted from the method invocation block_method('turtle') below? Why does/doesn't it raise an error?
```ruby
def block_method(animal)
  yield(animal)
end

block_method('turtle') do |turtle, seal|
  puts "This is a #{turtle} and a #{seal}."
end
```
The output is `"This is a turtle and a  ."`. `block`s and `procs` have lenient arity. This means that the number of arguments passed to a method doesn't need to match the number of arguments which are passed to a `block`. Therefore, there are no errors raised as the block variable `turtle` points to the string `'turtle'` and the block variable `seal` points to `nil`, hence the whitespace between `'a'` and `'.'` in the outputed string.

12. What will be outputted if we add the follow code to the code above? Why?
```ruby
block_method('turtle') { puts "This is a #{animal}."}
```
This attempt raises an exception `NameError: Undefined local variable or method 'animal'`. This is due to the fact that the call to `yield` execution in the method's definition take an argument and expects a `block` which has a block local variable named `animal`.

13. What will the method call call_me output? Why?
```ruby
def call_me(some_code)
  some_code.call
end

name = "Robert"

def name
  "Joe"
end

chunk_of_code = Proc.new {puts "hi #{name}"}

call_me(chunk_of_code)
```
  The output we expect is the string "hi Robert". This is because when it comes to string interpolation in Ruby, when the interpreter finds a local variable and a method with the same names, it will prioritize the local variable.  

14. Why does the following raise an error?
```ruby
def a_method(pro)
  pro.call
end

a = 'friend'
a_method(&a)
```
The object referenced by the local variable `a` is a `String` object. When Ruby encounters this object, it raises an exception `TypeError` as the interpreter expected a `proc` object instead. 

15. How does Kernel#block_given? work?
`Kernel#block_given?` is a `Kernel` method which returns a boolean value of `True` if there is a `block` passed as an argument to a method, and `False` otherwise. It is used to define custom methods which can take an implicit block without stopping execution if a block is not present.

16. Why do we get a LocalJumpError when executing the below code? & How do we fix it so the output is hi? (2 possible ways)
```ruby
def some
  yield
end

bloc = proc { p "hi" } # do not alter

some(&bloc)
```
We get a `LocalJumpError` because the method `#some`, which takes an argument, `yield`s execution to a `block` but there is no `block` passed to the method at the time it is invoked. Instead, a `proc` was passed as an explicit argument. 

We can fix this in two ways. The first one is to prepend unary `&` to the argument to `#some` at the time of invocation *and* removing the need for arguments to be passed on to the method in its implementation: 
```ruby
def some
  yield
end

bloc = proc { p "hi" } # do not alter

some(&bloc)
# => "hi"
```
The second way is to remove the `yield` to execution in the method's implementation, and replace it with a `#call` to the `proc` represented by the method local variable `pro`:

```ruby
def some(pro)
  pro.call
end

bloc = proc { p "hi" } # do not alter

some(&bloc)
#=> "hi"
```

17. What is a test suite?
  A test suite is a collection of tests that we create which make sure our code is covered against all manners of bug inducing errors prior to our program being released.  

18. What is a test?
  A single test is a method which tests *one* part of our code by either asserting or refuting a specific expectation of our program.

19. What is an assertion?
  An assertion is a method included in MiniTest which verifies if the return value of part of a program matches the expected value. 

20. What do testing frameworks provide?


21. What are the differences of Minitest vs RSpec
  MiniTest provides a way to define tests which follow an assert-style or spec-style. RSpec uses a spec-style only.

22. What is Domain Specific Language (DSL)?
  A DSL os a higher level language built with a general purpose, typically to solve a problem within one specific domain. For example, RSpec has a domain specific to testing, whereas Rails has a domain specific to setting up web applications. 

23. What is the difference of assertion vs refutation methods?
  Assertions verify whether a return value matches an expected value whereas refutations do the opposite. They ensure a return value does *not* match a given value.

24. How does assert_equal compare its arguments?
  It tests value equality, it uses the `#==` method defined for the objects in question to verify whether they have the same values. Because it uses the `#==` method, if we wish to ensure that two objects of a custom class pass this assertion, we must define a custom `#==` method in our class. 