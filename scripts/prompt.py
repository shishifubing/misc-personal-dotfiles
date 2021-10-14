from os import environ as env
from subprocess import (
        CompletedProcess as subprocess_CompletedProcess, 
        run as subprocess_run
        )
from typing import Union

def get_color(*colors: Union[str, int]) -> str:
        
    colors_string: str = ';'.join([
        str(color) for color in colors if color    
    ])
    return f'\033[{colors_string}m'

def run(command: str) -> 'subprocess_CompletedProcess':

    return subprocess_run(
            command,
            shell=True,
            check=False,
            universal_newlines=True,
    )

def print_row(*row_items: dict) -> None:
    """
    ::

        {
            'text': str,
            'foreground': Union[str, Any],
            'background': Union[str, Any]
        }
    """


    color_end = get_color(0)
    top = []
    middle = []
    bottom = [] 
    separator_vertical = '│'
    separator_horizontal = '─'
    separator_top_right = '┐'
    separator_top_left = '┌'
    separator_bottom_right = '┘'
    separator_bottom_left = '└'

    for item in row_items:
        text = item.get('text', '')
        foreground = item.get('foreground', '37')
        if foreground:
            foreground = (1, foreground)
        else:
            foreground = []
        background = item.get('background', '40')
        if background:
            background = (1, background)
        else:
            background = []
        color = get_color(*foreground, *background)
        
        top.append(
                color
                + separator_top_left
                + separator_horizontal * len(text)
                + separator_top_right
                + color_end
        )
        middle.append(
                color
                + separator_vertical
                + text
                + separator_vertical
                + color_end
        )
        bottom.append(
                color
                + separator_bottom_left
                + separator_horizontal * len(text)
                + separator_bottom_right
                + color_end
        )

    print(' '.join(top), ' '.join(middle), ' '.join(bottom), sep='\n')
        


def main():
    bash_version = {
        'text': env.get('BASH_VERSION', ''),
        'foreground': 36
    }
    user_name = {
        'text': env.get('USER', ''),
        'foreground': 37
    }
    hostname = {
        'text': env.get('HOSTNAME', ''),
        'foreground': 31
    }
    directory = {
        'text': env.get('PWD', ''),
        'foreground': 34
    }
    current_branch = run('git branch --show-current').stdout
    current_branch = {
        'text': current_branch if current_branch else 'not a git directory',
        'foreground': 35
    }
    jobs_running: str = run('jobs -r | wc -l').stdout
    jobs_stopped: str = run('jobs -s | wc -l ').stdout
    jobs = {
        'text': f'{jobs_running}:{jobs_stopped}',
        'foreground': 36
    }
    print_row(user_name, hostname)
    print_row(bash_version, jobs)
    print_row(directory, current_branch)

if __name__ == '__main__':
    main()
