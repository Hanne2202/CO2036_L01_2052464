// =====================================================================
//  Digital Signal Processing - Lab 2, ADDITIONAL EXERCISES (Scilab)
//  Student: Tran Gia Han
//  Student ID: 2052464
// =====================================================================
clear; clc;

// ------------------------- HAM HO TRO --------------------------------
// Dua tan so chuan hoa f (cycles/sample) ve khoang co ban [-1/2, 1/2]
function f0 = principal(f)
    f0 = f - round(f);
endfunction

// Tim chu ky co ban cua tin hieu roi rac sig(n) bang cach thu N = 1..Nmax:
// tra ve N nho nhat sao cho sig(n + N) = sig(n) voi moi n thu; tra ve 0 neu khong co
function N = findperiod(sig, Nmax)
    n = 0:299;
    N = 0;
    for k = 1:Nmax
        if max(abs(sig(n + k) - sig(n))) < 1e-8 then
            N = k;
            return;
        end
    end
endfunction

function report(name, N, Nmax)
    if N > 0 then
        mprintf("  %s: tuan hoan, chu ky co ban N = %d\n", name, N);
    else
        mprintf("  %s: KHONG tuan hoan (khong co N <= %d thoa x(n+N) = x(n))\n", name, Nmax);
    end
endfunction

// Ve tin hieu roi rac dang que
function stemplot(n, x, ttl, ylbl)
    plot2d3(n, x, style=2);
    plot(n, x, "b.");
    title(ttl); xlabel("n"); ylabel(ylbl);
    xgrid(color("grey"));
endfunction

// =====================================================================
//  Problem 1.3 - Xet tinh tuan hoan
// =====================================================================
mprintf("\n===== Problem 1.3 =====\n");
deff("x = sig_b(n)", "x = 3*cos(5*n + %pi/6)");
deff("x = sig_c(n)", "x = 2*exp(%i*(n/6 - %pi))");
deff("x = sig_d(n)", "x = cos(n/8) .* cos(%pi*n/8)");
deff("x = sig_e(n)", "x = cos(%pi*n/2) - sin(%pi*n/8) + 3*cos(%pi*n/4 + %pi/3)");

Nmax = 2000;
Tp_a = 2*%pi/5;
mprintf("  (a) xa(t) = 3cos(5t + pi/6): tuan hoan, Tp = 2*pi/5 = %.4f s\n", Tp_a);
report("(b) x(n) = 3cos(5n + pi/6)",              findperiod(sig_b, Nmax), Nmax);
report("(c) x(n) = 2exp[j(n/6 - pi)]",            findperiod(sig_c, Nmax), Nmax);
report("(d) x(n) = cos(n/8)cos(pi*n/8)",          findperiod(sig_d, Nmax), Nmax);
report("(e) x(n) = cos(pi*n/2) - sin(pi*n/8) + 3cos(pi*n/4 + pi/3)", findperiod(sig_e, Nmax), Nmax);

scf(13); clf(); fig = gcf(); fig.figure_name = "Problem 1.3"; fig.figure_size = [1000 850];
subplot(3,2,1);
t = 0 : Tp_a/200 : 3*Tp_a;
plot(t, 3*cos(5*t + %pi/6), "b-");
title("(a) xa(t) = 3cos(5t + pi/6): periodic, Tp = 2pi/5 s"); xlabel("t (s)"); ylabel("xa(t)"); xgrid(color("grey"));
subplot(3,2,2);
n = 0:40;  stemplot(n, sig_b(n), "(b) x(n) = 3cos(5n + pi/6): non-periodic", "x(n)");
subplot(3,2,3);
n = 0:80;  stemplot(n, real(sig_c(n)), "(c) Re{2exp[j(n/6 - pi)]}: non-periodic", "Re x(n)");
subplot(3,2,4);
n = 0:80;  stemplot(n, imag(sig_c(n)), "(c) Im{2exp[j(n/6 - pi)]}: non-periodic", "Im x(n)");
subplot(3,2,5);
n = 0:100; stemplot(n, sig_d(n), "(d) x(n) = cos(n/8)cos(pi n/8): non-periodic", "x(n)");
subplot(3,2,6);
n = 0:47;  stemplot(n, sig_e(n), "(e) periodic, N = 16 (3 periods shown)", "x(n)");

// =====================================================================
//  Problem 1.6 - Lay mau tin hieu sin: x(n) tuan hoan <=> T/Tp = k/N huu ti
//  Minh hoa: F0 = 50 Hz (Tp = 20 ms)
//    Fs = 120 Hz          -> T/Tp = F0/Fs = 5/12       -> N = 12, k = 5
//    Fs = 100*sqrt(2) Hz  -> T/Tp = 1/(2*sqrt(2)) vo ti -> khong tuan hoan
// =====================================================================
mprintf("\n===== Problem 1.6 =====\n");
F0 = 50;  Tp = 1/F0;

Fs = 120; T = 1/Fs;
g  = double(gcd(int32([F0 Fs])));
k  = F0/g;  N = Fs/g;
mprintf("  F0 = %g Hz, Fs = %g Hz:  T/Tp = F0/Fs = %d/%d  ->  N = %d mau, k = %d\n", F0, Fs, k, N, N, k);
mprintf("  Chu ky cua x(n) tinh bang giay: N*T = %g ms = k*Tp = %d x %g ms\n", 1000*N*T, k, 1000*Tp);
deff("x = sig_p(n)", "x = cos(2*%pi*(50/120)*n)");
deff("x = sig_q(n)", "x = cos(2*%pi*(50/(100*sqrt(2)))*n)");
report("Kiem tra bang so, Fs = 120 Hz",         findperiod(sig_p, Nmax), Nmax);
report("Kiem tra bang so, Fs = 100*sqrt(2) Hz", findperiod(sig_q, Nmax), Nmax);

scf(16); clf(); fig = gcf(); fig.figure_name = "Problem 1.6"; fig.figure_size = [1000 700];
subplot(2,1,1);
n = 0:2*N;  t = 0 : Tp/100 : 2*N*T;
plot(1000*t, cos(2*%pi*F0*t), "b-");
plot2d3(1000*n*T, sig_p(n), style=5);  plot(1000*n*T, sig_p(n), "r.");
// danh dau cac moc N*T = k*Tp (cho bo mau lap lai)
plot([1000*N*T 1000*N*T], [-1.2 1.2], "k--");
title("Fs = 120 Hz: T/Tp = 5/12 -> x(n) periodic, N = 12 samples = 100 ms = 5 Tp");
xlabel("t (ms)"); ylabel("xa(t) and samples x(n)"); xgrid(color("grey"));
subplot(2,1,2);
Fs2 = 100*sqrt(2);  n = 0:28;  t = 0 : Tp/100 : 28/Fs2;
plot(1000*t, cos(2*%pi*F0*t), "b-");
plot2d3(1000*n/Fs2, sig_q(n), style=5);  plot(1000*n/Fs2, sig_q(n), "r.");
title("Fs = 100 sqrt(2) Hz: T/Tp irrational -> samples never repeat, x(n) non-periodic");
xlabel("t (ms)"); ylabel("xa(t) and samples x(n)"); xgrid(color("grey"));

// =====================================================================
//  Problem 1.7 - Tin hieu co tan so den 10 kHz, lay mau Fs = 8 kHz
// =====================================================================
mprintf("\n===== Problem 1.7 =====\n");
Fmax = 10e3;  Fs = 8e3;
mprintf("  (a) Fs > 2*Fmax = %g kHz;  voi Fs = %g kHz thi tan so gap Fs/2 = %g kHz\n", 2*Fmax/1e3, Fs/1e3, Fs/2e3);
n = 0:16;  t = 0 : 1/(Fs*50) : 16/Fs;
Fin = [5e3 9e3];  lbl = ["(b)" "(c)"];
scf(17); clf(); fig = gcf(); fig.figure_name = "Problem 1.7"; fig.figure_size = [1000 700];
for i = 1:2
    F   = Fin(i);
    f   = F/Fs;                  // tan so chuan hoa (ngoai khoang co ban)
    f0  = principal(f);          // dua ve [-1/2, 1/2]
    Fal = abs(f0)*Fs;            // tan so alias quan sat duoc
    xs   = cos(2*%pi*f*n);       // mau cua tin hieu goc
    xal  = cos(2*%pi*f0*n);      // mau cua tin hieu alias
    mprintf("  %s F = %g kHz: f = F/Fs = %g -> f0 = %g -> alias %g kHz;  max|x - x_alias| = %.1e\n", ..
            lbl(i), F/1e3, f, f0, Fal/1e3, max(abs(xs - xal)));
    subplot(2,1,i);
    plot(1000*t, cos(2*%pi*F*t),   "b-");
    plot(1000*t, cos(2*%pi*Fal*t), "r-");
    plot(1000*n/Fs, xs, "ko");
    ax = gca(); ax.data_bounds = [0 -2; 2 1.2];       // chua cho cho chu thich
    legend([msprintf("cos(2 pi %g kHz t)", F/1e3); msprintf("alias: cos(2 pi %g kHz t)", Fal/1e3); "samples, Fs = 8 kHz"], "in_lower_right");
    title(msprintf("%s F = %g kHz sampled at Fs = 8 kHz -> same samples as %g kHz", lbl(i), F/1e3, Fal/1e3));
    xlabel("t (ms)"); ylabel("amplitude"); xgrid(color("grey"));
end

// =====================================================================
//  Problem 1.9 - xa(t) = sin(480 pi t) + 3 sin(720 pi t), Fs = 600 Hz
// =====================================================================
mprintf("\n===== Problem 1.9 =====\n");
F1 = 240;  F2 = 360;  Fs = 600;
f1 = principal(F1/Fs);  f2 = principal(F2/Fs);
mprintf("  (a) Nyquist rate FN = 2*Fmax = %g Hz\n", 2*max(F1, F2));
mprintf("  (b) Folding frequency Fs/2 = %g Hz\n", Fs/2);
mprintf("  (c) f1 = %g/%g = %g -> %g ;  f2 = %g/%g = %g -> %g (alias)\n", F1, Fs, F1/Fs, f1, F2, Fs, F2/Fs, f2);
mprintf("      omega = 2*pi*%g = %.4f rad/sample (= 4*pi/5)\n", abs(f1), 2*%pi*abs(f1));
n  = 0:20;
x  = sin(480*%pi*n/Fs) + 3*sin(720*%pi*n/Fs);    // lay mau truc tiep
xr = -2*sin(4*%pi*n/5);                           // ket qua rut gon
mprintf("      max|x(n) - (-2 sin(4 pi n/5))| = %.1e\n", max(abs(x - xr)));
mprintf("  (d) ya(t) = -2 sin(2*pi*%g*t) = -2 sin(480 pi t)\n", abs(f1)*Fs);

t  = 0 : 1/(Fs*50) : 20/Fs;
xa = sin(480*%pi*t) + 3*sin(720*%pi*t);
ya = -2*sin(480*%pi*t);
scf(19); clf(); fig = gcf(); fig.figure_name = "Problem 1.9"; fig.figure_size = [1000 850];
subplot(3,1,1);
plot(1000*t, xa, "b-");  plot(1000*n/Fs, x, "ko");
title("xa(t) = sin(480 pi t) + 3 sin(720 pi t) and its samples at Fs = 600 Hz");
xlabel("t (ms)"); ylabel("xa(t)"); xgrid(color("grey"));
subplot(3,1,2);
plot2d3(n, x, style=2);  plot(n, x, "b.");  plot(n, xr, "ro");
title("x(n) (blue stems) = -2 sin(4 pi n / 5) (red circles)");
xlabel("n"); ylabel("x(n)"); xgrid(color("grey"));
subplot(3,1,3);
plot(1000*t, xa, "b-");  plot(1000*t, ya, "r-");  plot(1000*n/Fs, x, "ko");
ax = gca(); ax.data_bounds = [0 -8; 35 4.5];          // chua cho cho chu thich
legend(["xa(t)"; "ya(t) = -2 sin(480 pi t)"; "samples"], "in_lower_right");
title("Ideal D/A output ya(t): passes through the same samples but differs from xa(t)");
xlabel("t (ms)"); ylabel("amplitude"); xgrid(color("grey"));

// =====================================================================
//  Problem 1.10 - xa(t) = 3cos(600 pi t) + 2cos(1800 pi t)
//  Duong truyen 10 000 bit/s, moi mau luong tu thanh 1024 muc
// =====================================================================
mprintf("\n===== Problem 1.10 =====\n");
R  = 10000;  L = 1024;
b  = log2(L);                 // so bit moi mau
Fs = R/b;                     // tan so lay mau
F1 = 300;  F2 = 900;
f1 = principal(F1/Fs);  f2 = principal(F2/Fs);
mprintf("  (a) b = log2(%d) = %d bit/mau -> Fs = %d/%d = %g Hz;  folding = Fs/2 = %g Hz\n", L, b, R, b, Fs, Fs/2);
mprintf("  (b) Nyquist rate FN = 2*Fmax = %g Hz\n", 2*max(F1, F2));
mprintf("  (c) f1 = %g/%g = %g ;  f2 = %g/%g = %g -> %g (alias cua 900 Hz, ung voi 100 Hz)\n", F1, Fs, f1, F2, Fs, F2/Fs, f2);
n  = 0:29;
x  = 3*cos(600*%pi*n/Fs) + 2*cos(1800*%pi*n/Fs);        // lay mau truc tiep
xr = 3*cos(2*%pi*0.3*n)  + 2*cos(2*%pi*0.1*n);          // ket qua rut gon
mprintf("      max|x(n) - [3cos(2 pi 0.3 n) + 2cos(2 pi 0.1 n)]| = %.1e\n", max(abs(x - xr)));
xmax = max(x);  xmin = min(x);
delta = (xmax - xmin)/(L - 1);
mprintf("  (d) xmax = %g, xmin = %g -> delta = (xmax - xmin)/(L - 1) = %g/%d = %.6f\n", xmax, xmin, xmax - xmin, L - 1, delta);

t  = 0 : 1/(Fs*50) : 29/Fs;
xa = 3*cos(600*%pi*t) + 2*cos(1800*%pi*t);
scf(110); clf(); fig = gcf(); fig.figure_name = "Problem 1.10"; fig.figure_size = [1000 700];
subplot(2,1,1);
plot(1000*t, xa, "b-");  plot(1000*n/Fs, x, "ko");
title("xa(t) = 3cos(600 pi t) + 2cos(1800 pi t) and its samples at Fs = 1000 Hz");
xlabel("t (ms)"); ylabel("xa(t)"); xgrid(color("grey"));
subplot(2,1,2);
plot2d3(n, x, style=2);  plot(n, x, "b.");  plot(n, xr, "ro");
title("x(n) (blue stems) = 3cos(2 pi 0.3 n) + 2cos(2 pi 0.1 n) (red circles), period N = 10");
xlabel("n"); ylabel("x(n)"); xgrid(color("grey"));
