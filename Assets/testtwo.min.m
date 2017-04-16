function varargout = testtwo(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testtwo_OpeningFcn, ...
                   'gui_OutputFcn',  @testtwo_OutputFcn, ...
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
function testtwo_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = testtwo_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
function browse_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.bmp','Select image file to decode');
g=imread(strcat(PathName,FileName));
global a
a=g;
function decrypt_Callback(hObject, eventdata, handles)
global a;
img = a;
rm = 1; gm = 1; bm = 1;     % Initializing Counters
rn = 1; gn = 1; bn = 1;
header = [];
[maxM, maxN, chan] = size(img);
for z = 1:8;
    temp = zeros(1,8);
    % Red    
    temp(1,1) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    temp(1,2) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end
    temp(1,3) = mod(img(bm,bn,3),2);
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    temp(1,4) = mod(img(bm,bn,3),2);
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    temp(1,5) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end
    temp(1,6) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    temp(1,7) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    temp(1,8) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end      
    tempstr = num2str(temp);
    header = vertcat(header,tempstr);
end
enc_key = 69; 
msg_head_set = bin2dec(header);
temp_head = bitxor(uint8(msg_head_set),uint8(enc_key));
msg_head_set = bin2dec(header);
temp_head = bitxor(uint8(msg_head_set),uint8(enc_key));
dim1 = char(temp_head(2:8));
m = str2double(dim1);
n = 1;    
z = 0;
enc_msg = [];
stopmax = (m * n);
for z = 1:stopmax
    temp = zeros(1,8);
    % Red    
    temp(1,1) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    temp(1,2) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end
    temp(1,3) = mod(img(bm,bn,3),2);
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    temp(1,4) = mod(img(bm,bn,3),2);
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    temp(1,5) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end
    temp(1,6) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    temp(1,7) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    temp(1,8) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end      
    tempstr = num2str(temp);
    enc_msg = vertcat(enc_msg,tempstr);
end

msg_dec_set = bin2dec(enc_msg);
msg_dec = bitxor(uint8(msg_dec_set),uint8(enc_key));

msg_set = msg_dec;
    msg_out = char(msg_set');
    
msg = msg_out;
disp(msg);
set(handles.op2, 'string', msg);



function op2_Callback(hObject, eventdata, handles)


function op2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
