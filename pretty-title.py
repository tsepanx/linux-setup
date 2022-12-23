#!/usr/bin/env python3

######################################################################
# ------------------------   SOME WORDS   -------------------------- #
######################################################################

s = input()

def main(s, l=80, mg=6, upper=True):
    bd = lambda x: f'# {x * "-"}{mg}'    

    cnt = l - ( len(s) + mg * 2 + 4 )
    cnt //= 2

    up = '#' * l
    dn = '#' * l

    mg = mg * ' '
    title = s.upper() if upper else s

    lb = bd(cnt)
    rb = bd(cnt + int(len(s) % 2))[::-1]

    mid = lb + title + rb 

    return '\n'.join([up, mid, dn])

print(main(s))
