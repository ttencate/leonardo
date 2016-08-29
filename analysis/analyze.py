#!/usr/bin/python3

from collections import defaultdict
from datetime import datetime, timedelta
import json
import sys

j = json.load(sys.stdin)
users = defaultdict(lambda: {'solved': [], 'first': None, 'last': None})
for _, solution in sorted(j['solutions'].items(), key=lambda item: item[0]):
    puzzleName = solution['puzzleName']
    time = solution.get('time', None)
    user = users[solution['uid']]
    if user['first'] is None:
        user['first'] = time
    if time is not None:
        user['last'] = time
    solved = user['solved']
    if puzzleName not in solved:
        solved.append(puzzleName)

for user in users.values():
    duration = None
    if user['first'] and user['last']:
        format = '%a, %d %b %Y %H:%M:%S %Z'
        duration = datetime.strptime(user['last'], format) - datetime.strptime(user['first'], format)
    user['duration'] = duration

for uid, user in sorted(list(users.items()), key=lambda item: item[1]['duration'] or timedelta(0)):
    if uid == '1472476898065-1538298449':
        continue
    print('{:24}\tduration: {}\tlast: {}\n\t\t\t\t{}'.format(
        uid, user['duration'], user['last'], user['solved']))
