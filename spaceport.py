#!/usr/bin/env python

import argparse
import sys
import subprocess
import configparser
import os
import requests

#read config file
config = configparser.ConfigParser()
config.read('local_settings.ini')


def export_ead(list, id_dict):
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
                print(resource['ead_id'])
                id_dict[coll_num] = resource['ead_id']
            else:
                id_dict[coll_num] = ''
            
            destination = 'Aspace_EADs/'
            outfile = open(destination + coll_num + '.xml', 'w', encoding = 'utf-8')
            #outfile.write(ead.encode('utf-8'))  #py2
            outfile.write(ead)
            outfile.close
    print('EAD exports completed')
    return id_dict

def vaheritage(inputFile, id_dict):
    #run Aspace2VaHeritage.xsl transformation with Saxon
    
    if id_dict[os.path.splitext(inputFile)[0]]:
        outname = id_dict[os.path.splitext(inputFile)[0]]
    else:
        outname = os.path.splitext(inputFile)[0]
    outpath = 'VaHeritage/'+outname+'.xml'
    #subprocess.call(['java', '-jar', config['Saxon']['saxon_path']+'saxon9he.jar', '-s:Aspace_EADs/'+inputFile, '-xsl:Aspace2VaHeritage.xsl', '-o:VaHeritage/'+out_name+'.xml'])
    subprocess.call(['java', '-jar', config['Saxon']['saxon_path']+'saxon9he.jar', '-s:Aspace_EADs/'+inputFile, '-xsl:Aspace2VaHeritage.xsl', '-o:'+outpath])
    
    
    #TODO try to make the non-XSLT changes
    with open('VaHeritage/'+outname+'.xml', 'r') as file:
        filedata = file.read()
    filedata = filedata.replace('<extref xmlns=', '<extref xmlns:xlink=')
    filedata = filedata.replace('<extptr xmlns=', '<extptr xmlns:xlink=')
    with open(outpath, 'w') as file:
        file.write(filedata)
    
    return 'Virginia Heritage transformation executed (' + outname + ')'

def marcxml(inputFile):
    #run Aspace2MARCXML.xsl transformation with Saxon
    
    #encoding troubleshooting
    #print()
    #print(inputFile)
    #with open('Aspace_EADs/'+inputFile, 'r', encoding='utf-8') as f:
    #    print(f.read())
    #print()
    #print()
    #encoding troubleshooting
    
    subprocess.call(['java', '-jar', config['Saxon']['saxon_path']+'saxon9he.jar', '-s:Aspace_EADs/'+inputFile, '-xsl:Aspace2MARCXML.xsl', '-o:MARCXML/'+os.path.splitext(inputFile)[0]+'_MARC.xml'])
    return 'MARCXML transformation executed'

def html(inputFile):
    #run Aspace2HTML.xsl transformation with Saxon
    subprocess.call(['java', '-jar', config['Saxon']['saxon_path']+'saxon9he.jar', '-s:Aspace_EADs/'+inputFile, '-xsl:Aspace2HTML.xsl', '-o:HTML/'+os.path.splitext(inputFile)[0]+'.html'])
    return 'HTML transformation executed'

def html_abstract(inputFile):
    #run Aspace2HTMLabstract.xsl transformation with Saxon
    subprocess.call(['java', '-jar', config['Saxon']['saxon_path']+'saxon9he.jar', '-s:Aspace_EADs/'+inputFile, '-xsl:Aspace2HTMLabstract.xsl', '-o:HTML_abstract/'+os.path.splitext(inputFile)[0]+'abstract.html'])
    return 'HTML abstract transformation executed'

def cleanup(filename):
    #remove exported Aspace EAD file
    os.remove(filename)
    return 'Aspace EAD file removed'

def main(arglist):
    #print(arglist)
    parser = argparse.ArgumentParser()
    parser.add_argument('input', help='text file of collection numbers')
    parser.add_argument('--vaheritage', help='run ASpace2VaHeritage.xsl', action='store_true')
    parser.add_argument('--marcxml', help='run ASpace2MARCXML.xsl', action='store_true')
    parser.add_argument('--html', help='run ASpace2HTML.xsl', action='store_true')
    parser.add_argument('--htmlabs', help='run ASpace2HTMLabstract.xsl', action='store_true')
    parser.add_argument('--retainexport', help='retain EAD exported from ArchivesSpace', action='store_true')
    args = parser.parse_args(arglist)
    #print(args)
    
    coll_list = arglist[0]
    #print(coll_list)
    
    sc_vihart = {}
    sc_vihart = export_ead(coll_list, sc_vihart)
    #print(sc_vihart)
    print()
    
    with open(coll_list) as f:
        for line in f:
            filename = line.replace(' ', '').rstrip() + '.xml'
            if filename in os.listdir('Aspace_EADs'):
                if args.vaheritage or args.marcxml or args.html or args.htmlabs or args.retainexport == False:
                    print(filename)
                if args.vaheritage:
                    print('    ' + vaheritage(filename, sc_vihart))
                if args.marcxml:
                    print('    ' + marcxml(filename))
                if args.html:
                    print('    ' + html(filename))
                if args.htmlabs:
                    print('    ' + html_abstract(filename))
                if args.retainexport == False:
                    print('    ' + cleanup('Aspace_EADs/' + filename))
                print()
    
if __name__ == '__main__':
    #print(parser.parse_args(sys.argv[1:]))
    main(sys.argv[1:])
    