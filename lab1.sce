// =====================================================================
//  Digital Signal Processing - Lab 1 
//  Student: Tran Gia Han
//  Student ID: 2052464
// =====================================================================
clear; clc;

// ---------------------------------------------------------------------
//  Ex 1.1 - Phep toan tren vector
// ---------------------------------------------------------------------
mprintf("\n===== Ex 1.1 =====\n");

// (a) (x1+1, x2+1, x3+1, x4+1) voi x = 1:4
x = 1:4;
a = x + 1;
mprintf("(a) x + 1 =");        disp(a);
// (b) (x1*y1, x2*y2, x3*y3, x4*y4) -> nhan TUNG PHAN TU, dung .* (khong phai *)
y = 5:8;
b = x .* y;
mprintf("(b) x .* y =");       disp(b);
// (c) (sin(x1), ..., sin(x10)), x gom 10 gia tri cach deu tren [0, pi]
x = linspace(0, %pi, 10);
c = sin(x);
mprintf("(c) x = linspace(0, %%pi, 10) =");  disp(x);
mprintf("    sin(x) =");                    disp(c);

// ---------------------------------------------------------------------
//  Ex 1.2 - Cac buoc ADC cho xa(t) = 3 sin(100*pi*t)
// ---------------------------------------------------------------------
mprintf("\n===== Ex 1.2 =====\n");

A     = 3;          // bien do
F     = 50;         // 100*pi = 2*pi*F  ->  F = 50 Hz
Tp    = 1/F;        // chu ky tin hieu tuong tu = 20 ms
Fs    = 300;        // tan so lay mau (samples/s)
delta = 0.1;        // buoc luong tu

// (1) Tin hieu tuong tu xa(t) trong 5 chu ky
t  = 0 : Tp/200 : 5*Tp;
xa = A*sin(2*%pi*F*t);

// (2) Lay mau: x(n) = xa(n/Fs) = 3 sin(2*pi*(F/Fs)*n) = 3 sin(pi*n/3)
//     f = F/Fs = 1/6 (huu ti)  ->  x(n) tuan hoan, chu ky co ban N = 6 mau
g  = double(gcd(int32([F Fs])));
k  = F/g;           // tu so cua f = k/N (toi gian)
N  = Fs/g;          // chu ky co ban cua x(n)
n  = 0 : 5*N;       // 5 chu ky (31 diem, tinh ca mau cuoi)
x  = A*sin(2*%pi*(F/Fs)*n);
mprintf("f = F/Fs = %d/%d (cycles/sample),  omega = 2*pi*f = %.4f rad/sample\n", k, N, 2*%pi*k/N);
mprintf("x(n) tuan hoan, chu ky co ban N = %d mau  (= %g ms)\n", N, 1000*N/Fs);
mprintf("Mot chu ky cua x(n):\n");  disp(clean(x(1:N)));

// (3) Luong tu hoa kieu cat bo (truncation): xq = delta * floor(x/delta)
//     clean() dua cac gia tri ~1e-16 (sai so dau cham dong cua sin) ve dung 0,
//     neu khong floor(-7e-15) = -1 se cho xq = -0.1 thay vi 0.
xq = delta * floor(clean(x) / delta);
mprintf("Mot chu ky cua xq(n) (delta = %g, truncation):\n", delta);  disp(xq(1:N));
mprintf("Sai so luong tu eq = xq - x trong mot chu ky:\n");          disp(clean(xq(1:N) - x(1:N)));

// (4) Ve ca 3 tin hieu trong MOT cua so
scf(1); clf();
fig = gcf(); fig.figure_name = "Lab 1 - Ex 1.2: xa(t), x(n), xq(n)"; fig.figure_size = [900 800];

subplot(3,1,1);
plot(1000*t, xa, "b-");
title("Analog signal  xa(t) = 3 sin(100 pi t)  (5 periods)");
xlabel("t (ms)"); ylabel("xa(t)");
ax = gca(); ax.data_bounds = [0 -3.5; 100 3.5]; xgrid(color("grey"));

subplot(3,1,2);
plot2d3(n, x, style=2);  plot(n, x, "b.");
title("Discrete-time signal  x(n) = 3 sin(pi n / 3),  Fs = 300 Hz,  N = 6  (5 periods)");
xlabel("n"); ylabel("x(n)");
ax = gca(); ax.data_bounds = [0 -3.5; 5*N 3.5]; xgrid(color("grey"));

subplot(3,1,3);
plot2d3(n, xq, style=5); plot(n, xq, "r.");
title("Quantized signal  xq(n),  delta = 0.1,  truncation  (5 periods)");
xlabel("n"); ylabel("xq(n)");
ax = gca(); ax.data_bounds = [0 -3.5; 5*N 3.5]; xgrid(color("grey"));
