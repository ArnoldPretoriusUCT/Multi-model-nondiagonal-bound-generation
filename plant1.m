%% PREAMBLE
format long
s = tf('s');

i = 1;
% k_diag = [2 3 6];
% k_off = [.5 .75 1.5];
pRes = 2;
k_diag = linspace(2,6,pRes);
k_off = linspace(.5,1.5,pRes);

N = pRes^4;
P = s*zeros(2,2,N);

for k11=k_diag
    for k12 = k_off
        for k21 = k_off
            for k22 = k_diag
                P(:,:,i) = 1/s*[k11 k12;
                                k21 k22];
                i = i + 1;
            end
        end
    end
end
N = i-1;
% Q = inv(P);
Po = 1/s*[3 1.5;
          1.5 3];
g11 = 4*(s/21+1)/(s/9+1)/(s^2/45^2+.92/45*s+1);
g22 = g11;
Go = [g11 0; 0 g11];

f11 = (s^2/13^2+.93/13*s+1)/(s/5+1)/(s/200+1)^2;
f12 = -.08*s*(s/3+1)/(s^2/2.8^2+1.32/2.8*s+1)/(s/30+1);
Fo = [f11 f12;f12 f11];

W = [1 2 3 5 8 10];
Gw = freqresp(Go,W);
Gw0 = Gw;
M = [1/(1+s/3) 0;
     0         1/(1+s/3)];
Mw = freqresp(M,W); 
Xo = Go*(Fo-M);
Xw0 = freqresp(Xo,W);
% Qw = freqresp(Q,W);
r = [1/s 1/s].';
Qo = inv(Po); 
ym = M*r;
% Bs = (eye(2)+P*Go)\(eye(2)-P*inv(Po))*M;
Bs = M-(eye(2)+P*Go)\(P*Go*Fo);
Bw = abs( squeeze(freqresp(Bs,W)) );
BwMax = zeros(2,2,length(W));
Us = (eye(2)+Go*P)\(Go*Fo);
Uw = abs( squeeze(freqresp(Us,W)) );
UwMax = BwMax;
BwInd = zeros(2,2,length(W));

Pw = freqresp(P,W);
Qw = Pw;
for w=1:length(W)
    for p=1:N
        Qw(:,:,w,p) = inv(Pw(:,:,w,p));
    end
end
    
Pow = freqresp(Po,W);
Qoww = freqresp(inv(Po),W);
for w=1:length(W)
    for i=1:N
        for row=1:2
            for col=1:2
                if( Bw(row,col,w,i) > BwMax(row,col,w) )
                    BwMax(row,col,w) = Bw(row,col,w,i);
                    BwInd(row,col,w) = i;
                end
                if( Uw(row,col,w,i) > UwMax(row,col,w) )
                    UwMax(row,col,w) = Uw(row,col,w,i);                    
                end
            end
        end
    end
end
PHI = (0:-5:-360)*pi/180;
dRg = 0.1;


Bw = zeros(2,2,length(W));
for w_index=1:length(W)
    Bw(1,1,w_index) = 1*.2*W(w_index)*sqrt(1+W(w_index)^2/9);
    Bw(1,2,w_index) = 1*.2*W(w_index)*sqrt(1+W(w_index)^2/9);
    Bw(2,1,w_index) = 1*.2*W(w_index)*sqrt(1+W(w_index)^2/9);
    Bw(2,2,w_index) = 1*.2*W(w_index)*sqrt(1+W(w_index)^2/9);
end