Yaml Revealer
=============

**Yaml Revealer** is a vim plugin which allows you to reveal the full tree structure of a Yaml key.

If you often use Yaml files, you know they are very readable at the beginning, but also that they can become a bit harder to read when becoming longer and longer… **Yaml Revealer** is here to guide you when you're lost.

Example
-------

    myRoot:
        firstChild:
            myVar: "foo"
        secondChild:
            myVar:
               foo: "foo"
            myVar2:
               foo: "foo"
               bar: "bar"
               specialKey: "Hi"

Typing `<Leader>yml` on your keyboard when you are on the last line, will make vim echo

    myRoot > secondChild > myVar2 > specialKey

Installation
------------

### Vundle Installation

Add `Plugin 'Einenlum/yaml-revealer'` to your `.vimrc`, reload your config and run a `Plugin:Install`.

Credits
-------

Thanks to [@PedroTroller](https://github.com/PedroTroller) for his very useful help :).
