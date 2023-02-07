#!/usr/bin/env python3

######################################################################
# ------------------------   SOME WORDS   -------------------------- #
######################################################################

input_str = input()


def gen_string(
        s: str,
        l: int = 80,
        mg: int = 6,
        upper=True
) -> str:
    bd = lambda x: f'# {x * "-"}{mg}'

    cnt = l - (len(s) + mg * 2 + 4)
    cnt //= 2

    up = '#' * l
    dn = '#' * l

    mg = mg * ' '
    title = s.upper() if upper else s

    lb = bd(cnt)
    rb = bd(cnt + int(len(s) % 2))[::-1]

    mid = lb + title + rb

    return '\n'.join([up, mid, dn])


print(gen_string(input_str))
