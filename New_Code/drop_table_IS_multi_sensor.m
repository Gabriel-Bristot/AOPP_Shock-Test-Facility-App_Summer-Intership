% This is the main program of the shock test facility =====================

% Clearing variables ======================================================
clear all;
close all;
clc;

%==========================================================================
% Start of Reading User Input =============================================
%==========================================================================

% File location for the program, this wil be called the repository from now
filename = 'H:\MATLAB\New_Code';

% Checks if "dd-MMM-yyyy" with current date exists in the repository
if(exist([filename,date]))

else
    % Creates a file named "dd-MMM-yyyy" in the repository if it did not
    % exist already
    status = mkdir([filename,date]); 
end

% Changes filename while not changing variable name
filename = [filename,'\'];

% Reading the droptable _options file and the whole text is stored in
% variable "A"
fileID = fopen('droptable_options.txt','r');
A = fscanf(fileID,'%c');

% Replacing spaces with "nothing"
A = strrep(A,' ','');

% Extract from options file what NI_DAQ1name is ===========================
k = strfind(A,'NI_DAQ1name=');

% Checking if the user inputed the name correctly
if(isempty(k))
    disp('Please check input file contains string : "NI_DAQ1name="')
    return

elseif(length(k)>2)
    disp('Please check input file contains only 1 string : "NI_DAQ1name="')
    return
end

% Another check of user input (wont be needed if done in the matlab app)
k1=k;
k = strfind(A(k+12:k+20),'"');
if(isempty(k))
    disp('Please check input file contains NI_DAQ1name= "name"')
    return
elseif(length(k)~=2)
    disp('Please check input file contains NI_DAQ1name= "name" only once')
    return
end

% Extracting the value for "NI_DAQ1_name"
NI_DAQ1_name = A(k1+k(1)+12:k1+k(2)+10);

% Number of devices is 2 but the code can accomodate for 1 as seen below
number_of_expected_devices = 2;

% Extract from options file what NI_DAQ2name is ===========================
k = strfind(A,'NI_DAQ2name=');

% Checking if dev 2 is "selected"
if(isempty(k))

    % Continuing code without second device
    fprintf("No second NI DAQ detected. Continuing with only one DAQ")
    NI_DAQ2_name = 0;
    number_of_expected_devices = 1;

elseif(length(k)>1)

    % Error if repeated name
    disp('Please check input file contains NI_DAQ2name= "name" only once')

    return

else

    k1=k;
    k = strfind(A(k+12:k+20),'"');

    if(isempty(k))
        fprintf("No second NI DAQ detected. Continuing with only one DAQ")
        NI_DAQ2_name = 0;
        number_of_expected_devices = 1;
    elseif(length(k)~=2)
        disp('Please check input file contains NI_DAQ2name= "name" only once')
        return

    end

    % If it passes all error checks it stores the "NI_DAQ2_name"
    NI_DAQ2_name = A(k1+k(1)+12:k1+k(2)+10);

end

% Check that NI_DAQ names match that found by matlab ======================

% Device type
d = daqlist("ni");

% Detecting if the number of devices matches the users input
if(size(d.DeviceID,1)~=number_of_expected_devices)

    if(size(d.DeviceID,2)==1)
        
        % Continues with only 1 device
        disp('Only one NI DAQ detected continuing with just one device')
        number_of_expected_devices = 1;

    else
        
        % Error message if no devices are detected
        disp('The number of NI DAQ devices found on the laptop does not match the number requested in the input file')

        return
    end
end

% Checking if the name given by user matches the device ID for first device
if(number_of_expected_devices==1)

    if(strcmp(d.DeviceID(1),NI_DAQ1_name))
        
    else

        % Error message if user input does not match ID
        disp('Please check input file NI_DAQ1name is correct')
        return
    end
else

    % Checking if the name given by user matches the device ID for both devices
    if( strcmp(d.DeviceID(1),NI_DAQ1_name) && strcmp(d.DeviceID(2),NI_DAQ2_name) || strcmp(d.DeviceID(2),NI_DAQ1_name) && strcmp(d.DeviceID(1),NI_DAQ2_name))

    else

       % Error message if user input does not match ID
       disp('Please check input file NI_DAQ1name and NI_DAQ2name is correct')
       return
    end
end

% Now extract the number of channels on each device =======================

% Finds where the answer is the the txt file
k = strfind(A,'DEV1_sensor_CH0=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1 (Same code repeated 12 times)
if(isempty(k))
    DEV1_CH0 = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV1_CH0 = (A(k1+k(1):k1+k(2)-2));
    else
        DEV1_CH0 = -1;
    end
end

% Finds where the answer is the the txt file
k = strfind(A,'DEV1_sensor_CH1=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1
if(isempty(k))
    DEV1_CH1 = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV1_CH1 = (A(k1+k(1):k1+k(2)-2));
    else
        DEV1_CH1 = -1;
    end
end

% Finds where the answer is the the txt file
k = strfind(A,'DEV1_sensor_CH2=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1
if(isempty(k))
    DEV1_CH2 = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV1_CH2 = (A(k1+k(1):k1+k(2)-2));
    else
        DEV1_CH2 = -1;
    end
end

% Now extract the number of channels on each device =======================

% Finds where the answer is the the txt file
k = strfind(A,'DEV2_sensor_CH0=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1
if(isempty(k))
    DEV2_CH0 = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV2_CH0 = (A(k1+k(1):k1+k(2)-2));
    else
        DEV2_CH0 = -1;
    end
end

% Finds where the answer is the the txt file
k = strfind(A,'DEV2_sensor_CH1=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1
if(isempty(k))
    DEV2_CH1 = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV2_CH1 = (A(k1+k(1):k1+k(2)-2));
    else
        DEV2_CH1 = -1;
    end
end

% Finds where the answer is the the txt file
k = strfind(A,'DEV2_sensor_CH2=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1
if(isempty(k))
    DEV2_CH2 = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV2_CH2 = (A(k1+k(1):k1+k(2)-2));
    else
        DEV2_CH2 = -1;
    end
end

% Extract gains ===========================================================

% Finds where the answer is the the txt file
k = strfind(A,'DEV1_sensor_CH0_gain=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1
if(isempty(k))
    DEV1_CH0_gain = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV1_CH0_gain = str2num(A(k1+k(1):k1+k(2)-2));
    else
        DEV1_CH0_gain = -1;
    end
end

% Finds where the answer is the the txt file
k = strfind(A,'DEV1_sensor_CH1_gain=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1
if(isempty(k))
    DEV1_CH1_gain = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV1_CH1_gain = str2num(A(k1+k(1):k1+k(2)-2));
    else
        DEV1_CH1_gain = -1;
    end
end

% Finds where the answer is the the txt file
k = strfind(A,'DEV1_sensor_CH2_gain=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1
if(isempty(k))
    DEV1_CH2_gain = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV1_CH2_gain = str2num(A(k1+k(1):k1+k(2)-2));
    else
        DEV1_CH2_gain = -1;
    end
end

% Finds where the answer is the the txt file
k = strfind(A,'DEV2_sensor_CH0_gain=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1
if(isempty(k))
    DEV2_CH0_gain = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV2_CH0_gain = str2num(A(k1+k(1):k1+k(2)-2));
    else
        DEV2_CH0_gain = -1;
    end
end

% Finds where the answer is the the txt file
k = strfind(A,'DEV2_sensor_CH1_gain=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1
if(isempty(k))
    DEV2_CH1_gain = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV2_CH1_gain = str2num(A(k1+k(1):k1+k(2)-2));
    else
        DEV2_CH1_gain = -1;
    end
end

% Finds where the answer is the the txt file
k = strfind(A,'DEV2_sensor_CH2_gain=');

% Checking the validity of the input of the user and if it is invalid set
% it to -1
if(isempty(k))
    DEV2_CH2_gain = -1;
elseif(length(k)>1)
    return
else
    new_line_ind = find(ismember(A(k:end),char(13))==1);
    k1 = k;
    k = strfind(A(k:end),'"');   
    if(k(2)<new_line_ind(1))
        DEV2_CH2_gain = str2num(A(k1+k(1):k1+k(2)-2));
    else
        DEV2_CH2_gain = -1;
    end
end

% Defining the the sensor gains
sensor_gains(1) = 1/(DEV1_CH0_gain*1e-6);
sensor_gains(2) = 1/(DEV1_CH1_gain*1e-6);
sensor_gains(3) = 1/(DEV1_CH2_gain*1e-6);
sensor_gains(4) = 1/(DEV2_CH0_gain*1e-6);
sensor_gains(5) = 1/(DEV2_CH1_gain*1e-6);
sensor_gains(6) = 1/(DEV2_CH2_gain*1e-6);

% Extract the sample rate =================================================

% Finds where the answer is the the txt file
k = strfind(A,'sample_rate=');

% If it is invalid do nothing?
if(isempty(k))
    return
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    sample_rate = str2num(A(k1+k(1):k1+k(2)-2));
else
    return
end

% Extract the sample duration =============================================

% Finds where the answer is the the txt file
k = strfind(A,'sample_duration=');

% If it is invalid do nothing?
if(isempty(k))
    return
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    sample_duration = str2num(A(k1+k(1):k1+k(2)-2));
else
    return
end

% Extract the specification ===============================================

% Finds where the answer is the the txt file
k = strfind(A,'spec_freq=');

% If it is invalid do nothing?
if(isempty(k))
    return
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    spec_freq = str2num(A(k1+k(1):k1+k(2)-2));
else
    return
end

% Extract the specification ===============================================

% Finds where the answer is the the txt file
k = strfind(A,'spec_freq_x=');

% If it is invalid do nothing?
if(isempty(k))
    return
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    spec_freq_x = str2num(A(k1+k(1):k1+k(2)-2));
else
    return
end

% Extract the specification ===============================================

% Finds where the answer is the the txt file
k = strfind(A,'spec_freq_y=');

% If it is invalid do nothing?
if(isempty(k))
    return
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    spec_freq_y = str2num(A(k1+k(1):k1+k(2)-2));
else
    return
end

% Extract the specification ===============================================

% Finds where the answer is the the txt file
k = strfind(A,'spec_freq_z=');

% If it is invalid do nothing?
if(isempty(k))
    return
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    spec_freq_z = str2num(A(k1+k(1):k1+k(2)-2));
else
    return
end

% Finds where the answer is the the txt file
k = strfind(A,'spec_SRS=');

% If it is invalid do nothing?
if(isempty(k))
    return
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    spec_SRS = str2num(A(k1+k(1):k1+k(2)-2));
else
    return
end

if(size(spec_freq,2)~=size(spec_SRS,2))
    return
end

% Finds where the answer is the the txt file
k = strfind(A,'spec_SRS_x=');

% If it is invalid do nothing?
if(isempty(k))
    return
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    spec_SRS_x = str2num(A(k1+k(1):k1+k(2)-2));
else
    return
end

if(size(spec_freq_x,2)~=size(spec_SRS_x,2))
    return
end

% Finds where the answer is the the txt file
k = strfind(A,'spec_SRS_y=');

% If it is invalid do nothing?
if(isempty(k))
    return
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    spec_SRS_y = str2num(A(k1+k(1):k1+k(2)-2));
else
    return
end

if(size(spec_freq_x,2)~=size(spec_SRS_y,2))
    return
end

% Finds where the answer is the the txt file
k = strfind(A,'spec_SRS_z=');

% If it is invalid do nothing?
if(isempty(k))
    return
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    spec_SRS_z = str2num(A(k1+k(1):k1+k(2)-2));
else
    return
end

% Is this implemented correctly?
if(size(spec_freq_z,2)~=size(spec_SRS_z,2))
    return
end

% Extract if want to plot data ============================================

% Finds where the answer is the the txt file
k = strfind(A,'plot_data=');

% Plot data if user says so
if(isempty(k))
    plot_data = 0;
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    if(strcmp(A(k1+k(1):k1+k(2)-2),'true'))
        plot_data = 1;
    elseif(strcmp(A(k1+k(1):k1+k(2)-2),'1'))
        plot_data = 1;
    else
        plot_data = 0;
    end
else
    plot_data = 0;
end

% Extract description for log file ========================================

% Finds where the answer is the the txt file
k = strfind(A,'description_for_log_file=');

% If user says "yes" set to 1 otherwise set to 0
if(isempty(k))
    log_file = 0;
elseif(length(k)>1)
    return
end

new_line_ind = find(ismember(A(k:end),char(13))==1);
k1 = k;
k = strfind(A(k:end),'"');   
if(k(2)<new_line_ind(1))
    if(strcmp(A(k1+k(1):k1+k(2)-2),'true'))
        log_file = 1;
    elseif(strcmp(A(k1+k(1):k1+k(2)-2),'1'))
        log_file = 1;
    else
        log_file = 0;
    end
else
    log_file = 0;
end

start_file_ind = new_line_ind(1) + k1;
B = A(start_file_ind:end);

% Find all descriptions
if(log_file ==1)
    list_dis_header_ind = strfind(B,'*');
    list_dis_ind = strfind(B,'"');
    test = (-1)^size(list_dis_ind,2);
    if(test==-1)
        return
    end
    test = (-1)^size(list_dis_header_ind,2);
    if(test==-1)
        return
    end    
    count = 1;
    for i_loop=1:length(list_dis_header_ind)/2
        dis_header{i_loop} = B(list_dis_header_ind(count)+1:list_dis_header_ind(count+1)-1);
        dis{i_loop} = B(list_dis_ind(count)+1:list_dis_ind(count+1)-1);
        count = count +2;        
    end
end

% Closing file
fclose(fileID);

%==========================================================================
% Start of Actual Logic ===================================================
%==========================================================================

% Starts the config for the dataloggers
s = daq.createSession('ni');

% User selected sample rate
s.Rate = sample_rate*1000;

% User selected sample duration
s.DurationInSeconds = sample_duration;

% If the Channels are valid and selected by user then configure them 
if(DEV1_CH0~=-1)
    DEV1ch0 = addAnalogInputChannel(s,NI_DAQ1_name, 0, 'Voltage');
end
if(DEV1_CH1~=-1)
    DEV1ch1 = addAnalogInputChannel(s,NI_DAQ1_name, 1, 'Voltage');
end
if(DEV1_CH2~=-1)
    DEV1ch2 = addAnalogInputChannel(s,NI_DAQ1_name, 2, 'Voltage');
end

% If the number of devices selected detected is 2 do the same check for
% those channels and configure them
if(number_of_expected_devices==2)
    if(DEV2_CH0~=-1)
        DEV2ch0 = addAnalogInputChannel(s,NI_DAQ2_name, 1, 'Voltage');
    end
    if(DEV2_CH1~=-1)
        DEV2ch1 = addAnalogInputChannel(s,NI_DAQ2_name, 2, 'Voltage');
    end
    if(DEV2_CH2~=-1)
        DEV2ch2 = addAnalogInputChannel(s,NI_DAQ2_name, 3, 'Voltage');
    end
end

% Start timer (Should do a red-yellow-green-red cycle)
pause(2)
fprintf('ready\n');
pause(2)
fprintf('DROP!\n');
beep

% Configuring the dataloggers
[all_data,time] = s.startForeground;


% Save raw data ===========================================================

clocknow = clock;
timeid = datestr(clocknow,'yyyymmddHHMMSS');
save([filename,timeid,'.mat'],'all_data','time')

sample_rate = s.Rate/1000;

% Save the logfile ========================================================

if(log_file==1)
    fileID = fopen([filename,timeid,'.txt'],'w');
    fprintf("saving log file : \n")    
    for i_loop=1:length(dis_header)
        fprintf(fileID,[dis_header{i_loop},' : ',dis{i_loop},'\n']);
        fprintf(['\t',dis_header{i_loop},' : ',dis{i_loop},'\n']);
    end
    fprintf(fileID,['\n','sample_rate = ',num2str(sample_rate),' KHz\nsample_duration = ',num2str(sample_duration) ...
        ' sec\nDevices connected = ',num2str(number_of_expected_devices),'\n']);
    fprintf(['\n\t','sample_rate = ',num2str(sample_rate),' KHz\n\tsample_duration = ',num2str(sample_duration) ...
        ' sec\n\tDevices connected = ',num2str(number_of_expected_devices),'\n']);
    fprintf(fileID,['\n','DEV1_CH0_sensor/gain = ',DEV1_CH0,'/',num2str(DEV1_CH0_gain) ...
                         '\nDEV1_CH1_sensor/gain = ',DEV1_CH1,'/',num2str(DEV1_CH1_gain) ...
                         '\nDEV1_CH2_sensor/gain = ',DEV1_CH2,'/',num2str(DEV1_CH2_gain),'\n']);
    fprintf(['\n\t','DEV1_CH0_sensor/gain = ',DEV1_CH0,'/',num2str(DEV1_CH0_gain) ...
                  '\n\tDEV1_CH1_sensor/gain = ',DEV1_CH1,'/',num2str(DEV1_CH1_gain) ...
                  '\n\tDEV1_CH2_sensor/gain = ',DEV1_CH2,'/',num2str(DEV1_CH2_gain),'\n'])    

    if(number_of_expected_devices==2)
        fprintf(fileID,['\n','DEV2_CH0_sensor/gain = ',DEV2_CH0,'/',num2str(DEV2_CH0_gain) ...
                             '\nDEV2_CH1_sensor/gain = ',DEV2_CH1,'/',num2str(DEV2_CH1_gain) ...
                             '\nDEV2_CH2_sensor/gain = ',DEV2_CH2,'/',num2str(DEV2_CH2_gain),'\n']);
        fprintf(['\n\t','DEV2_CH0_sensor/gain = ',DEV2_CH0,'/',num2str(DEV2_CH0_gain) ...
                      '\n\tDEV2_CH1_sensor/gain = ',DEV2_CH1,'/',num2str(DEV2_CH1_gain) ...
                      '\n\tDEV2_CH2_sensor/gain = ',DEV2_CH2,'/',num2str(DEV2_CH2_gain),'\n'])  
    end

    fprintf('\n\t%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n\n');

end

clear A


test = diff(all_data(:,1)*DEV1_CH0_gain);
impact_point = 0;
for i_loop=1:length(test)
    if(abs(test(i_loop)) > 5)
        impact_point = i_loop;
        break
    end
end

test = diff(all_data(:,4)*DEV2_CH0_gain);
impact_point2 = 0;
for i_loop=1:length(test)
    if(abs(test(i_loop)) > 5)
        impact_point2 = i_loop;
        break
    end
end

if (impact_point <100 && impact_point2 <100)
% if (impact_point <100 )    
    disp('ERROR : cannot find impact point - so no SRS data calculated')
    disp('ERROR : exiting script early')
    disp('NOTE : SRS is calculated looking for an impact point on DEV1 ch0 or DEV2 ch0')
    disp('NOTE : See figure 1 and 2 for time plots of recorded acceleration')
    disp('NOTE : It is possible that the drop is too small to be detected.')
    disp('NOTE : Signal must be >10.')
    figure(1)
    clf
    plot(time,all_data(:,1)*DEV1_CH0_gain)
    title("CH0 DEV1")
    xlabel('time')
    figure(2)
    clf
    plot(time,all_data(:,4)*DEV1_CH0_gain)
    title("CH0 DEV2")
    xlabel('time')    
    return
end

dev = 1;

if (impact_point2 <100)
    disp('ERROR : cannot find impact point on DEV2 - so no SRS data calculated for DEV2')
    number_of_expected_devices = 1;
end

if (impact_point <100)
    disp('ERROR : cannot find impact point on DEV1 - so no SRS data calculated for DEV2') 
    number_of_expected_devices = 1;
    dev = 4;
end

%==========================================================================
% Start of Plotting =======================================================
%==========================================================================

figure(1)
clf
figure(2)
clf
figure(3)
clf
hold on
figure(4)
clf
hold on

shock_length = 10000;

for j_loop=1:number_of_expected_devices
    for i_loop=dev:dev+2
        gain = sensor_gains(i_loop+((j_loop-1)*3));
        
        if(j_loop==1)
            data = cat(2,time([impact_point-100:shock_length+impact_point]),all_data([impact_point-100:shock_length+impact_point],i_loop+((j_loop-1)*3))*gain);
        else
            data = cat(2,time([impact_point2-100:shock_length+impact_point2]),all_data([impact_point2-100:shock_length+impact_point2],i_loop+((j_loop-1)*3))*gain);
        end
        data(:,2) = detrend(data(:,2),'constant');
        velocity=cumtrapz(data(:,1),data(:,2))*9.8;   
        figure(j_loop)        
        subplot(3,2,(i_loop-1)*2+1)
        plot(data(:,1),data(:,2))
        xlim([data(1,1) data(end,1)])
        ylabel('Acceleration (g)')
        title('acceleration')
        subplot(3,2,(i_loop-1)*2+2)
        plot(data(:,1),velocity,'b')
        xlim([data(1,1) data(end,1)])
        xlabel('Seconds')
        title('velocity(m/s)')
        
        clear A
        A = data;
        srs;
        CH_neg(:,i_loop+((j_loop-1)*3)) = x_neg;
        CH_pos(:,i_loop+((j_loop-1)*3)) = x_pos;
        CH_fn(:,i_loop+((j_loop-1)*3)) = fn;        
    end
end

save([filename,timeid,'_SRS_data.mat'],'CH_neg','CH_pos','CH_fn')

% Generate average curves of the +ve and -ve sensors
CH_f = CH_fn(:,1);
CH_X_avg = (CH_pos(:,1)+CH_pos(:,4)-CH_neg(:,1)-CH_neg(:,4))/4;
CH_Y_avg = (CH_pos(:,2)+CH_pos(:,5)-CH_neg(:,2)-CH_neg(:,5))/4;
CH_Z_avg = (CH_pos(:,3)+CH_pos(:,6)-CH_neg(:,3)-CH_neg(:,6))/4;

% Make plots of the individual SRS curves
figure(3)
if(number_of_expected_devices==2)
    plot(CH_fn(:,1),CH_pos(:,1),CH_fn(:,1),abs(CH_neg(:,1)),'-.r');
    plot(CH_fn(:,1),CH_pos(:,4),CH_fn(:,1),abs(CH_neg(:,4)),'-.r');
    plot(CH_fn(:,1),(CH_pos(:,1)+CH_pos(:,4))/2,CH_fn(:,1),(abs(CH_neg(:,1))+abs(CH_neg(:,4)))/2,'-.r');
else
    plot(CH_fn(:,1),CH_pos(:,dev),CH_fn(:,1),abs(CH_neg(:,dev)),'-.r');
end


figure(4)
if(number_of_expected_devices==2)
plot(CH_fn(:,2),CH_pos(:,2),CH_fn(:,2),abs(CH_neg(:,2)),'-.r');
plot(CH_fn(:,5),CH_pos(:,5),CH_fn(:,5),abs(CH_neg(:,5)),'-.r');
plot(CH_fn(:,1),(CH_pos(:,2)+CH_pos(:,5))/2,CH_fn(:,1),(abs(CH_neg(:,2))+abs(CH_neg(:,5)))/2,'-.r');
else
    plot(CH_fn(:,1),CH_pos(:,dev+1),CH_fn(:,1),abs(CH_neg(:,dev+1)),'-.r');
end

figure(5)
clf
hold on
if(number_of_expected_devices==2)
plot(CH_fn(:,3),CH_pos(:,3),CH_fn(:,3),abs(CH_neg(:,3)),'-.r');
plot(CH_fn(:,6),CH_pos(:,6),CH_fn(:,6),abs(CH_neg(:,6)),'-.r');
plot(CH_fn(:,3),(CH_pos(:,3)+CH_pos(:,6))/2,CH_fn(:,1),(abs(CH_neg(:,3))+abs(CH_neg(:,6)))/2,'-.r');
else
    plot(CH_fn(:,1),CH_pos(:,dev+2),CH_fn(:,1),abs(CH_neg(:,dev+2)),'-.r');
end

% Put the limits on the plots
figure(3)
loglog(spec_freq_x,spec_SRS_x,'g','linewidth',1)
%loglog(spec_freq_x,spec_SRS_x*sqrt(2),'--g','linewidth',2)
loglog(spec_freq_x,spec_SRS_x/sqrt(2),'--g','linewidth',2)
loglog(spec_freq_x,spec_SRS_x*2,'--k','linewidth',2)
%loglog(spec_freq_x,spec_SRS_x/2,'--k','linewidth',2)
%legend('Min specification','+/- 6 dB','+/- 3 dB','location','SouthEast');
xlim([20 10000])
set(gca,'MinorGridLineStyle','--','GridLineStyle',':','XScale','log','YScale','log');
grid;
xlim([100 10000])
ylim([1 10000])
title('Channel 0 X-axis')

figure(4)   % comented here..................
loglog(spec_freq_y,spec_SRS_y,'g','linewidth',1)
%loglog(spec_freq_y,spec_SRS_y*sqrt(2),'--g','linewidth',2)
loglog(spec_freq_y,spec_SRS_y/sqrt(2),'--g','linewidth',2)
loglog(spec_freq_y,spec_SRS_y*2,'--k','linewidth',2)
%loglog(spec_freq_y,spec_SRS_y/2,'--k','linewidth',2)
legend('Min specification','+ 6 dB','- 3 dB','location','SouthEast');
xlim([20 10000])
set(gca,'MinorGridLineStyle','--','GridLineStyle',':','XScale','log','YScale','log');
grid;
xlim([100 10000])
ylim([1 10000])
title('Channel 1 Y-axis')
% legend('ch0+','ch0-','ch1+','ch1-','ch2+','ch2-','Spec','+ 3 dB','-3 dB','+ 6 dB','-6dB','location','SouthEast');

figure(5)
loglog(spec_freq_z,spec_SRS_z,'g','linewidth',1)
%loglog(spec_freq_z,spec_SRS_z*sqrt(2),'--g','linewidth',2)
loglog(spec_freq_z,spec_SRS_z/sqrt(2),'--g','linewidth',2)
loglog(spec_freq_z,spec_SRS_z*2,'--k','linewidth',2)
%loglog(spec_freq_z,spec_SRS_z/2,'--k','linewidth',2)
%legend('Min specification','+/- 6 dB','+/- 3 dB','location','SouthEast');
xlim([20 10000])
set(gca,'MinorGridLineStyle','--','GridLineStyle',':','XScale','log','YScale','log');
grid;
xlim([100 10000])
ylim([1 10000])
title('Channel 2 Z-axis')
% legend('ch0+','ch0-','ch1+','ch1-','ch2+','ch2-','Spec','+ 3 dB','-3 dB','+ 6 dB','-6dB','location','SouthEast');


% New code to make avg plot
if(number_of_expected_devices==2)
    figure(6)
    clf
    hold on
  %  plot(CH_fn(:,1),(CH_pos(:,1)+CH_pos(:,4))/2,CH_fn(:,1),(abs(CH_neg(:,1))+abs(CH_neg(:,4)))/2,'-.r');
  %  plot(CH_fn(:,1),(CH_pos(:,2)+CH_pos(:,5))/2,CH_fn(:,1),(abs(CH_neg(:,2))+abs(CH_neg(:,5)))/2,'-.r');
  %  plot(CH_fn(:,1),(CH_pos(:,3)+CH_pos(:,6))/2,CH_fn(:,1),(abs(CH_neg(:,3))+abs(CH_neg(:,6)))/2,'-.r');
  %  plot(CH_fn(:,1),(CH_pos(:,1)+CH_pos(:,4))/2,'-r');
  %  plot(CH_fn(:,1),(CH_pos(:,2)+CH_pos(:,5))/2,'-g');
  %  plot(CH_fn(:,1),(CH_pos(:,3)+CH_pos(:,6))/2,'-b');
  %  loglog(spec_freq,spec_SRS,'g','linewidth',1)
  %  loglog(spec_freq,spec_SRS*sqrt(2),'--g','linewidth',2)
  %  loglog(spec_freq,spec_SRS/sqrt(2),'-.k','linewidth',2)
  %  loglog(spec_freq,spec_SRS*2,'--k','linewidth',2)
  %  loglog(spec_freq,spec_SRS/2,'--k','linewidth',2)
  %  legend('Specification','+ 6 dB','- 3 dB','location','SouthEast');
  %  xlim([20 10000])
  %  set(gca,'MinorGridLineStyle','--','GridLineStyle',':','XScale','log','YScale','log');
  %  grid;
  %  xlim([100 10000])
  %  ylim([1 10000])
  %  title('Average')
  
    loglog(CH_f,CH_X_avg,'LineWidth',2,'DisplayName','X axis',...
    'Color',[0.0745098039215686 0.623529411764706 1]);
    loglog(CH_f,CH_Y_avg,'LineWidth',2,'DisplayName','Y axis',...
        'Color',[1 0.411764705882353 0.16078431372549]);
    loglog(CH_f,CH_Z_avg,'LineWidth',2,'DisplayName','Z axis',...
        'Color',[0.392156862745098 0.831372549019608 0.0745098039215686]);
    
    % Plot the spec SRS + tolerance bands
    
    spec_freq = [100,1000,10000];
    spec_SRS = [10,350,350];
    
    loglog(spec_freq,spec_SRS,'k','linewidth',1,'DisplayName','Target');
    %  loglog(spec_freq,spec_SRS*sqrt(2),'--g','linewidth',2)
    loglog(spec_freq,spec_SRS/sqrt(2),'-.k','linewidth',1,'DisplayName','-3 dB','LineStyle','-.');
    loglog(spec_freq,spec_SRS*2,'--k','linewidth',1,'DisplayName','+6 dB','LineStyle','--');
    
    % Create zlabel
    zlabel('ZLabel');
    
    % Create ylabel
    ylabel({'Peak Acceleration (g)'},'HorizontalAlignment','center');
    
    % Create xlabel
    xlabel({'Frequency (Hz)'},'HorizontalAlignment','center');
    
    % Create title
    title('Acceleration Shock Response Spectrum Q=10',...
        'HorizontalAlignment','center',...
        'FontWeight','bold');
    
    % Uncomment the following line to preserve the X-limits of the axes
    xlim(axes1,[100 10000]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim(axes1,[1 10000]);
    grid(axes1,'on');
    hold(axes1,'off');
    % Set the remaining axes properties
    set(axes1,'GridLineStyle',':','MinorGridLineStyle','--','XMinorTick','on',...
        'XScale','log','YMinorTick','on','YScale','log');
    % Create legend
    legend(axes1,'show');

end


% legend('ch0+','ch0-','ch1+','ch1-','ch2+','ch2-','Spec','+ 3 dB','-3 dB','+ 6 dB','-6dB','location','SouthEast');
% End new code ============================================================

%%% write average data to file

fprintf('\n')
disp([".....Exporting Average SRS data to (",strcat(filename,timeid,"_SRS_data.xlsx"),")....."])
T = table(CH_f,CH_X_avg,CH_Y_avg,CH_Z_avg);

writetable(T,strcat(filename,timeid,'_SRS_data.xlsx'),'Sheet',1,'WriteVariableNames',true);

 %%%save the velocity and acc figures
 fprintf('\n')
 disp("......saving figures.....")
if(number_of_expected_devices==2)
 figure(1)
 saveas(gcf,[filename,timeid,'_time_series_DEV1.jpg'])
 saveas(gcf,[filename,timeid,'_time_series_DEV1.fig'])
 figure(2)
 saveas(gcf,[filename,timeid,'_time_series_DEV2.jpg'])
 saveas(gcf,[filename,timeid,'_time_series_DEV2.fig'])
 figure(3)
 saveas(gcf,[filename,timeid,'_SRS_CH0.jpg'])
 saveas(gcf,[filename,timeid,'_SRS_CH0.fig'])
 figure(4)
 saveas(gcf,[filename,timeid,'_SRS_CH1.jpg'])
 saveas(gcf,[filename,timeid,'_SRS_CH1.fig'])
 figure(5)
 saveas(gcf,[filename,timeid,'_SRS_CH2.jpg'])
 saveas(gcf,[filename,timeid,'_SRS_CH2.fig'])
 figure(6)
 saveas(gcf,[filename,timeid,'_SRS_avg.jpg'])
 saveas(gcf,[filename,timeid,'_SRS_avg.fig'])
else
    if(dev==1)
        figure(3)
    else
        figure(2)
    end
 saveas(gcf,[filename,timeid,'_SRS.fig'])
 saveas(gcf,[filename,timeid,'_SRS.jpg'])
end