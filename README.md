Yaml Revealer
=============

**Yaml Revealer** is a vim plugin which allows you to handle the full tree structure of a Yaml key.

If you often use Yaml files, you know they are very readable at the beginning, but also that they can become a bit harder to read when becoming longer and longer… **Yaml Revealer** is here to guide you when you're lost.

Features
--------

### Reveal the full tree structure of a key

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

Typing `<Leader>yml` when you are on the last line, will make vim echo

    myRoot > secondChild > myVar2 > specialKey

### Search for a specific key

Typing `<Leader>ys` will display a prompt to search a specific key.

    Search for a Yaml key:

Searching for

    secondChild>myVar2>specialKey

will find the concerned line.

Installation
------------

### Vundle Installation

Add `Plugin 'Einenlum/yaml-revealer'` to your `.vimrc`, reload your config and run a `Plugin:Install`.

Credits
-------

Thanks to [@PedroTroller](https://github.com/PedroTroller) for his useful help :).
