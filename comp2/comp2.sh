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
            P
            $S 1 =S $S m
        ;
    ;

    # Compare this string with each of the saved strings

    # 'push'
    $S > rA > F= ?
        # Add ')' to compiled data
        0ffb M
    ;

    # 'pop'
    $S > rB > F= ?
        # Add '<' to compiled data
        0ffff M
    ;

    # 'if'
    $S > rC > F= ?
        # Add '?' to compiled data
        0ffff3 M
    ;

    # 'while'
    $S > rD > F= ?
        # Add ':' to compiled data
        0fffd M
    ;

    # 'end'
    $S > rE > F= ?
        # Add ';' to compiled data
        0fffe M
    ;

    # 'memadd'
    $S > rF > F= ?
        # Add 'M' to compiled data
        0fffff2 M
    ;

    # 'memget'
    $S > rG > F= ?
        # Add 'm' to compiled data
        0fffffff4 M
    ;

    # 'printd'
    $S > rH > F= ?
        # Add 'p' to compiled data
        0fffffff7 M
    ;

    # 'printc'
    $S > rI > F= ?
        # Add 'P' to compiled data
        0fffff5 M
    ;

    # 'printf'
    $S > rJ > F= ?
        # Add 'm' to compiled data
        0fffffff4 M
        # Add 'P' to compiled data
        0fffff5 M
    ;

    # 'set'
    $S > rK > Fs ?
        # Add '0' to compiled data
        0fff3 M
        # Add the number after 'set ' (including the space) to compiled data
        # 'set num'
        $S 4 m M
    ;

    # 'ch'
    $S > rL > Fs ?
        # Add '0' to compiled data
        0fff3 M
        # Add the number after 'ch ' (including the space) to compiled data
        # (as a Char num)
        # 'ch num'
        $S 3 m > Fi
    ;

    # 'add'
    $S > rM > Fs ?
        # Add the number after 'add ' (including the space) to compiled data
        # 'add num'
        $S 4 m M
    ;

    # 'sub'
    $S > rN > Fs ?
        # Add '-' to compiled data
        0fff M
        # Add the number after 'sub ' (including the space) to compiled data
        # 'sub num'
        $S 4 m M
        # Add '+' to compiled data
        0ffd M
    ;

    # Increment pointer until it reaches the next string in the list
    $S m :
        P
        $S 1 =S $S m
    ;

    # Push new string pointer (+1) back into the stack
    $S 1 >
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
    < mP R1
    < mP R2
    0aP

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
    $A R0 # (make sure num isn't 0)
    0a R0 $A {
    & ?
        # Add '0' (48) to number and add to compiled data
        $A fff3 M
    ;
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
'push'   RA
'pop'    RB
'if'     RC
'while'  RD
'end'    RE
'memadd' RF
'memget' RG
'printd' RH
'printc' RI
'printf' RJ
'set '   RK
'ch '    RL
'add '   RM
'sub '   RN

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
