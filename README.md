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
- Exiting: `q` or `CTRL-D` exit rpn_party and return to the shell

# Architecture

There are three components to rpn_party: 
- An executable (`rpn_party`)
- A class for creating a REPL (`RPNParty::CLI`)
- A class for evaluating RPN statements (`RPNParty::Calculator`)

## Executable

This is simply an executable Ruby script that creates an instance of
`RPNParty::CLI`, which creates a REPL for the user to interact with.

## RPNParty::CLI

This class is responsible for creating the REPL that a user interacts with when
they invoke `rpn_party` from their shell. It is conceptually simple:

1. It starts by printing:
  - A welcome message
  - A prompt
2. In a continuous loop, it waits for input from the user
3. If the user types `q` or `CTRL-D` it exits
4. Otherwise it passes the user input to an instance of `RPNParty::Calculator`
5. If the user input was a valid RPN expression, it prints the result:
  - `nil` if the stack is empty
  - Otherwise a list of numbers representing the contents of the stack
6. If the user input was invalid, it prints:
  - A message to the user describing the error
  - A prompt.

## RPNParty::Calculator

This class is responsible for taking a string of text which represents a Reverse
Polish notation (RPN) expression and evaluating it to produce a result. It is
impemented as a stack as follows:

- Values are pushed onto the top of the stack
- Operators pop values off of the top of the stack, perform a calculation, then
  push the result back onto the top of the stack
- The result is whatever number is left on the stack once all calculations are
  complete

So, given an RPN expression like `3 2 5 * 5 / +`, here is what happens:

1. `3` is pushed to the stack
2. `2` is pushed to the stack
3. `5` is pusehd to the stack
4. `2` and `5` are popped from the stack and multiplied
5. `10`, the result, is pushed to the stack
6. `5` is pushed to the stack
7. `10` and `5` are popped from the stack and `10` is divided by `5`
8. `2`, the result, is pushed to the stack
9. `3` and `2` are popped from the stack and added
10. `5`, the result, is pushed to the stack
11. The expression is done being evaluated and the result is `5`.

`RPNParty::Calculator` will raise errros for some common error cases:

- `ZeroDivisionError` is raised when attempting to divide a number by zero,
  for example `3 0 /`
- `RPNParty::InsufficientOperandsError` is raised when attempting to evaluate
  an operator when there are not enough values on the stack, for example
  `3 +`
- `RPNParty::UnrecognizedInputError` is raised when one of arguments in an
  expression is not either a number or one of the supported operators (`+`,
  `-`, `*`, `/`)

For a valid expression, `RPNParty::Calculator` will return one of the following:
  - `nil` when the stack is empty
  - `Float` when the stack has a single value
  - `Array` of values when the stack contains more than one value

# Future Considerations

- It might make sense to split `RPNParty::Calculator` and `RPNParty::CLI` into
  two separate gems, say `rpn_party` and `rpn_party_cli`. This would make it
  for other people to include just `RPNParty::Calculator` in gems that might
  need a way to evaluate Reverse Polish notation expressions.
- The `RPNParty::CLI` tests are excellent in the sense that they are black box
  tests which verify that the program works by actually instantiating `rpn_party`
  and interacting with it just like a user would. But for this reason, they
  sometimes suffer from async timing issues. It would be nice to add a test
  helper method which intelligently retries assertions for either a set amount
  of time or for a set number fo attempts. At the moment, the async timing
  issue is being addressed by sleeping the test process for (relatively) short
  periods of time to ensure that the app process has time to finish. This isn't
  that big of a deal because the test suite is relatively small, but could
  become an issue in the future.
