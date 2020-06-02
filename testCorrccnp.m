% alpha = [30 10 350 0 340 330 20 30];
% beta = [60 50 10 350 330 0 40 70];

alpha = [30 15 11 4 348 347 341 333 332 285];
beta = [25 5 349 358 340 347 345 331 329 287];

alpha = deg2rad(alpha);
beta = deg2rad(beta);

[r, pval, U, r0_alpha] = circ_corrccnp(alpha, beta)