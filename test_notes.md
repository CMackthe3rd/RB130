# Blocks

  - Closures, binding, and scope
  - How blocks work, and when we want to use them.
  - Blocks and variable scope
  - Write methods that use blocks and procs
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

# Closures

A closure in Ruby can be defined as a "chunk of code" which can be saved to be executed at a later time. This code is capable of binding variables and methods to form an "enclosure" (hence the name) around them so that they can be referenced when the code is executed later. 

Ruby deals with closures in the form of `blocks`, `procs` and `lambdas`. Unlike `procs` and `lambdas`, `blocks` cannot be saved to variables and passed around, however, we can still think of them as a closure since they can "enclose" variables and methods within their scope and mutate any data (depending on our method's implementation).

# Binding

Let's use a simple example of a closure we should all be familiar with:

```ruby
results = []

10.times do |int|
  results << int
end
```

In the example above, the `block`, referring to the "chunk of code" written between the `do` and `end` keywords, allow the user to make changes to the local variable `results` initialized on line `1` by virtue of its **binding**. In this simple example, the **binding** is established when the `block` is passed as an argument to the `Integer#times` method and the `results` local variable is referenced in the `block`'s definition. This action forms a closure by binding the local variable `results` to the `block` passed as the argument to `10`. 

# Scope

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
# --------CLOSURE------------|
  counter = 0  #|-> binding  |
               #v            |
  Proc.new { counter += 1 } #|
# ---------------------------|
end
```
**A very rudumentary representation of the closure and bindings**




