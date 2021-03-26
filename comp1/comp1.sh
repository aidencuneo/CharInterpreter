# See code_styling.txt for code styling information

# Injections:
# (/examples/memory.sh)
Fs0@c=A0>;Fg<=A0@c=B$@-1+=C0=D0=E$@-2+@s$B-1+=B$Br1$A--!?1=D;(1:-1+=c$D?$c?$@-1+=S$C@s$c>$S@s$C1=C;;$c!?$D?1=E;$D!?$B-1+=B$Br1$A--!?1=D;;;$@-2+@s$@?$E!?(1;;;$C@s;Fd<=A0@c=B$@-1+=C0=D0=E$@-2+@s$B-1+=B$Br1$A--!?1=D;(1:-1+=c$D?$c?<0ff2r12************-1+>;;$c!?$D?1=E;$D!?$B-1+=B$Br1$A--!?1=D;;;$@-2+@s$@?$E!?(1;;;$C@s;

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
        $c r1 '~' < -- !? # $c r1 a -- !?
            0=o
        ;

        # Set n back to 0
        0=n

        # Debugging
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
    $c r1 '~' < -- !?
        1=n
    ;

    # If this character is a newline character (\n), then append the current
    # operator to the end of the output (if there is one)

    $c r1 a -- !?
        # Only append the operator if operator appending is allowed
        $i !?
            $o ? $o > ;
        ;
        # If operator appending is disabled, enable it now
        $i ?
            0=i
        ;
    ;

    # If this character is not a special character, append it to the end of
    # the output (as long as it isn't 0)
    $c r1 '~' < -- ?
    $c        ?
        $c >
    ;;

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
';s@C$;;;1(?!E$?@$s@+2-@$;;;D=1?!--A$1rB$B=+1-B$?!D$;E=1?D$?!c$;;>+1-************21r2ff0<?c$?D$c=+1-:1(;D=1?!--A$1rB$B=+1-B$s@+2-@$E=0D=0C=+1-@$B=c@0A=<dF;s@C$;;;1(?!E$?@$s@+2-@$;;;D=1?!--A$1rB$B=+1-B$?!D$;E=1?D$?!c$;;C=1C$s@S$>c$s@C$S=+1-@$?c$?D$c=+1-:1(;D=1?!--A$1rB$B=+1-B$s@+2-@$E=0D=0C=+1-@$B=c@0A=<gF;>0A=c@0sF'
< : . < ;
a. # Newline

[ :
    .
    [
;
