using Pkg
Pkg.add(["DataFrames", "CSV", "Dates", "Statistics", "Plots", "GLM"])

using DataFrames, CSV, Dates, Statistics, Plots, GLM

function loadPjmData(filepath::String)
    df = CSV.read(filepath, DataFrame)
    return df
end

function dataSummary(df::DataFrame)
    println("Shape of data: ", size(df))
    println("Column's names: ", names(df))
    println(first(df, 10))
    println(describe(df))
end

function processDate(df::DataFrame)
    format = dateformat"yyyy-mm-dd HH:MM:SS"
    return DateTime.(df.Datetime, format)
end

function extractTimeFeatures(df::DataFrame)
    dfCopy = copy(df)
    dfCopy.hour = hour.(dfCopy.Datetime)
    dfCopy.dayOfTheWeek = dayofweek.(dfCopy.Datetime)
    dfCopy.month = month.(dfCopy.Datetime)
    dfCopy.isWeekend = dfCopy.dayOfTheWeek .>= 6
    return dfCopy
end

function createLagFeatures(df::DataFrame, consumptionCol::Symbol)
    """Create lagged consumption features"""
    dfCopy = copy(df)
    dfCopy.prevHour = [missing; dfCopy[!, consumptionCol][1:end-1]]
    dfCopy.prev24h = [fill(missing, 24); dfCopy[!, consumptionCol][1:end-24]]
    return dfCopy
end

function createTargetVariable(df::DataFrame, consumptionCol::Symbol)
    """Create next-hour consumption target"""
    dfCopy = copy(df)
    dfCopy.target = [dfCopy[!, consumptionCol][2:end]; missing]
    return dfCopy
end

function splitTrainData(df::DataFrame, trainRatio::Float64=0.8)
    nTrain = Int(round(trainRatio * nrow(df)))
    return df[1:nTrain, :]
end

function splitTestData(df::DataFrame, trainRatio::Float64=0.8)
    nTrain = Int(round(trainRatio * nrow(df)))
    return df[(nTrain+1):end, :]
end

function plotTimeSeries(df::DataFrame, dateCol::Symbol, valueCol::Symbol; title::String="Time Series")
    """Plot basic time series"""
    plot(df[!, dateCol], df[!, valueCol],
         title=title, xlabel="Date", ylabel="Consumption (MW)",
         linewidth=0.5, size=(800, 400))
end

function plotPredictions(actual::Vector, predicted::Vector, dates::Vector)
    """Plot actual vs predicted consumption"""
    plot(dates, [actual predicted],
         title="Actual vs Predicted Consumption",
         xlabel="Date", ylabel="Consumption (MW)",
         label=["Actual" "Predicted"], linewidth=2)
end

function trainModel(trainDf::DataFrame)
    return lm(@formula(target ~ hour + dayOfTheWeek + month + isWeekend + prevHour + prev24h), trainDf)
end

function calcMetrics(actual::Vector, predicted::Vector)
    MSE = mean((actual - predicted).^2)
    RSME = sqrt(MSE)
    MAE = mean(abs.(actual - predicted))
    R2 = 1 - sum((actual - predicted).^2) / sum((actual .- mean(actual)).^2)
    return MSE, RSME, MAE, R2
end

function mainAnalysis(filepath::String)
    df = loadPjmData(filepath)
    df.Datetime = processDate(df)
    df = extractTimeFeatures(df)
    df = createLagFeatures(df, :PJME_MW)
    df = createTargetVariable(df, :PJME_MW)
    dfClean = dropmissing(df)

    trainDf = splitTrainData(dfClean)
    testDf = splitTestData(dfClean)

    model = trainModel(trainDf)

    testPred = predict(model, testDf)
    metrics = calcMetrics(testDf.target, testPred)

    plotPredictions(testDf.target, testPred, testDf.Datetime)

    return model, metrics
end

model, performance = mainAnalysis("/home/amirmhmd/code/electricity-predictor-julia/data/PJME_hourly.csv")

