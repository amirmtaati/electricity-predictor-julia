module Plotting
using Plots, DataFrames

export plotTimeSeries, plotPredictions

function plotTimeSeries(df::DataFrame, dateCol::Symbol, valueCol::Symbol; title::String="Time Series")
    plot(df[!, dateCol], df[!, valueCol],
         title=title, xlabel="Date", ylabel="Consumption (MW)",
         linewidth=0.5, size=(800, 400))
end

function plotPredictions(actual::Vector, predicted::Vector, dates::Vector)
    plot(dates, [actual predicted],
         title="Actual vs Predicted Consumption",
         xlabel="Date", ylabel="Consumption (MW)",
         label=["Actual" "Predicted"], linewidth=2)
end

end
