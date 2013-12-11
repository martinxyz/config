#!/usr/bin/env python
# file created 2010-08-19, Martin Renold
# public domain
"""
Generate HTML documentation from vhdl code structure and comments.
"""
import vhdl
import os, cgi, sys, optparse

parser = optparse.OptionParser(
    usage = '%prog <filelist1.txt|projectfile1.qsf> [<filelist2.txt|projectfile2.qsf> ...]',
    description = __doc__.lstrip()
    )

options, args = parser.parse_args()

parse_globals = False

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
    found = False
    for s in sourcefile.content:
        if not isinstance(s, str):
            break
        s = s.strip()
        if s.startswith('--'):
            s = s[2:].strip()
            if s.startswith('Description') and ':' in s:
                s = s.split(':', 1)[1]
                found = True
            if found:
                if '--------------------' in s:
                    break
                e.doc += s + '\n'
        elif found:
            break # end of commented section
    e.doc = e.doc.strip()

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
            # grab special comments
            l = line.split('--#', 1)[1:]
            if not l: continue
            comment = l[0].strip()
            if comment.startswith('#'):
                # new group
                group = SignalGroup()
                #group.name = comment[1:].split(None, 1)[1] # remove first word
                group.name = comment[1:].strip()
                group.signals = []
                e.signal_groups.append(group)
            else:
                assert signal is not None, 'signal comment continuation without signal (bad section comment?)%r\n%r\n' % (e, line)
                if signal.doc:
                    signal.doc += '\n'
                signal.doc += comment

#
# write html output
#

global_constants = {}

if parse_globals:
    for line in open('../core/hsr_prp_globals_pack.vhd'):
        if line.strip().startswith('--'):
            continue
        if 'constant' in line and ':=' in line:
            name = line.replace(':', ' ').split()[1]
            value = line.split(':=')[1].split(';')[0]
            try:
                value = eval(value, global_constants)
            except:
                continue
            global_constants[name] = value
            #print name, value

entities = []
for e in top.entities:
    #if e.name.endswith('_top'):
    #    continue
    #if e.name in ['cpu_rx_controller', 'cpu_tx_controller']:
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
    f.write('<html><body><h1>%s::%s</h1>' % (signal.entity.name, signal.name))
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
            for lineno, line in enumerate(open(fn)):
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
    f.write('<html><body>\n')

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
            # Hack to evaluate contants. Should probably tokenize a bit instead.
            try:
                before, after = t.split('(', 1)
                expression, after = after.split(' downto ')
                expression = str(eval(expression, global_constants))
                t = '%s(%s downto %s' % (before, expression, after)
                #print before, expression, after
            except:
                pass
            try:
                before, after = t.split('(', 1)
                expression, after = after.split(' to ')
                after, trash = after.split(')', 1)
                expression = str(eval(expression, global_constants))
                after = str(eval(after, global_constants))
                t = '%s(%s to %s)' % (before, expression, after)
            except:
                pass
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

print 'Finished.'
