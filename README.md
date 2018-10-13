# Yaml Revealer

**Yaml Revealer** is a vim plugin which allows you to handle the full tree structure of a Yaml key.

If you often use Yaml files, you know they are very readable at the beginning, but also that they can become a bit harder to read when becoming longer and longer… **Yaml Revealer** is here to guide you when you're lost.

![demo gif](https://user-images.githubusercontent.com/5675200/40068961-32d58f2a-586a-11e8-8db4-4da212f2f3b1.gif)

## Features

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
    >          specialKey: "Hi"

Moving to the indicated line will automatically make vim echo

    myRoot > secondChild > myVar2 > specialKey

### Search for a specific key

Typing `:call SearchYamlKey()` will display a prompt to search a specific key.

    Search for a Yaml key:

Searching for

    myVar2>specialKey

will find the concerned line.

## Installation

### Vundle Installation

Add `Plugin 'Einenlum/yaml-revealer'` to your `.vimrc`, reload your config and run a `Plugin:Install`.

## Credits

Thanks to [@PedroTroller](https://github.com/PedroTroller) for his useful help :).
