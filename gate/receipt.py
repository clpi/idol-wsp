#!/usr/bin/env python3
"""Check qualification transport identities and the named mutation outcome."""
import hashlib
import json
from pathlib import Path
import re
import sys


def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def inventory(roots):
    files = []
    for root in map(Path, roots):
        if root.is_symlink() or not root.exists():
            raise ValueError(f'invalid input root: {root}')
        entries = [root, *root.rglob('*')] if root.is_dir() else [root]
        for path in entries:
            if path.is_symlink():
                raise ValueError(f'linked input: {path}')
            if path.is_file():
                files.append(path)
            elif not path.is_dir():
                raise ValueError(f'non-regular input: {path}')
    return sorted(files, key=lambda path: path.as_posix())


def manifest(files):
    return ''.join(f'{digest(path)}  {path.as_posix()}\n' for path in files)


def mutation(normal, changed, error, code):
    labels = [
        'left selection retained',
        'right selection retained',
        'selection cannot be erased by merge',
        'existing result becomes unusable',
        'unresolved selection remains unknown',
    ]
    match = re.fullmatch(r'merge passes ([0-9]+) failures 0\n?', normal)
    if not match or int(match[1]) < len(labels) or error or code != len(labels):
        return False
    expected = [f'FAIL {label}' for label in labels]
    expected.append(f'merge passes {int(match[1]) - len(labels)} failures {len(labels)}')
    return changed.splitlines() == expected


def controls():
    normal = 'merge passes 27 failures 0\n'
    changed = '\n'.join([
        'FAIL left selection retained',
        'FAIL right selection retained',
        'FAIL selection cannot be erased by merge',
        'FAIL existing result becomes unusable',
        'FAIL unresolved selection remains unknown',
        'merge passes 22 failures 5',
    ]) + '\n'
    cases = {
        'named assertion outcome': mutation(normal, changed, '', 5),
        'unrelated error': not mutation(normal, '', '', 1),
        'crash status': not mutation(normal, changed, '', 139),
        'wrong assertion': not mutation(normal, changed.replace('left selection retained', 'unrelated'), '', 5),
        'wrong total': not mutation(normal, changed.replace('passes 22', 'passes 21'), '', 5),
        'success status': not mutation(normal, changed, '', 0),
        'unexpected stderr': not mutation(normal, changed, 'runtime fault\n', 5),
        'missing assertion': not mutation(normal, changed.split('\n', 1)[1], '', 5),
        'extra output': not mutation(normal, changed + 'unrelated\n', '', 5),
    }
    print(json.dumps(cases, indent=2))
    if not all(cases.values()):
        raise ValueError('mutation admission controls failed')


def main():
    mode = sys.argv[1]
    if mode in ('capture', 'verify'):
        current = manifest(inventory(('run.sh', 'zig-out', 'lib', 'tools', 'gate')))
        target = Path('result/input.sha256')
        if mode == 'capture':
            target.write_text(current)
        elif target.read_text() != current:
            raise ValueError('input bytes or file roster changed during qualification')
        else:
            Path('result/input.verify').write_text('All staged input bytes and paths match the initial manifest.\n')
    elif mode == 'outputs':
        target = Path('result/output.sha256')
        target.write_text(manifest(path for path in inventory(('result',)) if path != target))
    elif mode == 'mutation':
        if not mutation(Path(sys.argv[2]).read_text(), Path(sys.argv[3]).read_text(),
                        Path(sys.argv[4]).read_text(), int(sys.argv[5])):
            raise ValueError('mutation did not produce exactly the named selection-loss assertions')
        print('Exact selection-loss assertion outcome verified.')
    elif mode == 'controls':
        controls()
    else:
        raise ValueError(f'unknown receipt operation: {mode}')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, IndexError) as error:
        raise SystemExit(str(error))
