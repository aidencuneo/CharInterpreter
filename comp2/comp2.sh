# See code_styling.txt for code styling information

# Injections:
# (/examples/functions.sh)
Fw0=A<=C$C!?>1=A<;$C-ff2+!?>1=A<;$C-9+!?>1=A<;$C-a+!?>1=A<;$C-a3+!?>1=A<;$C-a1+!?>1=A<;$C-a2+!?>1=A<;;

# fun printf 1 *
Fp
    <=A
    $A :
        < P
        $A -1+ =A $A
    ;
;

# fun println 1 *
FP
    Fp
    0aP
    0
;

# Last character
0=l

# Get argc and argv
@

# Clear first two arguments (keep argc in $v)
<=v
<:<;
<:<;

# Open file
$@ o

# If the file wasn't opened properly (ptr != 0), stop the code execution
? q ;

, :
    # Save current character into c
    =c

    $c P

    # If last == '<' and c == '<'
    $l r1 '<' < -- !?
    $c r1 '<' < -- !?
        'ihhh' <P<P<P<P

        # Reset the last character
        0=l
    ;;

    $c=l

    # Get next character
    ,
;

# Set file descriptor to the output file
'txt.tuptuo' # File name
0a     # Length of file name
O      # Open the file for writing

# Write text to file
0 > # Null byte
# (See /examples/memory.sh for this code)
'<'
< : . < ;
a. # Newline

[ :
    .
    [
;
