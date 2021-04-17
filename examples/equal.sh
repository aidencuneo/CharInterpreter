# This is something that has never been easily doable in the past!
# This program will take two strings as input and check if they are equal (==)
# to each other. That is, check if they contain exactly the same bytes in
# exactly the same order before their null byte terminators.

# Save pointer to first string
'' 1 R1

# Print string
0 m :
    P
    r0 1 R0 m
;

# Take first string, suffixing with a null byte
, :
    M
    ,
;

# Save pointer to second string
'' 1 R2

# Take second string, suffixing with a null byte
, :
    M
    ,
; M

# Equal? (Starts true)
1=E

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

# Print result
$E ?
    'true' C
;

$E !?
    'false' C
;

0aP
