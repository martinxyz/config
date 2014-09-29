# file created 2010-07-19, Martin Renold
# public domain
"""
Module to analyze and manipulate an existing VHDL codebase.

This is not a correct VHDL parser, it assumes certain basic
conventions (entity and architecture must be in the same file,
newlines must be as they usually are, etc).
"""
import re
from os import path

def quartus_qsf_listfiles(qsf_filename):
    res = []
    for line in open(qsf_filename):
        if line.startswith('#'):
            continue
        s = 'set_global_assignment -name VHDL_FILE '
        parts = line.split(s)
        if len(parts) == 2:
            fn = parts[1].strip()
            # make the path relative to the current working directory
            fn = path.join(path.dirname(qsf_filename), fn)
            fn = path.normpath(path.relpath(fn))
            res.append(fn)
    return res

def textfile_listfiles(txt_filename):
    res = []
    for fn in open(txt_filename):
        fn = fn.split('#')[0].strip()
        if fn.endswith('.vhd'):
            # make the path relative to the current working directory
            fn = path.join(path.dirname(txt_filename), fn)
            fn = path.normpath(path.relpath(fn))
            res.append(fn)
    return res

class Codebase:
    def __init__(self, sourcefiles):
        self.files = []
        for filename in sourcefiles:
            if not path.exists(filename):
                print filename, 'does not exist, skipping!'
                continue
            f = SourceFile(self)
            f.filename = filename
            self.files.append(f)
            for lineno, line in enumerate(open(filename)):
                try:
                    f.feed(line)
                except:
                    print '%s:%d error while parsing %s' % (filename, lineno, repr(line.strip()))
                    raise
        self.connect_entities()
        self.connect_signals()

    def connect_entities(self):
        self.entities = []
        self.name2entity = {}
        for f in self.files:
            if f.entity:
                #print f.filename, 'defines entity', f.entity.name
                assert not f.entity.name in self.name2entity, 'Entitiy %s defined in several files!\n  %s and %s\n' % (repr(f.entity.name), repr(f.filename), repr(self.name2entity[f.entity.name].parent.filename))
                self.name2entity[f.entity.name] = f.entity
                self.entities.append(f.entity)
                assert f.arch, 'Entity %s has no architecture in the same file!' % f.entity.name
                f.entity.arch = f.arch
        print 'Found %d entities in design' % len(self.entities)
        for e in self.entities:
            e.children = []
            #e.internal_signals = {}
            for inst in e.arch.instances:
                e2 = self.name2entity.get(inst.entity_name)
                if e2:
                    inst.entity = e2
                    if e2 not in e.children:  # only once (flattened)
                        e.children.append(e2)
                else:
                    print 'WARNING: entity', e.name, 'contains instance of unknown entity', inst.entity_name
                    inst.entity = None
                #for portname, signalname in e.connections:
                #    internal_signals.append(signalname)
        for e in self.entities:
            e.parents = []
            for e2 in self.entities:
                if e in e2.children:
                    if e2 not in e.parents:
                        e.parents.append(e2)
        for e in self.entities:
            e.all_instances = []
        for e in self.entities:
            for inst in e.arch.instances:
                if inst.entity:
                    inst.entity.all_instances.append(inst)

    def connect_signals(self):
        # combine port signals and local signals into a single namespace
        self.signals = set()
        for e in self.entities:
            e.arch.signals = e.arch.local_signals + e.port_signals
            e.arch.name2signal = {}
            for sig in e.arch.signals:
                self.signals.add(sig)
                assert sig.name not in e.arch.name2signal, 'found a local signal with the same name as a port signal'
                e.arch.name2signal[sig.name] = sig

        # find signal connections
        for sig in self.signals:        
            sig.connections = set()
            sig.sources = set()
            sig.sinks = set()
            sig.inout = set()

        for e in self.entities:
            for inst in e.arch.instances:
                e2 = inst.entity
                if e2 is None:
                    continue
                #print 'parsing instance', inst, 'in entity', e
                for a_str, b_str in inst.connections:
                    #if inst.name == 'u_path_tx':
                    #    print 'resolving %r -> %r' % (a_str, b_str)
                    original_b_str = b_str
                    b_str = b_str.replace('(', '.').split('.')[0].strip()
                    a_str = a_str.replace('(', '.').split('.')[0].strip()
                    a = e2.name2port_signal.get(a_str)
                    b = e.arch.name2signal.get(b_str)
                    if not a:
                        print 'WARNING: port', repr(a_str), 'does not exist in entity', repr(e2.name)
                        continue
                    if not b:
                        b_str = b_str.lower()
                        if b_str.startswith('"') or b_str.startswith("'"):
                            pass # ignore constant assignment
                        elif b_str in ['open']:
                            pass # ignore open ports
                        else:
                            print 'WARNING: architecture namespace of', repr(e.name), 'has no signal named', repr(original_b_str)
                        continue
                    #if inst.name == 'u_path_tx':
                    #    print 'successful connection:', a.name, '<-->', b.name
                    a.connections.add(b)
                    b.connections.add(a)
                    if a.dir == 'in':
                        # b --> a
                        a.sources.add(b)
                        b.sinks.add(a)
                    elif a.dir == 'out':
                        # b <-- a
                        a.sinks.add(b)
                        b.sources.add(a)
                    else:
                        #print 'INOUT', a, b
                        a.inout.add(b)
                        b.inout.add(a)

    def write(self):
        for sf in self.files:
            data_new = ''.join(content2lines(sf.content))
            data_old = open(sf.filename).read()
            if data_old != data_new:
                print 'writing', sf.filename
                open(sf.filename, 'w').write(data_new)
            
def content2lines(content):
    lines = []
    #print content
    for thing in content:
        if isinstance(thing, str):
            lines.append(thing)
        else:
            lines += content2lines(thing.content)
    return lines

class SourceFile:
    def __init__(self, parent):
        self.parent = parent
        self.content = []
        self.entity = None
        self.arch = None
        self.ignoring = False
    def feed(self, line):
        if self.ignoring:
            return
        s = line.split('--')[0] # strip comments
        l = re.findall(r'entity\s+(\w*)\s+is', s, flags=re.IGNORECASE)
        if not self.entity:
            self.content.append(line)
            if l:
                self.entity = Entity(self, l[0])
                self.content.append(self.entity)
        else:
            if l:
                self.ignoring = True
                print 'WARNING: accepting only one entity per file, ignoring rest of the file:', self.filename
            #assert not l, 'accepting only one entity per file'
            l = re.findall(r'architecture\s+\w*\s+of\s+\w*\s+is', s, flags=re.IGNORECASE)
            if not self.arch:
                self.entity.feed(line)
                if l:
                    self.arch = Architecture(self)
                    self.content.append(self.arch)
            else:
                assert not l, 'accepting only one architecture per file'
                self.arch.feed(line)

class Entity:
    def __init__(self, parent, name):
        self.parent = parent
        self.name = name
        self.content = []
        self.name2port_signal = {}
        self.port_signals = []
        self.parsing_port = False
        self.parsing_generic = False
    def feed(self, line):
        s = line.split('--')[0] # strip comments
        generic = re.findall(r'generic\s*\(', s, flags=re.IGNORECASE)
        port = re.findall(r'port\s*\(', s, flags=re.IGNORECASE)
        if generic:
            self.parsing_generic = True
            self.parsing_port = False
        if port:
            self.parsing_generic = False
            self.parsing_port = True
            self.content.append(line)
        if self.parsing_port or self.parsing_generic:
            if ':' in s:
                # signal definition found on this line
                sig = PortSignal(self, line, self.parsing_generic)
                self.content.append(sig)
                self.port_signals.append(sig)
                assert sig.name not in self.name2port_signal, 'a port signal of that name already exists'
                self.name2port_signal[sig.name] = sig
            else:
                self.content.append(line)
        else:
            self.content.append(line)

    def __repr__(self):
        return 'Entity(name=%r)' %  (self.name)

class Architecture:
    def __init__(self, parent):
        self.parent = parent
        self.content = []
        self.expecting_signals = True
        self.local_signals = []
        self.name2local_signal = {}
        self.parsing_instance = None
        self.instances = []
    def feed(self, line):
        if self.expecting_signals:
            s = line.split('--')[0] # strip comments
            s = s.strip()
            if s.lower() == 'begin':
                self.expecting_signals = False
            if s.lower().startswith('signal'):
                sig = LocalSignal(self, line)
                self.local_signals.append(sig)
                self.content.append(sig)
                assert not sig.name in self.name2local_signal, 'a local signal of that name already exists'
                self.name2local_signal[sig.name] = sig
            else:
                self.content.append(line)
        else:
            l = re.findall(r'^\s*(\w+)\s*:\s*entity\s+(\S*)', line, flags=re.IGNORECASE)
            if not l and not self.parsing_instance:
                l = re.findall(r'^\s*(\w+)\s*:\s*(\w+)\s*$', line, flags=re.IGNORECASE)
                if l:
                    if l[0][1].lower() == 'process':
                        l = [] # not an instance, ignore
            if not self.parsing_instance:
                self.content.append(line)
                if l:
                    assert not self.expecting_signals
                    name = l[0][0]
                    entity = l[0][1].replace('work.', '')
                    #print 'found instance of', entity, 'named', name
                    self.parsing_instance = Instance(self, entity, name)
                    self.content.append(self.parsing_instance)
                    self.instances.append(self.parsing_instance)
            else:
                assert not l, 'found instance while parsing instance'
                self.parsing_instance.feed(line)
                if ');' in line and not '(' in line:
                    self.parsing_instance = None

class Instance:
    def __init__(self, parent, entity_name, instance_name):
        self.parent = parent
        self.entity_name = entity_name
        self.name = instance_name
        self.content = []
        self.connections = []
    def feed(self, line):
        self.content.append(line)
        line = line.split('--')[0] # strip comments
        # port map
        if '=>' in line:
            left, right = line.split('=>', 1)
            left = left.strip()
            right = right.strip().rstrip(',').strip()
            #if self.name == 'u_path_tx':
            #    print left, '=>', right
            self.connections.append((left, right))

    def __repr__(self):
        return 'Instance(filename=%r, entity_name=%r, instance_name=%r)' %  (self.parent.parent.filename, self.entity_name, self.name)

class Signal:
    pass

class LocalSignal(Signal):
    def __init__(self, parent, line):
        self.parent = parent
        self.entity = parent.parent.entity
        self.content = [line]
        s = line.split('--')[0] # strip comments
        s = s.strip()
        assert s.lower().startswith('signal')
        trash, s = s.split(None, 1)
        name, type = [part.strip() for part in s.split(':', 1)]
        type = type.rstrip(';').strip()
        type = type.split(':=')[0]
        self.name = name
        self.type = type
        self.dir = None
        #print 'sig', self.name, 'type', self.type

    def __repr__(self):
        return 'LocalSignal(name=%r, entity=%r)' %  (self.name, self.entity.name)

class PortSignal(Signal):
    def __init__(self, parent, line, parsing_generic):
        self.parent = parent
        self.entity = parent
        self.content = [line]
        self.generic = parsing_generic
        s = line.split('--')[0] # strip comments
        s = s.strip()
        assert ':' in line
        name, type = [part.strip() for part in s.split(':', 1)]
        type = type.rstrip(';').strip()
        if parsing_generic:
            direction = 'in'
        else:
            direction, type = type.split(None, 1)
        type = type.split(':=')[0]
        self.name = name
        self.type = type
        self.dir = direction.lower()
        #print 'port', self.name, 'type', self.type, 'dir', self.dir

    def __repr__(self):
        return 'PortSignal(name=%r, entity=%r)' %  (self.name, self.entity.name)

