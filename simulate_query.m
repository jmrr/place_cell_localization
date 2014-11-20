function simulate_query(FrameNo)
% Query MUST come from Pass 1 of the corridor; Dictionary and descriptors
% are already create, so pre-indexing has already been done, and is 
% held in the Chi^2 similarity kernel that is loaded from C2_kernel..
% HA_chi2_P2345678910_1.mat.
% 
% One COULD, of course, pass the image file-name in, but since there is a
% one-to-one correspondence between the name and the row of the Kernel
% matrix, there is really no need to do this.
%
% This directory should reside ABOVE the v5,v6 etc directory (Corridors) ?
%
% NEEDS C2_kernel_HA_chi2_P2345678910_1.mat in it's own directory
%
% Calling syntax: simulate_query(FrameNo)
%    

Ext = '.jpg';
Vdir= 'v6.0/C2/videos';
DecodeVersion = 'frames_resized_w208p';
load C2_kernel_HA_chi2_P2345678910_1.mat;
DBCorridorNames = {'2','3','4','5','6','7','8','9'};
QueryCorridorName = '1';
RootPath = pwd;

QueryDir = [RootPath,'/',Vdir,'/',QueryCorridorName,'/',...
    DecodeVersion,'/'];
QueryImageList = dir([QueryDir,'*',Ext]);

QueryImageName = QueryImageList(FrameNo).name;
QI = imread([QueryDir,QueryImageName]);

for i = 1:9
    KLine = Kernel{i}(FrameNo,:);
    [BestMax(i), BestFrame(i)] = max(KLine);
end

[SortedMax,I] = sort(BestMax,'descend');  % I(1) will contain the best pass

BestPass = I(1);
BestFrameOfBestPass = BestFrame(I(1));

BestPassDir = [RootPath,'/',Vdir,'/',DBCorridorNames{BestPass},'/',...
    DecodeVersion,'/'];
DBImageList = dir([BestPassDir,'*',Ext]);

 % Sanity Check
 KLine = Kernel{BestPass}(FrameNo,:);
 if length(KLine) ~= length(DBImageList)
     error('Path length inconsistent with Kernel column dimension');
 end

 BestFrameOfBestPass;
 BestMatchFilename = DBImageList(BestFrameOfBestPass).name;
 
 DBI1 = imread([BestPassDir,BestMatchFilename]);

 
 subplot(1,2,1);imagesc(QI);title('Query');axis off;
 subplot(1,2,2);imagesc(DBI1); title('Best Match');axis off;
disp('');
%