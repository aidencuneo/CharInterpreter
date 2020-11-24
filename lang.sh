# Stack items are used as function arguments in
# the order that they are taken from the top of
# the stack

# Uppercase variables A, B, C, etc. are function
# return values

# The first item in the stack can be used to tell
# a particular function how many arguments it will
# be receiving from the stack, if that function
# can receive an undefined amount

# Functions are stylised based on Quokka functions
# for readability, for example:
# fun name argmin argmax : retcount

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

# fun peek_index 1 : 1
# (Get the stack item with the given index)
F(
    0=A
    <=I

    $I=B
    $B :
        [ >
        $B -1+ =B $B
    ;

    [)=A

    $I+1=B
    $B :
        < ]
        $B -1+ =B $B
    ;
;

# fun pop_index 1 : 1
# (Pop the stack item with the given index)
F<
    0=A
    <=I

    $I=B
    $B :
        [ >
        $B -1+ =B $B
    ;

    [=A

    $I=B
    $B :
        < ]
        $B -1+ =B $B
    ;
;

# fun shuffle_index 1
# (Shuffle the stack so that all items starting
#  from 0 up until the given index are pushed
#  to the top)
Fs
    <=I

    $I=B
    $B :
        [ >
        $B -1+ =B $B
    ;
;

# fun to_int 1 : 1
Fi
    0=N
    1=B

    <=I
    $I :
        <=D
        $D > Fd $A ?
            $D
            '0'--
            > $B ** > $N ++ ) =N <
            # '0'++

            > $B > a** =B <  # base *= 10
        ;

        $I -1+ =I $I
    ;

    $N=A
;

# fun execute 1
Fx
    [=C
    $C # p >aP<

    # ' :rotarepo' a > Fp
    # $O p >aP<

    $C > Fd $A ?
        # 'REGETNI' 7 > FP
        $C ]
        $@ > Fi $A
        # p >aP<

        >  # Save number for later

        # If there is an operator in this line, use it
        $o > '+' F= $A ?
            $x ++ >
            =o  # Reset operator
        ;

        <=x
    ;
;

0=x  # First argument
0=y  # Second argument
0=o  # Operator (char)

# Get argc and argv
@

# Clear first two arguments (keep argc in $v)
<=v
<:<;
<:<;

# Open file
$@ o

, :
    =c $c

    # if isdigit(c)
    > Fd $A ? $c > ; # > Fw $A ! ? $c > ;

    # if c == '\n'
    $c > a > F= $A ?
        $c > Fx
        # $c=o
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
