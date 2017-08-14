%% Example : INI file reading

% Creation of an example file called "Configuration.ini"
Example_write();

% Initialization
File = 'Configuration.ini';
I = INI('File',File);

% INI file reading
I.read();

% Sections from INI file
Sections = I.get('Sections');

% Sections names
fprintf(1,'Sections of "%s" file :\n',File);

% Sections data
for s = 1:numel(Sections)
    fprintf(1,'- Section "%s"\n',Sections{s});
    disp(I.get(Sections{s}));
end
