# PLASM High Level Overview
PLASM is lightweight programming language for retro computing platforms that's designed around being able to integrate seamlessly with existing assembly code. Currently it only targets the 6502 but the long term goal is to not just extend it to the 65C02 and 65816 but also to the 8080, Z80, Gameboy Z80, as well as other retro 8/16/32 bit CPUs.

## Why The Name PLASM?
PLASM stands for **PL/0** + **Assembly**

* **PL/0**: the basis of the language's syntax is PL/0 (Pascal's less capable cousin) with some additional syntax borrowed from Super Pascal for the Commodore 64 and a little bit from C.
* **Assembly**: one of the major design goals was to make it seamless to integrate PLASM code with pre-existing assembly code.

## Design Philosophy
With that being said, I want to emphasize that when I say PLASM is a lightweight language that's really shorthand for saying it's a programming language that behaves more like a really fancy assembler front end. 

By that I mean the language has the bare minimum functionality necessary to be considered a "programming language." 

But, rather than try to add every flavor of syntactic sugar under the sun and bang my head against the wall trying to optimize the result, I heavily restricted some features of the language while also adding lower level features not typically found in a modern language in order to make it as easy as possible for the compiler to output effecient code. 

The idea is to provide just enough of a language that it's faster and less error prone than writing pure assembly code, but with the capability of freely inlining assembly anywhere to achieve anything the language doesn't provide out of the box. 

In fact, it's very possible to use the language as a thin wrapper around assembly code just using the compiler to help with organizing variables/data/subroutines. 

Also, to make it easy integrating pre-written assembly code the compiler stops at generating assembly files formatted to target one of the popular assembler choices that already exists (CA65/KickAssembler for the 6502) for the target CPU. The compiler also only handles a single file at a time, though there are methods provided to access variables/routines outside the file.

## State Of The Compiler
I'll address one more thing before moving on to the nuts and bolts of the language.

Right now the compiler executable achieves all the basic goals I started out with but is a few features short of being a full Beta version of the compiler. At a high level what still needs to be added is:

* More types. The initial design choice was to limit data types to strings and native 8-bit size variables. But, after deciding it would be convenient to add pointers to the language I realized that it's not as hard to optimize 16-bit arithmetic/comparisons due to the expression evaluation limitations I decided to enforce, I just haven't finished fully implementing data type declarations and all the code generation that handles multi-byte operations.

* Better configuration options. I overlooked some configuration possibilities when it comes to dealing with what character set the target machine uses (ASCII vs PETSCII mostly) and in order to not break things I (temporarily) removed native string/char support pending command line options/inline compiler directives to deal with this. You are still capable of declaring strings in an assembly file and there's a mechanism to tell the compiler that's what you're doing, but this workaround is only temporary. The Beta version will also include a feature that allows you to tell the compiler you're using this file as a "main" file so it can add more boilerplate to the .asm file, but for now the default behavior is to assume the user will provide their own assembly file to act as the "main" program file.

* A few other keywords/features to the language and backend optimization passes to the IR to fix things like condensing redundant labels or folding a series of JMP instructions into 1 JMP, telling the compiler it's allowed to perform a tail call, and a few other unnecessary instructions it occasionally generates because the front end can only make so many assumptions. I really wanted to wait to tackle this until I am satisfied that I've added all the language features and there's nothing more I can do in the front end to optimize the IR it outputs.

* A dash of syntactic sugar to make writing some expressions shorter

* Support for more assembler back ends. Currently, only CA65/CL65 assembly format is supported.

* Uploading the source code. I'd prefer to do some more refactoring/cleanup before sharing the C source.

## Usage
Right now the compiler operates under the assumption that the executable is in the same directory as the code it's compiling (as I don't think anyone wants to install the alpha version that's going to have more features added). All OS versions utilize the command line to invoke the compiler.

The only two command line arguments at present are

* "filename.pl0": the file to compile
* "outfilename": this is the name that will be used to create the .asm files associated with the .pl0 file

### Windows
`
./plasm.exe filename.pl0 outfilename
`
### Linux/MacOS
`
./plasm filename.pl0 outfilename
`

# PLASM Language

Note that any of the following sections marked with \* are subject to updates as features are added to the compiler.

## Reserved Keywords\*
`
const
var
data
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

## PLASM Program Structure
PLASM programs have the following structure and declaration order:

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
Note that anything with '+' is optional and '\*' is only required if you don't use the `%unit` compiler directive at the beginning of the program.

### Comments
Comments in PLASM begin with '{' and are terminated by '}'.

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

The current default behavior at the moment is to add all globa/local constants found by the compiler to a seperate `.inc` file so they can be included in other `.asm` files as needed.

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

Note that the compiler assumes any external identifier you provide exists somewhere and punts verifying that to the target assembler. 

### A Quick Note About Var/Data Distinction For 6502 Family Only
It should be noted that the only reason the difference between variables and data exists in PLASM is to account for the Zero Page when targetting 6502 platforms. Data is for anything that doesn't need to take up Zero Page space (like arrays) while only Variables can be pure pointers (to take advantage of the .Y index register) and you can't declare an array inside a `var` block.


### Declaring Variables
Variables are declared in a similar manner to constants, except that no value is assigned at the time of declaration. 

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
