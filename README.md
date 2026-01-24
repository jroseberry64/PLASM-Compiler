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

* More data types. The initial design choice was to limit data types to strings and native 8-bit size variables. But, after deciding it would be convenient to add pointers to the language I realized that it's not as hard to optimize 16-bit arithmetic/comparisons due to the expression evaluation limitations I decided to enforce, I just haven't finished fully implementing data type declarations and all the code generation that handles multi-byte operations.

* Better configuration options. I overlooked some configuration possibilities when it comes to dealing with what character set the target machine uses (ASCII vs PETSCII mostly) and in order to not break things I (temporarily) removed native string/char support pending command line options/inline compiler directives to deal with this. You are still capable of declaring strings in an assembly file and there's a mechanism to tell the compiler that's what you're doing, but this workaround is only temporary. The Beta version will also include a feature that allows you to tell the compiler you're using this file as a "main" file so it can add more boilerplate to the .asm file, but for now the default behavior is to assume the user will provide their own assembly file to act as the "main" program file.

* A few other keywords/features to the language and backend optimization passes to the IR to fix things like condensing redundant labels or folding a series of JMP instructions into 1 JMP, telling the compiler it's allowed to perform a tail call, and a few other unnecessary instructions it occasionally generates because the front end can only make so many assumptions. I really wanted to wait to tackle this until I am satisfied that I've added all the language features and there's nothing more I can do in the front end to optimize the IR it outputs. Also, there are a few situations where the compiler doesn't correctly swap a branch instruction for a jump that needs to fixed. 

* A dash of syntactic sugar to make writing some expressions shorter

* Support for more assembler back ends. Currently, only CA65/CL65 assembly format is supported.

* Uploading the source code. I'd prefer to do some more refactoring/cleanup before sharing the C source.

* Better Error messages 

## Installation
The PLASM compiler doesn't have any dependencies besides having the desired assembler backend installed. 

### Windows
There's not much to do other than unzipping the executable.

### MacOS/Linux
MacOS might require you to go to the settings to allow the executable to run.
Linux might require `chmod` to change the file permissions.

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

One thing to note is while PLASM doesn't have any explicit syntax for declaring/passing arguments to procedures there's nothing stopping you from using local/global variables and/or registers to pass arguments to the procedure or return as many values as you want.

### Register/Flag Access
PLASM allows access to registers/flags as psuedo-variables inside statements or expressions.

#### 6502 Registers/Flags
* Accumulator (A) Register: `%A`
* X Index (X) Register: `%X`
* Y Index (Y) Register: `%Y`
* Negative (N) Flag: `%NF`
* Overflow (V) Flag: `%VF`
* Zero (Z) Flag: `%ZF`
* Carry (C) Flag: `%CF`

NOTE: At this point the compilers only recognizes 6502 registers, but as more processors are added to the back end the compiler will recognize registers based on the target CPU.

### `mem` Keyword
PLASM provides a similar concept to BASIC's `PEEK`/`POKE` with the `mem[]` keyword. 

`mem[]` acts as a psuedo variable that allows you to treat memory like a giant array so you can load/store variables/data from anywhere in memory.

### Statements

#### `;` In PLASM VS C
In C, `;` is considered a statement _terminator_. In PLASM, `;` is a statement _seperator_ which means it's just used to tell where one statement ends and another begins.

####`begin`...`end` Statement Blocks
Unlike other C-like languages, PLASM doesn't utilize `{...}` to organize blocks of code. Instead, the keywords `begin...end` are used.

#### Assignment Statements
The `:=` symbol acts as the assignment operator for PLASM. 

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

PLASM only supports the native bitwise/mathematical operations of the CPU, so for the 6502 this means only addition, subraction, Logical AND/OR/EOR, shift/rotate left/right, and increment/decrement expressions are supported. 

Also note that addition, subtraction, and logical AND/OR/EOR can only be performed as binary operations, meaning:

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

Remember, any input/output to procedures must be handled manually, so it's not possible to assign the result of a procedure call to a variable. 

#### Comparison/Conditional Operators
PLASM supports the following operators:

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
It should be noted that only one comparison or condition operator may be used per conditional statement (i.e. there's currently no support for Boolean AND/OR/NOT to combine conditional statments)

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
PLASM makes no attempt to do anything with assembly inlined between `asm {...} end` blocks but copy and paste it to the final assembly output. So, in that sense, this is another place where PLASM punts any validation to the target assembler. On the one hand, this frees you to do anything the language doesn't support, including accessing const/var/data from outside the block (as PLASM doesn't do anything to mangle names so you can use then 1-1). On the other hand, any assembly syntax errors won't get caught until invoking the assembler.
