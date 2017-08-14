% Read all section from ini file
% fileDir: File path to *.ini

function [ sections ] = getAllSections( fileDir )

if ~isempty(fileDir)
    sections = readConfig(fileDir, 'Sections');
else
    fprintf('File dir %s is empty!', fileDir);
end

end

