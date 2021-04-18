# See code_styling.txt for code styling information

# fun compile_line 1
Fx
    # Save this string
    < =S

    # Trim spaces from the start of the string
    $S m R0 0ff2 -- !:
        $S 1 =S
        $S m R0 0ff2 -- !
    ;

    # If this string starts with '#', skip the whole thing
    $S m R0 0ff5 -- !?
        # Increment pointer until it reaches the end of this string
        $S m :
            $S 1 =S $S m
        ;
    ;

    # Compare this string with each of the saved strings

    # 'push'
    $S > rA > F= ?
        # ')'
        0ffb M
    ;

    # 'pop'
    $S > rB > F= ?
        # '<'
        0ffff M
    ;

    # 'if'
    $S > rC > F= ?
        # '?'
        0ffff3 M
    ;

    # 'while'
    $S > rD > F= ?
        # ':'
        0fffd M
    ;

    # 'end'
    $S > rE > F= ?
        # ';'
        0fffe M
    ;

    # 'memadd'
    $S > rF > F= ?
        # 'M'
        0fffff2 M
    ;

    # 'memget'
    $S > rG > F= ?
        # 'm'
        0fffffff4 M
    ;

    # 'print '
    $S > rH > Fs ?
        # 'print d'
        $S 6 m R0 0ffffffa -- !?
            # 'p'
            0fffffff7 M
        ;

        # 'print c'
        $S 6 m R0 0ffffff9 -- !?
            # 'P'
            0fffff5 M
        ;

        # 'print s'
        $S 6 m R0 0fffffffa -- !?
            # 'm'
            0fffffff4 M
            # 'P'
            0fffff5 M
        ;
    ;

    # 'println '
    $S > rI > Fs ?
        # 'println d'
        $S 8 m R0 0ffffffa -- !?
            # 'p'
            0fffffff7 M
        ;

        # 'println c'
        $S 8 m R0 0ffffff9 -- !?
            # 'P'
            0fffff5 M
        ;

        # 'println s'
        $S 8 m R0 0fffffffa -- !?
            # 'm'
            0fffffff4 M
            # 'P'
            0fffff5 M
        ;

        # println is exactly the same as print, but `>aP<` is pushed to the
        # end to suffix a newline

        # '>'
        0ffff2 M
        # 'a'
        0ffffff7 M
        # 'P'
        0fffff5 M
        # '<'
        0ffff M
    ;

    # 'memset'
    $S > rJ > F= ?
        # 'm'
        0fffffff4 M
        # 'S'
        0fffff8 M
    ;

    # 'set'
    $S > rK > Fs ?
        # '0'
        0fff3 M
        # Add the number after 'set ' (including the space)
        # (convert to integer, then save as a Char num)
        # 'set num'
        $S 4 > FI > Fi
    ;

    # 'ch'
    $S > rL > Fs ?
        # '0'
        0fff3 M
        # Add the number after 'ch ' (including the space)
        # (as a Char num)
        # 'ch num'
        $S 3 m > Fi
    ;

    # 'add'
    $S > rM > Fs ?
        # Add the expression after 'add ' (including the space)
        # 'add num'
        $S 4 > FX
    ;

    # 'sub'
    $S > rN > Fs ?
        # '-'
        0fff M
        # Add the number after 'sub ' (including the space)
        # (convert to integer, then save as a Char num)
        # 'sub num'
        $S 4 > FI > Fi
        # '+'
        0ffd M
    ;

    # 'mul'
    $S > rO > Fs ?
        # '*'
        0ffc M
        # '0'
        0fff3 M
        # Add the number after 'mul ' (including the space)
        # (convert to integer, then save as a Char num)
        # 'mul num'
        $S 4 > FI > Fi
        # '+'
        0ffd M
    ;

    # 'div'
    $S > rP > Fs ?
        # '>'
        0ffff2 M
        # Add the number after 'div ' (including the space)
        # (convert to integer, then save as a Char num)
        # 'div num'
        $S 4 > FI > Fi
        # 'R'
        0fffff7 M
        # '0'
        0fff3 M
        # '<'
        0ffff M
        # '//'
        0fff2 MM
    ;

    # 'exit'
    $S > rQ > F= ?
        # 'q'
        0fffffff4 M
    ;

    # 'setvar'
    $S > rR > Fs ?
        # '='
        0ffff1 M
        # Add the letter after 'setvar ' (including the space)
        $S 7 m M
    ;

    # 'setreg'
    $S > rS > Fs ?
        # 'R'
        0fffff7 M
        # Add the letter after 'setreg ' (including the space)
        $S 7 m M
    ;

    # 'getvar'
    $S > rT > Fs ?
        # '$'
        0ff6 M
        # Add the letter after 'getvar ' (including the space)
        $S 7 m M
    ;

    # 'getreg'
    $S > rU > Fs ?
        # 'r'
        0fffffff9 M
        # Add the letter after 'getreg ' (including the space)
        $S 7 m M
    ;

    # 'define'
    $S > rV > Fs ?
        # 'F'
        0ffffa M
        # Add the letter after 'define ' (including the space)
        $S 7 m M
    ;

    # 'call'
    $S > rW > Fs ?
        # Function calling differs from function defining in that the pointer
        # is saved to the stack and retrieved from the stack before and after
        # function calling, respectively.

        # '>'
        0ffff2 M
        # 'F'
        0ffffa M
        # Add the letter after 'call ' (including the space)
        $S 5 m M
        # '<'
        0ffff M
    ;

    # 'ptr'
    $S > rX > Fs ?
        # Define a pointer to an array of ints with a length equal to this
        # instruction's argument

        # 'm'
        0fffffff4 M
        # 's'
        0fffffffa M
        # '>'
        0ffff2 M

        # Add the number after 'ptr ' (including the space)
        # Also add one to that number, because the pointer should have the
        # length specified, plus a null byte at the end
        $S 4 > FI 1 > Fi

        # ':'
        0fffd M

        # '>'
        0ffff2 M
        # 'M'
        0fffff2 M
        # '<'
        0ffff M

        # '-'
        0fff M
        # '1'
        0fff4 M
        # '+'
        0ffd M
        # ';'
        0fffe M

        # '<'
        0ffff M
    ;

    # "'" || '"'
    $S m R0 0ff9 -- ! >
    $S m R0 0ff4 -- ! R0 < | ?
        # Save starting quote to put at the end
        $S m >

        $S m :
            $S m M
            $S 1 =S $S m
        ;

        # Fetch starting quote to put at the end of this string, as long as the
        # string hasn't already been ended
        # (Ending quotes are optional)
        $S -1+ m R0 ( -- ?
            < M
        ;
    ;

    # Increment pointer until it reaches the next string in the list
    $S m :
        $S 1 =S $S m
    ;

    # Push new string pointer (+1) back into the stack
    $S 1 >
;

# fun compile_expression 1
    # Get pointer to expression and save it
    <=A

    # If first letter is a digit, convert to int and push value as a Char num
    # A > 47 && A < 58
    0fff2 R0 $A m } >
    0fffd R0 $A m { R0 < & ?
        
    ;
;

# fun strcmp 2
F=
    # Save both string pointers to r1 and r2
    < R1
    < R2

    # Equal? (Starts true)
    01=E

    # Compare string equality
    r1 m R0
    r2 m & :
        # If !equal
        r1 m R0
        r2 m -- ?
            # Set unequal
            0=E
        ;

        r1 1 R1 m R0
        r2 1 R2 m &
    ;

    # If either string still has bytes remaining, set unequal
    r1 m ?
        0=E
    ;
    r2 m ?
        0=E
    ;

    $E
;

# fun startswith 2
Fs
    # r1 is prefix
    # r2 is string to check prefix against

    # Save both string pointers to r1 and r2
    < R1
    < R2

    # Equal? (Starts true)
    01=E

    # Compare string equality
    r1 m :
        # If !equal
        r1 m R0
        r2 m -- ?
            # Set unequal
            0=E
        ;

        # Increment pointers
        r1 1 R1
        r2 1 R2

        r1 m
    ;

    # Stop at the end of the shortest string because this function is only
    # checking whether a string starts with another

    $E
;

# fun push_int_as_charnum 1
Fi
    # Push an integer into compiled data as a Char num
    # Example: 32 -> ff2

    <=A

    # While num > 14
    0e R0 $A } :
        # Add 'f' to compiled data
        0ffffffc M

        # num -= 15
        $A -f+ =A
    
        # While num > 14
        0e R0 $A }
    ;

    # Now check the remaining value and add the final character

    # 14 -> 'e'
    $A -e+ !?
        # Add 'e' to compiled data
        0ffffffb M
    ;

    # 13 -> 'd'
    $A -d+ !?
        # Add 'd' to compiled data
        0ffffffa M
    ;

    # 12 -> 'c'
    $A -c+ !?
        # Add 'c' to compiled data
        0ffffff9 M
    ;

    # 11 -> 'b'
    $A -b+ !?
        # Add 'b' to compiled data
        0ffffff8 M
    ;

    # 10 -> 'a'
    $A -a+ !?
        # Add 'a' to compiled data
        0ffffff7 M
    ;

    # For any remaining numbers, simply add '0' (48) and append to compiled data

    # If num < 10
    # (make sure num isn't 0)
    0a R0 $A { R0
    $A & ?
        # Add '0' (48) to number and add to compiled data
        $A fff3 M
    ;
;

# fun toint 1
FI
    # Convert a string pointer to an integer

    # Multiplier
    01=M

    # Pointer
    <=A

    # Result num
    0=B

    # Start pointer
    $A=C

    # Increment A until a null byte is reached
    $A m :
        $A 1 =A
        $A m
    ;

    # Decrement A once
    $A -1+ =A

    # While A > C - 1 (A >= C)
    $C -1+ R0 $A } :
        # B += (*A - '0') * M
        $A m -fff3+ R0 $M ** R0 $B ++ =B

        # M *= 10
        $M R0 0a ** =M

        # Decrement A
        $A -1+ =A

        # Loop condition
        $C -1+ R0 $A }
    ;

    $B
;

# Get argc and argv
@

# Clear first two arguments (keep argc in $v)
<=v
<<

# Open file (third argument)
< o

# If the file wasn't opened properly (ptr != 0), stop the code execution
? q ;

# Save a whole heap of strings for later
'push'     RA
'pop'      RB
'if'       RC
'while'    RD
'end'      RE
'memadd'   RF
'memget'   RG
'print '   RH
'println ' RI
'memset'   RJ
'set '     RK
'ch '      RL
'add '     RM
'sub '     RN
'mul '     RO
'div '     RP
'exit'     RQ
'setvar '  RR
'setreg '  RS
'getvar '  RT
'getreg '  RU
'define '  RV
'call '    RW
'ptr '     RX

# Pointer to tokenised code
ms >

# Number of lines tokenised (starts at 1)
1=i

# Tokenisation
, :
    # Save current character into c
    =c

    $c P

    # Replace newlines with null bytes
    $c R0 0a -- !?
        0 M
        # Increment line count
        $i 1 =i
    ;

    # Push all other characters into memory as normal
    $c R0 0a -- ?
        $c M
    ;

    # Get next character
    ,
;

# Push null byte to signify the end of the final string
0 M

# Pointer to compiled data
ms Ra

# Compilation
$i :
    # Compile this string
    Fx

    # Decrement counter
    $i -1+ =i $i
;

# Suffix compiled data with a null byte
0 M

0aP

# Set file descriptor to the output file
'output.txt' # File name
O # Open the file for writing

# Write text to file
'# Program compiled with CharInterpreter/comp2/comp2.sh' m.

# Newline
0a.

# Write compiled data to file
ra m.

# Newline
0a.

# [ :
#     .
#     [
# ;
