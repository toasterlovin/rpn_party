[![Build Status](https://travis-ci.org/toasterlovin/rpn_party.svg?branch=master)](https://travis-ci.org/toasterlovin/rpn_party)

# rpn_party

An interactive [Reverse Polish notation] (RPN) calculator for the command line,
written in Ruby.

[Reverse Polish notation]: https://en.wikipedia.org/wiki/Reverse_Polish_notation

# Installation

You can install rpn_party via [RubyGems]:

```
gem install rpn_party
```

[RubyGems]: https://rubygems.org

# Usage

To start using rpn_party, invoke it from your shell:

```
$ rpn_party
```

This will bring up a [REPL] that you can interact with:

[REPL]: https://en.wikipedia.org/wiki/Read–eval–print_loop

```
$ rpn_party
Welcome to RPNParty!
> 3 2 +
5.0
> 6 -
-1.0
> 13 *
-13.0
> -1 /
13.0
> q
Goodbye!
$
```

Supported Commands

- Values: integers (`5`), decimals (`5.3`), and negative numbers (`-3.5`)
- Operators: addition (`+`), subtraction (`-`), multiplication (`*`), and
  division (`/`)
- Exiting: `q` or `CTRL-D` return to the shell

# Architecture

There are three components to rpn_party: 
- An executable (`rpn_party`)
- A class for creating a REPL (`RPNParty::CLI`)
- A class for evaluating RPN statements (`RPNParty::Calculator`)

## rpn_party

This is a simple Ruby script that instantiates `RPNParty::CLI`, which in turn
creates a REPL for the user to interact with.

## RPNParty::CLI

This class is responsible for creating the REPL that a user interacts with when
they invoke `rpn_party` from their shell. It is conceptually simple:

1. It starts by printing a welcome message and a prompt
2. In a continuous loop, it waits for input from the user
3. If the user types `q` or `CTRL-D` it exits
4. Otherwise it passes the user input to an instance of `RPNParty::Calculator`
5. If the user input was a valid RPN expression, it prints either `nil` (if the
   stack is empty), or a list of numbers representing the contents of the stack.
6. If the user input was invalid, it prints a message describing the error and
   a prompt.

## RPNParty::Calculator

This class is responsible for taking a string of text which represents a Reverse
Polish notation expression and evaluating it to produce a result. It is
impemented as a stack:

- Values are pushed onto the top of the stack
- Operators pop values off of the top of the stack, perform a calculation, then
  push the result back onto the top of the stack
- The result is whatever number is left on the stack once all calculations are
  complete

So, given an RPN expression like `3 2 5 * +`, here is what happens:

- `3` is pushed to the stack
- `2` is pushed to the stack
- `5` is pusehd to the stack
- `2` and `5` are popped from the stack and multiplied
- `10`, the result, is pushed to the stack
- `10` and `3` are popped from the stack and added
- `13`, the result, is pushed to the stack
- The expression is done being evaluated and the result is `13`.

An error for the following cases:

- `ZeroDivisionError` is raised when attempting to divide a number by zero,
  for example `3 0 /`.
- `RPNParty::InsufficientOperandsError` is raised when attempting to evaluate
  an operator with less than 2 values on the stack, for example `3 +`.
- `RPNParty::UnrecognizedInputError` is raised when one of the arguments in an
  expression is neither a number nor one of the supported operators (`+`, `-`,
  `*`, `/`).

For a valid expression, one of the following will be returned:

  - `nil` when the stack is empty
  - `Float` when the stack has a single value
  - `Array` of `Float`s when the stack contains more than one value

# Future Considerations

- It might make sense to split `RPNParty::Calculator` and `RPNParty::CLI` into
  two separate gems, say `rpn_party` and `rpn_party_cli`. This would make it
  easier for other people to include just `RPNParty::Calculator` in gems that
  need a way to evaluate Reverse Polish notation expressions.
- The `RPNParty::CLI` tests are excellent in the sense that they are black box
  tests which verify that the program works by actually instantiating `rpn_party`
  and interacting with it just like a user would. But for this reason, they
  sometimes suffer from async timing issues. It would be nice to add a test
  helper method which intelligently retries assertions for either a set amount
  of time or for a set number of attempts. At the moment, the async timing
  issue is being addressed by sleeping the test process for (relatively) short
  periods of time to ensure that the app process has time to finish. This isn't
  that big of a deal because the test suite is relatively small, but could
  become an issue in the future.
