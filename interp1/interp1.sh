# See code_styling.txt for code styling information

# fun isspace 1 : 1
Fw
    0=A
    <=C

    $C
    !? >1=A< ;  # '\0' (0)

    $C
    -ff2+
    !? >1=A< ;  # ' ' (32)

    $C
    -9+
    !? >1=A< ;  # '\t' (9)

    $C
    -a+
    !? >1=A< ;  # '\n' (10)

    $C
    -a3+
    !? >1=A< ;  # '\r' (13)

    $C
    -a1+
    !? >1=A< ;  # '\x0b' (11)

    $C
    -a2+
    !? >1=A< ;  # '\x0c' (12)
;

# fun isdigit 1 : 1
Fd
    0=R
    <=C

    $C > fff3 > F= $A ? >1=R< ;  # '0' (48)
    $C > fff4 > F= $A ? >1=R< ;  # '1' (49)
    $C > fff5 > F= $A ? >1=R< ;  # '2' (50)
    $C > fff6 > F= $A ? >1=R< ;  # '3' (51)
    $C > fff7 > F= $A ? >1=R< ;  # '4' (52)
    $C > fff8 > F= $A ? >1=R< ;  # '5' (53)
    $C > fff9 > F= $A ? >1=R< ;  # '6' (54)
    $C > fffa > F= $A ? >1=R< ;  # '7' (55)
    $C > fffb > F= $A ? >1=R< ;  # '8' (56)
    $C > fffc > F= $A ? >1=R< ;  # '9' (57)

    $R=A
;

# Get argc and argv
@

# Clear first two arguments (keep argc in $v)
<=v
<<

# Open file
$@ o

, :
    =c $c

    # if isdigit(c)
    > Fd $A ? $c > ; # > Fw $A ! ? $c > ;

    # if c == '\n'
    $c > a > F= $A ?

    ;

    # $c P

    # Operators
    $c > '+' F= $A ?
        $c=o
    ;

    # Actions
    $c > 'i' F= $A ?
        >$x p<
    ;

    $c > 'o' F= $A ?
        >$x p<
    ;

    $c > 'O' F= $A ?
        >$x P<
    ;

    ,
;

# >> FP
# $x p >> FP
# $y p >> FP
