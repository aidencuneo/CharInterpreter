# See code_styling.txt for code styling information

# fun printf 1 *
Fp
    <=A
    $A :
        <P
        $A -1+ =A $A
    ;
;

# fun println 1 *
FP
    Fp
    0aP0
;

# fun cmp_eq 2 : 1
F=
    <-- ! =A
;

# Current operator
0=o

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
    =c $c

    > 1 > FP
    'ereht olleH' a1 > FP

    ,
;
