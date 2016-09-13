# -*- coding: utf-8 -*-
"""
Created on Wed Jul 13 12:16:11 2016

@author: Dat Tien Hoang
"""

import numpy as np
import cv2
from matplotlib import pyplot as plt

# FOR COLOR IMAGES
#img = cv2.imread('C:/Users/Dat Tien Hoang/Desktop/hoa_fluo/hoa_fluo_r-0055.tif')#opticalang_1.png')
#gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)

# FOR GREYSCALE IMAGES
gray = cv2.imread('C:/Users/Dat Tien Hoang/Desktop/hoa_fluo/opticalang_55.png',0)

print gray.dtype
print np.amin(gray), np.amax(gray)

fig1 = plt.figure()
plt.imshow(gray)
plt.colorbar()

#------------------------------------------------------------------------------
# METHOD 1 - do nothing, otsu on color image

#------------------------------------------------------------------------------
# METHOD 2 - rescale all angles rel to 0 with range of 0-180

# in case its uint8...convert to int16 to allow values of 360 and negatives
gray = gray.astype(np.int16)
print gray.dtype
print gray
print np.mean(gray)
print np.amin(gray), np.amax(gray)
gray *= 2
print gray
print np.mean(gray)
print np.amin(gray), np.amax(gray)

fig2 = plt.figure()
plt.imshow(gray*0.708, vmin = 0, vmax = 255) #multiplied for display purposes
plt.colorbar()


# to rescale the angles however you want...
rows = np.where(gray > 180)[0]
cols = np.where(gray > 180)[1] # same lengths!
for i in range(len(rows)):
    gray[rows[i], cols[i]] = gray[rows[i], cols[i]] - 360
    gray[rows[i], cols[i]] *= -1
    #print 'in loop'
gray = abs(gray)
gray = gray.astype(np.uint8)
print gray.dtype

#------------------------------------------------------------------------------

#plt.imshow(gray, cmap = plt.get_cmap('gray'), vmin = 0, vmax = 255)#cmap='Greys_r', vmin = 0, vmax = 180)
fig3 = plt.figure()
plt.imshow(gray)
plt.colorbar()
print 'plotting'
# only works if i keep everythin in bytes for some reason...
ret, thresh = cv2.threshold(gray,0,255,cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)
fig4 = plt.figure()
plt.imshow(thresh)#, cmap = plt.get_cmap('rainbow'))
plt.colorbar()
#cv2.imshow('fig', thresh)
#cv2.waitKey(0)
print 'done'