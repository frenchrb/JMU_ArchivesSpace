#!/usr/bin/env python

import multiprocessing as mp
import multiprocessing.queues as mpq
import os
from pathlib import Path
from threading import Thread
from tkinter import *
from tkinter import filedialog
from tkinter import ttk
import spaceport
import generate_coll_list


class NewStdOut():
    def __init__(self, oldStdOut, textArea):
        self.oldStdOut = oldStdOut
        self.textArea = textArea

    def write(self, x):
        # self.oldStdOut.write(x)
        self.textArea.insert(END, x)
        self.textArea.see(END)
        self.textArea.update_idletasks()
    
    def flush(self):
        self.oldStdOut.flush()


class StdOutQueue(mpq.Queue):
    def __init__(self, *args, **kwargs):
        ctx = mp.get_context()
        super(StdOutQueue, self).__init__(*args, **kwargs, ctx=ctx)
    
    def write(self, msg):
        self.put(msg)
    
    def flush(self):
        sys.__stdout__.flush()
        sys.__stderr__.flush()


def text_writer(text_area, queue):
    while True:
        text_area.insert(END, queue.get())
        text_area.see(END)
        text_area.update_idletasks()


def open():
    global openpath
    openpath = filedialog.askopenfilename()
    #print('openpath: ' + openpath)


def save():
    global savepath
    desktop = Path(os.path.expanduser('~')) / 'Desktop'
    savepath = filedialog.askdirectory(initialdir=desktop)
    #print('savepath: ' + savepath)


def run():
    print('-------------------------------------------------------')
    args = []
    args.append(openpath)
    args.append(savepath)
    if c1var.get() == 1:
        args.append('--vaheritage')
    if c2var.get() == 1:
        args.append('--marcxml')
    if c3var.get() == 1:
        args.append('--html')
    if c4var.get() == 1:
        args.append('--htmlmult')
    if c5var.get() == 1:
        args.append('--htmlabs')
    if c6var.get() == 1:
        args.append('--retainexport')
    if c7var.get() == 1:
        args.append('--htmlnew')
    #print(args)
    t = Thread(target=spaceport.main, args=(args,), daemon=True)
    # t.daemon = True
    t.start()


def generate_list():
    print('-------------------------------------------------------')
    args = []
    args.append(savepath)
    if r1var.get():
        args.append('--published')
    t = Thread(target=generate_coll_list.main, args=(args,), daemon=True)
    # t.daemon = True
    t.start()


def main():
    root = Tk()
    root.wm_title('Spaceport')
    root.iconbitmap('images/spaceport_icon.ico')
    
    # Left panel
    left_frame = Frame(root)
    left_frame.grid()
    
    # Generate files
    inButton = Button(left_frame, text='Select Input File', height=2, width=25, command=open)
    inButton.grid(row=2)
    
    outButton = Button(left_frame, text='Select Save Location', height=2, width=25, command=save)
    outButton.grid(row=3)
    
    label3 = Label(left_frame, text='Choose options:')
    label3.grid(row=5, sticky=W)
    
    global c1var
    global c2var
    global c3var
    global c4var
    global c5var
    global c6var
    global c7var
    c1var = IntVar()
    c2var = IntVar()
    c3var = IntVar()
    c4var = IntVar()
    c5var = IntVar()
    c6var = IntVar()
    c7var = IntVar()
    
    c1 = Checkbutton(left_frame, text='Virginia Heritage EAD', variable=c1var)
    c1.grid(row=10, sticky=W)
    c2 = Checkbutton(left_frame, text='MARCXML record', variable=c2var)
    c2.grid(row=11, sticky=W)
    c3 = Checkbutton(left_frame, text='HTML finding aid', variable=c3var)
    c3.grid(row=12, sticky=W)
    c4 = Checkbutton(left_frame, text='HTML finding aid (multiple container types)', variable=c4var)
    c4.grid(row=13, sticky=W)
    c7 = Checkbutton(left_frame, text='HTML finding aid (new design)', variable=c7var)
    c7.grid(row=14, sticky=W)
    c5 = Checkbutton(left_frame, text='HTML abstract', variable=c5var)
    c5.grid(row=15, sticky=W)
    c6 = Checkbutton(left_frame, text='Retain exported Aspace EAD file', variable=c6var)
    c6.grid(row=16, sticky=W)
    
    runButton = Button(left_frame, text='Generate Files', height=2, width=25, command=run)
    runButton.grid(row=20)
    
    sep = ttk.Separator(left_frame).grid(row = 22, columnspan = 2, sticky = EW, pady=20)
    
    # Generate list
    label4 = Label(left_frame, text='Create text file of collection numbers')
    label4.grid(row=30, sticky=W)
    
    global r1var
    r1var = IntVar()
    
    radio1a = Radiobutton(left_frame, text='All', variable=r1var, value=False)
    radio1a.grid(row=32, sticky=W, padx=15)
    radio1b = Radiobutton(left_frame, text='Published only', variable=r1var, value=True)
    radio1b.grid(row=33, sticky=W, padx=15)
    
    outButton2 = Button(left_frame, text='Select Save Location', height=2, width=25, command=save)
    outButton2.grid(row=34)
    
    button_generate_list = Button(left_frame, text='Generate List', height=2, width=25, command=generate_list)
    button_generate_list.grid(row=35, column=0, columnspan=2, pady=10)
    
    # Text area
    text_area = Text(root, height=40, width=70)
    text_area.grid(row=0, column=2, rowspan=20)
    text_area.update_idletasks()
    
    scrollbar = Scrollbar(root)
    text_area.config(yscrollcommand=scrollbar.set)
    scrollbar.config(command=text_area.yview)
    scrollbar.grid(row=0, column=3, rowspan=20, sticky='NS')
    
    q = StdOutQueue()
    monitor = Thread(target=text_writer, args=(text_area, q), daemon=True)
    # monitor.daemon = True
    monitor.start()
    sys.stdout = q
    sys.stderr = q
    
    root.mainloop()


if __name__ == '__main__':
    main()
