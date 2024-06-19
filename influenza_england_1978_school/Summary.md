# BayesianEpiDynamics- Influenza 1979 England School Summary
## Description:

In this section of the project, we initially employed the **SIR model** using the 1979 influenza dataset, also utilized in the [MC-Stan case study](https://mc-stan.org/users/documentation/case-studies/boarding_school_case_study.html#4_covid-19_transmission_in_switzerland). This dataset is pivotal in demonstrating the practical application of epidemic models in understanding disease dynamics.

Following the preliminary analysis with the SIR model, the focus shifted to the **SEIR model**. For a comprehensive understanding of what these models encapsulate, the SIR (Susceptible, Infected, Recovered) model tracks the number of susceptible, infected, and recovered individuals in a population without immunity. The SEIR (Susceptible, Exposed, Infected, Recovered) model extends this by adding an 'Exposed' class, accounting for individuals who have been infected but are not yet infectious. A detailed explanation of these epidemiological models can be found in this [resource](https://www.sciencedirect.com/topics/mathematics/sir-model).

The SEIR model provided a more nuanced representation of the disease transmission dynamics by incorporating the latency period before infected individuals become infectious. In Bayesian terms, this approach allowed for a more detailed prior-posterior analysis, where the model parameters were continuously updated with new data, enhancing the robustness of the model predictions.

### Model Evaluation and Comparisons

Expanding upon the basic SIR model setup, we employed various priors derived from more recent outbreaks to evaluate the model's sensitivity and fit. These priors were sourced from:
- [PLOS ONE 2022](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0269306)
- [PLOS ONE 2022](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0298932)
- [BMC Medicine 2009](https://bmcmedicine.biomedcentral.com/articles/10.1186/1741-7015-7-30)
- [BMC Public Health 2020](https://bmcpublichealth.biomedcentral.com/articles/10.1186/s12889-020-8243-6)

These comparisons revealed that the choice of priors can significantly influence the model's output, illustrating the profound impact of prior information in Bayesian inference.

Further investigations into the suitability of different likelihood assumptions—negative binomial, Poisson, and quasi-Poisson—were conducted to address potential overdispersion. Notably, both Poisson and quasi-Poisson models provided similar fits, with the Poisson model showing slightly better convergence, evidenced by well-overlapping Markov chains across iterations.

This phase of the project demonstrated the power of Bayesian models in epidemiology, particularly how flexible and insightful these models can be with the appropriate use of priors and model structure adjustments.
