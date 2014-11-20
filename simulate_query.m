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
FPS = 30;
Ext = '.jpg';
Vdir= '/media/PictureThis/VISUAL_PATHS/v6.0/C2/videos';
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
SecondBestPass = I(2);
ThirdBestPass = I(3);

BestFrameOfBestPass = BestFrame(BestPass);
BestFrameOfSecondPass = BestFrame(SecondBestPass);
BestFrameOfThirdPass = BestFrame(ThirdBestPass);

BestPassDir = [RootPath,'/',Vdir,'/',DBCorridorNames{BestPass},'/',...
    DecodeVersion,'/'];
DBImageList1 = dir([BestPassDir,'*',Ext]);

SecondBestPassDir = [RootPath,'/',Vdir,'/',DBCorridorNames{SecondBestPass},'/',...
    DecodeVersion,'/'];
DBImageList2 = dir([SecondBestPassDir,'*',Ext]);

ThirdBestPassDir = [RootPath,'/',Vdir,'/',DBCorridorNames{ThirdBestPass},'/',...
    DecodeVersion,'/'];
DBImageList3 = dir([ThirdBestPassDir,'*',Ext]);

 % Sanity Check
 KLine1 = Kernel{BestPass}(FrameNo,:);
 if length(KLine1) ~= length(DBImageList1)
     error('Path length inconsistent with Kernel column dimension');
 end

 KLine2 = Kernel{SecondBestPass}(FrameNo,:);
 if length(KLine2) ~= length(DBImageList2)
     error('Path length inconsistent with Kernel column dimension');
 end
 
 KLine3 = Kernel{ThirdBestPass}(FrameNo,:);
 if length(KLine3) ~= length(DBImageList3)
     error('Path length inconsistent with Kernel column dimension');
 end


 
 BestMatchName1 = DBImageList1(BestFrameOfBestPass).name;
 BestMatchName2 = DBImageList2(BestFrameOfSecondPass).name;
 BestMatchName3 = DBImageList3(BestFrameOfThirdPass).name;
 
 DBI1 = imread([BestPassDir,BestMatchName1]);
 DBI2 = imread([SecondBestPassDir,BestMatchName2]);
 DBI3 = imread([ThirdBestPassDir,BestMatchName3]);
 
 subplot(4,5,[1,2,3,4,6,7,8,9,11,12,13,14]);
 imagesc(QI);axis off
 text(10,110,['t = ',num2str(FrameNo/FPS)],'FontSize',24,'Color','y');
 
 subplot(4,5,5);imagesc(DBI1); axis off;
 text(10,100,['Best Match'],'FontSize',16,'Color','y');
 
 subplot(4,5,10);imagesc(DBI2); axis off;
 text(10,100,['Next Best'],'FontSize',16,'Color','y');

 subplot(4,5,15);imagesc(DBI3); axis off;
 text(10,100,['Third Best'],'FontSize',16,'Color','y');
 
 % Make the filmstrip for the last row
 FirstImageNoInStrip = max(1,BestFrameOfBestPass-FPS);
 LastButOneImageNoInStrip = min(length(KLine1),BestFrameOfBestPass+FPS);
 LastImageNoInStrip = min(length(KLine1),BestFrameOfBestPass+2*FPS);
 
 DBI1M1SEC = imread([BestPassDir,DBImageList1(FirstImageNoInStrip).name]);
 DBI1P1SEC = imread([BestPassDir,DBImageList1(LastButOneImageNoInStrip).name]);
 DBI1P2SEC = imread([BestPassDir,DBImageList1(LastImageNoInStrip).name]);
 
 subplot(4,5,16);imagesc(DBI1M1SEC); 
 ht=text(65,105,'(t-1) s');axis off;set(ht,'FontSize',18,'Color','y');
 subplot(4,5,17);imagesc(DBI1); 
 ht=text(65,105,'t s');axis off;set(ht,'FontSize',18,'Color','y');
 subplot(4,5,18);imagesc(DBI1P1SEC); 
 ht=text(65,105,'(t+1) s');axis off;set(ht,'FontSize',18,'Color','y');
 subplot(4,5,19);imagesc(DBI1P2SEC); 
 ht=text(65,105,'(t+2) s');axis off;set(ht,'FontSize',18,'Color','y');
  
 subplot(4,5,20); 
 h1=plot((1:length(KLine1))/FPS,KLine1/max(KLine1),'r'); hold on
 h2=plot((1:length(KLine2))/FPS,KLine2/max(KLine1),'g'); hold on;
 h3=plot((1:length(KLine3))/FPS,KLine3/max(KLine1),'b');
 set(h1,'LineWidth',2);set(h2,'LineWidth',2);set(h3,'LineWidth',2);
 disp('');hold off
%