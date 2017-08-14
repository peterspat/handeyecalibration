%% Example : INI file writing

%  Initialisation
I = INI();
File = 'Configuration.ini';

%% Section "Timer"

% Creation of a timer
Timer = timer();

% Add section
I.add('Timer',Timer);

%% Section "Serial"

% Creation of a serial port
COM = serial('COM1');

% Add section
I.add('Serial',COM);

%% Section "UserData"

% Data specified by user
Structure.Field1 = 'Data1';
Structure.Field2 = {'Data21','Data22'};
Structure.Field3 = 'Data3';
UserData = struct('Vector',0:9,'Matrix',ones(3,3),'Structure',Structure);

% Add section
I.add('UserData',UserData);


%% Writing

% Write file
I.write(File);

% Open "Configuration.ini"
winopen(File);