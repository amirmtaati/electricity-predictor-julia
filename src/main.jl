using Pkg
Pkg.add(["DataFrames", "CSV", "Dates", "Statistics", "Plots", "GLM"])

using DataFrames, CSV, Dates, Statistics, Plots, GLM

df = CSV.read("/home/amirmhmd/code/electricity-predictor-julia/data/PJME_hourly.csv", DataFrame)

println("Shape of data: ", size(df))
println("Column's names: ", names(df))
println(first(df, 10))
println(describe(df))

plot(df.Datetime, df.PJME_MW,
     title="Electricity Consumption",
     xlabel="Date",
     ylabel="Consumption (MW)",
     linewidth= 0.5,
     size=(800, 400))

