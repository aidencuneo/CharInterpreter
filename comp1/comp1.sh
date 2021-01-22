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

# Current operator
0=o

# (bool) next character will become the new operator
0=n
# (bool) don't append the current operator at the next newline
0=i

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

    # $c > 1 > FP

    # If n is not 0, then this character becomes the new operator, and n gets
    # set back to 0
    $n ?
        $c=o

        # If this character is a tilde (~), set the operator back to 0
        '~' $c -- !? # a > $c -- !?
            0=o
        ;

        # Set n back to 0
        0=n
        # ' :rotarepo wen eht won si retcarahc sihT' 0aaaa > Fp
        # $o P 0aP

        # Set the current character to 0 so that the other if statements in
        # here don't interfere with what this if statement is doing
        0=c

        # Don't append the current operator at the next newline
        1=i
    ;

    # If this character is a tilde (~), then the character afterwards will
    # become the new operator, so set n to 1
    '~' $c -- !?
        # 'puY' 3 > FP
        1=n
    ;

    # If this character is a newline character (\n), then append the current
    # operator to the end of the output (if there is one)

    $i        !? # Make sure this is allowed
    $c > a -- !?
    $o         ?
        $o >
    ;;;

    # If this character is not a special character, append it to the end of
    # the output (as long as it isn't 0)
    '~' $c -- ?
    $c        ?
        $c >
    ;;

    # If operator appending is disabled, enable it again
    $i ? 0=i ;

    # Get next character
    ,
;

'eeeedoC' 07 > FP

[ :
    P
    [
;

0aP
