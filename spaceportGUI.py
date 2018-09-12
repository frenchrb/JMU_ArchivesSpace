#!/usr/bin/env python

from tkinter import *
from tkinter import filedialog
import spaceport

openpath = ''
savepath = ''

def open():
    global openpath
    openpath = filedialog.askopenfilename()
    #print('openpath: ' + openpath)

def save():
    global savepath
    savepath = filedialog.askdirectory()
    #print('savepath: ' + savepath)

def run():
    print()
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
        args.append('--htmlabs')
    if c5var.get() == 1:
        args.append('--retainexport')
    #print(args)
    spaceport.main(args)
    root.destroy()


root = Tk()
root.wm_title("spaceport")

inButton = Button(root, text='Select Input File', height=2, width=25, command=open)
inButton.grid(row=2)

outButton = Button(root, text='Select Save Location', height=2, width=25, command=save)
outButton.grid(row=3)

label3 = Label(root, text='Choose options:')
label3.grid(row=5, sticky=W)

c1var = IntVar()
c2var = IntVar()
c3var = IntVar()
c4var = IntVar()
c5var = IntVar()

c1 = Checkbutton(root, text='Virginia Heritage EAD', variable=c1var)
c1.grid(row=10, sticky=W)
c2 = Checkbutton(root, text='MARCXML record', variable=c2var)
c2.grid(row=11, sticky=W)
c3 = Checkbutton(root, text='HTML finding aid', variable=c3var)
c3.grid(row=12, sticky=W)
c4 = Checkbutton(root, text='HTML abstract', variable=c4var)
c4.grid(row=13, sticky=W)
c5 = Checkbutton(root, text='Retain exported Aspace EAD file', variable=c5var)
c5.grid(row=14, sticky=W)

runButton = Button(root, text='Run', height=2, width=25, command=run)
runButton.grid(row=20)

root.mainloop()
