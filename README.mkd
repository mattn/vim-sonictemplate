# sonictemplete-vim

Easy and high speed coding method.

## Template Completion

![](https://raw.githubusercontent.com/mattn/sonictemplate-vim/master/screenshot1.gif)

## Postfix Completion

![](https://raw.githubusercontent.com/mattn/sonictemplate-vim/master/screenshot2.gif)

## Basic Usage

Open new file

```sh
vim foo.pl
```

```vim
:Template <tab>
```

Then you can select `package` or `script` for perl filetype.

```vim
:Template package
:Template script
```

Type `<enter>` in `script`, you can see following.

```perl
use strict;
use warnings
use utf8;

_
```

And cursor is in `_`. If you open `lib/Foo.pm`, and type `<enter>` in `package`.  You get following.

```perl
package Foo;
use strict;
use warnings
use utf8;

_

1
```


If you open C++ file, you can select `main` for C.

## License

MIT

## Author

Yasuhiro Matsumoto `<mattn.jp@gmail.com>`

