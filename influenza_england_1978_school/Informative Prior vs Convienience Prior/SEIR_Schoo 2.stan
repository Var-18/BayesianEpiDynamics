functions {
  real[] seir(real t, real[] y, real[] theta, 
              real[] x_r, int[] x_i) {

    real S = y[1];
    real E = y[2];
    real I = y[3];
    real R = y[4];
    real N = x_i[1];
    
    real beta = theta[1];
    real sigma = theta[2];
    real gamma = theta[3];
    
    real dS_dt = -beta * I * S / N;
    real dE_dt =  beta * I * S / N - sigma * E;
    real dI_dt =  sigma * E - gamma * I;
    real dR_dt =  gamma * I;
    
    return {dS_dt, dE_dt, dI_dt, dR_dt};
  }
}
data {
  int<lower=1> n_days;
  real y0[4];
  real t0;
  real ts[n_days];
  int N;
  int cases[n_days];
  int<lower=0, upper=1> use_new_priors; // Flag to switch priors
}
transformed data {
  real x_r[0];
  int x_i[1] = { N };
}
parameters {
  real<lower=0> beta;
  real<lower=0> sigma;
  real<lower=0> gamma;
  real<lower=0> phi_inv;
}
transformed parameters {
  real y[n_days, 4];
  real phi = 1. / phi_inv;
  {
    real theta[3];
    theta[1] = beta;
    theta[2] = sigma;
    theta[3] = gamma;

    y = integrate_ode_rk45(seir, y0, t0, ts, theta, x_r, x_i);
  }
}
model {
  // Priors based on the flag
  if (use_new_priors == 1) {
    // New priors
    beta ~ normal(1, 0.5);
    sigma ~ normal(1/3, 0.1);
    gamma ~ normal(0.2, 0.1);
    phi_inv ~ exponential(5);
  } else {
    // Previous priors
    beta ~ normal(2, 1);
    sigma ~ normal(0.5, 0.5); // Assuming similar prior for sigma in previous setup
    gamma ~ normal(0.4, 0.5);
    phi_inv ~ exponential(5);
  }
  
  // Sampling distribution
  cases ~ neg_binomial_2(col(to_matrix(y), 3), phi);
}
generated quantities {
  real R0 = beta / gamma;
  real incubation_period = 1 / sigma;
  real recovery_time = 1 / gamma;
  real pred_cases[n_days];
  pred_cases = neg_binomial_2_rng(col(to_matrix(y), 3), phi);
}
