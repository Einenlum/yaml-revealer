Yaml Revealer
=============

**Yaml Revealer** is a vim plugin which allows you to handle the full tree structure of a Yaml key.

If you often use Yaml files, you know they are very readable at the beginning, but also that they can become a bit harder to read when becoming longer and longer… **Yaml Revealer** is here to guide you in the dark.

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

Typing `<Leader>f` will display a prompt to search a specific key. The search uses regular expressions a bit like the ctrlp plugin for files.
For example, searching for

    secChd>my2>specey

will find the line `myRoot>secondChild>myVar2>specialKey`.

Installation
------------

The plugin needs you to create a `temp` directory in `~/.vim`.

### Vundle Installation

Add `Plugin 'Einenlum/yaml-revealer'` to your `.vimrc`, reload your config and run a `Plugin:Install`.

Todo
----

  * Add a flexible mapping
  * Add a flexible separator character when displaying tree structure (" > " by default).
  * ":" in the values should not be taken in account
  * Commented lines should not be taken in account
  * "Ctrlp like" (interactive search with a bottom panel)

Credits
-------

Thanks to [@PedroTroller](https://github.com/PedroTroller) for his useful help :).
