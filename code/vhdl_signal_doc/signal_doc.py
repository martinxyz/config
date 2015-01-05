#!/usr/bin/env python3
# file created 2010-08-19, Martin Renold
# public domain
"""
Generate HTML documentation from vhdl source.
"""
import vhdl
import os, cgi, sys, optparse

parser = optparse.OptionParser(
    usage = '%prog <filelist1.txt|projectfile1.qsf> [<filelist2.txt|projectfile2.qsf> ...]',
    description = __doc__.lstrip()
    )
parser.add_option("-e", "--eval-constants",
                  action="store_true", default=False,
                  help="evaluate vhdl constants using use python eval(); not safe, only for trusted code")

options, args = parser.parse_args()

if not args:
    parser.print_help()
    sys.exit(1)

#
# analyze source
#

outdir = 'doc'
if not os.path.isdir('doc'):
    os.makedirs(outdir)

files = []
for fn in args:
    if fn.endswith('.qsf'):
        l = vhdl.quartus_qsf_listfiles(fn)
        l = [fn for fn in l if not 'quartus' in fn]
        files.extend(l)
    else:
        l = vhdl.textfile_listfiles(fn)
        files.extend(l)

# print files
top = vhdl.Codebase(files)

#
# collect entity description comments
#

for e in top.entities:
    # grab entity description from the top-of-file comment
    sourcefile = e.parent
    e.doc = ''
    for s in sourcefile.content:
        if not isinstance(s, str):
            break
        s = s.strip()
        if s.startswith('--'):
            s = s[2:]
            if not s.strip(): continue
            e.doc += s + '\n'
    e.doc = '<pre>' + e.doc.strip() + '</pre>'
    #e.doc = e.doc.strip()

#
# collect signal comments
#

class SignalGroup:
    pass

for e in top.entities:
    group = SignalGroup()
    group.name = ''
    group.signals = []
    e.signal_groups = [group]

    signal = None
    generic = None
    for c in e.content:
        if isinstance(c, vhdl.PortSignal):
            signal = c
            signal.doc = ''
            group.signals.append(signal)
            lines = vhdl.content2lines(signal.content)
        else:
            lines = [c]
        for line in lines:
            ## grab special comments
            #l = line.split('--#', 1)[1:]
            # grab all comments
            if '--' not in line:
                signal = None
                continue
            statement, comment = line.split('--', 1)
            statement = statement.strip()
            comment = comment.strip()
            if not comment:
                signal = None # if there is a comment on the next line, it's not a multi-line continuation
                continue

            # treat special comments (--!, --#, --##) like normal comments
            comment = comment.lstrip('!').lstrip('#')

            if not signal: # comment refers to all signals below
                # new signal group
                group = SignalGroup()
                #group.name = comment[1:].split(None, 1)[1] # remove first word
                group.name = comment[1:].strip()
                group.signals = []
                e.signal_groups.append(group)
            else:
                if signal.doc:
                    signal.doc += '\n'
                signal.doc += comment

#
# write html output
#

global_constants = {}

def resolve_constants(s):
    if not options.eval_constants:
        return s
    try:
        res = eval(s, global_constants)
    except:
        res = s
    return res

if True:
    invalid_constants = []
    for fn in files:
        for line in open(fn, encoding='utf8', errors='ignore'):
            if line.strip().startswith('--'):
                continue
            if 'constant' in line and ':=' in line:
                name = line.replace(':', ' ').split()[1].strip()
                if not ';' in line: continue
                value = line.split(':=')[1].split(';')[0].strip()
                #print 'found constant:', name, value
                if name in global_constants:
                    if value != global_constants[name]:
                        print('WARNING: multiple definitions of constant', name + '; not resolving it (' + repr(global_constants[name]), 'vs', repr(value) + ')')
                        invalid_constants.append(name)
                global_constants[name] = value
    for name in invalid_constants:
        if name in global_constants:
            global_constants.pop(name)
    stale = False
    while not stale:
        stale = True
        for name in list(global_constants.keys()):
            value = resolve_constants(global_constants[name])
            if value != global_constants[name]:
                global_constants[name] = value
                stale = False

entities = []
for e in top.entities:
    #if e.name.endswith('_top'):
    #    continue
    entities.append(e)

signal_pages = []

def make_main_index_page():
    f = open('%s/index.html' % outdir, 'w')
    f.write('<h3>Entities</h3>\n')
    roots = [e for e in top.entities if not e.parents]
    entities_ordered = []
    def write_children(children):
        f.write('<ul>\n')
        for e in children:
            if e in entities:
                if e not in entities_ordered:
                    entities_ordered.append(e)
                    f.write('<li><a href="%s.html">%s</a></li>\n' % (e.name, e.name))
            else:
                f.write('<li>%s</li>\n' % e.name)
            write_children(e.children)
            #f.write('<h1><a name="%s">%s</a></h1>\n' % (e.name, e.name))
        f.write('</ul>\n')
    write_children(roots)
    f.write('<h3>Signals</h3>\n')
    signal_pages.sort()
    for sig, ent, url in signal_pages:
        f.write('<a href="%s">%s</a> (%s)<br>' % (url, sig, ent))
    f.write('</html></body>\n')

def sig2url(signal):
    return signal.entity.name + '__' + signal.name + '.html'

def make_signal_info_page(signal):
    filename = sig2url(signal)
    signal_pages.append((signal.name, signal.entity.name, filename))
    f = open(outdir + '/' + filename, 'w')
    f.write('<html><head><meta charset="UTF-8"></head><body><h1>%s::%s</h1>' % (signal.entity.name, signal.name))
    f.write('<h3>from</h3>')

    def get_orig_sources(sig1):
        res = set()
        if not sig1.sources:
            return set([sig1])
        for sig2 in sig1.sources:
            res.update(get_orig_sources(sig2))
        return res
    def get_final_sinks(sig1, r=0):
        if not sig1.sinks:
            return set([sig1])
        res = set()
        for sig2 in sig1.sinks:
            res.update(get_final_sinks(sig2, r=r+1))
        return res
    for sig in get_orig_sources(signal):
        f.write('<a href="%s">%s</a> (<a href="%s">%s</a>)<br>\n' % (sig.entity.name+'.html', sig.entity.name, sig2url(sig), sig.name))
    f.write('<h3>to</h3>')
    for sig in get_final_sinks(signal):
        f.write('<a href="%s">%s</a> (<a href="%s">%s</a>)<br>\n' % (sig.entity.name+'.html', sig.entity.name, sig2url(sig), sig.name))
    f.write('<h2>code</h2>')
    f.write('<font face="monospace">')

    # code (context grep)
    sigs = list(get_orig_sources(signal))
    for sig in get_final_sinks(signal):
        if sig not in sigs:
            sigs.append(sig)
    names = [sig.name for sig in sigs]
    files = []
    for sig in sigs:
        fn = sig.entity.parent.filename
        if fn not in files:
            f.write('<h3>%s</h3>\n' % fn)
            files.append(fn)
            context = []
            N = 7 # number of context lines
            after = 0
            def show_line(c):
                lineno2, line2 = c
                line2 = line2.rstrip()
                line2 = cgi.escape(line2)
                for name2 in names:
                    #line2 = line2.replace(name2, '<font color="#660000">'+name2+'</font>')
                    line2 = line2.replace(name2, '<b>'+name2+'</b>')
                line2 = line2.replace(' ', '&nbsp;')
                f.write('%04d:&nbsp;%s<br>\n' % (lineno2, line2))
            for lineno, line in enumerate(open(fn, encoding='utf8', errors='ignore')):
                context.append((lineno, line))
                context = context[-N:]
                for name in names:
                    if name in line:
                        after = N
                if after > 0:
                    after -= 1
                    for l1 in context:
                        show_line(l1)
                    context = []
                    if after == 0:
                        f.write('...<br>\n')

    f.write('</font>')
    f.write('</body></html>')
    return filename

def txt2html(txt):
    html = ''
    parts = txt.split('\n\n')
    for s in parts:
        if s.strip():
            html += '<p>%s</p>\n' % s
    return html

def make_entity_page(e, print_version):
    if print_version:
        f = open('%s/%s_print.html' % (outdir, e.name), 'w') 
    else:
        f = open('%s/%s.html' % (outdir, e.name), 'w') 
    f.write('<html><head><meta charset="UTF-8"></head><body>\n')

    def write_tr(*rows, **kwargs):
        sep = kwargs.get('sep', 'td')
        id_str = ''
        td_id = kwargs.get('td_id', '')
        if td_id:
            id_str = ' id="%s"' % td_id
        f.write('<tr>')
        for s in rows:
            if not s:
                s = '&nbsp;'
            f.write('<%s>%s</%s>' % (sep + id_str, s, sep))
        f.write('</tr>\n')

    f.write('''
    <style type="text/css">
    /* <![CDATA[ */

    table, td, th
    {
        border-color: #AAAAAA;
        border-style: solid;
    }

    table
    {
        border-width: 0 0 1px 1px;
        border-spacing: 0;
        border-collapse: collapse;
    }

    td, th
    {
        margin: 0;
        padding: 4px;
        border-width: 1px 1px 0 0;
    }
    th
    {
        color: #FFFFFF;
        background-color: #000000;
    }
    td#signal
    {
        background-color: #FFFFDD;
    }

    /* ]]> */
    </style>
    ''')


    if print_version:
        f.write('<h2>%s</h2>\n' % e.name)
    else:
        f.write('<a href="%s">print version</a>\n' % (e.name + '_print.html'))
        f.write('<h1><a name="%s">%s</a></h1>\n' % (e.name, e.name))

    if print_version: f.write('<h4>Description</h4>\n')
    f.write(txt2html(e.doc))
    if print_version: f.write('<h4>Signals</h4><br>\n')

    for group in e.signal_groups:

        signals = []
        for signal in group.signals:
            if signal.doc:
                signals.append(signal)
            else:
                s = signal.name.lower()
                if not s.startswith('clk') and not s.startswith('clock') and not s.startswith('reset'):
                    signals.append(signal)

        if not signals:
            continue

        f.write('<table width="100%">\n')

        if group.name:
            f.write('<tr><td colspan="3"><b><center>%s</center></b></td></tr>\n' % group.name)

        write_tr('Signal', 'Type', 'Description', sep='th')
        for signal in signals:
            t = signal.type
            t = t.replace('( ', '(').replace(' )', ')')
            t = t.replace(' DOWNTO ', ' downto ')
            t = t.replace(' TO ', ' to ')
            # evaluate contants
            if '(' in t and (' downto ' in t or ' to ' in t):
                separator = ' downto ' if ' downto ' in t else ' to '
                before, after = t.split('(', 1)
                expression1, after = after.split(separator)
                expression2, after = after.split(')', 1)
                e1 = resolve_constants(expression1)
                e2 = resolve_constants(expression2)
                if expression1 != str(e1): expression1 = str(e1) + ' {=' + expression1 + '}'
                if expression2 != str(e2): expression2 = str(e2) + ' {=' + expression2 + '}'
                t = '%s(%s %s %s)%s' % (before, expression1, separator, expression2, after)

            t = t.replace(' ', '&nbsp;')
            t = t.replace('(', '&#8203;(') # zero-width space in front of every '(' for table layout.
            name = signal.name
            if not print_version:
                url = make_signal_info_page(signal)
                name = '<a href="%s">%s</a>' % (url, name)

            write_tr(name, t, txt2html(signal.doc), td_id='signal')

        f.write('</table><br>\n')

    f.write('</body></html>\n')

for e in entities:
    make_entity_page(e, True)
    make_entity_page(e, False)
make_main_index_page()

print('Finished.')

print('Now run: sensible-browser %s/index.html' % outdir)
