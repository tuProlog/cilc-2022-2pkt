/* Hyper paramenters */
hidden_layers([10]). hidden_layers([20, 10]).

/* Learning paramenters */
max_epochs(30). max_epochs(50). batch_size(32).
batch_size(16). learning_rate(0.01). loss(cross_entropy).

/* Workflow paramenters */
target_performance(0.90). test_percentage(0.2).

/* Generates all hyper & learning params combinations */
params(
  [hidden_layers(H)],
  [iterations(X), learning_rate(Y), batch_size(Z), loss(L)]
) :- hidden_layers(H), max_epochs(X), learning_rate(Y),
     batch_size(Z), loss(L).(*@\framebreak@*)
% Generates and trains all Predictors for the given Dataset
% and Schema, having at least a given performance.
model_selection(Dataset, Schema, Predictor) :-
     test_percentage(R), target_performance(Threshold),
     random_split(Dataset, R, TrainSet, TestSet),
     params(HyperParams, LearnParams),
     train_cv(TrainSet, HyperParams, LearnParams, Performance),
     Performance >= Threshold,
     multi_layer_perceptron(4, HyperParams, NN),
     train(NN, TrainSet, LearnParams, Predictor).

/* Example of training query: */
?- iris_dataset(D), iris_schema(S), (*@\label{line:training-query}@*)model_selection(D, S, P)
