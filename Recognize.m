close all
clear all
clc
delete('Frames\*.jpg');
[filename, pathname] = uigetfile({'*.avi'},'Select A Video File'); 
I = VideoReader([pathname,filename]);
implay([pathname,filename]);
pause(3);
nFrames = I.numberofFrames;
vidHeight =  I.Height;
vidWidth =  I.Width;
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);
       WantedFrames = 10;
for k = 1:WantedFrames
    mov(k).cdata = read( I, k);
   mov(k).cdata = imresize(mov(k).cdata,[256,256]);
    imwrite(mov(k).cdata,['Frames\',num2str(k),'.jpg']);
end

for I = 1:WantedFrames
   im=imread(['Frames\',num2str(I),'.jpg']);
    figure(1),subplot(2,5,I),imshow(im);
end
clc
for i=1:WantedFrames
    disp(['Processing frame no.',num2str(i)]);
  img=imread(['Frames\',num2str(i),'.jpg']);
  f1=il_rgb2gray(double(img));
  [ysize,xsize]=size(f1);
  nptsmax=40;   
  kparam=0.04;  
  pointtype=1;  
  sxl2=4;       
  sxi2=2*sxl2;  
  % detect points
  [posinit,valinit]=STIP(f1,kparam,sxl2,sxi2,pointtype,nptsmax);
  Test_Feat(i,1:40)=valinit;

  % figure(2),imshow();
  %imshow(f1,[]), hold on
 % axis off;
 % showellipticfeatures(posinit,[1 1 0]);
 % title('Feature Points','fontsize',12,'fontname','Times New Roman','color','Black')
end

% Use KNN To classify the videos
load('TrainFeat.mat')
X = meas;
Y = New_Label;
Z = Test_Feat;
% Now Classify

ens = fitensemble(X,Y,'Subspace',300,'KNN');
class = predict(ens,Z(1,:))
md1 = ClassificationKNN.fit(X,Y);

Type = predict(md1,Z);
if (Type == 1)
    f = msgbox('ACTIVITY RECOGNIZED');
    disp('Boxing');
    helpdlg(' Boxing ','RESULT');
elseif (Type == 2)
     f = msgbox('ACTIVITY RECOGNIZED');
    disp('Hand Clapping');
    helpdlg('Hand Clapping','RESULT');
elseif (Type == 3)
     f = msgbox('ACTIVITY RECOGNIZED');
    disp('Hand Waving');
    helpdlg('Hand Waving','RESULT');
elseif (Type == 4)
     f = msgbox('ACTIVITY RECOGNIZED');
    disp('Jogging');
    helpdlg('Jogging','RESULT');
elseif (Type == 5)
     f = msgbox('ACTIVITY RECOGNIZED');
    disp('Running');
    helpdlg('Running','RESULT');
elseif (Type == 6)
     f = msgbox('ACTIVITY RECOGNIZED');
    disp('Walking');
    helpdlg('Walking','RESULT');
elseif (Type == 7)
     f = msgbox('ACTIVITY RECOGNIZED');
    disp('Cycling');
    helpdlg('Cycling','RESULT');
elseif (Type == 8)
     f = msgbox('ACTIVITY RECOGNIZED');
    disp('Surfing');
    helpdlg('Surfing','RESULT');
end
    

