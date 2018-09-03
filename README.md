
### OPAM

OPAM is the package manager for OCaml.
Know your way around OPAM to be productive

The entire opam package database is held in the `.opam` directory in home dir,
including the compiler installations.

OPAM never installs files into your system directories, instead it puts
them in your home directory by default,
and can output a set of shell commands which configures your shell with the
right PATH variables so that packages will just work.
This result of running
`eval opam config env`
sets variables so that subsequent commands will use them.

A good idea is to add this in `.bashrc` or `.bash_profile`.



#### Switches

Opam switches are like version managers for ocaml. Like nvm for node.


### JaneStreet Base/Core

State of the art standard libraries used for all applications.

`Base`: minimal stdlib replacement.
`core_kernel`: Extension of base.
`core`: `core_kernel` extended with Unix APIs.

Installation: `opam install core`

Usage within utop:
```utop
#require "core";;
open Base;;
List.find;; // must see new signature
```

### Tooling via merlin

Install merlin packages to get tooling support


### Utop as a toplevel

Utop is state of the art REPL for ocaml.


