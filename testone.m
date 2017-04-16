
% SVNIT SOFTWARE TOOLS 2
% Authors Alkesh Vaghela and Chinmay kalegaonkar

function varargout = testone(varargin)
% TESTONE MATLAB code for testone.fig
%      TESTONE, by itself, creates a new TESTONE or raises the existing
%      singleton*.
%
%      H = TESTONE returns the handle to a new TESTONE or the handle to
%      the existing singleton*.
%
%      TESTONE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTONE.M with the given input arguments.
%
%      TESTONE('Property','Value',...) creates a new TESTONE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testone_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testone_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testone

% Last Modified by GUIDE v2.5 04-Apr-2017 16:25:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testone_OpeningFcn, ...
                   'gui_OutputFcn',  @testone_OutputFcn, ...
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

% --- Executes just before testone is made visible.
function testone_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testone (see VARARGIN)

% Choose default command line output for testone
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testone wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testone_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [filename,pathname,filterindex] = ...
%   uigetfile({'*.jpg','*.jpeg','*.bmp'},'Select the image file');
% above command will select the image file in which message is to be encoded
% if pathname == 0
%   return
% end   %if no file selected function returns null
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FileName,PathName] = uigetfile({'*.jpg';'*.jpeg';'*.bmp'},'Select image file to encode');
g=imread(strcat(PathName,FileName));
global a
a=g;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function text_Callback(hObject, eventdata, handles)

function text_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in crypt.
function crypt_Callback(hObject, eventdata, handles)
% hObject    handle to crypt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
msg = get(handles.text,'String');
global a;
img = a;

msg_temp = double(msg);                  % Converts from ASCII to Integer Values.
msg_dim = num2str(length(msg_temp));     % Matrix dimensions
msg_length = length(msg_dim);            % Length
z = 0;

% Applying Header To Beginning of Message to be Encoded
% Header is used to determine the length of message while decoding

if msg_length < 7
    padtext = 7 - msg_length;
    for z = 1:padtext
        msg_dim = horzcat('0',msg_dim);
    end
    msg_head = horzcat('t',msg_dim); 
    msg_temp_head = horzcat(msg_head,msg_temp);
end

%---------

tot_hiding_pix = max(cumprod(size(img)));
tot_data = max(cumprod(size(msg_temp_head)));           % Calculating cumilative product for Checking

if tot_hiding_pix <= tot_data
     error('Insufficient Hiding Space in Image')        % Image size determines the amount of information that can be encoded
end

enc_key=69;                                             % encoding KEY set by the user

msg_enc = bitxor(uint8(msg_temp_head),uint8(enc_key));  % Key hiding technique

msg_enc_set = dec2bin(msg_enc, 8);

img_prep = im2uint8(img);                               % Converts image to 8 precision integer array



rm = 1; gm = 1; bm = 1;     % Initializing Counters
rn = 1; gn = 1; bn = 1;

[maxM,maxN] = size(img_prep);
z = 0;

% RUN_TIME Variable indicates the number of Message "Words" that need to be
%   encoded in the IMG_PREP "Canvas" Image.
run_time = length(msg_enc_set);

for z = 1:run_time;
    temp_code = msg_enc_set(z,:);
    % Bit 1: Red
    if str2double(temp_code(1)) == 0
        img_prep(rm,rn,1) = bitand(img_prep(rm,rn,1),uint8(254));
    else
        img_prep(rm,rn,1) = bitor(img_prep(rm,rn,1),uint8(1));
    end
    
    rm = rm + 1;
    % This next step is used to determine whether or not we have reached
    %   the end end of the image. We then need to move to the next column
    %   and reset our pattern to the top row. Since we have no idea when we
    %   will reach this point we have to check this EVERY time after we
    %   increase the rm/gm/bm counter.
    if rm > maxM
        rn = rn + 1;
        rm = 1;
    end
    % Bit 2: Green
    if str2double(temp_code(2)) == 0
        img_prep(gm,gn,2) = bitand(img_prep(gm,gn,2),uint8(254));
    else
        img_prep(gm,gn,2) = bitor(img_prep(gm,gn,2),uint8(1));
    end
    
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
    end
    % Bit 3: Blue
    if str2double(temp_code(3)) == 0
        img_prep(bm,bn,3) = bitand(img_prep(bm,bn,3),uint8(254));
    else
        img_prep(bm,bn,3) = bitor(img_prep(bm,bn,3),uint8(1));
    end
    
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    % Bit 4: Blue
    if str2double(temp_code(4)) == 0
        img_prep(bm,bn,3) = bitand(img_prep(bm,bn,3),uint8(254));
    else
        img_prep(bm,bn,3) = bitor(img_prep(bm,bn,3),uint8(1));
    end
    
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    % Bit 5: Green
    if str2double(temp_code(5)) == 0
        img_prep(gm,gn,2) = bitand(img_prep(gm,gn,2),uint8(254));
    else
        img_prep(gm,gn,2) = bitor(img_prep(gm,gn,2),uint8(1));
    end
    
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
    end
    % Bit 6: Red
    if str2double(temp_code(6)) == 0
        img_prep(rm,rn,1) = bitand(img_prep(rm,rn,1),uint8(254));
    else
        img_prep(rm,rn,1) = bitor(img_prep(rm,rn,1),uint8(1));
    end
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
    end
    % Bit 7: Red
    if str2double(temp_code(7)) == 0
        img_prep(rm,rn,1) = bitand(img_prep(rm,rn,1),uint8(254));
    else
        img_prep(rm,rn,1) = bitor(img_prep(rm,rn,1),uint8(1));
    end
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
    end
    % Bit 8: Green
    if str2double(temp_code(8)) == 0
        img_prep(gm,gn,2) = bitand(img_prep(gm,gn,2),uint8(254));
    else
        img_prep(gm,gn,2) = bitor(img_prep(gm,gn,2),uint8(1));
    end
    
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
    end
    
end

J = img_prep;

[file,path]=uiputfile('*.bmp','Save encoded image file as');

imwrite(mat2gray(J),strcat(path,file));
