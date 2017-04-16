function varargout = testone(varargin)
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
guidata(hObject, handles);
varargout{1} = handles.output;
function browse_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile({'*.jpg';'*.jpeg';'*.bmp'},'Select image file to encode');
g=imread(strcat(PathName,FileName));
global a
a=g;
function text_Callback(hObject, eventdata, handles)
function text_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function crypt_Callback(hObject, eventdata, handles)
msg = get(handles.text,'String');
global a;
img = a;
msg_temp = double(msg);
msg_dim = num2str(length(msg_temp));
msg_length = length(msg_dim);
z = 0;
if msg_length < 7
    padtext = 7 - msg_length;
    for z = 1:padtext
        msg_dim = horzcat('0',msg_dim);
    end
    msg_head = horzcat('t',msg_dim);
    % Applying Header To Beginning of Message to be Encoded.
    msg_temp_head = horzcat(msg_head,msg_temp);
end
tot_hiding_pix = max(cumprod(size(img)));
tot_data = max(cumprod(size(msg_temp_head)));
if tot_hiding_pix <= tot_data
     error('Insufficient Hiding Space in Image')
end
enc_key=69;
msg_enc = bitxor(uint8(msg_temp_head),uint8(enc_key));
msg_enc_set = dec2bin(msg_enc, 8);
img_prep = im2uint8(img);
rm = 1; gm = 1; bm = 1;    
rn = 1; gn = 1; bn = 1;
[maxM,maxN] = size(img_prep);
z = 0;
run_time = length(msg_enc_set);
for z = 1:run_time;
    temp_code = msg_enc_set(z,:);
    if str2double(temp_code(1)) == 0
        img_prep(rm,rn,1) = bitand(img_prep(rm,rn,1),uint8(254));
    else
        img_prep(rm,rn,1) = bitor(img_prep(rm,rn,1),uint8(1));
    end
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
    end
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
