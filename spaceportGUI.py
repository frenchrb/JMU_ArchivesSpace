#!/usr/bin/env python

import os
from pathlib import Path
from tkinter import *
from tkinter import filedialog
import spaceport


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
    #print(args)
    spaceport.main(args)


def main():
    root = Tk()
    root.wm_title('Spaceport')
    
    # Left panel
    left_frame = Frame(root)
    left_frame.grid()
    
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
    c1var = IntVar()
    c2var = IntVar()
    c3var = IntVar()
    c4var = IntVar()
    c5var = IntVar()
    c6var = IntVar()
    
    c1 = Checkbutton(left_frame, text='Virginia Heritage EAD', variable=c1var)
    c1.grid(row=10, sticky=W)
    c2 = Checkbutton(left_frame, text='MARCXML record', variable=c2var)
    c2.grid(row=11, sticky=W)
    c3 = Checkbutton(left_frame, text='HTML finding aid', variable=c3var)
    c3.grid(row=12, sticky=W)
    c4 = Checkbutton(left_frame, text='HTML finding aid (multiple container types)', variable=c4var)
    c4.grid(row=13, sticky=W)
    c5 = Checkbutton(left_frame, text='HTML abstract', variable=c5var)
    c5.grid(row=14, sticky=W)
    c6 = Checkbutton(left_frame, text='Retain exported Aspace EAD file', variable=c6var)
    c6.grid(row=15, sticky=W)
    
    runButton = Button(left_frame, text='Run', height=2, width=25, command=run)
    runButton.grid(row=20)
    
    
    # Text area
    text_area = Text(root, height=40, width=70)
    text_area.grid(row=0, column=2, rowspan=20)
    text_area.update_idletasks()
    
    scrollbar = Scrollbar(root)
    text_area.config(yscrollcommand=scrollbar.set)
    scrollbar.config(command=text_area.yview)
    scrollbar.grid(row=0, column=3, rowspan=20, sticky='NS')

    save_stdout = sys.stdout
    sys.stdout = NewStdOut(save_stdout, text_area)
    
    save_stderr = sys.stderr
    sys.stderr = NewStdOut(save_stderr, text_area)
    
    root.mainloop()


if __name__ == '__main__':
    main()
