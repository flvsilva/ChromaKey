clear all;
clc;
close all
BLUE = imread('p1.jpg');     Thr_RL = 5; Thr_RH = 90;   Thr_GL = 80;   Thr_GH = 185;     Thr_B = 100; Thr_BH = 255;
BG = imread('back2.jpg');

 [y,x,z] = size(BLUE);

shiftY = 70;   shiftX = 185;
BG_R = BG(shiftY:shiftY+y-1, shiftX:shiftX+x-1,1);
BG_G = BG(shiftY:shiftY+y-1, shiftX:shiftX+x-1,2);
BG_B = BG(shiftY:shiftY+y-1, shiftX:shiftX+x-1,3);
BG(:,:,1) = BG_R;
BG(:,:,2) = BG_G;
BG(:,:,3) = BG_B;

R_BLUE = BLUE(:,:,1);
G_BLUE = BLUE(:,:,2);
B_BLUE = BLUE(:,:,3);
BackGround = BG;

for i = 1:x*y
    if R_BLUE(i)>=Thr_RL && R_BLUE(i)<=Thr_RH
        MaskR(i) = 1;
    else 
        MaskR(i) = 0;
    end
    if G_BLUE(i)>=Thr_GL && G_BLUE(i)<=Thr_GH
        MaskG(i) = 1;
    else 
        MaskG(i) = 0;
    end
    if B_BLUE(i)>=Thr_B && B_BLUE(i)<=Thr_BH
        MaskB(i) = 1;
    else 
        MaskB(i) = 0;
    end
end
MaskR = MaskR';
MaskG = MaskG';
MaskB = MaskB';
Mask = MaskR .*MaskG .* MaskB;
for j = 1:x
    MASK_R(1:y, j) = MaskR(j*y-y+1:(1+j)*y-y);
    MASK_G(1:y, j) = MaskG(j*y-y+1:(1+j)*y-y);
    MASK_B(1:y, j) = MaskB(j*y-y+1:(1+j)*y-y);    
    MASK(1:y, j)   = Mask(j*y-y+1:(1+j)*y-y);    
end
MaskR = MASK_R;
MaskG = MASK_G;
MaskB = MASK_B;
Mask = MASK;
MASK_R = uint8(MASK_R);
MASK_G = uint8(MASK_G);
MASK_B = uint8(MASK_B);
MASK = uint8(MASK);

MASK = MASK_R .* MASK_G .* MASK_B;

BG(:,:,1) = MASK .* BG(:,:,1);    
BG(:,:,2) = MASK .* BG(:,:,2);    
BG(:,:,3) = MASK .* BG(:,:,3);    

Mask_FG = abs(Mask - 1);
MASK_FG = uint8(Mask_FG);    
FG(:,:,1) = MASK_FG .* BLUE(:,:,1);    
FG(:,:,2) = MASK_FG .* BLUE(:,:,2);    
FG(:,:,3) = MASK_FG .* BLUE(:,:,3);    

FImage = FG + BG;

figure(1)
subplot(431); imshow(BLUE); title('Imagem Original'); ylabel('RGB'); 
subplot(433); imshow(Mask); title('Mask'); ylabel('Final Mask')

figure(2)
subplot(421); imshow(BLUE);         ylabel('Imagem Original: Foreground'); title('ForeGround')
subplot(422); imshow(BackGround);   ylabel('Imagem Original: Background'); title('BackGround')
subplot(423); imshow(Mask);         ylabel('Foreground Mask')
subplot(424); imshow(Mask_FG);       ylabel('Background Mask')
subplot(425); imshow(FG);           ylabel('Chroma Keyed Foreground')
subplot(426); imshow(BG);           ylabel('Chroma Keyed Background')
subplot(414); imshow(FImage);       title('Imagem final (Chroma Keyed) :)');


figure(3)
imshow(FImage); title('Imagem final')
