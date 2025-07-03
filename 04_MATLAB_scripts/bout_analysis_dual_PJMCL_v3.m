function [ABoutData, BBoutData, ABoutStart, ABoutDuration, BBoutStart, BBoutDuration, AGraphBoutBefore, AGraphBoutAfter, BGraphBoutBefore, BGraphBoutAfter] = bout_analysis_dual_PJMCL_v3(data,dF_FA,dF_FB,TimeFromStart,TimeFromEnd);
data.streams.TTLA.data=data.streams.TTLa.data; %%Comment in and out as needed for different stream labels on blue/black rigs.
data.streams.TTLB.data=data.streams.TTLb.data; %%Comment in and out as needed for different stream labels on blue/black rigs.
% Values for both channels:
Frequency = 1017.25262451172;
thresh = 0.2; % adjust this value to determine if there is or isn't licks
%Criteria for defining a bout:
MinBoutDuration = 0.5; %this is the minimum duration in seconds to define a bout
%cannot find a reference for minimum bout duration
LicksPerSecond = 4.5; % change this value to define the minimum lick rate/s (our mean lick rate = ~8-9 Hz)
%mean lick rate for C57 mice is ~130 ms (Boughter 2007; Johnson 2010). Three
%standard deviations from the the mean is 6.14 licks/sec from the Boughter
%manuscript.
InterBurstInterval = 0.5*Frequency;
%Davis 1992, Beh Neuro, shows that rodents have IBIs of 300 to 500 ms
%Boughter 2007 shows that delays in ILI in a burst are typically less than 500 ms
Start0 = TimeFromStart*Frequency;%Calls TimeFromStart from the Normalization function
Stop0 = length(data.streams.TTLA.data)-TimeFromEnd*Frequency; %Calls TimeFromEnd from the Normalization function
%%


%-------------------------Channel A------------------------------------------------------

ytest = double(data.streams.TTLA.data(round(Start0):round(Stop0)-Frequency));
ymode = ytest - mode(ytest); %shifts TTLs to have a true '0' value
y = abs(ymode); %inverts TTLs, if necessary, so that they are always positive

idxl = y>=thresh;%binary vector indicating where ttl is greater than threshold
idxl(1) = 0; %first item in vector is zero
idx = find(idxl);%indices (times) where ttl is greater than threshold
yest = y(idx-1)<thresh;%indicate if observation before lick was a lick 
h = idx(yest); %indices (times) of individual licks
hnew=[1 h]; %add 1 to the beginning of vector

clear ytest ymode yest idxl idx %MH ADDED 7/22/2020

%Checks distance between each lick
%If distance is greater than InterBurstInterval it is counted as a new bout
bout = [];
for i = 2:length(hnew)
    if hnew(i) - hnew(i-1) < InterBurstInterval
        nboutsstart = 1;
    else
        bout(i) = [hnew(i)];    
    end
end
%Bo is list of bout starts
Bo = nonzeros(bout);
 
%lickss = list indices in h where bouts start 
%(h is vector of ttl indices of individual licks)
lickss = [];
for i=1:length(Bo)
    lickss(i)= [find(h==Bo(i))];
end

%distance from first lick to last lick in bout
ABoutDuration = [];
for i = 1:length(lickss)
  if i < length(lickss)
      ABoutDuration(i) = h(lickss(i+1)-1)-h(lickss(i));
  else
      ABoutDuration(i) = h(length(h))-h(lickss(i));
  end
end

%Outputs 'No Bout A' if the mouse did not lick during the recording
if sum(ABoutDuration)==0
   ABoutData=cell2table({'No Bouts A'});
   AGraphBoutBefore=cell2table({'No Bouts A'});
   AGraphBoutAfter=cell2table({'No Bouts A'});
   ABoutStart=[];
   ABoutDuration=[];
   %FullBoutData=[];
   ReducedBoutData=[];
else

%list indices (in h) of first lick in bout)
%(h is vector of ttl indices of individual licks)
ABoutStart = nonzeros(Bo);
licks=[];
for i=1:length(ABoutStart)
    licks(i)= [find(h==ABoutStart(i))];
end

%calculates licks per bout
ALicksPerBout = [];
for i = 1:length(licks)
    if i < length(licks)
        ALicksPerBout(i)=licks(i+1)-licks(i);
    else
        ALicksPerBout(i)= length(h)-licks(i);
    end
end


%CLEAN UP BOUTS
ABoutDuration = ABoutDuration'/Frequency;
ALicksPerBout=ALicksPerBout';
ABoutStart = ABoutStart/Frequency; 
ALickFrequency = ALicksPerBout./ABoutDuration;

%FullBoutData=[ABoutStart ABoutDuration ALicksPerBout ALickFrequency];
idx = any((ABoutDuration < MinBoutDuration),2);
ABoutDuration(idx,:)=[];
ALicksPerBout(idx,:)=[];
ABoutStart(idx,:)=[];
ALickFrequency(idx,:)=[];

idx = any((ALickFrequency < LicksPerSecond),2);
ABoutDuration(idx,:)=[];
ALicksPerBout(idx,:)=[];
ABoutStart(idx,:)=[];
ALickFrequency(idx,:)=[];
%ReducedBoutData=[ABoutStart ABoutDuration ALicksPerBout ALickFrequency];
end

if sum(ABoutDuration)==0
   ABoutData=cell2table({'No Bouts Met Criteria A'});
   AGraphBoutBefore=cell2table({'No Bouts Met Criteria A'});
   AGraphBoutAfter=cell2table({'No Bouts Met Criteria A'});
   ABoutStart=[];
   ABoutDuration=[];
   %FullBoutData=[];
   ReducedBoutData=[];
else
    
A60to50=[];
A50to40=[];
A40to30=[];
A30to20=[];
A20to10=[];
A10to0=[];
for i = 1:length(ABoutStart)
    if  ABoutStart(i) > 50 && ABoutStart(i) < 60
        A60to50(i) = NaN;
        A50to40(i) = mean(dF_FA(ABoutStart(i)*Frequency-50*Frequency:ABoutStart(i)*Frequency -40*Frequency));
        A40to30(i) = mean(dF_FA(ABoutStart(i)*Frequency-40*Frequency:ABoutStart(i)*Frequency -30*Frequency));
        A30to20(i) = mean(dF_FA(ABoutStart(i)*Frequency-30*Frequency:ABoutStart(i)*Frequency -20*Frequency));
        A20to10(i) = mean(dF_FA(ABoutStart(i)*Frequency-20*Frequency:ABoutStart(i)*Frequency -10*Frequency));
        A10to0(i) = mean(dF_FA(ABoutStart(i)*Frequency-10*Frequency:ABoutStart(i)*Frequency));
    elseif ABoutStart(i) > 40 && ABoutStart(i) < 50
        A60to50(i) = NaN;
        A50to40(i) = NaN;
        A40to30(i) = mean(dF_FA(ABoutStart(i)*Frequency-40*Frequency:ABoutStart(i)*Frequency -30*Frequency));
        A30to20(i) = mean(dF_FA(ABoutStart(i)*Frequency-30*Frequency:ABoutStart(i)*Frequency -20*Frequency));
        A20to10(i) = mean(dF_FA(ABoutStart(i)*Frequency-20*Frequency:ABoutStart(i)*Frequency -10*Frequency));
        A10to0(i) = mean(dF_FA(ABoutStart(i)*Frequency-10*Frequency:ABoutStart(i)*Frequency));
    elseif ABoutStart(i) > 30 && ABoutStart(i) < 40
        A60to50(i) = NaN;
        A50to40(i) = NaN;
        A40to30(i) = NaN;
        A30to20(i) = mean(dF_FA(ABoutStart(i)*Frequency-30*Frequency:ABoutStart(i)*Frequency -20*Frequency));
        A20to10(i) = mean(dF_FA(ABoutStart(i)*Frequency-20*Frequency:ABoutStart(i)*Frequency -10*Frequency));
        A10to0(i) = mean(dF_FA(ABoutStart(i)*Frequency-10*Frequency:ABoutStart(i)*Frequency));
    elseif ABoutStart(i) > 20 && ABoutStart(i) < 30
        A60to50(i) = NaN;
        A50to40(i) = NaN;
        A40to30(i) = NaN;
        A30to20(i) = NaN;
        A20to10(i) = mean(dF_FA(ABoutStart(i)*Frequency-20*Frequency:ABoutStart(i)*Frequency -10*Frequency));
        A10to0(i) = mean(dF_FA(ABoutStart(i)*Frequency-10*Frequency:ABoutStart(i)*Frequency));
    elseif ABoutStart(i) > 10 && ABoutStart(i) < 20
        A60to50(i) = NaN;
        A50to40(i) = NaN;
        A40to30(i) = NaN;
        A30to20(i) = NaN;
        A20to10(i) = NaN;
        A10to0(i) = mean(dF_FA(ABoutStart(i)*Frequency-10*Frequency:ABoutStart(i)*Frequency));
    elseif ABoutStart(i) < 10
        A60to50(i) = NaN;
        A50to40(i) = NaN;
        A40to30(i) = NaN;
        A30to20(i) = NaN;
        A20to10(i) = NaN;
        A10to0(i) = NaN;
     else
        A60to50(i) = mean(dF_FA(ABoutStart(i)*Frequency-60*Frequency:ABoutStart(i)*Frequency -50*Frequency));
        A50to40(i) = mean(dF_FA(ABoutStart(i)*Frequency-50*Frequency:ABoutStart(i)*Frequency -40*Frequency));
        A40to30(i) = mean(dF_FA(ABoutStart(i)*Frequency-40*Frequency:ABoutStart(i)*Frequency -30*Frequency));
        A30to20(i) = mean(dF_FA(ABoutStart(i)*Frequency-30*Frequency:ABoutStart(i)*Frequency -20*Frequency));
        A20to10(i) = mean(dF_FA(ABoutStart(i)*Frequency-20*Frequency:ABoutStart(i)*Frequency -10*Frequency));
        A10to0(i) = mean(dF_FA(ABoutStart(i)*Frequency-10*Frequency:ABoutStart(i)*Frequency));
    end
end
A60to50 = transpose(A60to50);
A50to40 = transpose(A50to40);
A40to30 = transpose(A40to30);
A30to20 = transpose(A30to20);
A20to10 = transpose(A20to10);
A10to0 = transpose(A10to0);

%Extracts the data 15 seconds before and 15 seconds after each bout (with
%2.4 seconds on each side of ABoutBefore and ABoutAfter data
ABoutBefore=[];
ABoutAfter=[];
LENGTHAbout=length(round(Frequency-15*Frequency:(Frequency+2.4*Frequency)));
for i = 1:length(ABoutStart)
    if ABoutStart(i) < 15
        ABoutBefore(:,i)=NaN(LENGTHAbout,1);
    else
    ABoutBefore(:,i) = dF_FA(round(ABoutStart(i)*Frequency-15*Frequency:(ABoutStart(i)*Frequency+2.4*Frequency)));
    end
end
for i = 1:length(ABoutStart)
    if ABoutStart(i) < 15
         ABoutAfter(:,i)=NaN(LENGTHAbout,1);
    else
        if round(ABoutStart(i)*Frequency+ABoutDuration(i)*Frequency+15*Frequency) > length(dF_FA) 
          temppart1=dF_FA(round(ABoutStart(i)*Frequency+(ABoutDuration(i)*Frequency-2.4*Frequency)):length(dF_FA));
          temppart2=NaN(LENGTHAbout-length(temppart1),1)';
          ABoutAfter(:,i)=[temppart1, temppart2];        
        else
        ABoutAfter(:,i) = dF_FA(round(ABoutStart(i)*Frequency+ABoutDuration(i)*Frequency-2.4*Frequency:(ABoutStart(i)*Frequency+ABoutDuration(i)*Frequency+15*Frequency)));
        end
    end
end
APeakBefore = [];
APeakAfter = [];
AMinBefore = [];
AMeanBefore = [];
AOnset = [];
AEnd = [];
AMinAfter = [];
AMeanAfter = [];
AMinDuring = [];%Added by CL 11/10/20
AMeanDuring = [];%Added by CL 11/10/20
APeakDuring = [];%Added by CL 11/10/20

%%%%%%%%%%%% NEW AUC AND RISE/FALL TIME MEASURES MAY 2025 %%%%%%%%%%%%
AAUC15Before=[];
AAUC15After=[];
ATIMEDIFFBefore=[];
ATIMEDIFFAfter=[];

for i = 1:length(ABoutStart)
    ABefore = ABoutBefore(:,i);
    AAfter = ABoutAfter(:,i);
    APeakBefore(i) = max(ABefore(14*Frequency:15*Frequency)); %peak that occurs within 1 s before bout start
    AMinBefore(i) = min(ABefore(14*Frequency:15*Frequency)); %min that occurs within 1 s before bout start
    AMeanBefore(i) = mean(ABefore(14*Frequency:15*Frequency)); %mean that occurs within 1 s before bout start
    AOnset(i) = ABefore(round(15*Frequency)); %value at bout onset
    AEnd(i) = AAfter(round(2.4*Frequency)); %value at bout offset
    BOUTA = dF_FA(round(ABoutStart(i)*Frequency:(((ABoutStart(i)+ABoutDuration(i))*Frequency))));
    AMinDuring(i) = min(BOUTA); %min during the A bout %Added by CL 11/10/20
    AMeanDuring(i) = mean(BOUTA); %mean during the A bout %Added by CL 11/10/20
    APeakDuring(i) = max(BOUTA); %max during the A bout %Added by CL 11/10/20
    APeakAfter(i) = max(AAfter(2.4*Frequency:3.4*Frequency)); %peak that occurs 1 s after bout offset
    AMinAfter(i) = min(AAfter(2.4*Frequency:3.4*Frequency)); %min that occurs 1 s after bout offset
    AMeanAfter(i) = mean(AAfter(2.4*Frequency:3.4*Frequency)); %mean that occurs 1 s after bout offset
    
%%%%%%%%%%%% NEW AUC AND RISE/FALL TIME MEASURES MAY 2025 %%%%%%%%%%%%

    AMinBeforeAUC(i) = min(ABefore); %min that occurs during the 15sec pre-bout period
    APeakBeforeAUC(i) = max(ABefore); %peak that occurs during the 15sec pre-bout period
    AMinAfterAUC(i) = min(AAfter); %min that occurs during the 15sec post-bout period
    APeakAfterAUC(i) = max(AAfter); %peak that occurs during the 15sec post-bout period

    AAUC15Before(i)=trapz(ABefore);
    AAUC15After(i)=trapz(AAfter);
    I1 = find(ABefore == AMinBeforeAUC(i));
    I1=I1(1,1);
    I2 = find(ABefore == APeakBeforeAUC(i));
    I2=I2(1,1);
    ATIMEDIFFBefore(i)=I2-I1;
    I3 = find(AAfter == APeakAfterAUC(i));
    I3=I3(1,1);
    I4 = find(AAfter == AMinAfterAUC(i));
    I4=I4(1,1);
    ATIMEDIFFAfter(i)=I4-I3;
end

APeakBefore = transpose(APeakBefore);
APeakAfter = transpose(APeakAfter);
AMinBefore = transpose(AMinBefore);
AMeanBefore = transpose(AMeanBefore);
AOnset = transpose(AOnset);
AEnd = transpose(AEnd);
AMinAfter = transpose(AMinAfter);
AMeanAfter = transpose(AMeanAfter);
AMinDuring = transpose(AMinDuring);
AMeanDuring = transpose(AMeanDuring); %Added by CL 11/10/20
APeakDuring = transpose(APeakDuring); %Added by CL 11/10/20

%%%%%%%%%%%% NEW AUC AND RISE/FALL TIME MEASURES MAY 2025 %%%%%%%%%%%%
AAUC15Before=transpose(AAUC15Before);
AAUC15After=transpose(AAUC15After);
ATIMEDIFFBefore=transpose(ATIMEDIFFBefore);
ATIMEDIFFAfter=transpose(ATIMEDIFFAfter);


%Extracts data for the graphs 30 s before and after each bout
LENGTHAbout=length(round(Frequency-30*Frequency:(Frequency+2.4*Frequency)));
AGraphBoutBefore=[];
AGraphBoutAfter=[];

for i = 1:length(ABoutStart)
    if ABoutStart(i) < 30
        AGraphBoutBefore(:,i)=NaN(LENGTHAbout,1);
    else
    AGraphBoutBefore(:,i) = dF_FA(round(ABoutStart(i)*Frequency-30*Frequency:(ABoutStart(i)*Frequency+2.4*Frequency)));
    end
end
for i = 1:length(ABoutStart)
    if ABoutStart(i) < 30
          AGraphBoutAfter(:,i)=NaN(LENGTHAbout,1);
    elseif round(ABoutStart(i)*Frequency+ABoutDuration(i)*Frequency+30*Frequency) > length(dF_FA)
          temppart1=dF_FA(round(ABoutStart(i)*Frequency+ABoutDuration(i)*Frequency-2.4*Frequency):length(dF_FA));
          temppart2=NaN(LENGTHAbout-length(temppart1),1)';
          AGraphBoutAfter(:,i)=[temppart1, temppart2];
    else 
    AGraphBoutAfter(:,i) = dF_FA(round(ABoutStart(i)*Frequency+ABoutDuration(i)*Frequency-2.4*Frequency:(ABoutStart(i)*Frequency+ABoutDuration(i)*Frequency+30*Frequency)));
    end
end

%this calculates the slope during the bouts using two methods
ASlopePolyfit=[];
for i = 1:length(ABoutStart)
    f=dF_FA;
    ASlopeTwoPoint(i)=(f(round(ABoutStart(i)*Frequency+ABoutDuration(i)*Frequency))-f(round(ABoutStart(i)*Frequency)))/ABoutDuration(i);
    AFit=polyfit(((linspace(1/Frequency, length(f(ABoutStart(i)*Frequency:ABoutStart(i)*Frequency+ ABoutDuration(i)*Frequency))/Frequency,length(f(ABoutStart(i)*Frequency:ABoutStart(i)*Frequency+ ABoutDuration(i)*Frequency))))),f(ABoutStart(i)*Frequency:ABoutStart(i)*Frequency+ ABoutDuration(i)*Frequency),1);
    ASlopePolyfit(i)=AFit(1);
end
    ASlopeTwoPoint=transpose(ASlopeTwoPoint);
    ASlopePolyfit=transpose(ASlopePolyfit);

%this calculates the LickFrequency
for i=1:length(ALicksPerBout)
    ALickFrequency(i) = ALicksPerBout(i)/ABoutDuration(i);
end

% This calculates the mean, median,MAD (median average deviation), and Std Deviation of the normalized %dF/F for the whole session. 
% CL added this 12/11/2023 to be able to z-score data to mouse overall signal - depending on which value looked best. 
% This should be the same for each bout so the single value is repeated for the length of the data.
ASigMean=[];
ASigMedian=[];
ASigMAD=[];
ASigStdev=[];
meana = mean(dF_FA);
meda = median(dF_FA);
mada = mad(dF_FA,1);
stda = std(dF_FA);
for i = 1:length(ABoutStart)
    ASigMean(i) = meana;
    ASigMedian(i) = meda;
    ASigMAD(i) = mada;
    ASigStdev(i) = stda;
end

ASigMean = transpose(ASigMean);
ASigMedian = transpose(ASigMedian);
ASigMAD = transpose(ASigMAD);
ASigStdev = transpose(ASigStdev);
clear meana meda mada stda 

%--------------------------------------WRITE A TABLE--------------------------------------------------------------

ABoutData = [ASigMean,ASigMedian,ASigMAD,ASigStdev,ABoutStart,ABoutDuration,ALicksPerBout,ALickFrequency,AMinBefore,AMeanBefore,APeakBefore,AOnset,AEnd,AMinDuring,AMeanDuring,APeakDuring,AMinAfter,AMeanAfter,APeakAfter, ASlopePolyfit, ASlopeTwoPoint, A60to50, A50to40, A40to30, A30to20, A20to10, A10to0, AAUC15Before, AAUC15After, ATIMEDIFFBefore, ATIMEDIFFAfter];
ABoutData = array2table(ABoutData);
ABoutData.Properties.VariableNames = {'ASigMean','ASigMedian','ASigMAD','ASigStdev','ABoutStarts','ABoutDuration','ALicksPerBout','ALickFrequency','AMinBefore', 'AMeanBefore', 'APeakBefore', 'AOnset', 'AEnd', 'AMinDuring', 'AMeanDuring','APeakDuring', 'AMinAfter', 'AMeanAfter', 'APeakAfter', 'ASlopePolyfit', 'ASlopeTwoPoint','ARAMP60to50sec', 'ARAMP50to40sec', 'ARAMP40to30sec', 'ARAMP30to20sec', 'ARAMP20to10sec', 'ARAMP10to0sec', 'AAUC15Before', 'AAUC15After', 'ATIMEDIFFBefore', 'ATIMEDIFFAfter'};

AGraphBoutBefore=array2table(AGraphBoutBefore); 
AGraphBoutAfter=array2table(AGraphBoutAfter);
end

%writetable(ABoutData,'E:\JR25\JR25 PJM Results\ChannelAdF_Fbouts.xlsx');
%writetable(AGraphBoutBefore, 'E:\JR25\JR25 PJM Results\ChannelAGraphBoutBefore.xlsx')
%writetable(AGraphBoutAfter, 'E:\JR25\JR25 PJM Results\ChannelAGraphBoutAfter.xlsx')




%----------------------------Channel B------------------------------------------------------

ytest = double(data.streams.TTLB.data(round(Start0):round(Stop0)-Frequency));
ymode = ytest - mode(ytest); %shifts TTLs to have a true '0' value
y = abs(ymode); %inverts TTLs, if necessary, so that they are always positive

idxl = y>=thresh;%binary vector indicating where ttl is greater than threshold
idxl(1) = 0; %first item in vector is zero
idx = find(idxl);%indices (times) where ttl is greater than threshold
yest = y(idx-1)<thresh;%indicate if observation before lick was a lick 
h = idx(yest); %indices (times) of individual licks
hnew=[1 h]; %add 1 to the beginning of vector

clear ytest ymode yest idxl idx %MH ADDED 7/22/2020

%Checks distance between each lick
%If distance is greater than InterBurstInterval it is counted as a new bout
bout = [];
for i = 2:length(hnew)
    if hnew(i) - hnew(i-1) < InterBurstInterval
        nboutsstart = 1;
    else
        bout(i) = [hnew(i)];    
    end
end
%Bo is list of bout starts
Bo = nonzeros(bout);
 
%lickss = list indices in h where bouts start 
%(h is vector of ttl indices of individual licks)
lickss = [];
for i=1:length(Bo)
    lickss(i)= [find(h==Bo(i))];
end

%distance from firsr lick to last lick in bout
BBoutDuration = [];
for i = 1:length(lickss)
  if i < length(lickss)
      BBoutDuration(i) = h(lickss(i+1)-1)-h(lickss(i));
  else
      BBoutDuration(i) = h(length(h))-h(lickss(i));
  end
end

%Outputs 'No Bout B' if the mouse did not lick during the recording
if sum(BBoutDuration)==0
   BBoutData=cell2table({'No Bouts B'});
   BGraphBoutBefore=cell2table({'No Bouts B'});
   BGraphBoutAfter=cell2table({'No Bouts B'});
   BBoutStart=[];
   BBoutDuration=[];
   %FullBoutData=[];
   ReducedBoutData=[];
else

%list indices (in h) of first lick in bout)
%(h is vector of ttl indices of individual licks)
BBoutStart = nonzeros(Bo);
licks=[];
for i=1:length(BBoutStart)
    licks(i)= [find(h==BBoutStart(i))];
end

%calculates licks per bout
BLicksPerBout = [];
for i = 1:length(licks)
    if i < length(licks)
        BLicksPerBout(i)=licks(i+1)-licks(i);
    else
        BLicksPerBout(i)= length(h)-licks(i);
    end
end


%CLEAN UP BOUTS
BBoutDuration = BBoutDuration'/Frequency;
BLicksPerBout=BLicksPerBout';
BBoutStart = BBoutStart/Frequency; 
BLickFrequency = BLicksPerBout./BBoutDuration;

%FullBoutData=[BBoutStart BBoutDuration BLicksPerBout BLickFrequency];
idx = any((BBoutDuration < MinBoutDuration),2);
BBoutDuration(idx,:)=[];
BLicksPerBout(idx,:)=[];
BBoutStart(idx,:)=[];
BLickFrequency(idx,:)=[];

idx = any((BLickFrequency < LicksPerSecond),2);
BBoutDuration(idx,:)=[];
BLicksPerBout(idx,:)=[];
BBoutStart(idx,:)=[];
BLickFrequency(idx,:)=[];
%ReducedBoutData=[BBoutStart BBoutDuration BLicksPerBout BLickFrequency];
end

if sum(BBoutDuration)==0
   BBoutData=cell2table({'No Bouts Met Criteria B'});
   BGraphBoutBefore=cell2table({'No Bouts Met Criteria B'});
   BGraphBoutAfter=cell2table({'No Bouts Met Criteria B'});
   BBoutStart=[];
   BBoutDuration=[];
   %FullBoutData=[];
   ReducedBoutData=[];
else

B60to50=[];
B50to40=[];
B40to30=[];
B30to20=[];
B20to10=[];
B10to0=[];
for i = 1:length(BBoutStart)
    if  BBoutStart(i) > 50 && BBoutStart(i) < 60
        B60to50(i) = NaN;
        B50to40(i) = mean(dF_FB(BBoutStart(i)*Frequency-50*Frequency:BBoutStart(i)*Frequency -40*Frequency));
        B40to30(i) = mean(dF_FB(BBoutStart(i)*Frequency-40*Frequency:BBoutStart(i)*Frequency -30*Frequency));
        B30to20(i) = mean(dF_FB(BBoutStart(i)*Frequency-30*Frequency:BBoutStart(i)*Frequency -20*Frequency));
        B20to10(i) = mean(dF_FB(BBoutStart(i)*Frequency-20*Frequency:BBoutStart(i)*Frequency -10*Frequency));
        B10to0(i) = mean(dF_FB(BBoutStart(i)*Frequency-10*Frequency:BBoutStart(i)*Frequency));
    elseif BBoutStart(i) > 40 && BBoutStart(i) < 50
        B60to50(i) = NaN;
        B50to40(i) = NaN;
        B40to30(i) = mean(dF_FB(BBoutStart(i)*Frequency-40*Frequency:BBoutStart(i)*Frequency -30*Frequency));
        B30to20(i) = mean(dF_FB(BBoutStart(i)*Frequency-30*Frequency:BBoutStart(i)*Frequency -20*Frequency));
        B20to10(i) = mean(dF_FB(BBoutStart(i)*Frequency-20*Frequency:BBoutStart(i)*Frequency -10*Frequency));
        B10to0(i) = mean(dF_FB(BBoutStart(i)*Frequency-10*Frequency:BBoutStart(i)*Frequency));
    elseif BBoutStart(i) > 30 && BBoutStart(i) < 40
        B60to50(i) = NaN;
        B50to40(i) = NaN;
        B40to30(i) = NaN;
        B30to20(i) = mean(dF_FB(BBoutStart(i)*Frequency-30*Frequency:BBoutStart(i)*Frequency -20*Frequency));
        B20to10(i) = mean(dF_FB(BBoutStart(i)*Frequency-20*Frequency:BBoutStart(i)*Frequency -10*Frequency));
        B10to0(i) = mean(dF_FB(BBoutStart(i)*Frequency-10*Frequency:BBoutStart(i)*Frequency));
    elseif BBoutStart(i) > 20 && BBoutStart(i) < 30
        B60to50(i) = NaN;
        B50to40(i) = NaN;
        B40to30(i) = NaN;
        B30to20(i) = NaN;
        B20to10(i) = mean(dF_FB(BBoutStart(i)*Frequency-20*Frequency:BBoutStart(i)*Frequency -10*Frequency));
        B10to0(i) = mean(dF_FB(BBoutStart(i)*Frequency-10*Frequency:BBoutStart(i)*Frequency));
    elseif BBoutStart(i) > 10 && BBoutStart(i) < 20
        B60to50(i) = NaN;
        B50to40(i) = NaN;
        B40to30(i) = NaN;
        B30to20(i) = NaN;
        B20to10(i) = NaN;
        B10to0(i) = mean(dF_FB(BBoutStart(i)*Frequency-10*Frequency:BBoutStart(i)*Frequency));
    elseif BBoutStart(i) < 10
        B60to50(i) = NaN;
        B50to40(i) = NaN;
        B40to30(i) = NaN;
        B30to20(i) = NaN;
        B20to10(i) = NaN;
        B10to0(i) = NaN;
     else
        B60to50(i) = mean(dF_FB(BBoutStart(i)*Frequency-60*Frequency:BBoutStart(i)*Frequency -50*Frequency));
        B50to40(i) = mean(dF_FB(BBoutStart(i)*Frequency-50*Frequency:BBoutStart(i)*Frequency -40*Frequency));
        B40to30(i) = mean(dF_FB(BBoutStart(i)*Frequency-40*Frequency:BBoutStart(i)*Frequency -30*Frequency));
        B30to20(i) = mean(dF_FB(BBoutStart(i)*Frequency-30*Frequency:BBoutStart(i)*Frequency -20*Frequency));
        B20to10(i) = mean(dF_FB(BBoutStart(i)*Frequency-20*Frequency:BBoutStart(i)*Frequency -10*Frequency));
        B10to0(i) = mean(dF_FB(BBoutStart(i)*Frequency-10*Frequency:BBoutStart(i)*Frequency));
    end
end
B60to50 = transpose(B60to50);
B50to40 = transpose(B50to40);
B40to30 = transpose(B40to30);
B30to20 = transpose(B30to20);
B20to10 = transpose(B20to10);
B10to0 = transpose(B10to0);

%Extracts the data 15 seconds before and 15 seconds after each bout (with
%2.4 seconds on each side of BBoutBefore and BBoutAfter data
BBoutBefore=[];
BBoutAfter=[];
LENGTHBbout=length(round(Frequency-15*Frequency:(Frequency+2.4*Frequency)));
for i = 1:length(BBoutStart)
    if BBoutStart(i) < 15
        BBoutBefore(:,i)=NaN(LENGTHBbout,1);
    else
    BBoutBefore(:,i) = dF_FB(round(BBoutStart(i)*Frequency-15*Frequency:(BBoutStart(i)*Frequency+2.4*Frequency)));
    end
end
for i = 1:length(BBoutStart)
    if round(BBoutStart(i)*Frequency+BBoutDuration(i)*Frequency+15*Frequency) > length(dF_FB) 
       temppart1=dF_FB(round(BBoutStart(i)*Frequency+BBoutDuration(i)*Frequency-2.4*Frequency):length(dF_FB));
       temppart2=NaN(LENGTHBbout-length(temppart1),1)';
       BBoutAfter(:,i)=[temppart1, temppart2];       
    else
    BBoutAfter(:,i) = dF_FB(round(BBoutStart(i)*Frequency+BBoutDuration(i)*Frequency-2.4*Frequency:(BBoutStart(i)*Frequency+BBoutDuration(i)*Frequency+15*Frequency)));
    end
end
BPeakBefore = [];
BPeakAfter = [];
BMinBefore = [];
BMeanBefore = [];
BOnset = [];
BEnd = [];
BMinAfter = [];
BMeanAfter = [];
BMinDuring = [];
BMeanDuring = [];
BPeakDuring = [];

%%%%%%%%%%%% NEW AUC AND RISE/FALL TIME MEASURES MAY 2025 %%%%%%%%%%%%
BAUC15Before=[];
BAUC15After=[];
BTIMEDIFFBefore=[];
BTIMEDIFFAfter=[];

for i = 1:length(BBoutStart)
    BBefore = BBoutBefore(:,i);
    BAfter = BBoutAfter(:,i);
    BPeakBefore(i) = max(BBefore(14*Frequency:15*Frequency)); %peak that occurs within 1 s before bout start
    BMinBefore(i) = min(BBefore(14*Frequency:15*Frequency)); %min that occurs within 1 s before bout start
    BMeanBefore(i) = mean(BBefore(14*Frequency:15*Frequency)); %mean that occurs within 1 s before bout start
    BOnset(i) = BBefore(round(15*Frequency)); %value at bout onset
    BEnd(i) = BAfter(round(2.4*Frequency)); %value at bout offset
    BOUTB=dF_FB(round(BBoutStart(i)*Frequency:(((BBoutStart(i)+BBoutDuration(i))*Frequency))));
    BMinDuring(i) = min(BOUTB); %min during the a bout
    BMeanDuring(i) = mean(BOUTB); %mean during the A bout
    BPeakDuring(i) = max(BOUTB); %max during the A bout
    BPeakAfter(i) = max(BAfter(2.4*Frequency:3.4*Frequency)); %peak that occurs 1 s after bout offset
    BMinAfter(i) = min(BAfter(2.4*Frequency:3.4*Frequency)); %min that occurs 1 s after bout offset
    BMeanAfter(i) = mean(BAfter(2.4*Frequency:3.4*Frequency)); %mean that occurs 1 s after bout offset
    
%%%%%%%%%%%% NEW AUC AND RISE/FALL TIME MEASURES MAY 2025 %%%%%%%%%%%%

    BMinBeforeAUC(i) = min(BBefore); %min that occurs during the 15sec pre-bout period
    BPeakBeforeAUC(i) = max(BBefore); %peak that occurs during the 15sec pre-bout period
    BMinAfterAUC(i) = min(BAfter); %min that occurs during the 15sec post-bout period
    BPeakAfterAUC(i) = max(BAfter); %peak that occurs during the 15sec post-bout period

    BAUC15Before(i)=trapz(BBefore);
    BAUC15After(i)=trapz(BAfter);
    I1b = find(BBefore == BMinBeforeAUC(i));
    I1b=I1b(1,1);
    I2b = find(BBefore == BPeakBeforeAUC(i));
    I2b=I2b(1,1);
    BTIMEDIFFBefore(i)=I2b-I1b;
    I3b = find(BAfter == BPeakAfterAUC(i));
    I3b=I3b(1,1);
    I4b = find(BAfter == BMinAfterAUC(i));
    I4b=I4b(1,1);
    BTIMEDIFFAfter(i)=I4b-I3b;
end

BPeakBefore = transpose(BPeakBefore);
BPeakAfter = transpose(BPeakAfter);
BMinBefore = transpose(BMinBefore);
BMeanBefore = transpose(BMeanBefore);
BOnset = transpose(BOnset);
BEnd = transpose(BEnd);
BMinAfter = transpose(BMinAfter);
BMeanAfter = transpose(BMeanAfter);
BMinDuring = transpose(BMinDuring);
BMeanDuring = transpose(BMeanDuring);
BPeakDuring = transpose(BPeakDuring);

%%%%%%%%%%%% NEW AUC AND RISE/FALL TIME MEASURES MAY 2025 %%%%%%%%%%%%
BAUC15Before=transpose(BAUC15Before);
BAUC15After=transpose(BAUC15After);
BTIMEDIFFBefore=transpose(BTIMEDIFFBefore);
BTIMEDIFFAfter=transpose(BTIMEDIFFAfter);


%Extracts data for the graphs 30 s before and after each bout
LENGTHBbout=length(round(Frequency-30*Frequency:(Frequency+2.4*Frequency)));
BGraphBoutBefore=[];
BGraphBoutAfter=[];

for i = 1:length(BBoutStart)
    if BBoutStart(i) < 30
        BGraphBoutBefore(:,i)=NaN(LENGTHBbout,1);
    else
    BGraphBoutBefore(:,i) = dF_FB(round(BBoutStart(i)*Frequency-30*Frequency:(BBoutStart(i)*Frequency+2.4*Frequency)));
    end
end
for i = 1:length(BBoutStart)
    if BBoutStart(i) < 30
        BGraphBoutAfter(:,i)=NaN(LENGTHBbout,1);
    elseif round(BBoutStart(i)*Frequency+BBoutDuration(i)*Frequency+30*Frequency) > length(dF_FB) 
          temppart1=dF_FB(round(BBoutStart(i)*Frequency+BBoutDuration(i)*Frequency-2.4*Frequency):length(dF_FB));
          temppart2=NaN(LENGTHBbout-length(temppart1),1)';
          BGraphBoutAfter(:,i)=[temppart1, temppart2];
    else
    BGraphBoutAfter(:,i) = dF_FB(round(BBoutStart(i)*Frequency+BBoutDuration(i)*Frequency-2.4*Frequency:(BBoutStart(i)*Frequency+BBoutDuration(i)*Frequency+30*Frequency)));
    end
end

%this calculates the slope during the bouts using two methods
BSlopePolyfit=[];
for i = 1:length(BBoutStart)
    f=dF_FB;
    BSlopeTwoPoint(i)=(f(round(BBoutStart(i)*Frequency+BBoutDuration(i)*Frequency))-f(round(BBoutStart(i)*Frequency)))/BBoutDuration(i);
    BFit=polyfit(((linspace(1/Frequency, length(f(BBoutStart(i)*Frequency:BBoutStart(i)*Frequency+ BBoutDuration(i)*Frequency))/Frequency,length(f(BBoutStart(i)*Frequency:BBoutStart(i)*Frequency+ BBoutDuration(i)*Frequency))))),f(BBoutStart(i)*Frequency:BBoutStart(i)*Frequency+ BBoutDuration(i)*Frequency),1);
    BSlopePolyfit(i)=BFit(1);
end
    BSlopeTwoPoint=transpose(BSlopeTwoPoint);
    BSlopePolyfit=transpose(BSlopePolyfit);

%this calculates the LickFrequency
for i=1:length(BLicksPerBout);
    BLickFrequency(i) = BLicksPerBout(i)/BBoutDuration(i);
end

% This calculates the mean, median,MAD (median average deviation), and Std Deviation of the normalized %dF/F for the whole session. 
% CL added this 12/11/2023 to be able to z-score data to mouse overall signal - depending on which value looked best. 
% This should be the same for each bout so the single value is repeated for the length of the data.
BSigMean=[];
BSigMedian=[];
BSigMAD=[];
BSigStdev=[];
meanb = mean(dF_FB);
medb = median(dF_FB);
madb = mad(dF_FB,1);
stdb = std(dF_FB);
for i = 1:length(BBoutStart)
    BSigMean(i) = meanb;
    BSigMedian(i) = medb;
    BSigMAD(i) = madb;
    BSigStdev(i) = stdb;
end

BSigMean = transpose(BSigMean);
BSigMedian = transpose(BSigMedian);
BSigMAD = transpose(BSigMAD);
BSigStdev = transpose(BSigStdev);
clear meanb medb madb stdb 

%--------------------------------------WRITE B TABLE--------------------------------------------------------------

BBoutData = [BSigMean,BSigMedian,BSigMAD,BSigStdev,BBoutStart,BBoutDuration,BLicksPerBout,BLickFrequency,BMinBefore,BMeanBefore,BPeakBefore,BOnset,BEnd,BMinDuring,BMeanDuring,BPeakDuring,BMinAfter,BMeanAfter,BPeakAfter, BSlopePolyfit, BSlopeTwoPoint, B60to50, B50to40, B40to30, B30to20, B20to10, B10to0, BAUC15Before, BAUC15After, BTIMEDIFFBefore, BTIMEDIFFAfter];
BBoutData = array2table(BBoutData);
BBoutData.Properties.VariableNames = {'BSigMean','BSigMedian','BSigMAD','BSigStdev','BBoutStarts','BBoutDuration','BLicksPerBout','BLickFrequency','BMinBefore', 'BMeanBefore', 'BPeakBefore', 'BOnset', 'BEnd', 'BMinDuring', 'BMeanDuring','BPeakDuring', 'BMinAfter', 'BMeanAfter', 'BPeakAfter', 'BSlopePolyfit', 'BSlopeTwoPoint','BRAMP60to50sec', 'BRAMP50to40sec', 'BRAMP40to30sec', 'BRAMP30to20sec', 'BRAMP20to10sec', 'BRAMP10to0sec' 'BAUC15Before', 'BAUC15After', 'BTIMEDIFFBefore', 'BTIMEDIFFAfter'};

BGraphBoutBefore=array2table(BGraphBoutBefore); 
BGraphBoutAfter=array2table(BGraphBoutAfter);
end

%writetable(BBoutData,'E:\JR25\JR25 PJM Results\ChannelBdF_Fbouts.xlsx');
%writetable(BGraphBoutBefore, 'E:\JR25\JR25 PJM Results\ChannelBGraphBoutBefore.xlsx')
%writetable(BGraphBoutAfter, 'E:\JR25\JR25 PJM Results\ChannelBGraphBoutAfter.xlsx')

end