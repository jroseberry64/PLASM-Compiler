# PLASM

A lightweight programming language for retro computing platforms designed to integrate seamlessly with
existing assembly code

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
  * [Linux](#linux)
  * [MacOS](#macos)
* [***PLASM*** Language](#plasm-language)
   * [Reserved Keywords*](#reserved-keywords)
   * [Other Symbols*](#other-symbols)
   * [Compiler Directives*](#compiler-directives)
   * [***PLASM*** Program Structure](#plasm-program-structure)
      * [Comments](#comments)
      * [Declaring Constants](#declaring-constants)
      * [A Quick Note About Var/Data Distinction For 6502 Family Only](#a-quick-note-about-vardata-distinction-for-6502-family-only)
      * [Declaring Variables](#declaring-variables)
      * [Declaring Data](#declaring-data)
      * [Procedure Declaration](#procedure-declaration)
      * [A Quick Note About The "Main" Procedure](#a-quick-note-about-the-main-procedure)
      * [Register/Flag Access](#registerflag-access)
         * [6502 Registers/Flags](#6502-registersflags)
      * [`mem` Keyword](#mem-keyword)
      * [Statements](#statements)
         * [`;` In ***PLASM*** VS C](#-in-plasm-vs-c)
         * [`begin`...`end` Statement Blocks](#beginend-statement-blocks)
         * [Assignment Statements](#assignment-statements)
         * [Assigning Results Of Arithmetic/Bitwise Logic Operations](#assigning-results-of-arithmeticbitwise-logic-operations)
         * [Procedure Calls](#procedure-calls)
         * [Comparison/Conditional Operators](#comparisonconditional-operators)
         * [`if`...`then`...`else` Statements](#ifthenelse-statements)
         * [`repeat`...`until` Statements](#repeatuntil-statements)
         * [`while`...`do` Statements](#whiledo-statements)
         * [`asm {`...`} end` Statements (AKA Inline Assembly)](#asm--end-statements-aka-inline-assembly)

## Compatible Targets

Currently it only targets the `6502`, but the long term goal is to extend multiple other retro CPUs.
A list of current and planned targets includes:

- [x] `6502` <br/>
- [ ] `65C02` <br/>
- [ ] `65816` <br/>
- [ ] `8080` <br/>
- [ ] `Z80` <br/>
- [ ] `Game Boy Z80` <br/>
- [ ] Other retro 8/16/32 bit CPUs <br/>

## Overview

Addressing all curiosities before moving on to the nuts and bolts of the language

### Why The Name ***PLASM***?

***PLASM*** stands for **PL/0** + **Assembly**

* **PL/0**: The basis of the language's syntax is `PL/0` (Pascal's less capable cousin) with some additional
  syntax borrowed from `Super Pascal` for the `Commodore 64` and a little bit from `C`

* **Assembly**: Being able to seamlessly integrate ***PLASM*** code with pre-existing assembly code is a core
  feature of the language

### Design Philosophy

The ***PLASM*** language has the bare minimum functionality necessary to be considered a "programming
language." Branding ***PLASM*** as "*a lightweight programming language*" is shorthand for "*a programming
language that behaves like a really fancy assembler front end.*"

Rather than try to add every flavor of syntactic sugar under the sun and bang my head against the wall
trying to optimize the result, I **heavily restricted some features**
**(***[See Statements](#statements)***)** of the language in addition to exciting **lower level features** not
typically found in a modern language providing **more control** in order to make it as easy as possible to
output **efficient compiler generated code**.

The idea is to provide *just enough* of a language that it's **faster** and **less error prone** than writing
pure assembly code, but with the capability of **freely inlining assembly anywhere** to achieve anything the
language doesn't provide out of the box enabling more **developer autonomy**.

In fact, it's very possible to use ***PLASM*** as a thin wrapper around assembly code while only using the
compiler to help with organizing variables/data/subroutines.

***PLASM*** also provides **easy integration of pre-written assembly code**. The compiler doesn't generate a
binary executable, but rather generates the assembly language files formatted to target one of the existing
popular assembler choices (i.e. `CA65/KickAssembler` for the `6502`) for the target CPU.

The compiler is designed to **handle a single file at a time**. Though there *are* methods provided to access
variables/routines outside the file.

### Current State and Future Roadmap

The compiler executable is confidently an **Alpha Version** since it achieves all the basic goals I started
out with, but is a few features short of desired functionality.

The **Roadmap to the Beta Version** includes:

* **More Data Types**
   * **The Initial Design Choice**: Limit data types to strings and native 8-bit size variables
   * **Why Include More Data Types**: Pointers are convenient :point_left:
   * **Goal**:
      * Optimize 16-bit arithmetic/comparisons (I realized the expression evaluation limitations I decided
        to enforce make it easy)
   * **TODO**:
      * Data type declarations
      * All the code generation that handles multi-byte operations

* **Better Configuration Options**
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
      * Add a feature to tell the compiler which file to use as the `main` file

* **Miscellaneous Features**
   * Add a few more keywords, features, and backend optimization passes to the IR
   * A dash of syntactic sugar to make writing some expressions shorter
   * Support for more assembler back ends. Currently, only `CA65`/`CL65` assembly format is supported.
   * Uploading the source code. I'd prefer to do some more refactoring/cleanup before sharing the `C` source.
   * Better compiler error messages
   * More library code. Currently, only `Commander X16` examples are provided with a minimal amount of tested
     "library code." More code/platform varieties are in progress

* **Known Bugs** (For the super nerds)
   * Condensing of redundant labels
   * Folding a series of JMP instructions into 1 JMP, telling the compiler it's allowed to perform a tail call
   * A few other unnecessary instructions it occasionally generates because the front end can only make so
     many assumptions
   * There are a few specific situations where swapping a branch instruction for a jump is done incorrectly

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
* `outfilename`: The name that will be used to create the .asm file(s) (i.e. `outfilename.asm`, `outfilename_vars.asm`, etc.) associated with `plasm_filename`

### Windows

```shell
./plasm.exe filename.pl0 outfilename
```

*Windows doesn't care about security* :satisfied:

### MacOS

* Run the executable:

```shell
./plasm filename.pl0 outfilename
````

***Note:*** *The first time you run the executable, a pop-up might appear asking for permission to run the executable*

### Linux

* Run the executable

```shell
./plasm filename.pl0 outfilename
````

***Note:*** *The first time you run the executable, you may encounter a file permissions error. Run `chmod +x plasm` to fix*

# ***PLASM*** Language

***Note:*** *that any of the following sections marked with \* are subject to updates as features are added to the
compiler*

## Reserved Keywords\*

`
const
var
data
call
procedure
begin
end
if
then
else
while
do
repeat
until
inc
dec
rol
ror
shl
shr
mem
asm
extern
in
ROM
`

## Other Symbols\*

`
. $ # @ { } [ ] + - | ^ = < > ? : ; := %A %X %Y %CF %ZF %VF %NF 
`

## Compiler Directives\*

`
%incbin %incasm %unit
`

## ***PLASM*** Program Structure

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

Note that anything with '+' is optional and '\*' is only required if you don't use the `%unit` compiler
directive at the beginning of the program.

### Comments

Comments in ***PLASM*** begin with '{' and are terminated by '}'.

### Declaring Constants

Any constant declaration must immediately be followed by assigning it a value.

Global/local constants are declared using the following syntax:

```
{ Declaring 1 constant }
const myConst = 1;

{ Declaring multiple constants }
const
  const1 = 1,     { numerical constant }
  const2 = $01,   { Hexadecimal/Zero Page Addr constant }
  const3 = $1FFF  { Hexadecimal Address constant }
  ;               { Constant declaration must end with ';' }
```

The current default behavior at the moment is to add all globa/local constants found by the compiler to a
seperate `.inc` file so they can be included in other `.asm` files as needed.

External/.asm constants are declared with the following syntax:

```
{ Declaring 1 external constant. Note that we don't assign a value to external constants }
extern const myConst;

{ Declaring multiple external constants }

{ Method 1 }
extern const myConst;
extern const myOtherConst;

{ Method 2 }
extern const myConst, myOtherConst;
```

Note that the compiler assumes any external identifier you provide exists somewhere and punts verifying that
to the target assembler.

### A Quick Note About Var/Data Distinction For 6502 Family Only

It should be noted that the only reason the difference between variables and data exists in ***PLASM*** is to
account for the Zero Page when targetting 6502 platforms. Data is for anything that doesn't need to take up
Zero Page space (like arrays) while only Variables can be pure pointers (to take advantage of the .Y index
register) and you can't declare an array inside a `var` block.

### Declaring Variables

Variables are declared in a similar manner to constants, except that no value is assigned at the time of
declaration.

Variable Declaration:

```
{ Variable types }
var byteVar;  { Declares a variable with a default type of unsigned byte }
var ptrVar[]; { Declares a pointer to any type }

{ Declaring multiple variables }
var
  var1,
  ptrV1[],
  var2;

{ Declaring external variables }
extern var v1, v2[];
```

### Declaring Data

Data declarations follow the same pattern as variables, with the following exceptions:

```
{ Declaring an array }
data myArray[];    { Default size: 1 }
data myArray[10];  { Size: 10 }

{ Initialize with .asm/.bin data }
data
  myArray[] = %incbin:SomeBinFile.bin,
  array2[] = %incasm:SomeAsmData.asm,
  romArr[] = %incbin:File.bin in ROM    { This tells the compiler that we can expect this data to be READ ONLY }
;

{ External declaration }
extern data myData, myArray[], array[] in ROM, otherArray[] in ROM; 
```

### Procedure Declaration

Procedures are declared with the following syntax:

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

One thing to note is while ***PLASM*** doesn't have any explicit syntax for declaring/passing arguments to
procedures there's nothing stopping you from using local/global variables and/or registers to pass arguments
to the procedure or return as many values as you want.

### A Quick Note About The "Main" Procedure

Right now if you want to use a .pl0 file as the "main" file you have to manually include any other .asm files
that you compiled or manually wrote. I have a compiler directive I'm working on to address this and automate
the step that's at the top of my priority list.

```
{ Directive }
%main(...)   { (...) -> comma seperated list of files to include in the .asm output file }
```

### Register/Flag Access

***PLASM*** allows access to registers/flags as psuedo-variables inside statements or expressions.

#### 6502 Registers/Flags

* Accumulator (A) Register: `%A`
* X Index (X) Register: `%X`
* Y Index (Y) Register: `%Y`
* Negative (N) Flag: `%NF`
* Overflow (V) Flag: `%VF`
* Zero (Z) Flag: `%ZF`
* Carry (C) Flag: `%CF`

NOTE: At this point the compilers only recognizes 6502 registers, but as more processors are added to the back
end the compiler will recognize registers based on the target CPU.

### `mem` Keyword

***PLASM*** provides a similar concept to BASIC's `PEEK`/`POKE` with the `mem[]` keyword.

`mem[]` acts as a psuedo variable that allows you to treat memory like a giant array so you can load/store
variables/data from anywhere in memory.

### Statements

#### `;` In ***PLASM*** VS C

In C, `;` is considered a statement _terminator_. In ***PLASM***, `;` is a statement _seperator_ which means
it's
just used to tell where one statement ends and another begins.

####`begin`...`end` Statement Blocks
Unlike other C-like languages, ***PLASM*** doesn't utilize `{...}` to organize blocks of code. Instead, the
keywords
`begin...end` are used.

#### Assignment Statements

The `:=` symbol acts as the assignment operator for ***PLASM***.

Examples of valid assignment statements:

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

***PLASM*** only supports the native bitwise/mathematical operations of the CPU, so for the 6502 this means
only
addition, subraction, Logical AND/OR/EOR, shift/rotate left/right, and increment/decrement expressions are
supported.

Also note that addition, subtraction, and logical AND/OR/EOR can only be performed as binary operations,
meaning:

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

While shift/rotate left/right and increment/decrement are unary operations, meaning:

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

{ Note that on the vanilla 6502 there's no 'inc A' instruction }
inc %X;
dec %X;
inc %Y;
dec %Y;
```

#### Procedure Calls

```
{ Allowed }

call SomeProcedure;

{ Not Allowed }

v1 := SomeProcedure;
```

Remember, any input/output to procedures must be handled manually, so it's not possible to assign the result
of a procedure call to a variable.

#### Comparison/Conditional Operators

***PLASM*** supports the following operators:

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

It should be noted that only one comparison or condition operator may be used per conditional statement (i.e.
there's currently no support for Boolean AND/OR/NOT to combine conditional statments)

#### `if`...`then`...`else` Statements

These statements work the same as they do in other languages (minus the single conditional constraint).

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

#### `repeat`...`until` Statements

Works the same as a `do`...`while` loop in C or any other C-like language.

```
%Y := 0;

repeat
 inc %Y
until %Y = 20;
```

#### `while`...`do` Statements

Also works the same as `while` loops in other C-like languages.

```
%X := 0;
while %X < 5 do
begin
  a1[%X] := 0;
  inc %X
end;
```

#### `asm {`...`} end` Statements (AKA Inline Assembly)

***PLASM*** makes no attempt to do anything with assembly inlined between `asm {...} end` blocks but copy and
paste
it to the final assembly output. So, in that sense, this is another place where ***PLASM*** punts any
validation to
the target assembler. On the one hand, this frees you to do anything the language doesn't support, including
accessing const/var/data from outside the block (as ***PLASM*** doesn't do anything to mangle names so you can
use
then 1-1). On the other hand, any assembly syntax errors won't get caught until invoking the assembler.

