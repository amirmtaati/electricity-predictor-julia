module Modeling
using DataFrames, GLM

export trainModel

function trainModel(trainDf::DataFrame)
    lm(@formula(target ~ hour + dayOfTheWeek + month + isWeekend + prevHour + prev24h), trainDf)
end

end
