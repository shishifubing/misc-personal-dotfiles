#!/usr/bin/env python

from os import environ as environment

def color(*colors: str = '', brackets: bool = False) -> str:
    
    start = "\[\e[" if brackets else "\e["
    end = "\]" if brackets else ''

    return f'{start}{";".join(colors)}m{end}'


def get_preexec_message() -> str:
    
    
    pass
