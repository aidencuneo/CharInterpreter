# See code_styling.txt for code styling information

# fun memset : 1
Fs
    $n =A # Return the old number of objects in memory, because this number
          # will become the memory index of the added memory
    # Add one to the number of objects in memory
    $n 1 =n
    # Add a null byte to the end of the stack
    0 >
;

# fun memget 1 : 1
Fg
    <=A # Memory index to search for
    $n=B # Current memory index
    $@ -1+ =C # Old stack top

    0=D # (bool) Found the right memory index?
    0=E # (bool) Break the loop now?

    # This loop won't pop from the stack at any point in time, it will only
    # decrement the stack's top until it reaches 0, then it will return the
    # stack's top back to what it was before

    # Decrement the stack's top to begin with (to get past the first null byte)
    $@ -2+ @s
    # Also decrement current memory index to account for the line above
    $B -1+ =B

    ( 1 :
        # Do a fancy thing to prevent the loop from stopping at 0
        -1+
        =c

        # $c p 0aP

        # $B p
        # 0aaa2 P
        # $A p
        # 0aP

        # If this is the right memory object, then retrieve it
        $D ?
        $c ? # (only if this character isn't 0)
            $c P
        ;;

        # If 0 was found
        $c !?
            # If the right memory index has already been found, then this 0
            # should break the loop
            $D ?
                1=E
            ;

            # Otherwise, continue searching
            $D !?
                # Decrement current memory index
                $B -1+ =B

                # If current memory index is equal to the index to search for, then
                # this is the right object
                $B r $A -- !?
                    1=D
                ;
            ;
        ;

        # Decrement stack top by 1
        $@ -2+ @s

        # Do a fancy thing to prevent the loop from stopping at 0 (as long as
        # the stack length isn't 0 AND the loop isn't mean to break now)
        $@ ?
        $E !?
            ( 1
        ;;
    ;

    # Reset the stack's top to the old stack top
    $C @s

    # 'ecin' <P<P<P<P
    # 0aP
;

0=n # Number of objects in memory

'olleh' Fs $A p
0aP
'ooolleh' Fs $A p
0aP
"ereh osla m'I" Fs $A p
0aP
"em tuoba tegrof t'noD" Fs $A p
0aP
'iiih' Fs $A p
0aP

# Get the array back
# 00 > Fg '|' <P
# 0aP
# 01 > Fg '|' <P
# 0aP
# 02 > Fg '|' <P
# 0aP
03 > Fg '|' <P
0aP
04 > Fg '|' <P
0aP

0 -1+ ]

< 1 :
    -1+
    P
    < 1
;

0aP
