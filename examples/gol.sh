# Game of Life
#
# Author: Aiden Blishen Cuneo
# (Only this implementation, Game of Life was invented by John Conway)

05=w # Width (42) # aaaa2
     # Height will be infinite

# fun display
Fd
    0aP # Leading newline

    < : # Loop over the game board, which is stored in the stack
        =p
        $p -1+ !?
            ' ' <P
        ;
        $p -2+ !?
            'O' <P
        ;
        <
    ;

    0aP # Trailing newline
;

' :htdiW'
$w p
0aP

Fd
