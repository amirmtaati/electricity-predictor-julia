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

function plotTimeSeries(df::DataFrame, dateCol::Symbol, valueCol::Symbol; title::String="Time Series")
    """Plot basic time series"""
    plot(df[!, dateCol], df[!, valueCol],
         title=title, xlabel="Date", ylabel="Consumption (MW)",
         linewidth=0.5, size=(800, 400))
end

function mainAnalysis(filepath::String)
    df = loadPjmData(filepath)
    df.Datetime = processDate(df)
    df = extractTimeFeatures(df)
    df = createLagFeatures(df, :PJME_MW)
    df = createTargetVariable(df, :PJME_MW)
    dfClean = dropmissing(df)
end

mainAnalysis("/home/amirmhmd/code/electricity-predictor-julia/data/PJME_hourly.csv")

