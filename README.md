# PLASM

A lightweight programming language for retro computing platforms designed to integrate seamlessly with
existing assembly codebases

## Table Of Contents

* [Compatible Targets](#compatible-targets)
* [Overview](#overview)
   * [Why The Name ***PLASM***?](#why-the-name-plasm)
   * [Design Philosophy](#design-philosophy)
   * [Current State and Future Roadmap](#current-state-and-future-roadmap)
* [Installation](#installation)
   * [Windows/MacOS/Linux](#windowsmacoslinux)
* [Usage](#usage)
  * [Command Line Arguments](#command-line-arguments)
  * [Windows](#windows)
  * [MacOS](#macos)
  * [Linux](#linux)
* [The ***PLASM*** Language](#the-plasm-language)
   * [Reserved Keywords](#reserved-keywords)[*](#subject-to-change)
   * [Other Symbols](#other-symbols)[*](#subject-to-change)
   * [Compiler Directives](#compiler-directives)[*](#subject-to-change)
   * [Program Structure](#program-structure)
      * [Comments](#comments)
      * [Declaring Constants](#declaring-constants)
      * [Variable/Data Distinction for the `6502` Family Only](#variabledata-distinction-for-the-6502-family-only)
      * [Declaring Variables](#declaring-variables)
      * [Declaring Data](#declaring-data)
      * [Declaring Procedures](#declaring-procedures)
        * [The `main` Procedure](#the-main-procedure)
      * [Register/Flag Access](#registerflag-access)
         * [`6502` Registers/Flags](#6502-registersflags)
      * [The `mem` Keyword](#the-mem-keyword)
      * [Statements and Statement Blocks](#statements-and-statement-blocks)
         * [`;` in ***PLASM*** vs C](#-in-plasm-vs-c)
         * [`begin`...`end`](#beginend)
         * [Assignments](#assignments)
         * [Assigning Results Of Arithmetic/Bitwise Logic Operations](#assigning-results-of-arithmeticbitwise-logic-operations)
         * [Procedure Calls](#procedure-calls)
         * [Comparison/Conditional Operators](#comparisonconditional-operators)
         * [`if`...`then`...`else`](#ifthenelse)
         * [`repeat`...`until`](#repeatuntil)
         * [`while`...`do`](#whiledo)
         * [`asm {`...`} end` (AKA Inline Assembly)](#asm--end-aka-inline-assembly)

## Compatible Targets

Currently only targets the `6502`, but the long term goal is to extend multiple other retro CPUs.
A list of current and planned targets includes:

- [x] `6502` <br/>
- [ ] `65C02` <br/>
- [ ] `65816` <br/>
- [ ] `8080` <br/>
- [ ] `Z80` <br/>
- [ ] `Game Boy Z80` <br/>
- [ ] Other retro 8/16/32 bit CPUs <br/>

## Overview

### Why The Name ***PLASM***?

***PLASM*** stands for **PL/0** + **Assembly**

* **PL/0**: The basis of the language's syntax is `PL/0` (Pascal's less capable cousin) with some additional
  syntax borrowed from `Super Pascal` for the Commodore 64 and a little bit from `C`

* **Assembly**: Being able to seamlessly integrate ***PLASM*** code with pre-existing assembly code is a core
  feature of the language

### Design Philosophy

The ***PLASM*** language has the bare minimum functionality necessary to be considered a "programming
language." Branding ***PLASM*** as "*a lightweight programming language*" is really shorthand for "*a programming
language that behaves like a really fancy assembler front end.*"

Rather than try to add every flavor of syntactic sugar under the sun and bang my head against the wall
trying to optimize the result, I **heavily restricted some features**
**(***[See Statements](#statements-and-statement-blocks)***)** of the language in addition to **lower level features** not
typically found in a modern language providing **more control** in order to make it as easy as possible for
**efficient compiler code generation**.

The idea is to provide *just enough* of a language that it's **faster** and **less error prone** than writing
pure assembly code, but with the capability of **freely inlining assembly anywhere** to achieve anything the
language doesn't provide out of the box, enabling more **developer autonomy and control**.

In fact, it's very possible to use ***PLASM*** as a thin wrapper around assembly code while only using the
compiler to help with organizing `variables`/`data`/`subroutines`. Bear in mind that while this is *technically* 
achievable, **it's not the intended use** for the language. ***PLASM*** is designed to supplement the process 
of writing assembly code by taking advantage of the structure and readability a higher level language provides
without taking away the power and speed that true assembly programming offers.

***PLASM*** also provides **easy integration of pre-written assembly code**. The compiler doesn't generate a
binary executable, but rather generates the assembly language files formatted to target one of the existing
popular assembler choices (i.e. `CA65/KickAssembler` for the `6502`) for the target CPU.

The compiler is designed to **handle a single file at a time**. Though there *are* methods provided to access
variables/routines outside the file.

### Current State and Future Roadmap

The compiler executable is confidently an **Alpha Version** since it achieves all the basic goals I started
out with, but is a few features short of desired production ready functionality.

The **Roadmap to the Beta Version** includes:

- [ ] **Main File Compiler Directive**<a name="main-directive"></a>
   * **The Design Flaw**: Currently, there's no way to tell the compiler to treat a `.pl0` file as the `main`
     program file without manually including other files
   * **Goal**: Allow users to write a complete program in a single `.pl0` file without needing to manually
     include other `.asm` files
   * **TODO**:
     - [ ] Implement the `%main` compiler directive

[//]: # (TODO: Jon, double check this section for accuracy lol)
- [ ] **Traditional Array Syntax**<a name="traditional-array-syntax"></a>
   * **The Design Flaw**: `X`/`Y` index registers are only supported for pointer/array dereferencing
     inside expressions/statements. There's no way to declare an array with a specific size and initialize
     it with values like in other languages
   * **Goal**: Allow users to declare/initialize arrays in a more traditional way by incorporating `opc($XX),y` 
     style syntax
   * **TODO**:
     - [ ] Implement traditional array declaration/initialization syntax

- [ ] **More Data Types**
  * **The Initial Design Choice**: Limit data types to strings and native 8-bit size variables
  * **Why Include More Data Types**: Pointers are convenient :point_left:
  * **Goal**:
     * Optimize 16-bit arithmetic/comparisons (I realized the expression evaluation limitations I decided
       to enforce make it easy)
  * **TODO**:
    - [ ] Data type declarations
    - [ ] All the code generation that handles multi-byte operations

- [ ] **Better Configuration Options**
   * **The Design Flaw**: Configuration possibilities were overlooked when it comes to dealing with what
     character
     set the target machine uses (`ASCII` vs `PETSCII`)
   * **The Workaround**: I (temporarily) removed native `string`/`char` support pending command line
     options/inline compiler
     directives to deal with this. You are still capable of declaring strings in an assembly file and there's
     a mechanism
     to tell the compiler that's what you're doing, but this workaround is only temporary
   * **Current Default Behavior**: Assume the user will provide their own assembly file to act as the `main`
     program file
   * **Goal**: Add more boilerplate to the `.asm` file
   * **TODO**:
     - [ ] Add a feature to tell the compiler which file to use as the `main` file

- [ ] **Miscellaneous Features**
  - [ ] Add a few more keywords, features, and backend optimization passes to the IR
  - [ ] A dash of syntactic sugar to make writing some expressions shorter
  - [ ] Support for more assembler back ends. Currently, only `CA65`/`CL65` assembly format is supported.
  - [ ] A proper typing system with type checking <a name="roadmap-types"></a>
  - [ ] Uploading the source code. I'd prefer to do some more refactoring/cleanup before sharing the `C` source.
  - [ ] Better compiler error messages
  - [ ] More library code. Currently, only `Commander X16` examples are provided with a minimal amount of tested
     "library code." More code/platform varieties are in progress

- [ ] **Known Bugs/Inefficient Code Generation** (For the super nerds)
  - [ ] Condensing of redundant labels
  - [ ] Folding a series of JMP instructions into 1 JMP, telling the compiler it's allowed to perform a tail call
  - [ ] A few other unnecessary instructions it occasionally generates because the front end can only make so
     many assumptions
  - [ ] There are a few specific situations where swapping a branch instruction for a jump is done incorrectly

## Installation

The ***PLASM*** compiler doesn't have any dependencies besides having the desired assembler backend installed.

During the **Alpha Version**, it is recommended that you download the ***PLASM*** zip file in the same directory as 
the code/project that you plan to compile with ***PLASM***. The **Beta Version** will have a proper 
installer and/or instructions to add ***PLASM*** to your system path.

### Windows/MacOS/Linux

* Download the latest release for your operating system from the 
  [Releases](https://github.com/jroseberry64/PLASM-Compiler/releases) page <br/>
  *Recommended to install in the same directory as your code/project*
* Unzip the executable
* Proceed to [Usage](#usage) for instructions on how to run the compiler

## Usage

All OS versions utilize the command line to invoke the compiler.

***Final Reminder: The compiler operates under the assumption that the executable is in the same directory as the code/project
it's compiling***

### Command Line Arguments

* `plasm_filename`: The ***PLASM*** file to compile (i.e. `filename.pl0`)
* `outfilename`: The name that will be used to create the `.asm` file(s) (i.e. `outfilename.asm`, `outfilename_vars.asm`, etc.) associated with `plasm_filename`

### Windows

* Run the executable:

```shell
./plasm.exe filename.pl0 outfilename
```

*Windows doesn't care about security* :satisfied:

### MacOS

* Run the executable:

```shell
./plasm filename.pl0 outfilename
````

***Note:*** *The first time you run the executable, a pop-up might appear asking for permission to run the executable.
If the pop-up doesn't appear or errors persist, you may need to go into your Mac settings and manually allow the executable to run*

### Linux

* Run the executable

```shell
./plasm filename.pl0 outfilename
````

***Note:*** *The first time you run the executable, you may encounter a file permissions error. Run `chmod +x plasm` to fix*

## The ***PLASM*** Language

<a name="subject-to-change"></a>
***Note:*** *Any of the following sections marked with \* are subject to updates as features are added to the
compiler*

### Reserved Keywords[*](#subject-to-change)

(Mostly) Self-explanatory list of reserved keywords in ***PLASM***:

* [`const`](#declaring-constants)
* [`var`](#declaring-variables)
* [`data`](#declaring-data)
* `call`
* [`procedure`](#declaring-procedures)
* [`begin`](#beginend)
* [`end`](#beginend)
* [`if`](#ifthenelse-statements)
* [`then`](#ifthenelse-statements)
* [`else`](#ifthenelse-statements)
* [`while`](#whiledo-statements)
* [`do`](#whiledo-statements)
* [`repeat`](#repeatuntil-statements)
* [`until`](#repeatuntil-statements)
* `inc`
* `dec`
* `rol`
* `ror`
* `shl`
* `shr`
* [`mem`](#the-mem-keyword)
* `asm`
* `extern`
* `in`
* `ROM`


### Other Symbols[*](#subject-to-change)

List of other symbols used in ***PLASM***:

* `.`
* `$`
* `#`
* `@`
* `{` `}`
* `[` `]` 
* `+` 
* `-` 
* `|` 
* `^` 
* `=` 
* `<` 
* `>`
* `?` 
* `:` 
* `;` 
* `:=`
* [`6502` Registers/Flags](#6502-registersflags)
  * [`%A`](#register-flag-a) 
  * [`%X`](#register-flag-x) 
  * [`%Y`](#register-flag-y) 
  * [`%CF`](#register-flag-cf) 
  * [`%ZF`](#register-flag-zf) 
  * [`%VF`](#register-flag-vf) 
  * [`%NF`](#register-flag-nf)

*Some symbols might be different than what you're used to in other languages*


### Compiler Directives[*](#subject-to-change)

List of keywords that tell the compiler to behave in different ways:

* `%incbin` 
* `%incasm` 
* `%unit`

### Program Structure

***PLASM*** programs have the following structure and declaration order:

```
Global Constant Declaration Block+
Global Variable Declaration Block+
Global Data Declaration Block+

External Constant/Variable/Data/Procedure Declaration Block+

Procedure Declaration+
Local Constant Declaration Block+
Local Variable Declaration Block+
Local Data Declaration Block+
Procedure Code Block

Main Procedure Code Block*
```

***Note:*** *Anything with `+` is optional. Anything with `*` is only required if you don't use the `%unit` compiler
directive at the beginning of the program*

### Comments

Comments in ***PLASM*** begin with `{` and are terminated by `}`:

```
{ This is a comment }
{This is another comment}

{ 
  This is a
  multi-line
  comment 
}
```

### Declaring Constants

There are three types of constants:
* Global Constants
* Local Constants
* External/`.asm` Constants

Currently, constants cannot be an `array` or `pointer` type[*](#subject-to-change)

**Global and Local Constant Declaration:**<br/>
All global and local constant declarations are immediately initialized with a value

```
{ Declaring a single constant }
const myConst = 1;

{ Declaring multiple constants }
const
  const1 = 1,     { numerical constant }
  const2 = $01,   { Hexadecimal/Zero Page Addr constant }
  const3 = $1FFF  { Hexadecimal Address constant }
  ;               { Constant declaration must end with ';' }
```

The compiler adds all global/local constants to a separate `.inc` file so they can be included in other
`.asm` files as needed

**External/`.asm` Constant Declaration:**
External/`.asm` constants are never initialized with a value

```
{ Declaring a single external constant }
extern const myConst;

{ Declaring multiple external constants }

{ Method 1 }
extern const myConst;
extern const myOtherConst;

{ Method 2 }
extern const myConst, myOtherConst;
```

***Note:*** *The compiler assumes any provided external identifier already exists somewhere. The target assembler 
is responsible for verifying the constant variable's existence*

### Variable/Data Distinction for the `6502` Family Only

The main reason the difference between variables and data exists in ***PLASM*** is to account for the `Zero Page` when targeting `6502` platforms.
Data is for anything that doesn't need to take up `Zero Page` space (like `arrays`), while only `Variables` can be pure `pointers` (to take advantage of the `.Y` index
register). Therefore an `array` cannot be declared inside a `var` block.

The other rationale is giving the programmer the ability to better seperate what belongs in RAM/ROM for cartridge based systems and making it easy to embed 
binary/.asm data exported from any of the popular retro gamedev tools inside PLASM.

### Declaring Variables

[//]: # (TODO: Discuss the differences between being able to initialize var/data pointers/arrays with values or not)

**Variable Declaration:**<br/>
Variables are never initialized with a value. The `array`/`pointer` type is always indexed starting at 0 with a default size of 1

```
{ Variable Types }
var byteVar;  { Declares a variable with the default type of unsigned byte }
var ptrVar[]; { Declares a pointer to any type }

{ Declaring Multiple Variables }
var
  var1,
  ptrV1[],
  var2;

{ Declaring External Variables }
extern var v1, v2[];
```

*A proper typing system with multiple data types is planned for a future version of the compiler. [See it on the Roadmap](#roadmap-types)*

### Declaring Data

[//]: # (TODO: Discuss with Jon the differences between being able to initialize var/data pointers/arrays with values or not)

Data declarations are similar to variable declarations with a key difference regarding arrays.

**Data Declaration:**<br/>
Pointers/byte values are never initialized with a value and the `array`/`pointer` type is still always indexed starting at 0 with a default size of 1. 
Arrays can optionally be initialized with the `%incbin` and `%incasm` directives and the syntax for more traditional array initialization is a planned feature for
the Beta version.

```
{ Declaring an Array }
data myArray[];    { Default size: 1 }
data myArray[10];  { Size: 10 }

{ Initialize with `.asm`/`.bin` data }
data
  myArray[] = %incbin:SomeBinFile.bin,
  array2[] = %incasm:SomeAsmData.asm,
  romArr[] = %incbin:File.bin in ROM    { `in ROM` tells the compiler that the data is expected to be `READ ONLY` }
;

{ External declaration }
extern data myData, myArray[], array[] in ROM, otherArray[] in ROM; 
```

*A proper typing system with multiple data types is planned for a future version of the compiler. [See it on the Roadmap](#roadmap-types)*

### Declaring Procedures

Equivalent to functions/subroutines in other languages, procedures are blocks of code that can be called from
other parts of the program

**Procedure Declaration:**

```
{ Procedure declaration }
procedure SomeProcedure;

{ Local constant declaration }
const localConst = 1;

{ Local variable declaration } 
var localPtr[];

{ Local data declaration }
data localArray[4];

{ CODE BLOCK BEGINS HERE }
```

***Note:*** ***PLASM*** *Doesn't have any explicit syntax for declaring/passing arguments to
procedures.* ***However*** *you're free to use local/global variables/data and/or registers to pass arguments
to the procedure or return as many values as you want*

#### The `main` Procedure

By default ***PLASM*** doesn't assume there will be a `main` procedure in the file it's currently compiling in the sense most programmers are used to. 

In a hand written assembly program, the compiler's default assumption is to use the assembly code generated 
by the compiler elsewhere. This makes it as easy as possible to integrate ***PLASM*** code

Currently, **there is no mechanism to change the default assumption**. I'm in the process of implementing a compiler directive to address this limitation 
and automate this step. It's the top of my priority list. [See it on the Roadmap](#main-directive)

The syntax for telling the compiler to treat the current `.pl0` file [`begin ... end`](#beginend) block as the `main` procedure:

```
{ Directive }
%main(...)   { (...) -> comma seperated list of files to include in the `.asm` output file }
```

### Register/Flag Access

***PLASM*** allows access to registers/flags as pseudo-variables inside statements or expressions.

#### `6502` Registers/Flags

* Accumulator (A) Register: `%A`<a name="register-flag-a"></a>
* X Index (X) Register: `%X` <a name="register-flag-x"></a>
* Y Index (Y) Register: `%Y` <a name="register-flag-y"></a>
* Negative (N) Flag: `%NF` <a name="register-flag-nf"></a>
* Overflow (V) Flag: `%VF` <a name="register-flag-vf"></a>
* Zero (Z) Flag: `%ZF` <a name="register-flag-zf"></a>
* Carry (C) Flag: `%CF` <a name="register-flag-cf"></a>

***Note:*** *The compiler only recognizes `6502` registers. As more processors are added to the back
end, the compiler will recognize registers based on the target CPU*

### The `mem` Keyword

***PLASM*** provides a similar concept to [`BASIC`](https://en.wikipedia.org/wiki/BASIC)'s `PEEK`/`POKE` with the `mem[]` keyword.

`mem[]` acts as a pseudo variable that allows you to treat memory like a giant array.
This means you can load/store variables/data from anywhere in memory.

### Statements and Statement Blocks

Statements in ***PLASM*** are similar to statements in other C-like languages with a few key differences

#### `;` in ***PLASM*** vs `C`

In `C`, `;` is considered a statement _terminator_. In ***PLASM***, `;` is a statement _separator_.
It's used to tell where one statement ends and another begins.

#### `begin`...`end`

Unlike other C-like languages, ***PLASM*** doesn't utilize `{...}` to organize blocks of code. Instead, the
keywords `begin...end` are used

[//]: # (TODO: Jon definitely double check this bc I had copilot auto populate this lol)

```
{ Single line statement (no begin...end needed) }
if v1 = v2 then
  v1 := 1
else
  v1 := 0;

{ Multi-line statement (begin...end needed) }
if v1 = v2 then
begin
  v1 := 1;
  v2 := 2
end
else
begin
  v1 := 0;
  v2 := 0
end;

{ 'main' procedure begin...end block }
begin

{ Code goes here }

end. { Note that the 'main' procedure block must be terminated by '.' }
```

#### Assignments

The `:=` symbol acts as the assignment operator for ***PLASM***.

**Valid Assignments:**

```
{ Variable assignment }

v1 := 1;         { Assign a constant value }
v1 := HexConst;
v1 := NumConst;

v1 := v2;        { Assign the value of one variable to another }
v1 := mem[$10];  { Assign the value of a memory location }
v1 := p1[];      { Assign dereferenced pointer value }
v1 := p1[%Y];    { Offsets p1 by the contents of the Y register and assigns value of dereferenced pointer }
v1 := a1[0];     { Assigns the value of the first element in array }
   
{ Pointer assignment (Same as variable with these additions) }
p1[] := v1;      { Assigns variable to dereferenced pointer }
p1 := @v1;       { Assign address of variable to pointer }
p1 := AddrConst; { Same as above but with constant }

{ Array assignment (Same as variable with these additions) }
a1[] := v1;      { First element of array assigned variable value }
a1[%X] := v1;    { Array element index by %X assigned variable value }

{ Memory assignment (same as variable, with two variations) }
mem[AddrConst] := 1;  { Uses cont as address }
mem[$1000] := v1;     { Uses hard coded value as address }

{ Register Assignment }
%A := 1;
%A := v1;
%A := p1[];
%A := %X;
%A := %Y;

%X := 1;
%X := p1[%Y];
%X := %A;
```

#### Assigning Results Of Arithmetic/Bitwise Logic Operations

***PLASM*** only supports the native bitwise/mathematical operations of the CPU. 
For the `6502`, this means only the `addition`, `subtraction`, logical `AND`/`OR`/`EOR`, `shift`/`rotate`,
`left`/`right`, and `increment`/`decrement` expressions are supported.

The `addition`, `subtraction`, and logical `AND`/`OR`/`EOR` are strictly **binary operations**

The `shift`/`rotate`, `left`/`right`, and `increment`/`decrement` are strictly **unary operations**

**Binary Operation Examples:**<br/>
&ensb;`addition`, `subtraction`, `AND`/`OR`/`EOR`

```
{ These are expressions allowed }
v1 := v2 + v3;        
%A := v1 - v2;         { +=, -= will be added to Beta version }
%X := v1 & 1;          { Bitwise Logical AND }
v1 := p1[%Y] | p2[%Y]; { Bitwise Logical OR }
%Y := v1 ^ v2;         { Bitwise Logical EOR }

{ These are not }
v1 := v2 + v3 + v4;
v1 := v2 & v3 + v4;
```

**Unary Operation Examples:**
&ensb;`shift`/`rotate`, `left`/`right`, `increment`/`decrement`

```
{ This is how to use the unary operators }
inc v1;
dec v1;
shl v1;
shr v1;
rol v1;
ror v1;

{ This is also valid }
shl %A;
shr %A;
rol %A;
ror %A;

{ Note: On the vanilla `6502`, there's no `inc A` instruction }
inc %X;
dec %X;
inc %Y;
dec %Y;
```

#### Procedure Calls

See [Declaring Procedures](#declaring-procedures) for procedure declaration syntax

```
{ Allowed }

call SomeProcedure;

{ Not Allowed }

v1 := SomeProcedure;
v1 := call SomeProcedure;
```

Any input/output to procedures must be handled manually. It's not possible to assign the result of a procedure call to a variable/data.

#### Comparison/Conditional Operators

***PLASM*** supports the following comparison operators:

```
v1 = v2  { Tests equality }
v1 # v2  { Tests inequality }
v1 < v2  { <=, >= will be added to Beta }
v1 > v2

%CF-     { Carry Flag Clear }
%CF+     { Carry Flag Set }
%VF-
%VF+
%ZF-
%ZF+
%NF-
%NF+
```

***Note:*** *Only one comparison or condition operator may be used per conditional statement.*
***There is currently no support for combining boolean `AND`/`OR`/`NOT` statements***

#### `if`...`then`...`else`

These statements work the same as they do in other languages (minus the single conditional constraint)

**If...Then...Else Examples:**

```
if v1 = v2 then
begin
  { Do something }
end
else if %CF+ then
  { Do something in one line }
else
begin
  { Do something else }
end;
```

See also [Begin...End](#beginend)

#### `repeat`...`until`

Works the same as a `do`...`while` loop in `C` or any other C-like language.

**Repeat...Until Example:**

```
%Y := 0;

repeat
 inc %Y
until %Y = 20;
```

#### `while`...`do`

Works the same as a `while` loop in `C` or any other C-like language.

```
%X := 0;
while %X < 5 do
begin
  a1[%X] := 0;
  inc %X
end;
```

See also [Begin...End](#beginend)

#### `asm {`...`} end` (AKA Inline Assembly)

Validation of an `asm {...} end` block is completely deferred to the target assembler. ***PLASM*** doesn't
attempt to parse or validate any assembly code inlined between the `asm {...} end` blocks.

This frees you to do anything the language doesn't support, including accessing const/var/data from outside the 
block or even from your hand written assembly code (***PLASM*** will not alter/mangle names, so you can use them 1-1). 
The downside is **any assembly syntax errors won't get caught until invoking the assembler**.

```
{ Allowed }
asm {
  ldx #$00
  sty $0200
} end

{ Allowed }
asm
{
  ldx #$00
  sty $0200
}
end

{ Not Allowed (inline assembly code must start on a new line) }
asm { rts } end
```
