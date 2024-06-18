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
}
transformed data {
  real x_r[0];
  int x_i[1] = { N };
}
parameters {
  real<lower=0> beta;
  real<lower=0> sigma;
  real<lower=0> gamma;
  real<lower=0> theta;  // Overdispersion parameter
}
transformed parameters {
  real y[n_days, 4];
  {
    real theta_seir[3];
    theta_seir[1] = beta;
    theta_seir[2] = sigma;
    theta_seir[3] = gamma;

    y = integrate_ode_rk45(seir, y0, t0, ts, theta_seir, x_r, x_i);
  }
}
model {
  // priors
  beta ~ normal(2, 1);
  sigma ~ normal(0.5, 0.5);
  gamma ~ normal(0.4, 0.5);
  theta ~ exponential(1);  // Prior for overdispersion
  
  // sampling distribution
  for (t in 1:n_days) {
    target += poisson_log_lpmf(cases[t] | log(y[t, 3])) - log(1 + theta * (cases[t] - y[t, 3])^2 / y[t, 3]);
  }
}
generated quantities {
  real R0 = beta / gamma;
  real incubation_period = 1 / sigma;
  real recovery_time = 1 / gamma;
  real pred_cases[n_days];
  for (t in 1:n_days) {
    pred_cases[t] = poisson_rng(y[t, 3]);
  }
}
