#!/usr/bin/env python

import argparse
import sys
import subprocess
import configparser
import os
import requests
from pathlib import Path

#read config file
config = configparser.ConfigParser()
config.read('local_settings.ini')


def export_ead(list, out_dir, id_dict):
    #export all collections listed in input from ArchivesSpace
    
    # URL parameters dictionary, used to manage common URL patterns
    dictionary = {'baseURL': config.get('ArchivesSpace', 'baseURL'), 'repository':config.get('ArchivesSpace', 'repository'), 'user': config.get('ArchivesSpace', 'user'), 'password': config.get('ArchivesSpace', 'password')}
    baseURL = '{baseURL}'.format(**dictionary)
    repositoryBaseURL = '{baseURL}/repositories/{repository}/'.format(**dictionary)
    
    # authenticates the session
    auth = requests.post('{baseURL}/users/{user}/login?password={password}&expiring=false'.format(**dictionary)).json()
    session = auth['session']
    
    headers = {'X-ArchivesSpace-Session':session}
    export_options = '?numbered_cs=true&include_daos=true&include_unpublished=true'
    
    destination = out_dir / 'Aspace_EADs'
    Path.mkdir(destination)
    
    with open(list) as f:
        for line in f:
            print('Exporting ' + line.rstrip())
            
            #searches by id_0, which is our collection number (SC #### or UA ####)
            results = (requests.get(repositoryBaseURL + '/search?page=1&aq={\"query\":{\"field\":\"id_0\",\"value\":\"' + line.rstrip() +'\",\"jsonmodel_type\":\"field_query\",\"negated\":false,\"literal\":false}}', headers=headers)).json()
            #print (json.dumps(results, indent=2))
            
            #searches by ead_id, which is vihart#####
            #results = (requests.get(repositoryBaseURL + '/search?page=1&aq={\"query\":{\"field\":\"ead_id\",\"value\":\"vihart00266\",\"jsonmodel_type\":\"field_query\",\"negated\":false,\"literal\":false}}', headers=headers)).json()
            
            uri = results['results'][0]['id']
            #print 'URI:  ' + uri
            resource = (requests.get(baseURL + uri, headers = headers)).json()
            
            id = resource['uri']
            id_uri_string = id.replace('resources', 'resource_descriptions')
            ead = requests.get(baseURL + id_uri_string + '.xml' + export_options, headers = headers).text
            
            coll_num = resource['id_0'].replace(' ','')
            if 'ead_id' in resource:
                #print(resource['ead_id'])
                id_dict[coll_num] = resource['ead_id']
            else:
                id_dict[coll_num] = ''
            
            out_filename = Path(coll_num).with_suffix('.xml')
            outfile = destination / out_filename
            outfile.write_text(ead, encoding = 'utf-8')
    print('EAD exports completed')
    return id_dict

def vaheritage(in_file, out_dir, id_dict):
    source = out_dir / 'Aspace_EADs' / in_file
    
    #use vihart# as filename if it exists; otherwise use collection number
    if id_dict[in_file.stem]:
        out_file = (out_dir / 'Va_Heritage' / id_dict[in_file.stem]).with_suffix('.xml')
    else:
        out_file = out_dir / 'Va_Heritage' / in_file
    
    #run Aspace2VaHeritage.xsl transformation with Saxon
    subprocess.call(['java', '-jar', config['Saxon']['saxon_path']+'saxon9he.jar', '-s:'+str(source.resolve()), '-xsl:Aspace2VaHeritage.xsl', '-o:'+str(out_file.resolve())])
    
    #non-XSLT changes
    with open(out_file, 'r') as file:
        filedata = file.read()
    filedata = filedata.replace('<extref xmlns=', '<extref xmlns:xlink=')
    filedata = filedata.replace('<extptr xmlns=', '<extptr xmlns:xlink=')
    with open(out_file, 'w') as file:
        file.write(filedata)
    
    return 'Virginia Heritage transformation executed (' + out_file.stem + ')'

def marcxml(in_file, out_dir):
    #run Aspace2MARCXML.xsl transformation with Saxon
    
    #encoding troubleshooting
    #print()
    #print(inputFile)
    #with open('Aspace_EADs/'+inputFile, 'r', encoding='utf-8') as f:
    #    print(f.read())
    #print()
    #print()
    #encoding troubleshooting
    
    source = out_dir / 'Aspace_EADs' / in_file
    out_file = (out_dir / 'MARCXML' / (in_file.stem + '_MARC')).with_suffix('.xml')
    subprocess.call(['java', '-jar', config['Saxon']['saxon_path']+'saxon9he.jar', '-s:'+str(source.resolve()), '-xsl:Aspace2MARCXML.xsl', '-o:'+str(out_file.resolve())])
    return 'MARCXML transformation executed'

def html(in_file, out_dir):
    #run Aspace2HTML.xsl transformation with Saxon
    source = out_dir / 'Aspace_EADs' / in_file
    out_file = out_dir / 'HTML' / in_file.with_suffix('.html')
    subprocess.call(['java', '-jar', config['Saxon']['saxon_path']+'saxon9he.jar', '-s:'+str(source.resolve()), '-xsl:Aspace2HTML.xsl', '-o:'+str(out_file.resolve())])
    return 'HTML transformation executed'

def html_abstract(in_file, out_dir):
    #run Aspace2HTMLabstract.xsl transformation with Saxon
    source = out_dir / 'Aspace_EADs' / in_file
    out_file = (out_dir / 'HTML_abstract' / (in_file.stem + 'abstract')).with_suffix('.html')
    subprocess.call(['java', '-jar', config['Saxon']['saxon_path']+'saxon9he.jar', '-s:'+str(source.resolve()), '-xsl:Aspace2HTMLabstract.xsl', '-o:'+str(out_file.resolve())])
    return 'HTML abstract transformation executed'

def cleanup(filename):
    #remove exported Aspace EAD file
    os.remove(filename)
    return 'Aspace EAD file removed'

def main(arglist):
    #print(arglist)
    parser = argparse.ArgumentParser()
    parser.add_argument('input', help='text file of collection numbers')
    parser.add_argument('output', help='save directory')
    parser.add_argument('--vaheritage', help='run ASpace2VaHeritage.xsl', action='store_true')
    parser.add_argument('--marcxml', help='run ASpace2MARCXML.xsl', action='store_true')
    parser.add_argument('--html', help='run ASpace2HTML.xsl', action='store_true')
    parser.add_argument('--htmlabs', help='run ASpace2HTMLabstract.xsl', action='store_true')
    parser.add_argument('--retainexport', help='retain EAD exported from ArchivesSpace', action='store_true')
    args = parser.parse_args(arglist)
    #print(args)
    
    coll_list = arglist[0]
    #print(coll_list)
    
    save_dir = Path(arglist[1])
    out_dir = save_dir / 'Output'
    Path.mkdir(out_dir) #should first check if exists
    
    sc_vihart = {}
    sc_vihart = export_ead(coll_list, out_dir, sc_vihart)
    #print(sc_vihart)
    print()
    
    with open(coll_list) as f:
        for line in f:
            filename = Path(line.replace(' ', '').rstrip()).with_suffix('.xml')
            if filename.name in os.listdir(out_dir / 'Aspace_EADs'):
                if args.vaheritage or args.marcxml or args.html or args.htmlabs or args.retainexport == False:
                    print(filename)
                if args.vaheritage:
                    print('    ' + vaheritage(filename, out_dir, sc_vihart))
                if args.marcxml:
                    print('    ' + marcxml(filename, out_dir))
                if args.html:
                    print('    ' + html(filename, out_dir))
                if args.htmlabs:
                    print('    ' + html_abstract(filename, out_dir))
                if args.retainexport == False:
                    print('    ' + cleanup(out_dir / 'Aspace_EADs' / filename))
                print()
    
if __name__ == '__main__':
    #print(parser.parse_args(sys.argv[1:]))
    main(sys.argv[1:])
    