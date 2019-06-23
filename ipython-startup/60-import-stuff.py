import numpy
import numpy as np
#import matplotlib
#import matplotlib.pyplot as plt  # too slow
import os, sys, random, time, re, pprint, math
pp = pprint
from numpy import log, log2, exp, pi, sin, cos
from numpy import arange, zeros, ones, linspace, arange

def plot(*args, **argv):  # because always loading %matplotlib is too slow
    import matplotlib.pyplot as plt
    plt.plot(*args, **argv)
    plt.show()  # blocking (can't call %matplotlib from here, it seems)

