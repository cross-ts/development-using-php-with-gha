# What's happened?

## In GitHub Actions
```
$ phpcs
W 1 / 1 (100%)



FILE: /home/runner/work/gha-phpcs-not-worked/gha-phpcs-not-worked/src/hoge.php
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FOUND 0 ERRORS AND 2 WARNINGS AFFECTING 2 LINES
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 1 | WARNING | No PHP code was found in this file and short open tags are not allowed by this install of PHP. This file may be using short open tags but PHP does not allow them.
 3 | WARNING | Possible use of short open tags detected; found: <?
   |         |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Time: 48ms; Memory: 8MB
```

## In Docker
```
$ vendor/bin/phpcs
E 1 / 1 (100%)



FILE: /app/src/hoge.php
-----------------------------------------------------------------------------
FOUND 2 ERRORS AFFECTING 2 LINES
-----------------------------------------------------------------------------
 3 | ERROR | [x] Short PHP opening tag used; expected "<?php" but found "<?"
 4 | ERROR | [x] A closing tag is not permitted at the end of a PHP file
-----------------------------------------------------------------------------
PHPCBF CAN FIX THE 2 MARKED SNIFF VIOLATIONS AUTOMATICALLY
-----------------------------------------------------------------------------

Time: 44ms; Memory: 6MB
```
