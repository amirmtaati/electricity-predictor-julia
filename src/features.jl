module Features
using Dates, DataFrames

export processDate, extractTimeFeatures, createLagFeatures, createTargetVariable

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

function createLagFeatures(df::DataFrame, col::Symbol)
    dfCopy = copy(df)
    dfCopy.prevHour = [missing; dfCopy[!, col][1:end-1]]
    dfCopy.prev24h = [fill(missing, 24); dfCopy[!, col][1:end-24]]
    return dfCopy
end

function createTargetVariable(df::DataFrame, col::Symbol)
    dfCopy = copy(df)
    dfCopy.target = [dfCopy[!, col][2:end]; missing]
    return dfCopy
end

end
