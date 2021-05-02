TR(1)                                                                   User Commands                                                                  TR(1)

NNAAMMEE
       tr - translate or delete characters

SSYYNNOOPPSSIISS
       ttrr [_O_P_T_I_O_N]... _S_E_T_1 [_S_E_T_2]

DDEESSCCRRIIPPTTIIOONN
       Translate, squeeze, and/or delete characters from standard input, writing to standard output.

       --cc, --CC, ----ccoommpplleemmeenntt
              use the complement of SET1

       --dd, ----ddeelleettee
              delete characters in SET1, do not translate

       --ss, ----ssqquueeeezzee--rreeppeeaattss
              replace each sequence of a repeated character that is listed in the last specified SET, with a single occurrence of that character

       --tt, ----ttrruunnccaattee--sseett11
              first truncate SET1 to length of SET2

       ----hheellpp display this help and exit

       ----vveerrssiioonn
              output version information and exit

       SETs are specified as strings of characters.  Most represent themselves.  Interpreted sequences are:

       \NNN   character with octal value NNN (1 to 3 octal digits)

       \\     backslash

       \a     audible BEL

       \b     backspace

       \f     form feed

       \n     new line

       \r     return

       \t     horizontal tab

       \v     vertical tab

       CHAR1-CHAR2
              all characters from CHAR1 to CHAR2 in ascending order

       [CHAR*]
              in SET2, copies of CHAR until length of SET1

       [CHAR*REPEAT]
              REPEAT copies of CHAR, REPEAT octal if starting with 0

       [:alnum:]
              all letters and digits

       [:alpha:]
              all letters

       [:blank:]
              all horizontal whitespace

       [:cntrl:]
              all control characters

       [:digit:]
              all digits

       [:graph:]
              all printable characters, not including space

       [:lower:]
              all lower case letters

       [:print:]
              all printable characters, including space

       [:punct:]
              all punctuation characters

       [:space:]
              all horizontal or vertical whitespace

       [:upper:]
              all upper case letters

       [:xdigit:]
              all hexadecimal digits

       [=CHAR=]
              all characters which are equivalent to CHAR

       Translation  occurs  if  --dd is not given and both SET1 and SET2 appear.  --tt may be used only when translating.  SET2 is extended to length of SET1 by
       repeating its last character as necessary.  Excess characters of SET2 are ignored.  Only [:lower:] and [:upper:] are guaranteed to expand in  ascend‐
       ing order; used in SET2 while translating, they may only be used in pairs to specify case conversion.  --ss uses the last specified SET, and occurs af‐
       ter translation or deletion.

AAUUTTHHOORR
       Written by Jim Meyering.

RREEPPOORRTTIINNGG BBUUGGSS
       GNU coreutils online help: <https://www.gnu.org/software/coreutils/>
       Report any translation bugs to <https://translationproject.org/team/>

CCOOPPYYRRIIGGHHTT
       Copyright © 2020 Free Software Foundation, Inc.  License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
       This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law.

SSEEEE AALLSSOO
       Full documentation <https://www.gnu.org/software/coreutils/tr>
       or available locally via: info '(coreutils) tr invocation'

GNU coreutils 8.32                                                       March 2020                                                                    TR(1)
