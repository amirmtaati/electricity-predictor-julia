module DataLoading
using CSV, DataFrames

export loadPjmData

function loadPjmData(filepath::String)
    df = CSV.read(filepath, DataFrame)
    return df
end

end
