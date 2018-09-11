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

#def save():
#    global savepath
#    savepath = filedialog.asksaveasfilename(defaultextension='.csv', filetypes=[('CSV (Comma Delimited)', '.csv')])
#    print('savepath: ' + savepath)

def run():
    print()
    args = []
    args.append(openpath)
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

#label1 = Label(root, text='Enter collection numbers or select file containing a list of collection numbers')
#label1.grid(row=1, column=1)
#T = Text(root, height=5, width=30)
#T.grid(row=1, column=2)
#print(T.get(1))

#label2 = Label(root, text='Select file containing a list of collection numbers').grid(row=3, column=1)
inButton = Button(root, text='Select Input File', height=2, width=25, command=open)
inButton.grid(row=2, column=2)

#outButton = Button(root, text='Select Output Save Location', height=2, width=25, command=save)
#outButton.grid(row=1)

label3 = Label(root, text='Choose options:')
label3.grid(row=5, column=2)

c1var = IntVar()
c2var = IntVar()
c3var = IntVar()
c4var = IntVar()
c5var = IntVar()

c1 = Checkbutton(root, text='Virginia Heritage EAD', variable=c1var)
c1.grid(row=10, column=2)
c2 = Checkbutton(root, text='MARCXML record', variable=c2var)
c2.grid(row=11, column=2)
c3 = Checkbutton(root, text='HTML finding aid', variable=c3var)
c3.grid(row=12, column=2)
c4 = Checkbutton(root, text='HTML abstract', variable=c4var)
c4.grid(row=13, column=2)
c5 = Checkbutton(root, text='Retain exported Aspace EAD file', variable=c5var)
c5.grid(row=14, column=2)

runButton = Button(root, text='Run', height=2, width=25, command=run)
runButton.grid(row=20, column=2)

root.mainloop()
