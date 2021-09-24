#!/usr/bin/env python

import argparse
import configparser
import sys
from asnake.aspace import ASpace
from datetime import datetime
from pathlib import Path


def main(arglist):
    # print(arglist)
    parser = argparse.ArgumentParser()
    parser.add_argument('output', help='save directory')
    parser.add_argument('--published', help='only list published collections', action='store_true')
    args = parser.parse_args(arglist)
    # print(args)
    
    
    save_dir = Path(arglist[0])
    date_time = datetime.now().strftime('%Y%m%d_%H%M%S')
    if args.published:
        out_filename = Path('all_published_collections_' + date_time).with_suffix('.txt')
    else:
        out_filename = Path('all_collections_' + date_time).with_suffix('.txt')
    out_file = save_dir / out_filename
    
    # Read config file
    config = configparser.ConfigParser()
    config.read('local_settings.ini')
    
    aspace = ASpace(baseurl=config.get('ArchivesSpace', 'baseURL'), 
                    username=config.get('ArchivesSpace', 'user'), 
                    password=config.get('ArchivesSpace', 'password'))
    repo = aspace.repositories(config.get('ArchivesSpace', 'repository'))
    
    if args.published:
        print('Generating list of published collections...')
    else:
        print('Generating list of all collections...')
    
    colls = []
    for collection in repo.resources:
        if collection.id_0 != 'SC 9999' and 'temp' not in collection.id_0:
            if args.published:
                if collection.publish:
                    colls.append(collection.id_0)
            else: # print all collections regardless of publish status
                colls.append(collection.id_0)
    colls.sort()
    
    out_file = open(out_file, 'w')
    for i in colls:
        out_file.write(i + '\n')
    out_file.close()
    print('List created')
    print()


if __name__ == '__main__':
    main(sys.argv[1:])
