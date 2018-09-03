
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
sets env variables( e.g. `OCAML_TOPLEVEL_PATH`)
so that subsequent commands will use them.

A good idea is to add this in `.bashrc` or `.bash_profile`.


### OCAML toplevel

`.ocamlinit` is file used by toplevel like utop and other for initialization
instructions.

`#use filename` allows one to read, compile and execute source phrases
in the given file.

Requiring libraries or using filenames everytime when starting up toplevel
can be put inside `.ocamlinit`

### FindLib and ocamlfind

Findlib is library manager for Ocaml. 
It provides convention for how to store libraries and a file format ("META") to
describe properties of libraries.

`ocamlfind` - A cli tool that acts as front-end for findlib.
Interprets the META files, so it is easy to use libraries in programs
and scripts.

`META` - Includes version string, compiler options for using library and dependency on
other libraries.

Find more at findlib User's guide online.

### Ocamlbuild

Ocamlbuild's job is to determine the sequence of calls to be made to
compiler with specific flags in order to build the ocaml project

Ocamlbuild will work together with findlib/ocamlfind to support external
dependencies usage and compilation/building. Read the OcamlBuild manual.

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


