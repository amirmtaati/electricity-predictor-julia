module MainApp

include("data_loading.jl")
include("features.jl")
include("modeling.jl")
include("evaluation.jl")
include("plotting.jl")

using .DataLoading
using .Features
using .Modeling
using .Evaluation
using .Plotting
using DataFrames, GLM, Statistics, Plots

function main()
    if length(ARGS) < 1
        println("Usage: julia src/Main.jl <path/to/data.csv>")
        return
    end

    filepath = ARGS[1]
    df = loadPjmData(filepath)
    df.Datetime = processDate(df)
    df = extractTimeFeatures(df)
    df = createLagFeatures(df, :PJME_MW)
    df = createTargetVariable(df, :PJME_MW)
    df = dropmissing(df)

    trainRatio = 0.8
    n = size(df, 1)
    trainDf = df[1:floor(Int, trainRatio * n), :]
    testDf = df[floor(Int, trainRatio * n)+1:end, :]

    model = trainModel(trainDf)
    pred = predict(model, testDf)
    mse, rmse, mae, r2 = calcMetrics(testDf.target, pred)

    println("Evaluation Metrics:")
    println("MSE: ", mse)
    println("RMSE: ", rmse)
    println("MAE: ", mae)
    println("R²: ", r2)

    plotPredictions(testDf.target, pred, testDf.Datetime)
end

main()

end  # module MainApp
