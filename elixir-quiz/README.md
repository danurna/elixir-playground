# Elixir Quiz

## FizzBuzz
> Source: http://elixirquiz.github.io/2014-08-11-fizzbuzz.html

### Description

The FizzBuzz problem is fairly straight forward.

> Print the numbers from 1 to 100, replacing multiples of 3 with the word Fizz and multiples of 5 with the word Buzz. For numbers that are divisible by 3 and 5, replace the number with the word FizzBuzz.

So for example, 1 to 15 would look like:

> 1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz

### Solution
See [fizzbuzz/code.exs](fizzbuzz/code.exs)

## Run Length Encoding
> Source: http://elixirquiz.github.io/2014-08-16-run-length-encoding.html

### Description

Create a program that takes a single string as input, and returns the run length encoded value.

> Given a string of uppercase characters in the range A-Z, replace runs of sequential characters with a single instance of that value preceded by the number of items in the run.

For example, if would take the sequence JJJTTWPPMMMMYYYYYYYYYVVVVVV the output would look like:

> 3J2T1W2P4M9Y6V

### Solution
See [run_length_encoding/code.exs](run_length_encoding/code.exs)
