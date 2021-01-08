function varargout = capstone(varargin)
% CAPSTONE MATLAB code for capstone.fig
%      CAPSTONE, by itself, creates a new CAPSTONE or raises the existing
%      singleton*.
%
%      H = CAPSTONE returns the handle to a new CAPSTONE or the handle to
%      the existing singleton*.
%
%      CAPSTONE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAPSTONE.M with the given input arguments.
%
%      CAPSTONE('Property','Value',...) creates a new CAPSTONE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before capstone_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to capstone_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help capstone

% Last Modified by GUIDE v2.5 21-May-2020 13:02:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @capstone_OpeningFcn, ...
                   'gui_OutputFcn',  @capstone_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before capstone is made visible.
function capstone_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to capstone (see VARARGIN)

% Choose default command line output for capstone
handles.output = hObject;
ah=axes('unit','normalized','position',[0 0 1 1]);
%bg=imread('Files\1.jpg'); imagesc(bg);
set(ah,'handlevisibility','off','visible','off');
uistack(ah,'bottom');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes capstone wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = capstone_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Input.
function Input_Callback(hObject, eventdata, handles)
clc
global vfilename;
global vpathname;
global nFrames;
global vi;
global k
delete('Frames\*.jpg');
[ vfilename, vpathname ] = uigetfile( 'dataset\*.avi', 'Select an video' );
I=VideoReader([ vpathname, vfilename ]);
nFrames = I.numberofFrames;
vidHeight =  I.Height;
vidWidth =  I.Width;
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);
for k = 1: nFrames
    mov(k).cdata = read( I, k);
   mov(k).cdata = imresize(mov(k).cdata,[256,256]);
    imwrite(mov(k).cdata,['Frames\',num2str(k),'.jpg']);
end


for j= 10:60
    r=imread(['Frames\',num2str(j),'.jpg']);
    axes(handles.axes1);
    imshow(r);

    title('Selected Video','fontsize',14,'fontname','Times New Roman','color','Black');
    axis off;
end
% hObject    handle to Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in extractframes.
function extractframes_Callback(hObject, eventdata, handles)
for I = 1:15
    im=imread(['Frames\',num2str(I),'.jpg']);
      figure(1),subplot(3,5,I),imshow(im);
   %   oldmsgs = cellstr(get(handles.edit1,'String'));
%set(handles.edit1,'String',oldmsgs );
   % figure(1),subplot(2,5,I),imshow(im);
    %g = imread('kasus5.png');
    %axes(handles.axes(I));
    %imshow(im);
    %axis off;
end
  %imshow(f1,[]), hold on
 % axis off;
 % showellipticfeatures(posinit,[1 1 0]);
 % title('Feature Points','fontsize',12,'fontname','Times New Roman','color','Black')

% hObject    handle to extractframes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in recognise.
function recognise_Callback(hObject, eventdata, handles)
WantedFrames = 10;
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

%ens = fitensemble(X,Y,'Subspace',300,'KNN');
%class = predict(ens,Z(1,:))
md1 = ClassificationKNN.fit(X,Y);
Type = predict(md1,Z);
if (Type == 1)
   % f = msgbox('ACTIVITY RECOGNIZED');
    disp('Boxing');
     M='BOXING';    
     string1 = sprintf(M);
     set(handles.edit1, 'String', string1);

elseif (Type == 2)
       M='HAND CLAPPING';    
string1 = sprintf(M);
set(handles.edit1, 'String', string1);
    
elseif (Type == 3)
    disp('Hand Waving');
         M='HAND WAVING';    
string1 = sprintf(M);
set(handles.edit1, 'String', string1);
elseif (Type == 4)
    disp('Jogging');
        M='JOGGING';    
string1 = sprintf(M);
set(handles.edit1, 'String', string1);
elseif (Type == 5)
    disp('Running');
      M='RUNNING';    
string1 = sprintf(M);
set(handles.edit1, 'String', string1);
elseif (Type == 6)
    disp('Walking');
        M='WALKING';    
string1 = sprintf(M);
set(handles.edit1, 'String', string1);
elseif (Type == 7)
    disp('Cycling');
        M='CYCLING';    
string1 = sprintf(M);
set(handles.edit1, 'String', string1);
elseif (Type == 8)
    disp('Surfing');
     M='SURFING';    
string1 = sprintf(M);
set(handles.edit1, 'String', string1);
end
    
% hObject    handle to recognise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in endtask.
function endtask_Callback(hObject, eventdata, handles)
% hObject    handle to endtask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --- Executes on button press in Accuracy.
function Accuracy_Callback(hObject, eventdata, handles)
% hObject    handle to Accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global class
load Truelabel
Performance=classperf(class,Truelabel);
Accuracy=Performance.CorrectRate*100;
set(handles.edit2,'Visible','on');
set(handles.text1,'Visible','on');
set(handles.edit2,'string',[num2str(Accuracy),'%'])



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in feature.
function feature_Callback(hObject, eventdata, handles)
% hObject    handle to feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nFrames
for i=1:nFrames
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
  Testfeature(i,1:40)=valinit;
  axes(handles.axes1)
  imshow(f1,[]), hold on
  axis off;
  showellipticfeatures(posinit,[1 1 0]);
  title('Feature Points','fontsize',12,'fontname','Times New Roman','color','Black')
end
set(handles.uitable1,'Visible','on');
set(handles.uitable1,'data',Testfeature);
save Testfeature Testfeature

