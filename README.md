# CalculatorLanguageCompiler
A simple calculator language and its compiler.

Language syntax is the following :
```
integer * [let var1 = ?]{ var1 + integer + [let var2 = integer, var3 = ?]{ var2 - var3} };  
```

Where :  
&nbsp;&nbsp;&nbsp;● Integer is any integer number  
&nbsp;&nbsp;&nbsp;● To declare a variable you have to write [let <variable_name> = ? or integer], where if ? is present it'll let you insert dyamically any integer.  
&nbsp;&nbsp;&nbsp;● After a declaration there has to be an operation on the variable inside {}  
&nbsp;&nbsp;&nbsp;● There can be annidated variables declaration  
&nbsp;&nbsp;&nbsp;● Variables with the same name will always refer to their nearest declaration inside {}  
  
    
The corrispettive compiler was built using Flex and Bison under a Linux environment.
The compiler executable is already built.    

