using Images, TestImages
using LinearAlgebra

# Load testimage
img=testimage("mandrill")

# Seperate the RGB channels
channels = channelview(img)

# Low rank approximation of rank k of matrix F
function rank_approx(F::SVD, k)
    U, S, V = F
    M = U[:, 1:k] * Diagonal(S[1:k]) * V[:, 1:k]'
end

# Lets do k singular values
k = 30
#SVD from channel 1
SVDChannel_1=svd(channels[1,:,:])
reducedChannel_1= rank_approx(SVDChannel_1, k)

# Same for channel 2 and three
SVDChannel_2=svd(channels[2,:,:])
reducedChannel_2= rank_approx(SVDChannel_2, k)

SVDChannel_3=svd(channels[3,:,:])
reducedChannel_3= rank_approx(SVDChannel_3, k)

#Regenerate image
colorview(RGB, (reducedChannel_1,reducedChannel_2,reducedChannel_3)...)

#The image is compressed because for each channel we only need to save two small matrices and one vector
# – truncated part of (U, S, V). 
#For example, if the original image is gray image of size (512, 512), and we rebuild the image with 50 singular values, 
#then we only need to save 2×512×50+50 numbers to rebuild the image, while original image has 512×512
#numbers. Hence this gives us a compression ratio 19.55% if we don't consider the storage type.

