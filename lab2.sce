// =====================================================================
//  Digital Signal Processing - Lab 2; PART 2: Exercise 2 -> 8 
//  Student: Tran Gia Han
//  Student ID: 2052464
// =====================================================================
clear; clc;

// ------------------------- HAM HO TRO --------------------------------
// Tin hieu roi rac huu han duoc luu bang 2 vector: gia tri x va chi so n.

// Ve tin hieu roi rac dang "que" (stem) kem title / xlabel / ylabel
function stemplot(n, x, ttl, ylbl)
    plot2d3(n, x, style=2);
    plot(n, x, "b.");
    title(ttl); xlabel("n"); ylabel(ylbl);
    ax = gca();
    ax.data_bounds = [min(n)-1, min([0 x])-1; max(n)+1, max([0 x])+1];
    xgrid(color("grey"));
endfunction

// Dua x (xac dinh tren n) ve truc chi so chung nn, cho khong co mau thi = 0
function y = extend(x, n, nn)
    y = zeros(nn);
    y(n - nn(1) + 1) = x;
endfunction

// Dao (folding): y(n) = x(-n)
function [y, ny] = sigfold(x, n)
    y  = x($:-1:1);
    ny = -n($:-1:1);
endfunction

// Dich: y(n) = x(n - k).  k > 0: tre (delay),  k < 0: som (advance)
function [y, ny] = sigshift(x, n, k)
    y  = x;
    ny = n + k;
endfunction

// In tin hieu ra console: hang chi so n va hang gia tri
function showsig(name, x, n)
    mprintf("%s:\n", name);
    mprintf("   n     = %s\n", strcat(msprintf("%5g\n", n(:) + 0)'));   // "+ 0" de -0 hien thi la 0
    mprintf("   value = %s\n", strcat(msprintf("%5g\n", x(:) + 0)'));
endfunction

// ---------------------------------------------------------------------
//  Exercise 2 - bool2s(n >= 0)  ->  buoc don vi u(n)
// ---------------------------------------------------------------------
scf(2); clf(); fig = gcf(); fig.figure_name = "Lab 2 - Exercise 2";
n = -5:5;
msignal = bool2s(n >= 0);
plot2d3(n, msignal)
// (them cho de nhin: noi rong truc va dat nhan)
ax = gca(); ax.data_bounds = [-6 -0.5; 6 1.5];
title("Exercise 2: bool2s(n >= 0) = unit step u(n)"); xlabel("n"); ylabel("u(n)");
mprintf("\n===== Exercise 2 =====\n"); showsig("msignal = bool2s(n >= 0)", msignal, n);

// ---------------------------------------------------------------------
//  Exercise 3 - bool2s(n == 0)  ->  xung don vi delta(n)
// ---------------------------------------------------------------------
scf(3); clf(); fig = gcf(); fig.figure_name = "Lab 2 - Exercise 3";
n = -5:5;
msignal = bool2s(n == 0);
plot2d3(n, msignal)
ax = gca(); ax.data_bounds = [-6 -0.5; 6 1.5];
title("Exercise 3: bool2s(n == 0) = unit sample delta(n)"); xlabel("n"); ylabel("delta(n)");
mprintf("\n===== Exercise 3 =====\n"); showsig("msignal = bool2s(n == 0)", msignal, n);

// ---------------------------------------------------------------------
//  Exercise 4 - Doc don vi ur(n) = n voi n >= 0, = 0 voi n < 0
// ---------------------------------------------------------------------
scf(4); clf(); fig = gcf(); fig.figure_name = "Lab 2 - Exercise 4";
n  = -5:5;
ur = n .* bool2s(n >= 0);
stemplot(n, ur, "Exercise 4: unit ramp signal ur(n)", "ur(n)");
mprintf("\n===== Exercise 4 =====\n"); showsig("ur(n) = n .* bool2s(n >= 0)", ur, n);

// ---------------------------------------------------------------------
//  Exercise 5 - x(n) = {1, 3^, -2}: thanh phan chan xe(n), le xo(n)
// ---------------------------------------------------------------------
n = -1:1;                       // mui ten o gia tri 3  ->  n = 0
x = [1 3 -2];
[xf, nf] = sigfold(x, n);       // x(-n); o day nf trung n vi n doi xung
xe = (x + xf) / 2;              // xe(n) = [x(n) + x(-n)] / 2
xo = (x - xf) / 2;              // xo(n) = [x(n) - x(-n)] / 2

scf(5); clf(); fig = gcf(); fig.figure_name = "Lab 2 - Exercise 5"; fig.figure_size = [700 800];
subplot(3,1,1); stemplot(n, x,  "Exercise 5: original signal x(n)",  "x(n)");
subplot(3,1,2); stemplot(n, xe, "Even component xe(n) = [x(n) + x(-n)]/2", "xe(n)");
subplot(3,1,3); stemplot(n, xo, "Odd component xo(n) = [x(n) - x(-n)]/2",  "xo(n)");
mprintf("\n===== Exercise 5 =====\n");
showsig("x(n)", x, n); showsig("xe(n)", xe, n); showsig("xo(n)", xo, n);
showsig("Kiem tra xe(n) + xo(n) (phai bang x(n))", xe + xo, n);

// ---------------------------------------------------------------------
//  Exercise 6 - y(n) = x1(n) + x2(n)
//  x1(n) = {0^, 1, 3, -2}  ->  n = 0..3
//  x2(n) = {0, 1^, 2, 3}   ->  n = -1..2
// ---------------------------------------------------------------------
n1 = 0:3;   x1 = [0 1 3 -2];
n2 = -1:2;  x2 = [0 1 2 3];
n  = min([n1 n2]) : max([n1 n2]);       // truc chung n = -1..3
x1e = extend(x1, n1, n);
x2e = extend(x2, n2, n);
y   = x1e + x2e;

scf(6); clf(); fig = gcf(); fig.figure_name = "Lab 2 - Exercise 6"; fig.figure_size = [700 800];
subplot(3,1,1); stemplot(n, x1e, "Exercise 6: x1(n)", "x1(n)");
subplot(3,1,2); stemplot(n, x2e, "x2(n)", "x2(n)");
subplot(3,1,3); stemplot(n, y,   "y(n) = x1(n) + x2(n)", "y(n)");
mprintf("\n===== Exercise 6 =====\n");
showsig("x1(n)", x1e, n); showsig("x2(n)", x2e, n); showsig("y(n) = x1(n) + x2(n)", y, n);

// ---------------------------------------------------------------------
//  Exercise 7 - y(n) = x1(n) . x2(n)  (nhan tung mau)
// ---------------------------------------------------------------------
y = x1e .* x2e;

scf(7); clf(); fig = gcf(); fig.figure_name = "Lab 2 - Exercise 7"; fig.figure_size = [700 800];
subplot(3,1,1); stemplot(n, x1e, "Exercise 7: x1(n)", "x1(n)");
subplot(3,1,2); stemplot(n, x2e, "x2(n)", "x2(n)");
subplot(3,1,3); stemplot(n, y,   "y(n) = x1(n) . x2(n)", "y(n)");
mprintf("\n===== Exercise 7 =====\n");
showsig("x1(n)", x1e, n); showsig("x2(n)", x2e, n); showsig("y(n) = x1(n) .* x2(n)", y, n);

// ---------------------------------------------------------------------
//  Exercise 8 - x(n) = {1, -2, 3^, 6}  ->  n = -2..1
// ---------------------------------------------------------------------
n = -2:1;
x = [1 -2 3 6];
nn = -6:3;                               // truc chung de so sanh x(n) va yi(n)
xx = extend(x, n, nn);
mprintf("\n===== Exercise 8 =====\n"); showsig("x(n)", x, n);

// y1(n) = x(-n): dao tin hieu
[y1, m1] = sigfold(x, n);
scf(81); clf(); fig = gcf(); fig.figure_name = "Lab 2 - Exercise 8: y1(n) = x(-n)";
subplot(2,1,1); stemplot(nn, xx, "Exercise 8: original signal x(n)", "x(n)");
subplot(2,1,2); stemplot(nn, extend(y1, m1, nn), "y1(n) = x(-n)  (folding)", "y1(n)");
showsig("y1(n) = x(-n)", y1, m1);

// y2(n) = x(n + 3): dich som (sang trai) 3 mau  ->  k = -3
[y2, m2] = sigshift(x, n, -3);
scf(82); clf(); fig = gcf(); fig.figure_name = "Lab 2 - Exercise 8: y2(n) = x(n+3)";
subplot(2,1,1); stemplot(nn, xx, "Exercise 8: original signal x(n)", "x(n)");
subplot(2,1,2); stemplot(nn, extend(y2, m2, nn), "y2(n) = x(n + 3)  (advance by 3)", "y2(n)");
showsig("y2(n) = x(n + 3)", y2, m2);

// y3(n) = 2 x(-n - 2) = 2 x(-(n + 2)):
//   buoc 1: dao        f(n) = x(-n)
//   buoc 2: dich som 2 g(n) = f(n + 2) = x(-n - 2)
//   buoc 3: nhan 2     y3(n) = 2 g(n)
[f, mf]  = sigfold(x, n);
[g, m3]  = sigshift(f, mf, -2);
y3       = 2 * g;
scf(83); clf(); fig = gcf(); fig.figure_name = "Lab 2 - Exercise 8: y3(n) = 2x(-n-2)";
subplot(2,1,1); stemplot(nn, xx, "Exercise 8: original signal x(n)", "x(n)");
subplot(2,1,2); stemplot(nn, extend(y3, m3, nn), "y3(n) = 2 x(-n - 2)  (fold, advance by 2, scale by 2)", "y3(n)");
showsig("y3(n) = 2 x(-n - 2)", y3, m3);
