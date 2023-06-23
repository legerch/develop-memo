**Table of contents:**
- [1. Introduction](#1-introduction)
- [2. Variables assignments](#2-variables-assignments)
  - [2.1. List](#21-list)
  - [2.2. Assign details](#22-assign-details)
- [3. Directives](#3-directives)
- [4. Built-in Functions](#4-built-in-functions)
- [5. Automatic Variables](#5-automatic-variables)
- [6. Special Variables](#6-special-variables)
  - [6.1. List](#61-list)
  - [6.2. Special vars details](#62-special-vars-details)
    - [6.2.1. `DEFAULT_GOAL`](#621-default_goal)
- [7. Ressources](#7-ressources)


# 1. Introduction

This **GNU Make cheatsheet** is based on [GCC Quick Reference][doc-make-quick-refs]

# 2. Variables assignments
## 2.1. List

| Assignment | Description |
|:-|:-|
| VARIABLE = value | **Recursive assignment:** Evaluated everytime the variable is encountered in the code (this behaviour is also called **expand**) |
| VARIABLE := value | **Simple assignment:** Evaluated only once, when the variable is defined |
| VARIABLE ?= value | **Conditional assignment:** Assign value to variable only if it does not have a value |
| VARIABLE += value | **Append assignment:** Appending the supplied value to the existing value (or setting to that value if the variable didn't exist) |

## 2.2. Assign details

To complete difference details between `=` and `:=` assignments, we can use this example (thanks to [this thread][thread-so-makefile-differences]):
```make
DATE_EXEC   :=  $(shell date)   # Date is executed once
DATE_EXPAND =   $(shell date)   # Date will be expanded

test-exec:
    @echo $(DATE_EXEC)
    $(shell sleep 2)
    @echo $(DATE_EXEC)

test-expand:
    @echo $(DATE_EXPAND)
    $(shell sleep 2)
    @echo $(DATE_EXPAND)
```

Then, running `make test-exec` will produce:
```shell
lun. 22 mai 2023 13:33:33 CEST
lun. 22 mai 2023 13:33:33 CEST
```

And running `make test-expand` will produce:
```shell
lun. 22 mai 2023 13:33:33 CEST
lun. 22 mai 2023 13:33:35 CEST
```

So `:=` must be used by default (to limit uneeded overhead of re-running the same assignments multiples times), `=` feature will be used for specific cases.

# 3. Directives

| Directive | Description |
|:-|:-|
| `ifdef variable` <br/> `ifndef variable` <br/> `ifeq (a,b)` <br/> `ifeq "a" "b"` <br/> `ifeq 'a' 'b'` <br/> `ifneq (a,b)` <br/> `ifneq "a" "b"` <br/> `ifneq 'a' 'b'` <br/> `else` <br/> `endif`| Conditionally evaluate part of the makefile |
| `include file` <br/> `-include file` <br/> `sinclude file` | Include another makefile |
| `override variable-assignment`  | Define a variable, overriding any previous definition, even one from the command line |
| `export`                        | Tell make to export all variables to child processes by default |
| `export variable` <br/> `export variable-assignment` <br/> `unexport variable`| Tell make whether or not to export a particular variable to child processes |
| `private variable-assignment`   | Do not allow this variable assignment to be inherited by prerequisites |
| `vpath pattern path`            | Specify a search path for files matching a '%' pattern |
| `vpath pattern`                 | Remove all search paths previously specified for pattern |
| `vpath`                         | Remove all search paths previously specified in any vpath directive |

# 4. Built-in Functions

| Function | Description |
|:-|:-|
| `$(subst from,to,text)`               | Replace `from` with `to` in `text` |
| `$(patsubst pattern,replacement,text)`| Replace words matching `pattern` with `replacement` in `text` |
| `$(strip string)`                     | Remove excess whitespace characters from `string` |
| `$(findstring find,text)`             | Locate find in `text` |
| `$(filter pattern…,text)`             | Select words in `text` that match one of the `pattern` words |
| `$(filter-out pattern…,text)`         | Select words in `text` that do not match any of the `pattern` words |
| `$(sort list)`                        | Sort the words in `list` lexicographically, removing duplicates |
| `$(word n,text)`                      | Extract the `n`-th word (one-origin) of `text` |
| `$(words text)`                       | Count the number of words in `text` |
| `$(wordlist s,e,text)`                | Returns the list of words in `text` from `s` to `e` |
| `$(firstword names…)`                 | Extract the first word of `names` |
| `$(lastword names…)`                  | Extract the last word of `names` |
| `$(dir names…)`                       | Extract the directory part of each file name |
| `$(notdir names…)`                    | Extract the non-directory part of each file name |
| `$(suffix names…)`                    | Extract the suffix (the last '.' and following characters) of each file name |
| `$(basename names…)`                  | Extract the base name (name without suffix) of each file name |
| `$(addsuffix suffix,names…)`          | Append `suffix` to each word in `names` |
| `$(addprefix prefix,names…)`          | Prepend `prefix` to each word in `names` |
| `$(join list1,list2)`                 | Join two parallel lists of words |
| `$(wildcard pattern…)`                | Find file names matching a shell file name pattern (_not_ a '%' pattern) |
| `$(realpath names…)`                  | For each file name in `names`, expand to an absolute name that does not contain any ., .., nor symlinks |
| `$(abspath names…)`                   | For each file name in `names`, expand to an absolute name that does not contain any . or .. components, but preserves symlinks |
| `$(error text…)`                      | When this function is evaluated, make generates a fatal error with the message `text` |
| `$(warning text…)`                    | When this function is evaluated, make generates a warning with the message `text` |
| `$(shell command)`                    | Execute a shell command and return its output |
| `$(origin variable)`                  | Return a string describing how the make variable `variable` was defined |
| `$(flavor variable)`                  | Return a string describing the flavor of the make variable `variable` |
| `$(foreach var,words,text)`           | Evaluate `text` with `var` bound to each word in `words`, and concatenate the results |
| `$(if cond,then-part[,else-part])`    | Evaluate `cond`; if it’s non-empty substitute the expansion of the `then-part` otherwise substitute the expansion of the `else-part` |
| `$(or cond1[,cond2[,cond3…]])`        | Evaluate `condN` one at a time; substitute the first non-empty expansion. If all expansions are empty, substitute the empty string |
| `$(and cond1[,cond2[,cond3…]])`       | Evaluate `condN` one at a time; if any results in empty string substitute the empty string. Otherwise substitute the expansion of the last `condN` |
| `$(call var,param,…)`                 | Evaluate the variable `var` replacing any references to `$(1)`, `$(2)` with the first, second, etc. param values |
| `$(eval text)`                        | Evaluate `text` then read the results as makefile commands; expands to the empty string |
| `$(file op filename,text)`            | Expand the arguments, then open the file `filename` using mode `op` and write `text` to that file |
| `$(value var)`                        | Evaluates to the contents of the variable `var`, with no expansion performed on it |

# 5. Automatic Variables

| Variable | Description |
|:-|:-|
|`$@`                   | The file name of the target |
|`$%`                   | The target member name, when the target is an archive member |
|`$<`                   | The name of the first prerequisite |
|`$?`                   | The names of all the prerequisites newer than the target, with spaces between them. For prerequisites which are archive members, only the named member is used (see Archives) |
|`$^` <br/> `$+`        | The names of all the prerequisites, with spaces between them. For prerequisites which are archive members, only the named member is used (see Archives). The value of $^ omits duplicate prerequisites, while $+ retains them and preserves their order |
|`$*`                   |The stem with which an implicit rule matches (see How Patterns Match) |
|`$(@D)` <br/> `$(@F)`  | The directory part and the file-within-directory part of `$@` |
|`$(*D)` <br/> `$(*F)`  | The directory part and the file-within-directory part of `$*` |
|`$(%D)` <br/> `$(%F)`  | The directory part and the file-within-directory part of `$%` |
|`$(<D)` <br/> `$(<F)`  | The directory part and the file-within-directory part of `$<` |
|`$(^D)` <br/> `$(^F)`  | The directory part and the file-within-directory part of `$^` |
|`$(+D)` <br/> `$(+F)`  | The directory part and the file-within-directory part of `$+` |
|`$(?D)` <br/> `$(?F)`  | The directory part and the file-within-directory part of `$?` |


# 6. Special Variables
## 6.1. List

| Variables | Description |
|:-|:-|
| `MAKEFILES`        | Makefiles to be read on every invocation of make |
| `VPATH`            | Directory search path for files not found in the current directory |
| `SHELL`            | The name of the system default command interpreter, usually `/bin/sh` |
| `MAKESHELL`        | The name of the command interpreter that is to be used by make, taking precedence over `SHELL` (MS-DOS only) |
| `MAKE`             | The name with which make was invoked (using this variable in recipes has special meaning) |
| `MAKE_VERSION`     | The built-in variable `MAKE_VERSION` expands to the version number of the GNU make program |
| `MAKE_HOST`        | The built-in variable `MAKE_HOST` expands to a string representing the host that GNU make was built to run on |
| `MAKELEVEL`        | The number of levels of recursion (sub-makes) |
| `MAKEFLAGS`        | The flags given to make. You can set this in the environment or a makefile to set flags.  It is _never_ appropriate to use MAKEFLAGS directly in a recipe line: its contents may not be quoted correctly for use in the shell. Always allow recursive make’s to obtain these values through the environment from its parent |
| `GNUMAKEFLAGS`     | Other flags parsed by make. You can set this in the environment or a makefile to set make command-line flags. GNU make never sets this variable itself. This variable is only needed if you’d like to set GNU make-specific flags in a POSIX-compliant makefile. This variable will be seen by GNU make and ignored by other make implementations. It’s not needed if you only use GNU make; just use MAKEFLAGS directly. See Communicating Options to a Sub-make |
| `MAKECMDGOALS`     | The targets given to make on the command line. Setting this variable has no effect on the operation of make |
| `CURDIR`           | Set to the absolute pathname of the current working directory (after all -C options are processed, if any). Setting this variable has no effect on the operation of make |
| `SUFFIXES`         | The default list of suffixes before make reads any makefiles |
| `.LIBPATTERNS`     | Defines the naming of the libraries make searches for, and their order |
| `.DEFAULT_GOAL`    | Use to define a default target when none is specified, this can be useful when using a makefile include |

## 6.2. Special vars details
### 6.2.1. `DEFAULT_GOAL`

To complete `.DEFAULT_GOAL` description, we can use this example (thanks to [this thread][thread-so-makefile-include-rules-target]):
```make
# base.mk

base-rule:
    @echo "This is base rule"
```

```make
# Makefile

include base.make

all: rule1 rule2

rule1:
    @echo "This is rule 1"

rule2:
    @echo "This is rule 2"
```

When running main _Makefile_ with:
```shell
make
```

The first rule will be executed...Since `base.make` contains a rule, this is `base-rule` which will be executed, not `all`. If we want `all` to be executed when no target is specified, we can set our `Makefile`:
```make
# Makefile

.DEFAULT_GOAL := all    # Target "all" will be exec when no target is specified

include base.make

all: rule1 rule2

rule1:
    @echo "This is rule 1"

rule2:
    @echo "This is rule 2"
```

# 7. Ressources

- GNU Make official documentation
  - [doc-make-quick-refs]
  - [doc-make-vars-assignments]
  - [doc-make-specials-vars]
- Threads
  - [thread-so-makefile-differences]
  - [thread-so-makefile-assignments]
  - [thread-so-makefile-symbols-meaning]
  - [thread-so-makefile-include-rules-target]

<!-- Link ressources -->
[doc-make-quick-refs]: https://www.gnu.org/software/make/manual/html_node/Quick-Reference.html
[doc-make-vars-assignments]: https://www.gnu.org/software/make/manual/html_node/Flavors.html#Flavors
[doc-make-specials-vars]: https://www.gnu.org/software/make/manual/html_node/Special-Variables.html

[thread-so-makefile-differences]: https://stackoverflow.com/questions/4879592/whats-the-difference-between-and-in-makefile
[thread-so-makefile-assignments]: https://stackoverflow.com/questions/448910/what-is-the-difference-between-the-gnu-makefile-variable-assignments-a
[thread-so-makefile-symbols-meaning]: https://stackoverflow.com/questions/3220277/what-do-the-makefile-symbols-and-mean
[thread-so-makefile-include-rules-target]: https://stackoverflow.com/questions/12720399/why-makefile-include-should-be-after-all-target
