function [pw_memo,fvec] = test(filename)


switch (filename(4:5))              %各種類の最低音と最高音
    case{'SS'}
        lowest = 56; highest = 88;
    case{'AS'}
        lowest = 49; highest = 81;
    case{'TS'}
        lowest = 44; highest = 74;
    case{'BA'}
        lowest = 36; highest = 67;
end

NFFT = 2^15;
window_length = 2^15;
pw_memo = zeros((highest-lowest+1),floor(NFFT/2));
parents_filename = sprintf('/Users/kurosaki/Documents/Matlab/data/%s_spectram',filename);
mkdir(parents_filename);
 
for i = lowest:highest
    %楽器音データの絶対パスを取得
    pathname = sprintf('/Users/kurosaki/Documents/Matlab/RWC-IDB_DATA/%s/%s_D/%s_%03d.WAV', filename(1:3), filename,filename,i);
    [y,Fs]=audioread(pathname);                     %楽器音データを読み込む

    window_center = fix(length(y)/2);
    window = y(window_center-fix(window_length/2) : window_center+fix(window_length/2));

    han_window = 0.5 - 0.5 * cos(2 * pi * [0 : 1/length(window) : 1]);
    window = han_window(1:length(window))' .* window;

    cc = fft(transpose(window),NFFT);
    pw = abs(cc);
    pw_memo(i-lowest+1,:) = pw(1:floor(NFFT/2));
end;


end